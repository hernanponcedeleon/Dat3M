package com.dat3m.dartagnan.others.miscellaneous;
import com.dat3m.dartagnan.expression.integers.IntBinaryOp;
import com.dat3m.dartagnan.program.analysis.interval.Interval;
import com.dat3m.dartagnan.expression.type.IntegerType;


import com.dat3m.dartagnan.expression.type.TypeFactory;
import java.math.BigInteger;
import java.util.Arrays;


import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import static com.dat3m.dartagnan.expression.integers.IntBinaryOp.*;
import static org.junit.Assert.*;
@RunWith(Parameterized.class)
public class IntervalTest {


    private final Interval operand1;
    private final Interval operand2;
    private final Interval expected;
    private final IntBinaryOp op;

    public IntervalTest(
        int lb1,
        int ub1,
        int lb2,
        int ub2,
        int expectedLb,
        int expectedUb,
        IntBinaryOp op) {
        this.operand1 = makeInterval(lb1,ub1);
        this.operand2 = makeInterval(lb2,ub2);
        this.expected = makeInterval(expectedLb,expectedUb);
        this.op = op;
    }

    private static final TypeFactory types = TypeFactory.getInstance();
    private static final IntegerType byteType = types.getIntegerType(8);

    private static Interval makeInterval(int a, int b) {
        return new Interval(new BigInteger(String.valueOf(a)),new BigInteger(String.valueOf(b)),byteType);
    }


    @Parameterized.Parameters(name= "{index}: {0}, {1}, {2}, {3}, {4}, {5}, {6}")
    public static Iterable<Object[]> data() {
        return Arrays.asList(new Object[][] {
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

        //Division
        {1, 5, 2, 6, 0, 3, DIV}, 
        {-128, -128, -1, -1, 128, 128, DIV}, 
        //Division by zero
        {1, 5, -1, 1, -128, 255, DIV}, 

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
        Interval result = operand1.applyOperator(op,operand2);
        assertEquals(expected,result);
    }



}

