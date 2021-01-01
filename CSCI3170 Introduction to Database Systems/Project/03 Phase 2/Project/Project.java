//package project;
import java.sql.*;
import java.io.*;
import java.util.Scanner;
import java.util.Arrays;
import java.text.SimpleDateFormat;

public class Project {
    
    public static String dbAddress = "jdbc:mysql://projgw.cse.cuhk.edu.hk:2633/group97";
    public static String dbUsername = "Group97";
    public static String dbPassword = "3170group97";
    
    public static Connection connect() {
        Connection connection = null;
        try {
            Class.forName("com.mysql.jdbc.Driver");
            connection = DriverManager.getConnection(dbAddress, dbUsername, dbPassword);
        } catch (ClassNotFoundException e) {
            System.out.println("[Error]: Java MySQL DB Driver not found!!");
            System.exit(0);
        } catch (SQLException e) {
            System.out.println(e);
        }
        return connection;
    }
    
    public static void Meun() {
        Scanner input = new Scanner(System.in);
        do{
            System.out.println("Welcome! Who are you?");
            System.out.println("1. An administrator");
            System.out.println("2. A passenger");
            System.out.println("3. A driver");
            System.out.println("4. A manager");
            System.out.println("5. None of the above");
            System.out.println("Please enter [1-4]");
            
            int option = input.nextInt();
            
            switch(option) {
                case 1:
                    Administrator();
                    break;
                case 2:
                    Passenger();
                    break;
                case 3:
                    Driver();
                    break;
                case 4:
                    Manager();
                    break;
                case 5:
                    return;
                default:
                    System.out.println("[ERROR] Invalid Input");
            }
        } while(true);
    }
    
