package com.interviewx.service;

import java.util.*;
import java.util.regex.*;
import com.interviewx.dao.CareerDAO;
import com.interviewx.model.*;

public class ResumeService {

    private final CareerDAO careerDAO = new CareerDAO();

    // Dictionaries for skill identification
    private static final Map<String, List<String>> TRACK_KEYWORDS = new LinkedHashMap<>();

    static {
        // Track 15: Blockchain Developer
        TRACK_KEYWORDS.put("Blockchain Developer", Arrays.asList(
            "solidity", "smart contract", "smart contracts", "ethereum", "web3", "web3.js", "ethers.js",
            "evm", "hardhat", "truffle", "defi", "dapp", "dapps", "ipfs", "cryptography", "blockchain",
            "tokenomics", "erc20", "erc721", "foundry", "metamask", "bitcoin", "consensus"
        ));

        // Track 2: Backend Developer
        TRACK_KEYWORDS.put("Backend Developer", Arrays.asList(
            "java", "spring", "spring boot", "hibernate", "microservices", "rest", "rest api", "sql",
            "mysql", "postgresql", "redis", "node.js", "express", "django", "fastapi", "database",
            "jdbc", "kafka", "rabbitmq", "maven", "mvc", "orm"
        ));

        // Track 8: AI Engineer
        TRACK_KEYWORDS.put("AI Engineer", Arrays.asList(
            "python", "pytorch", "tensorflow", "machine learning", "deep learning", "nlp", "llm",
            "transformers", "hugging face", "scikit-learn", "pandas", "numpy", "computer vision",
            "neural networks", "langchain", "rag", "vector database", "embeddings", "data science"
        ));

        // Track 1: Frontend Developer
        TRACK_KEYWORDS.put("Frontend Developer", Arrays.asList(
            "javascript", "typescript", "react", "react.js", "vue", "angular", "html5", "css3",
            "tailwind", "redux", "next.js", "dom", "responsive design", "sass", "webpack", "ui/ux"
        ));

        // Track 3: Full Stack Developer
        TRACK_KEYWORDS.put("Full Stack Developer", Arrays.asList(
            "javascript", "react", "node.js", "java", "spring boot", "sql", "full stack",
            "html", "css", "mongodb", "restful", "api", "git", "docker"
        ));

        // Track 10: Cloud Engineer
        TRACK_KEYWORDS.put("Cloud Engineer", Arrays.asList(
            "aws", "azure", "gcp", "cloud", "ec2", "s3", "lambda", "cloudformation",
            "terraform", "serverless", "iam", "vpc", "cloud computing"
        ));

        // Track 11: DevOps Engineer
        TRACK_KEYWORDS.put("DevOps Engineer", Arrays.asList(
            "docker", "kubernetes", "ci/cd", "jenkins", "github actions", "ansible",
            "terraform", "linux", "bash", "monitoring", "prometheus", "grafana"
        ));

        // Track 12: Cybersecurity Engineer
        TRACK_KEYWORDS.put("Cybersecurity Engineer", Arrays.asList(
            "cybersecurity", "security", "penetration testing", "ethical hacking", "owasp",
            "cryptography", "firewall", "vulnerability", "wireshark", "network security", "siem"
        ));

        // Track 13: Mobile Developer
        TRACK_KEYWORDS.put("Mobile Developer", Arrays.asList(
            "android", "ios", "flutter", "react native", "swift", "kotlin", "mobile app",
            "xcode", "gradle", "mobile"
        ));

        // Track 6: Data Analyst
        TRACK_KEYWORDS.put("Data Analyst", Arrays.asList(
            "sql", "excel", "power bi", "tableau", "python", "pandas", "data analysis",
            "visualization", "statistics", "business intelligence"
        ));
    }

    /**
     * Extracts skills, technologies, and projects from raw resume text
     */
    public StudentResume analyzeResumeText(int userId, String fileName, String fileType, String rawText, Student student) {
        StudentResume resume = new StudentResume();
        resume.setUserId(userId);
        resume.setFileName(fileName != null && !fileName.isEmpty() ? fileName : "resume.txt");
        resume.setFileType(fileType != null && !fileType.isEmpty() ? fileType : "text/plain");
        resume.setRawText(rawText);

        String textLower = rawText.toLowerCase();

        // 1. Extract Skills
        Set<String> detectedSkills = new LinkedHashSet<>();
        for (List<String> kwList : TRACK_KEYWORDS.values()) {
            for (String kw : kwList) {
                if (containsWord(textLower, kw)) {
                    detectedSkills.add(capitalizeKeyword(kw));
                }
            }
        }
        // Include skills from student profile if available
        if (student != null && student.getSkills() != null) {
            String[] sArr = student.getSkills().split("[,;]");
            for (String s : sArr) {
                if (!s.trim().isEmpty()) detectedSkills.add(s.trim());
            }
        }
        resume.setExtractedSkills(String.join(", ", detectedSkills));

        // 2. Extract Technologies
        Set<String> techList = new LinkedHashSet<>();
        String[] coreTechs = {"Java", "Python", "JavaScript", "TypeScript", "C++", "C#", "Solidity",
            "Go", "Rust", "React", "Node.js", "Spring Boot", "Docker", "Kubernetes", "AWS", "SQL",
            "MongoDB", "Redis", "PyTorch", "TensorFlow", "Linux", "Git", "GraphQL", "Ethereum"};
        for (String tech : coreTechs) {
            if (containsWord(textLower, tech.toLowerCase())) {
                techList.add(tech);
            }
        }
        resume.setExtractedTechnologies(String.join(", ", techList));

        // 3. Extract Projects
        List<String> projects = extractProjects(rawText);
        resume.setExtractedProjects(String.join("\n", projects));

        // 4. Extract Experience & Education
        resume.setExtractedExperience(extractSection(rawText, "experience|work experience|employment history"));
        resume.setExtractedEducation(extractSection(rawText, "education|academic background|academics"));

        // 5. Generate Summary
        String summary = String.format("Parsed %d technical skills, %d core technologies, and %d project mentions from resume.",
            detectedSkills.size(), techList.size(), projects.size());
        resume.setAnalysisSummary(summary);

        return resume;
    }

