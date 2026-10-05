<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>InterviewX - Login</title>

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

        .login-container {

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

            margin-bottom: 20px;
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

        .login-btn {

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

        .login-btn:hover {

            background: #1d4ed8;

            transform: translateY(-1px);
        }

        .register-link {

            text-align: center;

            margin-top: 22px;

            font-size: 14px;

            color: #64748b;
        }

        .register-link a {

            color: #2563eb;

            text-decoration: none;

            font-weight: bold;
        }

        .register-link a:hover {

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


    <div class="login-container">


        <!-- LOGO -->

        <div class="logo">

            InterviewX 🚀

        </div>


        <!-- SUBTITLE -->

        <div class="subtitle">

            Login to continue your placement journey

        </div>


        <!-- REGISTRATION SUCCESS MESSAGE -->

        <%
            String registered =
                request.getParameter("registered");

            if ("true".equals(registered)) {
        %>

            <div class="success-message">

                Account created successfully!
                Please login to continue.

            </div>

        <%
            }
        %>


        <!-- LOGIN ERROR MESSAGE -->

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


        <!-- LOGIN FORM -->

        <form
            action="login"
            method="post">


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
                    placeholder="Enter your password"
                    autocomplete="current-password"
                    required>

            </div>


            <!-- LOGIN BUTTON -->

            <button
                type="submit"
                class="login-btn">

                Login

            </button>


        </form>


        <!-- REGISTER LINK -->

        <div class="register-link">

            Don't have an account?

            <a href="register.jsp">

                Create Account

            </a>

        </div>


    </div>


</body>

</html>