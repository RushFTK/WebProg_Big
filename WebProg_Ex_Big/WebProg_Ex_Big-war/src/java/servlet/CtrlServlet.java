/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlet;

import entitiy.Accounts;
import entitiy.Books;
import entitiy_beans.AccountsFacadeLocal;
import entitiy_beans.BooksFacadeLocal;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.ejb.EJB;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import stateful_beans.cartbeansLocal;

/**
 *
 * @author RushFTK
 */
@WebServlet(name = "CtrlServlet", urlPatterns = {"/CtrlServlet"})
public class CtrlServlet extends HttpServlet {

    cartbeansLocal cartbeans;

    @EJB
    private BooksFacadeLocal booksFacade;

    @EJB
    private AccountsFacadeLocal accountsFacade;

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try
        {
            String page_lastview = request.getParameter("destination");     //获得你下一个想访问的页面
            String page_action = request.getParameter("action");            //在跳转前处理的行为
            identity_verification(request,response);
            if (page_action != null)
            {
                switch(page_action)
                {
                    case "logged_out"   :action_loggedout(request,response);    break;  
                    case "log_in"       :action_login(request,response);        break;
                    case "buy"          :action_buy(request,response);          break;
                    case "editcart"     :action_editcart(request,response);          break;
                    default             :;     //默认什么都不做
                }
            }
        
            //处理跳转到指定页面，或跳转到指定页面时需要夹带信息的事宜
            if(page_lastview != null)
            {
                switch(page_lastview)
                {
                    case "login":       menthod_login(request,response);        break;
                    case "register":    menthod_register(request,response);     break;
                    case "search" :     menthod_search(request,response);       break;
                    case "directory":   menthod_directory(request,response);    break;
                    case "cart":        menthod_cart(request,response);         break;
                    case "index":       menthod_index(request,response);        break;
                    case "order":       menthod_order(request,response);        break;
                    default:            menthod_back(request,response);         break;
                }           
            }
            else {menthod_back(request,response);}
        }
        catch (Exception e)
        {
            response.getWriter().print(e);
        }        
    }
    
    //身份验证：每次运行servlet，并且不是注销操作的时候就进行一次比较
    void identity_verification(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException 
    {
        if (request.getSession().getAttribute("logged_in") != null)
        {
        if ((boolean)request.getSession().getAttribute("logged_in") == true)
        {
            //忽略登出
            if (request.getParameter("action") != null)
            {
                if (request.getParameter("action").equals("logged_out"))
                {
                    return;
                }
            }
            //id一致通过验证
            if (request.getSession().getAttribute("sessionid") != null)
            {
                if (request.getSession().getAttribute("sessionid").equals(request.getSession().getId()))
                {
                    return;
                }
            }
            //没有sessionid或id不一致，但是登入状态，那么验证失败。
            RequestDispatcher disp=request.getRequestDispatcher("verification_failed.jsp"); 
            disp.forward(request, response);
        }            
        }          
    }
    //注销的时候销毁会话会导致不知道转回的页面，因此需要预先存储跳转回去的页面
     void action_loggedout(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException 
    {
        String referer = request.getSession().getAttribute("referer").toString();   
        request.getSession().invalidate();                      //销毁session
        RequestDispatcher disp=request.getRequestDispatcher(referer);   //设置为跳转到预先的
        disp.forward(request, response);        
    }   
    
    
    //对于登录操作处理的主方法
    void action_login(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException 
    {
        String login_username = request.getParameter("login_username");
        String login_password = request.getParameter("login_password");
        
        if (login_username.equals("")) { request.setAttribute("error", "nousrname");}
        else if (login_password.equals("")) { request.setAttribute("error", "nopwd"); }
        else
        {
            List<Accounts> result = accountsFacade.findpassword(login_username);
            if (result.size() == 0)
            {
                request.setAttribute("error", "wrusrname");
            }
            else if (!result.get(0).getPassowrd().equals(login_password))
            {
                request.setAttribute("error", "wrpwd");
            }
            else
            {
                //仅在第一次登录，确认身份后lookup cartbenas(因为那时候才能使用购物车)
                cartbeans  = lookupcartbeansLocal();
                request.getSession().setAttribute("logged_in", true);
                request.getSession().setAttribute("username", login_username);
                request.getSession().setAttribute("sessionid", request.getSession().getId());
                return;
            }     
        }
        RequestDispatcher disp=request.getRequestDispatcher("login.jsp"); 
        disp.forward(request, response);
    }    
    
    //对于在搜索栏购买的方法
    void action_buy(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException 
    {
        List<Books> Search_result = (List<Books>)request.getSession().getAttribute("SearchResult");
        String num_str;    
        int num;            //购买商品的数量
        int[] search_num = new int[Search_result.size()];
        //检查购买项是否合理(表单中的数字越界)
        for (int i = 0;i<Search_result.size();i++)
        {
            num_str = request.getParameter(Search_result.get(i).getIsbn()+"_num");
            if (num_str.equals(""))
            {
                request.setAttribute("error", "ISBN为"+Search_result.get(i).getIsbn()+"的书目未填写购买量");
                menthod_back(request,response);
                return;
            }
            num = Integer.parseInt(num_str);
            if (num<0)
            {
                request.setAttribute("error", "ISBN为"+Search_result.get(i).getIsbn()+"的书目填写的购买量非法(小于0)");
                menthod_back(request,response);
                return;                
            }
            //备份到查询结果中
            search_num[i] = num;
        }
        //所有数据均有效，将其存入到session中
        
        request.getSession().setAttribute("SearchNum",search_num); 
        
        //更新cart中的信息
        for (int i = 0;i<Search_result.size();i++)
        {
            if (search_num[i] > 0)
            {
                 cartbeans.add_book_buynum(search_num[i] , Search_result.get(i).getIsbn());
            }
        }   
        //获取购物车应当包含的信息，更新至会话beans中。
        request.getSession().setAttribute("cart_num", cartbeans.getBuy_books_num());
        request.getSession().setAttribute("cart_bookinfo", cartbeans.gen_booklist());
        request.setAttribute("information", "恭喜您，购买成功，您可以<a href=\"CtrlServlet?destination=directory\">返回搜索结果</a>，或修改购物车的内容并选择提交。");
    }
    
    //上面的镜像方法
    void action_editcart(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException 
    {
        List<Books> Cart_book = (List<Books>)request.getSession().getAttribute("cart_bookinfo");
        String num_str;    
        int num;            //购买商品的数量
        int[] fix_num = new int[Cart_book.size()];
        //检查购买项是否合理(表单中的数字越界)
        for (int i = 0;i<Cart_book.size();i++)
        {
            num_str = request.getParameter(Cart_book.get(i).getIsbn()+"_newnum");
            if (num_str.equals(""))
            {
                request.setAttribute("error", "ISBN为"+Cart_book.get(i).getIsbn()+"的书目未填写购买量");
                menthod_back(request,response);
                return;
            }
            num = Integer.parseInt(num_str);
            if (num<0)
            {
                request.setAttribute("error", "ISBN为"+Cart_book.get(i).getIsbn()+"的书目填写的修改量非法(小于0)");
                menthod_back(request,response);
                return;                
            }
            //备份到修改结果中
            fix_num[i] = num;
        }
        
        //更新cart中的信息
        for (int i = 0;i<Cart_book.size();i++)
        {
            if (fix_num[i] >= 0)
            {
                //这里的方法变为set
                 cartbeans.set_book_buynum(fix_num[i] , Cart_book.get(i).getIsbn());
            }
        }   
        //获取购物车应当包含的信息，更新至会话beans中。
        request.getSession().setAttribute("cart_num", cartbeans.getBuy_books_num());
        request.getSession().setAttribute("cart_bookinfo", cartbeans.gen_booklist());
        request.setAttribute("information", "恭喜您，修改成功，您可以<a href=\"CtrlServlet?destination=directory\">返回最后一次的搜索结果</a>，或继续修改购物车的内容并选择提交。");
       
    }   
   
    //对于转向登录页面处理的主方法
    void menthod_login(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException 
    {       
            RequestDispatcher disp=request.getRequestDispatcher("login.jsp");
            disp.forward(request, response);   
    }
    
    void menthod_order(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException 
    {       
        if(request.getParameter("address") != null)
        {
            if(!request.getParameter("address").equals(""))
            {
                RequestDispatcher disp=request.getRequestDispatcher("order.jsp");
                disp.forward(request, response);
                return;
            }
        }
        request.setAttribute("error", "如果想提交订单，必须写入地址");
        menthod_back(request,response);
    }
    
    //对于注册处理的主方法
    void menthod_register(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException 
    {       
            RequestDispatcher disp=request.getRequestDispatcher("register.jsp");
            disp.forward(request, response);   
    }
    
    //对于查询页面处理的主方法
    void menthod_search(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException 
    {       
            RequestDispatcher disp=request.getRequestDispatcher("search.jsp");
            disp.forward(request, response);   
    }
    
    //对于图书目录请求处理的主方法
    void menthod_directory(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException 
    {
        String SearchKey = request.getParameter("key");
        //有新的表单搜索内容，则更新搜索结果的存储，并且清空搜索表单填写数据
        if (SearchKey != null)
        {
            if (!SearchKey.equals(""))
            {
                List<Books> result = booksFacade.findBookByKey(SearchKey);
                request.getSession().setAttribute("SearchResult", result);
                request.getSession().setAttribute("SearchNum", null);
            }            
        }
        RequestDispatcher disp=request.getRequestDispatcher("directory.jsp");
        disp.forward(request, response);   
    }
    
    //对于购物车页面处理的主方法
    void menthod_cart(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException 
    {       
        //该页面属于未登录页面，本应不显示连接，如果意外进入，则自动跳转到登录页面
        Object logged_in = (boolean)request.getSession().getAttribute("logged_in");
        if (logged_in == null) { menthod_login(request,response);}                  //防止会话本身被清除
        else if ((boolean)logged_in == false){ menthod_login(request,response); }   //未登录也跳转回登录
        else    //正常的跳转
        {

            RequestDispatcher disp=request.getRequestDispatcher("cart.jsp");
            disp.forward(request, response);
        }
    }
    
    //首页的访问方法
    void menthod_index(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException 
    {       
            RequestDispatcher disp=request.getRequestDispatcher("index.jsp");
            disp.forward(request, response);   
    }
    //没有参数，或参数有误，自动返回之前访问的页面
    void menthod_back(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException 
    {       
            String Referer = request.getSession().getAttribute("referer").toString();  //获取会话中存的之前访问的地址
            RequestDispatcher disp=request.getRequestDispatcher(Referer);
            disp.forward(request, response);   
    }
    
    //测试用函数
    void print_string(HttpServletResponse response,String target)
         throws ServletException, IOException 
    {
        if (!target.equals(""))
        {
            response.getWriter().print(target);
        }
        else {response.getWriter().print("null");}
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

    private cartbeansLocal lookupcartbeansLocal() {
        try {
            Context c = new InitialContext();
            return (cartbeansLocal) c.lookup("java:global/WebProg_Ex_Big/WebProg_Ex_Big-ejb/cartbeans!stateful_beans.cartbeansLocal");
        } catch (NamingException ne) {
            Logger.getLogger(getClass().getName()).log(Level.SEVERE, "exception caught", ne);
            throw new RuntimeException(ne);
        }
    }

}
