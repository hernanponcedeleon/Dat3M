package com.dat3m.testgen.old.cycle_gen;

import java.util.*;

/**
 * Represents a cycle of abstract events.
 */
public class GrammarCycle {

    final int max_event;
    List <GrammarRelation> relations;

    public GrammarCycle(
        final Stack <String> raw_cycle
    ) throws Exception {
        relations = new ArrayList<>();
        max_event = raw_cycle.size() - 1;
        
        for( int i = 0 ; i < raw_cycle.size() ; i++ ) {
            relations.add( new GrammarRelation(
                i,
                new GrammarRelationType( raw_cycle.get( i ) ),
                (i+1) % raw_cycle.size()
            ) );
        }
    }

    public GrammarCycle(
        final String raw_cycle
    ) throws Exception {
        relations = new ArrayList<>();
        max_event = raw_cycle.length() - 1;
        
        String[] cycle_relations = raw_cycle.substring( 1, raw_cycle.length() - 1 ).split( ", " );
        for( int i = 0 ; i < cycle_relations.length ; i++ ) {
            relations.add( new GrammarRelation(
                i,
                new GrammarRelationType( cycle_relations[i] ),
                (i+1) % cycle_relations.length
            ) );
        }
    }

    @Override
    public String toString()
    {
        StringBuilder sb = new StringBuilder();
        for( final GrammarRelation r : relations ) {
            sb.append( r + "\n" );
        }
        return sb.toString();
    }

}
