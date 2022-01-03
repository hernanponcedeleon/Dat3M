package com.dat3m.dartagnan.configuration;

public class OptionNames {

	// Base Options
	public static final String ANALYSIS = "analysis";
	public static final String METHOD = "method";
	public static final String SOLVER = "solver";
	public static final String TIMEOUT = "timeout";
	public static final String VALIDATE = "validate";

	// Wmm Options
	public static final String LOCAL_CONSISTENT = "wmm.localConsistent";
	
	// Program Processing Options
	public static final String BOUND = "program.processing.loopBound";
	public static final String TARGET = "program.processing.compilationTarget";
	public static final String DETREORDERING = "program.processing.detReordering";
	public static final String REDUCESYMMETRY = "program.processing.reduceSymmetry";
	public static final String ATOMICBLOCKSASLOCKS = "program.processing.atomicBlocksAsLocks";

	// Witness Options
	public static final String WITNESS_ORIGINAL_PROGRAM_PATH = "witness.originalProgramFilePath";
	
	// SVCOMP Options
	public static final String PROPERTY = "property";
	public static final String UMIN = "umin";
	public static final String UMAX = "umax";
	public static final String STEP = "step";
	public static final String SANITIZE = "sanitize";
}
