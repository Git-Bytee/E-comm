<?php
header('Content-Type: application/json');
require_once '../config.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    try {
        $data = json_decode(file_get_contents('php://input'), true);
        
        if (empty($data['id'])) {
            throw new Exception('Product ID is required');
        }
        
        $productId = $data['id'];
        
        $query = "DELETE FROM products WHERE product_id = :id";
        $stmt = $conn->prepare($query);
        $stmt->bindValue(':id', $productId);
        
        if ($stmt->execute()) {
            echo json_encode([
                'success' => true,
                'message' => 'Product deleted successfully'
            ]);
        } else {
            throw new Exception('Failed to delete product');
        }
        
    } catch (Exception $e) {
        http_response_code(400);
        echo json_encode([
            'success' => false,
            'message' => $e->getMessage()
        ]);
    }
} else {
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Method not allowed']);
}
?>
