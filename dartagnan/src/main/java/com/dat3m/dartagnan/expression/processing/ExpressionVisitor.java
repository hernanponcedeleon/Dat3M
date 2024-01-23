package com.dat3m.dartagnan.expression.processing;

import com.dat3m.dartagnan.expression.Construction;
import com.dat3m.dartagnan.expression.Extraction;
import com.dat3m.dartagnan.expression.GEPExpression;
import com.dat3m.dartagnan.expression.ITEExpr;
import com.dat3m.dartagnan.expression.booleans.BoolBinaryExpr;
import com.dat3m.dartagnan.expression.booleans.BoolLiteral;
import com.dat3m.dartagnan.expression.booleans.BoolUnaryExpr;
import com.dat3m.dartagnan.expression.booleans.NonDetBool;
import com.dat3m.dartagnan.expression.integers.*;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.memory.Location;
import com.dat3m.dartagnan.program.memory.MemoryObject;

public interface ExpressionVisitor<T> {
    default T visit(Atom atom) { return null; }
    default T visit(BoolLiteral boolLiteral) { return null; }
    default T visit(BoolBinaryExpr bBin) { return null; }
    default T visit(BoolUnaryExpr bUn) { return null; }
    default T visit(NonDetBool nonDetBool) { return null; }
    default T visit(IntLiteral intLiteral) { return null; }
    default T visit(IntBinaryExpr iBin) { return null; }
    default T visit(IntUnaryExpr iUn) { return null; }
    default T visit(ITEExpr iteExpr) { return null; }
    default T visit(NonDetInt iNonDet) { return null; }
    default T visit(Register reg) { return null; }
    default T visit(MemoryObject address) { return null; }
    default T visit(Location location) { return null; }
    default T visit(Function function) { return null; }
    default T visit(Construction construction) { return null; }
    default T visit(Extraction extraction) { return null; }
    default T visit(GEPExpression getElementPointer) { return null; }
}
