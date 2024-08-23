package com.dat3m.testgen.old.program_gen;

import java.util.ArrayList;
import java.util.List;

/**
 * Represents a list of events and the relations between them.
 */
public class SMTCycle {
    
    public final int cycle_size;
    public List <SMTEvent> events;
    public List <SMTRelation> relations;

    public SMTCycle(
        final int r_cycle_size
    ) throws Exception {
        if( r_cycle_size <= 1 )
            throw new Exception( "Cycle size must be greater than 1." );
        cycle_size = r_cycle_size;
        events     = new ArrayList<>();
        relations  = new ArrayList<>();
        for( int i = 0 ; i < cycle_size ; i++ )
            events.add( new SMTEvent( i ) );
    }

    public void create_relation(
        final int event_L_id,
        final SMTRelation.relation_t relation_type,
        final int event_R_id
    ) throws Exception {
        if( !( 0 <= event_L_id && event_L_id < cycle_size ) )
            throw new Exception( "Left event id is out of bounds." );
        if( relation_type == SMTRelation.relation_t.undefined )
            throw new Exception( "Relation type cannot be undefined." );
        if( !( 0 <= event_R_id && event_R_id < cycle_size ) )
            throw new Exception( "Right event id is out of bounds." );
        relations.add( new SMTRelation( events.get( event_L_id ), relation_type, events.get( event_R_id ) ) );
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append( "Cycle Events:\n" );
        for( final SMTEvent e : events )
            sb.append( "\t" + e + '\n' );
        sb.append( "Cycle Relations:\n" );
        for( final SMTRelation r : relations )
            sb.append( "\t" + r + '\n' );
        return sb.toString();
    }
    
}
