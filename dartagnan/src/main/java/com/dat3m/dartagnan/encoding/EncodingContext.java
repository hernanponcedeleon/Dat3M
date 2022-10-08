package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.verification.VerificationTask;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;
import org.sosy_lab.java_smt.api.*;

import static com.dat3m.dartagnan.configuration.OptionNames.IDL_TO_SAT;
import static com.google.common.base.Preconditions.checkNotNull;

@Options
public final class EncodingContext {

    private static final Logger logger = LogManager.getLogger(EncodingContext.class);

    private final VerificationTask verificationTask;
    private final Context analysisContext;
    private final SolverContext solverContext;
    private final FormulaManager formulaManager;

    @Option(
            name=IDL_TO_SAT,
            description = "Use SAT-based encoding for totality and acyclicity.",
            secure = true)
    boolean useSATEncoding = false;

    private EncodingContext(VerificationTask t, Context a, SolverContext s) {
        verificationTask = checkNotNull(t);
        analysisContext = checkNotNull(a);
        solverContext = checkNotNull(s);
        formulaManager = s.getFormulaManager();
    }

    public static EncodingContext of(VerificationTask task, Context analysisContext, SolverContext solverContext) throws InvalidConfigurationException {
        EncodingContext context = new EncodingContext(task, analysisContext, solverContext);
        task.getConfig().inject(context);
        logger.info("{}: {}", IDL_TO_SAT, context.useSATEncoding);
        return context;
    }

    public boolean usesSATEncoding() {
        return useSATEncoding;
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