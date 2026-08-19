package com.dat3m.dartagnan.asm;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Method;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.ResourceHelper;
import com.dat3m.dartagnan.utils.TestHelper;
import com.dat3m.dartagnan.verification.ResultStatus;
import com.dat3m.dartagnan.verification.Task;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Wmm;
import org.junit.Test;
import org.sosy_lab.java_smt.SolverContextFactory;

import java.nio.file.Path;
import java.util.EnumSet;

import static com.dat3m.dartagnan.configuration.Property.PROGRAM_SPEC;
import static com.dat3m.dartagnan.configuration.Property.TERMINATION;
import static org.junit.Assert.assertEquals;

public abstract class AbstractAsmTest {

    private final Path modelPath;
    private final Arch target;
    private final Path programPath;
    private final int bound;
    private final ResultStatus expected;

    protected AbstractAsmTest(Arch target, String programPath, int bound, ResultStatus expected) {
        this.modelPath = ResourceHelper.getCatPath(target, null);
        this.target = target;
        this.programPath = ResourceHelper.getTestResourcePath(programPath + ".ll");
        this.bound = bound;
        this.expected = expected;
    }

    @Test
    public void eager() throws Exception {
        //TODO skip EAGER for ARM7 and POWER
        assertEquals(expected, TestHelper.createAndRunSolver(mkTask(), Method.EAGER));
    }

    @Test
    public void lazy() throws Exception {
        //TODO RefinementSolver takes too long to run for ARM8, we have to investigate this
        assertEquals(expected, TestHelper.createAndRunSolver(mkTask(), Method.LAZY));
    }

    protected String getTargetWmmName() { return null; }

    private VerificationTask mkTask() throws Exception {
        final Task.TaskBuilder builder = VerificationTask.builder()
                .withSolver(SolverContextFactory.Solvers.YICES2)
                .withBound(bound)
                .withTarget(target);
        final Program program = new ProgramParser().parse(programPath);
        final Wmm mcm = new ParserCat().parse(modelPath);
        return builder.build(program, mcm, EnumSet.of(TERMINATION, PROGRAM_SPEC));
    }
}
