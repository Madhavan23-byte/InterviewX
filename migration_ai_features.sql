-- ============================================================
-- InterviewX AI Features Database Migration
-- Run this ONCE against the interviewx database
-- ============================================================

USE interviewx;

-- ============================================================
-- 1. AI Interview Sessions (enhanced mock_interviews)
-- ============================================================
ALTER TABLE mock_interviews 
    ADD COLUMN IF NOT EXISTS ai_questions_used TINYINT(1) DEFAULT 0,
    ADD COLUMN IF NOT EXISTS target_role VARCHAR(100) DEFAULT NULL;

-- ============================================================
-- 2. AI Interview Answers (enhanced interview_answers)
-- ============================================================
ALTER TABLE interview_answers
    ADD COLUMN IF NOT EXISTS ai_feedback_json TEXT DEFAULT NULL,
    ADD COLUMN IF NOT EXISTS score_breakdown VARCHAR(500) DEFAULT NULL,
    ADD COLUMN IF NOT EXISTS missing_concepts TEXT DEFAULT NULL,
    ADD COLUMN IF NOT EXISTS suggested_answer TEXT DEFAULT NULL,
    ADD COLUMN IF NOT EXISTS follow_up_question VARCHAR(500) DEFAULT NULL;

-- ============================================================
-- 3. Code Analysis History
-- ============================================================
CREATE TABLE IF NOT EXISTS code_analysis_history (
    analysis_id      INT AUTO_INCREMENT PRIMARY KEY,
    user_id          INT NOT NULL,
    language         VARCHAR(50) NOT NULL,
    code_snippet     TEXT,
    ai_response_json MEDIUMTEXT,
    question         VARCHAR(500),
    ai_response      TEXT,
    analyzed_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_user_id (user_id)
);

-- ============================================================
-- 4. Resume AI Analysis History
-- ============================================================
CREATE TABLE IF NOT EXISTS resume_ai_analysis (
    ai_analysis_id   INT AUTO_INCREMENT PRIMARY KEY,
    user_id          INT NOT NULL,
    resume_id        INT DEFAULT NULL,
    ai_response_json MEDIUMTEXT,
    top_role         VARCHAR(100),
    overall_summary  TEXT,
    analyzed_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_user_id (user_id)
);

-- ============================================================
-- 5. AI-Generated Interview Questions Cache
-- ============================================================
CREATE TABLE IF NOT EXISTS ai_generated_questions (
    ai_question_id  INT AUTO_INCREMENT PRIMARY KEY,
    target_role     VARCHAR(100) NOT NULL,
    interview_type  VARCHAR(50) NOT NULL,
    difficulty      VARCHAR(20) NOT NULL DEFAULT 'MEDIUM',
    question_text   TEXT NOT NULL,
    topic           VARCHAR(100),
    expected_keywords TEXT,
    hint            VARCHAR(500),
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_role_type (target_role, interview_type)
);

-- ============================================================
-- 6. Add target_roles column to interview_questions if needed
-- ============================================================
ALTER TABLE interview_questions 
    ADD COLUMN IF NOT EXISTS target_roles VARCHAR(500) DEFAULT NULL;

-- ============================================================
-- 7. Seed role-specific interview questions
-- ============================================================
INSERT IGNORE INTO interview_questions (interview_type, question_text, topic, difficulty, target_roles) VALUES
('TECHNICAL', 'Explain the difference between HashMap and Hashtable in Java.', 'Java Collections', 'MEDIUM', 'Backend Developer,Java Developer'),
('TECHNICAL', 'What is the difference between abstract class and interface in Java?', 'OOP', 'EASY', 'Backend Developer'),
('TECHNICAL', 'Explain normalization in DBMS with examples.', 'DBMS', 'MEDIUM', 'Backend Developer'),
('TECHNICAL', 'What is a REST API? Explain HTTP methods GET, POST, PUT, DELETE.', 'REST APIs', 'EASY', 'Backend Developer,Full Stack Developer'),
('TECHNICAL', 'Explain SOLID principles in object-oriented design.', 'Design Principles', 'MEDIUM', 'Backend Developer'),
('TECHNICAL', 'What is the time complexity of binary search? Explain.', 'DSA', 'EASY', NULL),
('TECHNICAL', 'Explain the difference between stack and heap memory in Java.', 'Java Memory', 'MEDIUM', 'Backend Developer'),
('TECHNICAL', 'What is a deadlock? How can it be prevented?', 'OS', 'MEDIUM', NULL),
('TECHNICAL', 'Explain ACID properties in database transactions.', 'DBMS', 'MEDIUM', 'Backend Developer'),
('TECHNICAL', 'What is microservices architecture? Advantages over monolith?', 'System Design', 'HARD', 'Backend Developer'),
('TECHNICAL', 'Explain supervised vs unsupervised learning with examples.', 'Machine Learning', 'EASY', 'AI Engineer,Machine Learning Engineer'),
('TECHNICAL', 'What is gradient descent? How does it work?', 'ML Algorithms', 'MEDIUM', 'AI Engineer'),
('TECHNICAL', 'Explain the transformer architecture and self-attention.', 'Deep Learning', 'HARD', 'AI Engineer'),
('TECHNICAL', 'What is overfitting? How do you prevent it?', 'ML Concepts', 'EASY', 'AI Engineer,Data Scientist'),
('TECHNICAL', 'Explain how a smart contract works on Ethereum.', 'Blockchain', 'MEDIUM', 'Blockchain Developer'),
('TECHNICAL', 'What is the difference between Proof of Work and Proof of Stake?', 'Blockchain', 'MEDIUM', 'Blockchain Developer'),
('TECHNICAL', 'What are ERC-20 and ERC-721 token standards?', 'Blockchain', 'MEDIUM', 'Blockchain Developer'),
('TECHNICAL', 'Explain virtual DOM in React and how it improves performance.', 'React', 'MEDIUM', 'Frontend Developer'),
('TECHNICAL', 'What is the difference between let, const, and var in JavaScript?', 'JavaScript', 'EASY', 'Frontend Developer'),
('TECHNICAL', 'Explain Docker and containerization benefits.', 'DevOps', 'MEDIUM', 'DevOps Engineer'),
('HR', 'Tell me about yourself and your career goals.', 'Introduction', 'EASY', NULL),
('HR', 'Where do you see yourself in 5 years?', 'Career Goals', 'EASY', NULL),
('HR', 'Describe a challenging project and how you handled it.', 'Problem Solving', 'MEDIUM', NULL),
('HR', 'What are your strengths and weaknesses?', 'Self Assessment', 'EASY', NULL),
('HR', 'Why do you want to join this company?', 'Motivation', 'EASY', NULL),
('GD', 'Impact of Artificial Intelligence on employment.', 'Technology', 'MEDIUM', NULL),
('GD', 'Should social media be regulated by the government?', 'Policy', 'MEDIUM', NULL),
('GD', 'Remote work vs office work: pros and cons.', 'Workplace', 'EASY', NULL);

SELECT 'Migration completed successfully.' AS status;
