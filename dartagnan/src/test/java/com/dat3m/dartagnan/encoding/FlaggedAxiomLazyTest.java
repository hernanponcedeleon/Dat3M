package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Method;
import com.dat3m.dartagnan.frontend.cat.ParserCat;
import com.dat3m.dartagnan.frontend.litmus.ParserLitmus;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.task.Task;
import com.dat3m.dartagnan.task.verification.VerificationStatus;
import com.dat3m.dartagnan.task.verification.VerificationTask;
import com.dat3m.dartagnan.task.verification.VerificationTaskSolver;
import org.antlr.v4.runtime.CharStreams;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.sosy_lab.java_smt.SolverContextFactory;

import java.util.EnumSet;
import java.util.List;

import static com.dat3m.dartagnan.configuration.Property.CAT_SPEC;
import static com.dat3m.dartagnan.task.verification.VerificationStatus.FAIL;
import static com.dat3m.dartagnan.task.verification.VerificationStatus.PASS;
import static org.junit.Assert.assertEquals;

// Non-negated flagged axioms must constrain their relations also in lazy solving.
@RunWith(Parameterized.class)
public class FlaggedAxiomLazyTest {

    private static final String PROGRAM = """
            C flagged-lazy
            { x = 0; y = 0; }
            P0 (atomic_int* x) {
              atomic_store_explicit(x, 1, memory_order_relaxed);
            }
            P1 (atomic_int* x, atomic_int* y) {
              int r0 = atomic_load_explicit(x, memory_order_relaxed);
              %s
            }
            exists (1:r0=0)
            """;

    private final String thread1Tail;
    private final VerificationStatus expected;
    private final Method method;

    public FlaggedAxiomLazyTest(String thread1Tail, VerificationStatus expected, Method method) {
        this.thread1Tail = thread1Tail;
        this.expected = expected;
        this.method = method;
    }

    @Parameterized.Parameters(name = "{index}: {0}, {2}")
    public static Iterable<Object[]> data() {
        // "rf ; po" is non-empty iff the load is followed by another event.
        final String store = "atomic_store_explicit(y, 1, memory_order_relaxed);";
        return List.of(
                new Object[]{ store, PASS, Method.EAGER },
                new Object[]{ store, PASS, Method.LAZY },
                new Object[]{ "", FAIL, Method.EAGER },
                new Object[]{ "", FAIL, Method.LAZY }
        );
    }

    @Test(timeout = 10000)
    public void test() throws Exception {
        final Program program = new ParserLitmus().parse(CharStreams.fromString(PROGRAM.formatted(thread1Tail)));
        final VerificationTask task = Task.builder()
                .withTarget(Arch.C11)
                .withSolver(SolverContextFactory.Solvers.Z3)
                .build(program, new ParserCat().parse("flag empty (rf ; po)\n"), EnumSet.of(CAT_SPEC));
        try (VerificationTaskSolver solver = VerificationTaskSolver.createWithMethod(task, method)) {
            solver.run();
            assertEquals(expected, solver.getResult().getStatus());
        }
    }
}
