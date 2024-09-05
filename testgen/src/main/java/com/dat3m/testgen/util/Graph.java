package com.dat3m.testgen.util;

import java.util.*;

public class Graph {
    
    public final List <RelationEdge> edges;
    
    public Graph(
        final List <RelationEdge> r_relations
    ) throws Exception {
        for( RelationEdge relation_edge : r_relations )
            if( relation_edge.base == null )
                throw new Exception( "RelationEdge base relation is null." );
        edges = new ArrayList<>( r_relations );
    }

    @Override
    public String toString()
    {
        StringBuilder sb = new StringBuilder();
        for( RelationEdge relation : edges )
            sb.append( relation + "\n" );
        return sb.toString();
    }

}
