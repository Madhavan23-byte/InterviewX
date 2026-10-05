package com.interviewx.config;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.Properties;
import java.util.concurrent.ConcurrentHashMap;

/**
 * GeminiConfig - Centralized Gemini API key configuration and connection testing.
 *
 * Security guarantees:
 * - API keys are NEVER hardcoded in source code or JSP/HTML/JS.
 * - API keys are stored in an external configuration file OUTSIDE the public web directory
 *   (default: <user.home>/InterviewX-config/ai.properties).
 * - Full keys are NEVER returned to browser clients (only masked suffixes like '••••••••ABCD').
 * - Three independent keys for Interview AI, Code Analyzer AI, and Resume Analyzer AI.
 * - Live in-memory updates: saving a key takes effect immediately without requiring Tomcat restart.
 */
public class GeminiConfig {

    // Environment variable names
    public static final String ENV_INTERVIEW_KEY    = "INTERVIEW_AI_GEMINI_API_KEY";
    public static final String ENV_CODE_KEY         = "CODE_ANALYZER_GEMINI_API_KEY";
    public static final String ENV_RESUME_KEY       = "RESUME_ANALYZER_GEMINI_API_KEY";

    // System property / Env var to override external config directory
    public static final String PROP_CONFIG_DIR      = "interviewx.config.dir";
    public static final String ENV_CONFIG_DIR       = "INTERVIEWX_CONFIG_DIR";
    public static final String CONFIG_FILENAME      = "ai.properties";

    // Default model (centralized configuration)
    public static final String DEFAULT_GEMINI_MODEL = "gemini-1.5-flash";

    // REST endpoint template
    public static final String GEMINI_API_BASE_URL  =
        "https://generativelanguage.googleapis.com/v1beta/models/" + DEFAULT_GEMINI_MODEL + ":generateContent?key=";

    // Backward-compatible constant
    public static final String GEMINI_API_URL       = GEMINI_API_BASE_URL;

    // Timeout values
    public static final int CONNECT_TIMEOUT_MS = 15_000;
    public static final int READ_TIMEOUT_MS    = 60_000;
    public static final int TEST_TIMEOUT_MS    = 10_000;

    // Max code submission size (characters)
    public static final int MAX_CODE_LENGTH = 8_000;

    // In-memory key store
    private static final ConcurrentHashMap<String, String> KEY_STORE = new ConcurrentHashMap<>();

    static {
        loadConfiguration();
    }

    /**
     * Resolves the external configuration directory.
     * Guaranteed to be outside the web application directory.
     */
    public static File getConfigDirectory() {
        String dirProp = System.getProperty(PROP_CONFIG_DIR);
        if (dirProp != null && !dirProp.isBlank()) {
            return new File(dirProp.trim());
        }
        String dirEnv = System.getenv(ENV_CONFIG_DIR);
        if (dirEnv != null && !dirEnv.isBlank()) {
            return new File(dirEnv.trim());
        }
        // Default: <user.home>/InterviewX-config
        String userHome = System.getProperty("user.home", ".");
        return new File(userHome, "InterviewX-config");
    }

    /**
     * Resolves the external configuration file.
     */
    public static File getConfigFile() {
        return new File(getConfigDirectory(), CONFIG_FILENAME);
    }

    /**
     * Loads keys from external properties file, then falls back to environment variables.
     */
    public static synchronized void loadConfiguration() {
        File file = getConfigFile();
        Properties props = new Properties();

        if (file.exists() && file.isFile()) {
            try (InputStream is = new FileInputStream(file);
                 Reader reader = new InputStreamReader(is, StandardCharsets.UTF_8)) {
                props.load(reader);
            } catch (IOException e) {
                System.err.println("[GeminiConfig] Warning: Failed to read external config file: " + e.getMessage());
            }
        }

        // Interview Key
        String interviewKey = props.containsKey(ENV_INTERVIEW_KEY) ? props.getProperty(ENV_INTERVIEW_KEY) : null;
        if (interviewKey == null || interviewKey.isBlank()) {
            interviewKey = System.getenv(ENV_INTERVIEW_KEY);
        }
        KEY_STORE.put(ENV_INTERVIEW_KEY, (interviewKey != null) ? interviewKey.trim() : "");

        // Code Analyzer Key
        String codeKey = props.containsKey(ENV_CODE_KEY) ? props.getProperty(ENV_CODE_KEY) : null;
        if (codeKey == null || codeKey.isBlank()) {
            codeKey = System.getenv(ENV_CODE_KEY);
        }
        KEY_STORE.put(ENV_CODE_KEY, (codeKey != null) ? codeKey.trim() : "");

        // Resume Analyzer Key
        String resumeKey = props.containsKey(ENV_RESUME_KEY) ? props.getProperty(ENV_RESUME_KEY) : null;
        if (resumeKey == null || resumeKey.isBlank()) {
            resumeKey = System.getenv(ENV_RESUME_KEY);
        }
        KEY_STORE.put(ENV_RESUME_KEY, (resumeKey != null) ? resumeKey.trim() : "");
    }

