package com.dat3m.dartagnan.utils;

import com.dat3m.dartagnan.Dartagnan;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.io.InputStream;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.List;
import java.util.Optional;
import java.util.Properties;
import java.util.Set;

public class EnvironmentInfo {

    private static final Logger logger = LoggerFactory.getLogger(EnvironmentInfo.class);

    private static final Properties properties = new Properties();

    public static void initEnvironmentInfo() {
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

    public static void logEnvironmentInfo(Set<String> tools) {
        logger.info("Git branch: {}", properties.getProperty("git.branch", "unknown"));
        logger.info("Git commit ID: {}", properties.getProperty("git.commit.id", "unknown"));
        logger.info("OS info: {}", getOSInfo());
        for (String tool : tools) {
            getToolVersion(tool).ifPresent(version -> logger.info("{} version: {}", tool, version));
        }
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

    private static Optional<String> getToolVersion(String tool) {
        try {
            ProcessBuilder pb = new ProcessBuilder(tool, "--version");
            Process process = pb.start();
            if (process.waitFor() != 0) {
                return Optional.empty();
            }
            try (BufferedReader reader = new BufferedReader(
                    new InputStreamReader(process.getInputStream()))) {
                List<String> lines = reader.lines()
                        .map(String::trim)
                        .filter(line -> !line.isEmpty())
                        .toList();
                return lines.isEmpty() ? Optional.empty() : Optional.of(String.join(" - ", lines));
            }
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            return Optional.empty();
        } catch (IOException e) {
            return Optional.empty();
        }
    }
}
