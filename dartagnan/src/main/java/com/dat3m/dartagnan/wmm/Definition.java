package com.dat3m.dartagnan.wmm;

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

    public String getTerm() {
        return getTerm(new Stack<>());
    }

    // INVARIANT: The first relation is always the defined relation.
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