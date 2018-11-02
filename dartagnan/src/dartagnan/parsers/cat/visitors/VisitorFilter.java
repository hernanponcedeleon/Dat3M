package dartagnan.parsers.cat.visitors;

import dartagnan.parsers.CatBaseVisitor;
import dartagnan.parsers.CatParser;
import dartagnan.parsers.CatVisitor;
import dartagnan.parsers.cat.utils.CatSyntaxException;
import dartagnan.wmm.Wmm;
import dartagnan.wmm.filter.*;

public class VisitorFilter extends CatBaseVisitor<FilterAbstract> implements CatVisitor<FilterAbstract> {

    private Wmm wmm;

    public VisitorFilter(Wmm wmm){
        this.wmm = wmm;
    }

    @Override
    public FilterAbstract visitExpr(CatParser.ExprContext ctx) {
        return ctx.e.accept(this);
    }

    @Override
    public FilterAbstract visitExprIntersection(CatParser.ExprIntersectionContext ctx) {
        return new FilterIntersection(ctx.e1.accept(this), ctx.e2.accept(this));
    }

    @Override
    public FilterAbstract visitExprMinus(CatParser.ExprMinusContext ctx) {
        return new FilterMinus(ctx.e1.accept(this), ctx.e2.accept(this));
    }

    @Override
    public FilterAbstract visitExprUnion(CatParser.ExprUnionContext ctx) {
        return new FilterUnion(ctx.e1.accept(this), ctx.e2.accept(this));
    }

    @Override
    public FilterAbstract visitExprComplement(CatParser.ExprComplementContext ctx) {
        throw new RuntimeException("Filter complement is not implemented");
    }

    @Override
    public FilterAbstract visitExprBasic(CatParser.ExprBasicContext ctx) {
        FilterAbstract filter = wmm.getFilter(ctx.getText());
        if(filter == null){
            filter = new FilterBasic(ctx.getText());
            wmm.addFilter(filter);
        }
        return filter;
    }

    @Override
    public FilterAbstract visitExprCartesian(CatParser.ExprCartesianContext ctx) {
        throw new CatSyntaxException(ctx.getText());
    }

    @Override
    public FilterAbstract visitExprComposition(CatParser.ExprCompositionContext ctx) {
        throw new CatSyntaxException(ctx.getText());
    }

    @Override
    public FilterAbstract visitExprFencerel(CatParser.ExprFencerelContext ctx) {
        throw new CatSyntaxException(ctx.getText());
    }

    @Override
    public FilterAbstract visitExprIdentity(CatParser.ExprIdentityContext ctx) {
        throw new CatSyntaxException(ctx.getText());
    }

    @Override
    public FilterAbstract visitExprInverse(CatParser.ExprInverseContext ctx) {
        throw new CatSyntaxException(ctx.getText());
    }

    @Override
    public FilterAbstract visitExprOptional(CatParser.ExprOptionalContext ctx) {
        throw new CatSyntaxException(ctx.getText());
    }

    @Override
    public FilterAbstract visitExprTransitive(CatParser.ExprTransitiveContext ctx) {
        throw new CatSyntaxException(ctx.getText());
    }

    @Override
    public FilterAbstract visitExprTransRef(CatParser.ExprTransRefContext ctx) {
        throw new CatSyntaxException(ctx.getText());
    }
}
