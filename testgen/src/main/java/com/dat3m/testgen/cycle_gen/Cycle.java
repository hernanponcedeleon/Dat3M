package com.dat3m.testgen.cycle_gen;

import java.util.*;

/**
 * Represents a cycle of abstract events.
 */
public class Cycle {

    final int max_event;
    List <Relation> relations;

    public Cycle(
        final Stack <String> raw_cycle
    ) throws Exception {
        relations = new ArrayList<>();
        max_event = raw_cycle.size() - 1;
        
        for( int i = 0 ; i < raw_cycle.size() ; i++ ) {
            relations.add( new Relation(
                i,
                new RelationType( raw_cycle.get( i ) ),
                (i+1) % raw_cycle.size()
            ) );
        }
    }

    public Cycle(
        final String raw_cycle
    ) throws Exception {
        relations = new ArrayList<>();
        max_event = raw_cycle.length() - 1;
        
        String[] cycle_relations = raw_cycle.substring( 1, raw_cycle.length() - 1 ).split( ", " );
        for( int i = 0 ; i < cycle_relations.length ; i++ ) {
            relations.add( new Relation(
                i,
                new RelationType( cycle_relations[i] ),
                (i+1) % cycle_relations.length
            ) );
        }
    }

    @Override
    public String toString()
    {
        StringBuilder sb = new StringBuilder();
        for( final Relation r : relations ) {
            sb.append( r + "\n" );
        }
        return sb.toString();
    }

}
