package com.dat3m.dartagnan.smt;

import org.sosy_lab.common.NativeLibraries;
import org.sosy_lab.common.ShutdownNotifier;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.log.BasicLogManager;
import org.sosy_lab.java_smt.SolverContextFactory;
import org.sosy_lab.java_smt.api.SolverContext;

public class SMTHelper {

    private SMTHelper() { }

    private static void loadLibrary(String libName) {
        // Try using NativeLibraries::loadLibrary. Fallback to System::loadLibrary
        // if NativeLibraries failed, for example, because the operating system is
        // not supported: see https://github.com/hernanponcedeleon/Dat3M/pull/835
        try {
            NativeLibraries.loadLibrary(libName);
        } catch (Exception e) {
            System.loadLibrary(libName);
        }
    }

    public static SolverContext createSolverContext(Configuration config, ShutdownNotifier notifier,
                                                    SolverContextFactory.Solvers solver) throws InvalidConfigurationException {
        return SolverContextFactory.createSolverContext(
                config,
                BasicLogManager.create(config),
                notifier,
                solver,
                SMTHelper::loadLibrary
        );
    }

}
