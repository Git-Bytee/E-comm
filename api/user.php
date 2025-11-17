<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, DELETE");
header("Access-Control-Allow-Headers: Content-Type");

require_once __DIR__ . '/../config.php';

$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'GET') {
    $search = isset($_GET['search']) ? trim($_GET['search']) : "";
    $sql = "SELECT user_id, username, first_name, last_name, email, created_at
            FROM users
            WHERE username LIKE :search OR first_name LIKE :search OR last_name LIKE :search OR email LIKE :search
            ORDER BY created_at DESC";

    $stmt = $conn->prepare($sql);
    $stmt->bindValue(':search', "%{$search}%");
    $stmt->execute();
    $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

    $users = array_map(function($r) {
        $name = trim((string)($r['first_name'] ?? '') . ' ' . ($r['last_name'] ?? ''));
        if ($name === '') $name = $r['username'] ?? '';
        return [
            'user_id' => $r['user_id'],
            'username' => $r['username'],
            'name' => $name,
            'email' => $r['email'],
            'created_at' => $r['created_at']
        ];
    }, $rows);

    echo json_encode($users);

} elseif ($method === 'DELETE') {
    $data = json_decode(file_get_contents("php://input"), true);
    $id = $data['id'] ?? 0;

    if ($id) {
        $query = "DELETE FROM users WHERE user_id = :id";
        $stmt = $conn->prepare($query);
        $stmt->bindParam(":id", $id, PDO::PARAM_INT);
        if ($stmt->execute()) {
            echo json_encode(["message" => "User deleted successfully"]);
        } else {
            http_response_code(500);
            echo json_encode(["message" => "Failed to delete user"]);
        }
    } else {
        http_response_code(400);
        echo json_encode(["message" => "Invalid user ID"]);
    }
} else {
    http_response_code(405);
    echo json_encode(["message" => "Method not allowed"]);
}
?>