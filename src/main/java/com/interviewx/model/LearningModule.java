package com.interviewx.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class LearningModule implements Serializable {
    private static final long serialVersionUID = 1L;

    private int moduleId;
    private int trackId;
    private String moduleName;
    private String description;
    private int moduleOrder;
    private String status; // NOT_STARTED, IN_PROGRESS, COMPLETED
    private Timestamp completedAt;

    public LearningModule() {
        this.status = "NOT_STARTED";
        this.moduleOrder = 1;
    }

    public LearningModule(int trackId, String moduleName, String description, int moduleOrder) {
        this.trackId = trackId;
        this.moduleName = moduleName;
        this.description = description;
        this.moduleOrder = moduleOrder;
        this.status = "NOT_STARTED";
    }

    public int getModuleId() { return moduleId; }
    public void setModuleId(int moduleId) { this.moduleId = moduleId; }

    public int getTrackId() { return trackId; }
    public void setTrackId(int trackId) { this.trackId = trackId; }

    public String getModuleName() { return moduleName; }
    public void setModuleName(String moduleName) { this.moduleName = moduleName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public int getModuleOrder() { return moduleOrder; }
    public void setModuleOrder(int moduleOrder) { this.moduleOrder = moduleOrder; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getCompletedAt() { return completedAt; }
    public void setCompletedAt(Timestamp completedAt) { this.completedAt = completedAt; }
}
