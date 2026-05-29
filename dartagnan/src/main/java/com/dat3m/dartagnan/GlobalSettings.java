package com.dat3m.dartagnan;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;

public class GlobalSettings {

    private static final Logger logger = LoggerFactory.getLogger(GlobalSettings.class);

    private GlobalSettings() {}

    private static final boolean USE_TEST_PATH = isJUnitTest();

    // --------------------

    public static String getHomeDirectory() {
        return getHomeDirectory(false);
    }

    public static String getHomeDirectory(boolean skipUnitTestCheck) {
        if (USE_TEST_PATH && !skipUnitTestCheck) {
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
        return getCatDirectory(false);
    }

    public static String getCatDirectory(boolean skipUnitTestCheck) {
        if (USE_TEST_PATH && !skipUnitTestCheck) {
            return "../cat";
        }
        String env = System.getenv("DAT3M_HOME");
        env = env == null ? "" : env;
        return env + "/cat";
    }

    public static String getOrCreateOutputDirectory() throws IOException {
        String path = getOutputDirectory();
        Files.createDirectories(Paths.get(path));
        return path;
    }

    public static String getOutputDirectory() {
        return getOutputDirectory(false);
    }

    public static String getOutputDirectory(boolean skipUnitTestCheck) {
        if (USE_TEST_PATH && !skipUnitTestCheck) {
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
