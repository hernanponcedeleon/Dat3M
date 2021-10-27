package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.program.Program;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;


@Options(prefix = "program.processing")
public class ProcessingManager implements ProgramProcessor {
    //TODO: We might want to also add unrolling and compiling into this process

    private final static Logger logger = LogManager.getLogger(ProcessingManager.class);

    private final Configuration config;

    // =========================== Configurables ===========================

    @Option(name = "performDCE",
            description = "Eliminates unreachable code.",
            secure = true)
    private boolean performDCE = true;

    public boolean performsDeadCodeElimination() { return performDCE; }
    public void setPerformDeadCodeElimination(boolean value) { performDCE = value; }

    @Option(name = "reorderBranches",
            description = "Soundly reorders the code structure to make it more linear if possible.",
            secure = true)
    private boolean reorderBranches = true;

    public boolean reordersBranches() { return reorderBranches; }
    public void setReorderBranches(boolean value) { reorderBranches = value; }

    @Option(name = "reduceSymmetry",
            description = "Reduces the symmetry of the program (unsound in general).",
            secure = true)
    private boolean reduceSymmetry = false;

    public boolean reducesSymmetry() { return reduceSymmetry; }
    public void setReduceSymmetry(boolean value) { reduceSymmetry = value; }

    // ======================================================================

    private ProcessingManager(Configuration config) throws InvalidConfigurationException {
        this.config = config;
        config.inject(this);
    }

    public void run(Program program) {
        try {
            if (performDCE) {
                DeadCodeElimination.fromConfig(config).run(program);
            }
            if (reorderBranches) {
                BranchReordering.fromConfig(config).run(program);
            }
            Simplifier.fromConfig(config).run(program);
            LoopUnrolling.fromConfig(config).run(program);
            Compilation.fromConfig(config).run(program);
            if (reduceSymmetry) {
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
