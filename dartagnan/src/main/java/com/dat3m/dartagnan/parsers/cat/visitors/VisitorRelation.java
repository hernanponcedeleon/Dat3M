package com.dat3m.dartagnan.parsers.cat.visitors;

import com.dat3m.dartagnan.parsers.CatBaseVisitor;
import com.dat3m.dartagnan.parsers.CatVisitor;
import com.dat3m.dartagnan.parsers.CatParser;
import com.dat3m.dartagnan.wmm.filter.FilterAbstract;
import com.dat3m.dartagnan.wmm.relation.RecursiveRelation;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.relation.base.stat.RelCartesian;
import com.dat3m.dartagnan.wmm.relation.base.stat.RelFencerel;
import com.dat3m.dartagnan.wmm.relation.base.stat.RelSetIdentity;
import com.dat3m.dartagnan.wmm.relation.binary.RelComposition;
import com.dat3m.dartagnan.wmm.relation.binary.RelIntersection;
import com.dat3m.dartagnan.wmm.relation.binary.RelMinus;
import com.dat3m.dartagnan.wmm.relation.binary.RelUnion;
import com.dat3m.dartagnan.wmm.relation.unary.*;

public class VisitorRelation extends CatBaseVisitor<Relation> implements CatVisitor<Relation> {

    private final VisitorBase base;

    VisitorRelation(VisitorBase base){
        this.base = base;
    }

    @Override
    public Relation visitExpr(CatParser.ExprContext ctx) {
        return ctx.e.accept(this);
    }

    @Override
    public Relation visitExprComposition(CatParser.ExprCompositionContext ctx) {
        return visitBinaryRelation(ctx.e1, ctx.e2, RelComposition.class);
    }

    @Override
    public Relation visitExprIntersection(CatParser.ExprIntersectionContext ctx) {
        return visitBinaryRelation(ctx.e1, ctx.e2, RelIntersection.class);
    }

    @Override
    public Relation visitExprMinus(CatParser.ExprMinusContext ctx) {
        return visitBinaryRelation(ctx.e1, ctx.e2, RelMinus.class);
    }

    @Override
    public Relation visitExprUnion(CatParser.ExprUnionContext ctx) {
        return visitBinaryRelation(ctx.e1, ctx.e2, RelUnion.class);
    }

    @Override
    public Relation visitExprInverse(CatParser.ExprInverseContext ctx) {
        return visitUnaryRelation(ctx.e, RelInverse.class);
    }

    @Override
    public Relation visitExprTransitive(CatParser.ExprTransitiveContext ctx) {
        return visitUnaryRelation(ctx.e, RelTrans.class);
    }

    @Override
    public Relation visitExprTransRef(CatParser.ExprTransRefContext ctx) {
        return visitUnaryRelation(ctx.e, RelTransRef.class);
    }

    @Override
    public Relation visitExprDomainIdentity(CatParser.ExprDomainIdentityContext ctx) {
        return visitUnaryRelation(ctx.e, RelDomainIdentity.class);
    }

    @Override
    public Relation visitExprRangeIdentity(CatParser.ExprRangeIdentityContext ctx) {
        return visitUnaryRelation(ctx.e, RelRangeIdentity.class);
    }

    @Override
    public Relation visitExprComplement(CatParser.ExprComplementContext ctx) {
        throw new RuntimeException("Relation complement is not implemented");
    }

    @Override
    public Relation visitExprOptional(CatParser.ExprOptionalContext ctx) {
        Relation r = ctx.e.accept(this);
        if(r != null){
            return base.relationRepository.getRelation(RelUnion.class, base.relationRepository.getRelation("id"), r);
        }
        return null;
    }

    @Override
    public Relation visitExprIdentity(CatParser.ExprIdentityContext ctx) {
        boolean orig = base.recursiveDef;
        base.recursiveDef = false;
        FilterAbstract filter = ctx.e.accept(base.filterVisitor);
        Relation relation = base.relationRepository.getRelation(RelSetIdentity.class, filter);
        base.recursiveDef = orig;
        return relation;
    }

    @Override
    public Relation visitExprCartesian(CatParser.ExprCartesianContext ctx) {
        boolean orig = base.recursiveDef;
        base.recursiveDef = false;
        FilterAbstract filter1 = ctx.e1.accept(base.filterVisitor);
        FilterAbstract filter2 = ctx.e2.accept(base.filterVisitor);
        Relation relation = base.relationRepository.getRelation(RelCartesian.class, filter1, filter2);
        base.recursiveDef = orig;
        return relation;
    }

    @Override
    public Relation visitExprFencerel(CatParser.ExprFencerelContext ctx) {
        return base.relationRepository.getRelation(RelFencerel.class, ctx.n.getText());
    }

    @Override
    public Relation visitExprBasic(CatParser.ExprBasicContext ctx) {
        Relation relation = base.relationRepository.getRelation(ctx.n.getText());
        if(relation == null && base.recursiveDef){
            relation = base.relationRepository.getRelation(RecursiveRelation.class, ctx.n.getText());
        }
        return relation;
    }

    private Relation visitBinaryRelation(CatParser.ExpressionContext e1, CatParser.ExpressionContext e2, Class<?> c){
        Relation r1 = e1.accept(this);
        Relation r2 = e2.accept(this);
        if(r1 != null && r2 != null){
            return base.relationRepository.getRelation(c, r1, r2);
        }
        return null;
    }

    private Relation visitUnaryRelation(CatParser.ExpressionContext e, Class<?> c){
        Relation r = e.accept(this);
        if(r != null){
            return base.relationRepository.getRelation(c, r);
        }
        return null;
    }
}
