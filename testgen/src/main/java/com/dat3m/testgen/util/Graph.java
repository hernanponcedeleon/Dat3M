package com.dat3m.testgen.util;

import java.util.*;

public class Graph {
    
    public List <RelationEdge> relations;
    
    public Graph(
        final List <RelationEdge> r_relations
    ) {
        relations = new ArrayList<>( r_relations );
    }

    @Override
    public String toString()
    {
        final StringBuilder sb = new StringBuilder();
        for( final RelationEdge relation : relations )
            sb.append( relation + "\n" );
        return sb.toString();
    }

}
