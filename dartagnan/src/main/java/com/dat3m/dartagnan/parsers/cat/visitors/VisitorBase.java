package com.dat3m.dartagnan.parsers.cat.visitors;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.parsers.CatBaseVisitor;
import com.dat3m.dartagnan.parsers.CatParser.*;
import com.dat3m.dartagnan.program.filter.FilterAbstract;
import com.dat3m.dartagnan.program.filter.FilterBasic;
import com.dat3m.dartagnan.program.filter.FilterIntersection;
import com.dat3m.dartagnan.program.filter.FilterMinus;
import com.dat3m.dartagnan.program.filter.FilterUnion;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.relation.*;
import com.dat3m.dartagnan.wmm.relation.base.stat.*;
import com.dat3m.dartagnan.wmm.relation.binary.*;
import com.dat3m.dartagnan.wmm.relation.unary.*;

import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;
import java.util.HashMap;
import java.util.Map;

import static com.dat3m.dartagnan.program.event.Tag.VISIBLE;
import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.ID;

public class VisitorBase extends CatBaseVisitor<Object> {

    private final Wmm wmm;
    private final Map<String, Object> namespace = new HashMap<>();

    public VisitorBase() {
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
        String n = ctx.n.getText();
        Object o = ctx.e.accept(this);
        namespace.put(n, o);
        if (o instanceof Relation) {
            wmm.addAlias(n, (Relation) o);
        } else {
            assert o instanceof FilterAbstract;
            FilterAbstract f = (FilterAbstract) o;
            f.setName(n);
            wmm.addFilter(f);
        }
        return null;
    }

    @Override
    public Void visitLetRecDefinition(LetRecDefinitionContext ctx) {
        int size = ctx.letRecAndDefinition().size();
        RecursiveRelation[] recursiveGroup = new RecursiveRelation[size + 1];
        recursiveGroup[0] = new RecursiveRelation(ctx.n.getText());
        for (int i = 0; i < size; i++) {
            recursiveGroup[i + 1] = new RecursiveRelation(ctx.letRecAndDefinition(i).n.getText());
        }
        for (RecursiveRelation r : recursiveGroup) {
            wmm.addRelation(r);
        }
        recursiveGroup[0].setConcreteRelation(relation(ctx.e).getDefinition());
        for (int i = 0; i < size; i++) {
            recursiveGroup[i + 1].setConcreteRelation(relation(ctx.letRecAndDefinition(i).e).getDefinition());
        }
        return null;
    }

    @Override
    public Object visitExpr(ExprContext ctx) {
        return ctx.e.accept(this);
    }

    @Override
    public Object visitExprBasic(ExprBasicContext ctx) {
        String n = ctx.n.getText();
        Object o = namespace.get(n);
        if (o != null) {
            return o;
        }
        Relation r = wmm.getRelation(n);
        if (r != null) {
            namespace.put(n, r);
            return r;
        }
        FilterBasic f = FilterBasic.get(n);
        namespace.put(n, f);
        return f;
    }

    @Override
    public Object visitExprIntersection(ExprIntersectionContext c) {
        Object o1 = c.e1.accept(this);
        Object o2 = c.e2.accept(this);
        if (o1 instanceof Relation) {
            return wmm.getRelation(RelIntersection.class, o1, relation(o2, c));
        }
        return FilterIntersection.get(set(o1, c), set(o2, c));
    }

    @Override
    public Object visitExprMinus(ExprMinusContext c) {
        Object o1 = c.e1.accept(this);
        Object o2 = c.e2.accept(this);
        if (o1 instanceof Relation) {
            return wmm.getRelation(RelMinus.class, o1, relation(o2, c));
        }
        return FilterMinus.get(set(o1, c), set(o2, c));
    }

    @Override
    public Object visitExprUnion(ExprUnionContext c) {
        Object o1 = c.e1.accept(this);
        Object o2 = c.e2.accept(this);
        if (o1 instanceof Relation) {
            return wmm.getRelation(RelUnion.class, o1, relation(o2, c));
        }
        return FilterUnion.get(set(o1, c), set(o2, c));
    }

    @Override
    public Object visitExprComplement(ExprComplementContext c) {
        Object o1 = c.e.accept(this);
        FilterBasic visible = FilterBasic.get(VISIBLE);
        if (o1 instanceof Relation) {
            return wmm.getRelation(RelMinus.class, wmm.getRelation(RelCartesian.class, visible, visible), o1);
        }
        return FilterMinus.get(visible, set(o1, c));
    }

    @Override
    public Relation visitExprComposition(ExprCompositionContext c) {
        Relation r1 = relation(c.e1);
        Relation r2 = relation(c.e2);
        return wmm.getRelation(RelComposition.class, r1, r2);
    }

    @Override
    public Relation visitExprInverse(ExprInverseContext c) {
        Relation r1 = relation(c.e);
        return wmm.getRelation(RelInverse.class, r1);
    }

    @Override
    public Relation visitExprTransitive(ExprTransitiveContext c) {
        Relation r1 = relation(c.e);
        return wmm.getRelation(RelTrans.class, r1);
    }

    @Override
    public Relation visitExprTransRef(ExprTransRefContext c) {
        Relation r1 = relation(c.e);
        return wmm.getRelation(RelTrans.class, wmm.getRelation(RelUnion.class, wmm.getRelation(ID), r1));
    }

    @Override
    public Relation visitExprDomainIdentity(ExprDomainIdentityContext c) {
        Relation r1 = relation(c.e);
        return wmm.getRelation(RelDomainIdentity.class, r1);
    }

    @Override
    public Relation visitExprRangeIdentity(ExprRangeIdentityContext c) {
        Relation r1 = relation(c.e);
        return wmm.getRelation(RelRangeIdentity.class, r1);
    }

    @Override
    public Relation visitExprOptional(ExprOptionalContext c) {
        Relation r1 = relation(c.e);
        return wmm.getRelation(RelUnion.class, wmm.getRelation(ID), r1);
    }

    @Override
    public Relation visitExprIdentity(ExprIdentityContext c) {
        FilterAbstract s1 = set(c.e);
        return wmm.getRelation(RelSetIdentity.class, s1);
    }

    @Override
    public Relation visitExprCartesian(ExprCartesianContext c) {
        FilterAbstract s1 = set(c.e1);
        FilterAbstract s2 = set(c.e2);
        return wmm.getRelation(RelCartesian.class, s1, s2);
    }

    @Override
    public Relation visitExprFencerel(ExprFencerelContext ctx) {
        FilterAbstract s1 = set(ctx.e);
        return wmm.getRelation(RelFencerel.class, s1);
    }

    private Relation relation(ExpressionContext t) {
        return relation(t.accept(this), t);
    }

    private Relation relation(Object o, ExpressionContext t) {
        if (o instanceof Relation) {
            return (Relation) o;
        }
        throw new ParsingException("expected relation, got " + o.getClass().getSimpleName() + " " + o + " from expression " + t.getText());
    }

    private FilterAbstract set(ExpressionContext t) {
        return set(t.accept(this), t);
    }

    private static FilterAbstract set(Object o, ExpressionContext t) {
        if (o instanceof FilterAbstract) {
            return (FilterAbstract) o;
        }
        throw new ParsingException("expected set, got " + o.getClass().getSimpleName() + " " + o + " from expression " + t.getText());
    }
}

