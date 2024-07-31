package com.dat3m.testgen.smt_classes;

import java.math.BigInteger;

import org.sosy_lab.common.ShutdownNotifier;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.log.LogManager;
import org.sosy_lab.java_smt.SolverContextFactory;
import org.sosy_lab.java_smt.SolverContextFactory.Solvers;
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

    UnionFindDisjointSet thread_ufds;
    UnionFindDisjointSet memory_ufds;

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

        thread_ufds = new UnionFindDisjointSet( cycle.cycle_size );
        memory_ufds = new UnionFindDisjointSet( cycle.cycle_size );

        prover = context.newProverEnvironment( ProverOptions.GENERATE_MODELS );
    }

    public String generate_program()
    throws Exception {
        StringBuilder sb = new StringBuilder();

        initialize( sb );

        process_relations( sb );

        finalize( sb );

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
                prover.addConstraint( int_mngr.greaterOrEquals( attribute_formulas[i], int_mngr.makeNumber( 0 ) ) );
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
                    thread_ufds.merge( relation.event_L.id, relation.event_R.id );
                    prover.addConstraint( int_mngr.equal( relation.event_L.thread_id , relation.event_R.thread_id ) );
                    prover.addConstraint( int_mngr.lessThan( relation.event_L.thread_row , relation.event_R.thread_row ) );
                    break;

                case rf:
                    memory_ufds.merge( relation.event_L.id, relation.event_R.id );
                    prover.addConstraint( int_mngr.equal( relation.event_L.type, int_mngr.makeNumber( WRITE_INSTRUCTION ) ) );
                    prover.addConstraint( int_mngr.equal( relation.event_R.type, int_mngr.makeNumber( READ_INSTRUCTION ) ) );
                    prover.addConstraint( int_mngr.equal( relation.event_L.location, relation.event_R.location ) );
                    prover.addConstraint( int_mngr.equal( relation.event_L.value, relation.event_R.value ) );
                    break;

                case co:
                    memory_ufds.merge( relation.event_L.id, relation.event_R.id );
                    prover.addConstraint( int_mngr.equal( relation.event_L.type, int_mngr.makeNumber( WRITE_INSTRUCTION ) ) );
                    prover.addConstraint( int_mngr.equal( relation.event_R.type, int_mngr.makeNumber( WRITE_INSTRUCTION ) ) );
                    prover.addConstraint( int_mngr.equal( relation.event_L.location, relation.event_R.location ) );
                    break;
                    
                case rf_inv:
                    memory_ufds.merge( relation.event_L.id, relation.event_R.id );
                    prover.addConstraint( int_mngr.equal( relation.event_L.type, int_mngr.makeNumber( READ_INSTRUCTION ) ) );
                    prover.addConstraint( int_mngr.equal( relation.event_R.type, int_mngr.makeNumber( WRITE_INSTRUCTION ) ) );
                    prover.addConstraint( int_mngr.equal( relation.event_L.location, relation.event_R.location ) );
                    prover.addConstraint( int_mngr.equal( relation.event_L.value, relation.event_R.value ) );
                    break;

                default:
                    throw new Exception( "Undefined relation type in cycle." );
            }
        }
    }

    void finalize(
        StringBuilder sb
    ) throws Exception {
        for( final Event event : cycle.events ) {
            if( thread_ufds.find_set( event.id ) == event.id ) {
                /* Events that don't have to be in the same thread, won't be in the same thread */
                for( final Event t_event : cycle.events ) {
                    if( thread_ufds.are_same_set( event.id, t_event.id ) )
                        continue;
                    if( thread_ufds.find_set( t_event.id ) != t_event.id )
                        continue;
                    prover.addConstraint( bool_mngr.not( int_mngr.equal( event.thread_id , t_event.thread_id ) ) );
                }
            }
            if( memory_ufds.find_set( event.id ) == event.id ) {
                /* Events that don't have to access the same memory location, won't access the same memory location */
                for( final Event t_event : cycle.events ) {
                    if( memory_ufds.are_same_set( event.id, t_event.id ) )
                        continue;
                    if( memory_ufds.find_set( t_event.id ) != t_event.id )
                        continue;
                    prover.addConstraint( bool_mngr.not( int_mngr.equal( event.location , t_event.location ) ) );
                }
                /* All writes to a memory location will be with a distinct value */
                for( final Event event_1 : cycle.events ) {
                    if( !memory_ufds.are_same_set( event.id, event_1.id ) )
                        continue;
                    for( final Event event_2 : cycle.events ) {
                        if( !memory_ufds.are_same_set( event.id, event_2.id ) || event_1 == event_2 )
                            continue;
                        prover.addConstraint(
                            bool_mngr.implication(
                                bool_mngr.and(
                                    int_mngr.equal( event_1.type, int_mngr.makeNumber( WRITE_INSTRUCTION ) ),
                                    int_mngr.equal( event_2.type, int_mngr.makeNumber( WRITE_INSTRUCTION ) )
                                ),
                                bool_mngr.not( int_mngr.equal( event_1.value , event_2.value ) )
                            )
                        );
                    }
                }
            }
        }
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
