<%-- 
    Document   : index
    Created on : 2017-6-7, 10:45:39
    Author     : RushFTK
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <%
            RequestDispatcher disp=request.getRequestDispatcher("TestServlet");
            disp.forward(request, response);
        %>
        <h1>Hello World!</h1>
    </body>
</html>
