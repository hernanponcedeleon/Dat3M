package com.dat3m.dartagnan.expression.utils;

import org.junit.Test;

import java.math.BigInteger;

import static org.junit.Assert.assertEquals;

public class IntegerHelperTest {

    private static BigInteger big(long value) {
        return BigInteger.valueOf(value);
    }

    @Test
    public void shiftsWithinBitWidth() {
        assertEquals(big(8), IntegerHelper.lshift(big(1), big(3), 32));
        assertEquals(big(1L << 31), IntegerHelper.lshift(big(1), big(31), 32));
        assertEquals(big(1), IntegerHelper.rshift(big(8), big(3), 32));
        assertEquals(big(0x7FFFFFFF), IntegerHelper.rshift(big(-1), big(1), 32));
        assertEquals(big(-1), IntegerHelper.arshift(big(-1), big(31), 32));
    }

    // Shifting by at least the bit width is poison in LLVM, we follow the SMT-LIB semantics.
    @Test
    public void shiftsByAtLeastBitWidth() {
        // Shift amounts of 32, 0xFFFFFFFF (signed -1), and 2^31 (beyond int range when used as shift)
        for (BigInteger amount : new BigInteger[]{ big(32), big(-1), big(0xFFFFFFFFL), big(1L << 31) }) {
            assertEquals(big(0), IntegerHelper.lshift(big(1), amount, 32));
            assertEquals(big(0), IntegerHelper.rshift(big(-1), amount, 32));
            assertEquals(big(0), IntegerHelper.arshift(big(0x7FFFFFFF), amount, 32));
            assertEquals(big(-1), IntegerHelper.arshift(big(-1), amount, 32));
            assertEquals(big(-1), IntegerHelper.arshift(big(0x80000000L), amount, 32));
        }
    }
}
