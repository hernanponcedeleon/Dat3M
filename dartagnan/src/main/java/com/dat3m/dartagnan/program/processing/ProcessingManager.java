package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.processing.compilation.Compilation;
import com.dat3m.dartagnan.utils.printer.Printer;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Objects;

import static com.dat3m.dartagnan.configuration.OptionNames.*;

@Options
public class ProcessingManager implements ProgramProcessor {

    private final List<ProgramProcessor> programProcessors = new ArrayList<>();

    // =========================== Configurables ===========================

    @Option(name = REDUCE_SYMMETRY,
            description = "Reduces the symmetry of the program (unsound in general).",
            secure = true)
    private boolean reduceSymmetry = false;

    @Option(name = CONSTANT_PROPAGATION,
            description = "Performs constant propagation.",
            secure = true)
    private boolean constantPropagation = true;

    @Option(name = DEAD_ASSIGNMENT_ELIMINATION,
            description = "Performs dead code elimination.",
            secure = true)
    private boolean dce = true;

    @Option(name = DYNAMIC_SPINLOOP_DETECTION,
            description = "Instruments loops to terminate early when spinning.",
            secure = true)
    private boolean dynamicSpinLoopDetection = true;

    // =================== Debugging options ===================

    @Option(name = PRINT_PROGRAM_BEFORE_PROCESSING,
            description = "Prints the program before any processing.",
            secure = true)
    private boolean printBeforeProcessing = false;

    @Option(name = PRINT_PROGRAM_AFTER_SIMPLIFICATION,
            description = "Prints the program after simplification.",
            secure = true)
    private boolean printAfterSimplification = false;

    @Option(name = PRINT_PROGRAM_AFTER_COMPILATION,
            description = "Prints the program after compilation.",
            secure = true)
    private boolean printAfterCompilation = false;

    @Option(name = PRINT_PROGRAM_AFTER_UNROLLING,
            description = "Prints the program after unrolling.",
            secure = true)
    private boolean printAfterUnrolling = false;

    @Option(name = PRINT_PROGRAM_AFTER_PROCESSING,
            description = "Prints the program after all processing.",
            secure = true)
    private boolean printAfterProcessing = false;


// ======================================================================

    private ProcessingManager(Configuration config) throws InvalidConfigurationException {
        config.inject(this);
        final Intrinsics intrinsics = Intrinsics.fromConfig(config);
        final FunctionProcessor sccp = constantPropagation ? SparseConditionalConstantPropagation.fromConfig(config) : null;
        programProcessors.addAll(Arrays.asList(
                printBeforeProcessing ? DebugPrint.withHeader("Before processing", Printer.Mode.ALL) : null,
                intrinsics.markIntrinsicsPass(),
                GEPToAddition.newInstance(),
                NaiveDevirtualisation.newInstance(),
                Inlining.fromConfig(config),
                ProgramProcessor.fromFunctionProcessor(
                        FunctionProcessor.chain(
                                intrinsics.earlyInliningPass(),
                                UnreachableCodeElimination.fromConfig(config),
                                ComplexBlockSplitting.newInstance(),
                                BranchReordering.fromConfig(config),
                                Simplifier.fromConfig(config)
                        ), Target.FUNCTIONS, true
                ),
                RegisterDecomposition.newInstance(),
                RemoveDeadFunctions.newInstance(),
                printAfterSimplification ? DebugPrint.withHeader("After simplification", Printer.Mode.ALL) : null,
                LoopFormVerification.fromConfig(config),
                Compilation.fromConfig(config), // We keep compilation global for now
                printAfterCompilation ? DebugPrint.withHeader("After compilation", Printer.Mode.ALL) : null,
                ProgramProcessor.fromFunctionProcessor(MemToReg.fromConfig(config), Target.FUNCTIONS, true),
                ProgramProcessor.fromFunctionProcessor(sccp, Target.FUNCTIONS, false),
                dynamicSpinLoopDetection ? DynamicSpinLoopDetection.fromConfig(config) : null,
                LoopUnrolling.fromConfig(config), // We keep unrolling global for now
                printAfterUnrolling ? DebugPrint.withHeader("After loop unrolling", Printer.Mode.ALL) : null,
                ProgramProcessor.fromFunctionProcessor(
                        FunctionProcessor.chain(
                                ResolveLLVMObjectSizeCalls.fromConfig(config),
                                sccp,
                                dce ? DeadAssignmentElimination.fromConfig(config) : null,
                                RemoveDeadCondJumps.fromConfig(config)
                        ), Target.FUNCTIONS, true
                ),
                ThreadCreation.fromConfig(config),
                reduceSymmetry ? SymmetryReduction.fromConfig(config) : null,
                intrinsics.lateInliningPass(),
                RemoveUnusedMemory.newInstance(),
                ProgramProcessor.fromFunctionProcessor(MemToReg.fromConfig(config), Target.THREADS, true),
                MemoryAllocation.newInstance(),
                // --- Statistics + verification ---
                IdReassignment.newInstance(), // Normalize used Ids (remove any gaps)
                printAfterProcessing ? DebugPrint.withHeader("After processing", Printer.Mode.THREADS) : null,
                ProgramProcessor.fromFunctionProcessor(
                        CoreCodeVerification.fromConfig(config),
                        Target.THREADS, false
                ),
                LogThreadStatistics.newInstance()
        ));
        programProcessors.removeIf(Objects::isNull);
    }

    public static ProcessingManager fromConfig(Configuration config) throws InvalidConfigurationException {
        return new ProcessingManager(config);
    }

    // ==================================================

    public void run(Program program) {
        programProcessors.forEach(p -> p.run(program));
    }


}