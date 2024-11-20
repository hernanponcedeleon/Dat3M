package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.aggregates.AggregateCmpExpr;
import com.dat3m.dartagnan.expression.aggregates.ConstructExpr;
import com.dat3m.dartagnan.expression.aggregates.ExtractExpr;
import com.dat3m.dartagnan.expression.booleans.BoolBinaryExpr;
import com.dat3m.dartagnan.expression.booleans.BoolLiteral;
import com.dat3m.dartagnan.expression.booleans.BoolUnaryExpr;
import com.dat3m.dartagnan.expression.floats.*;
import com.dat3m.dartagnan.expression.integers.*;
import com.dat3m.dartagnan.expression.misc.GEPExpr;
import com.dat3m.dartagnan.expression.misc.ITEExpr;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.memory.FinalMemoryValue;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.program.misc.NonDetValue;

public interface ExpressionVisitor<TRet> {

    // =================================== General ===================================
    default TRet visitExpression(Expression expr) { throw unsupported(expr, getClass()); }
    default TRet visitBinaryExpression(BinaryExpression expr) { return visitExpression(expr); }
    default TRet visitUnaryExpression(UnaryExpression expr) { return visitExpression(expr); }
    default TRet visitLeafExpression(LeafExpression expr) { return visitExpression(expr); }
    default TRet visitCastExpression(CastExpression expr) { return visitUnaryExpression(expr); }

    // =================================== Integers ===================================
    default TRet visitIntBinaryExpression(IntBinaryExpr expr) { return visitBinaryExpression(expr); }
    default TRet visitIntCmpExpression(IntCmpExpr expr) { return visitBinaryExpression(expr); }
    default TRet visitIntUnaryExpression(IntUnaryExpr expr) { return visitUnaryExpression(expr); }
    default TRet visitIntSizeCastExpression(IntSizeCast expr) { return visitCastExpression(expr); }
    default TRet visitFloatToIntCastExpression(FloatToIntCast expr) { return visitCastExpression(expr); }
    default TRet visitIntLiteral(IntLiteral lit) { return visitLeafExpression(lit); }

    // =================================== Booleans ===================================
    default TRet visitBoolBinaryExpression(BoolBinaryExpr expr) { return visitBinaryExpression(expr); }
    default TRet visitBoolUnaryExpression(BoolUnaryExpr expr) { return visitUnaryExpression(expr); }
    default TRet visitBoolLiteral(BoolLiteral lit) { return visitLeafExpression(lit); }

    // =================================== Floats ===================================
    default TRet visitFloatBinaryExpression(FloatBinaryExpr expr) { return visitBinaryExpression(expr); }
    default TRet visitFloatCmpExpression(FloatCmpExpr expr) { return visitBinaryExpression(expr); }
    default TRet visitFloatUnaryExpression(FloatUnaryExpr expr) { return visitUnaryExpression(expr); }
    default TRet visitFloatSizeCastExpression(FloatSizeCast expr) { return visitCastExpression(expr); }
    default TRet visitIntToFloatCastExpression(IntToFloatCast expr) { return visitCastExpression(expr); }
    default TRet visitFloatLiteral(FloatLiteral lit) { return visitLeafExpression(lit); }

    // =================================== Aggregates ===================================
    default TRet visitAggregateCmpExpression(AggregateCmpExpr expr) { return  visitBinaryExpression(expr); }
    default TRet visitExtractExpression(ExtractExpr extract) { return visitUnaryExpression(extract); }
    default TRet visitConstructExpression(ConstructExpr construct) { return visitExpression(construct); }

    // =================================== Pointer ===================================
    default TRet visitGEPExpression(GEPExpr expr) { return visitExpression(expr); }

    // =================================== Generic ===================================
    default TRet visitITEExpression(ITEExpr expr) { return visitExpression(expr); }

    // =================================== Program-specific ===================================
    default TRet visitRegister(Register reg) { return visitLeafExpression(reg); }
    default TRet visitFunction(Function function) { return visitLeafExpression(function); }
    default TRet visitMemoryObject(MemoryObject memObj) { return visitLeafExpression(memObj); }
    default TRet visitFinalMemoryValue(FinalMemoryValue val) { return visitLeafExpression(val); }
    default TRet visitNonDetValue(NonDetValue nonDet) { return visitLeafExpression(nonDet); }


    private static UnsupportedOperationException unsupported(Expression expr, Class<?> clazz) {
        final String error = String.format("Expression '%s' is unsupported by %s",
                expr.getClass().getSimpleName(), clazz.getSimpleName());
        return new UnsupportedOperationException(error);
    }

}
