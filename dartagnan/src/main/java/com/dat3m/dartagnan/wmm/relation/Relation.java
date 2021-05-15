package com.dat3m.dartagnan.wmm.relation;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.utils.dependable.Dependent;
import com.dat3m.dartagnan.utils.equivalence.BranchEquivalence;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.relation.base.stat.StaticRelation;
import com.dat3m.dartagnan.wmm.relation.binary.BinaryRelation;
import com.dat3m.dartagnan.wmm.relation.unary.UnaryRelation;
import com.google.common.collect.Sets;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;

import java.util.*;

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

    protected boolean isEncoded;

    protected TupleSet minTupleSet;
    protected TupleSet maxTupleSet;
    protected TupleSet encodeTupleSet;

    protected int recursiveGroupId = 0;
    protected boolean forceUpdateRecursiveGroupId = false;
    protected boolean isRecursive = false;
    protected boolean forceDoEncode = false;

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

    public void initialise(VerificationTask task, Context ctx){
        this.task = task;
        this.minTupleSet = null;
        this.maxTupleSet = null;
        this.isEncoded = false;
        encodeTupleSet = new TupleSet();
    }

    /*
    TODO: getMinTupleSet is no yet used extensively
     */
    public abstract TupleSet getMinTupleSet();

    public abstract TupleSet getMaxTupleSet();

    public TupleSet getMinTupleSetRecursive(){
        return getMinTupleSet();
    }

    public TupleSet getMaxTupleSetRecursive(){
        return getMaxTupleSet();
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
        if (this == obj)
            return true;

        if (obj == null || getClass() != obj.getClass())
            return false;

        return getName().equals(((Relation)obj).getName());
    }

    public BoolExpr encode(Context ctx) {
        if(isEncoded){
            return ctx.mkTrue();
        }
        isEncoded = true;
        return doEncode(ctx);
    }

    protected abstract BoolExpr encodeApprox(Context ctx);

    public BoolExpr encodeIteration(int recGroupId, int iteration, Context ctx){
        return ctx.mkTrue();
    }

    protected BoolExpr doEncode(Context ctx){
        if(!encodeTupleSet.isEmpty() || forceDoEncode){
        	return encodeApprox(ctx);
        }
        return ctx.mkTrue();
    }

    public BoolExpr getSMTVar(Tuple edge, Context ctx) {
        return !getMaxTupleSet().contains(edge) ? ctx.mkFalse() :
                edge(getName(), edge.getFirst(), edge.getSecond(), ctx);
    }

    public final BoolExpr getSMTVar(Event e1, Event e2, Context ctx) {
        return getSMTVar(new Tuple(e1, e2), ctx);
    }

    protected BoolExpr getExecPair(Event e1, Event e2, Context ctx) {
        if (e1.getCId() > e2.getCId()) {
            Event temp = e1;
            e1 = e2;
            e2 = temp;
        }
        BranchEquivalence eq = task.getBranchEquivalence();
        if (eq.isImplied(e1, e2)) {
            return e1.exec();
        } else if (eq.isImplied(e2 ,e1)) {
            return e2.exec();
        }
        return ctx.mkAnd(e1.exec(), e2.exec());
    }

    protected final BoolExpr getExecPair(Tuple t, Context ctx) {
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