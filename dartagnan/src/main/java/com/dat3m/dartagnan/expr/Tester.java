package com.dat3m.dartagnan.expr;

import com.dat3m.dartagnan.expr.aggregates.ExtractValueExpression;
import com.dat3m.dartagnan.expr.aggregates.InsertValueExpression;
import com.dat3m.dartagnan.expr.aggregates.StructExpression;
import com.dat3m.dartagnan.expr.booleans.BoolBinaryExpression;
import com.dat3m.dartagnan.expr.booleans.BoolToIntCastExpression;
import com.dat3m.dartagnan.expr.integers.BitWidthCastExpression;
import com.dat3m.dartagnan.expr.integers.IntBinaryExpression;
import com.dat3m.dartagnan.expr.misc.ITEExpression;
import com.dat3m.dartagnan.expr.pointer.GEPExpression;
import com.dat3m.dartagnan.expr.types.*;
import com.dat3m.dartagnan.programNew.Register;

import java.util.List;

import static com.dat3m.dartagnan.expr.ExpressionKind.IntBinary.ADD;

// Just a little test class to test code via the Debugger.
public class Tester {

    public static void main(String[] args) throws Exception {
        Register a = Register.create(BooleanType.get(), "a", null);
        Register b = Register.create(BooleanType.get(), "b", null);

        Register c = Register.create(IntegerType.get(16), "c", null);
        Register d = Register.create(IntegerType.get(16), "d", null);

        AggregateType boolInt16Type = AggregateType.get(BooleanType.get(), IntegerType.get(16));
        StructExpression struct = StructExpression.create(List.of(a, c));
        boolean typeCheck = struct.getType() == boolInt16Type;
        InsertValueExpression insertD = InsertValueExpression.create(1, struct, d);
        ExtractValueExpression extractD = ExtractValueExpression.create(1, insertD);

        IntBinaryExpression cADDd = IntBinaryExpression.create(extractD, ADD, d);
        BoolBinaryExpression aANDb = BoolBinaryExpression.create(a, ExpressionKind.BoolBinary.AND, b);
        BoolToIntCastExpression boolToInt = BoolToIntCastExpression.create(aANDb);
        BitWidthCastExpression extended = BitWidthCastExpression.create(cADDd.getType(), boolToInt, true);

        ITEExpression ite = ITEExpression.create(aANDb, cADDd, extended);

        Register ptr = Register.create(PointerType.get(), "ptr", null);

        StructExpression myStruct = StructExpression.create(
                IntegerType.INT16.createLiteral(25),
                BooleanType.createConstant(true),
                BooleanType.createConstant(false),
                IntegerType.INT64.createLiteral(12)
        );
        ArrayType arrayTypeOfMyStruct = ArrayType.get(myStruct.getType(), 10);
        GEPExpression typedGep1 = GEPExpression.create(
                arrayTypeOfMyStruct,
                ptr,
                IntegerType.INT32.createLiteral(0),
                IntegerType.INT32.createLiteral(3),
                IntegerType.INT32.createLiteral(2)
        );
        // The following is identical to the above
        GEPExpression typedGep2 = GEPExpression.create(
                myStruct.getType(),
                ptr,
                IntegerType.INT32.createLiteral(3),
                IntegerType.INT32.createLiteral(2)
        );

        // Function type: "myStructType (Array of myStructType, Int64)"
        // Could be the type of a "getElementAtIndex" function.
        FunctionType funcType = FunctionType.get(
                myStruct.getType(),
                arrayTypeOfMyStruct.withUnknownNumElements(),
                IntegerType.INT64
        );



        int breakPoint = 5; // Just a line of code to place a breakpoint and inspect the above code.

    }
}
