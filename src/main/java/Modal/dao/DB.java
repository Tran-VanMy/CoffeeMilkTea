// Path: src/main/java/Modal/dao/DB.java
package Modal.dao;

import java.sql.Connection;
import java.sql.DriverManager;

public class DB {
    
    private static final String HOST = "LAPTOP-KJ26ONI8\\SQLEXPRESS";
    private static final String PORT = "1433";
    private static final String DB_NAME = "CoffeeMilkTea";
    private static final String USER = "sa";
    private static final String PASS = "123";

    private static final String URL =
            "jdbc:sqlserver://" + HOST + ":" + PORT +
            ";databaseName=" + DB_NAME +
            ";encrypt=true;trustServerCertificate=true;" +
            ";loginTimeout=30;";

    public static Connection getConnection() throws Exception {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        System.out.println("da ket noi");
        return DriverManager.getConnection(URL, USER, PASS);
    }
}