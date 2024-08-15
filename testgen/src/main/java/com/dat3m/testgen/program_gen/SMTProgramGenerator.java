package com.dat3m.testgen.program_gen;

import java.math.BigInteger;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

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

/**
 * Generate a program given relations between events.
 */
public class SMTProgramGenerator {

    SMTCycle cycle;
    SMTCycle observers;

    Configuration config;
    LogManager logger;
    ShutdownNotifier shutdown;
    SolverContext context;
    FormulaManager fm;
    IntegerFormulaManager im;
    BooleanFormulaManager bm;
    ProverEnvironment prover;

    List <SMTEvent> all_events;

    public SMTProgramGenerator(
        final SMTCycle r_cycle
    ) throws Exception {
        if( r_cycle == null )
            throw new Exception( "Cycle object is not allowed to be null." );
        
        cycle    = r_cycle;
        observers = new SMTCycle( cycle.cycle_size );
        config   = Configuration.defaultConfiguration();
        logger   = LogManager.createNullLogManager();
        shutdown = ShutdownNotifier.createDummy();

        context = SolverContextFactory.createSolverContext(
            config, logger, shutdown, Solvers.Z3
        );

        fm = context.getFormulaManager();
        im = fm.getIntegerFormulaManager();
        bm = fm.getBooleanFormulaManager();

        prover = context.newProverEnvironment( ProverOptions.GENERATE_MODELS );

        all_events = Stream.concat( cycle.events.stream(), observers.events.stream() ).collect( Collectors.toList() );
    }

    public String generate_program()
    throws Exception {
        StringBuilder sb = new StringBuilder();
        initialize( sb );
        process_relations( sb );
        finalize( sb, cycle );
        finalize( sb, observers );
        prove_program( sb );
        return sb.toString();
    }

    /**
     * Initialize SMT variables.
     * All values are integers in the range [0, cycle_size)
     */
    void initialize(
        StringBuilder sb
    ) throws Exception {
        for( SMTEvent event : cycle.events ) {
            event.type       = im.makeVariable( event.name( "type"       ) );
            event.location   = im.makeVariable( event.name( "location"   ) );
            event.value      = im.makeVariable( event.name( "value"      ) );
            event.thread_id  = im.makeVariable( event.name( "thread_id"  ) );
            event.thread_row = im.makeVariable( event.name( "thread_row" ) );
            event.event_id   = im.makeVariable( event.name( "event_id"   ) );

            IntegerFormula attribute_formulas[] = new IntegerFormula[]{
                event.type, event.location, event.value, event.thread_id, event.thread_row, event.event_id
            };
            for( int i = 0 ; i < attribute_formulas.length ; i++ )
                prover.addConstraint( bm.and(
                    im.greaterOrEquals( attribute_formulas[i], im.makeNumber(0) ),
                    im.lessThan( attribute_formulas[i], im.makeNumber( cycle.cycle_size ) )
                ) );
        }
        for( SMTEvent event : observers.events ) {
            event.type       = im.makeVariable( event.name( "o_type"       ) );
            event.location   = im.makeVariable( event.name( "o_location"   ) );
            event.value      = im.makeVariable( event.name( "o_value"      ) );
            event.thread_id  = im.makeVariable( event.name( "o_thread_id"  ) );
            event.thread_row = im.makeVariable( event.name( "o_thread_row" ) );
            event.event_id   = im.makeVariable( event.name( "o_event_id"   ) );

            prover.addConstraint( bm.and(
                im.greaterOrEquals( event.thread_id, im.makeNumber( cycle.cycle_size ) ),
                im.lessThan( event.thread_id, im.makeNumber( 2*cycle.cycle_size ) ),
                im.greaterOrEquals( event.event_id, im.makeNumber( cycle.cycle_size ) ),
                im.lessThan( event.event_id, im.makeNumber( 2*cycle.cycle_size ) )
            ) );
            IntegerFormula attribute_formulas[] = new IntegerFormula[]{
                event.type, event.location, event.value, event.thread_row
            };
            for( int i = 0 ; i < attribute_formulas.length ; i++ )
                prover.addConstraint( bm.and(
                    im.greaterOrEquals( attribute_formulas[i], im.makeNumber( 0 ) ),
                    im.lessThan( attribute_formulas[i], im.makeNumber( cycle.cycle_size ) )
                ) );
        }
    }
    
