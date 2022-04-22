package com.dat3m.dartagnan;

import com.dat3m.dartagnan.solver.caat4wmm.Refiner;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class GlobalSettings {


	private static final Logger logger = LogManager.getLogger(GlobalSettings.class);

    // === Encoding ===
	// This has to be in sync with whatever smack generated for references, 
	// i.e. if type ref = X, then ARCH_PRECISION = X (or -1 if type = intX). 
    public static final int ARCH_PRECISION = 64;

    // === Parsing ===
    public static final boolean ATOMIC_AS_LOCK = false;

    // === Static analysis ===
    public static final boolean REDUCE_ACYCLICITY_ENCODE_SETS = true;

    // ==== Refinement ====
    /*
        This option causes Refinement to generate many .dot and .png files
        that describe EACH iteration. It is very expensive and should only be used
        for debugging purposes
    */
    public static final boolean REFINEMENT_GENERATE_GRAPHVIZ_DEBUG_FILES = false;

    // This option causes Refinement to generate a .dot and a .png file with the final iteration.
    public static final boolean REFINEMENT_GENERATE_GRAPHVIZ_FINAL = true;

    public static final Refiner.SymmetryLearning REFINEMENT_SYMMETRY_LEARNING = Refiner.SymmetryLearning.FULL;

    // --------------------

    // === Recursion depth ===
    public static final int MAX_RECURSION_DEPTH = 200;

    public static void LogGlobalSettings() {
        // General settings
    	logger.info("ARCH_PRECISION: " + ARCH_PRECISION);
    	logger.info("ATOMIC_AS_LOCK: " + ATOMIC_AS_LOCK);
    	logger.info("MAX_RECURSION_DEPTH: " + MAX_RECURSION_DEPTH);

    	// Refinement settings
        logger.info("REFINEMENT_GENERATE_GRAPHVIZ_DEBUG_FILES: " + REFINEMENT_GENERATE_GRAPHVIZ_DEBUG_FILES);
    	logger.info("REFINEMENT_SYMMETRY_LEARNING: " + REFINEMENT_SYMMETRY_LEARNING.name());
    }
}
