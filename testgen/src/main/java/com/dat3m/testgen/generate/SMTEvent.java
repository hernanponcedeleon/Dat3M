package com.dat3m.testgen.generate;

import org.sosy_lab.java_smt.api.EnumerationFormula;
import org.sosy_lab.java_smt.api.NumeralFormula.IntegerFormula;

public class SMTEvent {
    
    final int self_id;
    public EnumerationFormula type;
    public IntegerFormula location;
    public IntegerFormula value;
    public IntegerFormula thread_id;
    public IntegerFormula thread_row;
    public IntegerFormula event_id;

    SMTEvent(
        final int r_self_id
    ) throws Exception {
        if( r_self_id <= 0 )
            throw new Exception( "Event id has to be greater than zero." );
        self_id = r_self_id;
    }

    String name(
        final String suffix
    ) {
        return "e" + self_id + "_" + suffix;
    }

    void init(
        final SMTHandler smt,
        final int event_id_lower_bound,
        final int max_events
    ) throws Exception {
        type       = smt.em.makeVariable( name( "type" ) , SMTInstruction.enum_type );
        location   = smt.im.makeVariable( name( "location" ) );
        value      = smt.im.makeVariable( name( "value" ) );
        thread_id  = smt.im.makeVariable( name( "thread_id" ) );
        thread_row = smt.im.makeVariable( name( "thread_row" ) );
        event_id   = smt.im.makeVariable( name( "event_id" ) );
        smt.prover.addConstraint( smt.bm.and(
            smt.im.greaterThan(  location,   smt.im.makeNumber( 0 ) ),
            smt.im.lessOrEquals( location,   smt.im.makeNumber( max_events ) ),
            smt.im.greaterThan(  value,      smt.im.makeNumber( 0 ) ),
            smt.im.lessOrEquals( value,      smt.im.makeNumber( max_events ) ),
            smt.im.greaterThan(  thread_id,  smt.im.makeNumber( event_id_lower_bound ) ),
            smt.im.lessOrEquals( thread_id,  smt.im.makeNumber( event_id_lower_bound + max_events ) ),
            smt.im.greaterThan(  thread_row, smt.im.makeNumber( 0 ) ),
            smt.im.lessOrEquals( thread_row, smt.im.makeNumber( max_events ) ),
            smt.im.greaterThan(  event_id,   smt.im.makeNumber( event_id_lower_bound ) ),
            smt.im.lessOrEquals( event_id,   smt.im.makeNumber( event_id_lower_bound + max_events ) )
        ) );
    }

}
