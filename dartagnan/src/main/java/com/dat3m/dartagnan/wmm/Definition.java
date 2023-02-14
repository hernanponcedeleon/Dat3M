package com.dat3m.dartagnan.wmm;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.program.filter.FilterAbstract;

import java.util.ArrayList;
import java.util.List;
import java.util.Stack;

import static com.google.common.base.Preconditions.checkNotNull;

public abstract class Definition implements Constraint {

    protected final Relation definedRelation;
    private final String termPattern;

    protected Definition(Relation r) {
        this(r, r.getName().orElseThrow());
    }

    protected Definition(Relation r, String t) {
        definedRelation = checkNotNull(r);
        termPattern = checkNotNull(t);
    }

    public Relation getDefinedRelation() {
        return definedRelation;
    }

    public <T> T accept(Visitor<? extends T> visitor) {
        return visitor.visitDefinition(definedRelation, List.of());
    }

    public EncodingContext.EdgeEncoder getEdgeVariableEncoder(EncodingContext c) {
        String nameOrTerm = definedRelation.getNameOrTerm();
        return tuple -> c.edgeVariable(nameOrTerm, tuple.getFirst(), tuple.getSecond());
    }

    public String getTerm() {
        return getTerm(new Stack<>());
    }

    /**
     * @return
     * Non-empty list of all relations directly participating in this definition.
     * The first relation is always the defined relation,
     * while the roles of the others are implementation-dependent.
     */
    @Override
    public List<Relation> getConstrainedRelations() {
        return accept(new Definition.Visitor<>() {
            @Override
            public List<Relation> visitDefinition(Relation rel, List<? extends Relation> dependencies) {
                List<Relation> relations = new ArrayList<>(dependencies.size() + 1);
                relations.add(rel);
                relations.addAll(dependencies);
                return relations;
            }
        });
    }

    @Override
    public String toString() {
        String term = getTerm();
        return definedRelation.getName().map(s -> s + " := " + term).orElse(term);
    }

    public interface Visitor <T> {
        default T visitDefinition(Relation rel, List<? extends Relation> dependencies) { throw new UnsupportedOperationException("applying " + getClass().getSimpleName() + " to relation " + rel); }
        default T visitUnion(Relation rel, Relation... operands) { return visitDefinition(rel, List.of(operands)); }
        default T visitIntersection(Relation rel, Relation... operands) { return visitDefinition(rel, List.of(operands)); }
        default T visitDifference(Relation rel, Relation superset, Relation complement) { return visitDefinition(rel, List.of(superset, complement)); }
        default T visitComposition(Relation rel, Relation front, Relation back) { return visitDefinition(rel, List.of(front, back)); }
        default T visitDomainIdentity(Relation rel, Relation operand) { return visitDefinition(rel, List.of(operand)); }
        default T visitRangeIdentity(Relation rel, Relation operand) { return visitDefinition(rel, List.of(operand)); }
        default T visitInverse(Relation rel, Relation operand) { return visitDefinition(rel, List.of(operand)); }
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
        default T visitCoherence(Relation co) { return visitDefinition(co, List.of()); }
        default T visitSameAddress(Relation loc) { return visitDefinition(loc, List.of()); }
        default T visitReadFrom(Relation rf) { return visitDefinition(rf, List.of()); }
        default T visitSameScope(Relation sc) { return visitDefinition(sc, List.of()); }
    }

    public static final class Undefined extends Definition {
        Undefined(Relation r) {
            super(r, "undefined");
        }
    }

    private String getTerm(Stack<Definition> stack) {
        if (stack.contains(this)) {
            // Unreachable, as long as all recursions happen over a named relation
            return "...";
        }
        stack.push(this);
        List<Relation> l = getConstrainedRelations();
        int s = l.size() - 1;
        Object[] o = new Object[s];
        for (int i = 0; i < s; i++) {
            Relation r = l.get(i + 1);
            o[i] = r.getName().orElseGet(() -> "(" + r.definition.getTerm(stack) + ")");
        }
        stack.pop();
        return String.format(termPattern, o);
    }
}