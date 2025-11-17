<?php
header('Content-Type: application/json');
require_once __DIR__ . '/../config.php';

$response = ['success' => false, 'message' => 'Invalid request'];

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Method not allowed']);
    exit;
}

// Read input
$username = trim($_POST['username'] ?? '');
$email = trim($_POST['email'] ?? '');
$password = $_POST['password'] ?? '';
$first_name = trim($_POST['first_name'] ?? '');
$last_name = trim($_POST['last_name'] ?? '');

// Basic validation
$errors = [];
if ($username === '') $errors[] = 'Username is required';
if ($email === '') $errors[] = 'Email is required';
if (!filter_var($email, FILTER_VALIDATE_EMAIL)) $errors[] = 'Invalid email';
if ($password === '') $errors[] = 'Password is required';
if ($first_name === '') $errors[] = 'First name is required';
if ($last_name === '') $errors[] = 'Last name is required';

// Strong password rules (same as server-side)
if ($password !== '') {
    $pwErrors = [];
    if (strlen($password) < 8) $pwErrors[] = 'at least 8 characters';
    if (!preg_match('/[a-z]/', $password)) $pwErrors[] = 'a lowercase letter';
    if (!preg_match('/[A-Z]/', $password)) $pwErrors[] = 'an uppercase letter';
    if (!preg_match('/[0-9]/', $password)) $pwErrors[] = 'a number';
    if (!preg_match('/[^a-zA-Z0-9]/', $password)) $pwErrors[] = 'a special character';
    if (!empty($pwErrors)) $errors[] = 'Password must contain ' . implode(', ', $pwErrors);
}

if (!empty($errors)) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => implode('; ', $errors)]);
    exit;
}

try {
    // Check uniqueness
    $stmt = $conn->prepare('SELECT COUNT(*) as cnt FROM users WHERE username = :username OR email = :email');
    $stmt->bindValue(':username', $username);
    $stmt->bindValue(':email', $email);
    $stmt->execute();
    $row = $stmt->fetch(PDO::FETCH_ASSOC);
    if ($row && $row['cnt'] > 0) {
        http_response_code(400);
        echo json_encode(['success' => false, 'message' => 'Username or email already exists']);
        exit;
    }

    // Insert
    $stmt = $conn->prepare('INSERT INTO users (username, email, password_hash, first_name, last_name) VALUES (:username, :email, :password_hash, :first_name, :last_name)');
    $stmt->bindValue(':username', $username);
    $stmt->bindValue(':email', $email);
    $stmt->bindValue(':password_hash', password_hash($password, PASSWORD_DEFAULT));
    $stmt->bindValue(':first_name', $first_name);
    $stmt->bindValue(':last_name', $last_name);
    $stmt->execute();

    // Auto-login the user
    $user_id = $conn->lastInsertId();
    $_SESSION['user_id'] = $user_id;
    $_SESSION['username'] = $username;
    $_SESSION['first_name'] = $first_name;

    echo json_encode(['success' => true, 'message' => 'Registered', 'user' => ['user_id' => $user_id, 'username' => $username, 'first_name' => $first_name]]);
    exit;
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => 'Server error']);
    exit;
}
?>