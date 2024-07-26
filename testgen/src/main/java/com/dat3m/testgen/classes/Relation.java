package com.dat3m.testgen.classes;

public class Relation {

    public enum relation_t {
        undefined,
        po,
        rf,
        co,
        fr
    };

    Event event_L;
    relation_t type;
    Event event_R;

    public Relation(
        Event r_event_L,
        relation_t r_type,
        Event r_event_R
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
