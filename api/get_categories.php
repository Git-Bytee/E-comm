<?php
// api/get_categories.php
header('Content-Type: application/json');
require_once '../config.php';

try {
    $query = "SELECT * FROM categories WHERE is_active = 1 ORDER BY category_name";
    $stmt = $conn->query($query);
    $categories = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    echo json_encode($categories);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        'error' => 'Failed to fetch categories',
        'message' => $e->getMessage()
    ]);
}
