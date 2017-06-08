/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package stateful_beans;

import entitiy.Books;
import java.util.ArrayList;
import java.util.List;
import javax.ejb.Local;

/**
 *
 * @author RushFTK
 */
@Local
public interface cartbeansLocal {

    ArrayList getBuy_books_num();
    
    Books get_book_inf(String isbn);

    List<Books> gen_booklist();

    boolean set_book_buynum(int new_num, String target_isbn);

    boolean add_book_buynum(int add_num, String target_isbn);
    
}