    // ========================================================
    // KEY ACCESSORS
    // ========================================================

    /** Returns the Interview AI key, or empty string if not configured. */
    public static String getInterviewApiKey() {
        String key = KEY_STORE.get(ENV_INTERVIEW_KEY);
        return (key != null) ? key : "";
    }

    /** Alias for backward compatibility. */
    public static String getInterviewKey() {
        return getInterviewApiKey();
    }

    /** Returns the Code Analyzer key, or empty string if not configured. */
    public static String getCodeAnalyzerApiKey() {
        String key = KEY_STORE.get(ENV_CODE_KEY);
        return (key != null) ? key : "";
    }

    /** Alias for backward compatibility. */
    public static String getCodeAnalyzerKey() {
        return getCodeAnalyzerApiKey();
    }

    /** Returns the Resume Analyzer key, or empty string if not configured. */
    public static String getResumeAnalyzerApiKey() {
        String key = KEY_STORE.get(ENV_RESUME_KEY);
        return (key != null) ? key : "";
    }

    /** Alias for backward compatibility. */
    public static String getResumeAnalyzerKey() {
        return getResumeAnalyzerApiKey();
    }

    // ========================================================
    // CONFIGURATION STATUS CHECKS
    // ========================================================

    public static boolean isInterviewAIConfigured() {
        return !getInterviewApiKey().isEmpty();
    }

    public static boolean isCodeAnalyzerConfigured() {
        return !getCodeAnalyzerApiKey().isEmpty();
    }

    public static boolean isResumeAnalyzerConfigured() {
        return !getResumeAnalyzerApiKey().isEmpty();
    }

    /**
     * Returns a safely masked display string of an API key.
     * E.g. "••••••••••••ABCD" or "Not Configured".
     * NEVER returns the full key.
     */
    public static String getMaskedKey(String rawKey) {
        if (rawKey == null || rawKey.isBlank()) {
            return "Not Configured";
        }
        String trimmed = rawKey.trim();
        if (trimmed.length() <= 8) {
            return "Configured (••••)";
        }
        String suffix = trimmed.substring(trimmed.length() - 4);
        return "••••••••••••" + suffix;
    }

    public static String getMaskedInterviewKey() {
        return getMaskedKey(getInterviewApiKey());
    }

    public static String getMaskedCodeAnalyzerKey() {
        return getMaskedKey(getCodeAnalyzerApiKey());
    }

    public static String getMaskedResumeAnalyzerKey() {
        return getMaskedKey(getResumeAnalyzerApiKey());
    }

    // ========================================================
    // PERSISTENCE (SAVE KEY)
    // ========================================================

    /**
     * Saves or updates a specific API key safely.
     * Updates in-memory store and persists to external ai.properties file.
     * Does NOT overwrite or clear the other keys.
     *
     * @param serviceType "INTERVIEW", "CODE_ANALYZER", or "RESUME_ANALYZER"
     * @param keyValue    The raw API key string
     * @return true if successfully saved
     */
    public static synchronized boolean saveKey(String serviceType, String keyValue) {
        if (serviceType == null || keyValue == null) {
            return false;
        }

        String envName = normalizeServiceType(serviceType);
        if (envName == null) {
            return false;
        }

        String cleanedKey = keyValue.trim();
        // Validation: reject empty or suspiciously long inputs
        if (cleanedKey.isEmpty() || cleanedKey.length() > 256) {
            return false;
        }
        // Basic check for control characters
        for (char c : cleanedKey.toCharArray()) {
            if (Character.isISOControl(c)) return false;
        }

        // 1. Update in-memory
        KEY_STORE.put(envName, cleanedKey);

        // 2. Persist to external ai.properties
        try {
            File configDir = getConfigDirectory();
            if (!configDir.exists()) {
                configDir.mkdirs();
            }
            File configFile = getConfigFile();

            Properties props = new Properties();
            if (configFile.exists() && configFile.isFile()) {
                try (InputStream is = new FileInputStream(configFile);
                     Reader reader = new InputStreamReader(is, StandardCharsets.UTF_8)) {
                    props.load(reader);
                }
            }

            // Keep existing keys if not set in properties
            for (String key : new String[]{ENV_INTERVIEW_KEY, ENV_CODE_KEY, ENV_RESUME_KEY}) {
                String existing = KEY_STORE.get(key);
                if (existing != null && !existing.isBlank()) {
                    props.setProperty(key, existing);
                }
            }

            // Set the new/updated key
            props.setProperty(envName, cleanedKey);

            try (OutputStream os = new FileOutputStream(configFile);
                 Writer writer = new OutputStreamWriter(os, StandardCharsets.UTF_8)) {
                props.store(writer, "InterviewX AI Configuration - Do not edit manually while server is running");
            }
            return true;
        } catch (IOException e) {
            System.err.println("[GeminiConfig] Error saving API key: " + e.getMessage());
            return false;
        }
    }

