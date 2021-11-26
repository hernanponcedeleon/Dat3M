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

    // TODO: This option does not need to be exposed. Setting some value we are comfortable with should be enough.
    @Option(name = "general.maxRecursion",
            description = "Sets the maximal recursion depth before the call stack gets cleared." +
                    "A high limit may cause stack overflow exceptions.",
            secure = true)
    @IntegerOption(min = 1)
    private int maxRecursionDepth = 200;

    public int getMaxRecursionDepth() { return maxRecursionDepth; }
    public void setMaxRecursionDepth(int value) { maxRecursionDepth = value; }

    // =====================================================================

    public static void log() {
        getInstance().logPrivate();
    }

    private void logPrivate() {
        //TODO: This is temporary code that will get removed once all
        // options are moved to their appropriate classes
        logger.info("MAX_RECURSION_DEPTH: " + maxRecursionDepth);
    }

}
