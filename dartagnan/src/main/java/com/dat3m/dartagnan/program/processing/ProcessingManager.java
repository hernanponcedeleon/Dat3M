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

	@Option(name= ATOMIC_BLOCKS_AS_LOCKS,
			description="Transforms atomic blocks by adding global locks.",
			secure=true)
		private boolean atomicBlocksAsLocks = false;

	@Option(name= CONSTANT_PROPAGATION,
			description="Performs constant propagation.",
			secure=true)
		private boolean constantPropagation = true;

    // ======================================================================

    private ProcessingManager(Configuration config) throws InvalidConfigurationException {
        config.inject(this);

        programProcessors.addAll(Arrays.asList(
                atomicBlocksAsLocks ? AtomicAsLock.fromConfig(config) : null,
                Memory.fixateMemoryValues(),
                DeadCodeElimination.fromConfig(config),
                BranchReordering.fromConfig(config),
                Simplifier.fromConfig(config),
        		FindSpinLoops.fromConfig(config),
                LoopUnrolling.fromConfig(config),
                constantPropagation ? ConstantPropagation.fromConfig(config) : null,
                DeadAssignmentElimination.fromConfig(config),
                RemoveDeadCondJumps.fromConfig(config),
                AtomicityPropagation.fromConfig(config),
                Compilation.fromConfig(config),
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