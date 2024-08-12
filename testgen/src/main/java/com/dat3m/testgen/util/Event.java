package com.dat3m.testgen.util;

import org.sosy_lab.java_smt.api.NumeralFormula.IntegerFormula;

/**
 * Describes a single event (as a reference).
 * 
 * @param event_opration_t Types of events (read, write, etc.).
 * @param id Unique identifier for this event reference.
 * @param type SMT integer for event type.
 * @param location SMT integer for memory access location.
 * @param value SMT integer for memory access value.
 * @param thread_id SMT integer for which thread this event belongs to.
 * @param thread_row SMT integer for which row in the thread this event belongs to.
 * @param event_id ID of the 'real' event this SMT object is referencing.
 */
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
    public IntegerFormula event_id;

    /**
     * Constructor for Event class.
     * 
     * @param r_id Unique identifier for this event reference.
     * @throws Exception
     */
    public Event(
        final int r_id
    ) throws Exception {
        if( r_id < 0 ) throw new Exception( "Event id has to be non-negative." );
        this.id = r_id;
    }

    /**
     * Name generator function for variable names in SMT solver.
     * 
     * @param suffix Suffix to add to the name.
     * @return
     */
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
