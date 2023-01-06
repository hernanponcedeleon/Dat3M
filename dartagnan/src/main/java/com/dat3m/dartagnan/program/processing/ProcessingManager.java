package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.memory.Memory;
import com.dat3m.dartagnan.program.processing.compilation.Compilation;
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

    @Option(name= CONSTANT_PROPAGATION,
        description="Performs constant propagation.",
        secure=true)
        private boolean constantPropagation = false;

	@Option(name= DEAD_ASSIGNMENT_ELIMINATION,
			description="Performs dead code elimination.",
			secure=true)
		private boolean dce = false;

    @Option(name= DYNAMIC_PURE_LOOP_CUTTING,
            description="Instruments loops to terminate early when spinning.",
            secure=true)
    private boolean dynamicPureLoopCutting = true;

// ======================================================================

    private ProcessingManager(Configuration config) throws InvalidConfigurationException {
        config.inject(this);

        programProcessors.addAll(Arrays.asList(
                Memory.fixateMemoryValues(),
                UnreachableCodeElimination.fromConfig(config),
                BranchReordering.fromConfig(config),
                LoopFormVerification.fromConfig(config),
                Simplifier.fromConfig(config),
        		FindSpinLoops.fromConfig(config),
                LoopUnrolling.fromConfig(config),
                constantPropagation ? ConstantPropagation.fromConfig(config) : null,
                dce ? DeadAssignmentElimination.fromConfig(config) : null,
                RemoveDeadCondJumps.fromConfig(config),
                Compilation.fromConfig(config),
                dynamicPureLoopCutting ? DynamicPureLoopCutting.fromConfig(config) : null,
                reduceSymmetry ? SymmetryReduction.fromConfig(config) : null
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