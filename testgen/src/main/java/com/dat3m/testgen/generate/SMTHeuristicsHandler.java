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
                    smt.im.equal( events[i].eid, events[j].eid ),
                    smt.bm.and(
                        smt.im.equal( events[i].mem.location,   events[j].mem.location ),
                        smt.im.equal( events[i].thread.tid,  events[j].thread.tid ),
                        smt.im.equal( events[i].thread.row, events[j].thread.row ),
                        smt.im.equal( events[i].mem.value,      events[j].mem.value ),
                        smt.em.equivalence( events[i].instruction, events[j].instruction ),
                        smt.em.equivalence( events[i].mem.type, events[i].mem.type ),
                        smt.em.equivalence( events[i].mem.order, events[j].mem.order )
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
                        smt.im.equal( events[i].mem.location, events[j].mem.location ),
                        smt.em.equivalence( events[i].instruction, smt.instruction( "W" ) ),
                        smt.em.equivalence( events[j].instruction, smt.instruction( "W" ) )
                    ),
                    smt.bm.or(
                        smt.im.equal( events[i].eid, events[j].eid ),
                        smt.bm.not( smt.im.equal( events[i].mem.value, events[j].mem.value ) )
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
                    smt.im.equal( events[i].thread.tid , events[j].thread.tid ),
                    smt.bm.or(
                        smt.im.equal( events[i].eid, events[j].eid ),
                        smt.bm.not( smt.im.equal( events[i].thread.row, events[j].thread.row ) )
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
                BooleanFormula assumption = smt.bm.not( smt.im.equal( events[i].thread.tid, events[j].thread.tid ) );
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
                BooleanFormula assumption = smt.bm.not( smt.im.equal( events[i].mem.location, events[j].mem.location ) );
                if( !smt.prover.isUnsatWithAssumptions( Arrays.asList( assumption ) ) )
                    smt.prover.addConstraint( assumption );
            }
        }
    }

}
