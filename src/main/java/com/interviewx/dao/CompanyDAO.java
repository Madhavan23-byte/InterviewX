package com.interviewx.dao;

import java.sql.*;
import java.util.*;
import com.interviewx.model.Company;
import com.interviewx.util.DBConnection;

public class CompanyDAO {

    public List<Company> getAllCompanies() {
        List<Company> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             Statement st = c.createStatement();
             ResultSet rs = st.executeQuery("SELECT * FROM companies ORDER BY company_name")) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public Company getCompanyById(int id) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement("SELECT * FROM companies WHERE company_id=?")) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) { if (rs.next()) return mapRow(rs); }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    private Company mapRow(ResultSet rs) throws SQLException {
        Company co = new Company();
        co.setCompanyId(rs.getInt("company_id"));
        co.setCompanyName(rs.getString("company_name"));
        co.setIndustry(rs.getString("industry"));
        co.setDescription(rs.getString("description"));
        co.setWebsite(rs.getString("website"));
        co.setRequiredSkills(rs.getString("required_skills"));
        co.setInterviewStages(rs.getString("interview_stages"));
        co.setCodingExpectations(rs.getString("coding_expectations"));
        co.setTechnicalExpectations(rs.getString("technical_expectations"));
        co.setHrExpectations(rs.getString("hr_expectations"));
        return co;
    }
}
