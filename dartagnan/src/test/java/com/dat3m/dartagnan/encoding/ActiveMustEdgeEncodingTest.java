package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.frontend.cat.ParserCat;
import com.dat3m.dartagnan.frontend.litmus.ParserLitmus;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.task.Task;
import com.dat3m.dartagnan.task.verification.VerificationStatus;
import com.dat3m.dartagnan.test.AbstractVerificationTaskSolverTest;
import com.dat3m.dartagnan.wmm.Wmm;
import org.antlr.v4.runtime.CharStreams;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.sosy_lab.java_smt.SolverContextFactory;

import java.util.Arrays;
import java.util.EnumSet;

import static com.dat3m.dartagnan.configuration.OptionNames.INITIALIZE_REGISTERS;

/*
 * Must-edges that the extended relation analysis derives top-down, i.e., from the axioms, are not justified by the
 * must-edges of the operands. Such an edge is fixed to exec(x, y), but its definition must still be encoded if it
 * is active, since the definition is what forces the operands to (jointly) hold.
 *
 * In each model below, the axiom disables every edge of "([W] ; (loc & ext) ; [R]) \ X". As the minuend is a must
 * relation, the analysis derives that X must contain all these edges. X can be satisfied in multiple ways (P1 can read
 * from P0's write or from P2's write, if the latter is co-later), so nothing further can be propagated to X's
 * operands. If the definition of X is not encoded for its must-edges, the operands are unconstrained and the read is
 * allowed to observe the initial value.
 */
@RunWith(Parameterized.class)
public class ActiveMustEdgeEncodingTest extends AbstractVerificationTaskSolverTest {

    // The tested models require P1's read to observe P0's write or a co-later one,
    // so reading the initial value is forbidden.
    private static final String PROGRAM = """
            C active-must-edges
            {}
            P0(int *x)
            {
                WRITE_ONCE(*x, 1);
            }
            P1(int *x)
            {
                int r0;
                r0 = READ_ONCE(*x);
            }
            P2(int *x)
            {
                WRITE_ONCE(*x, 2);
            }
            exists (1:r0=0)
            """;

    private final String model;

    public ActiveMustEdgeEncodingTest(String name, String definition) {
        model = """
                "%s"
                let X = %s
                empty ([W] ; (loc & ext) ; [R]) \\ X
                """.formatted(name, definition);
    }

    @Parameterized.Parameters(name = "{index}: {0}")
    public static Iterable<Object[]> data() {
        return Arrays.asList(new Object[][]{
                { "union", "rf | (co ; rf)" },
                { "composition", "co? ; rf" },
                { "transitive closure", "(co | rf)+" },
                { "inverse", "((rf^-1) | (rf^-1 ; co^-1))^-1" },
                { "intersection", "(rf | (co ; rf)) & loc" },
                { "difference", "(rf | (co ; rf)) \\ po" },
                { "set identity", "[W] ; (rf | (co ; rf))" },
        });
    }

    @Override
    protected Task.TaskBuilder getTaskBuilder() {
        return super.getTaskBuilder()
                .withSolver(SolverContextFactory.Solvers.Z3)
                .withBound(1)
                .withTarget(Arch.LKMM)
                .withOption(INITIALIZE_REGISTERS, "true");
    }

    @Override
    protected long getTimeoutSeconds() { return 10; }

    @Override
    protected Program getProgram() { return new ParserLitmus().parse(CharStreams.fromString(PROGRAM)); }

    @Override
    protected Wmm getTargetWmm() { return new ParserCat().parse(model); }

    @Override
    protected EnumSet<Property> getTestedProperties() { return EnumSet.of(Property.PROGRAM_SPEC); }

    // The outcome "1:r0=0" is forbidden, so the "exists" clause is unreachable.
    @Override
    protected VerificationStatus getExpected() { return VerificationStatus.FAIL; }
}
