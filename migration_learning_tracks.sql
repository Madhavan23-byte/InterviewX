-- Migration: Learning Tracks / Course-Specific Progress & Daily Task Enhancement
-- Preserves existing tables, profiles, and tasks

CREATE TABLE IF NOT EXISTS learning_tracks (
    track_id INT AUTO_INCREMENT PRIMARY KEY,
    profile_id INT NOT NULL,
    user_id INT NOT NULL,
    track_name VARCHAR(150) NOT NULL,
    description TEXT NULL,
    category VARCHAR(100) DEFAULT 'Technical',
    icon VARCHAR(50) DEFAULT 'book',
    status ENUM('NOT_STARTED', 'IN_PROGRESS', 'PAUSED', 'COMPLETED') DEFAULT 'IN_PROGRESS',
    progress_percentage DECIMAL(5,2) DEFAULT 0.00,
    started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP NULL,
    last_accessed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (profile_id) REFERENCES preparation_profiles(profile_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_lt_profile (profile_id),
    INDEX idx_lt_user (user_id),
    UNIQUE KEY uk_profile_track (profile_id, track_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS learning_modules (
    module_id INT AUTO_INCREMENT PRIMARY KEY,
    track_id INT NOT NULL,
    module_name VARCHAR(200) NOT NULL,
    description TEXT NULL,
    module_order INT DEFAULT 1,
    status ENUM('NOT_STARTED', 'IN_PROGRESS', 'COMPLETED') DEFAULT 'NOT_STARTED',
    completed_at TIMESTAMP NULL,
    FOREIGN KEY (track_id) REFERENCES learning_tracks(track_id) ON DELETE CASCADE,
    INDEX idx_lm_track (track_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Add learning_track_id and module_id to study_tasks if not present
SET @exist_lt := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='study_tasks' AND COLUMN_NAME='learning_track_id');
SET @sql_lt := IF(@exist_lt = 0, 'ALTER TABLE study_tasks ADD COLUMN learning_track_id INT NULL AFTER profile_id, ADD INDEX idx_st_lt (learning_track_id)', 'SELECT ''learning_track_id exists''');
PREPARE stmt_lt FROM @sql_lt;
EXECUTE stmt_lt;
DEALLOCATE PREPARE stmt_lt;

SET @exist_mod := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='study_tasks' AND COLUMN_NAME='module_id');
SET @sql_mod := IF(@exist_mod = 0, 'ALTER TABLE study_tasks ADD COLUMN module_id INT NULL AFTER learning_track_id, ADD INDEX idx_st_mod (module_id)', 'SELECT ''module_id exists''');
PREPARE stmt_mod FROM @sql_mod;
EXECUTE stmt_mod;
DEALLOCATE PREPARE stmt_mod;

CREATE TABLE IF NOT EXISTS task_completion (
    completion_id INT AUTO_INCREMENT PRIMARY KEY,
    task_id INT NOT NULL,
    profile_id INT NOT NULL,
    track_id INT NULL,
    user_id INT NOT NULL,
    time_spent_minutes INT DEFAULT 30,
    completed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (task_id) REFERENCES study_tasks(task_id) ON DELETE CASCADE,
    FOREIGN KEY (profile_id) REFERENCES preparation_profiles(profile_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_tc_task (task_id),
    INDEX idx_tc_profile (profile_id),
    INDEX idx_tc_track (track_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