    public static void Administrator() {
        Scanner input = new Scanner(System.in);
        do{
            System.out.println("Administrator, what would you like to do?");
            System.out.println("1. Create tables");
            System.out.println("2. Delete tables");
            System.out.println("3. Load data");
            System.out.println("4. Check data");
            System.out.println("5. Go back");
            System.out.println("Please enter [1-5]");
            
            int option = input.nextInt();
            
            switch(option) {
                case 1:
                    String driveSql = "create table if not exists driver_vehicle ("
                            + "did integer, "
                            + "vid char(6), "
                            + "name char(30), "
                            + "drivingYears integer, "
                            + "model char(30), "
                            + "seats integer, "
                            + "unique(vid), "
                            + "primary key(did)"
                            + ");";
                    
                    String passengerSql = "create table if not exists passenger ("
                            + "pid integer, "
                            + "name char(30), "
                            + "primary key(pid));";
                    
                    String makeSql = "create table if not exists make_request ("
                            + "rid integer, "
                            + "pid integer, "
                            + "drivingYears integer, "
                            + "model char(30) default null, "
                            + "passengers integer,"
                            + "startLocation char(20), "
                            + "endLocation char(20), "
                            + "taken boolean, "
                            + "primary key(rid), "
                            + "foreign key(pid) references passenger(pid) on update cascade on delete cascade);";
                    
                    String takeSql = "create table if not exists take_trip ("
                            + "tid integer, "
                            + "did integer, "
                            + "pid integer, "
                            + "startTime datetime, "
                            + "endTime datetime, "
                            + "startLocation char(20), "
                            + "endLocation char(20), "
                            + "fee integer, "
                            + "primary key(tid, pid), "
                            + "foreign key(did) references driver_vehicle(did) on update cascade on delete cascade);";
                    
                    String taxiSql = "create table if not exists taxi ("
                            + "name char(20) not null, "
                            + "xLocation integer, "
                            + "yLocation integer, "
                            + "primary key(name));";
                    
                    try {
                        System.out.print("Processing...");
                        Connection mysql = connect();
                        Statement sql = mysql.createStatement();
                        sql.executeUpdate(driveSql);
                        sql.executeUpdate(passengerSql);
                        sql.executeUpdate(makeSql);
                        sql.executeUpdate(takeSql);
                        sql.executeUpdate(taxiSql);
                        System.out.println("Done! Tables are created");
                    } catch(Exception e) {
                        System.out.println(e);
                    }
                    break;
                case 2:
                    String disableFK  = "set foreign_key_checks = 0;";
                    String dropDriver = "drop table if exists driver_vehicle";
                    String dropPassenger = "drop table if exists passenger";
                    String dropMake = "drop table if exists make_request";
                    String dropTake = "drop table if exists take_trip";
                    String dropTaxi = "drop table if exists taxi";
                    
                    String EnableFK = "set foreign_key_checks = 1";
                    try {
                        System.out.print("Processing...");
                        Connection mysql = connect();
                        Statement sql = mysql.createStatement();
                        sql.executeUpdate(disableFK);
                        sql.executeUpdate(dropDriver);
                        sql.executeUpdate(dropPassenger);
                        sql.executeUpdate(dropMake);
                        sql.executeUpdate(dropTake);
                        sql.executeUpdate(dropTaxi);
                        sql.executeUpdate(EnableFK);
                        System.out.print("Done! Tables are deleted!\n");
                    } catch(Exception e) {
                        System.out.print(e);
                    }
                    break;
                case 3:
                    String[][] driverInfo = new String [10000][4];
                    String[][] passengersInfo = new String [10000][2];
                    String[][] taxi_stopsInfo = new String [10000][3];
                    String[][] tripsInfo = new String [10000][8];
                    String[][] vehiclesInfo = new String [10000][3];
                    
                    System.out.println("Please enter the folder path");
                    Scanner fileInput = new Scanner(System.in);
                    String path = fileInput.nextLine();
                    
                    System.out.print("Processing...");
                    
                    try {
                        File file = new File(path + "/drivers.csv");
                        BufferedReader br = new BufferedReader(new FileReader(file)); 
                        String st;
                        int count = 0;
                        while ((st = br.readLine()) != null) {
                            driverInfo[count] = st.split(",");
                            count++;
                        }
                        br.close();
                    } catch(Exception e) {
                        System.out.print(e);
                    }
                    
                    try {
                        File file = new File(path + "/passengers.csv");
                        BufferedReader br = new BufferedReader(new FileReader(file)); 
                        String st;
                        int count = 0;
                        while ((st = br.readLine()) != null) {
                            passengersInfo[count] = st.split(",");
                            count++;
                        }
                        br.close();
                    } catch(Exception e) {
                        System.out.print(e);
                    }
                    
                    try {
                        File file = new File(path + "/taxi_stops.csv");
                        BufferedReader br = new BufferedReader(new FileReader(file)); 
                        String st;
                        int count = 0;
                        while ((st = br.readLine()) != null) {
                            taxi_stopsInfo[count] = st.split(",");
                            count++;
                        }
                        br.close();
                    } catch(Exception e) {
                        System.out.print(e);
                    }
                    
                    try {
                        File file = new File(path + "/trips.csv");
                        BufferedReader br = new BufferedReader(new FileReader(file)); 
                        String st;
                        int count = 0;
                        while ((st = br.readLine()) != null) {
                            tripsInfo[count] = st.split(",");
                            count++;
                        }
                        br.close();
                    } catch(Exception e) {
                        System.out.print(e);
                    }
                
                    try {
                        File file = new File(path + "/vehicles.csv");
                        BufferedReader br = new BufferedReader(new FileReader(file)); 
                        String st;
                        int count = 0;
                        while ((st = br.readLine()) != null) {
                            vehiclesInfo[count] = st.split(",");
                            count++;
                        }
                        br.close();
                    } catch(Exception e) {
                        System.out.print(e);
                    }
                    
                    String driverInsert = "insert into driver_vehicle values(?, ?, ?, ?, ?, ?)";
                    String passengerInsert = "insert into passenger values(?, ?)";
                    String takeInsert = "insert into take_trip values(?, ?, ?, ?, ?, ?, ?, ?)";
                    String taixInsert = "insert into taxi values(?, ?, ?)";
                    
                    try{
                        Connection mysql = connect();
                        Statement sql = mysql.createStatement();
                        PreparedStatement driverPS = mysql.prepareStatement(driverInsert);
                        PreparedStatement passengerPS = mysql.prepareStatement(passengerInsert);
                        PreparedStatement takePS = mysql.prepareStatement(takeInsert);
                        PreparedStatement taixPS = mysql.prepareStatement(taixInsert);
                        
                        for(int i = 0; driverInfo[i][0] != null; i++) {
                            driverPS.setInt(1, Integer.parseInt(driverInfo[i][0]));
                            if(driverInfo[i][2].equals(vehiclesInfo[i][0])) {
                                driverPS.setString(2, vehiclesInfo[i][0]);
                            } else {
                                System.out.println("VID on drivers.csv and vehicles.csv doesn't match on the same line");
                                continue;
                            }
                            driverPS.setString(3, driverInfo[i][1]);
                            driverPS.setInt(4, Integer.parseInt(driverInfo[i][3]));
                            driverPS.setString(5, vehiclesInfo[i][1]);
                            driverPS.setInt(6, Integer.parseInt(vehiclesInfo[i][2]));
                            driverPS.executeUpdate();
                        }
                        
                        for(int i = 0; passengersInfo[i][0] != null; i++) {
                            passengerPS.setInt(1, Integer.parseInt(passengersInfo[i][0]));
                            passengerPS.setString(2, passengersInfo[i][1]);
                            passengerPS.executeUpdate();
                        }
                        
                        for(int i = 0; tripsInfo[i][0] != null; i++) {
                            SimpleDateFormat ft = new SimpleDateFormat ("yyyy-MM-dd HH:mm:ss");
                            String start = tripsInfo[i][3];
                            String end   = tripsInfo[i][4];
                            long startSecond, endSecond;
                            Date startTime = new Date(ft.parse(start).getTime()); 
                            Date endTime  = new Date(ft.parse(end).getTime());
                            startSecond  = startTime.getTime();
                            endSecond    = endTime.getTime();
                            
                            takePS.setInt(1, Integer.parseInt(tripsInfo[i][0]));
                            takePS.setInt(2, Integer.parseInt(tripsInfo[i][1]));
                            takePS.setInt(3, Integer.parseInt(tripsInfo[i][2]));
                            takePS.setTimestamp(4, new Timestamp(startSecond));
                            takePS.setTimestamp(5, new Timestamp(endSecond));
                            takePS.setString(6, tripsInfo[i][5]);
                            takePS.setString(7, tripsInfo[i][6]);
                            takePS.setInt(8, Integer.parseInt(tripsInfo[i][7]));
                            takePS.executeUpdate();
                        }
                        
                        for(int i = 0; taxi_stopsInfo[i][0] != null; i++) {
                            taixPS.setString(1, taxi_stopsInfo[i][0]);
                            taixPS.setInt(2, Integer.parseInt(taxi_stopsInfo[i][1]));
                            taixPS.setInt(3, Integer.parseInt(taxi_stopsInfo[i][2]));
                            taixPS.executeUpdate();
                        }
                        System.out.println("Data is loaded!");
                    } catch(Exception e) {
                        System.out.println(e);
                    }
                    break;
                case 4:
                    String driverCheck = "select count(*) from driver_vehicle;";
                    String passengerCheck = "select count(*) from passenger;";
                    String makeCheck = "select count(*) from make_request;";
                    String takeCheck = "select count(*) from take_trip;";
                    String taxiCheck = "select count(*) from taxi;";
                                        
                    try {
                        Connection mysql = connect();
                        Statement sql = mysql.createStatement();
                        System.out.println("Number of records in each table:");
                        
                        ResultSet vechicleRS = sql.executeQuery(driverCheck);
                        vechicleRS.next();
                        System.out.println("Vehicle: " + vechicleRS.getString(1));
                        
                        ResultSet passengerRS = sql.executeQuery(passengerCheck);
                        passengerRS.next();
                        System.out.println("Passenger: " + passengerRS.getString(1));
                        
                        ResultSet driverRS = sql.executeQuery(driverCheck);
                        driverRS.next();
                        System.out.println("Driver: " + driverRS.getString(1));
                        
                        ResultSet takeRS = sql.executeQuery(takeCheck);
                        takeRS.next();
                        System.out.println("Trip: " + takeRS.getString(1));
                        
                        ResultSet makeRS = sql.executeQuery(makeCheck);
                        makeRS.next();
                        System.out.println("Request: " + makeRS.getString(1));
                        
                        ResultSet taxiRS = sql.executeQuery(taxiCheck);
                        taxiRS.next();
                        System.out.println("Taxi_Stop: " + taxiRS.getString(1));
                        
                    } catch(Exception e) {
                        System.out.println(e);
                    }
                    break;
                case 5:
                    return;
                default:
                    System.out.println("[ERROR] Invalid Input");
            }
        } while(true);
    }
    
