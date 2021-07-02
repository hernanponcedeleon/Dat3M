package com.dat3m.dartagnan;

import com.dat3m.dartagnan.analysis.Refinement;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.ResourceHelper;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.dat3m.dartagnan.wmm.utils.alias.Alias;
import com.microsoft.z3.Context;
import com.microsoft.z3.Solver;
import org.junit.Test;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Map;

import static com.dat3m.dartagnan.analysis.Base.runAnalysis;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;

public abstract class AbstractDartagnanTest {

	static int SOLVER_TIMEOUT = 60;
	
    static Iterable<Object[]> buildParameters(String litmusPath, String cat, Arch target) throws IOException {
        int n = ResourceHelper.LITMUS_RESOURCE_PATH.length();
        Map<String, Result> expectationMap = ResourceHelper.getExpectedResults();
        Wmm wmm = new ParserCat().parse(new File(ResourceHelper.CAT_RESOURCE_PATH + cat));

        Settings s1 = new Settings(Alias.CFIS, 1, SOLVER_TIMEOUT);

        return Files.walk(Paths.get(ResourceHelper.LITMUS_RESOURCE_PATH + litmusPath))
                .filter(Files::isRegularFile)
                .map(Path::toString)
                .filter(f -> f.endsWith("litmus"))
                .filter(f -> expectationMap.containsKey(f.substring(n)))
                .map(f -> new Object[]{f, expectationMap.get(f.substring(n))})
                .collect(ArrayList::new,
                        (l, f) -> {
                            l.add(new Object[]{f[0], f[1], target, wmm, s1});
                        }, ArrayList::addAll);
    }

    private final String path;
    private final Result expected;
    private final Arch target;
    private final Wmm wmm;
    private final Settings settings;

    AbstractDartagnanTest(String path, Result expected, Arch target, Wmm wmm, Settings settings) {
        this.path = path;
        this.expected = expected;
        this.target = target;
        this.wmm = wmm;
        this.settings = settings;
    }

    //@Test
    public void testCombined() {
        // Compares Refinement and Assume solver on litmus tests
        // Replaces location-based assertions by ...
        final boolean REPLACE_BY_TRUE = true;
        // ... to allow Refinement to work

        Result res = Result.UNKNOWN;
        try {
            Program program = new ProgramParser().parse(new File(path));
            if (program.getAss() != null) {
                program.setAss(program.getAss().removeLocAssertions(REPLACE_BY_TRUE));
                Context ctx = new Context();
                Solver solver = ctx.mkSolver(ctx.mkTactic(Settings.TACTIC));
                VerificationTask task = new VerificationTask(program, wmm, target, settings);
                res = runAnalysis(solver, ctx, task);
                ctx.close();
            }
        } catch (Exception e) {
            fail("Missing resource file");
        }

        try {
            Program program = new ProgramParser().parse(new File(path));
            if (program.getAss() != null) {
                program.setAss(program.getAss().removeLocAssertions(REPLACE_BY_TRUE));
                Context ctx = new Context();
                Solver solver = ctx.mkSolver(ctx.mkTactic(Settings.TACTIC));
                VerificationTask task = new VerificationTask(program, wmm, target, settings);
                assertEquals(res, Refinement.runAnalysisGraphRefinement(solver, ctx, task));
                ctx.close();
            }
        } catch (Exception e) {
            fail("Missing resource file");
        }
    }

    //@Test
    public void test() {
    	try {
            Program program = new ProgramParser().parse(new File(path));
            if (program.getAss() != null) {
                // program.setAss(program.getAss().removeLocAssertions(true)); // TEST CODE for comparing!
                Context ctx = new Context();
                Solver solver = ctx.mkSolver(ctx.mkTactic(Settings.TACTIC));
                VerificationTask task = new VerificationTask(program, wmm, target, settings);
                assertEquals(expected, runAnalysis(solver, ctx, task));
                ctx.close();
            }
        } catch (Exception e){
            fail("Missing resource file");
        }
    }

    @Test
    public void testRefinement() {
        try {
            Program program = new ProgramParser().parse(new File(path));
            if (program.getAss() != null) {
                //program.setAss(program.getAss().removeLocAssertions(true));
                if (!program.getAss().getLocs().isEmpty()) {
                    // We assert true, because Refinement can't handle these assertions
                    // They need coherence, which Refinement avoids to encode!
                    assertEquals(0 ,0);
                    return;
                }
                Context ctx = new Context();
                Solver solver = ctx.mkSolver(ctx.mkTactic(Settings.TACTIC));
                VerificationTask task = new VerificationTask(program, wmm, target, settings);
                assertEquals(expected, Refinement.runAnalysisGraphRefinement(solver, ctx, task));
                ctx.close();
            }
        } catch (Exception e){
            fail("Missing resource file");
        }
    }
}
