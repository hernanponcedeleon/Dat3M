package com.dat3m.dartagnan;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.Path;

public class GlobalSettings {

    private static final Logger logger = LoggerFactory.getLogger(GlobalSettings.class);

    private GlobalSettings() {}

    private static final boolean USE_TEST_PATH = isJUnitTest();

    // --------------------

    public static Path getHomeDirectory() {
        return getHomeDirectory(false);
    }

    public static Path getHomeDirectory(boolean skipUnitTestCheck) {
        if (USE_TEST_PATH && !skipUnitTestCheck) {
            return Path.of("target");
        }
        String env = System.getenv("DAT3M_HOME");
        if (env == null) {
            logger.warn("Environment variable DAT3M_HOME not set. Default to empty path.");
            return Path.of("");
        }
        return Path.of(env);
    }

    public static Path getCatDirectory() {
        return getCatDirectory(false);
    }

    public static Path getCatDirectory(boolean skipUnitTestCheck) {
        if (USE_TEST_PATH && !skipUnitTestCheck) {
            return Path.of("..", "cat");
        }
        return getHomeDirectory(skipUnitTestCheck).resolve("cat");
    }

    public static Path getOrCreateOutputDirectory() throws IOException {
        Path path = getOutputDirectory();
        Files.createDirectories(path);
        return path;
    }

    public static Path getOutputDirectory() {
        return getOutputDirectory(false);
    }

    public static Path getOutputDirectory(boolean skipUnitTestCheck) {
        if (USE_TEST_PATH && !skipUnitTestCheck) {
            return Path.of("target", "output");
        }
        String env = System.getenv("DAT3M_OUTPUT");
        if (env != null) {
            return Path.of(env);
        }
        return getHomeDirectory(skipUnitTestCheck).resolve("output");
    }

    public static Path getLibraryDirectory() {
        return getHomeDirectory()
                .resolve("dartagnan")
                .resolve("target")
                .resolve("libs");
    }

    public static Path getExecutablePath(boolean jar) {
        return getHomeDirectory(true)
                .resolve("dartagnan")
                .resolve("target")
                .resolve(jar ? "dartagnan.jar" : "dartagnan");
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
