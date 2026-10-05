package com.interviewx.dao;

import java.sql.*;
import java.util.*;
import com.interviewx.model.CodingProblem;
import com.interviewx.model.CodingSubmission;
import com.interviewx.util.DBConnection;

public class CodingProblemDAO {

    public static class DashboardStats {
        public int totalProblems;
        public int solvedCount;
        public int attemptedCount;
        public int remainingCount;
        public int easySolved;
        public int mediumSolved;
        public int hardSolved;
        public int totalTopics;
        public int progressPercent;
    }

    public static class TopicProgress {
        public String topicName;
        public int totalProblems;
        public int solvedProblems;
        public int percent;

        public TopicProgress(String topicName, int totalProblems, int solvedProblems) {
            this.topicName = topicName;
            this.totalProblems = totalProblems;
            this.solvedProblems = solvedProblems;
            this.percent = totalProblems > 0 ? (solvedProblems * 100) / totalProblems : 0;
        }
    }

    public List<CodingProblem> getAllProblems(int userId, int profileId, String difficulty, String topic, String status, String search, String sortBy) {
        List<CodingProblem> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT cp.*, " +
            "COALESCE(cup.status, 'NOT_STARTED') AS user_status, " +
            "COALESCE(cup.attempt_count, 0) AS user_attempt_count, " +
            "cup.last_attempt_at AS user_last_attempt_at, " +
            "cup.solved_at AS user_solved_at " +
            "FROM coding_problems cp " +
            "LEFT JOIN codelab_user_progress cup " +
            "  ON cp.problem_id = cup.problem_id AND cup.user_id = ? AND cup.profile_id = ? " +
            "WHERE cp.is_active = 1 "
        );
        List<Object> params = new ArrayList<>();
        params.add(userId);
        params.add(profileId);

