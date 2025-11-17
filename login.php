<?php
require_once 'config.php';

$login_err = '';

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $username = trim($_POST['username'] ?? '');
    $password = $_POST['password'] ?? '';

    if ($username === '' || $password === '') {
        $login_err = "Please enter username and password.";
    } else {
        try {
            $sql = "SELECT user_id, username, password_hash, first_name, last_name FROM users WHERE username = :username LIMIT 1";
            $stmt = $conn->prepare($sql);
            $stmt->bindValue(':username', $username, PDO::PARAM_STR);
            $stmt->execute();
            $user = $stmt->fetch(PDO::FETCH_ASSOC);

            if ($user && password_verify($password, $user['password_hash'])) {
                // login successful
                $_SESSION["loggedin"] = true;
                $_SESSION["user_id"] = $user['user_id'];
                $_SESSION["username"] = $user['username'];
                $_SESSION["first_name"] = $user['first_name'] ?? '';
                
                $_SESSION['flash'] = 'Logged in successfully';
                header("Location: index.php");
                exit;
            } else {
                $login_err = "Invalid username or password.";
            }
        } catch (Exception $e) {
            $login_err = "Server error. Please try again later.";
        }
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        <h2>Login</h2>
                    </div>
                    <div class="card-body">
                        <?php 
                        if(!empty($login_err)){
                            echo '<div class="alert alert-danger">' . $login_err . '</div>';
                        }        
                        ?>
                        <form action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]); ?>" method="post">
                            <div class="form-group">
                                <label>Username</label>
                                <input type="text" name="username" class="form-control" required>
                            </div>    
                            <div class="form-group">
                                <label>Password</label>
                                <div class="input-group">
                                    <input id="login_password" type="password" name="password" class="form-control" required>
                                    <button class="btn btn-outline-secondary" type="button" id="toggleLoginPassword">Show</button>
                                </div>
                            </div>
                            <div class="form-group mt-3">
                                <input type="submit" class="btn btn-warning" value="Login">
                            </div>
                            <p>Don't have an account? <a href="register.php">Sign up now</a>.</p>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>    
</body>
</html>
<script>
document.addEventListener('DOMContentLoaded', function(){
    const pwd = document.getElementById('login_password');
    const toggle = document.getElementById('toggleLoginPassword');
    if (toggle && pwd) {
        toggle.addEventListener('click', ()=>{
            if (pwd.type === 'password') { pwd.type = 'text'; toggle.textContent = 'Hide'; }
            else { pwd.type = 'password'; toggle.textContent = 'Show'; }
        });
    }
});
</script>
