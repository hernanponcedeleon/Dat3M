package com.dat3m.dartagnan.utils.rules;

import com.dat3m.dartagnan.utils.TestHelper;
import org.sosy_lab.java_smt.api.SolverContext;

public class SolverContextProvider extends AbstractProvider<SolverContext> {
    @Override
    protected SolverContext provide() throws Throwable {
        return TestHelper.createContext();
    }

}
