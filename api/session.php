<?php
header('Content-Type: application/json');
require_once __DIR__ . '/../config.php';

$resp = ['logged_in' => false];
if (isset($_SESSION['user_id'])) {
    $resp['logged_in'] = true;
    $resp['user'] = [
        'user_id' => $_SESSION['user_id'],
        'username' => $_SESSION['username'] ?? null,
        'first_name' => $_SESSION['first_name'] ?? null
    ];
}

// Include any flash message and then clear it
if (!empty($_SESSION['flash'])) {
    $resp['flash'] = $_SESSION['flash'];
    unset($_SESSION['flash']);
}

echo json_encode($resp);
exit;

?>