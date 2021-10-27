package com.dat3m.dartagnan.program.encoding;

import com.dat3m.dartagnan.verification.VerificationTask;
import org.sosy_lab.java_smt.api.SolverContext;

public interface Encoder {

    void initialise(VerificationTask task, SolverContext context);
}
