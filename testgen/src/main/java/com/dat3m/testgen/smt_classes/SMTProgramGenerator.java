package com.dat3m.testgen.smt_classes;

import java.math.BigInteger;

import org.sosy_lab.common.ShutdownNotifier;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.log.LogManager;
import org.sosy_lab.java_smt.SolverContextFactory;
import org.sosy_lab.java_smt.SolverContextFactory.Solvers;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.FormulaManager;
import org.sosy_lab.java_smt.api.IntegerFormulaManager;
import org.sosy_lab.java_smt.api.Model;
import org.sosy_lab.java_smt.api.NumeralFormula.IntegerFormula;
import org.sosy_lab.java_smt.api.ProverEnvironment;
import org.sosy_lab.java_smt.api.SolverContext;
import org.sosy_lab.java_smt.api.SolverContext.ProverOptions;

public class SMTProgramGenerator {

    Cycle cycle;

    Configuration config;
    LogManager logger;
    ShutdownNotifier shutdown;
    SolverContext context;

    FormulaManager formula_mngr;
    IntegerFormulaManager int_mngr;
    BooleanFormulaManager bool_mngr;

    ProverEnvironment prover;

    final static int READ_INSTRUCTION = 1;
    final static int WRITE_INSTRUCTION = 2;

    public SMTProgramGenerator(
        final Cycle r_cycle
    ) throws Exception {
        if( r_cycle == null ) throw new Exception( "Cycle object is not allowed to be null." );
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

        prover = context.newProverEnvironment( ProverOptions.GENERATE_MODELS );
    }

    public String generate_program()
    throws Exception {
        StringBuilder sb = new StringBuilder();

        initialize( sb );

        // process_relations( sb );

        // finalize( sb );

        prove_program( sb );

        return sb.toString();
    }

    void initialize(
        StringBuilder sb
    ) throws Exception {
        for( Event event : cycle.events ) {
            event.type = int_mngr.makeVariable( event.name( "type" ) );
            event.location = int_mngr.makeVariable( event.name( "location" ) );
            event.value = int_mngr.makeVariable( event.name( "value" ) );
            event.thread_id = int_mngr.makeVariable( event.name( "thread_id" ) );
            event.thread_row = int_mngr.makeVariable( event.name( "thread_row" ) );

            String attribute_names[] = new String[]{ "type", "location", "value", "thread_id", "thread_row" };
            IntegerFormula attribute_formulas[] = new IntegerFormula[]{ event.type, event.location, event.value, event.thread_id, event.thread_row };
            for( int i = 0 ; i < attribute_names.length ; i++ ){
                prover.addConstraint( int_mngr.greaterOrEquals( attribute_formulas[i], int_mngr.makeNumber( -1 ) ) );
                prover.addConstraint( int_mngr.lessThan( attribute_formulas[i], int_mngr.makeNumber( cycle.cycle_size ) ) );
            }
        }
    }

    void process_relations(
        StringBuilder sb
    ) throws Exception {
        for( final Relation relation : cycle.relations ) {
            sb.append( relation + "\n" );
            switch( relation.type ) {
                case po:
                    break;

                case rf:
                    break;

                case co:
                    break;

                case fr:
                    break;

                default:
                    throw new Exception( "Undefined relation type in cycle." );
            }
        }
    }

    void finalize(
        StringBuilder sb
    ) throws Exception {
    }

    void prove_program(
        StringBuilder sb
    ) throws Exception {
        boolean isUnsat = prover.isUnsat();
        if( !isUnsat ) {
            Model model = prover.getModel();
            for( final Event event : cycle.events ) {
                BigInteger val_type = model.evaluate( event.type );
                BigInteger val_location = model.evaluate( event.location );
                BigInteger val_value = model.evaluate( event.value );
                BigInteger val_thread_id = model.evaluate( event.thread_id );
                BigInteger val_thread_row = model.evaluate( event.thread_row );
                sb.append(
                    "\n" + event + ": " +
                    "\n\ttype: " + ( val_type.equals( BigInteger.ONE ) ? "READ" : ( val_type.equals( BigInteger.TWO ) ? "WRITE" : "undefined" ) ) +
                    "\n\tlocation: " + val_location +
                    "\n\tvalue: " + val_value +
                    "\n\tthread_id: " + val_thread_id +
                    "\n\tthread_row:" + val_thread_row + "\n"
                );
            }
        } else {
            sb.append( "Program cannot exist!\n" );
        }
    }

}
