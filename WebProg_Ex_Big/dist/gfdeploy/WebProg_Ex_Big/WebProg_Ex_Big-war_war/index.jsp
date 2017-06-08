<%@page contentType="text/html" 
        import="java.util.*" 
        import="java.sql.*" 
        import="extra.Session_attr" 
        pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <%
        // current page's "referer" path content.
        String cur_page = "index.jsp";
        // define session and the attribute session included.
        HttpSession cur_session = request.getSession();
        Session_attr attr;
        // get current sessions & include information        
        if (cur_session == null){attr = new Session_attr();}else{attr = new Session_attr(cur_session);}
        
        // update referer path
        if (cur_session != null){cur_session.setAttribute("referer",cur_page);}
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
         <!-- 百度地图API -->
        <script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=71YpINzTtNAdfEF7oUoPf2fGxOGXmgsY"></script>
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
                    <a class="navbar-brand active" href="#">FTK's网上书店</a>
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
                <div class="row text-center">
                    <h3>欢迎来到FTK'sReadingTimes！<small>从搜索栏开始一项新的搜索吧！</small></h3>
                </div>

                <div class="row">
                <div class="col-md-6">
                <div class="row text-center">
                    <h4>关于我们</h4>
                </div>
                <blockquote>
                    <p>
                        朴实无华，奇货可居
                        <small>by <cite title="Source Title">贞德·沃夏便德</cite></small>
                    </p>
                </blockquote>
                <p style="line-height: 30px">　　本店历史悠久，生来不凡……作为一个生存周期长达518,400秒的商店，其底蕴相当不一般。常规的书目找不到，但是你总能在这里找到一些未曾公开，而又实用的书目……剩下的我懒得编了。</p><br>
                <p class="text-right"><small>Rush_FTK —2098年2月3日</small></p>
                </div>
                <div class="col-md-6">
                <div class="row text-center">
                    <h4>找到我们</h4>
                </div>
                <div class="row">
                    <div style="height:400px" id="baidumap"></div>
                </div>
                </div>
                </div>
            </div>
            
            <div class="col-md-2"></div>
        </div>
    </body>
    <script type="text/javascript">
	// 百度地图API功能
	var map = new BMap.Map("baidumap");
	var point = new BMap.Point(116.485441,39.884985);
	var point2 = new BMap.Point(116.485441,39.884629);
	var marker = new BMap.Marker(point);  // 创建标注
	var marker2 = new BMap.Marker(point2);  
	map.addOverlay(marker);              // 将标注添加到地图中
	map.addOverlay(marker2); 
	map.centerAndZoom(point, 20);
	var opts = {
	  width : 200,     // 信息窗口宽度
	  height: 100,     // 信息窗口高度
	  title : "FTK'sReadingTimes-旗舰店" , // 信息窗口标题
	  enableMessage:true,//设置允许信息窗发送短息
	  message:"电话:12345678"
	}
	var opts2 = {
	  width : 200,     // 信息窗口宽度
	  height: 100,     // 信息窗口高度
	  title : "FTK'sReadingTimes-青春分店" , // 信息窗口标题
	  enableMessage:true,//设置允许信息窗发送短息
	  message:"电话:87654321"
	}
	var infoWindow = new BMap.InfoWindow("电话:12345678", opts);  // 创建信息窗口对象
	var infoWindow2 = new BMap.InfoWindow("电话:87654321", opts2);  // 创建信息窗口对象 
	 
	marker.addEventListener("click", function(){          
		map.openInfoWindow(infoWindow,point); //开启信息窗口
	});
	marker2.addEventListener("click", function(){          
		map.openInfoWindow(infoWindow2,point2); //开启信息窗口
	});
    </script>
</html>
