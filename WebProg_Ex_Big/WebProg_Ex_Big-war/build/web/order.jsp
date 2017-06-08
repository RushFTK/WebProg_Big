<%@page import="entitiy.Books"%>
<%@page contentType="text/html" 
        import="java.util.*" 
        import="java.sql.*" 
        import="extra.Session_attr" 
        pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <%
        // current page's "referer" path content.
        String cur_page = "order.jsp";
        // define session and the attribute session included.
        HttpSession cur_session = request.getSession();
        Session_attr attr;
        // get current sessions & include information        
        if (cur_session == null){attr = new Session_attr();}else{attr = new Session_attr(cur_session);}
        
        // update referer path
        if (cur_session != null){cur_session.setAttribute("referer",cur_page);}
        
        // if haven't have cart
        if (attr.cart_bookinfo == null){attr.cart_bookinfo = new ArrayList<Books>();}
        
        double sum = 0;
    %>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>购物车一览</title>
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
                        <li><a href="CtrlServlet?destination=cart"><span class="glyphicon glyphicon-usd"></span> 购物车</a></li>
                        <%if (attr.logged_in){%>
                        <p class="navbar-text">欢迎您，<strong><%=attr.username%></strong></p> 
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
            <div class="col-md-2"></div>
            <div class="col-md-8">
                 <%int i = 0;%>
                <form action="CtrlServlet?action=editcart" method="POST">   
                <table class="table table-striped table-hover text-center">
                    <caption>结账单</caption>
                        <thead>
                            <tr>
                                <th>ISBN</th>
                                <th>图书名</th>
                                <th>作者</th>
                                <th>出版社</th>
                                <th>价格</th>
                                <th>购买数量</th>
                                <th>总价格</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% while (i<attr.cart_bookinfo.size()){ 
                                Books target = attr.cart_bookinfo.get(i);
                                int target_num = Integer.parseInt(attr.cart_num.get(i).toString());
                            %>
                            <tr>
                                <td><%=target.getIsbn()%></td>
                                <td><%=target.getTitle()%></td>
                                <td><%=target.getAuthor()%></td>
                                <td><%=target.getPress()%></td>
                                <td><%=target.getPrice()%></td>
                                <td><%=target_num%></td>
                                <td><%=(double)target.getPrice()*target_num%></td>
                            </tr>
                      <%  sum += (double)target.getPrice()*target_num;
                          i++;}%>
                      </tbody>
                </table> 
                <table class="table table-striped table-hover text-center">      
                <caption>总结信息</caption>   
                <tbody>
                    <tr>
                        <td>地址：<%=request.getParameter("address")%></td>
                    </tr>
                    <tr>
                        <td>请支付：<%=sum%> 元，感谢您的惠顾！</td>
                    </tr>                    
                </tbody>
                </table> 

            </div>
            <div class="col-md-2"></div>
        </div>
    </body>
</html>
