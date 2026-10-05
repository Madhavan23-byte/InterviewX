<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>InterviewX - Create Account</title>

    <style>

        * {
            box-sizing: border-box;
        }

        body {

            margin: 0;

            min-height: 100vh;

            font-family: Arial, sans-serif;

            background:
                linear-gradient(
                    135deg,
                    #0f172a,
                    #1e293b
                );

            display: flex;

            justify-content: center;

            align-items: center;

            color: #0f172a;
        }

        .register-container {

            width: 420px;

            max-width: 90%;

            background: white;

            padding: 40px;

            border-radius: 18px;

            box-shadow:
                0 20px 50px
                rgba(0, 0, 0, 0.25);
        }

        .logo {

            text-align: center;

            font-size: 32px;

            font-weight: bold;

            color: #0f172a;

            margin-bottom: 8px;
        }

        .subtitle {

            text-align: center;

            color: #64748b;

            font-size: 14px;

            margin-bottom: 30px;
        }

        .form-group {

            margin-bottom: 18px;
        }

        label {

            display: block;

            margin-bottom: 7px;

            font-weight: bold;

            font-size: 14px;
        }

        input {

            width: 100%;

            padding: 13px 14px;

            border:
                1px solid #cbd5e1;

            border-radius: 8px;

            font-size: 15px;

            outline: none;

            transition: 0.2s;
        }

        input:focus {

            border-color: #2563eb;

            box-shadow:
                0 0 0 3px
                rgba(37, 99, 235, 0.1);
        }

        .register-btn {

            width: 100%;

            padding: 14px;

            border: none;

            border-radius: 8px;

            background: #2563eb;

            color: white;

            font-size: 16px;

            font-weight: bold;

            cursor: pointer;

            margin-top: 8px;

            transition: 0.2s;
        }

        .register-btn:hover {

            background: #1d4ed8;

            transform: translateY(-1px);
        }

        .login-link {

            text-align: center;

            margin-top: 22px;

            font-size: 14px;

            color: #64748b;
        }

        .login-link a {

            color: #2563eb;

            text-decoration: none;

            font-weight: bold;
        }

        .login-link a:hover {

            text-decoration: underline;
        }

        .error-message {

            color: #dc2626;

            background: #fee2e2;

            border:
                1px solid #fecaca;

            padding: 10px;

            border-radius: 7px;

            margin-bottom: 15px;

            font-size: 14px;
        }

        .success-message {

            color: #166534;

            background: #dcfce7;

            border:
                1px solid #bbf7d0;

            padding: 10px;

            border-radius: 7px;

            margin-bottom: 15px;

            font-size: 14px;
        }

    </style>

</head>


<body>


    <div class="register-container">


        <!-- LOGO -->

        <div class="logo">

            InterviewX 🚀

        </div>


        <!-- SUBTITLE -->

        <div class="subtitle">

            Create your placement preparation account

        </div>


        <!-- SERVER-SIDE ERROR MESSAGE -->

        <%
            String error =
                (String) request.getAttribute("error");

            if (error != null) {
        %>

            <div class="error-message">

                <%= error %>

            </div>

        <%
            }
        %>


        <!-- SUCCESS MESSAGE -->

        <%
            String success =
                request.getParameter("registered");

            if ("true".equals(success)) {
        %>

            <div class="success-message">

                Account created successfully!
                Please login to continue.

            </div>

        <%
            }
        %>


        <!-- CLIENT-SIDE ERROR MESSAGE -->

        <div id="errorMessage"
             class="error-message"
             style="display: none;">

        </div>


        <!-- REGISTRATION FORM -->

        <form
            action="register"
            method="post"
            onsubmit="return validateForm();">


            <!-- FULL NAME -->

            <div class="form-group">

                <label for="fullName">

                    Full Name

                </label>

                <input
                    type="text"
                    id="fullName"
                    name="fullName"
                    placeholder="Enter your full name"
                    autocomplete="name"
                    required>

            </div>


            <!-- EMAIL -->

            <div class="form-group">

                <label for="email">

                    Email Address

                </label>

                <input
                    type="email"
                    id="email"
                    name="email"
                    placeholder="Enter your email"
                    autocomplete="email"
                    required>

            </div>


            <!-- PASSWORD -->

            <div class="form-group">

                <label for="password">

                    Password

                </label>

                <input
                    type="password"
                    id="password"
                    name="password"
                    placeholder="Minimum 8 characters"
                    autocomplete="new-password"
                    required>

            </div>


            <!-- CONFIRM PASSWORD -->

            <div class="form-group">

                <label for="confirmPassword">

                    Confirm Password

                </label>

                <input
                    type="password"
                    id="confirmPassword"
                    name="confirmPassword"
                    placeholder="Re-enter your password"
                    autocomplete="new-password"
                    required>

            </div>


            <!-- SUBMIT BUTTON -->

            <button
                type="submit"
                class="register-btn">

                Create Account

            </button>


        </form>


        <!-- LOGIN LINK -->

        <div class="login-link">

            Already have an account?

            <a href="login.jsp">

                Login

            </a>

        </div>


    </div>


    <!-- JAVASCRIPT VALIDATION -->

    <script>

        function validateForm() {

            const fullName =
                document.getElementById("fullName").value.trim();

            const email =
                document.getElementById("email").value.trim();

            const password =
                document.getElementById("password").value;

            const confirmPassword =
                document.getElementById("confirmPassword").value;

            const errorMessage =
                document.getElementById("errorMessage");


            /* Clear previous error */

            errorMessage.innerText = "";

            errorMessage.style.display = "none";


            /* Full name validation */

            if (fullName.length < 2) {

                errorMessage.innerText =
                    "Please enter your full name.";

                errorMessage.style.display =
                    "block";

                return false;
            }


            /* Email validation */

            const emailPattern =
                /^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$/;

            if (!emailPattern.test(email)) {

                errorMessage.innerText =
                    "Please enter a valid email address.";

                errorMessage.style.display =
                    "block";

                return false;
            }


            /* Password length */

            if (password.length < 8) {

                errorMessage.innerText =
                    "Password must contain at least 8 characters.";

                errorMessage.style.display =
                    "block";

                return false;
            }


            /* Confirm password */

            if (password !== confirmPassword) {

                errorMessage.innerText =
                    "Passwords do not match.";

                errorMessage.style.display =
                    "block";

                return false;
            }


            /* Everything is valid */

            return true;

        }

    </script>


</body>

</html>