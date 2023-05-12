package com.dat3m.dartagnan.expr;

import com.dat3m.dartagnan.expr.aggregates.ExtractValueExpression;
import com.dat3m.dartagnan.expr.aggregates.InsertValueExpression;
import com.dat3m.dartagnan.expr.aggregates.StructExpression;
import com.dat3m.dartagnan.expr.booleans.*;
import com.dat3m.dartagnan.expr.integers.*;
import com.dat3m.dartagnan.expr.misc.ITEExpression;
import com.dat3m.dartagnan.expr.pointer.GEPExpression;
import com.dat3m.dartagnan.expr.pointer.IntToPtrExpression;
import com.dat3m.dartagnan.expr.pointer.PtrToIntExpression;
import com.dat3m.dartagnan.programNew.Function;
import com.dat3m.dartagnan.programNew.GlobalObject;
import com.dat3m.dartagnan.programNew.GlobalVariable;
import com.dat3m.dartagnan.programNew.Register;

public interface ExpressionVisitor<TRet> {

    // =================================== General ===================================
    default TRet visitExpression(Expression expr) { throw unsupported(expr, getClass()); }
    default TRet visitBinaryExpression(BinaryExpression expr) { return visitExpression(expr); }
    default TRet visitUnaryExpression(UnaryExpression expr) { return visitExpression(expr); }
    default TRet visitLeafExpression(LeafExpression expr) { return visitExpression(expr); }
    default TRet visitConstant(Constant expr) { return visitLeafExpression(expr); }
    default TRet visitLiteral(Literal<?> literal) { return visitConstant(literal); }
    default TRet visitCastExpression(CastExpression expr) { return visitUnaryExpression(expr); }

    // =================================== Integers ===================================
    default TRet visitIntBinaryExpression(IntBinaryExpression expr) { return visitBinaryExpression(expr); }
    default TRet visitIntUnaryExpression(IntUnaryExpression expr) { return visitUnaryExpression(expr); }
    default TRet visitRelationalExpression(RelationalExpression expr) { return visitBinaryExpression(expr); }
    default TRet visitIntLiteral(IntLiteral constant) { return visitLiteral(constant); }
    default TRet visitBitWidthCastExpression(BitWidthCastExpression expr) { return visitCastExpression(expr); }
    default TRet visitIntNonDetExpression(IntNonDetExpression expr) { return visitConstant(expr); }

    // =================================== Booleans ===================================
    default TRet visitBoolBinaryExpression(BoolBinaryExpression expr) { return visitBinaryExpression(expr); }
    default TRet visitBoolUnaryExpression(BoolUnaryExpression expr) { return visitUnaryExpression(expr); }
    default TRet visitBoolLiteral(BoolLiteral constant) { return visitLiteral(constant); }
    default TRet visitBoolToIntCastExpression(BoolToIntCastExpression expr) { return visitCastExpression(expr); }
    default TRet visitBoolNonDetExpression(BoolNonDetExpression expr) { return visitConstant(expr); }

    // =================================== Aggregates ===================================
    default TRet visitExtractValueExpression(ExtractValueExpression expr) { return visitUnaryExpression(expr); }
    default TRet visitInsertValueExpression(InsertValueExpression expr) { return visitBinaryExpression(expr); }
    default TRet visitStructExpression(StructExpression expr) { return visitExpression(expr); }

    // =================================== Pointer ===================================
    default TRet visitGEPExpression(GEPExpression expr) { return visitExpression(expr); }
    default TRet visitIntToPtrExpression(IntToPtrExpression expr) { return visitCastExpression(expr); }
    default TRet visitPtrToIntExpression(PtrToIntExpression expr) { return visitCastExpression(expr); }

    // =================================== Misc ===================================
    default TRet visitITEExpression(ITEExpression expr) { return visitExpression(expr); }
    default TRet visitRegister(Register reg) { return visitLeafExpression(reg); }
    default TRet visitParameter(Function.Parameter parameter) { return visitLeafExpression(parameter); }
    default TRet visitGlobalObject(GlobalObject global) { return visitConstant(global); }
    default TRet visitFunction(Function function) { return visitGlobalObject(function); }
    default TRet visitGlobalVariable(GlobalVariable variable) { return visitGlobalObject(variable); }


    private static UnsupportedOperationException unsupported(Expression expr, Class<?> clazz) {
        final String error = String.format("Expression '%s' is unsupported by %s",
                expr.getClass().getSimpleName(), clazz.getSimpleName());
        return new UnsupportedOperationException(error);
    }
}
