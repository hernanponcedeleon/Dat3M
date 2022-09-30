package com.dat3m.dartagnan.wmm.relation;

import com.dat3m.dartagnan.encoding.Encoder;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.filter.FilterAbstract;
import com.dat3m.dartagnan.utils.dependable.Dependent;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Constraint;
import com.dat3m.dartagnan.wmm.relation.base.stat.StaticRelation;
import com.dat3m.dartagnan.wmm.relation.binary.BinaryRelation;
import com.dat3m.dartagnan.wmm.relation.unary.UnaryRelation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import com.google.common.base.Preconditions;
import com.google.common.collect.Sets;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.SolverContext;

import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.Set;
import java.util.stream.Stream;

import static com.dat3m.dartagnan.encoding.ProgramEncoder.execution;
import static com.dat3m.dartagnan.wmm.utils.Utils.edge;
import static java.util.stream.Collectors.toList;

/**
 *
 * @author Florian Furbach
 */
//TODO: Remove "Encoder" once we split data and operations appropriately
public abstract class Relation implements Constraint, Encoder, Dependent<Relation> {

    public static boolean PostFixApprox = false;

    protected String name;
    protected String term;

    protected VerificationTask task;
    protected Context analysisContext;

    protected TupleSet minTupleSet = null;
    protected TupleSet maxTupleSet = null;
    protected TupleSet encodeTupleSet = null;

    public Relation() { }

    public Relation(String name) {
        this();
        this.name = name;
    }

    public <T> T accept(Visitor<? extends T> visitor) {
        return visitor.visitDefinition(this, List.of());
    }

    @Override
    public List<Relation> getDependencies() {
        return Collections.emptyList();
    }

    // TODO: The following two methods are provided because currently Relations are treated as three things:
    //  data objects, static analysers (relation analysis) and encoders of said data objects.
    //  Once we split these aspects, we might get rid of these methods

    public void configure(Configuration config) throws InvalidConfigurationException { }
    // Due to being an encoder
    public void initializeEncoding(SolverContext ctx) {
    	Preconditions.checkState(this.maxTupleSet != null && this.minTupleSet != null,
    			String.format("No available relation data to encode %s. Perform RelationAnalysis before encoding.", this));
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
    public Collection<? extends Relation> getConstrainedRelations() {
        return accept(new Visitor<>() {
            @Override
            public Collection<? extends Relation> visitDefinition(Relation rel, List<? extends Relation> dependencies) {
                return dependencies;
            }
        });
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
        ExecutionAnalysis exec = analysisContext.requires(ExecutionAnalysis.class);
        return execution(e1, e2, exec, ctx);
    }

    protected final BooleanFormula getExecPair(Tuple t, SolverContext ctx) {
        return getExecPair(t.getFirst(), t.getSecond(), ctx);
    }

    protected void removeMutuallyExclusiveTuples(Set<Tuple> tupleSet) {
        ExecutionAnalysis exec = analysisContext.requires(ExecutionAnalysis.class);
        tupleSet.removeIf(t -> exec.areMutuallyExclusive(t.getFirst(), t.getSecond()));
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

    public interface Visitor <T> {
        default T visitDefinition(Relation rel, List<? extends Relation> dependencies) { return null; }
        default T visitUnion(Relation rel, Relation... operands) { return visitDefinition(rel, List.of(operands)); }
        default T visitIntersection(Relation rel, Relation... operands) { return visitDefinition(rel, List.of(operands)); }
        default T visitDifference(Relation rel, Relation superset, Relation complement) { return visitDefinition(rel, List.of(superset, complement)); }
        default T visitComposition(Relation rel, Relation front, Relation back) { return visitDefinition(rel, List.of(front, back)); }
        default T visitDomainIdentity(Relation rel, Relation operand) { return visitDefinition(rel, List.of(operand)); }
        default T visitRangeIdentity(Relation rel, Relation operand) { return visitDefinition(rel, List.of(operand)); }
        default T visitInverse(Relation rel, Relation operand) { return visitDefinition(rel, List.of(operand)); }
        default T visitRecursive(Relation rel, Relation other) { return visitDefinition(rel, List.of(other)); }
        default T visitTransitiveClosure(Relation rel, Relation operand) { return visitDefinition(rel, List.of(operand)); }
        default T visitEmpty(Relation rel) { return visitDefinition(rel, List.of()); }
        default T visitIdentity(Relation id, FilterAbstract set) { return visitDefinition(id, List.of()); }
        default T visitProduct(Relation rel, FilterAbstract domain, FilterAbstract range) { return visitDefinition(rel, List.of()); }
        default T visitExternal(Relation ext) { return visitDefinition(ext, List.of()); }
        default T visitInternal(Relation int_) { return visitDefinition(int_, List.of()); }
        default T visitProgramOrder(Relation po, FilterAbstract type) { return visitDefinition(po, List.of()); }
        default T visitControl(Relation ctrlDirect) { return visitDefinition(ctrlDirect, List.of()); }
        default T visitFences(Relation fence, FilterAbstract type) { return visitDefinition(fence, List.of()); }
        default T visitInternalDataDependency(Relation idd) { return visitDefinition(idd, List.of()); }
        default T visitCompareAndSwapDependency(Relation casDep) { return visitDefinition(casDep, List.of()); }
        default T visitAddressDependency(Relation addrDirect) { return visitDefinition(addrDirect, List.of()); }
        default T visitCriticalSections(Relation rscs) { return visitDefinition(rscs, List.of()); }
        default T visitReadModifyWrites(Relation rmw) { return visitDefinition(rmw, List.of()); }
        default T visitMemoryOrder(Relation co) { return visitDefinition(co, List.of()); }
        default T visitSameAddress(Relation loc) { return visitDefinition(loc, List.of()); }
        default T visitReadFrom(Relation rf) { return visitDefinition(rf, List.of()); }
    }
}