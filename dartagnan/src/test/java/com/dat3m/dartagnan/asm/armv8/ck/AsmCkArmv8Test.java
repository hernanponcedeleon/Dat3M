package com.dat3m.dartagnan.asm.armv8.ck;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Method;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.TestHelper;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Wmm;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.sosy_lab.java_smt.SolverContextFactory;

import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import java.util.EnumSet;

import static com.dat3m.dartagnan.configuration.Property.PROGRAM_SPEC;
import static com.dat3m.dartagnan.configuration.Property.TERMINATION;
import static com.dat3m.dartagnan.utils.ResourceHelper.getRootPath;
import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;
import static org.junit.Assert.assertEquals;

@RunWith(Parameterized.class)
public class AsmCkArmv8Test {

    private final String modelPath = getRootPath("cat/aarch64.cat");
    private final String programPath;
    private final int bound;
    private final Result expected;

    public AsmCkArmv8Test (String file, int bound, Result expected) {
        this.programPath = getTestResourcePath("asm/armv8/ck/" + file + ".ll");
        this.bound = bound;
        this.expected = expected;
    }

    @Parameterized.Parameters(name = "{index}: {0}, {1}, {2}")
    public static Iterable<Object[]> data() throws IOException {
        return Arrays.asList(new Object[][]{
            {"anderson", 3, Result.PASS},
            {"caslock", 3, Result.PASS},
            {"clhlock", 1, Result.PASS},
            {"declock", 3, Result.PASS},
            //{"ebr", 5, Result.PASS},
            {"faslock", 3, Result.PASS},
            {"mcslock", 2, Result.PASS},
            {"ticketlock", 1, Result.PASS},
            {"spsc_queue", 1, Result.PASS},
            {"stack_empty", 2, Result.UNKNOWN},
            {"ebr", 5, Result.PASS}
        });
    }

    @Test
    public void testAllSolvers() throws Exception {
        // TODO : RefinementSolver takes too long to run, we have to investigate this
        // assertEquals(expected, TestHelper.createAndRunModelChecker(mkTask(), Method.LAZY));
        assertEquals(expected, TestHelper.createAndRunModelChecker(mkTask(), Method.EAGER));
    }


    private VerificationTask mkTask() throws Exception {
        VerificationTask.VerificationTaskBuilder builder = VerificationTask.builder()
                .withSolver(SolverContextFactory.Solvers.YICES2)
                .withBound(bound)
                .withTarget(Arch.ARM8);
        Program program = new ProgramParser().parse(new File(programPath));
        Wmm mcm = new ParserCat().parse(new File(modelPath));
        return builder.build(program, mcm, EnumSet.of(TERMINATION, PROGRAM_SPEC));
    }
}
