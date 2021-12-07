package com.dat3m.dartagnan.utils;

import org.sosy_lab.common.ShutdownNotifier;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.log.BasicLogManager;
import org.sosy_lab.java_smt.SolverContextFactory;
import org.sosy_lab.java_smt.api.SolverContext;

public class TestHelper {

    private TestHelper() {
    }

    public static SolverContext createContext() throws InvalidConfigurationException {
        return createContextWithShutdownNotifier(ShutdownNotifier.createDummy());
    }

    public static SolverContext createContextWithShutdownNotifier(ShutdownNotifier notifier) throws InvalidConfigurationException {
        Configuration config = Configuration.builder()
                .setOption("solver.z3.usePhantomReferences", "true")
                .build();
        return SolverContextFactory.createSolverContext(
                config,
                BasicLogManager.create(config),
                notifier,
                SolverContextFactory.Solvers.Z3);
    }
}
