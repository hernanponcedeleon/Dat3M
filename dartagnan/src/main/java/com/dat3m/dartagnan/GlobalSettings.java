package com.dat3m.dartagnan;

import com.dat3m.dartagnan.solver.caat4wmm.coreReasoning.CoreReasoner;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Options;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;

@Options
public class GlobalSettings {

    private static final Logger logger = LogManager.getLogger(GlobalSettings.class);

    private GlobalSettings() {}

    private static final GlobalSettings instance = new GlobalSettings();

    public static void configure(Configuration config) throws InvalidConfigurationException {
       config.inject(instance);
    }

    // === Static analysis ===
    public static final boolean ALLOW_MULTIREADS = false; // Allows a read to have multiple rf-edges

    // ==== Refinement ====
    /*
        This option causes Refinement to generate many .dot and .png files
        that describe EACH iteration. It is very expensive and should only be used
        for debugging purposes
    */
    public static final boolean REFINEMENT_GENERATE_GRAPHVIZ_DEBUG_FILES = false;

    public static final CoreReasoner.SymmetricLearning REFINEMENT_SYMMETRIC_LEARNING = CoreReasoner.SymmetricLearning.FULL;

    private static final boolean USE_TEST_PATH = isJUnitTest();

    // --------------------

    public static void logGlobalSettings() {
        // Refinement settings
        logger.info("REFINEMENT_GENERATE_GRAPHVIZ_DEBUG_FILES: {}", REFINEMENT_GENERATE_GRAPHVIZ_DEBUG_FILES);
        logger.info("REFINEMENT_SYMMETRIC_LEARNING: {}", REFINEMENT_SYMMETRIC_LEARNING.name());
    }

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
