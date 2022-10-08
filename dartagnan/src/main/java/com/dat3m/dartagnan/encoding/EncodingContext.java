package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.verification.VerificationTask;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Options;
import org.sosy_lab.java_smt.api.*;

import static com.google.common.base.Preconditions.checkNotNull;

@Options
public final class EncodingContext {

    private final VerificationTask verificationTask;
    private final Context analysisContext;
    private final SolverContext solverContext;
    private final FormulaManager formulaManager;

    private EncodingContext(VerificationTask t, Context a, SolverContext s) {
        verificationTask = checkNotNull(t);
        analysisContext = checkNotNull(a);
        solverContext = checkNotNull(s);
        formulaManager = s.getFormulaManager();
    }

    public static EncodingContext of(VerificationTask task, Context analysisContext, SolverContext solverContext) throws InvalidConfigurationException {
        EncodingContext context = new EncodingContext(task, analysisContext, solverContext);
        task.getConfig().inject(context);
        return context;
    }

    public VerificationTask task() {
        return verificationTask;
    }

    public Context analysisContext() {
        return analysisContext;
    }

    public SolverContext solverContext() {
        return solverContext;
    }

    public FormulaManager getFormulaManager() {
        return formulaManager;
    }
}