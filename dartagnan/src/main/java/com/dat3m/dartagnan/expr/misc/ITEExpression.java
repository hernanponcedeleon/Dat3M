package com.dat3m.dartagnan.expr.misc;

import com.dat3m.dartagnan.expr.Expression;
import com.dat3m.dartagnan.expr.ExpressionKind;
import com.dat3m.dartagnan.expr.ExpressionVisitor;
import com.dat3m.dartagnan.expr.Type;
import com.dat3m.dartagnan.expr.helper.ExpressionBase;
import com.dat3m.dartagnan.expr.types.BooleanType;
import com.google.common.base.Preconditions;

import java.util.List;

public class ITEExpression extends ExpressionBase<Type, ExpressionKind.Other> {

    protected ITEExpression(Expression guard,
                            Expression trueCase, Expression falseCase) {
        super(trueCase.getType(), ExpressionKind.Other.ITE, List.of(guard, trueCase, falseCase));
    }

    public Expression getGuard() {return getOperands().get(0);}
    public Expression getTrueExpr() { return getOperands().get(1); }
    public Expression getFalseExpr() { return  getOperands().get(2); }

    public static ITEExpression create(
            Expression guard, Expression trueCase, Expression falseCase) {
        Preconditions.checkArgument(guard.getType() instanceof BooleanType);
        Preconditions.checkArgument(trueCase.getType() == falseCase.getType());
        return new ITEExpression(guard, trueCase, falseCase);
    }

    @Override
    public String toString() {
        return String.format("%s(%s, %s, %s)", getKind().getSymbol(), getGuard(), getTrueExpr(), getFalseExpr());
    }

    @Override
    public <TRet> TRet accept(ExpressionVisitor<TRet> visitor) {
        return visitor.visitITEExpression(this);
    }
}
