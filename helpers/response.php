<?php
function json_response($success, $data = null, $message = '', $status_code = 200) {
    http_response_code($status_code);
    header('Content-Type: application/json');
    
    $response = [
        'success' => $success,
        'message' => $message
    ];
    
    if ($data !== null) $response['data'] = $data;
    
    echo json_encode($response, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT);
    exit;
}