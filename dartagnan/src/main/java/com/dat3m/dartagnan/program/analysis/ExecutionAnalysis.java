package com.dat3m.dartagnan.program.analysis;

import com.dat3m.dartagnan.configuration.ProgressModel;
import com.dat3m.dartagnan.program.IRHelper;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.verification.Context;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.util.Comparator;

public interface ExecutionAnalysis {

    boolean isImplied(Event start, Event implied);
    boolean areMutuallyExclusive(Event a, Event b);



    static ExecutionAnalysis fromConfig(Program program, ProgressModel.Hierarchy progressModel, Context context, Configuration config)
            throws InvalidConfigurationException {
        final BranchEquivalence eq = context.requires(BranchEquivalence.class);
        return new DefaultExecutionAnalysis(program, eq, progressModel);
    }
}

/*
    NOTE: The BranchEquivalence computes cf-equivalence/implication assuming a strong progress model.
    However, we can "weaken" the BranchEquivalence results after the fact based on the assumed progress model.
 */
class DefaultExecutionAnalysis implements ExecutionAnalysis {

    private final BranchEquivalence eq;
    private final ProgressModel.Hierarchy progressModel;
    private final Thread lowestIdThread; // For HSA

    public DefaultExecutionAnalysis(Program program, BranchEquivalence eq, ProgressModel.Hierarchy progressModel) {
        this.eq = eq;
        this.progressModel = progressModel;

        this.lowestIdThread = program.getThreads().stream().min(Comparator.comparingInt(Thread::getId)).get();
    }

    private boolean isSameThread(Event a, Event b) {
        return a.getThread() == b.getThread();
    }

    @Override
    public boolean isImplied(Event start, Event implied) {
        if (start == implied) {
            return true;
        }
        final boolean weakestImplication = (implied.cfImpliesExec() && eq.isImplied(start, implied));
        if (!weakestImplication) {
            // If weakest implication does not hold, the events are unrelated under all progress models.
            return false;
        }
        final boolean strongestImplication = /* weakestImplication && */
                isSameThread(start, implied) && start.getGlobalId() > implied.getGlobalId();
        if (strongestImplication) {
            // If strongest implication does hold, then all progress models will give this implication
            return true;
        }

        if (!progressModel.isUniform()) {
            // For mixed-hierarchy models, we only rely on strongest implication.
            return strongestImplication; // FALSE
        }

        // weakest implication holds but not strongest & model is uniform: progress model decides
        final boolean implication = switch (progressModel.getDefaultProgress()) {
            case FAIR -> weakestImplication; // TRUE
            case HSA -> implied.getThread() == lowestIdThread;
            case OBE -> isSameThread(start, implied);
            case HSA_OBE -> (implied.getThread() == lowestIdThread || isSameThread(start, implied));
            case LOBE -> start.getThread().getId() >= implied.getThread().getId()
                    && !IRHelper.isInitThread(start.getThread());
            case UNFAIR -> strongestImplication; // FALSE
        };
        return implication;
    }

    @Override
    public boolean areMutuallyExclusive(Event a, Event b) {
        // The concept of mutual exclusion is identical under all progress models.
        return eq.areMutuallyExclusive(a, b);
    }
}
