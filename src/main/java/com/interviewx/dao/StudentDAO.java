package com.interviewx.dao;

import java.sql.*;
import com.interviewx.model.Student;
import com.interviewx.util.DBConnection;

public class StudentDAO {

    /** Get student profile by userId. Returns null if not found. */
    public Student getStudentByUserId(int userId) {
        String sql = "SELECT s.*, u.full_name, u.email FROM students s JOIN users u ON s.user_id = u.user_id WHERE s.user_id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /** Create a new student record (called after user registration). */
    public boolean createStudentProfile(int userId) {
        String sql = "INSERT IGNORE INTO students (user_id) VALUES (?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /** Update student profile. */
    public boolean updateStudent(Student s) {
        String sql = "UPDATE students SET college_name=?, degree=?, graduation_year=?, target_role=?, " +
                     "skills=?, interests=?, programming_experience=?, career_goals=?, phone=?, " +
                     "linkedin_url=?, github_url=?, profile_completed=1 WHERE user_id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, s.getCollegeName());
            ps.setString(2, s.getDegree());
            ps.setInt(3, s.getGraduationYear());
            ps.setString(4, s.getTargetRole());
            ps.setString(5, s.getSkills());
            ps.setString(6, s.getInterests());
            ps.setString(7, s.getProgrammingExperience());
            ps.setString(8, s.getCareerGoals());
            ps.setString(9, s.getPhone());
            ps.setString(10, s.getLinkedinUrl());
            ps.setString(11, s.getGithubUrl());
            ps.setInt(12, s.getUserId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private Student mapRow(ResultSet rs) throws SQLException {
        Student s = new Student();
        s.setStudentId(rs.getInt("student_id"));
        s.setUserId(rs.getInt("user_id"));
        s.setCollegeName(rs.getString("college_name"));
        s.setDegree(rs.getString("degree"));
        s.setGraduationYear(rs.getInt("graduation_year"));
        s.setTargetRole(rs.getString("target_role"));
        s.setSkills(rs.getString("skills"));
        s.setInterests(rs.getString("interests"));
        s.setProgrammingExperience(rs.getString("programming_experience"));
        s.setCareerGoals(rs.getString("career_goals"));
        s.setPhone(rs.getString("phone"));
        s.setLinkedinUrl(rs.getString("linkedin_url"));
        s.setGithubUrl(rs.getString("github_url"));
        s.setProfileCompleted(rs.getInt("profile_completed"));
        return s;
    }
}