    public static void Passenger() {
        Scanner input = new Scanner(System.in);
        do{
            System.out.println("Passenger, what would you like to do?");
            System.out.println("1. Request a ride");
            System.out.println("2. Check trip records");
            System.out.println("3. Go back");
            System.out.println("Please enter [1-3].");
            
            int option = Integer.parseInt(input.nextLine());
            
            switch(option) {
                case 1:
                    String MRinsert = "INSERT INTO make_request Values(?, ?, ?, ?, ?, ?, ?, ?);";
                    String checkMaxRid = "SELECT MAX(rid) FROM make_request;";
                    
                    System.out.println("Please enter your ID.");
                    int pid1 = Integer.parseInt(input.nextLine());
                    int validCount = 0;
                    try {
                        Connection mysql = connect();
                        Statement stmt = mysql.createStatement();
                        ResultSet rs = stmt.executeQuery("SELECT COUNT(*) As Number FROM passenger WHERE pid = " + pid1 + ";");
                        rs.next();
                        validCount = rs.getInt(1);
                    } catch(Exception e) {
                    }
                    while (validCount <= 0){
                        System.out.println("[ERROR] Passenger ID Not Found");
                        System.out.println("Please enter your ID.");
                        pid1 = Integer.parseInt(input.nextLine());
                        validCount = 0;
                        try {
                            Connection mysql = connect();
                            Statement stmt = mysql.createStatement();
                            ResultSet rs = stmt.executeQuery("SELECT COUNT(*) As Number FROM passenger WHERE pid = " + pid1 + ";");
                            rs.next();
                            validCount = rs.getInt(1);
                        } catch(Exception e) {
                        }
                    }
                    
                    
                    
                    System.out.println("Please enter the number of passengers.");
                    int passengerno = Integer.parseInt(input.nextLine());
                    /*int maxSeats = 0;
                    try {
                        Connection mysql = connect();
                        Statement stmt = mysql.createStatement();
                        ResultSet rs = stmt.executeQuery("SELECT MAX(seats) FROM driver_vehicle");
                        rs.next();
                        maxSeats = rs.getInt(1);
                    } catch(Exception e) {
                    }*/
                    while (passengerno < 0 || passengerno > 15){
                        System.out.println("[ERROR] Invalid number of passengers");
                        System.out.println("Please enter the number of passengers.");
                        passengerno = Integer.parseInt(input.nextLine());
                        /*maxSeats = 0;
                        try {
                            Connection mysql = connect();
                            Statement stmt = mysql.createStatement();
                            ResultSet rs = stmt.executeQuery("SELECT MAX(seats) FROM driver_vehicle");
                            rs.next();
                            maxSeats = rs.getInt(1);
                        } catch(Exception e) {
                        }*/
                    }
                    
                    System.out.println("Please enter the start location");
                    String startLocation2 = input.nextLine();
                    validCount = 0;
                    try {
                        Connection mysql = connect();
                        Statement stmt = mysql.createStatement();
                        ResultSet rs = stmt.executeQuery("SELECT COUNT(*) As Number FROM taxi WHERE name = \"" + startLocation2 + "\"");
                        rs.next();
                        validCount = rs.getInt(1);
                    } catch(Exception e) {
                    }
                    while (validCount <= 0){
                        System.out.println("[ERROR] Start Location Not Found");
                        System.out.println("Please enter the start location.");
                        startLocation2 = input.nextLine();
                        validCount = 0;
                        try {
                            Connection mysql = connect();
                            Statement stmt = mysql.createStatement();
                            ResultSet rs = stmt.executeQuery("SELECT COUNT(*) As Number FROM taxi WHERE name = \"" + startLocation2 + "\"");
                            rs.next();
                            validCount = rs.getInt(1);
                        } catch(Exception e) {
                        }
                    }
                    
                    
                    System.out.println("Please enter the destination");
                    String endLocation2 = input.nextLine();
                    while (endLocation2.equals(startLocation2)){
                        System.out.println("[ERROR] Destination and start location should be different.");
                        System.out.println("Please enter the destination.");
                        endLocation2 = input.nextLine();
                    }
                    validCount = 0;
                    try {
                        Connection mysql = connect();
                        Statement stmt = mysql.createStatement();
                        ResultSet rs = stmt.executeQuery("SELECT COUNT(*) As Number FROM taxi WHERE name = \"" + endLocation2 + "\"");
                        rs.next();
                        validCount = rs.getInt(1);
                    } catch(Exception e) {
                    }
                    while (validCount <= 0){
                        System.out.println("[ERROR] Destination Not Found");
                        System.out.println("Please enter the destination.");
                        endLocation2 = input.nextLine();
                        while (endLocation2.equals(startLocation2)){
                            System.out.println("[ERROR] Destination and start location should be different.");
                            System.out.println("Please enter the destination.");
                            endLocation2 = input.nextLine();
                        }
                        validCount = 0;
                        try {
                            Connection mysql = connect();
                            Statement stmt = mysql.createStatement();
                            ResultSet rs = stmt.executeQuery("SELECT COUNT(*) As Number FROM taxi WHERE name = \"" + endLocation2 + "\"");
                            rs.next();
                            validCount = rs.getInt(1);
                        } catch(Exception e) {
                        }
                    }
                    
                    
                    System.out.println("Please enter the model. (Press enter to skip)");
                    String model = input.nextLine();
                    if(model.equals("")){
                        model = "NULL";
                        }
                    else {
                        validCount = 0;
                        try {
                            Connection mysql = connect();
                            Statement stmt = mysql.createStatement();
                            ResultSet rs = stmt.executeQuery("SELECT COUNT(*) As Number FROM driver_vehicle WHERE model like '" + model + "%' ;");
                            rs.next();
                            validCount = rs.getInt(1);
                        } catch(Exception e) {
                        }
                        while (validCount <= 0){
                            System.out.println("[ERROR] Model not available! Please try again or skip.");
                            System.out.println("Please enter the model. (Press enter to skip)");
                            model = input.nextLine();
                            validCount = 0;
                            try {
                                Connection mysql = connect();
                                Statement stmt = mysql.createStatement();
                                ResultSet rs = stmt.executeQuery("SELECT COUNT(*) As Number FROM driver_vehicle WHERE model like '" + model + "%' ;");
                                rs.next();
                                validCount = rs.getInt(1);
                            } catch(Exception e) {
                            }
                        }
                    }
                    
                    System.out.println("Please enter the minimum driving years of the driver. (Press enter to skip)");
                    String minYear = input.nextLine();
                    int minimum_drivingYears;
                    if(minYear.equals("")) {
                        minimum_drivingYears = 0;
                    } else {
                        minimum_drivingYears = Integer.parseInt(minYear);
                    }
                    validCount = 0;
                    try {
                        Connection mysql = connect();
                        Statement stmt = mysql.createStatement();
                        ResultSet rs = stmt.executeQuery("SELECT COUNT(*) As Number FROM driver_vehicle WHERE drivingYears >= " + minimum_drivingYears + ";");
                        rs.next();
                        validCount = rs.getInt(1);
                    } catch(Exception e) {
                    }
                    while (validCount <= 0){
                        System.out.println("[ERROR] Sorry! There are no drivers who fit your driving years requirement. Please try again or skip.");
                        System.out.println("Please enter the minimum driving years of the driver. (Press enter to skip)");
                        minYear = input.nextLine();
                        if(minYear.equals("")) {
                            minimum_drivingYears = 0;
                        } else {
                            minimum_drivingYears = Integer.parseInt(minYear);
                        }
                        validCount = 0;
                        try {
                            Connection mysql = connect();
                            Statement stmt = mysql.createStatement();
                            ResultSet rs = stmt.executeQuery("SELECT COUNT(*) As Number FROM driver_vehicle WHERE drivingYears >= " + minimum_drivingYears + ";");
                            rs.next();
                            validCount = rs.getInt(1);
                        } catch(Exception e) {
                        }
                    }
                    
                    int availableDriverno = 0;
                    
                    try {
                        Connection mysql = connect();
                        Statement stmt = mysql.createStatement();
                        String availableDriver = new String();
                        if(!model.equals("NULL"))
                            availableDriver = "SELECT COUNT(*) FROM driver_vehicle" +
                                                    " WHERE seats >= " + passengerno +
                                                    " AND drivingYears >= " + minimum_drivingYears +
                                                    " AND model like '" + model + "%' ;";
                        else
                            availableDriver = "SELECT COUNT(*) FROM driver_vehicle"+
                                                    " WHERE seats >= " + passengerno +
                                                    " AND drivingYears >= " + minimum_drivingYears + ";";
                        
                        ResultSet rs = stmt.executeQuery(availableDriver);
                        rs.next();
                        availableDriverno = rs.getInt(1);
                    } catch(Exception e) {
                        System.out.println(e);
                    }
                    
                    if (availableDriverno > 0){
                        try {
                            Connection mysql = connect();
                            PreparedStatement MRpstmt = mysql.prepareStatement(MRinsert);
                            Statement stmt = mysql.createStatement();
                            ResultSet rs = stmt.executeQuery(checkMaxRid);
                            rs.next();
                            String maxRid = rs.getString(1);

                            int rid;
                            if(maxRid == null) {
                                rid = 1;
                            } else {
                                rid = Integer.parseInt(maxRid) + 1;
                            }
                            
                            MRpstmt.setInt(1, rid);
                            MRpstmt.setInt(2, pid1);
                            if(minYear.equals("")) {
                                MRpstmt.setInt(3, 0);
                            } else {
                                MRpstmt.setInt(3, minimum_drivingYears);
                            }
                            
                            if(model.equals("NULL")) {
                                MRpstmt.setNull(4, java.sql.Types.VARCHAR);
                            } else {
                                MRpstmt.setString(4, model);
                            }
                            MRpstmt.setInt(5, passengerno);
                            MRpstmt.setString(6, startLocation2);
                            MRpstmt.setString(7, endLocation2);
                            MRpstmt.setBoolean(8, false);
                            MRpstmt.executeUpdate();
                            System.out.println("Your request is placed. " + availableDriverno + " drivers are able to take the request.");
                        } catch(Exception e) {
                            System.out.println(e.getMessage());
                        }
                    } else System.out.println("Sorry! There are no drivers who fit your number of passengers requirement. Please try again.");
                    
                    
                    
                    break;
                    
                case 2:
                    System.out.println("Please enter your ID.");
                    int pid2 = Integer.parseInt(input.nextLine());
                    validCount = 0;
                    try {
                        Connection mysql = connect();
                        Statement stmt = mysql.createStatement();
                        ResultSet rs = stmt.executeQuery("SELECT COUNT(*) As Number FROM passenger WHERE pid = " + pid2 + ";");
                        rs.next();
                        validCount = rs.getInt(1);
                    } catch(Exception e) {
                    }
                    while (validCount <= 0){
                        System.out.println("[ERROR] Passenger ID Not Found");
                        System.out.println("Please enter your ID.");
                        pid2 = Integer.parseInt(input.nextLine());
                        validCount = 0;
                        try {
                            Connection mysql = connect();
                            Statement stmt = mysql.createStatement();
                            ResultSet rs = stmt.executeQuery("SELECT COUNT(*) As Number FROM passenger WHERE pid = " + pid2 + ";");
                            rs.next();
                            validCount = rs.getInt(1);
                        } catch(Exception e) {
                        }
                    }
                    
                    System.out.println("Please enter the Start date.");
                    String startDate = input.nextLine() + " 00:00:00";

                    System.out.println("Please enter the End date.");
                    String endDate   = input.nextLine() + " 23:59:59";
                    
                    System.out.println("Please enter the Destination.");
                    String endLocation3 = input.nextLine();
                    validCount = 0;
                    try {
                        Connection mysql = connect();
                        Statement stmt = mysql.createStatement();
                        ResultSet rs = stmt.executeQuery("SELECT COUNT(*) As Number FROM taxi WHERE name = \"" + endLocation3 + "\"");

                        rs.next();
                        validCount = rs.getInt(1);
                    } catch(Exception e) {
                    }
                    while (validCount <= 0){
                        System.out.println("[ERROR] Destination Not Found");
                        System.out.println("Please enter the destination.");
                        endLocation3 = input.nextLine();
                        validCount = 0;
                        try {
                            Connection mysql = connect();
                            Statement stmt = mysql.createStatement();
                            ResultSet rs = stmt.executeQuery("SELECT COUNT(*) As Number FROM taxi WHERE name = \"" + endLocation3 + "\"");
                            rs.next();
                            validCount = rs.getInt(1);
                        } catch(Exception e) {
                        }
                    }

                    String tripQuery = "SELECT T.tid, D.name, D.vid, D.model, T.startTime, T.endTime, T.fee, T.startLocation, T.endLocation, T.did, D.did FROM take_trip T, driver_vehicle D WHERE T.did = D.did AND T.pid = " + pid2 + " AND T.endLocation = \"" + endLocation3 + "\" AND T.startTime > \"" + startDate + "\" AND T.endTime < \"" + endDate + "\"" + "order by T.startTime DESC;";
                    
                    String title = "Trip ID, Driver name, Vehicle ID, Vehicle model, Start, End, Fee, Start Location, End Location\n";
                    
                    validCount = 0;
                    try {
                        Connection mysql = connect();
                        Statement stmt = mysql.createStatement();
                        ResultSet rs = stmt.executeQuery("SELECT COUNT(*) As Number FROM take_trip T, driver_vehicle D WHERE T.did = D.did AND T.pid = " + pid2 + " AND T.endLocation = \"" + endLocation3 + "\" AND T.startTime > \"" + startDate + "\" AND T.endTime < \"" + endDate + "\"");
                        rs.next();
                        validCount = rs.getInt(1);
                    } catch(Exception e) {
                    }
                    
                    if (validCount > 0){
                        try{
                            Connection mysql = connect();
                            Statement stmt = mysql.createStatement();
                            ResultSet rs = stmt.executeQuery(tripQuery);
                            System.out.print(title);
                            while(rs.next()){
                                System.out.println(rs.getInt(1) + ", " + rs.getString(2) + ", " + rs.getString(3) + ", " + rs.getString(4) + ", " + rs.getString(5).substring(0, 19) + ", " + rs.getString(6).substring(0, 19) + ", " + rs.getInt(7) + ", " + rs.getString(8) + ", " + rs.getString(9));
                            }
                        } catch(Exception e) {
                            System.out.println(e);
                        }
                    } else System.out.println("Records Not Found!");
                    break;
                case 3:
                    return;
                default:
                    System.out.println("[ERROR] Invalid Input");
            }
        } while(true);
    }
    
