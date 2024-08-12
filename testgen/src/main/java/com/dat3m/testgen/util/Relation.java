package com.dat3m.testgen.util;

import com.dat3m.testgen.program_gen.SMTEvent;

/**
 * Represents relations between events.
 * 
 * @param relation_t Types of currently supported relations.
 * @param event_L Left event involved in relation.
 * @param type Type of relation.
 * @param event_R Right event involved in relation.
 */
public class Relation {

    public enum relation_t {
        undefined,
        po,
        rf,
        co,
        rf_inv
    };

    public SMTEvent event_L;
    public relation_t type;
    public SMTEvent event_R;

    /**
     * Constructor for Relation class.
     * 
     * @param r_event_L Left event involved in relation.
     * @param r_type Type of relation.
     * @param r_event_R Right event involved in relation.
     * @throws Exception
     */
    public Relation(
        SMTEvent r_event_L,
        relation_t r_type,
        SMTEvent r_event_R
    ) throws Exception {
        if( r_event_L == null || r_event_R == null ) throw new Exception( "Events in relation cannot be null" );
        if( r_type == relation_t.undefined ) throw new Exception( "Relation type cannot be undefined" );
        this.event_L = r_event_L;
        this.type = r_type;
        this.event_R = r_event_R;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append( "[" + this.event_L + "] --" + this.type + "-> [" + this.event_R + "]" );
        return sb.toString();
    }

}

