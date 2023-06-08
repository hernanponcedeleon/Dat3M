package com.dat3m.dartagnan.expression.processing;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.memory.Location;
import com.dat3m.dartagnan.program.memory.MemoryObject;

public abstract class ExprTransformer implements ExpressionVisitor<Expression> {

    protected final TypeFactory types = TypeFactory.getInstance();
    protected final ExpressionFactory expressions = ExpressionFactory.getInstance();

    @Override
    public Expression visit(Atom atom) {
        return expressions.makeBinary(atom.getLHS().visit(this), atom.getOp(), atom.getRHS().visit(this));
    }

    @Override
    public Expression visit(BConst bConst) {
        return bConst;
    }

    @Override
    public Expression visit(BExprBin bBin) {
        return expressions.makeBinary(bBin.getLHS().visit(this), bBin.getOp(), bBin.getRHS().visit(this));
    }

    @Override
    public Expression visit(BExprUn bUn) {
        return expressions.makeUnary(bUn.getOp(), bUn.getInner().visit(this));
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
    public IExpr visit(IExprBin iBin) {
        return expressions.makeBinary(iBin.getLHS().visit(this), iBin.getOp(), iBin.getRHS().visit(this));
    }

    @Override
    public IExpr visit(IExprUn iUn) {
        return expressions.makeUnary(iUn.getOp(), iUn.getInner().visit(this), iUn.getType());
    }

    @Override
    public Expression visit(IfExpr ifExpr) {
        return expressions.makeConditional(
                ifExpr.getGuard().visit(this),
                ifExpr.getTrueBranch().visit(this),
                ifExpr.getFalseBranch().visit(this));
    }

    @Override
    public IExpr visit(INonDet iNonDet) {
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
