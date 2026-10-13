package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.integers.IntCmpOp;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.annotations.LoopBound;
import com.dat3m.dartagnan.program.memory.Memory;
import org.junit.Test;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.util.List;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

public class ScalarEvolutionTest {

    private static final TypeFactory types = TypeFactory.getInstance();
    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();
    private static final IntegerType type = types.getIntegerType(32);

    // NOTE: A loop with N full iterations requires a bound of N+1 due to the final exit check.

    @Test
    public void countUp() throws InvalidConfigurationException {
        // for (i = 0; i < 5; i++)
        assertEquals(6, computeBound(value(0), 1, IntCmpOp.LT, value(5), 1, 0));
    }

    @Test
    public void countUpInclusiveWithLargeStep() throws InvalidConfigurationException {
        // for (i = 1; i <= 10; i += 4)
        assertEquals(4, computeBound(value(1), 1, IntCmpOp.LTE, value(10), 4, 0));
    }

    @Test
    public void countDown() throws InvalidConfigurationException {
        // for (i = 10; i > 0; i -= 3)
        assertEquals(5, computeBound(value(10), 1, IntCmpOp.GT, value(0), -3, 0));
    }

    @Test
    public void countDownUnsigned() throws InvalidConfigurationException {
        // for (unsigned i = 7; i >= 2; i--)
        assertEquals(7, computeBound(value(7), 1, IntCmpOp.UGTE, value(2), -1, 0));
    }

    @Test
    public void countToInequality() throws InvalidConfigurationException {
        // for (i = 2; i != 20; i += 2)
        assertEquals(10, computeBound(value(2), 1, IntCmpOp.NEQ, value(20), 2, 0));
    }

    @Test
    public void countWithScaledCounter() throws InvalidConfigurationException {
        // for (i = 1; 2*i + 1 <= 9; i++)
        assertEquals(5, computeBound(value(1), 2, IntCmpOp.LTE, value(9), 1, 1));
    }

    @Test
    public void largeBoundsAreCapped() throws InvalidConfigurationException {
        // for (i = 0; i < 19; i++)
        assertEquals(20, computeBound(value(0), 1, IntCmpOp.LT, value(19), 1, 0));
        // for (i = 0; i < 20; i++)
        assertEquals(20, computeBound(value(0), 1, IntCmpOp.LT, value(20), 1, 0));
        // for (i = 0; i < 1000; i++)
        assertEquals(20, computeBound(value(0), 1, IntCmpOp.LT, value(1000), 1, 0));
    }

    @Test
    public void neverEntered() throws InvalidConfigurationException {
        // for (i = 8; i < 5; i++)
        assertEquals(1, computeBound(value(8), 1, IntCmpOp.LT, value(5), 1, 0));
    }

    @Test
    public void noBoundIfCounterNeverReachesLimit() throws InvalidConfigurationException {
        // for (i = 1; i != 20; i += 2)
        assertEquals(-1, computeBound(value(1), 1, IntCmpOp.NEQ, value(20), 2, 0));
        // for (i = 0; i < 5; i--)
        assertEquals(-1, computeBound(value(0), 1, IntCmpOp.LT, value(5), -1, 0));
    }

    @Test
    public void noBoundIfCounterOverflows() throws InvalidConfigurationException {
        // for (i = 0; i <= MAX_INT; i++)
        assertEquals(-1, computeBound(value(0), 1, IntCmpOp.LTE, value(Integer.MAX_VALUE), 1, 0));
        // for (i = 0; i < MAX_INT; i += 2)
        assertEquals(-1, computeBound(value(0), 1, IntCmpOp.LT, value(Integer.MAX_VALUE), 2, 0));
    }

    @Test
    public void noAnnotationForSymbolicBounds() throws InvalidConfigurationException {
        // for (i = 0; i < n; i++)
        assertEquals(-1, computeBound(value(0), 1, IntCmpOp.LT, null, 1, 0));
        // for (i = n; i < 5; i++)
        assertEquals(-1, computeBound(null, 1, IntCmpOp.LT, value(5), 1, 0));
    }

    // ---------------------------------------------------------------------------------------

    private static Expression value(long value) {
        return expressions.makeValue(value, type);
    }

    /*
        Constructs the loop "for (i = init; (scale*i + offset) op limit; i += step) { }" of the shape

                i <- init
                n <- limit
            Loop:
                c <- ITE((scale*i + offset) op n, 1, 0)
                if (c != 0) goto Continue
                goto Exit
            Continue:
                tmp <- i + step
                i <- tmp
                goto Loop
            Exit:

        and returns the value of the loop bound annotation that gets generated, or -1 if there is none.
        The values <init> and <limit> are unknown if NULL is provided.
    */
    private int computeBound(Expression init, int scale, IntCmpOp op, Expression limit, int step, int offset)
            throws InvalidConfigurationException {
        final Program program = new Program(new Memory(), Program.SourceLanguage.LLVM);
        final Function f = new Function("f", types.getFunctionType(types.getVoidType(), List.of()), List.of(), 0, null);
        program.addFunction(f);
        final Register i = f.newRegister("i", type);
        final Register n = f.newRegister("n", type);
        final Register c = f.newRegister("c", type);
        final Register tmp = f.newRegister("tmp", type);
        final Label loop = EventFactory.newLabel("Loop");
        final Label cont = EventFactory.newLabel("Continue");
        final Label exit = EventFactory.newLabel("Exit");

        final Expression counter = expressions.makeAdd(expressions.makeMul(value(scale), i), value(offset));
        f.append(List.of(
                EventFactory.newLocal(i, init != null ? init : program.newConstant(type)),
                EventFactory.newLocal(n, limit != null ? limit : program.newConstant(type)),
                loop,
                EventFactory.newLocal(c, expressions.makeITE(expressions.makeIntCmp(counter, op, n), value(1), value(0))),
                EventFactory.newJump(expressions.makeNEQ(c, value(0)), cont),
                EventFactory.newGoto(exit),
                cont,
                EventFactory.newLocal(tmp, expressions.makeAdd(i, value(step))),
                EventFactory.newLocal(i, tmp),
                EventFactory.newGoto(loop),
                exit
        ));
        IdReassignment.newInstance().run(f);

        ScalarEvolution.fromConfig(Configuration.builder().build()).run(f);

        final List<LoopBound> annotations = f.getEvents(LoopBound.class);
        assertTrue(annotations.size() <= 1);
        if (annotations.isEmpty()) {
            return -1;
        }
        assertEquals(loop, annotations.get(0).getSuccessor());
        assertFalse(annotations.get(0).getConstantBound() <= 0);
        return annotations.get(0).getConstantBound();
    }
}
