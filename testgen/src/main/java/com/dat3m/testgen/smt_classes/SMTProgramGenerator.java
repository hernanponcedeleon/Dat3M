package com.dat3m.testgen.smt_classes;

import org.sosy_lab.common.ShutdownNotifier;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.log.LogManager;
import org.sosy_lab.java_smt.SolverContextFactory;
import org.sosy_lab.java_smt.SolverContextFactory.Solvers;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.FormulaManager;
import org.sosy_lab.java_smt.api.IntegerFormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;

public class SMTProgramGenerator {
    
    Cycle cycle;

    Configuration config;
    LogManager logger;
    ShutdownNotifier shutdown;
    SolverContext context;

    FormulaManager formula_mngr;
    IntegerFormulaManager int_mngr;
    BooleanFormulaManager bool_mngr;
    
    public SMTProgramGenerator(
        final Cycle r_cycle
    ) throws Exception {
        if( r_cycle == null ) throw new Exception();
        cycle = r_cycle;

        config = Configuration.defaultConfiguration();
        logger = LogManager.createNullLogManager();
        shutdown = ShutdownNotifier.createDummy();

        context = SolverContextFactory.createSolverContext(
            config, logger, shutdown, Solvers.SMTINTERPOL
        );

        formula_mngr = context.getFormulaManager();
        bool_mngr = formula_mngr.getBooleanFormulaManager();
        int_mngr = formula_mngr.getIntegerFormulaManager();
    }

    public String generate_program()
    throws Exception {
        StringBuilder sb = new StringBuilder();

        for( final Relation relation : cycle.relations ) {
            switch( relation.type ) {
                case po:
                case rf:
                case co:
                case fr:
                    sb.append( relation + "\n" );
                    break;

                default:
                    throw new Exception( "Undefined relation type in cycle." );
            }
        }

        return sb.toString();
    }

}
