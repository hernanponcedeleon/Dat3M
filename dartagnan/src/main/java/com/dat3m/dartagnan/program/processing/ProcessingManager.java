package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.program.Program;
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
		private boolean constantPropagation = false;

    // ======================================================================

    private ProcessingManager(Configuration config) throws InvalidConfigurationException {
        config.inject(this);

        programProcessors.addAll(Arrays.asList(
                DeadCodeElimination.fromConfig(config),
                BranchReordering.fromConfig(config),
                Simplifier.fromConfig(config),
                LoopUnrolling.fromConfig(config),
                constantPropagation ? ConstantPropagation.fromConfig(config) : null,
                Compilation.fromConfig(config),
                atomicBlocksAsLocks ? AtomicAsLock.fromConfig(config) : null,
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