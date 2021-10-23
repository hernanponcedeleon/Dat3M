package com.dat3m.dartagnan.program.utils.preprocessing;

import com.dat3m.dartagnan.program.Program;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;


@Options(prefix = "program.preprocessing")
public class PreprocessingChain implements ProgramPreprocessor {
    //TODO: We might want to also add unrolling and compiling into this process

    private final static Logger logger = LogManager.getLogger(PreprocessingChain.class);
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

    @Option(name = "detReordering",
            description = "Deterministically reorders branches (only applicable if program.preprocessing.reorderBranches is TRUE)." +
                    "Setting this to FALSE may be useful for debugging.",
            secure = true)
    private boolean reorderDeterministically = true;

    public boolean reordersDeterministically() { return reorderDeterministically; }
    public void setReorderDeterministically(boolean value) { reorderDeterministically = value; }

    // ======================================================================

    private PreprocessingChain(Configuration config) throws InvalidConfigurationException {
        this.config = config;
        config.inject(this);
    }

    public void run(Program program) {
        if (performDCE) {
            new DeadCodeElimination().run(program);
        }
        if (reorderBranches) {
            try {
                new BranchReordering(config).run(program);
            } catch (InvalidConfigurationException ignore) {
                // We ignore config errors here for now
            }
        }

        new Simplifier().run(program);
    }

    // ==================================================

    public static PreprocessingChain fromConfig(Configuration config) throws InvalidConfigurationException {
        return new PreprocessingChain(config);
    }


}
