package com.dat3m.dartagnan.expression.processing;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.expression.Literal;
import com.dat3m.dartagnan.program.memory.Location;
import com.dat3m.dartagnan.program.memory.MemoryObject;

public interface ExpressionVisitor<T> {
    default T visit(Atom atom) { return null; }
    default T visit(BExprBin bBin) { return null; }
    default T visit(BExprUn bUn) { return null; }
    default T visit(Literal literal) { return null; }
    default T visit(IExprBin iBin) { return null; }
    default T visit(IExprUn iUn) { return null; }
    default T visit(IfExpr ifExpr) { return null; }
    default T visit(INonDet iNonDet) { return null; }
    default T visit(Register reg) { return null; }
    default T visit(MemoryObject address) { return null; }
    default T visit(Location location) { return null; }
}
