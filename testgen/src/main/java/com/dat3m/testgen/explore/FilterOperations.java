package com.dat3m.testgen.explore;

import java.util.*;

import com.dat3m.dartagnan.program.filter.Filter;
import com.dat3m.dartagnan.program.filter.UnionFilter;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.definition.SetIdentity;
import com.dat3m.testgen.program.ProgramEdge;
import com.dat3m.testgen.program.ProgramGraph;

class FilterOperations {
    
    private WmmExplorer explorer;
    private List <ProgramGraph> graphs;
    private List <ProgramEdge> relations;
    private ProgramEdge relation_edge;
    private Filter filter;

    FilterOperations(
        final WmmExplorer r_explorer,
        final List <ProgramGraph> r_graphs,
        final List <ProgramEdge> r_relations,
        final ProgramEdge r_relation_edge,
        final Filter r_filter
    ) {
        explorer      = r_explorer;
        graphs        = r_graphs;
        relations     = r_relations;
        relation_edge = r_relation_edge;
        filter        = r_filter;
    }

    void expand() throws Exception {
        if( filter instanceof UnionFilter )
            expand_union();
        else {
            System.out.println( "[ERROR] " + relation_edge );
            System.out.println( "[ERROR] " + relation_edge.relation.getDefinition() );
            throw new Exception( "Reached filter that isn't a base filter but also cannot be expanded." );
        }
    }

    private void expand_union() throws Exception {
        UnionFilter filter = ( UnionFilter )this.filter;
        Filter flt_L = filter.getLeft();
        Filter flt_R = filter.getRight();
        Relation dep_L = explorer.memory_model.addDefinition( new SetIdentity( explorer.memory_model.newRelation(), flt_L ) );
        Relation dep_R = explorer.memory_model.addDefinition( new SetIdentity( explorer.memory_model.newRelation(), flt_R ) );
        ProgramEdge wmm_L = new ProgramEdge(
            relation_edge.eid_L, dep_L, relation_edge.eid_R, explorer.get_base_relation( dep_L )
        );
        ProgramEdge wmm_R = new ProgramEdge(
            relation_edge.eid_L, dep_R, relation_edge.eid_R, explorer.get_base_relation( dep_R )
        );
        relations.add( wmm_L );
        explorer.explore_relation( relations, graphs );
        relations.remove( wmm_L );
        relations.add( wmm_R );
        explorer.explore_relation( relations, graphs );
        relations.remove( wmm_R );
    }

}
