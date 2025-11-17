<?php
session_start();
require_once 'config.php';

$username = $email = $password = $confirm_password = "";
$username_err = $email_err = $password_err = $confirm_password_err = "";

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Validate username
    $usernameInput = trim($_POST["username"] ?? '');
    if ($usernameInput === '') {
        $username_err = "Please enter a username.";
    } else {
        // check uniqueness
        $stmt = $conn->prepare("SELECT COUNT(*) as cnt FROM users WHERE username = :username");
        $stmt->bindValue(':username', $usernameInput, PDO::PARAM_STR);
        $stmt->execute();
        $row = $stmt->fetch(PDO::FETCH_ASSOC);
        if ($row && $row['cnt'] > 0) {
            $username_err = "This username is already taken.";
        } else {
            $username = $usernameInput;
        }
    }

    // Validate email
    $emailInput = trim($_POST["email"] ?? '');
    if ($emailInput === '') {
        $email_err = "Please enter an email.";
    } elseif (!filter_var($emailInput, FILTER_VALIDATE_EMAIL)) {
        $email_err = "Please enter a valid email address.";
    } else {
        // check uniqueness
        $stmt = $conn->prepare("SELECT COUNT(*) as cnt FROM users WHERE email = :email");
        $stmt->bindValue(':email', $emailInput, PDO::PARAM_STR);
        $stmt->execute();
        $row = $stmt->fetch(PDO::FETCH_ASSOC);
        if ($row && $row['cnt'] > 0) {
            $email_err = "An account with this email already exists.";
        } else {
            $email = $emailInput;
        }
    }

    // Validate password (strong rules)
    $passwordInput = trim($_POST["password"] ?? '');
    $confirmInput = trim($_POST["confirm_password"] ?? '');

    if ($passwordInput === '') {
        $password_err = "Please enter a password.";
    } else {
        $pw = $passwordInput;
        $errors = [];
        if (strlen($pw) < 8) {
            $errors[] = 'at least 8 characters';
        }
        if (!preg_match('/[a-z]/', $pw)) {
            $errors[] = 'a lowercase letter';
        }
        if (!preg_match('/[A-Z]/', $pw)) {
            $errors[] = 'an uppercase letter';
        }
        if (!preg_match('/[0-9]/', $pw)) {
            $errors[] = 'a number';
        }
        if (!preg_match('/[^a-zA-Z0-9]/', $pw)) {
            $errors[] = 'a special character';
        }

        if (!empty($errors)) {
            $password_err = 'Password must contain ' . implode(', ', $errors) . '.';
        } else {
            $password = $pw;
        }
    }

    // Validate confirm password
    if ($confirmInput === '') {
        $confirm_password_err = "Please confirm password.";
    } else {
        $confirm_password = $confirmInput;
        if (empty($password_err) && ($password !== $confirm_password)) {
            $confirm_password_err = "Password did not match.";
        }
    }

    // Check input errors before inserting in database
    if (empty($username_err) && empty($email_err) && empty($password_err) && empty($confirm_password_err)) {
        try {
            $sql = "INSERT INTO users (username, email, password_hash, first_name, last_name) VALUES (:username, :email, :password_hash, :first_name, :last_name)";
            $stmt = $conn->prepare($sql);
            $stmt->bindValue(':username', $username, PDO::PARAM_STR);
            $stmt->bindValue(':email', $email, PDO::PARAM_STR);
            $stmt->bindValue(':password_hash', password_hash($password, PASSWORD_DEFAULT), PDO::PARAM_STR);
            $stmt->bindValue(':first_name', trim($_POST["first_name"] ?? ''), PDO::PARAM_STR);
            $stmt->bindValue(':last_name', trim($_POST["last_name"] ?? ''), PDO::PARAM_STR);
            $stmt->execute();

            // Set a flash message and redirect to login page
            if (session_status() === PHP_SESSION_NONE) session_start();
            $_SESSION['flash'] = 'Registered successfully. Please login.';
            header("Location: login.php");
            exit;
        } catch (Exception $e) {
            echo "Something went wrong. Please try again later.";
        }
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Sign Up</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        <h2>Sign Up</h2>
                        <p>Please fill this form to create an account.</p>
                    </div>
                    <div class="card-body">
                        <form action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]); ?>" method="post">
                            <div class="form-group">
                                <label>Username</label>
                                <input type="text" name="username" class="form-control <?php echo (!empty($username_err)) ? 'is-invalid' : ''; ?>" value="<?php echo $username; ?>">
                                <span class="invalid-feedback"><?php echo $username_err; ?></span>
                            </div>    
                            <div class="form-group">
                                <label>Email</label>
                                <input type="email" name="email" class="form-control <?php echo (!empty($email_err)) ? 'is-invalid' : ''; ?>" value="<?php echo $email; ?>">
                                <span class="invalid-feedback"><?php echo $email_err; ?></span>
                            </div>
                            <div class="form-group">
                                <label>First Name</label>
                                <input type="text" name="first_name" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label>Last Name</label>
                                <input type="text" name="last_name" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label>Password</label>
                                <div class="input-group">
                                    <input id="password" type="password" name="password" class="form-control <?php echo (!empty($password_err)) ? 'is-invalid' : ''; ?>" value="<?php echo $password; ?>" required>
                                    <button class="btn btn-outline-secondary" type="button" id="togglePassword">Show</button>
                                </div>
                                <div class="mt-2">
                                    <div id="passwordStrength" class="progress" style="height:8px; display:none;">
                                        <div id="passwordStrengthBar" class="progress-bar" role="progressbar" style="width:0%"></div>
                                    </div>
                                    <small id="passwordHelp" class="form-text text-muted"></small>
                                </div>
                                <span class="invalid-feedback"><?php echo $password_err; ?></span>
                            </div>
                            <div class="form-group">
                                <label>Confirm Password</label>
                                <div class="input-group">
                                    <input id="confirm_password" type="password" name="confirm_password" class="form-control <?php echo (!empty($confirm_password_err)) ? 'is-invalid' : ''; ?>" value="<?php echo $confirm_password; ?>" required>
                                    <button class="btn btn-outline-secondary" type="button" id="toggleConfirmPassword">Show</button>
                                </div>
                                <span class="invalid-feedback"><?php echo $confirm_password_err; ?></span>
                            </div>
                            <div class="form-group mt-3">
                                <input type="submit" class="btn btn-warning" value="Submit">
                                <input type="reset" class="btn btn-secondary ml-2" value="Reset">
                            </div>
                            <p>Already have an account? <a href="login.php">Login here</a>.</p>
                        </form>
                    </div>
                </div>
            </div>
        </div>
                    </div>    

                <script>
                // Password strength and show/hide handlers
                function passwordScore(pw) {
                    let score = 0;
                    if (!pw) return score;
                    if (pw.length >= 8) score += 20;
                    if (/[a-z]/.test(pw)) score += 20;
                    if (/[A-Z]/.test(pw)) score += 20;
                    if (/[0-9]/.test(pw)) score += 20;
                    if (/[^a-zA-Z0-9]/.test(pw)) score += 20;
                    return score;
                }

                document.addEventListener('DOMContentLoaded', () => {
                    const pwd = document.getElementById('password');
                    const confirmPwd = document.getElementById('confirm_password');
                    const toggle = document.getElementById('togglePassword');
                    const toggleConfirm = document.getElementById('toggleConfirmPassword');
                    const strengthBar = document.getElementById('passwordStrengthBar');
                    const strengthWrap = document.getElementById('passwordStrength');
                    const help = document.getElementById('passwordHelp');

                    function updateStrength() {
                        const val = pwd.value || '';
                        if (!val) {
                            strengthWrap.style.display = 'none';
                            strengthBar.style.width = '0%';
                            help.textContent = '';
                            return;
                        }
                        strengthWrap.style.display = 'block';
                        const score = passwordScore(val);
                        strengthBar.style.width = score + '%';
                        strengthBar.className = 'progress-bar';
                        if (score < 40) strengthBar.classList.add('bg-danger');
                        else if (score < 80) strengthBar.classList.add('bg-warning');
                        else strengthBar.classList.add('bg-success');

                        const parts = [];
                        if (val.length < 8) parts.push('8+ chars');
                        if (!/[a-z]/.test(val)) parts.push('lowercase');
                        if (!/[A-Z]/.test(val)) parts.push('uppercase');
                        if (!/[0-9]/.test(val)) parts.push('number');
                        if (!/[^a-zA-Z0-9]/.test(val)) parts.push('special char');

                        help.textContent = parts.length ? 'Add: ' + parts.join(', ') : 'Strong password';
                    }

                    pwd.addEventListener('input', updateStrength);

                    toggle.addEventListener('click', () => {
                        if (pwd.type === 'password') { pwd.type = 'text'; toggle.textContent = 'Hide'; }
                        else { pwd.type = 'password'; toggle.textContent = 'Show'; }
                    });

                    toggleConfirm.addEventListener('click', () => {
                        if (confirmPwd.type === 'password') { confirmPwd.type = 'text'; toggleConfirm.textContent = 'Hide'; }
                        else { confirmPwd.type = 'password'; toggleConfirm.textContent = 'Show'; }
                    });

                    // Client-side final validation before submit
                    const form = document.querySelector('form');
                    form.addEventListener('submit', (e) => {
                        const val = pwd.value || '';
                        const conf = confirmPwd.value || '';
                        const score = passwordScore(val);
                        if (score < 80) {
                            e.preventDefault();
                            alert('Password is too weak. Please follow the password requirements.');
                            return false;
                        }
                        if (val !== conf) {
                            e.preventDefault();
                            alert('Passwords do not match');
                            return false;
                        }
                        return true;
                    });
                });
                </script>
                </body>
                </html>
