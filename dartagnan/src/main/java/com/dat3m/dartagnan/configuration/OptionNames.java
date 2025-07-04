package com.dat3m.dartagnan.configuration;

public class OptionNames {

    // Base Options
    public static final String PROPERTY = "property";
    public static final String BOUND = "bound";
    public static final String BOUNDS_LOAD_PATH = "bound.load";
    public static final String BOUNDS_SAVE_PATH = "bound.save";
    public static final String TARGET = "target";
    public static final String METHOD = "method";
    public static final String SOLVER = "solver";
    public static final String TIMEOUT = "timeout";
    public static final String VALIDATE = "validate";
    public static final String COVERAGE = "coverage";
    public static final String WITNESS = "witness";
    public static final String SMTLIB2 = "smtlib2";
    public static final String CAT_INCLUDE = "cat.include";
    public static final String MIXED_SIZE = "mixedSize";

    // Modeling Options
    public static final String PROGRESSMODEL = "modeling.progress";
    public static final String THREAD_CREATE_ALWAYS_SUCCEEDS = "modeling.threadCreateAlwaysSucceeds";
    public static final String RECURSION_BOUND = "modeling.recursionBound";
    public static final String MEMORY_IS_ZEROED = "modeling.memoryIsZeroed";
    public static final String INIT_DYNAMIC_ALLOCATIONS = "modeling.initDynamicAllocations";
    public static final String MULTI_READS = "modeling.multiReads";

    // Compilation Options
    public static final String USE_RC11_TO_ARCH_SCHEME = "compilation.rc11ToArch";
    public static final String C_TO_POWER_SCHEME = "compilation.cToPower";

    // Encoding Options
    public static final String USE_INTEGERS = "encoding.integers";
    public static final String ENABLE_ACTIVE_SETS = "encoding.activeSets";
    public static final String REDUCE_ACYCLICITY_ENCODE_SETS = "encoding.wmm.reduceAcyclicityEncodeSets";
    public static final String MERGE_CF_VARS = "encoding.mergeCFVars";
    public static final String INITIALIZE_REGISTERS = "encoding.initializeRegisters";
    public static final String IGNORE_FILTER_SPECIFICATION = "encoding.ignoreFilterSpecification";
    public static final String BREAK_SYMMETRY_ON = "encoding.symmetry.breakOn";
    public static final String BREAK_SYMMETRY_BY_SYNC_DEGREE = "encoding.symmetry.orderBySyncDegree";
    public static final String IDL_TO_SAT = "encoding.wmm.idl2sat";

    // Program Processing Options
    public static final String DETERMINISTIC_REORDERING = "program.processing.detReordering";
    public static final String REDUCE_SYMMETRY = "program.processing.reduceSymmetry";
    public static final String CONSTANT_PROPAGATION = "program.processing.constantPropagation";
    public static final String DEAD_ASSIGNMENT_ELIMINATION = "program.processing.dce";
    public static final String ASSIGNMENT_INLINING = "program.processing.assignmentInlining";
    public static final String DYNAMIC_SPINLOOP_DETECTION = "program.processing.spinloops";
    public static final String PROPAGATE_COPY_ASSIGNMENTS = "program.processing.propagateCopyAssignments";
    public static final String REMOVE_ASSERTION_OF_TYPE = "program.processing.skipAssertionsOfType";
    public static final String NONTERMINATION_INSTRUMENTATION = "program.processing.nonTermination";

    // Program Property Options
    public static final String REACHING_DEFINITIONS_METHOD = "program.analysis.reachingDefinitions";
    public static final String ALIAS_METHOD = "program.analysis.alias";
    public static final String ALIAS_GRAPHVIZ = "program.analysis.generateAliasGraph";
    public static final String ALIAS_GRAPHVIZ_SPLIT_BY_THREAD = "program.analysis.generateAliasGraph.splitByThread";
    public static final String ALIAS_GRAPHVIZ_SHOW_ALL = "program.analysis.generateAliasGraph.showAllEvents";
    public static final String ALIAS_GRAPHVIZ_INTERNAL = "program.analysis.generateAliasGraph.internal";
    public static final String ALWAYS_SPLIT_ON_JUMPS = "program.analysis.cf.alwaysSplitOnJump";
    public static final String MERGE_BRANCHES = "program.analysis.cf.mergeBranches";

    // Memory Model Options
    public static final String WMM_ATOMICITY = "wmm.analysis.assumeAtomicity";
    public static final String WMM_LOCALLY_CONSISTENT = "wmm.analysis.assumeLocalConsistency";
    public static final String RELATION_ANALYSIS = "wmm.analysis.relationAnalysis";
    public static final String ENABLE_EXTENDED_RELATION_ANALYSIS = "wmm.analysis.extendedRelationAnalysis";

    // Refinement Options
    public static final String BASELINE = "refinement.baseline";
    public static final String GRAPHVIZ_DEBUG_FILES = "refinement.generageGraphvizDebugFiles";
    public static final String SYMMETRIC_LEARNING = "refinement.symmetricLearning";

    // SMT solver Options
    public static final String PHANTOM_REFERENCES = "solver.z3.usePhantomReferences";

    // Witness Options
    public static final String WITNESS_ORIGINAL_PROGRAM_PATH = "witness.originalProgramFilePath";
    public static final String WITNESS_SHOW = "witness.show";

    // SVCOMP Options
    public static final String PROPERTYPATH = "svcomp.property";

    // Debugging Options
    public static final String PRINT_PROGRAM_BEFORE_PROCESSING = "printer.beforeProcessing";
    public static final String PRINT_PROGRAM_AFTER_SIMPLIFICATION = "printer.afterSimplification";
    public static final String PRINT_PROGRAM_AFTER_UNROLLING = "printer.afterUnrolling";
    public static final String PRINT_PROGRAM_AFTER_COMPILATION = "printer.afterCompilation";
    public static final String PRINT_PROGRAM_AFTER_PROCESSING = "printer.afterProcessing";
}