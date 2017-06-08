<%@page contentType="text/html" 
        import="java.util.*" 
        import="java.sql.*" 
        import="extra.Session_attr" 
        import="entitiy.Books"
        pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <%
        // current page's "referer" path content.
        String cur_page = "directory.jsp";
        // define session and the attribute session included.
        HttpSession cur_session = request.getSession();
        Session_attr attr;
        // get current sessions & include information        
        if (cur_session == null){attr = new Session_attr();}else{attr = new Session_attr(cur_session);}
        
        // update referer path
        if (cur_session != null){cur_session.setAttribute("referer",cur_page);}

        // if haven't have last search
        if (attr.SearchResult == null){attr.SearchResult = new ArrayList<Books>();}
        
        //if getting error
        String errormessage = (String)request.getAttribute("error");
    %>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>搜索结果</title>
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
                <%if (errormessage != null){%>
                    <div class="alert alert-danger">
   	 		<a class="close" data-dismiss="alert">&times;</a><strong>错误！</strong> <%=errormessage%>
                    </div>
                <%}%>
                <% if (attr.logged_in == false) { %>
                    <div class="alert alert-info">
                        <a class="close" data-dismiss="alert">&times;</a><strong>提示：</strong>如果您需要购买，请先<a href="CtrlServlet?destination=login">登录</a>
                    </div>                
                <%}%>
                <% if (attr.SearchResult.size() == 0) { %>
                <div class="row">
                <div class="col-md-8">
                <h3>对不起……小二无能，无法显示查询结果……可能是以下原因：</h3>
                <ul>
                    <li>您还没有进行过任何查询</li>
                    <br>
                    <li>您刚刚进行了注销，其会清空查询结果</li>
                    <br>
                    <li>您输入的查询单词有误</li>
                    <br>
                    <li>不好意思=_=小店不卖那种书</li>
                    <br>
                </ul>
                </div>
                <div class="col-md-4">
                    <img src="img/no_search_result.jpg" class="img-rounded">
                </div>
                </div>
                <%}else{int i = 0;
                %>
                <form action="CtrlServlet?action=buy&destination=cart" method="POST">      
                <table class="table table-striped table-hover text-center">
                    <caption>搜索结果</caption>
                        <thead>
                            <tr>
                                <th>ISBN</th>
                                <th>书名</th>
                                <th>作者</th>
                                <th>出版社</th>
                                <th>价格</th>
                                <th>购买数量</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% while (i<attr.SearchResult.size()){ 
                                Books target = attr.SearchResult.get(i);
                                String target_num = null;
                                if(attr.SearchNum!=null){target_num = String.valueOf(attr.SearchNum[i]);}
                            %>
                            <tr>
                                <td><%=target.getIsbn()%></td>
                                <td><%=target.getTitle()%></td>
                                <td><%=target.getAuthor()%></td>
                                <td><%=target.getPress()%></td>
                                <td><%=target.getPrice()%></td>
                                <td><input type="number" name="<%=target.getIsbn() + "_num"%>" 
                                           <% if (target_num != null ){%> value="<%=target_num%>"<%}%> 
                                           <% if (attr.logged_in == false) { %>disabled="disabled"<%}%></td>
                            </tr>
                            <% i++;}}%>
                        </tbody>
                </table>    
                <% if (attr.SearchResult.size() != 0) { %>
                <div class="row">
                    <div class="col-md-1"></div>
                    <div class="col-md-4"><button type="submit" class="btn btn-success" style="width:100%" <% if (attr.logged_in == false) { %>disabled="disabled"<%}%>>当然是选择购买他啦！</button></div>
                    <div class="col-md-1"></div>
                    <div class="col-md-1"></div>
                    <div class="col-md-4"><button type="reset" class="btn btn-danger" style="width:100%" <% if (attr.logged_in == false) { %>disabled="disabled"<%}%> >我再想想买多少...</button>     </div>
                    <div class="col-md-1"></div>             
                </div>            
                <%}%>
                </form>
            </div>
                 
</div>
            <div class="col-md-2"></div>
        </div>
    </body>
</html>

