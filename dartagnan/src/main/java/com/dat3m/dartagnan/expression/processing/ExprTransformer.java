package com.dat3m.dartagnan.expression.processing;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.LeafExpression;
import com.dat3m.dartagnan.expression.aggregates.AggregateCmpExpr;
import com.dat3m.dartagnan.expression.aggregates.ConstructExpr;
import com.dat3m.dartagnan.expression.aggregates.ExtractExpr;
import com.dat3m.dartagnan.expression.aggregates.InsertExpr;
import com.dat3m.dartagnan.expression.booleans.BoolBinaryExpr;
import com.dat3m.dartagnan.expression.booleans.BoolUnaryExpr;
import com.dat3m.dartagnan.expression.floats.FloatBinaryExpr;
import com.dat3m.dartagnan.expression.floats.FloatCmpExpr;
import com.dat3m.dartagnan.expression.floats.FloatUnaryExpr;
import com.dat3m.dartagnan.expression.integers.*;
import com.dat3m.dartagnan.expression.misc.GEPExpr;
import com.dat3m.dartagnan.expression.misc.ITEExpr;
import com.dat3m.dartagnan.expression.type.TypeFactory;

import java.util.ArrayList;

public abstract class ExprTransformer implements ExpressionVisitor<Expression> {

    protected final TypeFactory types = TypeFactory.getInstance();
    protected final ExpressionFactory expressions = ExpressionFactory.getInstance();

    @Override
    public Expression visitBoolBinaryExpression(BoolBinaryExpr expr) {
        return expressions.makeBoolBinary(expr.getLeft().accept(this), expr.getKind(), expr.getRight().accept(this));
    }

    @Override
    public Expression visitBoolUnaryExpression(BoolUnaryExpr expr) {
        return expressions.makeBoolUnary(expr.getKind(), expr.getOperand().accept(this));
    }

    @Override
    public Expression visitIntBinaryExpression(IntBinaryExpr iBin) {
        return expressions.makeIntBinary(iBin.getLeft().accept(this), iBin.getKind(), iBin.getRight().accept(this));
    }

    @Override
    public Expression visitIntCmpExpression(IntCmpExpr cmp) {
        return expressions.makeIntCmp(cmp.getLeft().accept(this), cmp.getKind(), cmp.getRight().accept(this));
    }

    @Override
    public Expression visitIntUnaryExpression(IntUnaryExpr expr) {
        return expressions.makeIntUnary(expr.getKind(), expr.getOperand().accept(this));
    }

    @Override
    public Expression visitIntConcat(IntConcat expr) {
        return expressions.makeIntConcat(expr.getOperands().stream().map(e -> e.accept(this)).toList());
    }

    @Override
    public Expression visitIntExtract(IntExtract expr) {
        return expressions.makeIntExtract(expr.getOperand().accept(this), expr.getLowBit(), expr.getHighBit());
    }

    @Override
    public Expression visitIntSizeCastExpression(IntSizeCast expr) {
        return expressions.makeIntegerCast(expr.getOperand().accept(this), expr.getTargetType(), expr.preservesSign());
    }

    @Override
    public Expression visitFloatBinaryExpression(FloatBinaryExpr expr) {
        return expressions.makeFloatBinary(expr.getLeft().accept(this), expr.getKind(), expr.getRight().accept(this));
    }

    @Override
    public Expression visitFloatCmpExpression(FloatCmpExpr expr) {
        return expressions.makeFloatCmp(expr.getLeft().accept(this), expr.getKind(), expr.getRight().accept(this));
    }

    @Override
    public Expression visitFloatUnaryExpression(FloatUnaryExpr expr) {
        return expressions.makeFloatUnary(expr.getKind(), expr.getOperand().accept(this));
    }

    @Override
    public Expression visitITEExpression(ITEExpr expr) {
        return expressions.makeITE(
                expr.getCondition().accept(this),
                expr.getTrueCase().accept(this),
                expr.getFalseCase().accept(this));
    }

    @Override
    public Expression visitConstructExpression(ConstructExpr construct) {
        final var arguments = new ArrayList<Expression>();
        for (final Expression argument : construct.getOperands()) {
            arguments.add(argument.accept(this));
        }
        return expressions.makeConstruct(construct.getType(), arguments);
    }

    @Override
    public Expression visitExtractExpression(ExtractExpr expr) {
        return expressions.makeExtract(expr.getOperand().accept(this), expr.getIndices());
    }

    @Override
    public Expression visitInsertExpression(InsertExpr insert) {
        return expressions.makeInsert(insert.getAggregate().accept(this),
                insert.getInsertedValue().accept(this), insert.getIndices());
    }

    @Override
    public Expression visitAggregateCmpExpression(AggregateCmpExpr expr) {
        return expressions.makeAggregateCmp(
                expr.getLeft().accept(this),
                expr.getKind(),
                expr.getRight().accept(this)
        );
    }

    @Override
    public Expression visitGEPExpression(GEPExpr gep) {
        Expression base = gep.getBase().accept(this);
        final var offsets = new ArrayList<Expression>();
        for (Expression offset : gep.getOffsets()) {
            offsets.add(offset.accept(this));
        }
        return expressions.makeGetElementPointer(gep.getIndexingType(), base, offsets);
    }

    @Override
    public Expression visitLeafExpression(LeafExpression expr) {
        return expr;
    }
}
