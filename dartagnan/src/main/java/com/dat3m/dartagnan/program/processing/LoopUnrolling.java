package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.google.common.base.Preconditions;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.*;

@Options(prefix = "program.processing")
public class LoopUnrolling implements ProgramProcessor {

    private static final Logger logger = LogManager.getLogger(LoopUnrolling.class);

    // =========================== Configurables ===========================

    @Option(name = "loopBound",
            description = "Unrolls loops up to loopBound many times.",
            secure = true)
    @IntegerOption(min = 1)
    private int bound = 1;

    public int getUnrollingBound() { return bound; }
    public void setUnrollingBound(int bound) {
        Preconditions.checkArgument(bound >= 1, "The unrolling bound must be positive.");
        this.bound = bound;
    }

    // =====================================================================

    private LoopUnrolling() { }

    private LoopUnrolling(Configuration config) throws InvalidConfigurationException {
        this();
        config.inject(this);
    }

    public static LoopUnrolling fromConfig(Configuration config) throws InvalidConfigurationException {
        return new LoopUnrolling(config);
    }

    public static LoopUnrolling newInstance() {
        return new LoopUnrolling();
    }


    @Override
    public void run(Program program) {
        if (program.isUnrolled()) {
            logger.warn("Skipped unrolling: Program is already unrolled.");
            return;
        }

        int nextId = 0;
        for(Thread thread : program.getThreads()){
            nextId = unrollThread(thread, bound, nextId);
        }
        program.clearCache(false);
        program.markAsUnrolled();

        logger.info("Program unrolled {} times", bound);
    }

    private int unrollThread(Thread t, int bound, int nextId){
        while(bound > 0) {
            t.getEntry().unroll(bound, null);
            bound--;
        }
        nextId = t.getEntry().setUId(nextId);
        t.updateExit(t.getEntry());
        t.clearCache();
        return nextId;
    }



}
