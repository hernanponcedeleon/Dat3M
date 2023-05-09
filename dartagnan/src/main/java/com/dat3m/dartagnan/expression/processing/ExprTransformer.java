package com.dat3m.dartagnan.expression.processing;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.expression.ExpressionFactory;
import com.dat3m.dartagnan.program.memory.Location;
import com.dat3m.dartagnan.program.memory.MemoryObject;

public abstract class ExprTransformer implements ExpressionVisitor<ExprInterface> {

    protected final ExpressionFactory factory;

    protected ExprTransformer(ExpressionFactory factory) {
        this.factory = factory;
    }

    @Override
    public ExprInterface visit(Atom atom) {
        return factory.makeBinary(atom.getLHS().visit(this), atom.getOp(), atom.getRHS().visit(this));
    }

    @Override
    public BExpr visit(BConst bConst) {
        return bConst;
    }

    @Override
    public BExpr visit(BExprBin bBin) {
        return factory.makeBinary(bBin.getLHS().visit(this), bBin.getOp(), bBin.getRHS().visit(this));
    }

    @Override
    public BExpr visit(BExprUn bUn) {
        return factory.makeUnary(bUn.getOp(), bUn.getInner().visit(this));
    }

    @Override
    public BExpr visit(BNonDet bNonDet) {
        return bNonDet;
    }

    @Override
    public IValue visit(IValue iValue) {
        return iValue;
    }

    @Override
    public IExpr visit(IExprBin iBin) {
        return factory.makeBinary((IExpr) iBin.getLHS().visit(this), iBin.getOp(), (IExpr) iBin.getRHS().visit(this));
    }

    @Override
    public IExpr visit(IExprUn iUn) {
        return factory.makeUnary(iUn.getOp(), (IExpr) iUn.getInner().visit(this));
    }

    @Override
    public ExprInterface visit(IfExpr ifExpr) {
        return factory.makeConditional(
                (BExpr)ifExpr.getGuard().visit(this),
                (IExpr)ifExpr.getTrueBranch().visit(this),
                (IExpr)ifExpr.getFalseBranch().visit(this));
    }

    @Override
    public IExpr visit(INonDet iNonDet) {
        return iNonDet;
    }

    @Override
    public ExprInterface visit(Register reg) {
        return reg;
    }

    @Override
    public ExprInterface visit(MemoryObject address) {
        return address;
    }

    @Override
    public ExprInterface visit(Location location) {
        return location;
    }
}
