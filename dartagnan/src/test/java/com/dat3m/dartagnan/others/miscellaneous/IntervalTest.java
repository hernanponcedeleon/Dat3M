package com.dat3m.dartagnan.others.miscellaneous;

import com.dat3m.dartagnan.expression.integers.IntBinaryOp;
import com.dat3m.dartagnan.expression.integers.IntUnaryOp;
import com.dat3m.dartagnan.program.analysis.interval.Interval;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import java.math.BigInteger;
import java.util.Arrays;


import org.junit.Test;
import org.junit.experimental.runners.Enclosed;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import static com.dat3m.dartagnan.expression.integers.IntBinaryOp.*;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertThrows;

@RunWith(Enclosed.class)
public abstract class IntervalTest {

    static TypeFactory types = TypeFactory.getInstance();
    static IntegerType byteType = types.getIntegerType(8);

    public static class IntervalInitialisationOrderingTest {
        @Test
        public void boundOrder() {
            assertThrows(IllegalArgumentException.class, () -> new Interval(BigInteger.ONE,BigInteger.ZERO,byteType));

        }
    }

    @RunWith(Parameterized.class)
    public static class IntervalInitialisationTest {
        Interval result;
        Interval expected;
        public IntervalInitialisationTest(int lb,
                                          int ub,
                                          int expectedLb,
                                          int expectedUb) {

            this.result = new Interval(BigInteger.valueOf(lb), BigInteger.valueOf(ub), byteType);
            this.expected = new Interval(BigInteger.valueOf(expectedLb), BigInteger.valueOf(expectedUb), byteType);
        }



        @Parameterized.Parameters(name = "{index}: {0}, {1}, {2}, {3}")
        public static Iterable<Object[]> data() {
            return Arrays.asList(new Object[][]{
                    // Simple success cases
                    {1, 5, 1, 5},
                    {-2, 2, -2, 2},
                    // Lowerbound does not fit in bitwidth
                    {-129, 0, -128, 255},
                    // Upperbound does not fit in bitwidth
                    {0, 256, -128, 255},
                    // Does not have a signed or unsigned interpretation
                    {-1, 128, -128, 255},
            });
        }

        @Test
        public void test() {
            assertEquals(result, expected);
        }
    }


    @RunWith(Parameterized.class)
    public static class IntervalUnaryOperationsTest {
        private final Interval operand;
        private final IntUnaryOp operator;
        private final Interval expected;

        public IntervalUnaryOperationsTest(
                int lb,
                int ub,
                int expectedLb,
                int expectedUb,
                IntUnaryOp operator) {
            operand = new Interval(BigInteger.valueOf(lb), BigInteger.valueOf(ub), byteType);
            expected = new Interval(BigInteger.valueOf(expectedLb),BigInteger.valueOf(expectedUb), byteType);
            this.operator = operator;
        }

        @Parameterized.Parameters(name = "{index}: {0}, {1}, {2}, {3}, {4}")
        public static Iterable<Object[]> data() {
            return Arrays.asList(new Object[][]{
                    {-5,-2,2,5, IntUnaryOp.MINUS},
                    {2,5,-5,-2, IntUnaryOp.MINUS},
                    {-5,2,-2,5, IntUnaryOp.MINUS},
                    {127,129,-128,255,IntUnaryOp.MINUS},
            });
        }

         @Test
        public void test() {
            Interval result = operand.applyOperator(operator);
            assertEquals(result, expected);
         }

    }


    @RunWith(Parameterized.class)
    public static class IntervalBinaryOperationsTest {


        private final Interval operand1;
        private final Interval operand2;
        private final Interval expected;
        private final IntBinaryOp op;

        public IntervalBinaryOperationsTest(
                int lb1,
                int ub1,
                int lb2,
                int ub2,
                int expectedLb,
                int expectedUb,
                IntBinaryOp op) {
            this.operand1 = new Interval(BigInteger.valueOf(lb1), BigInteger.valueOf(ub1), byteType);
            this.operand2 = new Interval(BigInteger.valueOf(lb2), BigInteger.valueOf(ub2), byteType);
            this.expected = new Interval(BigInteger.valueOf(expectedLb), BigInteger.valueOf(expectedUb), byteType);
            this.op = op;
        }

        @Parameterized.Parameters(name = "{index}: {0}, {1}, {2}, {3}, {4}, {5}, {6}")
        public static Iterable<Object[]> data() {
            return Arrays.asList(new Object[][]{
                    // Addition
                    {1, 5, 2, 6, 3, 11, ADD},

                    //Subtraction
                    {1, 5, 2, 6, -5, 3, SUB},

                    //Multiplication
                    {1, 5, 2, 6, 2, 30, MUL},
                    {-1, 5, 2, 6, -6, 30, MUL},
                    {-5, -1, 2, 6, -30, -2, MUL},
                    {1, 5, -6, -2, -30, -2, MUL},
                    {-1, 5, -6, -2, -30, 6, MUL},
                    {-5, -1, -6, -2, 2, 30, MUL},
                    {1, 5, -2, 6, -10, 30, MUL},
                    {-1, 5, -2, 6, -10, 30, MUL},
                    {-5, -1, -2, 6, -30, 10, MUL},

                    // Signed division
                    {1, 5, 2, 6, 0, 3, DIV},
                    // Signed division Asymmetry edge case
                    {-128, -128, -1, -1, -128, 255, DIV},
                    // Signed division by zero
                    {1, 5, -1, 1, -128, 255, DIV},

                    // Unsigned Division
                    {-1, -1, 1, 1, 255, 255, UDIV},


                    //Overflow addition
                    {-128, 127, 1, 1, -128, 255, ADD},

                    //Overflow subtraction
                    {-128, 127, 1, 1, -128, 255, SUB},

                    //Overflow Multiplication
                    {-128, 127, 2, 2, -128, 255, MUL},

                    //OR Cases
                    {2, 4, 9, 20, 10, 23, OR},
                    {-4, -2, -20, -9, -4, -1, OR},
                    {-4, -2, 9, 20, -4, -1, OR},
                    {2, 4, -20, -9, -20, -9, OR},
                    {-4, -2, -20, 9, -4, -1, OR},
                    {-4, 2, -20, 9, -20, 11, OR},
                    {-4, 2, 9, 20, -4, 22, OR},
                    {2, 4, -9, 20, -9, 23, OR},

                    //AND
                    {2, 4, 9, 20, 0, 4, AND},
                    {-4, -2, 9, 20, 8, 20, AND},
                    {-4, -2, -9, 20, -12, 20, AND},
                    {-4, -2, -9, 20, -12, 20, AND},
                    {-4, 2, -20, -9, -20, 2, AND},
                    {-4, 2, -20, 9, -20, 9, AND},
                    {-4, 2, 9, 20, 0, 20, AND},
                    {2, 4, -9, 20, 0, 4, AND},
            });
        }

        @Test
        public void test() {
            Interval result = operand1.applyOperator(op, operand2);
            assertEquals(expected, result);
        }
    }

}


