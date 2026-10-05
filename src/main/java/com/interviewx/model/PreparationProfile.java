package com.interviewx.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Represents a student's independent preparation profile for a specific career role.
 * A single student can have multiple preparation profiles (e.g. Blockchain Developer, Backend Developer).
 */
public class PreparationProfile implements Serializable {
    private static final long serialVersionUID = 1L;

    private int profileId;
    private int userId;
    private int studentId;
    private int trackId;
    private String targetRole;
    private String profileName;
    private String status; // active, paused, completed
    private double readinessScore;
    private Timestamp createdAt;
    private Timestamp lastActiveAt;

    // Transient stats for rich UI rendering
    private String trackIcon;
    private int modulesCompleted;
    private int totalModules;
    private int tasksCompleted;
    private int totalTasks;
    private int problemsSolved;
    private int interviewAttempts;
    private double avgInterviewScore;

    public PreparationProfile() {
        this.status = "active";
        this.readinessScore = 0.0;
    }

    public PreparationProfile(int profileId, int userId, int studentId, int trackId,
                              String targetRole, String profileName, String status,
                              double readinessScore, Timestamp createdAt, Timestamp lastActiveAt) {
        this.profileId = profileId;
        this.userId = userId;
        this.studentId = studentId;
        this.trackId = trackId;
        this.targetRole = targetRole;
        this.profileName = profileName;
        this.status = status;
        this.readinessScore = readinessScore;
        this.createdAt = createdAt;
        this.lastActiveAt = lastActiveAt;
    }

    public int getProfileId() { return profileId; }
    public void setProfileId(int profileId) { this.profileId = profileId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }

    public int getTrackId() { return trackId; }
    public void setTrackId(int trackId) { this.trackId = trackId; }

    public String getTargetRole() { return targetRole; }
    public void setTargetRole(String targetRole) { this.targetRole = targetRole; }

    public String getProfileName() { return profileName != null ? profileName : targetRole; }
    public void setProfileName(String profileName) { this.profileName = profileName; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public double getReadinessScore() { return readinessScore; }
    public void setReadinessScore(double readinessScore) { this.readinessScore = readinessScore; }

    public int getReadinessPercent() { return (int) Math.round(readinessScore); }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getLastActiveAt() { return lastActiveAt; }
    public void setLastActiveAt(Timestamp lastActiveAt) { this.lastActiveAt = lastActiveAt; }

    public String getTrackIcon() { return trackIcon != null ? trackIcon : "IX"; }
    public void setTrackIcon(String trackIcon) { this.trackIcon = trackIcon; }

    public int getModulesCompleted() { return modulesCompleted; }
    public void setModulesCompleted(int modulesCompleted) { this.modulesCompleted = modulesCompleted; }

    public int getTotalModules() { return totalModules; }
    public void setTotalModules(int totalModules) { this.totalModules = totalModules; }

    public int getModuleProgressPercent() {
        return totalModules > 0 ? (modulesCompleted * 100 / totalModules) : 0;
    }

    public int getTasksCompleted() { return tasksCompleted; }
    public void setTasksCompleted(int tasksCompleted) { this.tasksCompleted = tasksCompleted; }

    public int getTotalTasks() { return totalTasks; }
    public void setTotalTasks(int totalTasks) { this.totalTasks = totalTasks; }

    public int getProblemsSolved() { return problemsSolved; }
    public void setProblemsSolved(int problemsSolved) { this.problemsSolved = problemsSolved; }

    public int getInterviewAttempts() { return interviewAttempts; }
    public void setInterviewAttempts(int interviewAttempts) { this.interviewAttempts = interviewAttempts; }

    public double getAvgInterviewScore() { return avgInterviewScore; }
    public void setAvgInterviewScore(double avgInterviewScore) { this.avgInterviewScore = avgInterviewScore; }
}