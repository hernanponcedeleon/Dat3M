package com.dat3m.dartagnan.parsers.cat;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.parsers.CatBaseVisitor;
import com.dat3m.dartagnan.parsers.CatParser.*;
import com.dat3m.dartagnan.program.filter.FilterAbstract;
import com.dat3m.dartagnan.program.filter.FilterBasic;
import com.dat3m.dartagnan.program.filter.FilterIntersection;
import com.dat3m.dartagnan.program.filter.FilterMinus;
import com.dat3m.dartagnan.program.filter.FilterUnion;
import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.definition.*;
import com.google.common.base.VerifyException;

import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

import static com.dat3m.dartagnan.program.event.Tag.VISIBLE;
import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.ID;
import static com.google.common.base.Verify.verify;

class VisitorBase extends CatBaseVisitor<Object> {

    private final Wmm wmm;
    private final Map<String, Object> namespace = new HashMap<>();
    private Relation current;
    private String alias;
    private final Map<String, Relation> termMap = new HashMap<>();

    VisitorBase() {
        this.wmm = new Wmm();
    }

    @Override
    public Object visitMcm(McmContext ctx) {
        super.visitMcm(ctx);
        return wmm;
    }

    @Override
    public Void visitAxiomDefinition(AxiomDefinitionContext ctx) {
        try {
            Relation r = relation(ctx.e);
            Constructor<?> constructor = ctx.cls.getConstructor(Relation.class, boolean.class, boolean.class);
            Axiom axiom = (Axiom) constructor.newInstance(r, ctx.negate != null, ctx.flag != null);
            if (ctx.NAME() != null) {
                axiom.setName(ctx.NAME().toString());
            }
            wmm.addAxiom(axiom);
        } catch (NoSuchMethodException | InstantiationException | IllegalAccessException |
                 InvocationTargetException e) {
            throw new ParsingException(ctx.getText());
        }
        return null;
    }

    @Override
    public Void visitLetDefinition(LetDefinitionContext ctx) {
        String name = ctx.n.getText();
        alias = name;
        Object definedPredicate = ctx.e.accept(this);
        namespace.put(name, definedPredicate);
        if (definedPredicate instanceof FilterAbstract) {
            FilterAbstract filter = (FilterAbstract) definedPredicate;
            filter.setName(name);
            wmm.addFilter(filter);
        }
        return null;
    }

    @Override
    public Void visitLetRecDefinition(LetRecDefinitionContext ctx) {
        int size = ctx.letRecAndDefinition().size();
        Relation[] recursiveGroup = new Relation[size + 1];
        String name = ctx.n.getText();
        recursiveGroup[0] = wmm.newRelation(name);
        namespace.put(name, recursiveGroup[0]);
        for (int i = 0; i < size; i++) {
            name = ctx.letRecAndDefinition(i).n.getText();
            recursiveGroup[i + 1] = wmm.newRelation(name);
            namespace.put(name, recursiveGroup[i + 1]);
        }
        for (Relation r : recursiveGroup) {
            r.setRecursive();
        }
        current = recursiveGroup[0];
        relation(ctx.e);
        for (int i = 0; i < size; i++) {
            current = recursiveGroup[i + 1];
            relation(ctx.letRecAndDefinition(i).e);
        }
        return null;
    }

    @Override
    public Object visitExpr(ExprContext ctx) {
        return ctx.e.accept(this);
    }

    @Override
    public Object visitExprBasic(ExprBasicContext ctx) {
        String name = ctx.n.getText();
        Object predicate = namespace.computeIfAbsent(name,
                k -> wmm.containsRelation(k) ? wmm.getRelation(k) : FilterBasic.get(k));
        addCurrentName(predicate);
        return predicate;
    }

    @Override
    public Object visitExprIntersection(ExprIntersectionContext c) {
        checkNoCurrentOrNoAlias(c);
        Relation current = current();
        String alias = alias();
        Object o1 = c.e1.accept(this);
        Object o2 = c.e2.accept(this);
        if (o1 instanceof Relation) {
            Relation r0 = current != null ? current : newRelation(alias);
            return addDefinition(new Intersection(r0, (Relation) o1, relation(o2, c)));
        }
        return withAlias(alias, FilterIntersection.get(set(o1, c), set(o2, c)));
    }

    @Override
    public Object visitExprMinus(ExprMinusContext c) {
        checkNoCurrent(c);
        String alias = alias();
        Object o1 = c.e1.accept(this);
        Object o2 = c.e2.accept(this);
        if (o1 instanceof Relation) {
            Relation r0 = newRelation(alias);
            return addDefinition(new Difference(r0, (Relation) o1, relation(o2, c)));
        }
        return withAlias(alias, FilterMinus.get(set(o1, c), set(o2, c)));
    }

    @Override
    public Object visitExprUnion(ExprUnionContext c) {
        checkNoCurrentOrNoAlias(c);
        Relation current = current();
        String alias = alias();
        Object o1 = c.e1.accept(this);
        Object o2 = c.e2.accept(this);
        if (o1 instanceof Relation) {
            Relation r0 = current != null ? current : newRelation(alias);
            return addDefinition(new Union(r0, (Relation) o1, relation(o2, c)));
        }
        return withAlias(alias, FilterUnion.get(set(o1, c), set(o2, c)));
    }

    @Override
    public Object visitExprComplement(ExprComplementContext c) {
        checkNoCurrent(c);
        String alias = alias();
        Object o1 = c.e.accept(this);
        FilterBasic visible = FilterBasic.get(VISIBLE);
        if (o1 instanceof Relation) {
            Relation r0 = newRelation(alias);
            Relation all = wmm.newRelation();
            Relation r1 = wmm.addDefinition(new CartesianProduct(all, visible, visible));
            return addDefinition(new Difference(r0, r1, (Relation) o1));
        }
        return withAlias(alias, FilterMinus.get(visible, set(o1, c)));
    }

