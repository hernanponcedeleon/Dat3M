package com.dat3m.dartagnan;

import com.dat3m.dartagnan.solver.caat4wmm.Refiner;
import com.dat3m.dartagnan.wmm.relation.RelationNameRepository;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import static com.dat3m.dartagnan.verification.RefinementTask.BaselineWMM.EMPTY;

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
    public static final boolean REDUCE_ACYCLICITY_ENCODE_SETS = true;
    public static final boolean COMPUTE_MUSTNOT_SETS = true;

    // ------ Symm breaking ------
    public static final boolean ENABLE_SYMMETRY_BREAKING = true;
    public static final boolean BREAK_SYMMETRY_BY_SYNC_DEGREE = true;
    public static final String BREAK_SYMMETRY_ON_RELATION = RelationNameRepository.RF;
    public static final int LEX_LEADER_SIZE = 1000;

    // === BranchEquivalence ===
    public static final boolean MERGE_BRANCHES = true;
    public static final boolean ALWAYS_SPLIT_ON_JUMP = false;

    // === Static analysis ===
    public static final boolean PERFORM_DEAD_CODE_ELIMINATION = true;
    public static final boolean PERFORM_REORDERING = true;
    public static final boolean DETERMINISTIC_REORDERING = true;
    public static final boolean ENABLE_SYMMETRY_REDUCTION = true;

    // ==== Refinement ====
    /*
        This option causes Refinement to generate many .dot and .png files
        that describe EACH iteration. It is very expensive and should only be used
        for debugging purposes
    */
    public static final boolean REFINEMENT_GENERATE_GRAPHVIZ_DEBUG_FILES = false;

    public static final int REFINEMENT_BASELINE_WMM = EMPTY;
    public static final Refiner.SymmetryLearning REFINEMENT_SYMMETRY_LEARNING = Refiner.SymmetryLearning.FULL;

    // --------------------

    // === Recursion depth ===
    public static final int MAX_RECURSION_DEPTH = 200;

    // === Debug ===
    public static final boolean ENABLE_DEBUG_OUTPUT = false;

    // === Testing ===
    public static final boolean SKIP_TIMINGOUT_LITMUS = false;

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
    	if (ENABLE_SYMMETRY_BREAKING) {
            logger.info("-- Breaking on Relation: " + BREAK_SYMMETRY_ON_RELATION);
            logger.info("-- Break by sync-degree: " + BREAK_SYMMETRY_BY_SYNC_DEGREE);
            logger.info("-- Lex leader size: " + LEX_LEADER_SIZE);
        }
        logger.info("ENABLE_SYMMETRY_REDUCTION: " + ENABLE_SYMMETRY_REDUCTION);
    	logger.info("MAX_RECURSION_DEPTH: " + MAX_RECURSION_DEPTH);
    	logger.info("ENABLE_DEBUG_OUTPUT: " + ENABLE_DEBUG_OUTPUT);

    	// Refinement settings
        logger.info("REFINEMENT_GENERATE_GRAPHVIZ_DEBUG_FILES: " + REFINEMENT_GENERATE_GRAPHVIZ_DEBUG_FILES);
    	logger.info("REFINEMENT_BASELINE_WMM: " + REFINEMENT_BASELINE_WMM);
    	logger.info("REFINEMENT_SYMMETRY_LEARNING: " + REFINEMENT_SYMMETRY_LEARNING.name());
    }
}
