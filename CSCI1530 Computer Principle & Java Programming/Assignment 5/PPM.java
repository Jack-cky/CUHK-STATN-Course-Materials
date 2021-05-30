package photokiosk;

import java.awt.Color;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.PrintStream;
import java.util.Scanner;
import javax.swing.ImageIcon;
import javax.swing.JOptionPane;

/**
 * Portable Pixel Map (RGB Color image file in ASCII text)
 * Java application employs 2D array and file I/O
 * @author Michael FUNG
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
 *   http://www.cuhk.edu.hk/policy/academichonesty/
 *
 * Student Name : CHAN KING YEUNG
 * Student ID   : 1155119394
 * Class/Section: CSCI1530
 * Date         : 09/04/2019
 */
public class PPM {
    // instance fields
    private String imageName;
    private int width, height;
    private int maxValue;
    private Color[][] image;
    
    // Default constructor for creating an blank PPM image of 2 x 3
    // provided for reference, NEED NOT be modified
    public PPM()
    {
        imageName = "Blank";
        width = 2;
        height = 3;
        maxValue = 255;
        image = new Color[height][width];
        image[0][0] = new Color(0, 128, 255);

        int r = image[0][0].getRed();
        int g = image[0][0].getGreen();
        int b = image[0][0].getBlue();
        
        image[0][1] = new Color(r, g+127, b-128);
        image[1][0] = new Color(128, g, 128);
        image[1][1] = new Color(255, 0, 255);
        image[2][0] = new Color(255, 255, 255);
        image[2][1] = new Color(0, 0, 0);
    }
    
    // Constructor for creating an "purple" PPM image of w x h
    // All pixels shall carry Color(127, 0, 127) in RGB
    public PPM(String name, int w, int h)
    {
        // fill in code here

        // assign the name of "image"
        imageName = name;

        // assign the width of "image"
        width = w;

        // assign the height of "image"
        height = h;

        // assign the maximum possible value of RGB of pixel of "image"
        maxValue = 255;

        // initialize the "image" by PPM's width and height
        image = new Color[height][width];

        // assign RGB values of purple to "image" line by line
        for (int i = 0; i < height; i++)
            for (int j = 0; j < width; j++)
                image[i][j] = new Color(127, 0, 127);
    }
    
    // Constructor for reading a PPM image file
    public PPM(String filename)
    {
        // fill in code here

        // assign the name of "image"
        imageName = filename;

        // display for debugging purposes
        if(read(filename))
            System.out.println(imageName + " has no error");
        else
            System.out.println(imageName + " has error");
    }
    
    public int getWidth()
    {
        return width;
    }
    
    public int getHeight()
    {
        return height;
    }
    
    public Color[][] getImage()
    {
        return image;
    }
 
    // Show image on screen
    // given and NEED NOT be modified
    public void showImage()
    {
        if (getHeight() <= 0 || getWidth() <= 0 || image == null)
        {
            JOptionPane.showConfirmDialog(null, "Width x Height = " + getWidth() + "x" + getHeight(), imageName + " corrupted!", JOptionPane.CLOSED_OPTION, JOptionPane.ERROR_MESSAGE, null);
            return;
        }
        
        BufferedImage img = new BufferedImage(getWidth(), getHeight(), BufferedImage.TYPE_INT_RGB);
        
        for (int row = 0; row < getHeight(); row++)
            for (int col = 0; col < getWidth(); col++)
                img.setRGB(col, row, image[row][col].getRGB());
        
        JOptionPane.showConfirmDialog(null, "Width x Height = " + getWidth() + "x" + getHeight(), imageName, JOptionPane.CLOSED_OPTION, JOptionPane.INFORMATION_MESSAGE, new ImageIcon(img));
    }
    
    public PPM blend(PPM img2)
    {
        PPM result = new PPM("Blend", getWidth(), getHeight());

        // use image pixels from this object and img2 object
        // to compute new image pixels for result object

        // fill in code here

        // blend two images by calculating each RGB value with a blending ratio
        // formula used here is Q(i,j) = X * P1(i,j) + (1 - X) * P2(i,j), where P1 and P2 are two input images, X is the blending ratio
        for (int i = 0; i < height; i++)
            for (int j = 0; j < width; j++)
                result.image[i][j] = new Color((int) ((img2.image[i][j].getRed() + this.image[i][j].getRed()) * 0.5), (int) ((img2.image[i][j].getGreen() + this.image[i][j].getGreen()) * 0.5), (int) ((img2.image[i][j].getBlue() + this.image[i][j].getBlue()) * 0.5));

        return result;
    }
    
    public boolean read(String filename)
    {
        try {
            File f = new File(filename);
            Scanner reader = new Scanner(f);
            String header = reader.nextLine();

            boolean checkHeaderFailed = false;

            // fill in code here

            // check if the header of PPM is correct
            checkHeaderFailed = !"P3".equals(header);

            if (checkHeaderFailed)
                throw new Exception("Wrong PPM header!");

            // fill in code here

            // read the width of PPM
            width = reader.nextInt();

            // read the height of PPM
            height = reader.nextInt();

            // read the maximum possible value of RGB of pixel
            maxValue = reader.nextInt();

            // initialize the "image" by PPM's width and height
            image = new Color[height][width];

            // assign RGB values to "image" by reading PPM line by line
            for (int i = 0; i < height; i++)
                for (int j = 0; j < width; j++)
                    image[i][j] = new Color(reader.nextInt(), reader.nextInt(), reader.nextInt());
        }
        catch (Exception e)
        {
            System.err.println(e);
            image = null;
            width = -1;
            height = -1;
            return false;
        }
        return true;
    }
    
    public void write(String filename)
    {
        try {
            PrintStream ps = new PrintStream(filename);

            // fill in code here

            // write the header of PPM
            ps.println("P3");

            // write the width and height of the PPM
            ps.println(width + " " + height);

            // write the maximum possible value of RGB of pixel
            ps.println(maxValue);

            // write the RGB pixel value row by row
            for (int i = 0; i < height; i++) {
                for (int j = 0; j < width; j++)
                    ps.print(image[i][j].getRed() + " " + image[i][j].getGreen() + " " + image[i][j].getBlue() + " ");
                ps.println();
            }

            ps.close();
        }
        catch (Exception e)
        {
            System.err.println(e);
        }
    }
}