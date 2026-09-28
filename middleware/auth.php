<?php
function getMemberId($conn) {
    $auth = $_SERVER['HTTP_AUTHORIZATION'] ?? '';
    if ($auth === '' && function_exists('getallheaders')) {
        foreach (getallheaders() as $name => $value) {
            if (strcasecmp($name, 'Authorization') === 0) {
                $auth = $value;
                break;
            }
        }
    }

    if (!preg_match('/^Bearer\s+(\S+)$/i', trim($auth), $matches)) {
        json_response(false, null, 'Unauthorized - Token required', 401);
    }

    $token = $matches[1];
    
    $stmt = $conn->prepare("SELECT member_id FROM auth_tokens WHERE token = ? AND expires_at > NOW() LIMIT 1");
    $stmt->bind_param("s", $token);
    $stmt->execute();
    $result = $stmt->get_result();
    
    if ($result->num_rows === 0) {
        json_response(false, null, 'Token expired or invalid', 401);
    }
    
    return (int)$result->fetch_assoc()['member_id'];
}