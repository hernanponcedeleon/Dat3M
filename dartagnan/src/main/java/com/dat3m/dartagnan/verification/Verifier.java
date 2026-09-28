package com.dat3m.dartagnan.verification;

import org.sosy_lab.common.ShutdownManager;

public interface Verifier extends AutoCloseable {

    // TODO: Add exceptions?
    VerificationResult verify();
    void setShutdownManager(ShutdownManager shutdownManager);

    @Override
    void close();
}
