package com.dat3m.testgen.program_gen;

import org.sosy_lab.java_smt.api.NumeralFormula.IntegerFormula;

/**
 * Describes a single event (as a reference).
 */
public class SMTEvent {

    public final int id;
    public IntegerFormula type;
    public IntegerFormula location;
    public IntegerFormula value;
    public IntegerFormula thread_id;
    public IntegerFormula thread_row;
    public IntegerFormula event_id;

    public SMTEvent(
        final int r_id
    ) throws Exception {
        if( r_id < 0 )
            throw new Exception( "Event id has to be non-negative." );
        this.id = r_id;
    }

    public String name(
        final String suffix
    ) {
        return "e" + id + "_" + suffix;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append( "[Event: " + this.id + "]" );
        return sb.toString();
    }

}
