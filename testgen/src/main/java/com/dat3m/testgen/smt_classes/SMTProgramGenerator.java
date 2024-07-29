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

    final static int READ_INSTRUCTION = 1;
    final static int WRITE_INSTRUCTION = 2;
        
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
    }

    public String generate_program()
    throws Exception {
        StringBuilder sb = new StringBuilder();

        BooleanFormula constraint = initialize();

        constraint = process_relations( constraint, sb );

        constraint = finalize( constraint );

        prove_program( constraint, sb );

        return sb.toString();
    }

    BooleanFormula initialize()
    {
        BooleanFormula constraint = bool_mngr.makeTrue();

        for( Event event : cycle.events ) {
            event.type = int_mngr.makeVariable( event.name( "type" ) );
            event.location = int_mngr.makeVariable( event.name( "location" ) );
            event.value = int_mngr.makeVariable( event.name( "value" ) );
            event.thread_id = int_mngr.makeVariable( event.name( "thread_id" ) );
            event.thread_row = int_mngr.makeVariable( event.name( "thread_row" ) );

            for( IntegerFormula int_field : new IntegerFormula[]{ event.location, event.thread_id, event.thread_row } ){
                constraint = bool_mngr.and( constraint, int_mngr.greaterOrEquals( int_field, int_mngr.makeNumber( 0 ) ) );
                constraint = bool_mngr.and( constraint, int_mngr.lessThan( int_field, int_mngr.makeNumber( cycle.cycle_size ) ) );    
            }

            constraint = bool_mngr.and( constraint, int_mngr.greaterOrEquals( event.type, int_mngr.makeNumber( 0 ) ) );
            constraint = bool_mngr.and( constraint, int_mngr.lessThan( event.type, int_mngr.makeNumber( 3 ) ) );  
            constraint = bool_mngr.and( constraint, int_mngr.greaterOrEquals( event.value, int_mngr.makeNumber( -1 ) ) );
            constraint = bool_mngr.and( constraint, int_mngr.lessThan( event.value, int_mngr.makeNumber( cycle.cycle_size ) ) );    
        }

        return constraint;
    }

    BooleanFormula process_relations(
        BooleanFormula constraint,
        StringBuilder sb
    ) throws Exception {
        for( final Relation relation : cycle.relations ) {
            sb.append( relation + "\n" );
            switch( relation.type ) {
                case po:
                    constraint = bool_mngr.and( constraint, bool_mngr.and(
                        int_mngr.equal( relation.event_L.thread_id, relation.event_R.thread_id ),
                        int_mngr.lessThan( relation.event_L.thread_row, relation.event_R.thread_row )
                    ) );
                    relation.event_R.was_moved = true;
                    break;

                case rf:
                constraint = bool_mngr.and( constraint, bool_mngr.and( bool_mngr.and( bool_mngr.and( bool_mngr.and(
                    int_mngr.equal( relation.event_L.type, int_mngr.makeNumber( WRITE_INSTRUCTION ) ),
                    int_mngr.equal( relation.event_R.type, int_mngr.makeNumber( READ_INSTRUCTION ) ) ),
                    int_mngr.equal( relation.event_L.location, relation.event_R.location ) ),
                    int_mngr.equal( relation.event_L.value, relation.event_R.value ) ),
                    int_mngr.equal( relation.event_L.value, int_mngr.makeNumber( relation.event_L.id ) )
                ) );
                    break;

                case co:
                case fr:
                    break;

                default:
                    throw new Exception( "Undefined relation type in cycle." );
            }
        }
        
        return constraint;
    }

    BooleanFormula finalize(
        BooleanFormula constraint
    ) {
        for( Event event : cycle.events ) {
            if( event.was_moved )
                continue;
            constraint = bool_mngr.and(
                constraint, bool_mngr.and( 
                int_mngr.equal( event.thread_id, int_mngr.makeNumber( event.id ) ),
                int_mngr.equal( event.thread_row, int_mngr.makeNumber( 0 ) ) 
            ) );
        }

        return constraint;
    }

    void prove_program(
        BooleanFormula constraint,
        StringBuilder sb
    ) throws Exception {
        try( ProverEnvironment prover = context.newProverEnvironment( ProverOptions.GENERATE_MODELS ) ) {
            prover.addConstraint( constraint );
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
                        "\n\ttype: " + ( val_type.equals( BigInteger.ZERO ) ? "undefined" : ( val_type.equals( BigInteger.ONE ) ? "READ" : "WRITE" ) ) +
                        "\n\tlocation: " + val_location +
                        "\n\tvalue: " + val_value + 
                        "\n\tthread_id: " + val_thread_id +
                        "\n\tthread_row:" + val_thread_row +
                        "\n\twas_moved:" + event.was_moved + "\n"
                    );
                }
            } else {
                sb.append( "Program cannot exist!\n" );
            }
        }
    }

}
