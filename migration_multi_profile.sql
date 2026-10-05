USE interviewx;

-- 1. Create preparation_profiles table
CREATE TABLE IF NOT EXISTS preparation_profiles (
    profile_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    student_id INT,
    track_id INT NOT NULL,
    target_role VARCHAR(100) NOT NULL,
    profile_name VARCHAR(150),
    status VARCHAR(30) DEFAULT 'active',
    readiness_score DECIMAL(5,2) DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_active_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    KEY idx_user (user_id),
    KEY idx_track (track_id),
    UNIQUE KEY uk_user_role (user_id, target_role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2. Create student_resumes table
CREATE TABLE IF NOT EXISTS student_resumes (
    resume_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    file_name VARCHAR(255),
    file_type VARCHAR(50),
    raw_text MEDIUMTEXT,
    extracted_skills TEXT,
    extracted_technologies TEXT,
    extracted_projects TEXT,
    extracted_experience TEXT,
    extracted_education TEXT,
    analysis_summary TEXT,
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    KEY idx_user_resume (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3. Create resume_role_recommendations table
CREATE TABLE IF NOT EXISTS resume_role_recommendations (
    rec_id INT AUTO_INCREMENT PRIMARY KEY,
    resume_id INT,
    user_id INT NOT NULL,
    track_id INT NOT NULL,
    role_name VARCHAR(100) NOT NULL,
    alignment_level VARCHAR(50) NOT NULL,
    match_score INT NOT NULL,
    reasons TEXT,
    skill_matches TEXT,
    skill_gaps TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    KEY idx_user_rec (user_id),
    KEY idx_resume_rec (resume_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 4. Safely add profile_id column to existing preparation data tables
SET @dbname = DATABASE();

-- student_module_progress
SET @colExists = (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=@dbname AND TABLE_NAME='student_module_progress' AND COLUMN_NAME='profile_id');
SET @s = IF(@colExists = 0, 'ALTER TABLE student_module_progress ADD COLUMN profile_id INT NULL AFTER user_id, ADD INDEX idx_module_prog_profile (profile_id)', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- study_tasks
SET @colExists = (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=@dbname AND TABLE_NAME='study_tasks' AND COLUMN_NAME='profile_id');
SET @s = IF(@colExists = 0, 'ALTER TABLE study_tasks ADD COLUMN profile_id INT NULL AFTER user_id, ADD INDEX idx_tasks_profile (profile_id)', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- coding_submissions
SET @colExists = (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=@dbname AND TABLE_NAME='coding_submissions' AND COLUMN_NAME='profile_id');
SET @s = IF(@colExists = 0, 'ALTER TABLE coding_submissions ADD COLUMN profile_id INT NULL AFTER user_id, ADD INDEX idx_subs_profile (profile_id)', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- mock_interviews
SET @colExists = (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=@dbname AND TABLE_NAME='mock_interviews' AND COLUMN_NAME='profile_id');
SET @s = IF(@colExists = 0, 'ALTER TABLE mock_interviews ADD COLUMN profile_id INT NULL AFTER user_id, ADD INDEX idx_interviews_profile (profile_id)', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- student_skill_profiles
SET @colExists = (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=@dbname AND TABLE_NAME='student_skill_profiles' AND COLUMN_NAME='prep_profile_id');
SET @s = IF(@colExists = 0, 'ALTER TABLE student_skill_profiles ADD COLUMN prep_profile_id INT NULL AFTER user_id, ADD INDEX idx_skills_profile (prep_profile_id)', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- placement_readiness
SET @colExists = (SELECT count(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=@dbname AND TABLE_NAME='placement_readiness' AND COLUMN_NAME='profile_id');
SET @s = IF(@colExists = 0, 'ALTER TABLE placement_readiness ADD COLUMN profile_id INT NULL AFTER user_id', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- Update placement_readiness index to allow multiple profiles per user
SET @idxExists = (SELECT count(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA=@dbname AND TABLE_NAME='placement_readiness' AND INDEX_NAME='user_id');
SET @s = IF(@idxExists > 0, 'ALTER TABLE placement_readiness DROP INDEX user_id', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @ukExists = (SELECT count(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA=@dbname AND TABLE_NAME='placement_readiness' AND INDEX_NAME='uk_user_profile');
SET @s = IF(@ukExists = 0, 'ALTER TABLE placement_readiness ADD UNIQUE KEY uk_user_profile (user_id, profile_id)', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- 5. Seed Roadmaps for Blockchain Developer (Track 15) and AI Engineer (Track 8) if not present
INSERT IGNORE INTO roadmaps (roadmap_id, track_id, roadmap_name) VALUES
(15, 15, 'Blockchain Developer Career Roadmap'),
(8, 8, 'AI & Machine Learning Engineer Career Roadmap'),
(3, 3, 'Full Stack Developer Career Roadmap');

-- Modules for Blockchain Developer (Track 15, Roadmap 15)
INSERT IGNORE INTO roadmap_modules (roadmap_id, module_name, description, order_index, estimated_days) VALUES
(15, 'Blockchain Fundamentals & Cryptography', 'Hash functions, SHA-256, asymmetric cryptography, consensus mechanisms (PoW, PoS)', 1, 7),
(15, 'Ethereum & EVM Architecture', 'Gas economics, account models, transactions, EVM state transitions', 2, 10),
(15, 'Solidity Smart Contract Development', 'Syntax, data types, mappings, events, inheritance, access control', 3, 14),
(15, 'Smart Contract Security & Testing', 'Reentrancy, integer overflows, oracle manipulation, Foundry & Hardhat unit testing', 4, 12),
(15, 'DeFi Protocols & Token Standards', 'ERC-20, ERC-721, ERC-1155, Automated Market Makers (AMM), Liquidity Pools', 5, 14),
(15, 'Web3 Integration & Ethers.js', 'Frontend integration with MetaMask, Web3.js / Ethers.js, IPFS storage', 6, 10),
(15, 'Layer 2 & Scaling Solutions', 'Rollups (Optimistic & ZK-Rollups), sidechains, cross-chain bridges', 7, 10),
(15, 'Cap-stone Production DApp', 'Build, test, audit, and deploy a full decentralized application', 8, 14);

-- Modules for AI Engineer (Track 8, Roadmap 8)
INSERT IGNORE INTO roadmap_modules (roadmap_id, module_name, description, order_index, estimated_days) VALUES
(8, 'Python for AI & Scientific Computing', 'Advanced Python, NumPy, Pandas vector operations, data visualization', 1, 7),
(8, 'Classical Machine Learning', 'Supervised vs Unsupervised learning, regression, decision trees, Scikit-Learn', 2, 10),
(8, 'Deep Learning & Neural Networks', 'Backpropagation, activation functions, CNNs, RNNs, PyTorch fundamentals', 3, 14),
(8, 'Natural Language Processing & Transformers', 'Embeddings, self-attention, Hugging Face Transformers, BERT, GPT architectures', 4, 14),
(8, 'Large Language Models & Prompt Engineering', 'Zero-shot, few-shot prompting, LangChain, RAG (Retrieval Augmented Generation)', 5, 12),
(8, 'Vector Databases & Semantic Search', 'ChromaDB, Pinecone, FAISS, cosine similarity, hybrid search systems', 6, 10),
(8, 'Model Evaluation & MLOps', 'Accuracy metrics, precision/recall, MLflow, Dockerized model serving with FastAPI', 7, 10),
(8, 'End-to-End AI Production System', 'Deploy a production-grade LLM-powered application with streaming inference', 8, 14);

-- 6. Migrate existing student profile data into preparation_profiles
INSERT IGNORE INTO preparation_profiles (user_id, student_id, track_id, target_role, profile_name, status, readiness_score)
SELECT s.user_id, s.student_id, COALESCE(t.track_id, 2), COALESCE(s.target_role, 'Backend Developer'), 
       CONCAT(COALESCE(s.target_role, 'Backend Developer'), ' Profile'), 'active', 25.00
FROM students s
LEFT JOIN career_tracks t ON t.track_name LIKE CONCAT('%', s.target_role, '%') OR s.target_role LIKE CONCAT('%', t.track_name, '%')
WHERE s.target_role IS NOT NULL AND s.target_role != '';

-- Link existing study_tasks to existing profile if unassigned
UPDATE study_tasks st 
JOIN preparation_profiles pp ON st.user_id = pp.user_id
SET st.profile_id = pp.profile_id
WHERE st.profile_id IS NULL;

-- Link existing student_module_progress to existing profile if unassigned
UPDATE student_module_progress smp
JOIN preparation_profiles pp ON smp.user_id = pp.user_id
SET smp.profile_id = pp.profile_id
WHERE smp.profile_id IS NULL;

-- Link existing placement_readiness to existing profile if unassigned
UPDATE placement_readiness pr
JOIN preparation_profiles pp ON pr.user_id = pp.user_id
SET pr.profile_id = pp.profile_id
WHERE pr.profile_id IS NULL;