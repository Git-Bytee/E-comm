<?php
// api/get_brands.php
header('Content-Type: application/json');
require_once '../config.php';

try {
    $query = "SELECT * FROM brands WHERE is_active = 1 ORDER BY brand_name";
    $stmt = $conn->query($query);
    $brands = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    echo json_encode($brands);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        'error' => 'Failed to fetch brands',
        'message' => $e->getMessage()
    ]);
}