package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Method;
import com.dat3m.dartagnan.configuration.Property;
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

import java.util.ArrayList;
import java.util.EnumSet;
import java.util.List;

import static com.dat3m.dartagnan.configuration.Property.CAT_SPEC;
import static com.dat3m.dartagnan.configuration.Property.PROGRAM_SPEC;
import static com.dat3m.dartagnan.task.verification.VerificationStatus.FAIL;
import static com.dat3m.dartagnan.task.verification.VerificationStatus.PASS;
import static org.junit.Assert.assertEquals;

// Acyclicity axioms must detect cycles of must-edges (e.g. self-loops).
@RunWith(Parameterized.class)
public class MustCycleAcyclicityTest {

    private final String model;
    private final Property property;
    private final VerificationStatus expected;
    private final Method method;

    public MustCycleAcyclicityTest(String model, Property property, VerificationStatus expected, Method method) {
        this.model = model;
        this.property = property;
        this.expected = expected;
        this.method = method;
    }

    @Parameterized.Parameters(name = "{index}: {0}, {1}, {3}")
    public static Iterable<Object[]> data() {
        final Object[][] cases = {
                { "flag ~acyclic [W]", CAT_SPEC, FAIL },
                { "flag ~acyclic (po | po^-1)", CAT_SPEC, FAIL },
                { "flag ~acyclic po", CAT_SPEC, PASS },
                { "~acyclic [W]", PROGRAM_SPEC, PASS },
                { "~acyclic (po | po^-1)", PROGRAM_SPEC, PASS },
                { "~acyclic po", PROGRAM_SPEC, FAIL },
                { "acyclic [W]", PROGRAM_SPEC, FAIL },
                { "acyclic po", PROGRAM_SPEC, PASS },
        };
        final List<Object[]> data = new ArrayList<>();
        for (Object[] c : cases) {
            for (Method method : new Method[]{ Method.EAGER, Method.LAZY }) {
                data.add(new Object[]{ c[0], c[1], c[2], method });
            }
        }
        return data;
    }

    @Test(timeout = 10000)
    public void test() throws Exception {
        final Program program = new ParserLitmus().parse(CharStreams.fromString("""
                AArch64 must-cycle
                { 0:X1=x; }
                P0;
                MOV W0,#1;
                STR W0,[X1];
                MOV W2,#2;
                STR W2,[X1];
                exists (x=2)
                """));
        final VerificationTask task = Task.builder()
                .withTarget(Arch.ARM8)
                .withSolver(SolverContextFactory.Solvers.Z3)
                .build(program, new ParserCat().parse(model), EnumSet.of(property));
        try (VerificationTaskSolver solver = VerificationTaskSolver.createWithMethod(task, method)) {
            solver.run();
            assertEquals(expected, solver.getResult().getStatus());
        }
    }
}
