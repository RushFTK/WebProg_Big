/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package entitiy_beans;

import entitiy.Books;
import java.util.List;
import javax.ejb.Local;

/**
 *
 * @author RushFTK
 */
@Local
public interface BooksFacadeLocal {

    void create(Books books);

    void edit(Books books);

    void remove(Books books);

    Books find(Object id);

    List<Books> findAll();

    List<Books> findRange(int[] range);

    int count();
    
    List<Books> findBookByKey(Object book_key);
    
    List<Books> findBookByISBN(Object ISBN);
}
