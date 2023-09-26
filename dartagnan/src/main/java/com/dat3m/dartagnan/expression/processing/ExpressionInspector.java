package com.dat3m.dartagnan.expression.processing;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.memory.Location;
import com.dat3m.dartagnan.program.memory.MemoryObject;

/*
    This is a helper class to be used to traverse/inspect expression with RegReader.transformExpressions,
    without changing the expressions.
 */
public interface ExpressionInspector extends ExpressionVisitor<Expression>{
    default Expression visit(Atom atom) {
        atom.getLHS().accept(this);
        atom.getRHS().accept(this);
        return atom;
    }

    default Expression visit(BExprBin bBin) {
        bBin.getLHS().accept(this);
        bBin.getRHS().accept(this);
        return bBin;
    }

    default Expression visit(BExprUn bUn) {
        bUn.getInner().accept(this);
        return bUn;
    }

    default Expression visit(IExprBin iBin) {
        iBin.getLHS().accept(this);
        iBin.getRHS().accept(this);
        return iBin;
    }

    default Expression visit(IExprUn iUn) {
        iUn.getInner().accept(this);
        return iUn;
    }

    default Expression visit(IfExpr ifExpr) {
        ifExpr.getGuard().accept(this);
        ifExpr.getFalseBranch().accept(this);
        ifExpr.getTrueBranch().accept(this);
        return ifExpr;
    }

    default Expression visit(Construction construction) {
        construction.getArguments().forEach(arg -> arg.accept(this));
        return construction;
    }
    default Expression visit(Extraction extraction) {
        extraction.getObject().accept(this);
        return extraction;
    }

    default Expression visit(GEPExpression getElementPointer) {
        getElementPointer.getBaseExpression().accept(this);
        getElementPointer.getOffsetExpressions().forEach(o -> o.accept(this));
        return getElementPointer;
    }

    @Override
    default Expression visit(PointerCast pointerCast) {
        pointerCast.getInnerExpression().accept(this);
        return pointerCast;
    }

    default Expression visit(Location location) {
        location.getMemoryObject().accept(this);
        return location;
    }

    default Expression visit(BConst bConst) { return bConst;  }
    default Expression visit(BNonDet bNonDet) { return bNonDet; }
    default Expression visit(IValue iValue) { return iValue; }
    default Expression visit(INonDet iNonDet) { return iNonDet; }
    default Expression visit(Register reg) { return reg; }
    default Expression visit(MemoryObject address) { return address; }
    default Expression visit(Function function) { return function; }
    default Expression visit(NullPointer constant) { return constant; }
}
