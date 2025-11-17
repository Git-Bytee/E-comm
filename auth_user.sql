-- Auth schema and queries for user registration/login
-- Database: easycart_db (MySQL)

-- 1) Database
CREATE DATABASE IF NOT EXISTS easycart_db;
USE easycart_db;

-- 2) Users table (matches backend expectations)
CREATE TABLE IF NOT EXISTS users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone VARCHAR(15),
    date_of_birth DATE,
    gender ENUM('Male','Female','Other'),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Helpful indexes
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_username ON users(username);
CREATE INDEX IF NOT EXISTS idx_users_created_at ON users(created_at);

-- 3) Stored procedure for registration
-- Hash passwords in the application, pass the hash here
DELIMITER $$
CREATE PROCEDURE register_user (
  IN p_username VARCHAR(50),
  IN p_email VARCHAR(100),
  IN p_password_hash VARCHAR(255),
  IN p_first_name VARCHAR(50),
  IN p_last_name VARCHAR(50)
)
BEGIN
  DECLARE dup CONDITION FOR 1062; -- ER_DUP_ENTRY
  START TRANSACTION;
  BEGIN
    DECLARE EXIT HANDLER FOR dup
    BEGIN
      ROLLBACK;
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Username or email already exists';
    END;

    INSERT INTO users (username, email, password_hash, first_name, last_name)
    VALUES (TRIM(p_username), LOWER(TRIM(p_email)), p_password_hash, TRIM(p_first_name), TRIM(p_last_name));

    COMMIT;
  END;
END$$
DELIMITER ;

-- 4) Sample usage (example; replace values in app layer)
-- CALL register_user('janedoe', 'jane@example.com', '$2y$10$REPLACE_WITH_BCRYPT', 'Jane', 'Doe');

-- 5) Login lookup (password verification must be done in app layer)
-- SELECT * FROM users WHERE email = LOWER('jane@example.com') LIMIT 1;
-- SELECT * FROM users WHERE username = 'janedoe' LIMIT 1;


