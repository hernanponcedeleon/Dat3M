package com.dat3m.dartagnan.expression.processing;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.booleans.BoolBinaryExpr;
import com.dat3m.dartagnan.expression.booleans.BoolLiteral;
import com.dat3m.dartagnan.expression.booleans.BoolUnaryExpr;
import com.dat3m.dartagnan.expression.booleans.NonDetBool;
import com.dat3m.dartagnan.expression.integers.*;
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
        atom.getLeft().accept(this);
        atom.getRight().accept(this);
        return atom;
    }

    default Expression visit(BoolBinaryExpr bBin) {
        bBin.getLeft().accept(this);
        bBin.getRight().accept(this);
        return bBin;
    }

    default Expression visit(BoolUnaryExpr bUn) {
        bUn.getOperand().accept(this);
        return bUn;
    }

    default Expression visit(IntBinaryExpr iBin) {
        iBin.getLeft().accept(this);
        iBin.getRight().accept(this);
        return iBin;
    }

    default Expression visit(IntUnaryExpr iUn) {
        iUn.getOperand().accept(this);
        return iUn;
    }

    default Expression visit(ITEExpr iteExpr) {
        iteExpr.getCondition().accept(this);
        iteExpr.getFalseCase().accept(this);
        iteExpr.getTrueCase().accept(this);
        return iteExpr;
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

    default Expression visit(Location location) {
        location.getMemoryObject().accept(this);
        return location;
    }

    default Expression visit(BoolLiteral boolLiteral) { return boolLiteral;  }
    default Expression visit(NonDetBool nonDetBool) { return nonDetBool; }
    default Expression visit(IntLiteral intLiteral) { return intLiteral; }
    default Expression visit(NonDetInt iNonDet) { return iNonDet; }
    default Expression visit(Register reg) { return reg; }
    default Expression visit(MemoryObject address) { return address; }
    default Expression visit(Function function) { return function; }
}
