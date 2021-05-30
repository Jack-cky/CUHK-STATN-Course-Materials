package photokiosk;

/**
 * PhotoKiosk
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
public class PhotoKiosk {

    public static void main(String[] args) {
        
        /* given class and given main() method, NEED NOT be modified */
        
        String filename;
        
        PPM imgDefault;
        imgDefault = new PPM();
        imgDefault.showImage();
        
        PPM imgBlank;
        imgBlank = new PPM("Purple", 40, 30);
        imgBlank.showImage();

        filename = "WRONG_FILENAME.ppm";
        PPM imgFileCorrupted;
        imgFileCorrupted = new PPM(filename);
        imgFileCorrupted.showImage();

        filename = "rgb_30x25.ppm";
        PPM imgFileSmall;
        imgFileSmall = new PPM(filename);
        imgFileSmall.showImage();
        
        filename = "rgb_256.ppm";
        PPM imgFile1;
        imgFile1 = new PPM(filename);
        imgFile1.showImage();

        filename = "kitten_256.ppm";
        PPM imgFile2;
        imgFile2 = new PPM(filename);
        imgFile2.showImage();

        PPM result = imgFile1.blend(imgFile2);
        result.showImage();
        
        result.write("blend.ppm");
    }
}
