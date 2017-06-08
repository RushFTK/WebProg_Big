/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package extra;

import entitiy.Books;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpSession;

/**
 *
 * @author RushFTK
 */
public class Session_attr {
   public boolean logged_in;
   public String username;
   public String sessionid;
   public String referer;
   public List<Books> SearchResult;
   public int[] SearchNum;
   public List<Books> cart_bookinfo;
   public ArrayList cart_num;
   
   public Session_attr()
   {
       logged_in = false;
       username = null;
       sessionid = null;
       referer = null;
       SearchResult = null;
       SearchNum = null;
       cart_bookinfo = null;
       cart_num = null;
   }
   public Session_attr(HttpSession src)
   {
       logged_in = (src.getAttribute("logged_in") != null)?
                   (boolean)(src.getAttribute("logged_in")):
                    false;
       username = (src.getAttribute("username") != null)?
                   src.getAttribute("username").toString():
                   null;
       sessionid = (src.getAttribute("sessionid") != null)?
                   src.getAttribute("sessionid").toString():
                   null;
       referer = (src.getAttribute("referer") != null)?
                   src.getAttribute("referer").toString():
                   null;
       SearchResult = (src.getAttribute("SearchResult") != null)?
                   (List<Books>)src.getAttribute("SearchResult"):
                   null;
       SearchNum = (src.getAttribute("SearchNum") != null)?
                   (int [])src.getAttribute("SearchNum"):
                   null;
       cart_bookinfo = (src.getAttribute("cart_bookinfo") != null)?
                        (List<Books>)src.getAttribute("cart_bookinfo"):
                        null;
       cart_num = (src.getAttribute("cart_num") != null)?
                        (ArrayList)src.getAttribute("cart_num"):
                        null;
   }    
}
