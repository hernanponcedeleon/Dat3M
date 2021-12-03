package com.dat3m.dartagnan.wmm.relation;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.utils.dependable.Dependent;
import com.dat3m.dartagnan.utils.equivalence.BranchEquivalence;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.relation.base.stat.StaticRelation;
import com.dat3m.dartagnan.wmm.relation.binary.BinaryRelation;
import com.dat3m.dartagnan.wmm.relation.unary.UnaryRelation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import com.google.common.collect.Sets;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.SolverContext;

import java.util.Collections;
import java.util.List;
import java.util.Set;

import static com.dat3m.dartagnan.wmm.utils.Utils.edge;

/**
 *
 * @author Florian Furbach
 */
public abstract class Relation implements Dependent<Relation> {

    public static boolean PostFixApprox = false;

    protected String name;
    protected String term;

    protected VerificationTask task;

    protected TupleSet minTupleSet;
    protected TupleSet maxTupleSet;
    protected TupleSet encodeTupleSet;
	protected TupleSet disableTupleSet;

    protected int recursiveGroupId = 0;
    protected boolean forceUpdateRecursiveGroupId = false;
    protected boolean isRecursive = false;

    public Relation() {}

    public Relation(String name) {
        this.name = name;
    }

    @Override
    public List<Relation> getDependencies() {
        return Collections.emptyList();
    }

    public int getRecursiveGroupId(){
        return recursiveGroupId;
    }

    public void setRecursiveGroupId(int id){
        forceUpdateRecursiveGroupId = true;
        recursiveGroupId = id;
    }

    public int updateRecursiveGroupId(int parentId){
        return recursiveGroupId;
    }

	/**
	 * Adds this relation and all its descendants to a set.
	 * This is a recursive and overridden method.
	 * @param result
	 * Receives the relations.
	 */
	public void collect(Set<?super Relation> result) {
		result.add(this);
	}

    public void initialise(VerificationTask task, SolverContext ctx){
        this.task = task;
        this.minTupleSet = null;
        this.maxTupleSet = null;
        encodeTupleSet = new TupleSet();
		disableTupleSet = new TupleSet();
    }

    /*
    TODO: getMinTupleSet is no yet used extensively
     */
    public abstract TupleSet getMinTupleSet();

    public abstract TupleSet getMaxTupleSet();

	/**
	 * @return
	 * Read-only subset of the may-set marked as must-not.
	 */
	public final TupleSet getDisableTupleSet() {
		return disableTupleSet;
	}

	/**
	 * Updates the must- and must-not-sets of this relation.
	 * @return
	 * Updated version of {@code getMinTupleSet()}.
	 */
    public TupleSet getMinTupleSetRecursive(){
        return getMinTupleSet();
    }

    public TupleSet getMaxTupleSetRecursive(){
        return getMaxTupleSet();
    }

	/**
	 * Marks relationships as impossible due to some axiom of the associated model.
	 * @param tuples
	 * Subset of this relation's may set.
	 * Retains all newly-marked relationships.
	 * @return
	 * Detected some new minimal tuples.
	 */
	public boolean disable(TupleSet tuples) {
		tuples.removeIf(t -> !disableTupleSet.add(t));
		return false;
	}

    public TupleSet getEncodeTupleSet(){
        return encodeTupleSet;
    }

    public void addEncodeTupleSet(TupleSet tuples){
        encodeTupleSet.addAll(Sets.intersection(tuples, maxTupleSet));
    }

    public String getName() {
        return name != null ? name : term;
    }

    public Relation setName(String name){
        this.name = name;
        return this;
    }

    public String getTerm(){
        return term;
    }

    public boolean getIsNamed(){
        return name != null;
    }

    @Override
    public String toString(){
        if(name != null){
            return name + " := " + term;
        }
        return term;
    }

    @Override
    public int hashCode(){
        return getName().hashCode();
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        } else if (obj == null || getClass() != obj.getClass()) {
            return false;
        }

        return getName().equals(((Relation)obj).getName());
    }

	/**
	 * Transforms this relation into an SMT formula by constraining pairs in this relation.
	 * Only includes relationships marked as active with {@link #addEncodeTupleSet(TupleSet)}.
	 * This method is not recursive.
	 * @param ctx
	 * Builder of formulas.
	 * @return
	 * Models executions where all event pairs in this relation satisfy the direct constraints of this relation.
	 */
	public BooleanFormula encode(SolverContext ctx) {
		return encodeApprox(ctx);
	}

    protected abstract BooleanFormula encodeApprox(SolverContext ctx);

    public BooleanFormula getSMTVar(Tuple edge, SolverContext ctx) {
        return !getMaxTupleSet().contains(edge) || disableTupleSet.contains(edge) ?
        		ctx.getFormulaManager().getBooleanFormulaManager().makeFalse() :
                edge(getName(), edge.getFirst(), edge.getSecond(), ctx);
    }

    public final BooleanFormula getSMTVar(Event e1, Event e2, SolverContext ctx) {
        return getSMTVar(new Tuple(e1, e2), ctx);
    }

    protected BooleanFormula getExecPair(Event e1, Event e2, SolverContext ctx) {
        if (e1.exec() == e2.exec()) {
            return e1.exec();
        }
        if (e1.getCId() > e2.getCId()) {
            Event temp = e1;
            e1 = e2;
            e2 = temp;
        }
        BranchEquivalence eq = task.getBranchEquivalence();
        if (eq.isImplied(e1, e2) && e2.cfImpliesExec()) {
            return e1.exec();
        } else if (eq.isImplied(e2 ,e1) && e1.cfImpliesExec()) {
            return e2.exec();
        }
        return ctx.getFormulaManager().getBooleanFormulaManager().and(e1.exec(), e2.exec());
    }

    protected final BooleanFormula getExecPair(Tuple t, SolverContext ctx) {
        return getExecPair(t.getFirst(), t.getSecond(), ctx);
    }

    protected void removeMutuallyExclusiveTuples(Set<Tuple> tupleSet) {
        BranchEquivalence eq = task.getBranchEquivalence();
        tupleSet.removeIf(t -> eq.areMutuallyExclusive(t.getFirst(), t.getSecond()));
    }

    // ========================== Utility methods =========================
    
    public boolean isStaticRelation() {
    	return this instanceof StaticRelation;
    }
    
    public boolean isUnaryRelation() {
    	return this instanceof UnaryRelation;
    }
    
    public boolean isBinaryRelation() {
    	return this instanceof BinaryRelation;
    }
    
    public boolean isRecursiveRelation() {
    	return this instanceof RecursiveRelation;
    }

    public Relation getInner() {
        return (isUnaryRelation() || isRecursiveRelation()) ? getDependencies().get(0) : null;
    }
    
    public Relation getFirst() {
    	return isBinaryRelation() ? getDependencies().get(0) : null;
    }
    
    public Relation getSecond() {
    	return isBinaryRelation() ? getDependencies().get(1) : null;
    }
}