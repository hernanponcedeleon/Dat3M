package com.dat3m.dartagnan.wmm;

import com.dat3m.dartagnan.utils.dependable.DependencyGraph;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.filter.FilterAbstract;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.relation.RecursiveRelation;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.RecursiveGroup;
import com.dat3m.dartagnan.wmm.utils.RelationRepository;
import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableSet;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

import java.util.*;

import static com.dat3m.dartagnan.configuration.OptionNames.LOCALLY_CONSISTENT;
import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.*;

/**
 *
 * @author Florian Furbach
 */
@Options
public class Wmm {

    public final static ImmutableSet<String> BASE_RELATIONS = ImmutableSet.of(CO, RF, IDD, ADDRDIRECT);

    // =========================== Configurables ===========================

    //TODO: We need to move these options somewhere else (e.g. a WmmEncoder or a WmmMetaData Object)
    // because a Wmm is a non-configurable data object.
    @Option(
    	name= LOCALLY_CONSISTENT,
    	description="Assumes local consistency for all created wmms.",
    	secure=true)
    private boolean assumeLocalConsistency = true;

    @Option(
    	description="Assumes the WMM respects atomic blocks for optimization (only the case for SVCOMP right now).",
    	secure=true)
    private boolean respectsAtomicBlocks = true;

    // =====================================================================

    private final List<Axiom> axioms = new ArrayList<>();
    private final Map<String, FilterAbstract> filters = new HashMap<>();
    private final RelationRepository relationRepository;
    private final List<RecursiveGroup> recursiveGroups = new ArrayList<>();

    public Wmm() {
        relationRepository = new RelationRepository();
    }

    public void addAxiom(Axiom ax) {
        axioms.add(ax);
    }

    public List<Axiom> getAxioms() {
        return axioms;
    }

    public List<RecursiveGroup> getRecursiveGroups() { return recursiveGroups; }

    public void addFilter(FilterAbstract filter) {
        filters.put(filter.getName(), filter);
    }

    public FilterAbstract getFilter(String name){
        return filters.computeIfAbsent(name, FilterBasic::get);
    }

    public RelationRepository getRelationRepository(){
        return relationRepository;
    }

    public boolean isLocallyConsistent() {
        // For now we return a preset value. Ideally, we would like to
        // find this property automatically.
        return assumeLocalConsistency;
    }

    public boolean doesRespectAtomicBlocks() {
        // For now we return a preset value. Ideally, we would like to
        // find this property automatically. This is currently only relevant for SVCOMP
        return respectsAtomicBlocks;
    }

    public void addRecursiveGroup(Set<RecursiveRelation> recursiveGroup){
        int id = 1 << recursiveGroups.size();
        Preconditions.checkArgument(id >= 0, "Exceeded maximum number of recursive relations.");
        recursiveGroups.add(new RecursiveGroup(id, recursiveGroup));
    }


    public String toString() {
        StringBuilder sb = new StringBuilder();

        for (Axiom axiom : axioms) {
            sb.append(axiom).append("\n");
        }

        for (Relation relation : relationRepository.getRelations()) {
            if(relation.getIsNamed()){
                sb.append(relation).append("\n");
            }
        }

        for (Map.Entry<String, FilterAbstract> filter : filters.entrySet()){
            sb.append(filter.getValue()).append("\n");
        }

        return sb.toString();
    }


    // ====================== Utility Methods ====================
    
    private DependencyGraph<Relation> relationDependencyGraph;
    
    public DependencyGraph<Relation> getRelationDependencyGraph() {
        if (relationDependencyGraph == null) {
            relationDependencyGraph = DependencyGraph.from(relationRepository.getRelations());
        }
        return relationDependencyGraph;
    }
}
