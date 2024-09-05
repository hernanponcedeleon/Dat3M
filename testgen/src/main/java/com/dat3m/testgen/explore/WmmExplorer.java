package com.dat3m.testgen.explore;

import java.io.*;
import java.util.*;

import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.axiom.Acyclicity;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.testgen.util.BaseRelations;
import com.dat3m.testgen.util.Graph;
import com.dat3m.testgen.util.RelationEdge;

public class WmmExplorer {

    Wmm memory_model;
    Map <String, BaseRelations.type> base_relations;
    Set <String> ignored_relations;
    int next_event_id;
    
    public WmmExplorer(
        final File wmm_file
    ) throws Exception {
        memory_model      = new ParserCat().parse( wmm_file );
        base_relations    = new HashMap<>();
        ignored_relations = new HashSet<>();
    }

    public List <Graph> begin_exploration(
        final int cycle_length
    ) throws Exception {
        List <Graph> graphs = new ArrayList<>();

        for( Axiom axiom : memory_model.getAxioms() ) {
            if( !( axiom instanceof Acyclicity ) )
                continue;

            next_event_id = cycle_length + 1;
            List <RelationEdge> relations = new ArrayList<>();
            for( int d = 1 ; d <= cycle_length ; d++ ) {
                relations.add( new RelationEdge(
                    d, axiom.getRelation(), ( d % cycle_length ) + 1, get_base_relation( axiom.getRelation() )
                ) );
            }

            explore_relation( relations, graphs );
        }

        return graphs;
    }

    void explore_relation(
        final List <RelationEdge> relations,
        final List <Graph> graphs
    ) throws Exception {
        RelationEdge relation_edge = null;
        for( RelationEdge candidate_edge : relations ) {
            if( ignored_relations.contains( get_relation_string( candidate_edge.relation ) ) )
                return;
            if( candidate_edge.base != null )
                continue;
            relation_edge = candidate_edge;
            break;
        }

        if( relation_edge == null ) {
            graphs.add( new Graph( relations ) );
            return;
        }

        relations.remove( relation_edge );

        new SetOperations( this, graphs, relations, relation_edge ).expand();

        relations.add( relation_edge );
    }

    String get_relation_string(
        final Relation relation
    ) {
        return relation.getNames().isEmpty() ?
        relation.getDefinition().toString()  :
        relation.getNames().get(0);
    }

    BaseRelations.type get_base_relation(
        final Relation relation
    ) {
        if( !base_relations.containsKey( get_relation_string( relation ) ) )
            return null;
        return base_relations.get( get_relation_string( relation ) );
    }

    public void register_base_relation(
        final String relation_str,
        final BaseRelations.type relation_type
    ) throws Exception {
        base_relations.put( relation_str, relation_type );
    }

    public void register_ignored_relation(
        final String relation_str
    ) throws Exception {
        ignored_relations.add( relation_str );
    }

}
