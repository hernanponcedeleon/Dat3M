package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.program.Program;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

import static com.dat3m.dartagnan.configuration.OptionNames.ATOMIC_BLOCKS_AS_LOCKS;
import static com.dat3m.dartagnan.configuration.OptionNames.REDUCE_SYMMETRY;


@Options
public class ProcessingManager implements ProgramProcessor {

    private final static Logger logger = LogManager.getLogger(ProcessingManager.class);

    private final Configuration config;

    // =========================== Configurables ===========================

    @Option(name = REDUCE_SYMMETRY,
            description = "Reduces the symmetry of the program (unsound in general).",
            secure = true)
    private boolean reduceSymmetry = false;

	@Option(name= ATOMIC_BLOCKS_AS_LOCKS,
			description="Transforms atomic blocks by adding global locks.",
			secure=true)
		private boolean atomicBlocksAsLocks = false;

    // ======================================================================

    private ProcessingManager(Configuration config) throws InvalidConfigurationException {
        this.config = config;
        config.inject(this);
    }

    public void run(Program program) {
        try {
        	DeadCodeElimination.fromConfig(config).run(program);
        	BranchReordering.fromConfig(config).run(program);
        	Simplifier.fromConfig(config).run(program);
        	LoopUnrolling.fromConfig(config).run(program);
        	Compilation.fromConfig(config).run(program);
        	if(atomicBlocksAsLocks) {
        	    // TODO: Do we really want to execute this after compilation?
            	AtomicAsLock.fromConfig(config).run(program);
        	}
        	if(reduceSymmetry) {
                SymmetryReduction.fromConfig(config).run(program);
            }
        } catch (InvalidConfigurationException ex) {
            logger.error(ex.getMessage());
            throw new RuntimeException(ex);
        }
    }

    // ==================================================

    public static ProcessingManager fromConfig(Configuration config) throws InvalidConfigurationException {
        return new ProcessingManager(config);
    }
}