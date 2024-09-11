package com.dat3m.testgen.program;

import java.util.*;

public class ProgramGraph {
    
    public final List <ProgramEdge> edges;
    
    public ProgramGraph(
        final List <ProgramEdge> r_relations
    ) throws Exception {
        for( ProgramEdge relation_edge : r_relations )
            if( relation_edge.base == null )
                throw new Exception( "RelationEdge base relation is null." );
        edges = new ArrayList<>( r_relations );
    }

    @Override
    public String toString()
    {
        StringBuilder sb = new StringBuilder();
        for( ProgramEdge relation : edges )
            sb.append( relation + "\n" );
        return sb.toString();
    }

}
