package com.dat3m.testgen.util;

import java.util.*;

public class Graph {
    
    public final List <RelationEdge> edges;
    
    public Graph(
        final List <RelationEdge> r_relations
    ) {
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
