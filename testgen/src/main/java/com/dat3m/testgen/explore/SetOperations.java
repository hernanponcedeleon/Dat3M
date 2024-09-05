package com.dat3m.testgen.explore;

import java.util.*;

import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.definition.Composition;
import com.dat3m.dartagnan.wmm.definition.Intersection;
import com.dat3m.dartagnan.wmm.definition.Inverse;
import com.dat3m.dartagnan.wmm.definition.Union;
import com.dat3m.testgen.util.Graph;
import com.dat3m.testgen.util.RelationEdge;

class SetOperations {
    
    WmmExplorer explorer;
    List <Graph> graphs;
    List <RelationEdge> relations;
    RelationEdge relation_edge;

    SetOperations(
        final WmmExplorer r_explorer,
        final List <Graph> r_graphs,
        final List <RelationEdge> r_relations,
        final RelationEdge r_relation_edge
    ) {
        explorer      = r_explorer;
        graphs        = r_graphs;
        relations     = r_relations;
        relation_edge = r_relation_edge;
    }

    void expand() throws Exception {
        if(      relation_edge.relation.getDefinition() instanceof Inverse )
            expand_inverse();
        else if( relation_edge.relation.getDefinition() instanceof Composition )
            expand_composition();
        else if( relation_edge.relation.getDefinition() instanceof Union )
            expand_union();
        else if( relation_edge.relation.getDefinition() instanceof Intersection )
            expand_intersection();
        else {
            System.out.println( "[ERROR] " + relation_edge );
            System.out.println( "[ERROR] " + relation_edge.relation.getDefinition() );
            throw new Exception( "Reached relation that isn't a base relation but also cannot be expanded." );
        }
    }

    void expand_intersection() throws Exception {
        Relation dep_L = relation_edge.relation.getDependencies().get( 0 );
        Relation dep_R = relation_edge.relation.getDependencies().get( 1 );
        RelationEdge wmm_L = new RelationEdge(
            relation_edge.eid_L, dep_L, relation_edge.eid_R, explorer.get_base_relation( dep_L )
        );
        RelationEdge wmm_R = new RelationEdge(
            relation_edge.eid_L, dep_R, relation_edge.eid_R, explorer.get_base_relation( dep_R )
        );
        relations.add( wmm_L );
        relations.add( wmm_R );
        explorer.explore_relation( relations, graphs );
        relations.remove( wmm_R );
        relations.remove( wmm_L );
    }

    void expand_union() throws Exception {
        Relation dep_L = relation_edge.relation.getDependencies().get( 0 );
        Relation dep_R = relation_edge.relation.getDependencies().get( 1 );
        RelationEdge wmm_L = new RelationEdge(
            relation_edge.eid_L, dep_L, relation_edge.eid_R, explorer.get_base_relation( dep_L )
        );
        RelationEdge wmm_R = new RelationEdge(
            relation_edge.eid_L, dep_R, relation_edge.eid_R, explorer.get_base_relation( dep_R )
        );
        relations.add( wmm_L );
        explorer.explore_relation( relations, graphs );
        relations.remove( wmm_L );
        relations.add( wmm_R );
        explorer.explore_relation( relations, graphs );
        relations.remove( wmm_R );
    }

    void expand_composition() throws Exception {
        Relation dep_L = relation_edge.relation.getDependencies().get( 0 );
        Relation dep_R = relation_edge.relation.getDependencies().get( 1 );
        int intermediate_event_id = explorer.next_event_id++;
        RelationEdge wmm_L = new RelationEdge(
            relation_edge.eid_L, dep_L, intermediate_event_id, explorer.get_base_relation( dep_L )
        );
        RelationEdge wmm_R = new RelationEdge(
            intermediate_event_id, dep_R, relation_edge.eid_R, explorer.get_base_relation( dep_R )
        );
        relations.add( wmm_L );
        relations.add( wmm_R );
        explorer.explore_relation( relations, graphs );
        relations.remove( wmm_R );
        relations.remove( wmm_L );
        explorer.next_event_id--;
    }

    void expand_inverse() throws Exception {
        Relation dep = relation_edge.relation.getDependencies().get( 0 );
        RelationEdge edge = new RelationEdge(
            relation_edge.eid_R, dep, relation_edge.eid_L, explorer.get_base_relation( dep )
        );
        relations.add( edge );
        explorer.explore_relation( relations, graphs );
        relations.remove( edge );
    }

}
