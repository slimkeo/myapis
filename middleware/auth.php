<?php
function getMemberId($conn) {
    $headers = getallheaders();
    $auth = $headers['Authorization'] ?? '';
    
    if (strpos($auth, 'Bearer ') !== 0) {
        json_response(false, null, 'Unauthorized - Token required', 401);
    }
    
    $token = substr($auth, 7);
    
    $stmt = $conn->prepare("SELECT member_id FROM auth_tokens WHERE token = ? AND expires_at > NOW() LIMIT 1");
    $stmt->bind_param("s", $token);
    $stmt->execute();
    $result = $stmt->get_result();
    
    if ($result->num_rows === 0) {
        json_response(false, null, 'Token expired or invalid', 401);
    }
    
    return $result->fetch_assoc()['member_id'];
}