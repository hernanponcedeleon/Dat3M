package com.dat3m.testgen.generate;

import org.sosy_lab.common.ShutdownNotifier;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.log.LogManager;
import org.sosy_lab.java_smt.SolverContextFactory;
import org.sosy_lab.java_smt.SolverContextFactory.Solvers;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.EnumerationFormula;
import org.sosy_lab.java_smt.api.EnumerationFormulaManager;
import org.sosy_lab.java_smt.api.FormulaManager;
import org.sosy_lab.java_smt.api.FormulaType.EnumerationFormulaType;
import org.sosy_lab.java_smt.api.IntegerFormulaManager;
import org.sosy_lab.java_smt.api.ProverEnvironment;
import org.sosy_lab.java_smt.api.SolverContext;
import org.sosy_lab.java_smt.api.SolverContext.ProverOptions;

class SMTHandler {
    
    Configuration config;
    LogManager logger;
    ShutdownNotifier shutdown;
    SolverContext context;
    FormulaManager fm;
    IntegerFormulaManager im;
    BooleanFormulaManager bm;
    EnumerationFormulaManager em;
    ProverEnvironment prover;
    
    EnumerationFormulaType instruction_type;
    String[] instructions = { "UNDEFINED", "R", "W" };

    SMTHandler()
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

        prover = context.newProverEnvironment( ProverOptions.GENERATE_MODELS );
        instruction_type = em.declareEnumeration( "instruction_type", instructions ); 
    }

    EnumerationFormula instruction(
        final String instruction
    ) throws Exception {
        for( String str : instructions ) {
            if( str.equals( instruction ) )
                return em.makeConstant( instruction, instruction_type );
        }
        throw new Exception( "Instruction type not found!" );
    }

}
