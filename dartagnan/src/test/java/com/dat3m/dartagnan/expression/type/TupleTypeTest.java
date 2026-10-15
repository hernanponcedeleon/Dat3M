package com.dat3m.dartagnan.expression.type;

import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.processing.ExprSimplifier;
import org.junit.Test;

import java.util.List;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotEquals;
import static org.junit.Assert.assertSame;
import static org.junit.Assert.assertThrows;

public class TupleTypeTest {

    private static final TypeFactory types = TypeFactory.getInstance();
    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();

    @Test
    public void tuplesSupportValueOperationsWithoutMemoryLayout() {
        final var integer = types.getIntegerType(32);
        final var tuple = types.getTupleType(List.of(integer, types.getBooleanType()));
        final var one = expressions.makeValue(1, integer);
        final var value = expressions.makeConstruct(tuple, List.of(one, expressions.makeFalse()));
        final var simplified = new ExprSimplifier(true);
        assertSame(tuple, types.getTupleType(List.of(integer, types.getBooleanType())));
        assertEquals(one, expressions.makeExtract(value, 0).accept(simplified));
        final var updated = expressions.makeInsert(value, expressions.makeTrue(), 1);
        assertEquals(tuple, updated.getType());
        assertEquals(types.getBooleanType(), expressions.makeExtract(updated, 1).getType());
        assertEquals(expressions.makeTrue(), expressions.makeEQ(value, value).accept(simplified));
        assertEquals(expressions.makeFalse(), expressions.makeNEQ(value, value).accept(simplified));
        assertEquals(expressions.makeZero(integer),
                expressions.makeExtract(expressions.makeGeneralZero(tuple), 0).accept(simplified));
        assertNotEquals(tuple, types.getAggregateType(List.of(integer, types.getBooleanType()), List.of(0, 4), 4, 8));
        assertThrows(IllegalArgumentException.class, () -> types.getArrayType(tuple, 1));
        assertThrows(IllegalArgumentException.class,
                () -> types.getAggregateType(List.of(tuple), List.of(0), 1, -1));
        assertThrows(UnsupportedOperationException.class, () -> types.getMemorySizeInBytes(tuple));
        assertThrows(UnsupportedOperationException.class, () -> types.getOffsetInBytes(tuple, 0));
        assertThrows(UnsupportedOperationException.class, () -> types.getOffsetInBytes(tuple, 1));
    }
}
