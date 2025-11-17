<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: DELETE");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Methods, Authorization, X-Requested-With");

include_once "../config/database.php";

$database = new Database();
$conn = $database->getConnection();

// Check if ID is passed
if (!isset($_GET['id'])) {
    echo json_encode(["success" => false, "message" => "User ID not provided"]);
    exit;
}

$user_id = intval($_GET['id']);

// Delete query
$query = "DELETE FROM users WHERE id = :id";
$stmt = $conn->prepare($query);
$stmt->bindParam(":id", $user_id);

if ($stmt->execute()) {
    echo json_encode(["success" => true, "message" => "User deleted successfully"]);
} else {
    echo json_encode(["success" => false, "message" => "Failed to delete user"]);
}
?>