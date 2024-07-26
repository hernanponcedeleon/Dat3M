package com.dat3m.testgen.smt_classes;

import java.math.BigInteger;

import org.sosy_lab.common.ShutdownNotifier;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.log.LogManager;
import org.sosy_lab.java_smt.SolverContextFactory;
import org.sosy_lab.java_smt.SolverContextFactory.Solvers;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.EnumerationFormulaManager;
import org.sosy_lab.java_smt.api.FormulaManager;
import org.sosy_lab.java_smt.api.IntegerFormulaManager;
import org.sosy_lab.java_smt.api.Model;
import org.sosy_lab.java_smt.api.ProverEnvironment;
import org.sosy_lab.java_smt.api.SolverContext;
import org.sosy_lab.java_smt.api.SolverContext.ProverOptions;
import org.sosy_lab.java_smt.api.FormulaType.EnumerationFormulaType;

public class SMTProgramGenerator {
    
    Cycle cycle;

    Configuration config;
    LogManager logger;
    ShutdownNotifier shutdown;
    SolverContext context;

    FormulaManager formula_mngr;
    IntegerFormulaManager int_mngr;
    BooleanFormulaManager bool_mngr;
    EnumerationFormulaManager enum_mngr;
    
    EnumerationFormulaType event_t;
    
    public SMTProgramGenerator(
        final Cycle r_cycle
    ) throws Exception {
        if( r_cycle == null ) throw new Exception();
        cycle = r_cycle;

        config = Configuration.defaultConfiguration();
        logger = LogManager.createNullLogManager();
        shutdown = ShutdownNotifier.createDummy();

        context = SolverContextFactory.createSolverContext(
            config, logger, shutdown, Solvers.Z3
        );

        formula_mngr = context.getFormulaManager();
        int_mngr = formula_mngr.getIntegerFormulaManager();
        bool_mngr = formula_mngr.getBooleanFormulaManager();
        enum_mngr = formula_mngr.getEnumerationFormulaManager();

        event_t = enum_mngr.declareEnumeration( "event_t", "undefined", "read", "write" );
    }

    public String generate_program()
    throws Exception {
        StringBuilder sb = new StringBuilder();

        BooleanFormula constraint = bool_mngr.makeTrue();

        for( Event event : cycle.events ) {
            event.type = enum_mngr.makeVariable( event.name( "type" ), event_t );
            event.location = int_mngr.makeVariable( event.name( "location" ) );
            event.value = int_mngr.makeVariable( event.name( "value" ) );
            event.thread_id = int_mngr.makeVariable( event.name( "thread_id" ) );
            event.thread_row = int_mngr.makeVariable( event.name( "thread_row" ) );

            constraint = bool_mngr.and( constraint, int_mngr.greaterOrEquals( event.location, int_mngr.makeNumber(0) ) );
            constraint = bool_mngr.and( constraint, int_mngr.lessThan( event.location, int_mngr.makeNumber( cycle.cycle_size ) ) );
            constraint = bool_mngr.and( constraint, int_mngr.greaterOrEquals( event.value, int_mngr.makeNumber(0) ) );
            constraint = bool_mngr.and( constraint, int_mngr.lessThan( event.value, int_mngr.makeNumber( cycle.cycle_size ) ) );
            constraint = bool_mngr.and( constraint, int_mngr.greaterOrEquals( event.thread_id, int_mngr.makeNumber(0) ) );
            constraint = bool_mngr.and( constraint, int_mngr.lessThan( event.thread_id, int_mngr.makeNumber( cycle.cycle_size ) ) );
            constraint = bool_mngr.and( constraint, int_mngr.greaterOrEquals( event.thread_row, int_mngr.makeNumber(0) ) );
            constraint = bool_mngr.and( constraint, int_mngr.lessThan( event.thread_row, int_mngr.makeNumber( cycle.cycle_size ) ) );
        }

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

        try( ProverEnvironment prover = context.newProverEnvironment( ProverOptions.GENERATE_MODELS ) ) {
            prover.addConstraint( constraint );
            boolean isUnsat = prover.isUnsat();
            if( !isUnsat ){
                Model model = prover.getModel();
                for( final Event event : cycle.events ) {
                    String val_type = model.evaluate( event.type );
                    BigInteger val_location = model.evaluate( event.location );
                    BigInteger val_value = model.evaluate( event.value );
                    BigInteger val_thread_id = model.evaluate( event.thread_id );
                    BigInteger val_thread_row = model.evaluate( event.thread_row );
                    System.out.println(
                        "" + event + ": " +
                        "\n\ttype: " + val_type +
                        "\n\tlocation: " + val_location +
                        "\n\tvalue: " + val_value + 
                        "\n\tthread_id: " + val_thread_id +
                        "\n\tthread_row:" + val_thread_row + "\n"
                    );
                }
            }
        }

        return sb.toString();
    }

}
