-- ========================================================
-- InterviewX CodeLab Migration Script: migration_codelab.sql
-- Adds columns and creates codelab_user_progress table
-- ========================================================
USE interviewx;

CREATE TABLE IF NOT EXISTS codelab_user_progress (
    progress_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    profile_id INT NOT NULL,
    problem_id INT NOT NULL,
    status ENUM('NOT_STARTED', 'ATTEMPTED', 'SOLVED') DEFAULT 'NOT_STARTED',
    attempt_count INT DEFAULT 0,
    first_attempt_at TIMESTAMP NULL,
    last_attempt_at TIMESTAMP NULL,
    solved_at TIMESTAMP NULL,
    last_code TEXT NULL,
    last_language VARCHAR(30) NULL,
    UNIQUE KEY uq_user_profile_problem (user_id, profile_id, problem_id),
    KEY idx_user_profile_status (user_id, profile_id, status),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (problem_id) REFERENCES coding_problems(problem_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
