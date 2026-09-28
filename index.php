<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

require_once 'config/condig.php';
require_once 'helpers/response.php';

$method = $_SERVER['REQUEST_METHOD'];

$path = trim(parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH) ?? '', '/');
$base = trim(str_replace('\\', '/', dirname($_SERVER['SCRIPT_NAME'] ?? '')), '/');
if ($base !== '' && $base !== '.' && str_starts_with($path, $base)) {
    $path = trim(substr($path, strlen($base)), '/');
}

$uri = array_values(array_filter(explode('/', $path)));

// Support /index.php/auth/send-otp style paths
if (($uri[0] ?? '') === 'index.php') {
    array_shift($uri);
}

$endpoint = $uri[0] ?? '';
$action   = $uri[1] ?? '';

if ($method === 'OPTIONS') exit(http_response_code(200));

switch ($endpoint) {
    case 'auth':
        if ($method !== 'POST') {
            json_response(false, null, 'Method not allowed', 405);
        }

        require_once 'controllers/AuthController.php';
        $ctrl = new AuthController($conn);

        if ($action === 'send-otp') {
            $ctrl->sendOtp();
        } elseif ($action === 'verify-otp') {
            $ctrl->verifyOtp();
        } else {
            json_response(false, null, 'Endpoint not found', 404);
        }
        break;

    default:
        if (!in_array($endpoint, ['dashboard', 'claims', 'beneficiaries', 'statements'], true)) {
            json_response(false, null, 'Endpoint not found', 404);
        }

        if ($method !== 'GET') {
            json_response(false, null, 'Method not allowed', 405);
        }

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
        }
}