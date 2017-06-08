/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package stateful_beans;

import entitiy.Books;
import entitiy_beans.BooksFacadeLocal;
import java.util.ArrayList;
import java.util.List;
import javax.ejb.EJB;
import javax.ejb.Stateful;

/**
 *
 * @author RushFTK
 */
@Stateful
public class cartbeans implements cartbeansLocal {

    @EJB
    private BooksFacadeLocal booksFacade;
    
    private ArrayList buy_books_num;
   
    public List<String> Buy_books_isbn;

    public cartbeans() 
    {
        buy_books_num = new ArrayList();
        Buy_books_isbn = new ArrayList<String>();
    }

    /**
     * Get the value of Buy_books_isbn
     *
     * @return the value of Buy_books_isbn
     */
    public List<String> getBuy_books_isbn() {
        return Buy_books_isbn;
    }

    /**
     * Set the value of Buy_books_isbn
     *
     * @param Buy_books_isbn new value of Buy_books_isbn
     */
    public void setBuy_books_isbn(List<String> Buy_books_isbn) {
        this.Buy_books_isbn = Buy_books_isbn;
    }
    
    /**
     * Get the value of buy_books_num
     *
     * @return the value of buy_books_num
     */
    @Override
    public ArrayList getBuy_books_num() {
        return  buy_books_num;
    }

    /**
     * Set the value of buy_books_num
     *
     * @param buy_books_num new value of buy_books_num
     */
    public void setBuy_books_num(ArrayList buy_books_num) {
        this.buy_books_num = buy_books_num;
    }
  
    
    // Add business logic below. (Right-click in editor and choose
    // "Insert Code > Add Business Method")

    //获取购物车中一本图书的信息
    @Override
    public Books get_book_inf(String isbn) {
        List<Books> result = booksFacade.findBookByISBN(isbn);
            if (result.size() > 0)  {return result.get(0);}
        return null;
    }

    //生成购物车中图书的全部信息
    @Override
    public List<Books> gen_booklist() {
        List<Books> result = new ArrayList<Books>();
        for (int i = 0;i<Buy_books_isbn.size();i++)
        {
            result.add(get_book_inf(Buy_books_isbn.get(i)));
        }
        return result;
    }

    //购物车使用，设置一本书购买的数量
    @Override
    public boolean set_book_buynum(int new_num, String target_isbn) 
    {
        int target_index = Buy_books_isbn.indexOf(target_isbn);
        //设置为0意味着将从购物车移除
        if (new_num == 0)
        {
            if (target_index == -1) return false;
            else
            {
                Buy_books_isbn.remove(target_index);
                buy_books_num.remove(target_index);
                return true;
            }
        }
        
        //遍历是否这本书存在在购物车，如果不存在，则添加一个新的记录
        if (Buy_books_isbn.indexOf(target_isbn) == -1)
        {
            Buy_books_isbn.add(target_isbn);
            buy_books_num.add(new_num);
            return true;
        }
        else
        {
            buy_books_num.set(target_index, new_num);
        }
        return true;
    }

    //加入购物车使用，添加一本书的数量
    @Override
    public boolean add_book_buynum(int add_num, String target_isbn) {
        if (add_num <= 0)    return false;
        else
        {
            int target_index = Buy_books_isbn.indexOf(target_isbn);
            //遍历是否这本书存在在购物车，如果不存在，则添加一个新的记录
            if (Buy_books_isbn.indexOf(target_isbn) == -1)
            {
                Buy_books_isbn.add(target_isbn);
                buy_books_num.add(add_num);
                return true;
            }
            else
            {
                 buy_books_num.set(target_index, Integer.parseInt(buy_books_num.get(target_index).toString()) + add_num); 
                 return true;
            }
        }
    }
        
}
