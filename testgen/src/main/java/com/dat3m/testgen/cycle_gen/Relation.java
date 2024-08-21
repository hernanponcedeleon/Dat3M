package com.dat3m.testgen.cycle_gen;

/**
 * Represents a relation between two abstract events.
 */
public class Relation {

    public final int event_L_id;
    public final RelationType type;
    public final int event_R_id;

    public Relation(
        final int r_event_L_id,
        final RelationType r_type,
        final int r_event_R_id
    ) throws Exception {
        if( r_event_L_id < 0 || r_event_R_id < 0 )
            throw new Exception( "Event ids cannot be negative" );
        event_L_id = r_event_L_id;
        type = r_type;
        event_R_id = r_event_R_id;
    }

    @Override
    public String toString()
    {
        StringBuilder sb = new StringBuilder();
        sb.append( event_L_id + " --" + type + "-> " + event_R_id );
        return sb.toString();
    }

}
