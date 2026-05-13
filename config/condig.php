<?php
$host = 'localhost';
$dbname = 'snatbur1_db';
$username = 'snatbur1_user';
$password = 'Snat2026!';

$conn = new mysqli($host, $username, $password, $dbname);

if ($conn->connect_error) {
    die(json_encode(['success' => false, 'message' => 'Database connection failed']));
}

$conn->set_charset("utf8mb4");