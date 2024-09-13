package com.dat3m.testgen.generate;

import org.sosy_lab.java_smt.api.BooleanFormula;

import com.dat3m.testgen.util.Types;

class SMTBaseRelationHandler {
    
    SMTBaseRelationHandler(){}

    static BooleanFormula handle_relation(
        final SMTHandler smt,
        final SMTEvent   event_L,
        final SMTEvent   event_R,
        final SMTEvent   observer_L,
        final SMTEvent   observer_R,
        final Types.base type
    ) throws Exception {      
        switch( type ) {
            case po:
                return smt.bm.and(
                    smt.bm.not( smt.im.equal( event_L.eid, event_R.eid ) ),
                    smt.im.equal( event_L.thread.tid, event_R.thread.tid ),
                    smt.im.lessThan( event_L.thread.row, event_R.thread.row )
                );
            
            case rf:
                return smt.bm.and(
                    smt.bm.not( smt.im.equal( event_L.eid, event_R.eid ) ),
                    smt.em.equivalence( event_L.instruction, smt.instruction( "W" ) ),
                    smt.em.equivalence( event_R.instruction, smt.instruction( "R" ) ),
                    smt.im.equal( event_L.mem.location, event_R.mem.location ),
                    smt.im.equal( event_L.mem.value, event_R.mem.value )
                );

            case co:
                return smt.bm.and(
                    set_observer( smt, event_L, observer_L ),
                    set_observer( smt, event_R, observer_R ),
                    smt.bm.not( smt.im.equal( event_L.eid, event_R.eid ) ),
                    smt.em.equivalence( event_L.instruction, smt.instruction( "W" ) ),
                    smt.em.equivalence( event_R.instruction, smt.instruction( "W" ) ),
                    smt.im.equal( event_L.mem.location, event_R.mem.location ),
                    handle_relation( smt, observer_L, observer_R, null, null, Types.base.po )
                );

            case ext:
                return smt.bm.and(
                    smt.bm.not( smt.im.equal( event_L.eid, event_R.eid ) ),
                    smt.bm.not( smt.im.equal( event_L.thread.tid, event_R.thread.tid ) )
                );

            case rmw:
                return smt.bm.and(
                    smt.bm.not( smt.im.equal( event_L.eid, event_R.eid ) ),
                    smt.im.equal( event_L.thread.tid, event_R.thread.tid ),
                    smt.im.equal( event_L.thread.row, smt.im.subtract( event_R.thread.row, smt.im.makeNumber(1) ) ),
                    smt.im.equal( event_L.mem.location, event_R.mem.location ),
                    smt.em.equivalence( event_L.instruction, smt.instruction( "R" ) ),
                    smt.em.equivalence( event_R.instruction, smt.instruction( "W" ) )
                );

            case read:
                return smt.bm.and(
                    smt.im.equal( event_L.eid, event_R.eid ),
                    smt.em.equivalence( event_L.instruction, smt.instruction( "R" ) )
                );

            case write:
                return smt.bm.and(
                    smt.im.equal( event_L.eid, event_R.eid ),
                    smt.em.equivalence( event_L.instruction, smt.instruction( "W" ) )
                );
    
            case loc:
                return smt.bm.and(
                    smt.bm.not( smt.im.equal( event_L.eid, event_R.eid ) ),
                    smt.im.equal( event_L.mem.location, event_R.mem.location )
                );

            default:
                System.out.println( "[ERROR] " + type );
                throw new Exception( "Relation type does not have defined rules!" );
        }
    }

    static BooleanFormula set_observer(
        final SMTHandler smt,
        final SMTEvent   event,
        final SMTEvent   observer
    ) throws Exception {
        return smt.bm.and(
            smt.em.equivalence( observer.instruction, smt.instruction( "R" ) ),
            smt.im.equal( observer.mem.location, event.mem.location ),
            smt.im.equal( observer.mem.value, event.mem.value )
        );
    }

}
