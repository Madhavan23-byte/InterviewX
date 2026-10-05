package com.interviewx.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class StudentResume implements Serializable {
    private static final long serialVersionUID = 1L;

    private int resumeId;
    private int userId;
    private String fileName;
    private String fileType;
    private String rawText;
    private String extractedSkills;
    private String extractedTechnologies;
    private String extractedProjects;
    private String extractedExperience;
    private String extractedEducation;
    private String analysisSummary;
    private Timestamp uploadedAt;

    public StudentResume() {}

    public int getResumeId() { return resumeId; }
    public void setResumeId(int resumeId) { this.resumeId = resumeId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getFileName() { return fileName; }
    public void setFileName(String fileName) { this.fileName = fileName; }

    public String getFileType() { return fileType; }
    public void setFileType(String fileType) { this.fileType = fileType; }

    public String getRawText() { return rawText; }
    public void setRawText(String rawText) { this.rawText = rawText; }

    public String getExtractedSkills() { return extractedSkills; }
    public void setExtractedSkills(String extractedSkills) { this.extractedSkills = extractedSkills; }

    public String getExtractedTechnologies() { return extractedTechnologies; }
    public void setExtractedTechnologies(String extractedTechnologies) { this.extractedTechnologies = extractedTechnologies; }

    public String getExtractedProjects() { return extractedProjects; }
    public void setExtractedProjects(String extractedProjects) { this.extractedProjects = extractedProjects; }

    public String getExtractedExperience() { return extractedExperience; }
    public void setExtractedExperience(String extractedExperience) { this.extractedExperience = extractedExperience; }

    public String getExtractedEducation() { return extractedEducation; }
    public void setExtractedEducation(String extractedEducation) { this.extractedEducation = extractedEducation; }

    public String getAnalysisSummary() { return analysisSummary; }
    public void setAnalysisSummary(String analysisSummary) { this.analysisSummary = analysisSummary; }

    public Timestamp getUploadedAt() { return uploadedAt; }
    public void setUploadedAt(Timestamp uploadedAt) { this.uploadedAt = uploadedAt; }
}