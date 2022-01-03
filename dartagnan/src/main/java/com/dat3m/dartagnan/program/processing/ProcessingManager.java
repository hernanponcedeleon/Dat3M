package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.program.Program;

import static com.dat3m.dartagnan.configuration.OptionNames.ATOMICBLOCKSASLOCKS;
import static com.dat3m.dartagnan.configuration.OptionNames.REDUCESYMMETRY;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;


@Options
public class ProcessingManager implements ProgramProcessor {

    private final static Logger logger = LogManager.getLogger(ProcessingManager.class);

    private final Configuration config;

    // =========================== Configurables ===========================

    @Option(name = REDUCESYMMETRY,
            description = "Reduces the symmetry of the program (unsound in general).",
            secure = true)
    private boolean reduceSymmetry = false;

	@Option(name= ATOMICBLOCKSASLOCKS,
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