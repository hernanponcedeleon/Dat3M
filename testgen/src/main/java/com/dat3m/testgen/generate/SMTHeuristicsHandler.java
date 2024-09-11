package com.dat3m.testgen.generate;

import java.util.*;

import org.sosy_lab.java_smt.api.BooleanFormula;

class SMTHeuristicsHandler {

    final SMTHandler smt;
    final SMTEvent[] events;

    SMTHeuristicsHandler(
        final SMTHandler r_smt,
        final SMTEvent[] r_events
    ) {
        smt    = r_smt;
        events = r_events;
    }

    void apply_heuristics(
        String... heuristics
    ) throws Exception {
        for( String heuristic : heuristics ) {
            switch( heuristic ) {
                case "equivalence":
                    equivalence_h();
                break;

                case "memory_distinction":
                    memory_distinction();
                break;

                case "row_maximization":
                    row_maximization();
                break;

                case "thread_maximization":
                    thread_maximization();
                break;

                case "memory_maximization":
                    memory_maximization();
                break;

                case "event_minimization":
                    event_minimization();
                break;

                default:
                    System.out.println( "[ERROR] " + heuristic );
                    throw new Exception( "Unknown heuristic type!" );
            }
        }
    }
    
    /**
     * Handle equivalence between events
     */
    void equivalence_h() throws Exception {
        for( int i = 0 ; i < events.length ; i++ ) {
            for( int j = 0 ; j < events.length ; j++ ) {
                smt.prover.addConstraint( smt.bm.implication(
                    smt.im.equal( events[i].event_id, events[j].event_id ),
                    smt.bm.and(
                        smt.em.equivalence( events[i].type, events[j].type ),
                        smt.im.equal( events[i].location,   events[j].location ),
                        smt.im.equal( events[i].thread_id,  events[j].thread_id ),
                        smt.im.equal( events[i].thread_row, events[j].thread_row ),
                        smt.im.equal( events[i].value,      events[j].value )
                ) ) );
            }
        }
    }

    /**
     * Each two writes at the same memory location, either have different value or are equivalent events
     */
    void memory_distinction() throws Exception {
        for( int i = 0 ; i < events.length ; i++ ) {
            for( int j = 0 ; j < events.length ; j++ ) {
                smt.prover.addConstraint( smt.bm.implication(
                    smt.bm.and(
                        smt.im.equal( events[i].location, events[j].location ),
                        smt.em.equivalence( events[i].type, smt.instruction( "W" ) ),
                        smt.em.equivalence( events[j].type, smt.instruction( "W" ) )
                    ),
                    smt.bm.or(
                        smt.im.equal( events[i].event_id, events[j].event_id ),
                        smt.bm.not( smt.im.equal( events[i].value, events[j].value ) )
                    )
                ) );
            }
        }
    }

    /**
     * Each two events on the same thread, either have different rows or are equivalent events
     */
    void row_maximization() throws Exception {
        for( int i = 0 ; i < events.length ; i++ ) {
            for( int j = 0 ; j < events.length ; j++ ) {
                smt.prover.addConstraint( smt.bm.implication(
                    smt.im.equal( events[i].thread_id , events[j].thread_id ),
                    smt.bm.or(
                        smt.im.equal( events[i].event_id, events[j].event_id ),
                        smt.bm.not( smt.im.equal( events[i].thread_row, events[j].thread_row ) )
                    )
                ) );
            }
        }
    }

    /**
     * [Optional] Events that don't have to be in the same thread, won't be in the same thread
     */
    void thread_maximization() throws Exception {
        for( int i = 0 ; i < events.length ; i++ ) {
            for( int j = 0 ; j < events.length ; j++ ) {
                BooleanFormula assumption = smt.bm.not( smt.im.equal( events[i].thread_id, events[j].thread_id ) );
                if( !smt.prover.isUnsatWithAssumptions( Arrays.asList( assumption ) ) )
                    smt.prover.addConstraint( assumption );
            }
        }
    }

    /**
     * [Optional] Events that don't have to access the same memory location, won't access the same memory location
     */
    void memory_maximization() throws Exception {
        for( int i = 0 ; i < events.length ; i++ ) {
            for( int j = 0 ; j < events.length ; j++ ) {
                BooleanFormula assumption = smt.bm.not( smt.im.equal( events[i].location, events[j].location ) );
                if( !smt.prover.isUnsatWithAssumptions( Arrays.asList( assumption ) ) )
                    smt.prover.addConstraint( assumption );
            }
        }
    }

    /**
     * [Optional] Events that don't have to be defined, won't be defined
     */
    void event_minimization() throws Exception {
        for( int i = 0 ; i < events.length ; i++ ) {
            BooleanFormula assumption = smt.em.equivalence( events[i].type, smt.instruction( "UNDEFINED" ) );
            if( !smt.prover.isUnsatWithAssumptions( Arrays.asList( assumption ) ) ) {
                smt.prover.addConstraint( assumption );
            }
        }
    }

}
