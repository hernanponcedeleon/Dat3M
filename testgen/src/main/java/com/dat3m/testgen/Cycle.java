package com.dat3m.testgen;

import java.util.ArrayList;
import java.util.List;

/**
 * Represents a list of events and the relations between them.
 * 
 * @param cycle_size Amount of events in the cycle.
 * @param events List of events that will be in the resulting program.
 * @param relations List of relations between events.
 */
public class Cycle {
    
    public final int cycle_size;
    public List <Event> events;
    public List <Relation> relations;

    /**
     * Constructor for Cycle class.
     * 
     * @param r_cycle_size Amount of events in the cycle.
     * @throws Exception
     */
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

    /**
     * Creates a relation between two events (given their event ids).
     * 
     * @param event_L_id Event id of left event.
     * @param relation_type Relation type.
     * @param event_R_id Event id of right event.
     * @throws Exception
     */
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
