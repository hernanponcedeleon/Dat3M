package com.dat3m.testgen.explore;

import java.util.*;

import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.definition.Composition;
import com.dat3m.dartagnan.wmm.definition.Intersection;
import com.dat3m.dartagnan.wmm.definition.Inverse;
import com.dat3m.dartagnan.wmm.definition.Union;
import com.dat3m.testgen.util.Graph;
import com.dat3m.testgen.util.RelationEdge;

public class SetOperator {

    public static boolean expand(
        final WmmExplorer wmm_explorer,
        final List <Graph> all_cycles,
        final List <RelationEdge> relation_list,
        final RelationEdge relation_edge
    ) throws Exception {
        if( relation_edge.relation.getDefinition() instanceof Inverse )
            return expand_inverse( wmm_explorer, all_cycles, relation_list, relation_edge );
        if( relation_edge.relation.getDefinition() instanceof Composition )
            return expand_composition( wmm_explorer, all_cycles, relation_list, relation_edge );
        if( relation_edge.relation.getDefinition() instanceof Union )
            return expand_union( wmm_explorer, all_cycles, relation_list, relation_edge );
        if( relation_edge.relation.getDefinition() instanceof Intersection )
            return expand_intersection( wmm_explorer, all_cycles, relation_list, relation_edge );
        return false;
    }

    static boolean expand_intersection(
        final WmmExplorer wmm_explorer,
        final List <Graph> all_cycles,
        final List <RelationEdge> relation_list,
        final RelationEdge relation_edge
    ) throws Exception {
        if( relation_edge.relation.getDependencies().size() != 2 )
            return false;
        Relation dep_L = relation_edge.relation.getDependencies().get( 0 );
        Relation dep_R = relation_edge.relation.getDependencies().get( 1 );
        RelationEdge wmm_L = new RelationEdge(
            relation_edge.eid_L, dep_L, relation_edge.eid_R, wmm_explorer.get_base_relation( dep_L )
        );
        RelationEdge wmm_R = new RelationEdge(
            relation_edge.eid_L, dep_R, relation_edge.eid_R, wmm_explorer.get_base_relation( dep_R )
        );
        relation_list.add( wmm_L );
        relation_list.add( wmm_R );
        wmm_explorer.explore_relation( relation_list, all_cycles );
        relation_list.remove( wmm_R );
        relation_list.remove( wmm_L );
        return true;
    }

    static boolean expand_union(
        final WmmExplorer wmm_explorer,
        final List <Graph> all_cycles,
        final List <RelationEdge> relation_list,
        final RelationEdge relation_edge
    ) throws Exception {
        if( relation_edge.relation.getDependencies().size() != 2 )
            return false;
        Relation dep_L = relation_edge.relation.getDependencies().get( 0 );
        Relation dep_R = relation_edge.relation.getDependencies().get( 1 );
        RelationEdge wmm_L = new RelationEdge(
            relation_edge.eid_L, dep_L, relation_edge.eid_R, wmm_explorer.get_base_relation( dep_L )
        );
        RelationEdge wmm_R = new RelationEdge(
            relation_edge.eid_L, dep_R, relation_edge.eid_R, wmm_explorer.get_base_relation( dep_R )
        );
        relation_list.add( wmm_L );
        wmm_explorer.explore_relation( relation_list, all_cycles );
        relation_list.remove( wmm_L );
        relation_list.add( wmm_R );
        wmm_explorer.explore_relation( relation_list, all_cycles );
        relation_list.remove( wmm_R );
        return true;
    }

    static boolean expand_composition(
        final WmmExplorer wmm_explorer,
        final List <Graph> all_cycles,
        final List <RelationEdge> relation_list,
        final RelationEdge relation_edge
    ) throws Exception {
        if( relation_edge.relation.getDependencies().size() != 2 )
            return false;
        Relation dep_L = relation_edge.relation.getDependencies().get( 0 );
        Relation dep_R = relation_edge.relation.getDependencies().get( 1 );
        int intermediate_event_id = wmm_explorer.next_event_id++;
        RelationEdge wmm_L = new RelationEdge(
            relation_edge.eid_L, dep_L, intermediate_event_id, wmm_explorer.get_base_relation( dep_L )
        );
        RelationEdge wmm_R = new RelationEdge(
            intermediate_event_id, dep_R, relation_edge.eid_R, wmm_explorer.get_base_relation( dep_R )
        );
        relation_list.add( wmm_L );
        relation_list.add( wmm_R );
        wmm_explorer.explore_relation( relation_list, all_cycles );
        relation_list.remove( wmm_R );
        relation_list.remove( wmm_L );
        wmm_explorer.next_event_id--;
        return true;
    }

    static boolean expand_inverse(
        final WmmExplorer wmm_explorer,
        final List <Graph> all_cycles,
        final List <RelationEdge> relation_list,
        final RelationEdge relation_edge
    ) throws Exception {
        if( relation_edge.relation.getDependencies().size() != 1 )
            return false;
        Relation dep = relation_edge.relation.getDependencies().get( 0 );
        RelationEdge edge = new RelationEdge(
            relation_edge.eid_R, dep, relation_edge.eid_L, wmm_explorer.get_base_relation( dep )
        );
        relation_list.add( edge );
        wmm_explorer.explore_relation( relation_list, all_cycles );
        relation_list.remove( edge );
        return true;
    }

}