    /**
     * Generates advisory role compatibility recommendations with understandable reasons.
     */
    public List<RoleRecommendation> generateRoleRecommendations(int userId, StudentResume resume, Student student) {
        List<RoleRecommendation> recommendations = new ArrayList<>();
        List<CareerTrack> allTracks = careerDAO.getAllTracks();
        Map<String, CareerTrack> trackMap = new HashMap<>();
        for (CareerTrack ct : allTracks) {
            trackMap.put(ct.getTrackName().toLowerCase(), ct);
        }

        String rawLower = (resume.getRawText() != null ? resume.getRawText().toLowerCase() : "");
        String studentInterests = (student != null && student.getInterests() != null) ? student.getInterests().toLowerCase() : "";
        String studentTarget = (student != null && student.getTargetRole() != null) ? student.getTargetRole().toLowerCase() : "";
        String studentSkills = (student != null && student.getSkills() != null) ? student.getSkills().toLowerCase() : "";

        for (Map.Entry<String, List<String>> entry : TRACK_KEYWORDS.entrySet()) {
            String roleName = entry.getKey();
            List<String> keywords = entry.getValue();

            CareerTrack track = trackMap.get(roleName.toLowerCase());
            if (track == null) {
                for (CareerTrack ct : allTracks) {
                    if (ct.getTrackName().toLowerCase().contains(roleName.toLowerCase()) ||
                        roleName.toLowerCase().contains(ct.getTrackName().toLowerCase())) {
                        track = ct;
                        break;
                    }
                }
            }
            int trackId = (track != null) ? track.getTrackId() : 2;

            List<String> matchedSkills = new ArrayList<>();
            List<String> missingSkills = new ArrayList<>();
            List<String> reasons = new ArrayList<>();

            int keywordHits = 0;
            for (String kw : keywords) {
                if (containsWord(rawLower, kw) || containsWord(studentSkills, kw)) {
                    keywordHits++;
                    matchedSkills.add(capitalizeKeyword(kw));
                } else {
                    if (missingSkills.size() < 4) missingSkills.add(capitalizeKeyword(kw));
                }
            }

            // Project detection for this domain
            boolean projectDetected = detectDomainProject(rawLower, roleName);
            if (projectDetected) {
                reasons.add(roleName.split(" ")[0] + " project detected in resume/portfolio");
            }

            if (!matchedSkills.isEmpty()) {
                reasons.add(String.format("Relevant technical skills detected (%s)",
                    String.join(", ", matchedSkills.subList(0, Math.min(3, matchedSkills.size())))));
            }

            // Check student interest alignment
            String roleKey = roleName.toLowerCase().split(" ")[0];
            if (studentInterests.contains(roleKey) || studentTarget.contains(roleKey)) {
                reasons.add(capitalizeKeyword(roleKey) + " interest indicated in career profile");
            }

            // Calculate match score
            int baseScore = (int) Math.min(60, keywordHits * 12);
            if (projectDetected) baseScore += 25;
            if (studentInterests.contains(roleKey)) baseScore += 10;
            if (studentTarget.contains(roleKey)) baseScore += 10;

            int matchScore = Math.min(95, Math.max(30, baseScore));

            // Determine advisory alignment level (Never claim "perfect fit")
            String alignmentLevel;
            if (matchScore >= 75) {
                alignmentLevel = "Strong alignment";
            } else if (matchScore >= 55) {
                alignmentLevel = "Good alignment";
            } else {
                alignmentLevel = "Moderate alignment";
            }

            if (reasons.isEmpty()) {
                reasons.add("Foundational programming skills detected");
                reasons.add("Matches entry-level industry prerequisites");
            }

            RoleRecommendation rec = new RoleRecommendation();
            rec.setUserId(userId);
            rec.setTrackId(trackId);
            rec.setRoleName(roleName);
            rec.setAlignmentLevel(alignmentLevel);
            rec.setMatchScore(matchScore);
            rec.setReasons(String.join("\n", reasons));
            rec.setSkillMatches(String.join(", ", matchedSkills));
            rec.setSkillGaps(String.join(", ", missingSkills));
            if (track != null) rec.setTrackIcon(track.getIcon());

            recommendations.add(rec);
        }

        // Sort by match score descending
        recommendations.sort((a, b) -> Integer.compare(b.getMatchScore(), a.getMatchScore()));

        return recommendations;
    }

