package com.dat3m.dartagnan.others.expression.type;

import com.dat3m.dartagnan.expression.Type;
import org.junit.Test;

import java.util.List;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;

public class AggregateTypeTest {

    private static final TypeFactory types = TypeFactory.getInstance();

    @Test
    public void testDefaultOffsets() {
        Type i8 = types.getIntegerType(8);
        Type i16 = types.getIntegerType(16);
        Type i32 = types.getIntegerType(32);
        Type i64 = types.getIntegerType(64);

        testStandardOffsets(List.of(i8, i8, i8, i32), List.of(0, 1, 2, 4), 8);
        testStandardOffsets(List.of(i32, i8, i8, i8), List.of(0, 4, 5, 6), 8);
        testStandardOffsets(List.of(i8, i16, i32), List.of(0, 2, 4), 8);
        testStandardOffsets(List.of(i32, i16, i8), List.of(0, 4, 6), 8);
        testStandardOffsets(List.of(i8, i64), List.of(0, 8), 16);
        testStandardOffsets(List.of(i64, i8), List.of(0, 8), 16);

        Type arr1 = types.getArrayType(i16, 3);
        Type arr2 = types.getArrayType(i16);

        testStandardOffsets(List.of(arr1), List.of(0), 6);
        testStandardOffsets(List.of(i16, arr1), List.of(0, 2), 8);
        testStandardOffsets(List.of(arr1, i16), List.of(0, 6), 8);
        testStandardOffsets(List.of(arr2), List.of(0), -1);
        testStandardOffsets(List.of(i16, arr2), List.of(0, 2), -1);

        Type s1 = types.getAggregateType(List.of(i32, i8));

        testStandardOffsets(List.of(s1, i16), List.of(0, 8), 12);
    }

    @Test
    public void testExplicitOffsets() {
        Type i8 = types.getIntegerType(8);

        testExplicitOffsets(List.of(i8, i8, i8), List.of(0, 1, 2), 3);
        testExplicitOffsets(List.of(i8, i8, i8), List.of(0, 3, 5), 6);
        testExplicitOffsets(List.of(i8, i8, i8), List.of(0, 1, 7), 8);
        testExplicitOffsets(List.of(i8, i8, i8), List.of(0, 7, 13), 14);

        Type i16 = types.getIntegerType(16);
        Type i32 = types.getIntegerType(32);
        Type i64 = types.getIntegerType(64);

        testExplicitOffsets(List.of(i8, i8, i8, i32), List.of(0, 4, 8, 12), 16);
        testExplicitOffsets(List.of(i8, i8, i8, i32), List.of(0, 4, 8, 12), 16);
        testExplicitOffsets(List.of(i8, i64), List.of(0, 1), 16);
        testExplicitOffsets(List.of(i64, i8), List.of(0, 15), 16);

        Type arr1 = types.getArrayType(i16, 3);
        Type arr2 = types.getArrayType(i16);

        testExplicitOffsets(List.of(i16, arr1), List.of(0, 8), 14);
        testExplicitOffsets(List.of(arr1, i16), List.of(0, 8), 10);
        testExplicitOffsets(List.of(i16, arr2), List.of(0, 8), -1);

        Type s1 = types.getAggregateType(List.of(i32, i8));

        testExplicitOffsets(List.of(s1, i16), List.of(0, 5), 8);
        testExplicitOffsets(List.of(s1, i16), List.of(0, 6), 8);
        testExplicitOffsets(List.of(s1, i16), List.of(0, 8), 12);
    }

    @Test
    public void testIllegalOffsets() {
        Type i32 = types.getIntegerType(32);
        Type arr = types.getArrayType(i32);

        testIllegalOffsets(List.of(i32, i32), List.of(0, 2), "Offset is too small");
        testIllegalOffsets(List.of(i32, i32), List.of(4, 8), "The first offset must be zero");
        testIllegalOffsets(List.of(i32, i32), List.of(0, -1), "Offset cannot be negative");
        testIllegalOffsets(List.of(i32, i32), List.of(0), "Offsets number does not match the fields number");
        testIllegalOffsets(List.of(i32, i32), List.of(0, 4, 8), "Offsets number does not match the fields number");
        testIllegalOffsets(List.of(arr, i32), List.of(0, 8), "Non-last element with unknown size");
    }

    @Test
    public void testEmptyType() {
        Type empty = types.getAggregateType(List.of());
        Type emptyAlt = types.getAggregateType(List.of(), List.of());

        assertEquals(empty, emptyAlt);

        Type i32 = types.getIntegerType(32);
        List<Type> structMembers = List.of(empty, i32, empty, empty, i32, empty);

        testDefaultOffsets(structMembers, List.of(0, 0, 4, 4, 4, 8), 8);
        testExplicitOffsets(structMembers, List.of(0, 0, 4, 5, 8, 13), 16);
    }

    private void testStandardOffsets(List<Type> fields, List<Integer> offsets, int size) {
        testDefaultOffsets(fields, offsets, size);
        testExplicitOffsets(fields, offsets, size);
    }

    private void testDefaultOffsets(List<Type> fields, List<Integer> offsets, int size) {
        AggregateType type = types.getAggregateType(fields);
        assertEquals(fields, type.getTypeOffsets().stream().map(TypeOffset::type).toList());
        assertEquals(offsets, type.getTypeOffsets().stream().map(TypeOffset::offset).toList());
        assertEquals(size, types.getMemorySizeInBytes(type));
    }

    private void testExplicitOffsets(List<Type> fields, List<Integer> offsets, int size) {
        AggregateType type = types.getAggregateType(fields, offsets);
        assertEquals(fields, type.getTypeOffsets().stream().map(TypeOffset::type).toList());
        assertEquals(offsets, type.getTypeOffsets().stream().map(TypeOffset::offset).toList());
        assertEquals(size, types.getMemorySizeInBytes(type));
    }

    private void testIllegalOffsets(List<Type> fields, List<Integer> offsets, String error) {
        try {
            types.getAggregateType(fields, offsets);
            fail("Should throw exception");
        } catch (IllegalArgumentException e) {
            assertEquals(error, e.getMessage());
        }
    }
}
