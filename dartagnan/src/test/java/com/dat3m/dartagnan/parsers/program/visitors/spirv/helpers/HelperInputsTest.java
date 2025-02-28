package com.dat3m.dartagnan.parsers.program.visitors.spirv.helpers;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.ScopedPointerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.event.Tag;
import org.junit.Test;

import java.util.List;

import static com.dat3m.dartagnan.parsers.program.visitors.spirv.helpers.HelperInputs.castInputType;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;

public class HelperInputsTest {

    private static final TypeFactory types = TypeFactory.getInstance();

    @Test
    public void testPointerTypeScalar() {
        IntegerType int32 = types.getIntegerType(32);
        IntegerType int64 = types.getIntegerType(64);

        ScopedPointerType ptr32 = types.getScopedPointerType(Tag.Spirv.SC_GENERIC, int32);
        assertEquals(int32, castInputType("test", ptr32, int32));
        assertEquals(int32, castInputType("test", ptr32, int64));

        ScopedPointerType ptr64 = types.getScopedPointerType(Tag.Spirv.SC_GENERIC, int64);
        assertEquals(int64, castInputType("test", ptr64, int32));
        assertEquals(int64, castInputType("test", ptr64, int64));
    }

    @Test
    public void testPointerTypeComposite() {
        IntegerType int32 = types.getIntegerType(32);
        IntegerType int64 = types.getIntegerType(64);
        Type agg32 = types.getAggregateType(List.of(int32, int32, int32));
        Type agg64 = types.getAggregateType(List.of(int64, int64, int64));
        Type arr32 = types.getArrayType(int32, 3);
        Type arr64 = types.getArrayType(int64, 3);

        ScopedPointerType ptr32 = types.getScopedPointerType(Tag.Spirv.SC_GENERIC, int32);
        assertEquals(arr32, castInputType("test", ptr32, agg32));
        assertEquals(arr32, castInputType("test", ptr32, arr32));
        assertEquals(arr32, castInputType("test", ptr32, agg64));
        assertEquals(arr32, castInputType("test", ptr32, arr64));

        ScopedPointerType ptr64 = types.getScopedPointerType(Tag.Spirv.SC_GENERIC, int64);
        assertEquals(arr64, castInputType("test", ptr64, agg32));
        assertEquals(arr64, castInputType("test", ptr64, arr32));
        assertEquals(arr64, castInputType("test", ptr64, agg64));
        assertEquals(arr64, castInputType("test", ptr64, arr64));
    }

    @Test
    public void testPointerTypeCompositeNested() {
        IntegerType int32 = types.getIntegerType(32);
        IntegerType int64 = types.getIntegerType(64);
        Type agg = types.getAggregateType(List.of(int64, int64, int64));
        Type arr = types.getArrayType(int64, 3);

        ScopedPointerType ptr32 = types.getScopedPointerType(Tag.Spirv.SC_GENERIC, int32);
        Type exp32 = types.getArrayType(types.getArrayType(int32, 3), 1);
        assertEquals(exp32, castInputType("test", ptr32, types.getAggregateType(List.of(agg))));
        assertEquals(exp32, castInputType("test", ptr32, types.getAggregateType(List.of(arr))));
        assertEquals(exp32, castInputType("test", ptr32, types.getArrayType(agg, 1)));
        assertEquals(exp32, castInputType("test", ptr32, types.getArrayType(arr, 1)));

        ScopedPointerType ptr64 = types.getScopedPointerType(Tag.Spirv.SC_GENERIC, int64);
        Type exp64 = types.getArrayType(types.getArrayType(int64, 3), 1);
        assertEquals(exp64, castInputType("test", ptr64, types.getAggregateType(List.of(agg))));
        assertEquals(exp64, castInputType("test", ptr64, types.getAggregateType(List.of(arr))));
        assertEquals(exp64, castInputType("test", ptr64, types.getArrayType(agg, 1)));
        assertEquals(exp64, castInputType("test", ptr64, types.getArrayType(arr, 1)));
    }

    @Test
    public void testInvalidPointerConversion() {
        IntegerType int32 = types.getIntegerType(32);
        IntegerType int64 = types.getIntegerType(64);

        Type agg1 = types.getAggregateType(List.of(int64));
        Type agg2 = types.getAggregateType(List.of(int64, int64));
        Type agg3 = types.getAggregateType(List.of(int64, int64, int64));

        Type arr1 = types.getArrayType(int64, 1);
        Type arr2 = types.getArrayType(int64, 2);
        Type arr3 = types.getArrayType(int64, 3);

        doTestInvalidInput(int32, types.getAggregateType(List.of(agg1, agg1, agg1)),
                getUnexpectedNumberElementsError("test", 1, 3));
        doTestInvalidInput(int32, types.getAggregateType(List.of(agg1, agg2)),
                getMismatchingValueTypeError("test"));
        doTestInvalidInput(int32, types.getAggregateType(List.of(agg3, agg3)),
                getUnexpectedNumberElementsError("test", 1, 2));

        doTestInvalidInput(int32, types.getAggregateType(List.of(arr1, arr1, arr1)),
                getUnexpectedNumberElementsError("test", 1, 3));
        doTestInvalidInput(int32, types.getAggregateType(List.of(arr1, arr2)),
                getMismatchingValueTypeError("test"));
        doTestInvalidInput(int32, types.getAggregateType(List.of(arr3, arr3)),
                getUnexpectedNumberElementsError("test", 1, 2));

        doTestInvalidInput(int32, types.getAggregateType(List.of(arr1, agg1)),
                getMismatchingValueTypeError("test"));
        doTestInvalidInput(int32, types.getAggregateType(List.of(types.getAggregateType(List.of(int64, int64, agg1)))),
                getMismatchingValueTypeError("test[0]"));

        doTestInvalidInput(int32, types.getArrayType(agg1, 3),
                getUnexpectedNumberElementsError("test", 1, 3));
        doTestInvalidInput(int32, types.getArrayType(agg3, 2),
                getUnexpectedNumberElementsError("test", 1, 2));
        doTestInvalidInput(int32, types.getArrayType(arr1, 3),
                getUnexpectedNumberElementsError("test", 1, 3));
        doTestInvalidInput(int32, types.getArrayType(arr3, 2),
                getUnexpectedNumberElementsError("test", 1, 2));

        doTestInvalidInput(int32, types.getArrayType(arr3, 0),
                getUnexpectedNumberElementsError("test", 1, 0));
        doTestInvalidInput(int32, types.getArrayType(arr3),
                getUnexpectedNumberElementsError("test", 1, -1));
        doTestInvalidInput(int32, types.getAggregateType(List.of()),
                getMismatchingValueTypeError("test"));
    }

    private String getUnexpectedNumberElementsError(String name, int expected, int received) {
        return "Unexpected number of elements in variable '" + name + "', expected " + expected + " but received " + received;
    }

    private String getMismatchingValueTypeError(String name) {
        return "Mismatching value type for variable '" + name + "', expected same-type elements but received elements of different types";
    }

    private void doTestInvalidInput(Type inner, Type outer, String error) {
        ScopedPointerType pointer = types.getScopedPointerType(Tag.Spirv.SC_GENERIC, inner);
        try {
            castInputType("test", pointer, outer);
            fail("Should throw exception");
        } catch (ParsingException e) {
            assertEquals(error, e.getMessage());
        }
    }
}
