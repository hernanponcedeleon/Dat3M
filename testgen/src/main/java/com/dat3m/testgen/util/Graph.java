package com.dat3m.testgen.util;

import java.util.*;

import com.dat3m.testgen.explore.WmmRelation;

public class Graph {
    
    List <WmmRelation> relations;
    
    public Graph(
        final List <WmmRelation> r_relations
    ) {
        relations = new ArrayList<>( r_relations );
    }

    @Override
    public String toString()
    {
        final StringBuilder sb = new StringBuilder();
        for( final WmmRelation relation : relations )
            sb.append( relation + "\n" );
        return sb.toString();
    }

}
