package com.dat3m.dartagnan.exploration;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.test.ResourceHelper;
import com.dat3m.dartagnan.test.TestHelper;
import com.dat3m.dartagnan.task.exploration.ExplorationResult;
import com.dat3m.dartagnan.task.exploration.ExplorationTask;
import com.dat3m.dartagnan.task.exploration.ExplorationTaskSolver;
import com.dat3m.dartagnan.task.verification.VerificationStatus;
import com.dat3m.dartagnan.task.Task;
import com.dat3m.dartagnan.task.exploration.ExplorationOrder;
import com.dat3m.dartagnan.wmm.Wmm;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.util.Arrays;
import java.util.EnumSet;

import static com.dat3m.dartagnan.configuration.OptionNames.*;
import static com.dat3m.dartagnan.task.verification.VerificationStatus.*;
import static com.dat3m.dartagnan.task.exploration.ExplorationOrder.DEPENDENCIES;
import static com.dat3m.dartagnan.task.exploration.ExplorationOrder.PO;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

/*
    Tests for exploration (stateless model checking) on C programs with loops.
    Loops are NOT unrolled: spin loops are handled by blocking side-effect-free iterations,
    infinite executions are cut off by a bound on the events per thread (if given).
 */
@RunWith(Parameterized.class)
public class ExplorationTest {

    private final String program;
    private final String cat;
    private final Arch target;
    private final ExplorationOrder order;
    private final int maxEvents;
    private final VerificationStatus expected;

    public ExplorationTest(String program, String cat, Arch target, ExplorationOrder order, int maxEvents,
                           VerificationStatus expected) {
        this.program = program;
        this.cat = cat;
        this.target = target;
        this.order = order;
        this.maxEvents = maxEvents;
        this.expected = expected;
    }

    @Parameterized.Parameters(name = "{index}: {0}, {1}, {3}, maxEvents={4}")
    public static Iterable<Object[]> data() {
        return Arrays.asList(new Object[][]{
                // Message passing with a spin loop
                {"exploration/spin", "rc11", Arch.C11, PO, 0, PASS},
                {"exploration/spin", "rc11", Arch.C11, DEPENDENCIES, 0, PASS},
                // Infinite loop: violations are found within the bound, otherwise the result is inconclusive.
                {"exploration/infinite", "rc11", Arch.C11, PO, 20, FAIL},
                {"exploration/infinite_safe", "rc11", Arch.C11, PO, 20, UNKNOWN},
                {"exploration/infinite_safe", "rc11", Arch.C11, DEPENDENCIES, 20, UNKNOWN},
                // Load buffering: requires a (po U rf)-cycle, so only the dependency order finds it.
                {"exploration/lb_loop", "rc11", Arch.C11, PO, 0, PASS},
                {"exploration/lb_loop", "rc11", Arch.C11, DEPENDENCIES, 0, PASS},
                {"exploration/lb_loop", "c11", Arch.C11, PO, 0, PASS},
                {"exploration/lb_loop", "c11", Arch.C11, DEPENDENCIES, 0, FAIL},
                {"exploration/lb_loop", "aarch64", Arch.ARM8, PO, 0, PASS},
                {"exploration/lb_loop", "aarch64", Arch.ARM8, DEPENDENCIES, 0, FAIL},
                // Locks (with spin loops). Bounded model checking reports UNKNOWN for ttas (bound 1).
                {"locks/spinlock", "rc11", Arch.C11, PO, 0, PASS},
                {"locks/spinlock-acq2rx", "rc11", Arch.C11, PO, 0, FAIL},
                {"locks/spinlock-rel2rx", "rc11", Arch.C11, PO, 0, FAIL},
                {"locks/ttas", "rc11", Arch.C11, PO, 0, PASS},
                {"locks/ttas-acq2rx", "rc11", Arch.C11, PO, 0, FAIL},
                {"locks/ticketlock", "rc11", Arch.C11, PO, 0, PASS},
                {"locks/ticketlock-acq2rx", "rc11", Arch.C11, PO, 0, FAIL},
                {"locks/ticketlock", "aarch64", Arch.ARM8, DEPENDENCIES, 0, PASS},
                {"locks/spinlock", "aarch64", Arch.ARM8, DEPENDENCIES, 0, PASS},
        });
    }

    private ExplorationTask getTask(int bound, int timeout) throws Exception {
        final Program p = TestHelper.parseProgram(ResourceHelper.getTestResourcePath(program + ".ll"));
        final Wmm wmm = TestHelper.parseWmm(ResourceHelper.getCatPathFromName(cat));
        final Task.TaskBuilder builder = Task.builder()
                .withTarget(target)
                .withOption(EXPLORATION_ORDER, order.name())
                .withOption(EXPLORATION_MAX_EVENTS, String.valueOf(bound));
        if (timeout > 0) {
            builder.withSolverTimeout(timeout);
        }
        return builder.buildExplorationTask(p, wmm, EnumSet.of(Property.PROGRAM_SPEC));
    }

    @Test(timeout = 120_000)
    public void test() throws Exception {
        try (ExplorationTaskSolver solver = ExplorationTaskSolver.create(getTask(maxEvents, 0))) {
            solver.run();
            final ExplorationResult result = solver.getResult();
            assertEquals(expected, result.getStatus());
            if (maxEvents == 0) {
                assertTrue(result.isExhaustive());
            }
            if (expected == UNKNOWN) {
                assertFalse(result.isExhaustive());
            }
        }
    }

    // Without a bound, the exploration of a program with infinite executions does not terminate.
    @Test(timeout = 60_000)
    public void testUnboundedDoesNotTerminate() throws Exception {
        if (!program.equals("exploration/infinite_safe")) {
            return;
        }
        try (ExplorationTaskSolver solver = ExplorationTaskSolver.create(getTask(0, 3))) {
            solver.run();
            throw new AssertionError("Exploration of an infinite program terminated.");
        } catch (InterruptedException e) {
            assertTrue(e.getMessage() == null || e.getMessage().contains("Timeout"));
        }
    }
}
