package com.dat3m.dartagnan.parsers.cat.visitors;

import com.dat3m.dartagnan.parsers.CatBaseVisitor;
import com.dat3m.dartagnan.parsers.CatVisitor;
import com.dat3m.dartagnan.parsers.CatParser;
import com.dat3m.dartagnan.parsers.cat.utils.ParsingException;
import com.dat3m.dartagnan.wmm.filter.*;

public class VisitorFilter extends CatBaseVisitor<FilterAbstract> implements CatVisitor<FilterAbstract> {

    private final VisitorBase base;

    VisitorFilter(VisitorBase base){
        this.base = base;
    }

    @Override
    public FilterAbstract visitExpr(CatParser.ExprContext ctx) {
        return ctx.e.accept(this);
    }

    @Override
    public FilterAbstract visitExprIntersection(CatParser.ExprIntersectionContext ctx) {
        return FilterIntersection.get(ctx.e1.accept(this), ctx.e2.accept(this));
    }

    @Override
    public FilterAbstract visitExprMinus(CatParser.ExprMinusContext ctx) {
        return FilterMinus.get(ctx.e1.accept(this), ctx.e2.accept(this));
    }

    @Override
    public FilterAbstract visitExprUnion(CatParser.ExprUnionContext ctx) {
        return FilterUnion.get(ctx.e1.accept(this), ctx.e2.accept(this));
    }

    @Override
    public FilterAbstract visitExprComplement(CatParser.ExprComplementContext ctx) {
        throw new RuntimeException("Filter complement is not implemented");
    }

    @Override
    public FilterAbstract visitExprBasic(CatParser.ExprBasicContext ctx) {
        FilterAbstract filter = base.wmm.getFilter(ctx.getText());
        if(filter == null){
            filter = FilterBasic.get(ctx.getText());
            base.wmm.addFilter(filter);
        }
        return filter;
    }

    @Override
    public FilterAbstract visitExprCartesian(CatParser.ExprCartesianContext ctx) {
        throw new ParsingException(ctx.getText());
    }

    @Override
    public FilterAbstract visitExprComposition(CatParser.ExprCompositionContext ctx) {
        throw new ParsingException(ctx.getText());
    }

    @Override
    public FilterAbstract visitExprFencerel(CatParser.ExprFencerelContext ctx) {
        throw new ParsingException(ctx.getText());
    }

    @Override
    public FilterAbstract visitExprDomainIdentity(CatParser.ExprDomainIdentityContext ctx) {
        throw new ParsingException(ctx.getText());
    }

    @Override
    public FilterAbstract visitExprRangeIdentity(CatParser.ExprRangeIdentityContext ctx) {
        throw new ParsingException(ctx.getText());
    }

    @Override
    public FilterAbstract visitExprIdentity(CatParser.ExprIdentityContext ctx) {
        throw new ParsingException(ctx.getText());
    }

    @Override
    public FilterAbstract visitExprInverse(CatParser.ExprInverseContext ctx) {
        throw new ParsingException(ctx.getText());
    }

    @Override
    public FilterAbstract visitExprOptional(CatParser.ExprOptionalContext ctx) {
        throw new ParsingException(ctx.getText());
    }

    @Override
    public FilterAbstract visitExprTransitive(CatParser.ExprTransitiveContext ctx) {
        throw new ParsingException(ctx.getText());
    }

    @Override
    public FilterAbstract visitExprTransRef(CatParser.ExprTransRefContext ctx) {
        throw new ParsingException(ctx.getText());
    }
}
