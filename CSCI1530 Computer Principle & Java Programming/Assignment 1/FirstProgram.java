package firstprogram;

/**
 * First Program in Java
 * Aim: Get acquainted with the JDK + NetBeans programming environment
 * Learn the structure and format of a Java program by example
 *
 * Remark: Type class names, variable names, method names, etc. AS IS
 *         You should type also ALL the comment lines (text in gray) AS IS too!
 *
 * I declare that the assignment here submitted is original
 * except for source material explicitly acknowledged,
 * and that the same or closely related material has not been
 * previously submitted for another course.
 * I also acknowledge that I am aware of University policy and
 * regulations on honesty in academic work, and of the disciplinary
 * guidelines and procedures applicable to breaches of such
 * policy and regulations, as contained in the website.
 *
 * University Guideline on Academic Honesty:
 *  http://www.cuhk.edu.hk/policy/academichonesty
 * Faculty of Engineering Guidelines to Academic Honesty:
 *  https://www.erg.cuhk.edu.hk/erg/AcademicHonesty
 *
 * Student Name : CHAN KING YEUNG
 * Student ID : 1155119394
 * Date : 30/01/2019
*/

public class FirstProgram {
    
    public void welcomeMessage() {
        // TODO: write your own statements to show your SID in Arabic numerals and in Morse Code
        System.out.println("My SID is 1155119394");
        System.out.println("My SID in Morse Code is .---- .---- ..... ..... .---- .---- ----. ...-- ----. ....-");
        System.out.println("My Last Name is");
        System.out.println(" _____ \t _   _ \t  ___  \t _   _ ");
        System.out.println("/  __ \\\t| | | |\t / _ \\\t| \\ | |");
        System.out.println("| /  \\/\t| |_| |\t/ /_\\ \\\t|  \\| |");
        System.out.println("| |    \t|  _  |\t|  _  |\t| . ` |");
        System.out.println("| \\__/\\\t| | | |\t| | | |\t| |\\  |");
        System.out.println(" \\____/\t\\_| |_/\t\\_| |_/\t\\_| \\_/");
        // TODO: write your own statements to display the first 5 letters of your Last Name
        //       in BIG capital letter font (ASCII Art)!
        // Note: altogether there are NINE output lines
}

 /**
 * Starting point of your Java program, the main() method of your class
 */
    
    public static void main(String[] args) {
        
        // declare an object variable
        FirstProgram myObject;
        
        // create a new object and assign it to a variable
        myObject = new FirstProgram();
        
        // send message to your object
        myObject.welcomeMessage();
 }
}