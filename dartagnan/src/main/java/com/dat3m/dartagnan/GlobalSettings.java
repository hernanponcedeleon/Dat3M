package com.dat3m.dartagnan;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class GlobalSettings {
	
	private static final Logger logger = LogManager.getLogger(GlobalSettings.class);

    // === Parsing ===
    public static final boolean ATOMIC_AS_LOCK = false;

    // === WMM Assumptions ===
    public static final boolean ASSUME_LOCAL_CONSISTENCY = false;
    public static final boolean PERFORM_ATOMIC_BLOCK_OPTIMIZATION = true;

    // === Encoding ===
    public static final boolean FIXED_MEMORY_ENCODING = true;
    // NOTE: ALLOW_PARTIAL_MODELS does NOT work on Litmus tests due to their different assertion condition
    //TODO: This is not used right now. Some previous merge with the JavaSMT branch removed its usage
    // We will fix this later or remove this option completely.
    public static final boolean ALLOW_PARTIAL_MODELS = false;
    public static final boolean MERGE_CF_VARS = true; // ONLY has effect if ALLOW_PARTIAL_MODELS is 'false'
    public static final boolean ANTISYMM_CO = false;
    public static final boolean ENABLE_SYMMETRY_BREAKING = true;

    // === BranchEquivalence ===
    public static final boolean MERGE_BRANCHES = true;
    public static final boolean ALWAYS_SPLIT_ON_JUMP = false;

    // === Static analysis ===
    public static final boolean PERFORM_DEAD_CODE_ELIMINATION = true;
    public static final boolean PERFORM_REORDERING = true;
    public static final boolean DETERMINISTIC_REORDERING = true;
    public static final boolean ENABLE_SYMMETRY_REDUCTION = true;
    public static final boolean REDUCE_ACYCLICITY_ENCODE_SETS = true;

    // ==== Refinement ====
    public static final boolean REFINEMENT_USE_LOCALLY_CONSISTENT_BASELINE_WMM = true; // Uses acyclic(po-loc + rf) as baseline
    public static final boolean REFINEMENT_ADD_ACYCLIC_DEP_RF = false; // Only takes effect if USE_BASELINE_WMM is set to TRUE

    public enum SymmetryLearning { NONE, LINEAR, QUADRATIC, FULL }
    public static final SymmetryLearning REFINEMENT_SYMMETRY_LEARNING = SymmetryLearning.FULL;

    // ==== Saturation ====
    public static boolean SATURATION_ENABLE_DEBUG = false;
    public static final int SATURATION_MAX_DEPTH = 3;

    // --------------------

    // === Recursion depth ===
    public static final int MAX_RECURSION_DEPTH = 200;

    // === Debug ===
    public static final boolean ENABLE_DEBUG_OUTPUT = false;

    public static void LogGlobalSettings() {
        // General settings
    	logger.info("FIXED_MEMORY_ENCODING: " + FIXED_MEMORY_ENCODING);
    	logger.info("ATOMIC_AS_LOCK: " + ATOMIC_AS_LOCK);
    	logger.info("ASSUME_LOCAL_CONSISTENCY: " + ASSUME_LOCAL_CONSISTENCY);
    	logger.info("PERFORM_ATOMIC_BLOCK_OPTIMIZATION: " + PERFORM_ATOMIC_BLOCK_OPTIMIZATION);
    	logger.info("MERGE_CF_VARS: " + MERGE_CF_VARS);
    	logger.info("ALLOW_PARTIAL_MODELS: " + ALLOW_PARTIAL_MODELS);
    	logger.info("ANTISYMM_CO: " + ANTISYMM_CO);
    	logger.info("MERGE_BRANCHES: " + MERGE_BRANCHES);
    	logger.info("ALWAYS_SPLIT_ON_JUMP: " + ALWAYS_SPLIT_ON_JUMP);
    	logger.info("PERFORM_DEAD_CODE_ELIMINATION: " + PERFORM_DEAD_CODE_ELIMINATION);
    	logger.info("PERFORM_REORDERING: " + PERFORM_REORDERING);
    	logger.info("ENABLE_SYMMETRY_BREAKING: " + ENABLE_SYMMETRY_BREAKING);
        logger.info("ENABLE_SYMMETRY_REDUCTION: " + ENABLE_SYMMETRY_REDUCTION);
    	logger.info("MAX_RECURSION_DEPTH: " + MAX_RECURSION_DEPTH);
    	logger.info("ENABLE_DEBUG_OUTPUT: " + ENABLE_DEBUG_OUTPUT);

    	// Refinement settings
    	logger.info("REFINEMENT_USE_LOCALLY_CONSISTENT_BASELINE_WMM: " + REFINEMENT_USE_LOCALLY_CONSISTENT_BASELINE_WMM);
    	logger.info("REFINEMENT_ADD_ACYCLIC_DEP_RF: " + REFINEMENT_ADD_ACYCLIC_DEP_RF);
    	logger.info("REFINEMENT_SYMMETRY_LEARNING: " + REFINEMENT_SYMMETRY_LEARNING.name());

    	// Saturation settings
        logger.info("SATURATION_ENABLE_DEBUG: " + SATURATION_ENABLE_DEBUG);
        logger.info("SATURATION_MAX_DEPTH: " + SATURATION_MAX_DEPTH);
    }
}
