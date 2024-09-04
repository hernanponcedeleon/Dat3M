package com.dat3m.testgen.explore;

import java.io.*;
import java.util.*;

import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.testgen.util.BaseRelations;
import com.dat3m.testgen.util.Graph;
import com.dat3m.testgen.util.RelationEdge;

public class WmmExplorer {

    Wmm memory_model;
    Map <String, BaseRelations.type> type_map;
    Set <String> ignore_set;
    int next_event_id;
    
    public WmmExplorer(
        final File wmm_file
    ) throws Exception {
        memory_model = new ParserCat().parse( wmm_file );
        type_map     = new HashMap<>();
        ignore_set   = new HashSet<>();
    }

    public List <Graph> begin_exploration(
        final int degree_of_exploration
    ) throws Exception {
        List <Graph> all_cycles = new ArrayList<>();

        for( Axiom axiom : memory_model.getAxioms() ) {
            List <RelationEdge> relation_list = new ArrayList<>();
            for( int d = 1 ; d <= degree_of_exploration ; d++ ) {
                relation_list.add( new RelationEdge(
                    d, axiom.getRelation(), (d%degree_of_exploration)+1, get_base_relation( axiom.getRelation() )
                ) );
            }

            next_event_id = -1;
            for( RelationEdge relation : relation_list ) {
                next_event_id = Math.max( next_event_id, relation.eid_L );
                next_event_id = Math.max( next_event_id, relation.eid_R );
            }
            next_event_id++;

            explore_relation( relation_list, all_cycles );
        }

        return all_cycles;
    }

    void explore_relation(
        final List <RelationEdge> relation_list,
        final List <Graph> all_cycles
    ) throws Exception {
        RelationEdge relation_edge = null;
        for( RelationEdge rel : relation_list ) {
            if( rel.base != null || ignore_set.contains( get_relation_string( rel.relation ) ) )
                continue;
            relation_edge = rel;
            break;
        }

        if( relation_edge == null ) {
            Graph potential_cycle = generate_cycle( relation_list );
            if( potential_cycle != null )
                all_cycles.add( potential_cycle );
            return;
        }

        relation_list.remove( relation_edge );

        if( !SetOperator.expand( this, all_cycles, relation_list, relation_edge ) ) {
            System.out.println( "[ERROR] " + relation_edge );
            System.out.println( "[ERROR] " + relation_edge.relation.getDefinition() );
            throw new Exception( "Reached relation that isn't a base relation but also cannot be expanded." );
        }

        relation_list.add( relation_edge );
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
        return type_map.get( get_relation_string( relation ) );
    }

    Graph generate_cycle(
        final List <RelationEdge> relation_list
    ) {
        for( final RelationEdge relation : relation_list )
            if( relation.base == null )
                return null;
        return new Graph( relation_list );
    }

    public void register_base_relation(
        final String relation_str,
        final BaseRelations.type relation_type
    ) throws Exception {
        type_map.put( relation_str, relation_type );
    }

    public void register_ignored_relation(
        final String relation_str
    ) throws Exception {
        ignore_set.add( relation_str );
    }

}
