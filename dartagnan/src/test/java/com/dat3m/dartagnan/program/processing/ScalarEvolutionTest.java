package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.integers.IntCmpOp;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.annotations.LoopBound;
import com.dat3m.dartagnan.program.memory.Memory;
import org.junit.Test;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.util.List;

import static com.dat3m.dartagnan.configuration.OptionNames.BOUND_CAP;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;

public class ScalarEvolutionTest {

    private static final TypeFactory types = TypeFactory.getInstance();
    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();
    private static final IntegerType type = types.getIntegerType(32);

    // The bound cap used by all tests that do not explicitly specify one.
    private static final int BOUND_CAP_VALUE = 20;

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
    public void onlyCappedBoundsAreSoft() throws InvalidConfigurationException {
        final Configuration config = newConfig(BOUND_CAP_VALUE);
        // for (i = 0; i < 19; i++)
        assertFalse(annotateLoop(config, value(0), 1, IntCmpOp.LT, value(19), 1, 0).isSoft());
        // for (i = 0; i < 20; i++)
        assertTrue(annotateLoop(config, value(0), 1, IntCmpOp.LT, value(20), 1, 0).isSoft());
    }

    @Test
    public void capIsConfigurable() throws InvalidConfigurationException {
        final Configuration config = newConfig(5);
        // for (i = 0; i < 3; i++)
        final LoopBound exact = annotateLoop(config, value(0), 1, IntCmpOp.LT, value(3), 1, 0);
        assertEquals(4, exact.getConstantBound());
        assertFalse(exact.isSoft());
        // for (i = 0; i < 10; i++)
        final LoopBound capped = annotateLoop(config, value(0), 1, IntCmpOp.LT, value(10), 1, 0);
        assertEquals(5, capped.getConstantBound());
        assertTrue(capped.isSoft());
    }

    @Test
    public void capCanBeDisabled() throws InvalidConfigurationException {
        final Configuration config = newConfig(0);
        // for (i = 0; i < 1000; i++)
        final LoopBound bound = annotateLoop(config, value(0), 1, IntCmpOp.LT, value(1000), 1, 0);
        assertEquals(1001, bound.getConstantBound());
        assertFalse(bound.isSoft());
        // for (i = 0; i != -1; i++) has a bound that is too large to be annotated.
        assertNull(annotateLoop(config, value(0), 1, IntCmpOp.NEQ, value(-1), 1, 0));
    }

    @Test
    public void uncappedBoundsAreNotOverwrittenByGlobalBounds() throws InvalidConfigurationException {
        // for (i = 0; i < 30; i++) has the hard bound 31 if there is no bound cap.
        assertEquals(31, unrollLoop(value(30), 0, 10));
        assertEquals(31, unrollLoop(value(30), 0, 50));
    }

    @Test
    public void softBoundsAreOverwrittenByLargerGlobalBounds() throws InvalidConfigurationException {
        // for (i = 0; i < 1000; i++) has the soft bound 20 if that is the bound cap.
        assertEquals(20, unrollLoop(value(1000), 20, 10));
        assertEquals(20, unrollLoop(value(1000), 20, 20));
        assertEquals(30, unrollLoop(value(1000), 20, 30));
    }

    @Test
    public void hardBoundsAreNotOverwrittenByGlobalBounds() throws InvalidConfigurationException {
        // for (i = 0; i < 5; i++) has the hard bound 6.
        assertEquals(6, unrollLoop(value(5), 20, 1));
        assertEquals(6, unrollLoop(value(5), 20, 30));
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

    private static Configuration newConfig(int boundCap) throws InvalidConfigurationException {
        return Configuration.builder().setOption(BOUND_CAP, Integer.toString(boundCap)).build();
    }

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

        and returns the loop bound annotation that gets generated, or NULL if there is none.
        The values <init> and <limit> are unknown if NULL is provided.
    */
    private LoopBound annotateLoop(Configuration config, Expression init, int scale, IntCmpOp op, Expression limit,
                                   int step, int offset) throws InvalidConfigurationException {
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

        ScalarEvolution.fromConfig(config).run(f);

        final List<LoopBound> annotations = f.getEvents(LoopBound.class);
        assertTrue(annotations.size() <= 1);
        if (annotations.isEmpty()) {
            return null;
        }
        assertEquals(loop, annotations.get(0).getSuccessor());
        assertFalse(annotations.get(0).getConstantBound() <= 0);
        return annotations.get(0);
    }

    // Returns the value of the generated loop bound annotation (using the fixed bound cap), or -1 if there is none.
    private int computeBound(Expression init, int scale, IntCmpOp op, Expression limit, int step, int offset)
            throws InvalidConfigurationException {
        final LoopBound annotation = annotateLoop(newConfig(BOUND_CAP_VALUE), init, scale, op, limit, step, offset);
        return annotation != null ? annotation.getConstantBound() : -1;
    }

    // Annotates and unrolls the loop "for (i = 0; i < limit; i++) { }" using the provided bound cap and global bound.
    // Returns the number of times the loop got unrolled.
    private int unrollLoop(Expression limit, int boundCap, int globalBound) throws InvalidConfigurationException {
        final LoopBound annotation = annotateLoop(newConfig(boundCap), value(0), 1, IntCmpOp.LT, limit, 1, 0);
        final Function f = annotation.getFunction();
        final LoopUnrolling unrolling = LoopUnrolling.newInstance();
        unrolling.setUnrollingBound(globalBound);
        unrolling.run(f.getProgram());

        final List<Event> boundEvents = f.getEvents().stream().filter(e -> e.hasTag(Tag.BOUND)).toList();
        assertEquals(1, boundEvents.size());
        return boundEvents.get(0).getMetadata(Event.UnrollingBound.class).value();
    }
}
