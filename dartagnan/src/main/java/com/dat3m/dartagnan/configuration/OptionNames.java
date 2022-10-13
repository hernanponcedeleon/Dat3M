package com.dat3m.dartagnan.configuration;

public class OptionNames {

	// Base Options
	public static final String PROPERTY = "property";
	public static final String BOUND = "bound";
	public static final String TARGET = "target";
	public static final String METHOD = "method";
	public static final String SOLVER = "solver";
	public static final String TIMEOUT = "timeout";
	public static final String VALIDATE = "validate";

	// Modeling Options
	public static final String THREAD_CREATE_ALWAYS_SUCCEEDS = "modeling.threadCreateAlwaysSucceeds";

	// Compilation Options
	public static final String USE_RC11_TO_ARCH_SCHEME = "compilation.rc11ToArch";
	public static final String C_TO_POWER_SCHEME = "compilation.cToPower";
	
	// Encoding Options
	public static final String LOCALLY_CONSISTENT = "encoding.locallyConsistent";
	public static final String MERGE_CF_VARS = "encoding.mergeCFVars";
	public static final String INITIALIZE_REGISTERS = "encoding.initializeRegisters";
	public static final String PRECISION = "encoding.precision";
	public static final String BREAK_SYMMETRY_ON = "encoding.symmetry.breakOn";
	public static final String BREAK_SYMMETRY_BY_SYNC_DEGREE = "encoding.symmetry.orderBySyncDegree";
	public static final String IDL_TO_SAT = "encoding.wmm.idl2sat";
	
	// Program Processing Options
	public static final String DETERMINISTIC_REORDERING = "program.processing.detReordering";
	public static final String REDUCE_SYMMETRY = "program.processing.reduceSymmetry";
	public static final String ATOMIC_BLOCKS_AS_LOCKS = "program.processing.atomicBlocksAsLocks";
	public static final String CONSTANT_PROPAGATION = "program.processing.constantPropagation";
	
	// Program Property Options
	public static final String ALIAS_METHOD = "program.analysis.alias";
	public static final String ALWAYS_SPLIT_ON_JUMPS = "program.analysis.cf.alwaysSplitOnJump";
	public static final String MERGE_BRANCHES = "program.analysis.cf.mergeBranches";

	// Refinement Options
	public static final String BASELINE = "refinement.baseline";
	
	// SMT solver Options
	public static final String PHANTOM_REFERENCES = "solver.z3.usePhantomReferences";

	// Witness Options
	public static final String WITNESS_ORIGINAL_PROGRAM_PATH = "witness.originalProgramFilePath";
	public static final String WITNESS_GRAPHVIZ = "witness.graphviz";

	// SVCOMP Options
	public static final String PROPERTYPATH = "svcomp.property";
	public static final String UMIN = "svcomp.umin";
	public static final String UMAX = "svcomp.umax";
	public static final String STEP = "svcomp.step";
	public static final String SANITIZE = "svcomp.sanitize";
	public static final String OPTIMIZATION = "svcomp.optimization";
	public static final String INTEGER_ENCODING = "svcomp.integerEncoding";

	// Debugging Options
	public static final String PRINT_PROGRAM_AFTER_SIMPLIFICATION = "printer.afterSimplification";
	public static final String PRINT_PROGRAM_AFTER_UNROLLING = "printer.afterUnrolling";
	public static final String PRINT_PROGRAM_AFTER_COMPILATION = "printer.afterCompilation";
}