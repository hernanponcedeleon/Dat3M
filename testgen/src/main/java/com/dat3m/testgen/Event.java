package com.dat3m.testgen;

import org.sosy_lab.java_smt.api.NumeralFormula.IntegerFormula;

public class Event {

    public enum event_operation_t {
        undefined,
        read,
        write
    };

    public final int id;
    public IntegerFormula type;
    public IntegerFormula location;
    public IntegerFormula value;
    public IntegerFormula thread_id;
    public IntegerFormula thread_row;

    public Event(
        final int r_id
    ) throws Exception {
        if( r_id < 0 ) throw new Exception( "Event id has to be non-negative." );
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
