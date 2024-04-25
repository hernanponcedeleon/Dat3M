package com.dat3m.dartagnan.utils;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.dat3m.dartagnan.Dartagnan;

public class GitInfo {

    private static final Logger logger = LogManager.getLogger(Dartagnan.class);

    static Properties properties = new Properties();

    public static void CreateGitInfo() throws IOException {
        try (InputStream is = Dartagnan.class.getClassLoader()
                .getResourceAsStream("git.properties")) {
            if (is == null) {
                return;
            }
            properties.load(is);
            logger.info("Git branch: " + properties.getProperty("git.branch"));
            logger.info("Git commit ID: " + properties.getProperty("git.commit.id"));
        }
    }

    public static String getGitId() throws IOException {
        try (InputStream is = Dartagnan.class.getClassLoader()
                .getResourceAsStream("git.properties")) {
            if (is == null) {
                return "unknown";
            }
            properties.load(is);
            return properties.getProperty("git.commit.id");
        }
    }

}
