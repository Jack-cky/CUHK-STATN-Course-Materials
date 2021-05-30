package tool;

public class Shape {

    protected int type;
    protected String name;
    protected double centerX, centerY;
    protected double size;
    
    private final double sunGlassesSeparation = 0.7;

    /**
     * Constructor creating a new Shape object of a given type.
     *
     * @param newShapeType int; 1 means circle; 2 means square; 3 means cross; 4 means sun-glasses
     */
    public Shape(int newShapeType)
    {
        if (newShapeType < 0) {
            type = 0;
        } else {
            type = newShapeType;
        }

        switch (type) {
            case 1:
                name = type + " Circle";
                break;
            case 2:
                name = type + " Square";
                break;
            case 3:
                name = type + " Cross";
                break;
            case 4:
                name = type + " Sun-glasses";
                break;
            default:
                name = type + " Undefined";
        }
    }
    
    /* Get name of the Shape */
    public String getName()
    {
        return name;
    }
    
    /** 
     * Set geometry of the Shape
     * 
     * @param _centerX is X-coordinate in [0.0, 1.0) of the center of the Shape
     * @param _centerY is Y-coordinate in [0.0, 1.0) of the center of the Shape
     * @param _size is size in [0.0, 1.0] of the Shape
     */
    public void setGeometry(double _centerX, double _centerY, double _size)
    {
        centerX = _centerX;
        centerY = _centerY;
        size = _size;
    }
    
    /**
     * shapeObject.getArea() calculates and returns the theoretical area of
     * the shape object with the given geometry center(x, y) and size.
     *
     * @return theoretical area of the shape object
     */
    public double getArea() 
    {
        // non-OO treatment as an learning example
        double area;
        switch (type) {
            case 1:
                area = getCircleArea();
                break;
            case 2:
                area = getSquareArea();
                break;
            case 3:
                area = getCrossArea();
                break;
            case 4:
                area = getSunGlassesArea();
                break;
            default:
                area = 0;
        }
        return area;
    }
    
    protected double getCircleArea()
    {
        double radius = size;
        return Math.PI * radius * radius;
    }
    
    protected double getSquareArea()
    {
        double side = size * 2;
        return side * side;
    }

    protected double getCrossArea()
    {
        double side = size;
        double halfSide = size / 2;
        return 4 * (side * side - halfSide * halfSide);
    }

    protected double getSunGlassesArea()
    {
        double radius = size;
        double radiusSq = radius * radius;
        double distance = size * sunGlassesSeparation * 2;
        double distSq = distance * distance;
        double halfAngle = Math.acos(distSq / (2 * radius * distance));
        return 2 * getCircleArea() - 2 * (halfAngle * radiusSq - 0.5 * distance * radius * Math.sin(halfAngle));
    }

    /**
     * shapeObject.contains(x, y) tells if a given point (x, y) falls in a shape
     * object. Type of the shape object shall be determined during object
     * creation.
     *
     * @param x double in [0.0, 1.0)
     * @param y double in [0.0, 1.0)
     * @return boolean
     */
    public boolean contains(double x, double y)
    {
        // non-OO treatment as an learning example
        boolean isInShape;
        switch (type) {
            case 1:
                isInShape = formula_circle(x, y);
                break;
            case 2:
                isInShape = formula_square(x, y);
                break;
            case 3:
                isInShape = formula_cross(x, y);
                break;
            case 4:
                isInShape = formula_sunglasses(x, y);
                break;
            default:
                isInShape = false;
        }
        return isInShape;
    }

    protected boolean formula_circle(double x, double y)
    {
        double radius = size;
        return ((x - centerX) * (x - centerX) + (y - centerY) * (y - centerY) < radius * radius);
    }

    protected boolean formula_square(double x, double y)
    {
        double leftX  = centerX - size;
        double rightX = centerX + size;
        double leftY  = centerY - size;
        double rightY = centerY + size;
        return (leftX < x && x < rightX && leftY < y && y < rightY);
    }

    protected boolean formula_cross(double x, double y) 
    {
        double leftX  = centerX - size;
        double rightX = centerX + size;
        double leftY  = centerY - size;
        double rightY = centerY + size;

        double leftHalfX  = centerX - size / 2;
        double rightHalfX = centerX + size / 2;
        double leftHalfY  = centerY - size / 2;
        double rightHalfY = centerY + size / 2;

        return (leftHalfX < x && x < rightHalfX && leftY < y && y < rightY) ||
               (leftX < x && x < rightX && leftHalfY < y && y < rightHalfY);
    }

    protected boolean formula_sunglasses(double x, double y)
    {
        double leftCenterX = centerX - size * sunGlassesSeparation;
        double rightCenterX = centerX + size * sunGlassesSeparation;
        double radius = size;
        
        /* re-use this class to create two new Shape objects */
        Shape leftCircle = new Shape(1);
        leftCircle.setGeometry(leftCenterX, centerY, radius);

        Shape rightCircle = new Shape(1);
        rightCircle.setGeometry(rightCenterX, centerY, radius);

        return leftCircle.contains(x, y) || rightCircle.contains(x, y);
    }
}
