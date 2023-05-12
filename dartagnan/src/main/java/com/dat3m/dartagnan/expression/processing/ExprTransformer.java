package com.dat3m.dartagnan.expression.processing;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.expression.Expression;
import com.dat3m.dartagnan.program.expression.ExpressionFactory;
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
    public Expression visit(Atom atom) {
        return factory.makeBinary(atom.getLHS().visit(this), atom.getOp(), atom.getRHS().visit(this));
    }

    @Override
    public Expression visit(BConst bConst) {
        return bConst;
    }

    @Override
    public Expression visit(BExprBin bBin) {
        Expression l = bBin.getLHS().visit(this);
        Expression r = bBin.getRHS().visit(this);
        return bBin.getLHS().equals(l) && bBin.getRHS().equals(r) ? bBin : factory.makeBinary(l, bBin.getOp(), r);
    }

    @Override
    public Expression visit(BExprUn bUn) {
        Expression i = bUn.getInner().visit(this);
        return bUn.getInner().equals(i) ? bUn : factory.makeUnary(bUn.getOp(), i);
    }

    @Override
    public Expression visit(BNonDet bNonDet) {
        return bNonDet;
    }

    @Override
    public IValue visit(IValue iValue) {
        return iValue;
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
    public Expression visit(IfExpr ifExpr) {
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
