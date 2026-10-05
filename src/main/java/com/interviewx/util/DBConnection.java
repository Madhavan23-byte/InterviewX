package com.interviewx.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String URL =
            "jdbc:mysql://127.0.0.1:3306/interviewx"
            + "?useSSL=false"
            + "&serverTimezone=UTC"
            + "&allowPublicKeyRetrieval=true";

    private static final String USER = "root";

    /*
     * IMPORTANT:
     * Enter the SAME MySQL root password
     * that you use in MySQL Workbench.
     *
     * Do NOT send the password to me.
     */
    private static final String PASSWORD = "root";


    public static Connection getConnection()
            throws SQLException {

        try {

            Class.forName(
                "com.mysql.cj.jdbc.Driver"
            );

        } catch (ClassNotFoundException e) {

            throw new SQLException(
                "MySQL JDBC Driver not found. "
                + "Check mysql-connector JAR.",
                e
            );
        }

        Connection connection =
                DriverManager.getConnection(
                    URL,
                    USER,
                    PASSWORD
                );

        return connection;
    }
}