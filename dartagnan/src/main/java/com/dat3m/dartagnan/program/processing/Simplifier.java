package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

public class Simplifier implements ProgramProcessor {

    private static final Logger logger = LogManager.getLogger(Simplifier.class);

    private Simplifier() { }

    public static Simplifier newInstance() {
        return new Simplifier();
    }

    public static Simplifier fromConfig(Configuration config) throws InvalidConfigurationException {
        return newInstance(); // There is noting to configure
    }

    @Override
    public void run(Program program) {
        if (program.isUnrolled()) {
            throw new IllegalStateException("Simplifying should be performed before unrolling.");
        }
        // Some simplification are only applicable after others.
        // Thus we apply them iteratively until we reach a fixpoint.
        int size = program.getEvents().size();
        logger.info("pre-simplification: " + size + " events");

        int newSize = size;
        do {
            size = newSize;
            one_step_simplify(program);
            newSize = program.getEvents().size();
        } while (newSize != size);

        logger.info("post-simplification: " + size + " events");
    }

    private void one_step_simplify(Program program) {
        for(Thread thread : program.getThreads()){
            thread.getEntry().simplify(null);
            thread.clearCache();
        }
        program.clearCache();
    }
}
