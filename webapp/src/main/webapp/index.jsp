<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Hey Guys!! Good Morning</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            color: #333;
            text-align: center;
            padding: 50px;
        }
        .container {
            background-color: #fff;
            margin: 0 auto;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            max-width: 600px;
        }
        h1 {
            color: #0056b3;
        }
        p {
            font-size: 1.1em;
        }
        .current-time {
            font-style: italic;
            color: #666;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Hello from JSP! 👋</h1>
        <p>This is a simple JavaServer Pages (JSP) example.</p>
        <p>JSP allows you to embed Java code within HTML to create dynamic web content.</p>

        <%-- JSP Scriptlet to display current date and time --%>
        <%
            java.util.Date now = new java.util.Date();
            String message = "The current time is: " + now.toString();
        %>
        <p class="current-time"><%= message %></p>

        <%-- JSP Expression to display a simple calculation --%>
        <p>2 + 3 = <%= 2 + 3 %></p>

        <%-- Including another JSP file (if it existed, e.g., footer.jsp) --%>
        <%-- Uncomment the line below to see how to include another file --%>
        <%-- <jsp:include page="footer.jsp" /> --%>
    </div>
</body>
</html>
