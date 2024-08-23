package com.dat3m.testgen.explore;

import java.io.*;
import java.util.*;

import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.definition.Composition;
import com.dat3m.dartagnan.wmm.definition.Intersection;
import com.dat3m.dartagnan.wmm.definition.Union;
import com.dat3m.testgen.util.Graph;
import com.dat3m.testgen.util.RelationType;

public class WmmExplorer {

    Wmm memory_model;
    Map <String, RelationType> type_map;
    int next_event_id = -1;
    
    public WmmExplorer(
        final File wmm_file
    ) throws Exception {
        memory_model = new ParserCat().parse( wmm_file );
        type_map     = new HashMap<>();
    }

    public List <Graph> begin_exploration(
        final int degree_of_exploration
    ) throws Exception {
        register_base_relations();

        List <Graph> all_cycles = new ArrayList<>();

        for( final Axiom axiom : memory_model.getAxioms() ) {
            final List <WmmRelation> relation_list = new ArrayList<>();
            for( int d = 1 ; d <= degree_of_exploration ; d++ ) {
                relation_list.add( new WmmRelation(
                    d, axiom.getRelation(), (d%degree_of_exploration)+1,
                    is_base_relation( axiom.getRelation() ), get_base_relation( axiom.getRelation() )
                ) );
            }

            next_event_id = -1;
            for( final WmmRelation relation : relation_list ) {
                next_event_id = Math.max( next_event_id, relation.event_id_left );
                next_event_id = Math.max( next_event_id, relation.event_id_right );
            }
            next_event_id++;

            explore_relation( relation_list, all_cycles );
        }

        return all_cycles;
    }

    void register_base_relations()
    throws Exception {
        register_base_relation( "po", "po" );
        register_base_relation( "co", "co" );
        register_base_relation( "rf", "rf" );
        register_base_relation( "rf^-1", "rf_inv" );
        register_base_relation( "ext", "ext" );
        register_base_relation( "rmw", "rmw" );
        register_base_relation( "((([R]) \\ ([range(rf)])) ; loc) ; ([W])", null );
    }

    void explore_relation(
        final List <WmmRelation> relation_list,
        final List <Graph> all_cycles
    ) throws Exception {
        WmmRelation relation = null;
        for( final WmmRelation rel : relation_list ) {
            if( rel.is_base_relation )
                continue;
            relation = rel;
            break;
        }

        if( relation == null ) {
            Graph potential_cycle = generate_cycle( relation_list );
            if( potential_cycle != null )
                all_cycles.add( potential_cycle );
            return;
        }

        relation_list.remove( relation ); 

        boolean composition  = relation.dat3m_relation.getDefinition() instanceof Composition;
        boolean union        = relation.dat3m_relation.getDefinition() instanceof Union;
        boolean intersection = relation.dat3m_relation.getDefinition() instanceof Intersection;

        if( !composition && !union && !intersection ) {
            System.out.println( "[ERROR] " + relation );
            System.out.println( "[ERROR] " + relation.dat3m_relation.getDefinition() );
            throw new Exception( "Reached relation that isn't a base relation but also cannot be expanded." );
        }

        if( relation.dat3m_relation.getDependencies().size() != 2 )
            throw new Exception( "Dependency size should be exactly two." );
            
        final Relation dep_L = relation.dat3m_relation.getDependencies().get(0);
        final Relation dep_R = relation.dat3m_relation.getDependencies().get(1);

        if( composition ) {
            final int intermediate_event_id = next_event_id++;
            final WmmRelation wmm_L = new WmmRelation(
                relation.event_id_left, dep_L, intermediate_event_id,
                is_base_relation( dep_L ), get_base_relation( dep_L )
            );
            final WmmRelation wmm_R = new WmmRelation(
                intermediate_event_id, dep_R, relation.event_id_right,
                is_base_relation( dep_R ), get_base_relation( dep_R )
            );
            relation_list.add( wmm_L );
            relation_list.add( wmm_R );
            explore_relation( relation_list, all_cycles );
            relation_list.remove( wmm_R );
            relation_list.remove( wmm_L );
            next_event_id--;
        } else if( union ) {
            final WmmRelation wmm_L = new WmmRelation(
                relation.event_id_left, dep_L, relation.event_id_right,
                is_base_relation( dep_L ), get_base_relation( dep_L )
            );
            final WmmRelation wmm_R = new WmmRelation(
                relation.event_id_left, dep_R, relation.event_id_right,
                is_base_relation( dep_R ), get_base_relation( dep_R )
            );
            relation_list.add( wmm_L );
            explore_relation( relation_list, all_cycles );
            relation_list.remove( wmm_L );
            relation_list.add( wmm_R );
            explore_relation( relation_list, all_cycles );
            relation_list.remove( wmm_R );
        } else if( intersection ) {
            final WmmRelation wmm_L = new WmmRelation(
                relation.event_id_left, dep_L, relation.event_id_right,
                is_base_relation( dep_L ), get_base_relation( dep_L )
            );
            final WmmRelation wmm_R = new WmmRelation(
                relation.event_id_left, dep_R, relation.event_id_right,
                is_base_relation( dep_R ), get_base_relation( dep_R )
            );
            relation_list.add( wmm_L );
            relation_list.add( wmm_R );
            explore_relation( relation_list, all_cycles );
            relation_list.remove( wmm_R );
            relation_list.remove( wmm_L );
        }

        relation_list.add( relation );
    }

    boolean is_base_relation(
        final Relation relation
    ) {
        final String str = (
            relation.getNames().isEmpty()       ?
            relation.getDefinition().toString() :
            relation.getNames().get(0)
        );
        return type_map.containsKey( str );
    }

    RelationType get_base_relation(
        final Relation relation
    ) {
        if( !is_base_relation( relation ) )
            return null;
        final String str = (
            relation.getNames().isEmpty()       ?
            relation.getDefinition().toString() :
            relation.getNames().get(0)
        );
        return type_map.get( str );
    }

    Graph generate_cycle(
        final List <WmmRelation> relation_list
    ) {
        for( final WmmRelation relation : relation_list )
            if( relation.base_relation == null )
                return null;
        /* TODO: Check for duplicate cycles... */
        return new Graph( relation_list );
    }

    void register_base_relation(
        final String relation_str,
        final String type_str
    ) throws Exception {
        type_map.put(
            relation_str,
            type_str == null ? null : new RelationType( type_str )
        );
    }

}
