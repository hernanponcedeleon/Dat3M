package com.dat3m.testgen.generate;

import org.sosy_lab.common.ShutdownNotifier;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.log.LogManager;
import org.sosy_lab.java_smt.SolverContextFactory;
import org.sosy_lab.java_smt.SolverContextFactory.Solvers;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.EnumerationFormulaManager;
import org.sosy_lab.java_smt.api.FormulaManager;
import org.sosy_lab.java_smt.api.IntegerFormulaManager;
import org.sosy_lab.java_smt.api.ProverEnvironment;
import org.sosy_lab.java_smt.api.SolverContext;
import org.sosy_lab.java_smt.api.UFManager;
import org.sosy_lab.java_smt.api.SolverContext.ProverOptions;

public class SMTHandler {
    
    public Configuration config;
    public LogManager logger;
    public ShutdownNotifier shutdown;
    public SolverContext context;
    public FormulaManager fm;
    public IntegerFormulaManager im;
    public BooleanFormulaManager bm;
    public EnumerationFormulaManager em;
    public UFManager ufm;
    public ProverEnvironment prover;
    
    public SMTHandler()
    throws Exception {
        config   = Configuration.defaultConfiguration();
        logger   = LogManager.createNullLogManager();
        shutdown = ShutdownNotifier.createDummy();

        context = SolverContextFactory.createSolverContext(
            config, logger, shutdown, Solvers.Z3
        );

        fm = context.getFormulaManager();
        im = fm.getIntegerFormulaManager();
        bm = fm.getBooleanFormulaManager();
        em = fm.getEnumerationFormulaManager();
        ufm = fm.getUFManager();

        prover = context.newProverEnvironment( ProverOptions.GENERATE_MODELS );

        SMTInstruction.enum_type = em.declareEnumeration( "instruction_type", SMTInstruction.instruction_types ); 
    }

}