    // ========================================================
    // TEST CONNECTION
    // ========================================================

    public static class TestResult {
        public final boolean success;
        public final String message;

        public TestResult(boolean success, String message) {
            this.success = success;
            this.message = message;
        }
    }

    /**
     * Tests the connection for a specific AI service using ONLY its corresponding API key.
     * Makes a minimal lightweight ping call to Gemini.
     * Never exposes or logs the actual API key.
     *
     * @param serviceType "INTERVIEW", "CODE_ANALYZER", or "RESUME_ANALYZER"
     * @return TestResult indicating success/failure and sanitized status message
     */
    public static TestResult testConnection(String serviceType) {
        String envName = normalizeServiceType(serviceType);
        if (envName == null) {
            return new TestResult(false, "Unknown AI service type: " + serviceType);
        }

        String apiKey = KEY_STORE.get(envName);
        if (apiKey == null || apiKey.isBlank()) {
            return new TestResult(false, "API key is not configured.");
        }

        HttpURLConnection conn = null;
        try {
            URL url = new URL(GEMINI_API_BASE_URL + apiKey);
            conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
            conn.setDoOutput(true);
            conn.setConnectTimeout(TEST_TIMEOUT_MS);
            conn.setReadTimeout(TEST_TIMEOUT_MS);

            // Minimal payload to test connectivity & authentication
            String body = "{\"contents\":[{\"parts\":[{\"text\":\"ping\"}]}],\"generationConfig\":{\"maxOutputTokens\":5}}";
            try (OutputStream os = conn.getOutputStream()) {
                os.write(body.getBytes(StandardCharsets.UTF_8));
            }

            int statusCode = conn.getResponseCode();
            if (statusCode == 200) {
                return new TestResult(true, "Connection Successful ✓");
            }

            // Inspect error response safely
            String errDetail = "";
            try (InputStream es = conn.getErrorStream()) {
                if (es != null) {
                    try (BufferedReader br = new BufferedReader(new InputStreamReader(es, StandardCharsets.UTF_8))) {
                        StringBuilder sb = new StringBuilder();
                        String line;
                        while ((line = br.readLine()) != null) sb.append(line);
                        String s = sb.toString();
                        if (s.contains("API_KEY_INVALID") || s.contains("API key not valid")) {
                            errDetail = "Invalid API key (Google returned API_KEY_INVALID)";
                        } else if (s.contains("RESOURCE_EXHAUSTED")) {
                            errDetail = "Quota exceeded (RESOURCE_EXHAUSTED)";
                        }
                    }
                }
            } catch (Exception ignored) {}

            if (!errDetail.isEmpty()) {
                return new TestResult(false, "Connection Failed: " + errDetail);
            } else if (statusCode == 400) {
                return new TestResult(false, "Connection Failed: Invalid request or API key format (HTTP 400)");
            } else if (statusCode == 403 || statusCode == 401) {
                return new TestResult(false, "Connection Failed: Invalid API key or unauthorized (HTTP " + statusCode + ")");
            } else if (statusCode == 429) {
                return new TestResult(false, "Connection Failed: Rate limit / quota exceeded (HTTP 429)");
            } else if (statusCode == 404) {
                return new TestResult(false, "Connection Failed: Model endpoint not found (HTTP 404)");
            } else {
                return new TestResult(false, "Connection Failed: Gemini returned HTTP status " + statusCode);
            }
        } catch (java.net.SocketTimeoutException e) {
            return new TestResult(false, "Connection Failed: Network request timed out");
        } catch (IOException e) {
            return new TestResult(false, "Connection Failed: Network error or Gemini service unreachable");
        } catch (Exception e) {
            return new TestResult(false, "Connection Failed: Unexpected error during test");
        } finally {
            if (conn != null) {
                try { conn.disconnect(); } catch (Exception ignored) {}
            }
        }
    }

    /**
     * Normalizes service type string to the standard environment variable name.
     */
    public static String normalizeServiceType(String serviceType) {
        if (serviceType == null) return null;
        String s = serviceType.trim().toUpperCase().replace("-", "_").replace(" ", "_");
        if (s.contains("INTERVIEW")) {
            return ENV_INTERVIEW_KEY;
        } else if (s.contains("CODE") || s.contains("ANALYZER_AI")) {
            return ENV_CODE_KEY;
        } else if (s.contains("RESUME")) {
            return ENV_RESUME_KEY;
        }
        return null;
    }

    public static String getConfigStatus() {
        return "INTERVIEW_AI=" + (isInterviewAIConfigured() ? "CONFIGURED (" + getMaskedInterviewKey() + ")" : "MISSING") +
               " | CODE_ANALYZER=" + (isCodeAnalyzerConfigured() ? "CONFIGURED (" + getMaskedCodeAnalyzerKey() + ")" : "MISSING") +
               " | RESUME_ANALYZER=" + (isResumeAnalyzerConfigured() ? "CONFIGURED (" + getMaskedResumeAnalyzerKey() + ")" : "MISSING");
    }
}