    public static void Driver() {
        Scanner input = new Scanner(System.in);
        do{
            System.out.println("Driver, what would you like to do?");
            System.out.println("1. Search a requests");
            System.out.println("2. Take a request");
            System.out.println("3. Finish a trip");
            System.out.println("4. Go back");
            System.out.println("Please enter [1-4]");
            
            int option = input.nextInt();
            
            switch(option) {
                case 1:
                    Scanner scan3 = new Scanner(System.in);
                    
                    System.out.println("Please enter your ID.");
                    int did2 = Integer.parseInt(scan3.nextLine());
                    int validCount = 0;
                    try {
                        Connection mysql = connect();
                        Statement stmt = mysql.createStatement();
                        ResultSet rs = stmt.executeQuery("SELECT COUNT(*) As Number FROM driver_vehicle WHERE did = " + did2 + ";");
                        rs.next();
                        validCount = rs.getInt(1);
                    } catch(Exception e) {
                    }
                    while (validCount <= 0){
                        System.out.println("[ERROR] Driver ID Not Found");
                        System.out.println("Please enter your ID.");
                        did2 = Integer.parseInt(scan3.nextLine());
                        validCount = 0;
                        try {
                            Connection mysql = connect();
                            Statement stmt = mysql.createStatement();
                            ResultSet rs = stmt.executeQuery("SELECT COUNT(*) As Number FROM driver_vehicle WHERE did = " + did2 + ";");
                            rs.next();
                            validCount = rs.getInt(1);
                        } catch(Exception e) {
                        }
                    }
                    
                    System.out.println("Please enter the coordinates of your location");
                    String coordinates = scan3.nextLine();
                    String nos[] = coordinates.split("[ ]");
                    int driver_locationX = Integer.parseInt(nos[0]);
                    int driver_locationY = Integer.parseInt(nos[1]);
                    
                    System.out.println("Please enter the maximum distance from you to the passenger.");
                    int max_dist_fromDtoP = Integer.parseInt(scan3.nextLine());
                    
                    String PlocationQuery = "SELECT T.xlocation, T.ylocation FROM make_request M, taxi T WHERE M.startLocation = T.name;";
                    
                    String showRequest = "SELECT M.rid, P.name, M.passengers, M.startLocation, M.endLocation, M.taken FROM make_request M, passenger P, driver_vehicle D WHERE M.pid = P.pid AND M.taken = 0 AND D.seats >= M.passengers AND (M.model = D.model OR M.model IS NULL) AND (D.drivingYears >= M.drivingYears OR M.drivingYears = 0) AND D.did = " + did2 + ";";
                    
                    validCount = 0;
                    
                    try{
                        Connection mysql = connect();
                        Statement pqstmt = mysql.createStatement();
                        Statement SRstmt = mysql.createStatement();
                        ResultSet pq = pqstmt.executeQuery(PlocationQuery);
                        ResultSet sr = SRstmt.executeQuery(showRequest);
                        pq.next();
                        int PlocationX = pq.getInt(1);
                        int PlocationY = pq.getInt(2);
                        
                        double x1 = driver_locationX;
                        double x2 = PlocationX;
                        double y1 = driver_locationY;
                        double y2 = PlocationY;
                        
                        double distance1 = Math.sqrt( (x2-x1) * (x2-x1) + (y2-y1) * (y2-y1) );
                
                        Statement stmt = mysql.createStatement();
                        ResultSet rs = stmt.executeQuery("SELECT COUNT(*) As Number FROM make_request M, passenger P, driver_vehicle D WHERE M.pid = P.pid AND M.taken = 0 AND D.seats >= M.passengers AND (M.model = D.model OR M.model IS NULL) AND (D.drivingYears >= M.drivingYears OR M.drivingYears = 0) AND D.did = " + did2 + ";");
                        rs.next();
                        validCount = rs.getInt(1);
                        
                        if(validCount <= 0){
                            System.out.println("No Request Available!");
                        }
                        else if (max_dist_fromDtoP >= distance1){
                            System.out.println("request ID, passenger name, num of passengers, start location, destination\n");
                            while(sr.next()){
                                System.out.format("%3d, ", sr.getInt(1));
                                System.out.print(" " + sr.getString(2) + ",");
                                System.out.format("%3d, ", sr.getInt(3));
                                System.out.print(" " + sr.getString(4) + ",");
                                System.out.print(" " + sr.getString(5) + "\n");
                            }
                        }
                    }catch(Exception e){System.out.println(e);}
                    break;
                    
                case 2:
                    
                    Scanner scan4 = new Scanner(System.in);
                    
                    System.out.println("Please enter your ID.");
                    int did3 = Integer.parseInt(scan4.nextLine());
                    validCount = 0;
                    try {
                        Connection mysql = connect();
                        Statement stmt = mysql.createStatement();
                        ResultSet rs = stmt.executeQuery("SELECT COUNT(*) As Number FROM driver_vehicle WHERE did = " + did3 + ";");
                        rs.next();
                        validCount = rs.getInt(1);
                    } catch(Exception e) {
                    }
                    while (validCount <= 0){
                        System.out.println("[ERROR] Driver ID Not Found");
                        System.out.println("Please enter your ID.");
                        did3 = Integer.parseInt(scan4.nextLine());
                        validCount = 0;
                        try {
                            Connection mysql = connect();
                            Statement stmt = mysql.createStatement();
                            ResultSet rs = stmt.executeQuery("SELECT COUNT(*) As Number FROM driver_vehicle WHERE did = " + did3 + ";");
                            rs.next();
                            validCount = rs.getInt(1);
                        } catch(Exception e) {
                        }
                    }
                    
                    System.out.println("Please enter the request ID.");
                    int rid2 = Integer.parseInt(scan4.nextLine());
                    validCount = 0;
                    try {
                        Connection mysql = connect();
                        Statement stmt = mysql.createStatement();
                        ResultSet rs = stmt.executeQuery("SELECT COUNT(*) As Number FROM make_request WHERE taken = 0 AND rid = " + rid2 + ";");
                        rs.next();
                        validCount = rs.getInt(1);
                    } catch(Exception e) {
                    }
                    
                    
                    String requestAvailable = "SELECT pid, startLocation, endLocation FROM make_request WHERE rid = " + rid2 + ";";
                    
                    try {
                        Connection mysql = connect();
                        Statement MTstmt = mysql.createStatement();
                        Statement RAstmt = mysql.createStatement();
                        
                        Statement stmt = mysql.createStatement();
                        ResultSet rsQ = stmt.executeQuery("SELECT COUNT(*) As Number FROM make_request M, driver_vehicle D WHERE (M.passengers <= D.seats) AND (M.model = D.model OR M.model IS NULL) AND (M.drivingYears >= D.drivingYears OR M.drivingYears = 0) AND M.rid = " + rid2 + " AND D.did = " + did3 + ";");
                        rsQ.next();
                        int QvalidCount = rsQ.getInt(1);

                        PreparedStatement prep2 = mysql.prepareStatement("SELECT * FROM driver_vehicle D, take_trip T WHERE T.did = " + did3 + " AND T.endTime IS NULL"); //check if did is finished
                        ResultSet result = prep2.executeQuery();
                        
                        
                        if (result.next()){
                            System.out.println("Sorry! Your current trip is not finished.\n");
                            }
                        else if (validCount <= 0){
                            System.out.println("[ERROR] No such request or request being taken.");
                        }
                        else if (QvalidCount <= 0){
                            System.out.println("[ERROR] You are not qualified for the request");
                        }
                        else {
                            String maxTripSQL = "SELECT MAX(tid) FROM take_trip;"; //get the latest Trip id from take_trip
                            ResultSet rsMT = MTstmt.executeQuery(maxTripSQL);
                            ResultSet rsRA = RAstmt.executeQuery(requestAvailable);
                            rsRA.next();
                            rsMT.next();
                            int maxTrip = 1;
                            if(!rsMT.getString(1).equals("NULL")){
                                maxTrip = rsMT.getInt(1)+1;
                            }
                            
                            Timestamp timestamp = new Timestamp(System.currentTimeMillis()); //get current systim
                            String time = timestamp.toString().substring(0,19);
                                
                            String startTrip = "INSERT INTO take_trip VALUES(?,?,?,?,?,?,?,?);";
                            PreparedStatement p = mysql.prepareStatement(startTrip);
                            p.setInt(1,maxTrip);
                            p.setInt(2,did3);
                            p.setInt(3, rsRA.getInt(1));
                            p.setString(4, time);
                            p.setNull(5, java.sql.Types.VARCHAR);
                            p.setString(6, rsRA.getString(2));
                            p.setString(7, rsRA.getString(3));
                            p.setInt(8, 0);
                            p.executeUpdate();
                                
                            System.out.println("Trip ID, Passenger Name, Start\n");
                                
                            ResultSet rs = MTstmt.executeQuery("SELECT name FROM passenger WHERE pid = " + rsRA.getInt(1) + " ;"); //get passenger name
                            rs.next();
                                
                            System.out.format("%7d, %14s, %19s\n", maxTrip, rs.getString(1), time);
                            String updateMR = "UPDATE make_request SET taken = 1 WHERE pid = " + rsRA.getInt(1);
                            MTstmt.executeUpdate(updateMR);
                        }
                    }catch(Exception e){System.out.println(e);}
                break;
                    
                case 3:
                    
                    System.out.println("Please enter your ID.");
                    int did4 = input.nextInt();
                    validCount = 0;
                    try {
                        Connection mysql = connect();
                        Statement stmt = mysql.createStatement();
                        ResultSet rs = stmt.executeQuery("SELECT COUNT(*) As Number FROM driver_vehicle WHERE did = " + did4 + ";");
                        rs.next();
                        validCount = rs.getInt(1);
                    } catch(Exception e) {
                    }
                    while (validCount <= 0){
                        System.out.println("[ERROR] Driver ID Not Found");
                        System.out.println("Please enter your ID.");
                        did4 = Integer.parseInt(input.nextLine());
                        validCount = 0;
                        try {
                            Connection mysql = connect();
                            Statement stmt = mysql.createStatement();
                            ResultSet rs = stmt.executeQuery("SELECT COUNT(*) As Number FROM driver_vehicle WHERE did = " + did4 + ";");
                            rs.next();
                            validCount = rs.getInt(1);
                        } catch(Exception e) {
                        }
                    }
                    
                    
                    String driverAvailable2 = "SELECT * FROM take_trip WHERE did = " + did4 + " AND endTime IS NULL;";
                    try{
                        Connection mysql = connect();

                        Statement FRstmt = mysql.createStatement();

                        PreparedStatement prep2 = mysql.prepareStatement("SELECT * FROM driver_vehicle D, take_trip T WHERE T.did = " + did4 + " AND T.endTime IS NULL"); //check if did is finished
                        ResultSet result = prep2.executeQuery();
                        
                        if (result.next()){
                            ResultSet rsDA = FRstmt.executeQuery(driverAvailable2);
                            rsDA.next();
                            int tid = rsDA.getInt(1);
                            int pid = rsDA.getInt(3);
                            String start = rsDA.getString(4).substring(0,19);
                            System.out.println("Trip ID, Passenger ID, Start\n");
                            System.out.format("%7d, ", tid);
                            System.out.format("%12d, ", pid);
                            System.out.format("%19s,\n", start);
                            System.out.println("Do you want to finish the trip?[y/n]");
                            String toEnd = input.next();
                            if(toEnd.equals("y")){
                                Timestamp endstmp = new Timestamp(System.currentTimeMillis());
                                String end = endstmp.toString().substring(0,19);
                                Timestamp startstmp = Timestamp.valueOf(start);
                                int fee = (int)((endstmp.getTime()- startstmp.getTime())/60000);
                                String updateTrip = "UPDATE take_trip SET endTime = \""+
                                                    end + "\" ,fee = "+
                                                    fee + " WHERE tid = "+
                                                    tid + ";";
                                FRstmt.executeUpdate(updateTrip);
                                ResultSet rsGP = FRstmt.executeQuery("SELECT name FROM passenger WHERE pid = " + pid + ";");
                                rsGP.next();
                                String passengerName = rsGP.getString(1);
                                System.out.println("Trip ID, Passenger Name, Start, End, Fee\n");
                                System.out.format("%7d, %14s, %19s, %19s, %3d\n", tid, passengerName, start, end, fee);
                            }
                        }
                            
                    }catch(Exception e){System.out.println(e);}
                    
                    break;

                case 4:
                    return;
                default:
                    System.out.println("[ERROR] Invalid Input");
            }
        } while(true);
    }
    
