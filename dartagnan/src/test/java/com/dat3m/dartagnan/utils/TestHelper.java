package com.dat3m.dartagnan.utils;

import org.sosy_lab.common.ShutdownManager;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.log.BasicLogManager;
import org.sosy_lab.java_smt.SolverContextFactory;
import org.sosy_lab.java_smt.api.SolverContext;

public class TestHelper {

    private TestHelper() {
    }

    public static SolverContext createContext() throws InvalidConfigurationException {
            Configuration config = Configuration.builder()
                    .setOption("solver.z3.usePhantomReferences", "true")
            		.setOption("solver.nonLinearArithmetic", "APPROXIMATE_FALLBACK")
                    .build();
            return SolverContextFactory.createSolverContext(
                    config,
                    BasicLogManager.create(config),
                    ShutdownManager.create().getNotifier(),
                    SolverContextFactory.Solvers.Z3);
    }
}