    @Override
    public Relation visitExprComposition(ExprCompositionContext c) {
        checkNoCurrentOrNoAlias(c);
        Relation r = current();
        String a = alias();
        Relation r0 = r != null ? r : newRelation(a);
        Relation r1 = relation(c.e1);
        Relation r2 = relation(c.e2);
        return addDefinition(new Composition(r0, r1, r2));
    }

    @Override
    public Relation visitExprInverse(ExprInverseContext c) {
        checkNoCurrent(c);
        Relation r0 = newRelation(alias());
        Relation r1 = relation(c.e);
        return addDefinition(new Inverse(r0, r1));
    }

    @Override
    public Relation visitExprTransitive(ExprTransitiveContext c) {
        checkNoCurrent(c);
        Relation r0 = newRelation(alias());
        Relation r1 = relation(c.e);
        return addDefinition(new TransitiveClosure(r0, r1));
    }

    @Override
    public Relation visitExprTransRef(ExprTransRefContext c) {
        checkNoCurrent(c);
        Relation r0 = newRelation(alias());
        Relation r1 = wmm.newRelation();
        Relation r2 = wmm.getRelation(ID);
        Relation r3 = relation(c.e);
        return addDefinition(new TransitiveClosure(r0, addDefinition(new Union(r1, r2, r3))));
    }

    @Override
    public Relation visitExprDomainIdentity(ExprDomainIdentityContext c) {
        checkNoCurrent(c);
        Relation r0 = newRelation(alias());
        Relation r1 = relation(c.e);
        return addDefinition(new DomainIdentity(r0, r1));
    }

    @Override
    public Relation visitExprRangeIdentity(ExprRangeIdentityContext c) {
        checkNoCurrent(c);
        Relation r0 = newRelation(alias());
        Relation r1 = relation(c.e);
        return addDefinition(new RangeIdentity(r0, r1));
    }

    @Override
    public Relation visitExprOptional(ExprOptionalContext c) {
        checkNoCurrent(c);
        Relation r0 = newRelation(alias());
        Relation r1 = relation(c.e);
        return addDefinition(new Union(r0, wmm.getRelation(ID), r1));
    }

    @Override
    public Relation visitExprIdentity(ExprIdentityContext c) {
        checkNoCurrent(c);
        Relation r0 = newRelation(alias());
        FilterAbstract s1 = set(c.e);
        return addDefinition(new Identity(r0, s1));
    }

    @Override
    public Relation visitExprCartesian(ExprCartesianContext c) {
        checkNoCurrent(c);
        Relation r0 = newRelation(alias());
        FilterAbstract s1 = set(c.e1);
        FilterAbstract s2 = set(c.e2);
        return addDefinition(new CartesianProduct(r0, s1, s2));
    }

    @Override
    public Relation visitExprFencerel(ExprFencerelContext ctx) {
        checkNoCurrent(ctx);
        Relation r0 = newRelation(alias());
        FilterAbstract s1 = set(ctx.e);
        return addDefinition(new Fences(r0, s1));
    }

    private void addCurrentName(Object o) {
        if (alias == null) {
            return;
        }
        if (o instanceof Relation) {
            wmm.addAlias(alias, (Relation) o);
        }
        namespace.put(alias, o);
        alias = null;
    }

    private void checkNoCurrent(ExpressionContext c) {
        if(current != null) {
            throw new ParsingException("Unexpected recursive context at expression: " + c.getText());
        }
    }

    private Relation current() {
        Relation r = current;
        current = null;
        return r;
    }

    private void checkNoCurrentOrNoAlias(ExpressionContext c) {
        if (current != null && alias != null) {
            // call getText only if necessary.
            throw new VerifyException(String.format("Simultaneous let and let rec expression at \"%s\"", c.getText()));
        }
    }

    private String alias() {
        String a = alias;
        alias = null;
        return a;
    }

    private FilterAbstract withAlias(String name, FilterAbstract filter) {
        if (name != null) {
            namespace.put(name, filter);
        }
        return filter;
    }

    private Relation newRelation(String name) {
        if (name == null) {
            return wmm.newRelation();
        }
        Relation newRelation = wmm.newRelation(name);
        namespace.put(name, newRelation);
        return newRelation;
    }

    private Relation addDefinition(Definition definition) {
        String term = definition.getTerm();
        Relation mappedRelation = termMap.get(term);
        Relation definedRelation = definition.getDefinedRelation();
        if (mappedRelation == null) {
            termMap.put(term, definedRelation);
            return wmm.addDefinition(definition);
        }
        Optional<String> name = definedRelation.getName();
        wmm.deleteRelation(definedRelation);
        if (name.isPresent()) {
            Object v = namespace.put(name.get(), mappedRelation);
            verify(v == definedRelation);
            wmm.addAlias(name.get(), mappedRelation);
        }
        verify(!namespace.containsValue(definedRelation));
        return mappedRelation;
    }

    private Relation relation(ExpressionContext t) {
        return relation(t.accept(this), t);
    }

    private Relation relation(Object o, ExpressionContext t) {
        if (o instanceof Relation) {
            return (Relation) o;
        }
        throw new ParsingException("Expected relation, got " + o.getClass().getSimpleName() + " " + o + " from expression " + t.getText());
    }

    private FilterAbstract set(ExpressionContext t) {
        return set(t.accept(this), t);
    }

    private static FilterAbstract set(Object o, ExpressionContext t) {
        if (o instanceof FilterAbstract) {
            return (FilterAbstract) o;
        }
        throw new ParsingException("Expected set, got " + o.getClass().getSimpleName() + " " + o + " from expression " + t.getText());
    }
}

