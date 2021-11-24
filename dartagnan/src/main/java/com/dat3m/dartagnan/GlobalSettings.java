package com.dat3m.dartagnan;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.*;

@Options
public class GlobalSettings {

    private static final Logger logger = LogManager.getLogger(GlobalSettings.class);

    private static GlobalSettings instance;

    public static GlobalSettings getInstance() {
        if (instance == null) {
            try {
                initializeFromConfig(Configuration.defaultConfiguration());
            } catch (InvalidConfigurationException ex) {
                // We expect this to never happen for a default config
                logger.error(ex.getMessage());
                throw new RuntimeException(ex);
            }
        }
        return instance;
    }

    public static void initializeFromConfig(Configuration config) throws InvalidConfigurationException {
        instance = new GlobalSettings(config);
    }

    private GlobalSettings(Configuration config) throws InvalidConfigurationException {
        config.inject(this);
    }

    // =========================== Configurables ===========================

    @Option(name = "program.parsing.atomicBlocksAsLocks",
            description = "Transforms atomic blocks by adding global locks.",
            secure = true)
    private boolean shouldParseAtomicBlockAsLocks = false;

    public boolean shouldParseAtomicBlockAsLocks() { return shouldParseAtomicBlockAsLocks; }
    public void setShouldParseAtomicBlockAsLocks(boolean value) { shouldParseAtomicBlockAsLocks = value; }

    @Option(name = "encoding.enableSymmetryBreaking",
            description = "Adds a symmetry breaking formula to the encoding. " +
                    "This is unsound if the program contains assertions that distinguish symmetric threads.",
            secure = true)
    private boolean symmetryBreakingEnabled = false;

    public boolean isSymmetryBreakingEnabled() { return symmetryBreakingEnabled ; }
    public void setIsSymmetryBreakingEnabled(boolean value) { symmetryBreakingEnabled  = value; }

    //TODO: The following options get replaced when the new Refinement branch gets merged.
    @Option(name = "refinement.assumeLocallyConsistentWMM",
            description = "Refinement will start from a locally consistent baseline WMM instead of the empty one.",
            secure = true)
    private boolean shouldRefinementUseLocallyConsistentBaselineWmm = false;

    public boolean shouldRefinementUseLocallyConsistentBaselineWMM() { return shouldRefinementUseLocallyConsistentBaselineWmm; }
    public void setShouldRefinementUseLocallyConsistentBaselineWMM(boolean value) { shouldRefinementUseLocallyConsistentBaselineWmm = value; }

    @Option(name = "refinement.assumeNoOOTA",
            description = "Refinement will start from a baseline WMM that does not allow Out-Of-Thin-Air behaviour.",
            secure = true)
    private boolean shouldRefinementUseNoOOTABaselineWMM = false;

    public boolean shouldRefinementUseNoOOTABaselineWMM() { return shouldRefinementUseNoOOTABaselineWMM; }
    public void setShouldRefinementUseNoOOTABaselineWMM(boolean value) { shouldRefinementUseNoOOTABaselineWMM = value; }


    public enum SymmetryLearning { NONE, LINEAR, QUADRATIC, FULL }
    @Option(name = "refinement.symmetryLearning",
            description = "Refinement will learn symmetries if possible.",
            secure = true,
            toUppercase = true)
    private SymmetryLearning refinementSymmetryLearning = SymmetryLearning.FULL;

    public SymmetryLearning getRefinementSymmetryLearning() { return refinementSymmetryLearning; }
    public void setRefinementSymmetryLearning(SymmetryLearning value) { refinementSymmetryLearning = value; }

    @Option(name = "saturation.enableDebug",
            description = "Enables debugging of the Saturation algorithm.",
            secure = true)
    private boolean saturationDebugEnabled = false;

    public boolean isSaturationDebugEnabled() { return saturationDebugEnabled; }
    public void setIsSaturationDebugEnabled(boolean value) { saturationDebugEnabled = value; }


    @Option(name = "saturation.maxDepth",
            description = "Sets the maximal saturation depth.",
            secure = true)
    @IntegerOption(min = 0)
    private int saturationMaxDepth = 3;

    public int getSaturationMaxDepth() { return saturationMaxDepth; }
    public void setSaturationMaxDepth(int value) { saturationMaxDepth = value; }

    //TODO: End of options that will be replaced

    // TODO: This option does not need to be exposed. Setting some value we are comfortable with should be enough.
    @Option(name = "general.maxRecursion",
            description = "Sets the maximal recursion depth before the call stack gets cleared." +
                    "A high limit may cause stack overflow exceptions.",
            secure = true)
    @IntegerOption(min = 1)
    private int maxRecursionDepth = 200;

    public int getMaxRecursionDepth() { return maxRecursionDepth; }
    public void setMaxRecursionDepth(int value) { maxRecursionDepth = value; }

    @Option(name = "program.debugPrint",
            description = "Prints the program after all processing steps and before verification for debug purposes.",
            secure = true)
    private boolean shouldDebugPrintProgram = false;

    public boolean shouldDebugPrintProgram () { return shouldDebugPrintProgram ; }
    public void setShouldDebugPrintProgram(boolean value) { shouldDebugPrintProgram  = value; }

    // =====================================================================

    public static void log() {
        getInstance().logPrivate();
    }

    private void logPrivate() {
        //TODO: This is temporary code that will get removed once all
        // options are moved to their appropriate classes
        logger.info("ATOMIC_AS_LOCK: " + shouldParseAtomicBlockAsLocks);
        logger.info("ENABLE_SYMMETRY_BREAKING: " + symmetryBreakingEnabled);
        logger.info("MAX_RECURSION_DEPTH: " + maxRecursionDepth);
        logger.info("ENABLE_DEBUG_OUTPUT: " + shouldDebugPrintProgram);

        // Refinement settings
        logger.info("REFINEMENT_USE_LOCALLY_CONSISTENT_BASELINE_WMM: " + shouldRefinementUseLocallyConsistentBaselineWmm);
        logger.info("REFINEMENT_ADD_ACYCLIC_DEP_RF: " + shouldRefinementUseNoOOTABaselineWMM);
        logger.info("REFINEMENT_SYMMETRY_LEARNING: " + refinementSymmetryLearning.name());

        // Saturation settings
        logger.info("SATURATION_ENABLE_DEBUG: " + saturationDebugEnabled);
        logger.info("SATURATION_MAX_DEPTH: " + saturationMaxDepth);
    }

}
