<?php
// Simple database connection test
$conn = new mysqli('localhost', 'root', 'jisql', 'easycart_db');

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
} else {
    echo "✅ Successfully connected to database!";
    
    // Test query
    $result = $conn->query("SHOW TABLES");
    if ($result) {
        echo "<h3>Tables in easycart_db:</h3>";
        while($row = $result->fetch_array()) {
            echo $row[0] . "<br>";
        }
    } else {
        echo "<br>Error: " . $conn->error;
    }
    
    $conn->close();
}
?>