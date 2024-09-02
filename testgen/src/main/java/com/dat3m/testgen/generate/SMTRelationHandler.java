package com.dat3m.testgen.generate;

import com.dat3m.testgen.util.RelationType;
import com.dat3m.testgen.util.RelationType.base_relation;

public class SMTRelationHandler {
    
    SMTRelationHandler(){}

    static void handle_relation(
        final SMTHandler   smt,
        final SMTEvent     event_L,
        final SMTEvent     event_R,
        final SMTEvent     observer_L,
        final SMTEvent     observer_R,
        final RelationType type
    ) throws Exception {      
        switch( type.type ) {
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
                    smt.em.equivalence( event_L.type, SMTInstruction.get( smt, "WRITE" ) ),
                    smt.em.equivalence( event_R.type, SMTInstruction.get( smt, "READ" ) ),
                    smt.im.equal( event_L.location, event_R.location ),
                    smt.im.equal( event_L.value, event_R.value )
                ) );
            break;

            case co:
                set_observer( smt, event_L, observer_L );
                set_observer( smt, event_R, observer_R );
                smt.prover.addConstraint( smt.bm.and(
                    smt.bm.not( smt.im.equal( event_L.event_id, event_R.event_id ) ),
                    smt.em.equivalence( event_L.type, SMTInstruction.get( smt, "WRITE" ) ),
                    smt.em.equivalence( event_R.type, SMTInstruction.get( smt, "WRITE" ) ),
                    smt.im.equal( event_L.location, event_R.location )
                ) );
                handle_relation(
                    smt,
                    observer_L, observer_R,
                    null, null,
                    new RelationType( base_relation.po )
                );
            break;

            case ext:
            case rmw:
            default:
        }
    }

    static void set_observer(
        final SMTHandler smt,
        final SMTEvent   event,
        final SMTEvent   observer
    ) throws Exception {
        smt.prover.addConstraint( smt.bm.and(
            smt.em.equivalence( observer.type, SMTInstruction.get( smt, "READ" ) ),
            smt.im.equal( observer.location, event.location ),
            smt.im.equal( observer.value, event.value )
        ) );
    }

}
