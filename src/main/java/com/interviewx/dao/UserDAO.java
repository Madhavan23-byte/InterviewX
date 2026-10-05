package com.interviewx.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.interviewx.model.User;
import com.interviewx.util.DBConnection;

public class UserDAO {


    // =====================================================
    // CHECK WHETHER EMAIL ALREADY EXISTS
    // =====================================================

    public boolean emailExists(String email) {

        String sql =
            "SELECT user_id " +
            "FROM users " +
            "WHERE email = ?";

        try (
            Connection connection =
                DBConnection.getConnection();

            PreparedStatement statement =
                connection.prepareStatement(sql)
        ) {

            statement.setString(1, email);

            try (
                ResultSet resultSet =
                    statement.executeQuery()
            ) {

                return resultSet.next();
            }

        } catch (SQLException e) {

            e.printStackTrace();

            return false;
        }
    }


    // =====================================================
    // CREATE USER
    // =====================================================

    public boolean createUser(User user) {

        String sql =
            "INSERT INTO users " +
            "(full_name, email, password_hash, role) " +
            "VALUES (?, ?, ?, ?)";

        try (
            Connection connection =
                DBConnection.getConnection();

            PreparedStatement statement =
                connection.prepareStatement(sql)
        ) {

            statement.setString(
                1,
                user.getFullName()
            );

            statement.setString(
                2,
                user.getEmail()
            );

            statement.setString(
                3,
                user.getPasswordHash()
            );

            statement.setString(
                4,
                user.getRole()
            );


            int rowsInserted =
                statement.executeUpdate();


            System.out.println(
                "USER INSERT RESULT = "
                + rowsInserted
            );


            return rowsInserted > 0;

        } catch (SQLException e) {

            System.out.println(
                "USER INSERT FAILED"
            );

            e.printStackTrace();

            return false;
        }
    }


    // =====================================================
    // FIND USER BY EMAIL
    // =====================================================

    public User findByEmail(String email) {

        String sql =
            "SELECT user_id, " +
            "full_name, " +
            "email, " +
            "password_hash, " +
            "role " +
            "FROM users " +
            "WHERE email = ?";

        try (
            Connection connection =
                DBConnection.getConnection();

            PreparedStatement statement =
                connection.prepareStatement(sql)
        ) {

            statement.setString(1, email);

            try (
                ResultSet resultSet =
                    statement.executeQuery()
            ) {

                if (resultSet.next()) {

                    User user =
                        new User();

                    user.setUserId(
                        resultSet.getInt(
                            "user_id"
                        )
                    );

                    user.setFullName(
                        resultSet.getString(
                            "full_name"
                        )
                    );

                    user.setEmail(
                        resultSet.getString(
                            "email"
                        )
                    );

                    user.setPasswordHash(
                        resultSet.getString(
                            "password_hash"
                        )
                    );

                    user.setRole(
                        resultSet.getString(
                            "role"
                        )
                    );

                    return user;
                }
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return null;
    }
}