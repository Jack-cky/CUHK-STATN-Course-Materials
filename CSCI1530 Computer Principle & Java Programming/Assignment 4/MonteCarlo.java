/**
 * CSCI1530 Assignment 4 Monte Carlo Simulator
 * Aim: 1. Implementing a practical simulator using Monte Carlo method.
 *      2. Practising object-oriented programming.
 *      3. Generating random numbers.
 *      4. Creating and using simple GUI components.
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
 * Date : 22/03/2019
 */
package tool;

// import useful functions
import java.awt.Color;
import java.awt.Graphics;
import java.awt.image.BufferedImage;
import java.util.Random;
import javax.swing.ImageIcon;
import javax.swing.JOptionPane;

public class MonteCarlo {

    // declare global variables "dots", "hits", "imageWidth", and "imageHeight"
    // "dots" is the number random points in the experiments (default 100000 dots)
    // "hits" is the number of "dots" hit the object
    // "imageWidth" and "imageHeight" are the length of the experiments (default 200x200 pixels)
    static int dots = 100000, hits;
    static int imageWidth = 200, imageHeight = 200;
    /* the reason for global variables is to modify the experiments easily if needed */

    // main method: perform experiments
    public static void main(String[] args) {

        // perform an experiment of Circle
        experiment(1);

        // perform an experiment of Square
        experiment(2);

        // perform an experiment of Cross
        experiment(3);

        // perform an experiment of Sun-glasses
        experiment(4);
    }

    // experiment method: general flow of the experiment
    public static void experiment(int type) {

        // create an object
        Shape object = shapeType(type);

        // create an experiment area "image" to define the size and the colour of the experiment area
        BufferedImage image = new BufferedImage(imageWidth, imageHeight, BufferedImage.TYPE_INT_ARGB);

        // create a pen to draw dots in the experiment area
        Graphics pen = paint(image);

        // draw pixels in the experiment area
        drawing(pen, object);

        // display the result of the experiment
        result(image, object);
    }

    // shapeType method: create an object
    public static Shape shapeType(int type) {

        // create an object from Shape class
        Shape object = new Shape(type);

        // set the object at the middle of the experiment area and define the length of the object
        object.setGeometry(0.5, 0.5, 0.25);

        return object;
    }

    // paintPen method: create a pen to draw tests in the experiment area
    public static Graphics paint(BufferedImage image) {

        // create "pen" for drawing coloured pixels in the experiment area
        Graphics pen = image.createGraphics();

        // erase all the pixels in the experiment area
        pen.clearRect(0, 0, imageWidth, imageHeight);

        return pen;
    }

    // drawing method: draw pixels in the experiment area
    public static void drawing(Graphics pen, Shape object) {

        // create "random" to get pseudo random numbers
        Random random = new Random();

        // rest number of hits in the experiment
        hits = 0;

        // draw number of "dots" in the experiment area
        for (int i = 1; i <= dots; i++) {

            // create "xAxis" and "yAxis" correspond to the coordinate of a random point
            double xAxis = random.nextDouble(), yAxis = random.nextDouble();

            // determine if the random point hits the object
            if (object.contains(xAxis, yAxis)) {
                // modify the colour of "pen" to red
                pen.setColor(Color.RED);

                // count number of hits
                hits++;
            } else {
                // modify the colour of "pen" to green
                pen.setColor(Color.GREEN);
            }

            // draw a pixel in the experiment area
            pen.fillOval((int) (xAxis * imageWidth), (int) (yAxis * imageHeight), 2, 2);
        }
    }

    // result method: display the result of the experiment
    public static void result(BufferedImage image, Shape object) {

        // capture "icon" from "image"
        ImageIcon icon = new ImageIcon(image);

        // create "title" to describe the experiment
        String title = "Monte Carlo Experiment " + object.getName() + ": ";

        // create "result" to describe the number of hits and hit ratio
        String result = hits + " in " + dots + " = " + (double) hits / dots + " vs " + "[" + object.getArea() + "]";

        // output the statistics of the experiment
        System.out.println(title + result);

        // display the image with statistics of the experiment
        JOptionPane.showConfirmDialog(null, result, title, JOptionPane.CLOSED_OPTION, JOptionPane.INFORMATION_MESSAGE, icon);
    }
}