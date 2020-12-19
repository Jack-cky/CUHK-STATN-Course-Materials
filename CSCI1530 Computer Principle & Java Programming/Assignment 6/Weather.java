/**
 * CSCI1530 Assignment 6 Weather
 * Aim: 1. build a practical web information system using Java;
 *      2. practise using String, file I/O and URL classes for web-data processing;
 *      3. practise interpreting and extracting information from textual/ HTML information source.
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
 * Date : 24/04/2019
 */
package weather;

// import usefull functions
import java.io.*;
import java.net.URL;
import java.util.Scanner;
import javax.swing.JOptionPane;

public class Weather {

    // surrender exception in order to silence all possible kinds of exception
    public static void main(String[] args) throws Exception {

        // create "webObj" to read URL from Hong Kong Observatory
        URL webObj = new URL("http://www.weather.gov.hk/textonly/v2/forecast/englishwx2.htm");

        // create "input" to get data access from "webObj"
        InputStream input = webObj.openStream();

        // create "scanner" to get data from "input"
        Scanner scanner = new Scanner(input);

        // create "messageInHTML" with null value for storing data in HTML format
        StringBuilder messageInHTML = new StringBuilder();

        // create "file" to identify a file location
        File file = new File("weather.txt");

        // create "output" to get destination to output data
        PrintStream output = new PrintStream(file);

        // read data until there are no more data
        while (scanner.hasNextLine()) {

            //read data line by line
            String str = scanner.nextLine();

            // identify if the line contains "<!--Current Weather-->"
            if (str.contains("<!--Current Weather-->")) {

                // append data in HTML format
                messageInHTML.append(str);

                // output data to file
                output.println(str);

                // read data util the line contains "<!--/Current Weather-->"
                while (!str.contains("<!--/Current Weather-->")) {

                    // read data line by line
                    str = scanner.nextLine();

                    // append data in HTML format
                    messageInHTML.append(str);

                    // append a linefeed in HTML format
                    messageInHTML.append("<br>");

                    // (for outputting to file) change the word "Celsius" into "Fahrenheit"
                    if (str.contains("Celsius"))
                        str = str.replace("Celsius", "Fahrenheit");

                    // (for outputting to file) change data in degree Celsius to Fahrenheit
                    if (str.contains("degrees")) {
                        // extract data of degree Celsius
                        String temperatureString = str.substring(str.indexOf("degrees") - 3, str.indexOf("degrees") - 1);

                        // convert data into numerical data
                        double tempInCelsius = Double.parseDouble(temperatureString);

                        // convert data from degree Celsius to Fahrenheit
                        double tempInFahrenheit = tempInCelsius * 9 / 5 + 32;

                        // convert data to Sting value
                        String tempFah = "" + tempInFahrenheit;

                        // replace the original data of degree Celsius to Fahrenheit
                        str = str.replace(temperatureString, tempFah);
                    }

                    // output data to file
                    output.println(str);
                }
            }
        }
        // release memory from output stream
        output.close();

        // display the weather report on a Message Dialog
        JOptionPane.showMessageDialog(null, "<html>" + messageInHTML + "</html>");
    }
}