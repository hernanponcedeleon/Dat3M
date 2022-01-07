package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.verification.VerificationTask;
import org.sosy_lab.java_smt.api.SolverContext;

public interface Encoder {

    // Any Encoder may rely on the assumption that after initialisation, the
    // data models (e.g. program, wmm and memory) do not change anymore.
    void initializeEncoding(VerificationTask task, SolverContext context);
}