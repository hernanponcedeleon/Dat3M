package com.dat3m.dartagnan.utils;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.dat3m.dartagnan.Dartagnan;

public class GitInfo {

    private static final Logger logger = LogManager.getLogger(GitInfo.class);

    static Properties properties = new Properties();

    public static void initGitInfo() throws IOException {
        try (InputStream is = Dartagnan.class.getClassLoader()
                .getResourceAsStream("git.properties")) {
            if (is == null) {
                logger.warn("Failed to load git.properties");
                return;
            }
            properties.load(is);
        }
    }

    public static void logGitInfo() {
        logger.info("Git branch: " + properties.getProperty("git.branch", "unknown"));
        logger.info("Git commit ID: " + properties.getProperty("git.commit.id", "unknown"));
    }

    public static String getGitId() {
        return properties.getProperty("git.commit.id", "unknown");
    }

}
