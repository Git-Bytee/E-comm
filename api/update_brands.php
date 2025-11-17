<?php
header('Content-Type: application/json');
require_once '../config.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    try {
        $brandId = $_GET['id'] ?? null;
        
        if (!$brandId) {
            throw new Exception('Brand ID is required');
        }
        
        $brand_name = $_POST['brand_name'] ?? '';
        $description = $_POST['description'] ?? '';
        $logo_url = $_POST['logo_url'] ?? '';
        $website_url = $_POST['website_url'] ?? '';
        $is_active = $_POST['is_active'] ?? 1;
        
        if (empty($brand_name)) {
            throw new Exception('Brand name is required');
        }
        
        $query = "UPDATE brands SET brand_name = :brand_name, description = :description, 
                  logo_url = :logo_url, website_url = :website_url, is_active = :is_active 
                  WHERE brand_id = :id";
        
        $stmt = $conn->prepare($query);
        $stmt->bindValue(':brand_name', $brand_name);
        $stmt->bindValue(':description', $description);
        $stmt->bindValue(':logo_url', $logo_url);
        $stmt->bindValue(':website_url', $website_url);
        $stmt->bindValue(':is_active', $is_active);
        $stmt->bindValue(':id', $brandId);
        
        if ($stmt->execute()) {
            echo json_encode([
                'success' => true,
                'message' => 'Brand updated successfully',
                'brand_id' => $brandId
            ]);
        } else {
            throw new Exception('Failed to update brand');
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
