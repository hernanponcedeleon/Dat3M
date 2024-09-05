package com.dat3m.testgen.generate;

import com.dat3m.testgen.util.BaseRelations;

public class SMTRelationHandler {
    
    SMTRelationHandler(){}

    static void handle_relation(
        final SMTHandler         smt,
        final SMTEvent           event_L,
        final SMTEvent           event_R,
        final SMTEvent           observer_L,
        final SMTEvent           observer_R,
        final BaseRelations.type type
    ) throws Exception {      
        switch( type ) {
            case po:
                smt.prover.addConstraint( smt.bm.and(
                    smt.bm.not( smt.im.equal( event_L.event_id, event_R.event_id ) ),
                    smt.im.equal( event_L.thread_id, event_R.thread_id ),
                    smt.im.lessThan( event_L.thread_row, event_R.thread_row )
                ) );
            break;
            
            case rf:
                smt.prover.addConstraint( smt.bm.and(
                    smt.bm.not( smt.im.equal( event_L.event_id, event_R.event_id ) ),
                    smt.em.equivalence( event_L.type, SMTInstruction.get( smt, "W" ) ),
                    smt.em.equivalence( event_R.type, SMTInstruction.get( smt, "R" ) ),
                    smt.im.equal( event_L.location, event_R.location ),
                    smt.im.equal( event_L.value, event_R.value )
                ) );
            break;

            case co:
                set_observer( smt, event_L, observer_L );
                set_observer( smt, event_R, observer_R );
                smt.prover.addConstraint( smt.bm.and(
                    smt.bm.not( smt.im.equal( event_L.event_id, event_R.event_id ) ),
                    smt.em.equivalence( event_L.type, SMTInstruction.get( smt, "W" ) ),
                    smt.em.equivalence( event_R.type, SMTInstruction.get( smt, "W" ) ),
                    smt.im.equal( event_L.location, event_R.location )
                ) );
                handle_relation( smt, observer_L, observer_R, null, null, BaseRelations.type.po );
            break;

            case ext:
                smt.prover.addConstraint( smt.bm.and(
                    smt.bm.not( smt.im.equal( event_L.event_id, event_R.event_id ) ),
                    smt.bm.not( smt.im.equal( event_L.thread_id, event_R.thread_id ) )
                ) );
            break;

            case rmw:
                smt.prover.addConstraint( smt.bm.and(
                    smt.bm.not( smt.im.equal( event_L.event_id, event_R.event_id ) ),
                    smt.im.equal( event_L.thread_id, event_R.thread_id ),
                    smt.im.equal( event_L.thread_row, smt.im.subtract( event_R.thread_row, smt.im.makeNumber(1) ) ),
                    smt.im.equal( event_L.location, event_R.location ),
                    smt.em.equivalence( event_L.type, SMTInstruction.get( smt, "R" ) ),
                    smt.em.equivalence( event_R.type, SMTInstruction.get( smt, "W" ) )
                ) );
            break;

            case read:
                smt.prover.addConstraint( smt.bm.and(
                    smt.im.equal( event_L.event_id, event_R.event_id ),
                    smt.em.equivalence( event_L.type, SMTInstruction.get( smt, "R" ) )
                ) );
            break;

            case write:
                smt.prover.addConstraint( smt.bm.and(
                    smt.im.equal( event_L.event_id, event_R.event_id ),
                    smt.em.equivalence( event_L.type, SMTInstruction.get( smt, "W" ) )
                ) );
            break;
    
            default:
                System.out.println( "[ERROR] " + type );
                throw new Exception( "Relation type does not have defined rules!" );
        }
    }

    static void set_observer(
        final SMTHandler smt,
        final SMTEvent   event,
        final SMTEvent   observer
    ) throws Exception {
        smt.prover.addConstraint( smt.bm.and(
            smt.em.equivalence( observer.type, SMTInstruction.get( smt, "R" ) ),
            smt.im.equal( observer.location, event.location ),
            smt.im.equal( observer.value, event.value )
        ) );
    }

}