        if (difficulty != null && !difficulty.trim().isEmpty()) {
            sql.append(" AND cp.difficulty = ? ");
            params.add(difficulty.trim());
        }
        if (topic != null && !topic.trim().isEmpty()) {
            sql.append(" AND cp.topic = ? ");
            params.add(topic.trim());
        }
        if (status != null && !status.trim().isEmpty()) {
            if ("SOLVED".equalsIgnoreCase(status)) {
                sql.append(" AND cup.status = 'SOLVED' ");
            } else if ("ATTEMPTED".equalsIgnoreCase(status)) {
                sql.append(" AND cup.status = 'ATTEMPTED' ");
            } else if ("NOT_STARTED".equalsIgnoreCase(status)) {
                sql.append(" AND (cup.status IS NULL OR cup.status = 'NOT_STARTED') ");
            }
        }
        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (cp.title LIKE ? OR cp.description LIKE ? OR cp.tags LIKE ? OR cp.topic LIKE ?) ");
            String term = "%" + search.trim() + "%";
            params.add(term); params.add(term); params.add(term); params.add(term);
        }

        if ("difficulty".equalsIgnoreCase(sortBy)) {
            sql.append(" ORDER BY FIELD(cp.difficulty, 'Easy', 'Medium', 'Hard'), cp.order_index, cp.problem_id ");
        } else if ("title".equalsIgnoreCase(sortBy)) {
            sql.append(" ORDER BY cp.title ASC ");
        } else {
            sql.append(" ORDER BY cp.order_index ASC, cp.problem_id ASC ");
        }

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRowWithProgress(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<CodingProblem> getAllProblems(String difficulty, String topic, String search) {
        return getAllProblems(0, 0, difficulty, topic, null, search, "order");
    }

    public CodingProblem getProblemById(int id, int userId, int profileId) {
        String sql =
            "SELECT cp.*, " +
            "COALESCE(cup.status, 'NOT_STARTED') AS user_status, " +
            "COALESCE(cup.attempt_count, 0) AS user_attempt_count, " +
            "cup.last_attempt_at AS user_last_attempt_at, " +
            "cup.solved_at AS user_solved_at, " +
            "cup.last_code AS user_last_code, " +
            "cup.last_language AS user_last_language " +
            "FROM coding_problems cp " +
            "LEFT JOIN codelab_user_progress cup " +
            "  ON cp.problem_id = cup.problem_id AND cup.user_id = ? AND cup.profile_id = ? " +
            "WHERE cp.problem_id = ?";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, profileId);
            ps.setInt(3, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    CodingProblem p = mapRowWithProgress(rs);
                    p.setLastCode(rs.getString("user_last_code"));
                    p.setLastLanguage(rs.getString("user_last_language"));
                    return p;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public CodingProblem getProblemById(int id) {
        return getProblemById(id, 0, 0);
    }

    public boolean recordSubmission(CodingSubmission sub) {
        String insertSub =
            "INSERT INTO coding_submissions " +
            "(user_id, profile_id, problem_id, language, code, verdict, runtime_ms, memory_kb, passed_test_cases, total_test_cases, attempt_number, error_details) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        String upsertProgress =
            "INSERT INTO codelab_user_progress " +
            "(user_id, profile_id, problem_id, status, attempt_count, first_attempt_at, last_attempt_at, solved_at, last_code, last_language) " +
            "VALUES (?, ?, ?, ?, 1, NOW(), NOW(), ?, ?, ?) " +
            "ON DUPLICATE KEY UPDATE " +
            "attempt_count = attempt_count + 1, " +
            "status = IF(VALUES(status) = 'SOLVED', 'SOLVED', status), " +
            "solved_at = IF(VALUES(status) = 'SOLVED' AND solved_at IS NULL, NOW(), solved_at), " +
            "last_attempt_at = NOW(), " +
            "last_code = VALUES(last_code), " +
            "last_language = VALUES(last_language)";

        try (Connection c = DBConnection.getConnection()) {
            c.setAutoCommit(false);
            try {
                // 1. Insert submission
                try (PreparedStatement ps = c.prepareStatement(insertSub, Statement.RETURN_GENERATED_KEYS)) {
                    ps.setInt(1, sub.getUserId());
                    ps.setInt(2, sub.getProfileId());
                    ps.setInt(3, sub.getProblemId());
                    ps.setString(4, sub.getLanguage());
                    ps.setString(5, sub.getCode());
                    ps.setString(6, sub.getVerdict());
                    ps.setInt(7, sub.getRuntimeMs());
                    ps.setInt(8, sub.getMemoryKb());
                    ps.setInt(9, sub.getPassedTestCases());
                    ps.setInt(10, sub.getTotalTestCases());
                    ps.setInt(11, sub.getAttemptNumber());
                    ps.setString(12, sub.getErrorDetails());
                    ps.executeUpdate();
                    try (ResultSet rs = ps.getGeneratedKeys()) {
                        if (rs.next()) sub.setSubmissionId(rs.getInt(1));
                    }
                }

                // 2. Upsert progress
                boolean isAccepted = "Accepted".equalsIgnoreCase(sub.getVerdict());
                String newStatus = isAccepted ? "SOLVED" : "ATTEMPTED";

                try (PreparedStatement ps2 = c.prepareStatement(upsertProgress)) {
                    ps2.setInt(1, sub.getUserId());
                    ps2.setInt(2, sub.getProfileId());
                    ps2.setInt(3, sub.getProblemId());
                    ps2.setString(4, newStatus);
                    if (isAccepted) {
                        ps2.setTimestamp(5, new Timestamp(System.currentTimeMillis()));
                    } else {
                        ps2.setNull(5, Types.TIMESTAMP);
                    }
                    ps2.setString(6, sub.getCode());
                    ps2.setString(7, sub.getLanguage());
                    ps2.executeUpdate();
                }

                c.commit();
                return true;
            } catch (SQLException e) {
                c.rollback();
                throw e;
            } finally {
                c.setAutoCommit(true);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean saveSubmission(int userId, int profileId, int problemId, String language, String code, String verdict) {
        CodingSubmission sub = new CodingSubmission();
        sub.setUserId(userId);
        sub.setProfileId(profileId);
        sub.setProblemId(problemId);
        sub.setLanguage(language);
        sub.setCode(code);
        sub.setVerdict(verdict);
        sub.setRuntimeMs(25);
        sub.setMemoryKb(40100);
        sub.setPassedTestCases("Accepted".equalsIgnoreCase(verdict) ? 3 : 1);
        sub.setTotalTestCases(3);
        return recordSubmission(sub);
    }

    public DashboardStats getCodelabDashboardStats(int userId, int profileId) {
        DashboardStats stats = new DashboardStats();

        try (Connection c = DBConnection.getConnection()) {
            // 1. Total Problems
            try (Statement st = c.createStatement();
                 ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM coding_problems WHERE is_active = 1")) {
                if (rs.next()) stats.totalProblems = rs.getInt(1);
            }

            // 2. Distinct topics
            try (Statement st = c.createStatement();
                 ResultSet rs = st.executeQuery("SELECT COUNT(DISTINCT topic) FROM coding_problems WHERE is_active = 1")) {
                if (rs.next()) stats.totalTopics = rs.getInt(1);
            }

            // 3. User Solved & Attempted Count for current profile
            String progressSql =
                "SELECT " +
                "COUNT(CASE WHEN status = 'SOLVED' THEN 1 END) AS solved_cnt, " +
                "COUNT(CASE WHEN status = 'ATTEMPTED' THEN 1 END) AS attempted_cnt " +
                "FROM codelab_user_progress WHERE user_id = ? AND profile_id = ?";
            try (PreparedStatement ps = c.prepareStatement(progressSql)) {
                ps.setInt(1, userId);
                ps.setInt(2, profileId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        stats.solvedCount = rs.getInt("solved_cnt");
                        stats.attemptedCount = rs.getInt("attempted_cnt");
                    }
                }
            }

            // 4. Breakdown by difficulty
            String diffSql =
                "SELECT cp.difficulty, COUNT(*) AS cnt " +
                "FROM codelab_user_progress cup " +
                "JOIN coding_problems cp ON cup.problem_id = cp.problem_id " +
                "WHERE cup.user_id = ? AND cup.profile_id = ? AND cup.status = 'SOLVED' " +
                "GROUP BY cp.difficulty";
            try (PreparedStatement ps = c.prepareStatement(diffSql)) {
                ps.setInt(1, userId);
                ps.setInt(2, profileId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        String diff = rs.getString("difficulty");
                        int count = rs.getInt("cnt");
                        if ("Easy".equalsIgnoreCase(diff)) stats.easySolved = count;
                        else if ("Medium".equalsIgnoreCase(diff)) stats.mediumSolved = count;
                        else if ("Hard".equalsIgnoreCase(diff)) stats.hardSolved = count;
                    }
                }
            }

            stats.remainingCount = Math.max(0, stats.totalProblems - stats.solvedCount);
            stats.progressPercent = stats.totalProblems > 0 ? (stats.solvedCount * 100) / stats.totalProblems : 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return stats;
    }

    public List<TopicProgress> getTopicProgressList(int userId, int profileId) {
        List<TopicProgress> list = new ArrayList<>();
        String sql =
            "SELECT cp.topic, " +
            "COUNT(cp.problem_id) AS total_count, " +
            "COUNT(CASE WHEN cup.status = 'SOLVED' THEN 1 END) AS solved_count " +
            "FROM coding_problems cp " +
            "LEFT JOIN codelab_user_progress cup " +
            "  ON cp.problem_id = cup.problem_id AND cup.user_id = ? AND cup.profile_id = ? " +
            "WHERE cp.is_active = 1 " +
            "GROUP BY cp.topic " +
            "ORDER BY cp.topic ASC";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, profileId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String topic = rs.getString("topic");
                    int total = rs.getInt("total_count");
                    int solved = rs.getInt("solved_count");
                    list.add(new TopicProgress(topic, total, solved));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<CodingSubmission> getSubmissionsForProblem(int userId, int profileId, int problemId) {
        List<CodingSubmission> list = new ArrayList<>();
        String sql =
            "SELECT s.*, p.title AS problem_title " +
            "FROM coding_submissions s " +
            "JOIN coding_problems p ON s.problem_id = p.problem_id " +
            "WHERE s.user_id = ? AND s.profile_id = ? AND s.problem_id = ? " +
            "ORDER BY s.submitted_at DESC";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, profileId);
            ps.setInt(3, problemId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CodingSubmission s = new CodingSubmission();
                    s.setSubmissionId(rs.getInt("submission_id"));
                    s.setUserId(rs.getInt("user_id"));
                    s.setProfileId(rs.getInt("profile_id"));
                    s.setProblemId(rs.getInt("problem_id"));
                    s.setProblemTitle(rs.getString("problem_title"));
                    s.setLanguage(rs.getString("language"));
                    s.setCode(rs.getString("code"));
                    s.setVerdict(rs.getString("verdict"));
                    s.setRuntimeMs(rs.getInt("runtime_ms"));
                    s.setMemoryKb(rs.getInt("memory_kb"));
                    s.setPassedTestCases(rs.getInt("passed_test_cases"));
                    s.setTotalTestCases(rs.getInt("total_test_cases"));
                    s.setAttemptNumber(rs.getInt("attempt_number"));
                    s.setErrorDetails(rs.getString("error_details"));
                    s.setSubmittedAt(rs.getTimestamp("submitted_at"));
                    list.add(s);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getSubmissionCount(int userId, int profileId) {
        String sql = "SELECT COUNT(*) FROM codelab_user_progress WHERE user_id=? AND profile_id=? AND status='SOLVED'";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, profileId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public int getSubmissionCount(int userId) {
        return getSubmissionCount(userId, 0);
    }

    public List<String> getDistinctTopics() {
        List<String> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             Statement st = c.createStatement();
             ResultSet rs = st.executeQuery("SELECT DISTINCT topic FROM coding_problems WHERE is_active=1 ORDER BY topic")) {
            while (rs.next()) {
                list.add(rs.getString("topic"));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    private CodingProblem mapRowWithProgress(ResultSet rs) throws SQLException {
        CodingProblem p = new CodingProblem();
        p.setProblemId(rs.getInt("problem_id"));
        p.setProblemNumber(rs.getInt("problem_number"));
        p.setOrderIndex(rs.getInt("order_index"));
        p.setTitle(rs.getString("title"));
        p.setDescription(rs.getString("description"));
        p.setDifficulty(rs.getString("difficulty"));
        p.setTopic(rs.getString("topic"));
        p.setSubtopic(rs.getString("subtopic"));
        p.setExamples(rs.getString("examples"));
        p.setConstraintsText(rs.getString("constraints_text"));
        p.setHints(rs.getString("hints"));
        p.setStarterCodeJava(rs.getString("starter_code_java"));
        p.setStarterCodePython(rs.getString("starter_code_python"));
        p.setStarterCodeCpp(rs.getString("starter_code_cpp"));
        p.setStarterCodeJs(rs.getString("starter_code_js"));
        p.setSolutionJava(rs.getString("solution_java"));
        p.setTestCasesJson(rs.getString("test_cases_json"));
        p.setTags(rs.getString("tags"));
        p.setExternalLink(rs.getString("external_link"));
        p.setIsActive(rs.getInt("is_active"));

        try {
            p.setUserStatus(rs.getString("user_status"));
            p.setAttemptCount(rs.getInt("user_attempt_count"));
            p.setLastAttemptAt(rs.getTimestamp("user_last_attempt_at"));
            p.setSolvedAt(rs.getTimestamp("user_solved_at"));
        } catch (SQLException ignore) {}

        return p;
    }
}
