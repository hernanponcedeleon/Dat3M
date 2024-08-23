package com.dat3m.testgen.old.cycle_gen;

/**
 * Represents a relation between two abstract events.
 */
public class GrammarRelation {

    public final int event_L_id;
    public final GrammarRelationType type;
    public final int event_R_id;

    public GrammarRelation(
        final int r_event_L_id,
        final GrammarRelationType r_type,
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
