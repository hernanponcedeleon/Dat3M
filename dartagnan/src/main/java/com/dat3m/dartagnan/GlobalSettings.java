package com.dat3m.dartagnan;

import com.dat3m.dartagnan.solver.caat4wmm.Refiner;

import static com.dat3m.dartagnan.configuration.OptionNames.ARCH_PRECISION;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

@Options
public class GlobalSettings {

    private static final Logger logger = LogManager.getLogger(GlobalSettings.class);

    private GlobalSettings() {}

    private static final GlobalSettings instance = new GlobalSettings();

    @Option(name = ARCH_PRECISION,
            description = "Integer encoding: use -1 for integer theory or X for bit-vectors with precision X.",
            secure = true)
    private int arch_precision = -1;

    public static int getArchPrecision() { return instance.arch_precision; }

    public static void configure(Configuration config) throws InvalidConfigurationException {
       config.inject(instance);
    }

    // === Parsing ===
    public static final boolean ATOMIC_AS_LOCK = false;

    // === Static analysis ===
    public static final boolean ALLOW_MULTIREADS = false; // Allows a read to have multiple rf-edges

    // ==== Refinement ====
    /*
        This option causes Refinement to generate many .dot and .png files
        that describe EACH iteration. It is very expensive and should only be used
        for debugging purposes
    */
    public static final boolean REFINEMENT_GENERATE_GRAPHVIZ_DEBUG_FILES = false;

    public static final Refiner.SymmetryLearning REFINEMENT_SYMMETRY_LEARNING = Refiner.SymmetryLearning.FULL;

    // --------------------

    public static void LogGlobalSettings() {
        // General settings
        logger.info("ARCH_PRECISION: " + getArchPrecision());
        logger.info("ATOMIC_AS_LOCK: " + ATOMIC_AS_LOCK);

        // Refinement settings
        logger.info("REFINEMENT_GENERATE_GRAPHVIZ_DEBUG_FILES: " + REFINEMENT_GENERATE_GRAPHVIZ_DEBUG_FILES);
        logger.info("REFINEMENT_SYMMETRY_LEARNING: " + REFINEMENT_SYMMETRY_LEARNING.name());
    }
}
