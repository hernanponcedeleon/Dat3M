package com.dat3m.dartagnan.wmm;

import com.dat3m.dartagnan.encoding.EncodingContext;

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

    public EncodingContext.EdgeEncoder getEdgeVariableEncoder(EncodingContext c) {
        String nameOrTerm = definedRelation.getNameOrTerm();
        return (e1, e2) -> c.edgeVariable(nameOrTerm, e1, e2);
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
        return List.of(definedRelation);
    }

    @Override
    public String toString() {
        String term = getTerm();
        return definedRelation.getName().map(s -> s + " := " + term).orElse(term);
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

    public static final class Undefined extends Definition {
        public Undefined(Relation r) {
            super(r, "undefined");
        }

        @Override
        public <T> T accept(Visitor<? extends T> visitor) {
            return visitor.visitUndefined(this);
        }
    }
}