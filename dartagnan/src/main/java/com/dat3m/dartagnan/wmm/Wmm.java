package com.dat3m.dartagnan.wmm;

import com.dat3m.dartagnan.GlobalSettings;
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.utils.*;
import com.dat3m.dartagnan.wmm.utils.alias.AliasAnalysis;
import com.google.common.collect.ImmutableSet;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.filter.FilterAbstract;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.relation.RecursiveRelation;
import com.dat3m.dartagnan.wmm.relation.Relation;

import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.ADDRDIRECT;
import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.CO;
import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.IDD;
import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.RF;

import java.util.*;

import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;

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
        FilterAbstract filter = filters.get(name);
        if(filter == null){
            filter = FilterBasic.get(name);
        }
        return filter;
    }

    public RelationRepository getRelationRepository(){
        return relationRepository;
    }

    public boolean isLocallyConsistent() {
        return GlobalSettings.ASSUME_LOCAL_CONSISTENCY;
    }

    public void addRecursiveGroup(Set<RecursiveRelation> recursiveGroup){
        int id = 1 << recursiveGroups.size();
        if(id < 0){
            throw new RuntimeException("Exceeded maximum number of recursive relations");
        }
        recursiveGroups.add(new RecursiveGroup(id, recursiveGroup));
    }

    public void initialise(VerificationTask task, SolverContext ctx) {
        this.task = task;
        new AliasAnalysis().calculateLocationSets(task.getProgram(), task.getSettings().getAlias());

        for(String relName : baseRelations){
            relationRepository.getRelation(relName);
        }

        for(FilterAbstract filter : filters.values()){
            filter.initialise();
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

    // Encodes only the base relations of the memory model without co!
    // This should be (almost) equivalent to encoding the empty memory model
    // A call to <consistent> should not be performed afterwards.
    public BooleanFormula encodeCore(SolverContext ctx) {
        if (this.task == null) {
            throw new IllegalStateException("The WMM needs to get initialised first.");
        }

        // Encode all base relations except co (essentially encodes rf and po)
        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
		BooleanFormula enc = bmgr.makeTrue();
        for(String relName : baseRelations){
            if (relName.equals(CO)) {
                continue;
            }
            relationRepository.getRelation(relName).getMaxTupleSet();
            enc = bmgr.and(enc, relationRepository.getRelation(relName).encode(ctx));
        }

        return enc;
    }

    // This methods initializes all relations and encodes all base relations
    // and recursive groups (why recursive groups?)
    // It also triggers the computation of may and active sets!
    // It does NOT encode the axioms nor any non-base relation yet!
    public BooleanFormula encodeBase(SolverContext ctx) {
        if (this.task == null) {
            throw new IllegalStateException("The WMM needs to get initialised first.");
        }

        for (RecursiveGroup recursiveGroup : recursiveGroups) {
            recursiveGroup.initMaxTupleSets();
            recursiveGroup.initMinTupleSets();
        }

        for (Axiom ax : axioms) {
            ax.getRelation().getMaxTupleSet();
        }

        for(String relName : baseRelations){
            relationRepository.getRelation(relName).getMaxTupleSet();
        }

        for (Axiom ax : axioms) {
            ax.getRelation().addEncodeTupleSet(ax.getEncodeTupleSet());
        }

        Collections.reverse(recursiveGroups);
        for(RecursiveGroup recursiveGroup : recursiveGroups){
            recursiveGroup.updateEncodeTupleSets();
        }

        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
		BooleanFormula enc = bmgr.makeTrue();
        for(String relName : baseRelations){
            enc = bmgr.and(enc, relationRepository.getRelation(relName).encode(ctx));
        }

        return enc;
    }

    // Initalizes everything just like encodeBase but also encodes all
    // relations that are needed for the axioms (but does NOT encode the axioms themselves yet)
    public BooleanFormula encode(SolverContext ctx) {
        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
    	BooleanFormula enc = encodeBase(ctx);
        for (Axiom ax : axioms) {
			enc = bmgr.and(enc, ax.getRelation().encode(ctx));
        }
        relationsAreEncoded = true;
        return enc;
    }

    // Encodes all axioms. This should be called after <encode>
    public BooleanFormula consistent(SolverContext ctx) {
        if(!relationsAreEncoded){
            throw new IllegalStateException("Wmm relations must be encoded before consistency predicate");
        }
        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
		BooleanFormula expr = bmgr.makeTrue();
        for (Axiom ax : axioms) {
            expr = bmgr.and(expr, ax.consistent(ctx));
        }
        return expr;
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
