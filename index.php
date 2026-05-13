<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

require_once 'config/db.php';
require_once 'helpers/response.php';

$method = $_SERVER['REQUEST_METHOD'];
$uri = array_values(array_filter(explode('/', trim(parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH), '/'))));

$endpoint = $uri[0] ?? '';
$action   = $uri[1] ?? '';

if ($method === 'OPTIONS') exit(http_response_code(200));

switch ($endpoint) {
    case 'auth':
        require_once 'controllers/AuthController.php';
        $ctrl = new AuthController($conn);
        
        if ($action === 'send-otp' && $method === 'POST') $ctrl->sendOtp();
        if ($action === 'verify-otp' && $method === 'POST') $ctrl->verifyOtp();
        break;

    default:
        // Protected routes
        require_once 'middleware/auth.php';
        $member_id = getMemberId($conn);
        
        if ($endpoint === 'dashboard') {
            require_once 'controllers/DashboardController.php';
            (new DashboardController($conn))->index($member_id);
        } elseif ($endpoint === 'claims') {
            require_once 'controllers/ClaimController.php';
            (new ClaimController($conn))->index($member_id);
        } elseif ($endpoint === 'beneficiaries') {
            require_once 'controllers/BeneficiaryController.php';
            (new BeneficiaryController($conn))->index($member_id);
        } elseif ($endpoint === 'statements') {
            require_once 'controllers/SubscriptionController.php';
            (new SubscriptionController($conn))->index($member_id);
        } else {
            json_response(false, null, 'Endpoint not found', 404);
        }
}