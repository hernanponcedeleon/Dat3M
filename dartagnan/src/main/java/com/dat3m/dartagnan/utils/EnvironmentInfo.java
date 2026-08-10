package com.dat3m.dartagnan.utils;

import com.dat3m.dartagnan.Dartagnan;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.io.InputStream;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.Properties;

public class EnvironmentInfo  {

    private static final Logger logger = LoggerFactory.getLogger(EnvironmentInfo .class);

    private final static Properties properties = new Properties();

    public static void initEnvironmentInfo () {
        try (InputStream is = Dartagnan.class.getClassLoader()
                .getResourceAsStream("git.properties")) {
            if (is != null) {
                properties.load(is);
                return;
            }
        } catch (IOException e) {
            logger.warn("Failed to load git.properties");
        }
    }

    public static void logEnvironmentInfo () {
        logger.info("Git branch: {}", properties.getProperty("git.branch", "unknown"));
        logger.info("Git commit ID: {}", properties.getProperty("git.commit.id", "unknown"));
        logger.info("OS info: {}", getOSInfo());
        logger.info("Clang version: {}", getClangInfo());
    }

    public static String getGitId() {
        return properties.getProperty("git.commit.id", "unknown");
    }

    public static String getGitTags() {
        return properties.getProperty("git.tags", "unknown");
    }

    private static String getOSInfo() {
        return String.format("%s-%s-%s",
                System.getProperty("os.name"),
                System.getProperty("os.arch"),
                System.getProperty("os.version"));
    }

    private static String getClangInfo() {
        try {
            ProcessBuilder pb = new ProcessBuilder("clang", "--version");
            Process process = pb.start();
            try (BufferedReader reader = new BufferedReader(
                    new InputStreamReader(process.getInputStream()))) {
                String firstLine = reader.readLine();
                return (firstLine != null) ? firstLine : "unknown";
            }
        } catch (IOException e) {
            String errorMsg = "Clang not detected or not in PATH";
            logger.warn("Failed to retrieve clang version: {}", errorMsg, e);
            return "unknown";
        }
    }
}
