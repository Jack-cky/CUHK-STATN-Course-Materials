/**
 * CSCI1530 Assignment 3 Problem Solving
 * Aim: problem solving with Java using branching and repetition statements
 *
 * Declaration:
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
 * Date : 13/02/2019
 */
package problemsolver;

// import input function
import java.util.Scanner;

public class ProblemSolver {

    public static void main(String[] args) {

        // create "scanner" to get user input
        Scanner scanner = new Scanner(System.in);

        // create "choice" to get user decision of looping
        int choice;

        do {
            // create "checkHeads", "checkWings", and "checkLegs" for checking a match animals proporties
            boolean checkHeads, checkWings, checkLegs;

            // initialise "pigs", "ducks", "dragons" as 0 for determining cases 
            int pigs = 0, ducks = 0, dragons = 0;

            // output background information
            System.out.println("*** ProblemSolver ***");
            System.out.println("There are at most 20 animals.");
            System.out.println("A pig has 1 head, no wing, 4 legs.");
            System.out.println("A duck has 1 head, 2 wings, 2 legs.");
            System.out.println("A dragon has 3 heads, 2 wings, 4 legs.");

            // get heads
            System.out.print("How many heads? ");
            int heads = scanner.nextInt();

            // get wings
            System.out.print("How many wings? ");
            int wings = scanner.nextInt();

            // get legs
            System.out.print("How many legs? ");
            int legs = scanner.nextInt();

            // in cases of
            // 1) animal(s) exisit(s) in the party; and 
            // 2) no solution (animals in the party are more than 20 or user input unmatch with animal proporties)
            // list all possible matches of properties of animals
            for (int i = 0; i <= 20; i++)
                for (int j = 0; j <= 20 - i; j++)
                    for (int k = 0; k <= 20 - i - j; k++) {
                        // check if there is match with user input
                        checkHeads = (i * 1 + j * 1 + k * 3 == heads);
                        checkWings = (i * 0 + j * 2 + k * 2 == wings);
                        checkLegs = (i * 4 + j * 2 + k * 4 == legs);

                        // in a case that animal(s) exist(s) in the party
                        if (checkHeads && checkWings && checkLegs) {
                            pigs = i;
                            ducks = j;
                            dragons = k;

                            System.out.println("There are " + pigs + " pigs, " + ducks + " ducks, " + dragons + " dragons.");

                            // bar chart of pigs
                            System.out.print("Pigs\t:");
                            for (int x = 1; x <= pigs; x++)
                                System.out.print("*");

                            // bar chart of ducks
                            System.out.print("\nDucks\t:");
                            for (int x = 1; x <= ducks; x++)
                                System.out.print("*");

                            // bar chart of dragons
                            System.out.print("\nDragons\t:");
                            for (int x = 1; x <= dragons; x++)
                                System.out.print("*");

                            // bar chart reference
                            System.out.println("\nLegend\t:12345678901234567890");
                        }
                    }

            // in cases of no solution
            if (pigs == 0 && ducks == 0 && dragons == 0)
                System.out.println("No solution.");

            // get user decision of looping
            System.out.print("Try again (enter 1 for yes; other int to quit)? ");
            choice = scanner.nextInt();

        } while (choice == 1);
    }
}
