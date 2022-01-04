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
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.alias.AliasAnalysis;
import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableSet;
import com.google.common.collect.Sets;
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
    private boolean relationsAreEncoded = false;

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
        Preconditions.checkArgument(id >= 0, "Exceeded maximum number of recursive relations.");
        recursiveGroups.add(new RecursiveGroup(id, recursiveGroup));
    }

	/**
	 * Associates this parsed model with a program and additional information.
	 * <p>
	 * Once associated with a task, {@link #encodeRelations(SolverContext)} is enabled.
	 * @param task
	 * Pair of program and memory model to be tested for a certain property.
	 * {@link VerificationTask#getMemoryModel()} could refer to a different model.
	 */
    public void initialise(VerificationTask task, SolverContext ctx) {
        this.task = task;
        new AliasAnalysis().calculateLocationSets(task.getProgram());

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
    }

	/**
	 * Computes the may-sets, must-sets and possibly also must-not and active sets.
	 * @param computeMustNotSets Whether must-not sets get computed.
	 * @param computedActiveSets Whether active sets get computed.
	 */
	public void performRelationAnalysis(boolean computeMustNotSets, boolean computedActiveSets) {
    	Preconditions.checkState(task != null, "The WMM needs to get initialised first.");

		// ===== Compute may sets =====
		for(RecursiveGroup recursiveGroup : recursiveGroups) {
			recursiveGroup.initMaxTupleSets();
		}
		for(Axiom ax : axioms) {
			ax.getRelation().getMaxTupleSet();
		}
		// Needed in case some baseRelation is not used in the Wmm definition
		for(String relName : baseRelations) {
			relationRepository.getRelation(relName).getMaxTupleSet();
		}

		// ===== Compute must (and must-not) sets =====
		boolean changed = true;
		while (changed) {
			changed = false;
			// ----- Must-set -----
			for (RecursiveGroup g : recursiveGroups) {
				g.initMinTupleSets();
			}
			for(Axiom ax : axioms) {
				ax.getRelation().fetchMinTupleSet();
			}

			// ----- Must-not set -----
			if (computeMustNotSets) {
				for (Axiom a : axioms) {
					changed |= a.applyDisableSet();
				}
				for(Relation r : relationRepository.getRelations()) {
					changed |= r.continueDisableTupleSet();
				}
				for (RecursiveGroup g : reverse(recursiveGroups)) {
					changed |= g.initDisableTupleSets();
				}
			}
		}

		// ===== Active sets =====
		if (computedActiveSets) {
			for (Relation r : relationRepository.getRelations()) {
				r.initEncodeTupleSet();
			}
			for (Axiom ax : axioms) {
				ax.getRelation().addEncodeTupleSet(ax.getEncodeTupleSet());
			}
			for (RecursiveGroup recursiveGroup : reverse(recursiveGroups)) {
				recursiveGroup.updateEncodeTupleSets();
			}
		}



	}

	/**
	 * Translates the relations of this model into an SMT formula.
	 * This always includes Read-From, Memory-Order, and Dependencies.
	 * Computes the may set.
	 * Computes the must and must-not set.
	 * Computes the active set.
	 * @param ctx
	 * Builder of expressions.
	 * @return
	 * Models executions roughly of the associated program.
	 * Misses control-flow information and parts of intra-thread data-flow information.
	 * @throws IllegalStateException
	 * This model has to be invoked with {@link #initialise(VerificationTask, SolverContext)} first.
	 */
	public BooleanFormula encodeRelations(SolverContext ctx) {

		performRelationAnalysis(GlobalSettings.COMPUTE_MUSTNOT_SETS, true);

		BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
		BooleanFormula enc = bmgr.makeTrue();
		for(Relation r : relationRepository.getRelations()) {
			enc = bmgr.and(enc,r.encode(ctx));
		}
		relationsAreEncoded = true;
		return enc;
	}

	/**
	 * Translates this model into an SMT formula.
	 * @param ctx
	 * Builder of expressions.
	 * @return
	 * Models consistent executions roughly of the associated program.
	 * Misses relation encoding.
	 * @throws IllegalStateException
	 * This model's relations were not encoded with {@link #encodeRelations(SolverContext)} before.
	 */
	public final BooleanFormula encodeConsistency(SolverContext ctx) {
        //TODO: Actually, there are use-cases where it makes sense to encode axioms without the relations
    	Preconditions.checkState(relationsAreEncoded, "Wmm relations must be encoded before the consistency predicate.");
        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
		BooleanFormula enc = bmgr.makeTrue();
        for (Axiom ax : axioms) {
            enc = bmgr.and(enc, ax.consistent(ctx));
        }
		for(Relation r : relationRepository.getRelations()) {
			//NOTE relationRepository does not contain any RecursiveRelation#r1
			Set<Tuple> d = r.getDisableTupleSet();
			for(Tuple t : baseRelations.contains(r.getName()) ? d : Sets.intersection(d,r.getEncodeTupleSet())) {
				enc = bmgr.and(enc, bmgr.not(r.getSMTVar(t,ctx)));
			}
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
			//Does this work properly? RecursiveRelation#r1 is not contained in getRelations()
            relationDependencyGraph = DependencyGraph.from(relationRepository.getRelations());
        }
        return relationDependencyGraph;
    }
}
