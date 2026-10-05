package com.interviewx.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class TaskCompletion implements Serializable {
    private static final long serialVersionUID = 1L;

    private int completionId;
    private int taskId;
    private int profileId;
    private int trackId;
    private int userId;
    private int timeSpentMinutes;
    private Timestamp completedAt;

    public TaskCompletion() {
        this.timeSpentMinutes = 30;
    }

    public int getCompletionId() { return completionId; }
    public void setCompletionId(int completionId) { this.completionId = completionId; }

    public int getTaskId() { return taskId; }
    public void setTaskId(int taskId) { this.taskId = taskId; }

    public int getProfileId() { return profileId; }
    public void setProfileId(int profileId) { this.profileId = profileId; }

    public int getTrackId() { return trackId; }
    public void setTrackId(int trackId) { this.trackId = trackId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getTimeSpentMinutes() { return timeSpentMinutes; }
    public void setTimeSpentMinutes(int timeSpentMinutes) { this.timeSpentMinutes = timeSpentMinutes; }

    public Timestamp getCompletedAt() { return completedAt; }
    public void setCompletedAt(Timestamp completedAt) { this.completedAt = completedAt; }
}
