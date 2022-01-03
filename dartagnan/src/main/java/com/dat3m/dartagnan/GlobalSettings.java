package com.dat3m.dartagnan;

import com.dat3m.dartagnan.solver.caat4wmm.Refiner;
import com.dat3m.dartagnan.wmm.relation.RelationNameRepository;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class GlobalSettings {


	private static final Logger logger = LogManager.getLogger(GlobalSettings.class);

    // === Parsing ===
    public static final boolean ATOMIC_AS_LOCK = false;

    // ------ Symm breaking ------
    public static final boolean ENABLE_SYMMETRY_BREAKING = true;
    public static final boolean BREAK_SYMMETRY_BY_SYNC_DEGREE = true;
    public static final String BREAK_SYMMETRY_ON_RELATION = RelationNameRepository.RF;
    public static final int LEX_LEADER_SIZE = 1000;

    // === Static analysis ===
    public static final boolean REDUCE_ACYCLICITY_ENCODE_SETS = true;

    // ==== Refinement ====
    /*
        This option causes Refinement to generate many .dot and .png files
        that describe EACH iteration. It is very expensive and should only be used
        for debugging purposes
    */
    public static final boolean REFINEMENT_GENERATE_GRAPHVIZ_DEBUG_FILES = false;

    public static final Refiner.SymmetryLearning REFINEMENT_SYMMETRY_LEARNING = Refiner.SymmetryLearning.FULL;

    // --------------------

    // === Recursion depth ===
    public static final int MAX_RECURSION_DEPTH = 200;

    public static void LogGlobalSettings() {
        // General settings
    	logger.info("ATOMIC_AS_LOCK: " + ATOMIC_AS_LOCK);
    	logger.info("ENABLE_SYMMETRY_BREAKING: " + ENABLE_SYMMETRY_BREAKING);
    	if (ENABLE_SYMMETRY_BREAKING) {
            logger.info("-- Breaking on Relation: " + BREAK_SYMMETRY_ON_RELATION);
            logger.info("-- Break by sync-degree: " + BREAK_SYMMETRY_BY_SYNC_DEGREE);
            logger.info("-- Lex leader size: " + LEX_LEADER_SIZE);
        }
    	logger.info("MAX_RECURSION_DEPTH: " + MAX_RECURSION_DEPTH);

    	// Refinement settings
        logger.info("REFINEMENT_GENERATE_GRAPHVIZ_DEBUG_FILES: " + REFINEMENT_GENERATE_GRAPHVIZ_DEBUG_FILES);
    	logger.info("REFINEMENT_SYMMETRY_LEARNING: " + REFINEMENT_SYMMETRY_LEARNING.name());
    }
}
