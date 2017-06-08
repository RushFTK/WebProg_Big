<%@page contentType="text/html" 
        import="java.util.*" 
        import="java.sql.*" 
        import="extra.Session_attr" 
        pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <%
        // define session and the attribute session included.
        HttpSession cur_session = request.getSession();
        Session_attr attr;
        // get current sessions & include information        
        if (cur_session == null){attr = new Session_attr();}else{attr = new Session_attr(cur_session);}
        // get login errors
        String error_flags = (String)request.getAttribute("error");

    %>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>欢迎来到FTK的网上书店！</title>
        <link href="css/bootstrap.min.css" rel="stylesheet">
        <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
        <script src="js/jquery.min.js"></script>
        <!-- Include all compiled plugins (below), or include individual files as needed -->
        <script src="js/bootstrap.min.js"></script>
        <!--[if lt IE 9]>
            <script src="js/html5shiv.min.js"></script>
            <script src="js/respond.min.js"></script>
        <![endif]-->
    </head>
    <body>
        <!--泛用导航栏-->
        <nav class="navbar navbar-default" role="navigation">
            <div class="container-fluid"> 
                <div class="navbar-header">
                    <a class="navbar-brand active" href="CtrlServlet?destination=index">FTK's网上书店</a>
                </div>
                <div>
                    <!-- 以下内容向左对齐 -->
                    <ul class="nav navbar-nav navbar-left">
                        <!--快速搜索-->
                        <form class="navbar-form navbar-left" action="CtrlServlet?destination=directory" method="POST" role="search">
                            <div class="form-group">
                               <input type="text" name="key" class="form-control" placeholder="书名,作者,出版社...">
                            </div>
                            <button type="submit" class="btn btn-default">给我搜!</button>
                        </form>
                    </ul>
                    <!-- 以下内容向右对齐 -->
                    <ul class="nav navbar-nav navbar-right">
                        <%if (attr.logged_in){%>
                        <li><a href="CtrlServlet?destination=cart"><span class="glyphicon glyphicon-usd"></span> 购物车</a></li>
                        <p class="navbar-text">欢迎您，<%=attr.username%></p> 
                        <li><a href="CtrlServlet?action=logged_out"><span class="glyphicon glyphicon-log-out"></span> 注销</a></li><%}else{%>                         
                        <li><a href="CtrlServlet?destination=register"><span class="glyphicon glyphicon-user"></span> 注册</a></li>
                        <li><a href="CtrlServlet?destination=login"><span class="glyphicon glyphicon-log-in"></span> 登录</a></li>
                        <%}%>
                    </ul>
                </div>
            </div>
        </nav>
        <!--泛用导航栏：结束-->
        <div class="row">
            <div class="col-md-3"></div>
            <div class="col-md-6">
                <div class="panel panel-default">   	
                    <div class="panel-body">
            		<h3 class="text-center">用户登录</h3>
            		<br>
            		<form id="login_form" class="form-horizontal" role="form" action="CtrlServlet?action=log_in" method="Post">
                            <%if (error_flags == "nousrname"){%>
                            <div class="alert alert-danger">
   	 			<a href="#" class="close" data-dismiss="alert">&times;</a><strong>错误！</strong>您的用户名不能为空！
                            </div>
                            <%}%>
                            <%if (error_flags == "nopwd"){%>
                            <div class="alert alert-warning">
   	 			<a href="#" class="close" data-dismiss="alert"> &times;</a><strong>警告！</strong>您的密码不能为空！
                            </div>
                            <%}%>
                            <%if (error_flags == "wrusrname"){%>
                            <div class="alert alert-warning">
   	 			<a href="#" class="close" data-dismiss="alert"> &times;</a><strong>警告！</strong>您的用户名有误！
                            </div>
                            <%}%>
                            <%if (error_flags == "wrpwd"){%>
                            <div class="alert alert-warning">
   	 			<a href="#" class="close" data-dismiss="alert"> &times;</a><strong>警告！</strong>您的密码有误！
                            </div>
                            <%}%>
                            
                            <div class="form-group">
                                <label for="form-control" class="col-sm-3 control-label">用户名</label>
                                <div class="col-sm-9">
                                    <input type="text" class="form-control" name="login_username">
                                </div>
                            </div>
                            <br>
                            <div class="form-group">
                                <label for="login_password" class="col-sm-3 control-label">密码</label>
                                <div class="col-sm-9">
                                    <input type="password" class="form-control" name="login_password">
                                </div>
                            </div>
                            <br>
                                <center><button class="btn btn-primary" id="submit_data" style="width:20%" type="submit">提交</button></center>
                	</form>      			 
                    </div>
		</div>
            </div>
            <div class="col-md-3"></div>
        </div>
    </body>
</html>