    /**
     * Process event relations.
     * Each relation between two events gives us information based on the relation type.
     */
    void process_relations(
        StringBuilder sb
    ) throws Exception {
        for( final SMTRelation relation : cycle.relations ) {
            switch( relation.type ) {
                case po:
                    /* L.event_id != R.event_id    */ prover.addConstraint( bm.not( im.equal( relation.event_L.event_id, relation.event_R.event_id ) ) );
                    /* L.thread_id == R.thread_id  */ prover.addConstraint( im.equal( relation.event_L.thread_id, relation.event_R.thread_id ) );
                    /* L.thread_row < R.thread_row */ prover.addConstraint( im.lessThan( relation.event_L.thread_row, relation.event_R.thread_row ) );
                    break;

                case rf:
                    /* L.event_id != R.event_id */ prover.addConstraint( bm.not( im.equal( relation.event_L.event_id, relation.event_R.event_id ) ) );
                    /* L.type == W              */ prover.addConstraint( im.equal( relation.event_L.type, im.makeNumber( SMTInstructions.WRITE ) ) );
                    /* R.type == R              */ prover.addConstraint( im.equal( relation.event_R.type, im.makeNumber( SMTInstructions.READ ) ) );
                    /* L.location == R.location */ prover.addConstraint( im.equal( relation.event_L.location, relation.event_R.location ) );
                    /* L.value == R.value       */ prover.addConstraint( im.equal( relation.event_L.value, relation.event_R.value ) );
                    break;

                case co:
                    /* L.event_id != R.event_id       */ prover.addConstraint( bm.not( im.equal( relation.event_L.event_id, relation.event_R.event_id ) ) );
                    /* L.type == W                    */ prover.addConstraint( im.equal( relation.event_L.type, im.makeNumber( SMTInstructions.WRITE ) ) );
                    /* R.type == W                    */ prover.addConstraint( im.equal( relation.event_R.type, im.makeNumber( SMTInstructions.WRITE ) ) );
                    /* L.location == R.location       */ prover.addConstraint( im.equal( relation.event_L.location, relation.event_R.location ) );
                    /* Declare observer thread L      */ prover.addConstraint( im.equal( observers.events.get( relation.event_L.id ).type, im.makeNumber( SMTInstructions.OBSERVER_READ ) ) );
                    /* Set observer thread L location */ prover.addConstraint( im.equal( observers.events.get( relation.event_L.id ).location, relation.event_L.location ) );
                    /* Set observer thread L value    */ prover.addConstraint( im.equal( observers.events.get( relation.event_L.id ).value, relation.event_L.value ) );
                    /* Declare observer thread R      */ prover.addConstraint( im.equal( observers.events.get( relation.event_R.id ).type, im.makeNumber( SMTInstructions.OBSERVER_READ ) ) );
                    /* Set observer thread R location */ prover.addConstraint( im.equal( observers.events.get( relation.event_R.id ).location, relation.event_R.location ) );
                    /* Set observer thread R value    */ prover.addConstraint( im.equal( observers.events.get( relation.event_R.id ).value, relation.event_R.value ) );
                    /* Set po order between observers */ prover.addConstraint( im.equal( observers.events.get( relation.event_L.id ).thread_id, observers.events.get( relation.event_R.id ).thread_id ) );
                    /* Set po order between observers */ prover.addConstraint( im.lessThan( observers.events.get( relation.event_L.id ).thread_row, observers.events.get( relation.event_R.id ).thread_row ) );
                    break;
                    
                case rf_inv:
                    /* L.event_id != R.event_id */ prover.addConstraint( bm.not( im.equal( relation.event_L.event_id, relation.event_R.event_id ) ) );
                    /* L.type == R              */ prover.addConstraint( im.equal( relation.event_L.type, im.makeNumber( SMTInstructions.READ ) ) );
                    /* R.type == W              */ prover.addConstraint( im.equal( relation.event_R.type, im.makeNumber( SMTInstructions.WRITE ) ) );
                    /* L.location == R.location */ prover.addConstraint( im.equal( relation.event_L.location, relation.event_R.location ) );
                    /* L.value == R.value       */ prover.addConstraint( im.equal( relation.event_L.value, relation.event_R.value ) );
                    break;

                default:
                    throw new Exception( "Undefined relation type in cycle." );
            }
        }
    }