    public static void Manager() {
        Scanner input = new Scanner(System.in);
        do{
            System.out.println("Manager, what would you like to do?");
            System.out.println("1. Find trips");
            System.out.println("2. Go back");
            System.out.println("Please enter [1-2].");
            
            int option = input.nextInt();
            
            switch(option) {
                case 1:
                    System.out.println("Please enter the minimum traveling distance");
                    int minDist = input.nextInt();
                    
                    System.out.println("Please enter the maximum traveling distance");
                    int maxDist = input.nextInt();
                    
                    System.out.println("trip id, driver name, passenger name, start location, destination, duration");
                    
                    String findTrip = "select tt.tid, pv.name, p.name, tt.startLocation, tt.endLocation, tt.fee "
                            + "from take_trip tt, driver_vehicle pv, passenger p, taxi ts, taxi te "
                            + "where tt.did = pv.did and tt.pid = p.pid and  tt.startLocation = ts.name and tt.endLocation = te.name and abs(ts.xLocation - te.xLocation) + abs(ts.yLocation - te.yLocation) >= " + minDist + " and abs(ts.xLocation - te.xLocation) + abs(ts.yLocation - te.yLocation) <= " + maxDist + " "
                            + "order by tt.tid;";
                    
                    try {
                        Connection mysql = connect();
                        Statement sql = mysql.createStatement();
                        ResultSet result = sql.executeQuery(findTrip);
                        
                        while(result.next()) {
                            System.out.println(result.getInt(1) + ", " + result.getString(2) + ", " + result.getString(3) + ", " + result.getString(4) + ", " + result.getString(5) + ", " + result.getInt(6));
                        }
                    } catch(Exception e) {
                        System.out.println(e);
                    }
                    break;
                case 2:
                    return;
                default:
                    System.out.println("[ERROR] Invalid Input");
            }
        } while(true);
    }
    
    public static void main(String[] args) {
        Meun();
    }
}
