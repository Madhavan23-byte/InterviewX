package com.interviewx.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class LearningTrack implements Serializable {
    private static final long serialVersionUID = 1L;

    private int trackId;
    private int profileId;
    private int userId;
    private String trackName;
    private String description;
    private String category;
    private String icon;
    private String status; // NOT_STARTED, IN_PROGRESS, PAUSED, COMPLETED
    private double progressPercentage;
    private Timestamp startedAt;
    private Timestamp completedAt;
    private Timestamp lastAccessedAt;

    // Aggregated / runtime computed metrics
    private int completedModules;
    private int totalModules;
    private double moduleProgressPercentage;
    private int completedTasks;
    private int totalTasks;
    private double taskProgressPercentage;
    private int todaysTasksCount;
    private int timeSpentMinutes;
    private String currentModuleName;
    private String nextTaskTitle;

    public LearningTrack() {
        this.status = "IN_PROGRESS";
        this.category = "Technical";
        this.icon = "book";
        this.progressPercentage = 0.0;
    }

    public int getTrackId() { return trackId; }
    public void setTrackId(int trackId) { this.trackId = trackId; }

    public int getProfileId() { return profileId; }
    public void setProfileId(int profileId) { this.profileId = profileId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getTrackName() { return trackName; }
    public void setTrackName(String trackName) { this.trackName = trackName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getIcon() { return icon; }
    public void setIcon(String icon) { this.icon = icon; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public double getProgressPercentage() { return progressPercentage; }
    public void setProgressPercentage(double progressPercentage) { this.progressPercentage = progressPercentage; }

    public Timestamp getStartedAt() { return startedAt; }
    public void setStartedAt(Timestamp startedAt) { this.startedAt = startedAt; }

    public Timestamp getCompletedAt() { return completedAt; }
    public void setCompletedAt(Timestamp completedAt) { this.completedAt = completedAt; }

    public Timestamp getLastAccessedAt() { return lastAccessedAt; }
    public void setLastAccessedAt(Timestamp lastAccessedAt) { this.lastAccessedAt = lastAccessedAt; }

    public int getCompletedModules() { return completedModules; }
    public void setCompletedModules(int completedModules) { this.completedModules = completedModules; }

    public int getTotalModules() { return totalModules; }
    public void setTotalModules(int totalModules) { this.totalModules = totalModules; }

    public double getModuleProgressPercentage() { return moduleProgressPercentage; }
    public void setModuleProgressPercentage(double moduleProgressPercentage) { this.moduleProgressPercentage = moduleProgressPercentage; }

    public int getCompletedTasks() { return completedTasks; }
    public void setCompletedTasks(int completedTasks) { this.completedTasks = completedTasks; }

    public int getTotalTasks() { return totalTasks; }
    public void setTotalTasks(int totalTasks) { this.totalTasks = totalTasks; }

    public double getTaskProgressPercentage() { return taskProgressPercentage; }
    public void setTaskProgressPercentage(double taskProgressPercentage) { this.taskProgressPercentage = taskProgressPercentage; }

    public int getTodaysTasksCount() { return todaysTasksCount; }
    public void setTodaysTasksCount(int todaysTasksCount) { this.todaysTasksCount = todaysTasksCount; }

    public int getTimeSpentMinutes() { return timeSpentMinutes; }
    public void setTimeSpentMinutes(int timeSpentMinutes) { this.timeSpentMinutes = timeSpentMinutes; }

    public String getCurrentModuleName() { return currentModuleName; }
    public void setCurrentModuleName(String currentModuleName) { this.currentModuleName = currentModuleName; }

    public String getNextTaskTitle() { return nextTaskTitle; }
    public void setNextTaskTitle(String nextTaskTitle) { this.nextTaskTitle = nextTaskTitle; }
}
