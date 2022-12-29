package com.dat3m.dartagnan.parsers.cat.visitors;

import com.dat3m.dartagnan.parsers.CatBaseVisitor;
import com.dat3m.dartagnan.parsers.CatParser;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.filter.FilterAbstract;
import com.dat3m.dartagnan.program.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.relation.base.stat.RelCartesian;
import com.dat3m.dartagnan.wmm.relation.base.stat.RelFencerel;
import com.dat3m.dartagnan.wmm.relation.base.stat.RelSetIdentity;
import com.dat3m.dartagnan.wmm.relation.binary.RelComposition;
import com.dat3m.dartagnan.wmm.relation.binary.RelIntersection;
import com.dat3m.dartagnan.wmm.relation.binary.RelMinus;
import com.dat3m.dartagnan.wmm.relation.binary.RelUnion;
import com.dat3m.dartagnan.wmm.relation.unary.*;

import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.ID;

public class VisitorRelation extends CatBaseVisitor<Relation> {

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
        Relation r = ctx.e.accept(this);
        if(r != null){
            return base.wmm.getRelation(RelTrans.class, base.wmm.getRelation(RelUnion.class, base.wmm.getRelation(ID), r));
        }
        return null;
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
        Relation r = ctx.e.accept(this);
        if(r != null){
        	Relation allPairs = base.wmm.getRelation(RelCartesian.class,
					FilterBasic.get(Tag.VISIBLE), FilterBasic.get(Tag.VISIBLE));
            return base.wmm.getRelation(RelMinus.class, allPairs, r);
        }
        return null;
    }

    @Override
    public Relation visitExprOptional(CatParser.ExprOptionalContext ctx) {
        Relation r = ctx.e.accept(this);
        if(r != null){
            return base.wmm.getRelation(RelUnion.class, base.wmm.getRelation(ID), r);
        }
        return null;
    }

    @Override
    public Relation visitExprIdentity(CatParser.ExprIdentityContext ctx) {
        FilterAbstract filter = ctx.e.accept(base.filterVisitor);
        return base.wmm.getRelation(RelSetIdentity.class, filter);
    }

    @Override
    public Relation visitExprCartesian(CatParser.ExprCartesianContext ctx) {
        FilterAbstract filter1 = ctx.e1.accept(base.filterVisitor);
        FilterAbstract filter2 = ctx.e2.accept(base.filterVisitor);
        return base.wmm.getRelation(RelCartesian.class, filter1, filter2);
    }

    @Override
    public Relation visitExprFencerel(CatParser.ExprFencerelContext ctx) {
        FilterAbstract filter = ctx.e.accept(base.filterVisitor);
        Relation relation = base.wmm.getRelation(RelFencerel.class, filter);
        return relation;
    }

    @Override
    public Relation visitExprBasic(CatParser.ExprBasicContext ctx) {
        return base.wmm.getRelation(ctx.n.getText());
    }

    private Relation visitBinaryRelation(CatParser.ExpressionContext e1, CatParser.ExpressionContext e2, Class<?> c){
        Relation r1 = e1.accept(this);
        Relation r2 = e2.accept(this);
        if(r1 != null && r2 != null){
            return base.wmm.getRelation(c, r1, r2);
        }
        return null;
    }

    private Relation visitUnaryRelation(CatParser.ExpressionContext e, Class<?> c){
        Relation r = e.accept(this);
        if(r != null){
            return base.wmm.getRelation(c, r);
        }
        return null;
    }
}
