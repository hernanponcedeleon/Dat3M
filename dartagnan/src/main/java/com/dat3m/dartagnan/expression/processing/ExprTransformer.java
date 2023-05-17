package com.dat3m.dartagnan.expression.processing;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.expression.*;
import com.dat3m.dartagnan.program.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.memory.Location;
import com.dat3m.dartagnan.program.memory.MemoryObject;

public abstract class ExprTransformer implements ExpressionVisitor<Expression> {

    protected static final TypeFactory types = TypeFactory.getInstance();
    protected final ExpressionFactory factory;

    protected ExprTransformer(ExpressionFactory factory) {
        this.factory = factory;
    }

    @Override
    public Expression visit(Comparison comparison) {
        return factory.makeBinary(comparison.getLHS().visit(this), comparison.getOp(), comparison.getRHS().visit(this));
    }

    @Override
    public Expression visit(BinaryBooleanExpression bBin) {
        Expression l = bBin.getLHS().visit(this);
        Expression r = bBin.getRHS().visit(this);
        return bBin.getLHS().equals(l) && bBin.getRHS().equals(r) ? bBin : factory.makeBinary(l, bBin.getOp(), r);
    }

    @Override
    public Expression visit(UnaryBooleanExpression bUn) {
        Expression i = bUn.getInner().visit(this);
        return bUn.getInner().equals(i) ? bUn : factory.makeUnary(bUn.getOp(), i);
    }

    @Override
    public Literal visit(Literal literal) {
        return literal;
    }

    @Override
    public Expression visit(IExprBin iBin) {
        Expression l = iBin.getLHS().visit(this);
        Expression r = iBin.getRHS().visit(this);
        return iBin.getLHS().equals(l) && iBin.getRHS().equals(r) ? iBin : factory.makeBinary(l, iBin.getOp(), r);
    }

    @Override
    public Expression visit(IExprUn iUn) {
        Expression i = iUn.getInner().visit(this);
        return iUn.getInner().equals(i) ? iUn : factory.makeUnary(iUn.getOp(), i);
    }

    @Override
    public Expression visit(ConditionalExpression ifExpr) {
        Expression g = ifExpr.getGuard().visit(this);
        Expression t = ifExpr.getTrueBranch().visit(this);
        Expression f = ifExpr.getFalseBranch().visit(this);
        return ifExpr.getGuard().equals(g) && ifExpr.getTrueBranch().equals(t) && ifExpr.getFalseBranch().equals(f) ?
                ifExpr : factory.makeConditional(g, t, f);
    }

    @Override
    public Expression visit(INonDet iNonDet) {
        return iNonDet;
    }

    @Override
    public Expression visit(Register reg) {
        return reg;
    }

    @Override
    public Expression visit(MemoryObject address) {
        return address;
    }

    @Override
    public Expression visit(Location location) {
        return location;
    }
}