    private boolean detectDomainProject(String text, String roleName) {
        String lower = text.toLowerCase();
        if (roleName.contains("Blockchain")) {
            return lower.contains("smart contract") || lower.contains("dapp") || lower.contains("solidity") ||
                   lower.contains("web3") || lower.contains("ethereum") || lower.contains("defi");
        } else if (roleName.contains("Backend")) {
            return lower.contains("api") || lower.contains("backend") || lower.contains("microservices") ||
                   lower.contains("rest") || lower.contains("server") || lower.contains("database");
        } else if (roleName.contains("AI")) {
            return lower.contains("model") || lower.contains("neural") || lower.contains("nlp") ||
                   lower.contains("classification") || lower.contains("prediction") || lower.contains("llm");
        } else if (roleName.contains("Frontend")) {
            return lower.contains("dashboard") || lower.contains("ui") || lower.contains("website") ||
                   lower.contains("react") || lower.contains("frontend");
        }
        return false;
    }

    private List<String> extractProjects(String rawText) {
        List<String> list = new ArrayList<>();
        String[] lines = rawText.split("\\r?\\n");
        boolean inProjectSection = false;

        for (String line : lines) {
            String trimmed = line.trim();
            if (trimmed.isEmpty()) continue;

            if (trimmed.toLowerCase().matches("^(projects|personal projects|academic projects|key projects).*")) {
                inProjectSection = true;
                continue;
            }

            if (inProjectSection && (trimmed.toLowerCase().matches("^(experience|education|skills|certifications).*"))) {
                inProjectSection = false;
            }

            if (inProjectSection) {
                if (trimmed.startsWith("•") || trimmed.startsWith("-") || trimmed.startsWith("*") || trimmed.length() > 15) {
                    list.add(trimmed.replaceAll("^[•\\-*\\s]+", ""));
                    if (list.size() >= 5) break;
                }
            } else {
                if (trimmed.toLowerCase().contains("project:") || trimmed.toLowerCase().contains("dapp") ||
                    trimmed.toLowerCase().contains("system") || trimmed.toLowerCase().contains("application")) {
                    list.add(trimmed);
                    if (list.size() >= 5) break;
                }
            }
        }
        if (list.isEmpty()) {
            list.add("Project portfolio details included in resume");
        }
        return list;
    }

    private String extractSection(String rawText, String headingPattern) {
        Pattern pattern = Pattern.compile("(?s)(?i)(?:" + headingPattern + ")[\\s:]*\\n(.*?)(?=\\n[A-Z][A-Za-z\\s]{2,20}:|\\n[A-Z\\s]{3,20}\\n|$)", Pattern.DOTALL);
        Matcher matcher = pattern.matcher(rawText);
        if (matcher.find()) {
            String res = matcher.group(1).trim();
            return res.length() > 500 ? res.substring(0, 500) + "..." : res;
        }
        return "Provided in submitted resume profile";
    }

    private boolean containsWord(String text, String word) {
        if (text == null || word == null) return false;
        String t = text.toLowerCase();
        String w = word.toLowerCase();
        if (w.length() <= 3) {
            return Pattern.compile("(?s)(?i).*\\b" + Pattern.quote(w) + "\\b.*").matcher(t).matches();
        }
        return t.contains(w);
    }

    private String capitalizeKeyword(String kw) {
        if (kw.equalsIgnoreCase("sql") || kw.equalsIgnoreCase("aws") || kw.equalsIgnoreCase("gcp") ||
            kw.equalsIgnoreCase("api") || kw.equalsIgnoreCase("evm") || kw.equalsIgnoreCase("defi") ||
            kw.equalsIgnoreCase("dapp") || kw.equalsIgnoreCase("nlp") || kw.equalsIgnoreCase("llm") ||
            kw.equalsIgnoreCase("rag") || kw.equalsIgnoreCase("ui/ux") || kw.equalsIgnoreCase("ci/cd")) {
            return kw.toUpperCase();
        }
        if (kw.equalsIgnoreCase("node.js")) return "Node.js";
        if (kw.equalsIgnoreCase("react.js")) return "React.js";
        if (kw.equalsIgnoreCase("next.js")) return "Next.js";
        if (kw.equalsIgnoreCase("web3.js")) return "Web3.js";
        if (kw.equalsIgnoreCase("ethers.js")) return "Ethers.js";

        String[] parts = kw.split(" ");
        StringBuilder sb = new StringBuilder();
        for (String p : parts) {
            if (p.length() > 0) {
                sb.append(Character.toUpperCase(p.charAt(0))).append(p.substring(1).toLowerCase()).append(" ");
            }
        }
        return sb.toString().trim();
    }
}