package com.dat3m.dartagnan.smt;

import org.sosy_lab.common.NativeLibraries;
import org.sosy_lab.common.ShutdownNotifier;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.ConfigurationBuilder;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.log.BasicLogManager;
import org.sosy_lab.java_smt.SolverContextFactory;
import org.sosy_lab.java_smt.api.SolverContext;

import static com.dat3m.dartagnan.configuration.OptionNames.PHANTOM_REFERENCES;
import static com.dat3m.dartagnan.configuration.OptionNames.YICES2_SOLVER_TYPE;

public class SMTHelper {

    private SMTHelper() { }

    private static void loadLibrary(String libName) {
        // Try using NativeLibraries::loadLibrary. Fallback to System::loadLibrary
        // if NativeLibraries failed, for example, because the operating system is
        // not supported: see https://github.com/hernanponcedeleon/Dat3M/pull/835
        try {
            NativeLibraries.loadLibrary(libName);
        } catch (Exception _) {
            System.loadLibrary(libName);
        }
    }

    public static SolverContext createSolverContext(Configuration config, ShutdownNotifier notifier,
                                                    SolverContextFactory.Solvers solver) throws InvalidConfigurationException {
        final Configuration solverConfig = withSolverDefaults(config, solver);
        return SolverContextFactory.createSolverContext(
                solverConfig,
                BasicLogManager.create(solverConfig),
                notifier,
                solver,
                SMTHelper::loadLibrary
        );
    }

    // Solver options that differ from JavaSMT's defaults. Options set explicitly by the user take precedence.
    private static Configuration withSolverDefaults(Configuration config, SolverContextFactory.Solvers solver)
            throws InvalidConfigurationException {
        final ConfigurationBuilder builder = Configuration.builder().copyFrom(config);
        switch (solver) {
            // Lets the JVM garbage collector free Z3 terms that are no longer referenced.
            case Z3 -> setIfAbsent(config, builder, PHANTOM_REFERENCES, "true");
            // JavaSMT defaults to MCSAT, which is much slower than DPLL(T) on our encodings.
            case YICES2 -> setIfAbsent(config, builder, YICES2_SOLVER_TYPE, "dpllt");
            default -> { return config; }
        }
        return builder.build();
    }

    private static void setIfAbsent(Configuration config, ConfigurationBuilder builder, String option, String value) {
        if (!config.hasProperty(option)) {
            builder.setOption(option, value);
        }
    }

}
