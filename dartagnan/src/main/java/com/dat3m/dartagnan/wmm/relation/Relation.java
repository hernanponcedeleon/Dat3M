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
	protected boolean fetchedMinTupleSet;

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

    public void initialise(VerificationTask task, SolverContext ctx){
        this.task = task;
        this.minTupleSet = new TupleSet();
        this.maxTupleSet = null;
        encodeTupleSet = new TupleSet();
		disableTupleSet = new TupleSet();
		fetchedMinTupleSet = false;
    }

    public abstract TupleSet getMaxTupleSet();

	/**
	 * Under-approximates relationships with minimal preconditions.
	 * Such relationships hold in all consistent runs that execute both participating events.
	 * @return
	 * Current collection of minimal event pairs in this relation.
	 * @see #fetchMinTupleSet()
	 */
	public final TupleSet getMinTupleSet() {
		if(!fetchedMinTupleSet) {
			fetchedMinTupleSet = true;
			fetchMinTupleSet();
		}
		return minTupleSet;
	}

	/**
	 * Recomputes the set of minimal tuples in this relation.
	 * Does not remove existing minimal tuples.
	 * Also fetches disabled tuples.
	 * <p>
	 * This method is recursive:
	 * All composed relations except {@link RecursiveRelation} always recur.
	 * @see #getMinTupleSet()
	 */
	public void fetchMinTupleSet() {
	}

	/**
	 * Accesses the current must-not-set associated with the task.
	 * <p>
	 * This relation has to be analysed up to this point,
	 * with {@link com.dat3m.dartagnan.wmm.Wmm#encodeRelations(SolverContext)}.
	 * @return
	 * Read-only subset of the may-set marked as must-not.
	 */
	public final TupleSet getDisableTupleSet() {
		return disableTupleSet;
	}

    public TupleSet getMaxTupleSetRecursive(){
        return getMaxTupleSet();
    }

	/**
	 * Marks relationships as impossible due to some axiom of the associated model.
	 * @param tuples
	 * Tuples to be marked if contained by the may-set.
	 * Retains all newly-marked relationships.
	 * @return
	 * Detected some new minimal tuples.
	 */
	public boolean disable(TupleSet tuples) {
		tuples.removeIf(t -> !maxTupleSet.contains(t) || !disableTupleSet.add(t));
		return false;
	}

	/**
	 * Tries to find new disabled tuples.
	 * This method is specialised by compositions and intersections,
	 * as later bottom-up minimal tuples are not allowed to eagerly trigger top-down disabling.
	 * @return
	 * Detected some new minimal tuples.
	 */
	public boolean continueDisableTupleSet() {
		return false;
	}

    public TupleSet getEncodeTupleSet(){
        return encodeTupleSet;
    }

	/**
	 * Activates all must-not relationships that still have support.
	 * The support has to be encoded, and constrained accordingly.
	 * For unions and differences, this does nothing.
	 * For intersections and compositions, this is crucial.
	 */
	public void initEncodeTupleSet() {
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
        return !getMaxTupleSet().contains(edge) ?
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