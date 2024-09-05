package com.dat3m.testgen.generate;

import org.sosy_lab.java_smt.api.BooleanFormula;

import com.dat3m.testgen.util.BaseRelations;

class SMTRelationHandler {
    
    SMTRelationHandler(){}

    static BooleanFormula handle_relation(
        final SMTHandler         smt,
        final SMTEvent           event_L,
        final SMTEvent           event_R,
        final SMTEvent           observer_L,
        final SMTEvent           observer_R,
        final BaseRelations.type type
    ) throws Exception {      
        switch( type ) {
            case po:
                return smt.bm.and(
                    smt.bm.not( smt.im.equal( event_L.event_id, event_R.event_id ) ),
                    smt.im.equal( event_L.thread_id, event_R.thread_id ),
                    smt.im.lessThan( event_L.thread_row, event_R.thread_row )
                );
            
            case rf:
                return smt.bm.and(
                    smt.bm.not( smt.im.equal( event_L.event_id, event_R.event_id ) ),
                    smt.em.equivalence( event_L.type, smt.instruction( "W" ) ),
                    smt.em.equivalence( event_R.type, smt.instruction( "R" ) ),
                    smt.im.equal( event_L.location, event_R.location ),
                    smt.im.equal( event_L.value, event_R.value )
                );

            case co:
                return smt.bm.and(
                    set_observer( smt, event_L, observer_L ),
                    set_observer( smt, event_R, observer_R ),
                    smt.bm.not( smt.im.equal( event_L.event_id, event_R.event_id ) ),
                    smt.em.equivalence( event_L.type, smt.instruction( "W" ) ),
                    smt.em.equivalence( event_R.type, smt.instruction( "W" ) ),
                    smt.im.equal( event_L.location, event_R.location ),
                    handle_relation( smt, observer_L, observer_R, null, null, BaseRelations.type.po )
                );

            case ext:
                return smt.bm.and(
                    smt.bm.not( smt.im.equal( event_L.event_id, event_R.event_id ) ),
                    smt.bm.not( smt.im.equal( event_L.thread_id, event_R.thread_id ) )
                );

            case rmw:
                return smt.bm.and(
                    smt.bm.not( smt.im.equal( event_L.event_id, event_R.event_id ) ),
                    smt.im.equal( event_L.thread_id, event_R.thread_id ),
                    smt.im.equal( event_L.thread_row, smt.im.subtract( event_R.thread_row, smt.im.makeNumber(1) ) ),
                    smt.im.equal( event_L.location, event_R.location ),
                    smt.em.equivalence( event_L.type, smt.instruction( "R" ) ),
                    smt.em.equivalence( event_R.type, smt.instruction( "W" ) )
                );

            case read:
                return smt.bm.and(
                    smt.im.equal( event_L.event_id, event_R.event_id ),
                    smt.em.equivalence( event_L.type, smt.instruction( "R" ) )
                );

            case write:
                return smt.bm.and(
                    smt.im.equal( event_L.event_id, event_R.event_id ),
                    smt.em.equivalence( event_L.type, smt.instruction( "W" ) )
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
            smt.em.equivalence( observer.type, smt.instruction( "R" ) ),
            smt.im.equal( observer.location, event.location ),
            smt.im.equal( observer.value, event.value )
        );
    }

}
