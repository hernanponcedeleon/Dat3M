package com.dat3m.dartagnan.verification;

import org.sosy_lab.common.ShutdownManager;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.java_smt.api.SolverException;

public interface Verifier extends AutoCloseable {

    VerificationResult verify() throws SolverException, InterruptedException, InvalidConfigurationException;
    void setShutdownManager(ShutdownManager shutdownManager);

    @Override
    void close();
}