    /**
     * Add final extra assertions to the program.
     * Rules marked as [H] are Heuristics, and aren't required for correctness.
     * Rule 2. is required for correctness, since the equivalence depends on the value that is being written by writes to the same location.
     */
    void finalize(
        StringBuilder sb,
        SMTCycle cycle
    ) throws Exception {
        /* 1. Handle equivalence between events */
        for( int i = 0 ; i < cycle.events.size() ; i++ ) {
            for( int j = 0 ; j < cycle.events.size() ; j++ ) {
                prover.addConstraint( bm.implication(
                    im.equal( cycle.events.get(i).event_id, cycle.events.get(j).event_id ),
                    bm.and( bm.and(
                        im.equal( cycle.events.get(i).type,       cycle.events.get(j).type ),
                        im.equal( cycle.events.get(i).location,   cycle.events.get(j).location ) ), bm.and( bm.and(
                        im.equal( cycle.events.get(i).thread_id,  cycle.events.get(j).thread_id ),
                        im.equal( cycle.events.get(i).thread_row, cycle.events.get(j).thread_row ) ),
                        im.equal( cycle.events.get(i).value,      cycle.events.get(j).value ) )
                    )
                ) );
            }
        }
        /* 2. Each two writes at the same memory location, either have different value or are equivalent events */
        for( int i = 0 ; i < cycle.events.size() ; i++ ) {
            for( int j = 0 ; j < cycle.events.size() ; j++ ) {
                prover.addConstraint( bm.implication( bm.and(
                    im.equal( cycle.events.get(i).location, cycle.events.get(j).location ),
                    im.equal( cycle.events.get(i).type, im.makeNumber( SMTInstructions.WRITE ) ),
                    im.equal( cycle.events.get(j).type, im.makeNumber( SMTInstructions.WRITE ) ) ), bm.or(
                    im.equal( cycle.events.get(i).event_id, cycle.events.get(j).event_id ),
                    bm.not( im.equal( cycle.events.get(i).value, cycle.events.get(j).value ) )
                ) ) );
            }
        }
        /* 3. [H] Events that don't have to be in the same thread, won't be in the same thread */
        for( int i = 0 ; i < cycle.events.size() ; i++ ) {
            for( int j = 0 ; j < cycle.events.size() ; j++ ) {
                if( !prover.isUnsatWithAssumptions( Arrays.asList(
                    bm.not( im.equal( cycle.events.get(i).thread_id, cycle.events.get(j).thread_id ) )
                ) ) ) {
                    prover.addConstraint( bm.not( im.equal( cycle.events.get(i).thread_id, cycle.events.get(j).thread_id ) ) );
                }
            }
        }
        /* 4. [H] Events that don't have to access the same memory location, won't access the same memory location */
        for( int i = 0 ; i < cycle.events.size() ; i++ ) {
            for( int j = 0 ; j < cycle.events.size() ; j++ ) {
                if( !prover.isUnsatWithAssumptions( Arrays.asList(
                    bm.not( im.equal( cycle.events.get(i).location, cycle.events.get(j).location ) )
                ) ) ) {
                    prover.addConstraint( bm.not( im.equal( cycle.events.get(i).location, cycle.events.get(j).location ) ) );
                }
            }
        }
        /* 5. [H] Events that don't have to be defined, won't be defined */
        for( int i = 0 ; i < cycle.events.size() ; i++ ) {
            if( !prover.isUnsatWithAssumptions( Arrays.asList(
                im.equal( cycle.events.get(i).type, im.makeNumber( SMTInstructions.UNDEFINED ) )
            ) ) ) {
                prover.addConstraint( im.equal( cycle.events.get(i).type, im.makeNumber( SMTInstructions.UNDEFINED ) ) );
            }
        }
    }

    /**
     * Generate a program from the SMT constraints.
     */
    void prove_program(
        StringBuilder sb
    ) throws Exception {
        if( prover.isUnsat() ) {
            sb.append( "Program cannot exist!" );
            return;
        }
        Model model = prover.getModel();
        for( final SMTEvent event : all_events ) {
            BigInteger val_type = model.evaluate( event.type );
            BigInteger val_location = model.evaluate( event.location );
            BigInteger val_value = model.evaluate( event.value );
            BigInteger val_thread_id = model.evaluate( event.thread_id );
            BigInteger val_thread_row = model.evaluate( event.thread_row );
            BigInteger val_event_id = model.evaluate( event.event_id );
            sb.append(
                val_event_id.toString() + "," +
                val_type.toString() + "," +
                val_location.toString() + "," +
                val_value.toString() + "," +
                val_thread_id.toString() + "," +
                val_thread_row.toString() + "\n"
            );
        }
    }

}
