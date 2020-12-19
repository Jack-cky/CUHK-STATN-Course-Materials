/**
 * CSCI1530 Assignment 2 JHealth
 * Aim: user interaction and simple calculations
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
package jhealth;

// import input functions
import java.util.Scanner;
import javax.swing.JOptionPane;

public class JHealth {

    public static void main(String[] args) {

        // create "scanner" to get user input
        Scanner scanner = new Scanner(System.in);

        // get user name
        System.out.print("Name: ");
        String name = scanner.nextLine();

        System.out.println("Choose an app below");
        System.out.println("1) HeartRate");
        System.out.println("2) BMI");

        // get user choice
        System.out.print("Choice: ");
        int choice = scanner.nextInt();

        System.out.println("Showing you an input dialog...");

        switch (choice) {
            // situation of calculating heart rate
            case 1:
                // create "askAge" pop-up dialog
                String askAge = JOptionPane.showInputDialog("Age");
                // create "age" and get user age
                int age = Integer.parseInt(askAge);

                // calculate and display user traning zone
                JOptionPane.showMessageDialog(null, "Target Heart Rate Training Zone for " + name + ": " + Math.round((220 - age) * 0.7) + " - " + Math.round((220 - age) * 0.8));
                
                break;
            // situation of calculating BMI
            case 2:
                // create "askWeight" pop-up dialog
                String askWeight = JOptionPane.showInputDialog("What is your weight in kilogram?");
                // create "weight" and get user weight
                double weight = Double.parseDouble(askWeight);
                
                // create "askHeight" pop-up dialog
                String askHeight = JOptionPane.showInputDialog("What is your height in meter?");
                // create "height" and get user height
                double height = Double.parseDouble(askHeight);

                // calculate bmi
                double bmi = weight / (height * height);

                // declare "diagnosis"
                String diagnosis;
                // assign user diagnosis
                if (bmi < 5)
                    diagnosis = "Erroneous";
                else if (bmi < 18.5)
                    diagnosis = "Low";
                else if (bmi < 23)
                    diagnosis = "Normal";
                else if (bmi < 27.5)
                    diagnosis = "Pre-obese";
                else
                    diagnosis = "Obese";

                // display user bmi and diagnosis
                JOptionPane.showMessageDialog(null, "Hi, " + name + ". Your BMI " + bmi + " is " + diagnosis + ".");
        }
    }
}