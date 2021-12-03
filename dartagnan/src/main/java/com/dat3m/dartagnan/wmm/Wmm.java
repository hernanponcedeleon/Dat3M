package com.dat3m.dartagnan.wmm;

import com.dat3m.dartagnan.GlobalSettings;
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.filter.FilterAbstract;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.relation.RecursiveRelation;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.RecursiveGroup;
import com.dat3m.dartagnan.wmm.utils.RelationRepository;
import com.dat3m.dartagnan.wmm.utils.alias.AliasAnalysis;
import com.google.common.collect.ImmutableSet;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;

import java.util.*;

import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.*;
import static com.google.common.collect.Lists.reverse;

/**
 *
 * @author Florian Furbach
 */
public class Wmm {

    private final static ImmutableSet<String> baseRelations = ImmutableSet.of(CO, RF, IDD, ADDRDIRECT);

    private final List<Axiom> axioms = new ArrayList<>();
    private final Map<String, FilterAbstract> filters = new HashMap<>();
    private final RelationRepository relationRepository;
    private final List<RecursiveGroup> recursiveGroups = new ArrayList<>();

    private VerificationTask task;

    private boolean encodeCo = true;

    public void setEncodeCo(boolean encodeCO) {
        this.encodeCo = encodeCO;
    }

    public Wmm() {
        relationRepository = new RelationRepository();
    }

    public void addAxiom(Axiom ax) {
        axioms.add(ax);
    }

    public List<Axiom> getAxioms() {
        return axioms;
    }

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
        // For now we just return a global flag, but we would like to automatically
        // detect local consistency
        return GlobalSettings.ASSUME_LOCAL_CONSISTENCY;
    }

    public void addRecursiveGroup(Set<RecursiveRelation> recursiveGroup){
        int id = 1 << recursiveGroups.size();
        if(id < 0){
            throw new RuntimeException("Exceeded maximum number of recursive relations");
        }
        recursiveGroups.add(new RecursiveGroup(id, recursiveGroup));
    }

	/**
	Associates this parsed model with a program and additional information.
	Computes the may set.
	Computes the must and must-not set.
	Computes the active set.
	<p>
	Once associated with a task, {@link #encode(SolverContext)} is enabled.
	@param task
	Pair of program and memory model to be tested for a certain property.
	{@link VerificationTask#getMemoryModel()} could refer to a different model.
	*/
    public void initialise(VerificationTask task, SolverContext ctx) {
        this.task = task;
        new AliasAnalysis().calculateLocationSets(task.getProgram(), task.getSettings().getAlias());

        for(String relName : baseRelations){
            relationRepository.getRelation(relName);
        }

        for (Axiom ax : axioms) {
            ax.getRelation().updateRecursiveGroupId(ax.getRelation().getRecursiveGroupId());
        }

        for(RecursiveGroup recursiveGroup : recursiveGroups){
            recursiveGroup.setDoRecurse();
        }

        for(Relation relation : relationRepository.getRelations()){
            relation.initialise(task, ctx);
        }

        for (Axiom axiom : axioms) {
            axiom.initialise(task, ctx);
        }

		//fixed point of may set
		for(RecursiveGroup recursiveGroup : recursiveGroups) {
			recursiveGroup.initMaxTupleSets();
		}
		for(Axiom ax : axioms) {
			ax.getRelation().getMaxTupleSet();
		}

		//fixed point of must and must-not set
		for(boolean changed = true; changed;) {
			changed = false;
			for(RecursiveGroup g : recursiveGroups)
				g.initMinTupleSets();
			for(Axiom a : axioms)
				changed = a.getRelation().disable(a.getDisabledSet()) || changed;
			for(RecursiveGroup g : reverse(recursiveGroups))
				changed = g.initDisableTupleSets() || changed;
		}

		//make sure to encode the dataflow-relevant information, as well as the communications
		for(String relName : baseRelations) {
			relationRepository.getRelation(relName).getMaxTupleSet();
		}

		//fixed point of active set
		for(Axiom ax : axioms) {
			ax.getRelation().addEncodeTupleSet(ax.getEncodeTupleSet());
		}
		for(RecursiveGroup recursiveGroup : reverse(recursiveGroups)) {
			recursiveGroup.updateEncodeTupleSets();
		}
    }

	/**
	Translates this model into an SMT formula.
	@param ctx
	Builder of expressions.
	@return
	Models consistent executions roughly of the associated program.
	Misses control-flow information and parts of intra-thread data-flow information.
	@throws IllegalStateException
	This model is parsed but uninitialized.
	*/
	public final BooleanFormula encode(SolverContext ctx) {
		if(task == null) {
			throw new IllegalStateException("The WMM needs to get initialised first.");
		}
        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
		BooleanFormula enc = bmgr.makeTrue();
		LinkedHashSet<Relation> relations = new LinkedHashSet<>();
		for(String relName : baseRelations) {
			if (!encodeCo && relName.equals(CO)) {
				continue;
			}
			relations.add(relationRepository.getRelation(relName));
		}
        for (Axiom ax : axioms) {
			ax.getRelation().collect(relations);
        }
		for(Relation r : relations) {
			enc = bmgr.and(enc,r.encode(ctx));
		}
        for (Axiom ax : axioms) {
            enc = bmgr.and(enc, ax.consistent(ctx));
        }
        return enc;
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
