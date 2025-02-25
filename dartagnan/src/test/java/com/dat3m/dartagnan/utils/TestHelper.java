package com.dat3m.dartagnan.utils;

import static com.dat3m.dartagnan.configuration.OptionNames.PHANTOM_REFERENCES;

import org.sosy_lab.common.ShutdownNotifier;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.log.BasicLogManager;
import org.sosy_lab.java_smt.SolverContextFactory;
import org.sosy_lab.java_smt.SolverContextFactory.Solvers;
import org.sosy_lab.java_smt.api.SolverContext;

public class TestHelper {

    private TestHelper() {
    }

    public static SolverContext createContext() throws InvalidConfigurationException {
        return createContextWithShutdownNotifier(ShutdownNotifier.createDummy(), Solvers.Z3);
    }

    public static SolverContext createContextWithShutdownNotifier(ShutdownNotifier notifier, Solvers solver) throws InvalidConfigurationException {
        Configuration config = solver.equals(Solvers.Z3) ?
            Configuration.builder()
                .setOption(PHANTOM_REFERENCES, "true")
                .build() :
            Configuration.defaultConfiguration();
        return SolverContextFactory.createSolverContext(
                config,
                BasicLogManager.create(config),
                notifier,
                solver);
    }
}
