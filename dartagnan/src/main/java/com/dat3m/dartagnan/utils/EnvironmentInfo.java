package com.dat3m.dartagnan.utils;

import com.dat3m.dartagnan.Dartagnan;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.io.InputStream;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.Locale;
import java.util.List;
import java.util.Optional;
import java.util.Properties;
import java.util.Set;

public class EnvironmentInfo {

    public enum OperatingSystem {
        LINUX, MACOS, WINDOWS, OTHER
    }

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

    public static OperatingSystem getOperatingSystem() {
        final String name = System.getProperty("os.name", "").toLowerCase(Locale.ROOT);
        if (name.contains("linux")) {
            return OperatingSystem.LINUX;
        }
        if (name.contains("mac") || name.contains("darwin")) {
            return OperatingSystem.MACOS;
        }
        if (name.contains("windows")) {
            return OperatingSystem.WINDOWS;
        }
        return OperatingSystem.OTHER;
    }

    public static String getVersion() {
        final String version = properties.getProperty("git.build.version", "unknown");
        return version.equals(getGitTags()) ? version : String.format("%s (commit %s)", version, getGitId());
    }

    private static String getOSInfo() {
        return String.format("%s-%s-%s",
                System.getProperty("os.name"),
                System.getProperty("os.arch"),
                System.getProperty("os.version"));
    }

    private static Optional<String> getToolVersion(String tool) {
        try {
            for (String option : List.of("--version", "-version")) {
                ProcessBuilder pb = new ProcessBuilder(tool, option);
                pb.redirectErrorStream(true);
                Process process = pb.start();
                if (process.waitFor() != 0) {
                    continue;
                }
                try (BufferedReader reader = new BufferedReader(
                        new InputStreamReader(process.getInputStream()))) {
                    List<String> lines = reader.lines()
                            .map(String::trim)
                            .filter(line -> !line.isEmpty())
                            .toList();
                    if (!lines.isEmpty()) {
                        return Optional.of(String.join(" - ", lines));
                    }
                }
            }
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        } catch (IOException e) {
            // Tool not available.
        }
        return Optional.empty();
    }
}
