package com.dat3m.dartagnan.expression.processing;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.memory.Address;
import com.dat3m.dartagnan.program.memory.Location;


public abstract class ExprTransformer implements ExpressionVisitor<ExprInterface> {

    @Override
    public ExprInterface visit(Atom atom) {
        return new Atom(atom.getLHS().visit(this), atom.getOp(), atom.getRHS().visit(this));
    }

    @Override
    public BExpr visit(BConst bConst) {
        return bConst;
    }

    @Override
    public BExpr visit(BExprBin bBin) {
        return new BExprBin(bBin.getLHS().visit(this), bBin.getOp(), bBin.getRHS().visit(this));
    }

    @Override
    public BExpr visit(BExprUn bUn) {
        return new BExprUn(bUn.getOp(), bUn.getInner().visit(this));
    }

    @Override
    public BExpr visit(BNonDet bNonDet) {
        return bNonDet;
    }

    @Override
    public IExpr visit(IConst iConst) {
        return iConst;
    }

    @Override
    public IExpr visit(IExprBin iBin) {
        return new IExprBin(iBin.getLHS().visit(this), iBin.getOp(), iBin.getRHS().visit(this));
    }

    @Override
    public IExpr visit(IExprUn iUn) {
        return new IExprUn(iUn.getOp(), iUn.getInner().visit(this));
    }

    @Override
    public ExprInterface visit(IfExpr ifExpr) {
        return new IfExpr((BExpr)ifExpr.getGuard().visit(this), ifExpr.getTrueBranch().visit(this), ifExpr.getFalseBranch().visit(this));
    }

    @Override
    public IExpr visit(INonDet iNonDet) {
        return iNonDet;
    }

    @Override
    public ExprInterface visit(Location loc) {
        return loc;
    }

    @Override
    public ExprInterface visit(Register reg) {
        return reg;
    }

    @Override
    public ExprInterface visit(Address address) {
        return address;
    }
}
