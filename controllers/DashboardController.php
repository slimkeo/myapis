<?php
class DashboardController {
    private $conn;

    public function __construct($conn) {
        $this->conn = $conn;
    }

    public function index($member_id) {
        $data = [];

        $stmt = $this->conn->prepare("SELECT COUNT(*) AS total FROM claims WHERE member_id = ?");
        $stmt->bind_param("i", $member_id);
        $stmt->execute();
        $data['claims'] = (int)$stmt->get_result()->fetch_assoc()['total'];

        $stmt = $this->conn->prepare("SELECT amount FROM statements WHERE memberid = ? AND type = 'contribution' ORDER BY id DESC LIMIT 1");
        $stmt->bind_param("i", $member_id);
        $stmt->execute();
        $result = $stmt->get_result();
        $data['monthly_contribution'] = $result->num_rows > 0
            ? (float)$result->fetch_assoc()['amount']
            : 150.00;

        $stmt = $this->conn->prepare("SELECT COUNT(*) AS total FROM beneficiaries WHERE member_id = ?");
        $stmt->bind_param("i", $member_id);
        $stmt->execute();
        $data['beneficiaries'] = (int)$stmt->get_result()->fetch_assoc()['total'];

        // Policy Status (You can adjust logic)
        $data['policy_status'] = 'Active';
        $data['coverage_amount'] = 15000.00;

        json_response(true, $data);
    }
}