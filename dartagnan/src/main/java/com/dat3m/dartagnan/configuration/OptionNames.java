package com.dat3m.dartagnan.configuration;

public class OptionNames {

	// Base Options
	public static final String ANALYSIS = "analysis";
	public static final String METHOD = "method";
	public static final String SOLVER = "solver";
	public static final String TIMEOUT = "timeout";
	public static final String VALIDATE = "validate";

	// Encoding Options
	public static final String LOCAL_CONSISTENT = "encoding.localConsistent";
	public static final String OPTION_ANTISYMMETRY = "encoding.antiSymmCo";

	// Program Processing Options
	public static final String BOUND = "program.processing.loopBound";
	public static final String TARGET = "program.processing.compilationTarget";
	public static final String DETERMINISTIC_REORDERING = "program.processing.detReordering";
	public static final String REDUCE_SYMMETRY = "program.processing.reduceSymmetry";
	public static final String ATOMIC_BLOCKS_AS_LOCKS = "program.processing.atomicBlocksAsLocks";

	// Program Analysis Options
	public static final String ALWAYS_SPLIT_ON_JUMPS = "program.analysis.cf.alwaysSplitOnJump";
	public static final String MERGE_BRANCHES = "program.analysis.cf.mergeBranches";

	// Refinement Options
	public static final String ASSUME_LOCALLY_CONSISTENT_WMM = "refinement.assumeLocallyConsistentWMM";
	public static final String ASSUME_NO_OOTA = "refinement.assumeNoOOTA";
	
	// Witness Options
	public static final String WITNESS_ORIGINAL_PROGRAM_PATH = "witness.originalProgramFilePath";
	
	// SVCOMP Options
	public static final String PROPERTY = "svcomp.property";
	public static final String UMIN = "svcomp.umin";
	public static final String UMAX = "svcomp.umax";
	public static final String STEP = "svcomp.step";
	public static final String SANITIZE = "svcomp.sanitize";
}
