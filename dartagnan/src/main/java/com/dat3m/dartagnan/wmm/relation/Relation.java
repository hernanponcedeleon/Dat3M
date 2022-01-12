package com.dat3m.dartagnan.wmm.relation;

import com.dat3m.dartagnan.encoding.Encoder;
import com.dat3m.dartagnan.program.analysis.BranchEquivalence;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.utils.dependable.Dependent;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.relation.base.stat.StaticRelation;
import com.dat3m.dartagnan.wmm.relation.binary.BinaryRelation;
import com.dat3m.dartagnan.wmm.relation.unary.UnaryRelation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import com.google.common.base.Preconditions;
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
//TODO: Remove "Encoder" once we split data and operations appropriately
public abstract class Relation implements Encoder, Dependent<Relation> {

    public static boolean PostFixApprox = false;

    protected String name;
    protected String term;

    protected VerificationTask task;
    protected Context analysisContext;

    protected boolean isEncoded;

    protected TupleSet minTupleSet = null;
    protected TupleSet maxTupleSet = null;
    protected TupleSet encodeTupleSet = null;

    protected int recursiveGroupId = 0;
    protected boolean forceUpdateRecursiveGroupId = false;
    protected boolean isRecursive = false;
    protected boolean forceDoEncode = false;

    public Relation() { }

    public Relation(String name) {
        this();
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

    // TODO: The following two methods are provided because currently Relations are treated as three things:
    //  data objects, static analysers (relation analysis) and encoders of said data objects.
    //  Once we split these aspects, we might get rid of these methods

    // Due to being an encoder
    public void initializeEncoding(SolverContext ctx) {
        Preconditions.checkState(this.maxTupleSet != null && this.minTupleSet != null,
                "No available relation data to encode. Perform RelationAnalysis before encoding.");
        this.isEncoded = false;
        this.encodeTupleSet = new TupleSet();
    }

    // TODO: We misuse <task> as data object and analysis information object.
    // Due to partaking in relation analysis
    public void initializeRelationAnalysis(VerificationTask task, Context context) {
        this.task = task;
        this.analysisContext = context;
        this.maxTupleSet = null;
        this.minTupleSet = null;
    }

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
        if (this == obj) {
            return true;
        } else if (obj == null || getClass() != obj.getClass()) {
            return false;
        }

        return getName().equals(((Relation)obj).getName());
    }

    public BooleanFormula encode(SolverContext ctx) {
        if(isEncoded){
            return ctx.getFormulaManager().getBooleanFormulaManager().makeTrue();
        }
        isEncoded = true;
        return doEncode(ctx);
    }

    protected abstract BooleanFormula encodeApprox(SolverContext ctx);

    protected BooleanFormula doEncode(SolverContext ctx){
        if(!encodeTupleSet.isEmpty() || forceDoEncode){
        	return encodeApprox(ctx);
        }
        return ctx.getFormulaManager().getBooleanFormulaManager().makeTrue();
    }

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
        BranchEquivalence eq = analysisContext.requires(BranchEquivalence.class);
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
        BranchEquivalence eq = analysisContext.requires(BranchEquivalence.class);
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