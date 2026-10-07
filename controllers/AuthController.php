<?php
class AuthController {
    private $conn;

    public function __construct($conn) {
        $this->conn = $conn;
    }

    public function sendOtp() {
        $input = json_decode(file_get_contents('php://input'), true);
        if (!is_array($input)) {
            json_response(false, null, 'Invalid JSON request body', 400);
        }

        $identifier = trim((string)($input['identifier'] ?? ''));

        if (empty($identifier)) {
            json_response(false, null, 'Identifier is required', 400);
        }

        // Normalize cell number
        $normalized = preg_replace('/\D/', '', $identifier);
        if (strlen($normalized) == 8 && substr($normalized, 0, 3) !== '268') {
            $normalized = '268' . $normalized;
        }

        $stmt = $this->conn->prepare("
            SELECT id, cellnumber FROM members 
            WHERE idnumber = ? OR cellnumber = ? OR cellnumber = ? 
            LIMIT 1
        ");
        $stmt->bind_param("sss", $identifier, $identifier, $normalized);
        $stmt->execute();
        $result = $stmt->get_result();

        if ($result->num_rows === 0) {
            json_response(false, null, 'Member not found', 404);
        }

        $member = $result->fetch_assoc();
        $otp = str_pad((string)random_int(0, 999999), 6, '0', STR_PAD_LEFT);

        // Clear previous unused OTPs
        $this->conn->query("DELETE FROM login_otps WHERE member_id = " . (int)$member['id'] . " AND used = 0");

        $expires_at = date('Y-m-d H:i:s', strtotime('+3 minutes'));

        $stmt = $this->conn->prepare("
            INSERT INTO login_otps (identifier, otp, member_id, cellnumber, expires_at, created_at) 
            VALUES (?, ?, ?, ?, ?, NOW())
        ");
        $stmt->bind_param("ssiss", $identifier, $otp, $member['id'], $member['cellnumber'], $expires_at);
        $stmt->execute();

        $this->sendSms($member['cellnumber'], $otp);

        json_response(true, null, 'OTP sent successfully. Valid for 3 minutes.');
    }

    public function verifyOtp() {
        $input = json_decode(file_get_contents('php://input'), true);
        if (!is_array($input)) {
            json_response(false, null, 'Invalid JSON request body', 400);
        }

        $identifier = trim((string)($input['identifier'] ?? ''));
        $otp = trim((string)($input['otp'] ?? ''));

        if (empty($identifier) || empty($otp)) {
            json_response(false, null, 'Identifier and OTP required', 400);
        }

        if (!preg_match('/^\d{6}$/', $otp)) {
            json_response(false, null, 'OTP must be 6 digits', 400);
        }

        $normalized = preg_replace('/\D/', '', $identifier);
        if (strlen($normalized) == 8) $normalized = '268' . $normalized;

        $stmt = $this->conn->prepare("
            SELECT * FROM login_otps 
            WHERE (identifier = ? OR identifier = ?) 
              AND otp = ? 
              AND used = 0 
              AND expires_at > NOW()
            LIMIT 1
        ");
        $stmt->bind_param("sss", $identifier, $normalized, $otp);
        $stmt->execute();
        $result = $stmt->get_result();

        if ($result->num_rows === 0) {
            json_response(false, null, 'Invalid or expired OTP', 401);
        }

        $record = $result->fetch_assoc();
        $member_id = $record['member_id'];

        // Mark OTP as used
        $stmt = $this->conn->prepare("UPDATE login_otps SET used = 1, used_at = NOW() WHERE id = ? AND used = 0");
        $stmt->bind_param("i", $record['id']);
        $stmt->execute();
        if ($stmt->affected_rows !== 1) {
            json_response(false, null, 'Invalid or expired OTP', 401);
        }

        // Keep the session duration consistent with the app's persisted login state.
        $token = bin2hex(random_bytes(32));
        $token_expires = date('Y-m-d H:i:s', strtotime('+30 days'));

        // Clear old tokens
        $this->conn->query("DELETE FROM auth_tokens WHERE member_id = " . (int)$member_id);

        $stmt = $this->conn->prepare("INSERT INTO auth_tokens (member_id, token, expires_at) VALUES (?, ?, ?)");
        $stmt->bind_param("iss", $member_id, $token, $token_expires);
        $stmt->execute();

        //get nominee
        $stmt = $this->conn->prepare("SELECT `id`, `member_id`, `fullname`, `user`, `createdate` FROM `nominee` WHERE `member_id`=".$member_id." ORDER BY `createdate` DESC LIMIT 1");
        $stmt->execute();
        $result = $stmt->get_result();
        $nominee = $result->fetch_assoc();

        // Get member data
        $stmt = $this->conn->prepare("SELECT id, surname, name, cellnumber, idnumber, passbook_no FROM members WHERE id = ?");
        $stmt->bind_param("i", $member_id);
        $stmt->execute();
        $member = $stmt->get_result()->fetch_assoc();

        json_response(true, [
            'token' => $token,
            'expires_in' => 2592000,
            'member' => $member,
            'nominee' => $nominee['fullname']
        ], 'Login successful');
    }

    private function sendSms($phone, $otp) {
        $message = "SNAT Burial Scheme Login OTP: $otp. Valid for 3 minutes only.";
        $encoded = urlencode($message);
        $api_key = "c25hdGJ1cmlhbEBzd2F6aS5uZXQtcmVhbHNtcw==";
        $url = "https://www.realsms.co.sz/urlSend?_apiKey={$api_key}&dest={$phone}&message={$encoded}";
        @file_get_contents($url);
    }
}