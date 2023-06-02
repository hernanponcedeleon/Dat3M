package com.dat3m.dartagnan.program.analysis;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.core.AbstractEvent;
import com.dat3m.dartagnan.verification.Context;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

public interface ExecutionAnalysis {

    boolean isImplied(AbstractEvent start, AbstractEvent implied);
    boolean areMutuallyExclusive(AbstractEvent a, AbstractEvent b);



    static ExecutionAnalysis fromConfig(Program program, Context context, Configuration config)
            throws InvalidConfigurationException {

        BranchEquivalence eq = context.requires(BranchEquivalence.class);
        return new ExecutionAnalysis() {
            @Override
            public boolean isImplied(AbstractEvent start, AbstractEvent implied) {
                return start == implied || (implied.cfImpliesExec() && eq.isImplied(start, implied));
            }

            @Override
            public boolean areMutuallyExclusive(AbstractEvent a, AbstractEvent b) {
                return eq.areMutuallyExclusive(a, b);
            }
        };
    }
}
