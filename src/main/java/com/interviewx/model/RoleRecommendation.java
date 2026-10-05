package com.interviewx.model;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class RoleRecommendation implements Serializable {
    private static final long serialVersionUID = 1L;

    private int recId;
    private int resumeId;
    private int userId;
    private int trackId;
    private String roleName;
    private String alignmentLevel; // "Strong alignment", "Good alignment", "Moderate alignment"
    private int matchScore; // 0-100
    private String reasons; // Newline or semicolon separated
    private String skillMatches;
    private String skillGaps;
    private Timestamp createdAt;

    // Transient UI helper
    private boolean profileExists;
    private int existingProfileId;
    private String trackIcon;

    public RoleRecommendation() {}

    public int getRecId() { return recId; }
    public void setRecId(int recId) { this.recId = recId; }

    public int getResumeId() { return resumeId; }
    public void setResumeId(int resumeId) { this.resumeId = resumeId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getTrackId() { return trackId; }
    public void setTrackId(int trackId) { this.trackId = trackId; }

    public String getRoleName() { return roleName; }
    public void setRoleName(String roleName) { this.roleName = roleName; }

    public String getAlignmentLevel() { return alignmentLevel; }
    public void setAlignmentLevel(String alignmentLevel) { this.alignmentLevel = alignmentLevel; }

    public int getMatchScore() { return matchScore; }
    public void setMatchScore(int matchScore) { this.matchScore = matchScore; }

    public String getReasons() { return reasons; }
    public void setReasons(String reasons) { this.reasons = reasons; }

    public List<String> getReasonList() {
        if (reasons == null || reasons.trim().isEmpty()) return new ArrayList<>();
        return Arrays.asList(reasons.split("\\s*[;\\n]\\s*"));
    }

    public String getSkillMatches() { return skillMatches; }
    public void setSkillMatches(String skillMatches) { this.skillMatches = skillMatches; }

    public String getSkillGaps() { return skillGaps; }
    public void setSkillGaps(String skillGaps) { this.skillGaps = skillGaps; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public boolean isProfileExists() { return profileExists; }
    public void setProfileExists(boolean profileExists) { this.profileExists = profileExists; }

    public int getExistingProfileId() { return existingProfileId; }
    public void setExistingProfileId(int existingProfileId) { this.existingProfileId = existingProfileId; }

    public String getTrackIcon() { return trackIcon != null ? trackIcon : "IX"; }
    public void setTrackIcon(String trackIcon) { this.trackIcon = trackIcon; }
}