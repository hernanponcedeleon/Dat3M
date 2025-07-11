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
    private boolean performDce = true;

    @Option(name = ASSIGNMENT_INLINING,
            description = "Performs inlining of assignments that are used only once to avoid intermediary variables.",
            secure = true)
    private boolean performAssignmentInlining = true;

    @Option(name = DYNAMIC_SPINLOOP_DETECTION,
            description = "Instruments loops to terminate early when spinning.",
            secure = true)
    private boolean dynamicSpinLoopDetection = true;

    @Option(name = MIXED_SIZE,
            description = "If 'true', checks for mixed-size and misaligned memory accesses." +
                    " This also enables a subsequent program transformation to handle these events." +
                    " Otherwise, assumes that no such accesses happen in any execution." +
                    " Defaults to 'false'.",
            secure = true)
    private boolean detectMixedSizeAccesses = false;

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
        final Intrinsics intrinsics = Intrinsics.fromConfig(config, detectMixedSizeAccesses);
        final FunctionProcessor sccp = constantPropagation ? SparseConditionalConstantPropagation.fromConfig(config) : null;
        final FunctionProcessor dce = performDce ? DeadAssignmentElimination.fromConfig(config) : null;
        final FunctionProcessor assignmentInlining = performAssignmentInlining ? AssignmentInlining.newInstance() : null;
        final FunctionProcessor removeDeadJumps = RemoveDeadCondJumps.fromConfig(config);
        final FunctionProcessor simplifyFunction = FunctionProcessor.chain(
                assignmentInlining,
                sccp,
                dce,
                removeDeadJumps
        );
        final ProgramProcessor simplifyBoundedProgram = ProgramProcessor.fromFunctionProcessor(
                simplifyFunction, Target.THREADS, true
        );
        programProcessors.addAll(Arrays.asList(
                printBeforeProcessing ? DebugPrint.withHeader("Before processing", Printer.Mode.ALL) : null,
                intrinsics.markIntrinsicsPass(),
                ProgramProcessor.fromFunctionProcessor(intrinsics.earlyInliningPass(), Target.ALL, true),
                GEPToAddition.newInstance(),
                NaiveDevirtualisation.newInstance(),
                Inlining.fromConfig(config),
                ProgramProcessor.fromFunctionProcessor(
                        FunctionProcessor.chain(
                                UnreachableCodeElimination.fromConfig(config),
                                ComplexBlockSplitting.newInstance(),
                                BranchReordering.fromConfig(config),
                                Simplifier.fromConfig(config)
                        ), Target.ALL, true
                ),
                ProgramProcessor.fromFunctionProcessor(NormalizeLoops.newInstance(), Target.ALL, true),
                RemoveDeadFunctions.newInstance(),
                printAfterSimplification ? DebugPrint.withHeader("After simplification", Printer.Mode.ALL) : null,
                Compilation.fromConfig(config), // We keep compilation global for now
                LoopFormVerification.fromConfig(config),
                printAfterCompilation ? DebugPrint.withHeader("After compilation", Printer.Mode.ALL) : null,
                ProgramProcessor.fromFunctionProcessor(MemToReg.fromConfig(config), Target.FUNCTIONS, true),
                ProgramProcessor.fromFunctionProcessor(sccp, Target.FUNCTIONS, false),
                dynamicSpinLoopDetection ? DynamicSpinLoopDetection.fromConfig(config) : null,
                ProgramProcessor.fromFunctionProcessor(NaiveLoopBoundAnnotation.fromConfig(config), Target.FUNCTIONS, true),
                LoopUnrolling.fromConfig(config), // We keep unrolling global for now
                printAfterUnrolling ? DebugPrint.withHeader("After loop unrolling", Printer.Mode.ALL) : null,
                ProgramProcessor.fromFunctionProcessor(
                        FunctionProcessor.chain(
                                ResolveLLVMObjectSizeCalls.fromConfig(config),
                                simplifyFunction
                        ), Target.FUNCTIONS, true
                ),
                ThreadCreation.fromConfig(config),
                ResolveNonDetChoices.newInstance(),
                reduceSymmetry ? SymmetryReduction.fromConfig(config) : null,
                intrinsics.lateInliningPass(),
                ProgramProcessor.fromFunctionProcessor(
                        FunctionProcessor.chain(
                                RemoveDeadNullChecks.newInstance(),
                                MemToReg.fromConfig(config)
                        ), Target.THREADS, true
                ),
                simplifyBoundedProgram,
                RemoveUnusedMemory.newInstance(),
                MemoryAllocation.fromConfig(config),
                detectMixedSizeAccesses ? Tearing.fromConfig(config) : null,
                detectMixedSizeAccesses ? simplifyBoundedProgram : null,
                NonterminationDetection.fromConfig(config),
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