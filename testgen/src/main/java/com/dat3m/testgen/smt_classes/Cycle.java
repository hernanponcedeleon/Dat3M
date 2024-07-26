package com.dat3m.testgen.smt_classes;

import java.util.ArrayList;
import java.util.List;

public class Cycle {
    
    public final int cycle_size;
    public List <Event> events;
    public List <Relation> relations;

    public Cycle(
        final int r_cycle_size
    ) throws Exception {
        if( r_cycle_size <= 1 ) throw new Exception( "Cycle size must be greater than 1." );
        this.cycle_size = r_cycle_size;
        events = new ArrayList<>();
        relations = new ArrayList<>();
        for( int i = 0 ; i < this.cycle_size ; i++ ) {
            this.events.add( new Event( i ) );
        }
    }

    public void create_relation(
        final int event_L_id,
        final Relation.relation_t relation_type,
        final int event_R_id
    ) throws Exception {
        if( !( 0 <= event_L_id && event_L_id < cycle_size ) ) throw new Exception( "Left event id is out of bounds." );
        if( relation_type == Relation.relation_t.undefined ) throw new Exception( "Relation type cannot be undefined." );
        if( !( 0 <= event_R_id && event_R_id < cycle_size ) ) throw new Exception( "Right event id is out of bounds." );
        if( event_L_id == event_R_id ) throw new Exception( "Event cannot be in a relation with itself." );
        relations.add( new Relation( events.get( event_L_id ), relation_type, events.get( event_R_id ) ) );
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append( "Cycle Events:\n" );
        for( final Event e : events )
            sb.append( "\t" + e + '\n' );
        sb.append( "Cycle Relations:\n" );
        for( final Relation r : relations )
            sb.append( "\t" + r + '\n' );
        return sb.toString();
    }
    
}
