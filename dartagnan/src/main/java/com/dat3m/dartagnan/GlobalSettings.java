package com.dat3m.dartagnan;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;

public class GlobalSettings {

    private static final Logger logger = LogManager.getLogger(GlobalSettings.class);

    private GlobalSettings() {}

    private static final boolean USE_TEST_PATH = isJUnitTest();

    // --------------------

    public static String getHomeDirectory() {
        if (USE_TEST_PATH) {
            return "target";
        }
        String env = System.getenv("DAT3M_HOME");
        if (env == null) {
            logger.warn("Environment variable DAT3M_HOME not set. Default to empty path.");
            return "";
        }
        return env;
    }

    public static String getCatDirectory() {
        if (USE_TEST_PATH) {
            return "../cat";
        }
        String env = System.getenv("DAT3M_HOME");
        env = env == null ? "" : env;
        return env + "/cat";
    }

    public static String getBoundsFile() {
        return getOutputDirectory() + "/bounds.csv";
    }

    public static String getOrCreateOutputDirectory() throws IOException {
        String path = getOutputDirectory();
        Files.createDirectories(Paths.get(path));
        return path;
    }

    public static String getOutputDirectory() {
        if (USE_TEST_PATH) {
            return "target/output";
        }
        String env = System.getenv("DAT3M_OUTPUT");
        if (env != null) {
            return env;
        }
        String home = getHomeDirectory();
        if (!home.isEmpty()) {
            return home + "/output";
        }
        return "output";
    }

    private static boolean isJUnitTest() {
        for (StackTraceElement element : Thread.currentThread().getStackTrace()) {
            if (element.getClassName().startsWith("org.junit.")) {
                return true;
            }
        }
        return false;
    }
}
