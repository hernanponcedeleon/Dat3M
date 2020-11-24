package com.dat3m.dartagnan;

import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.wmm.utils.Mode;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.ResourceHelper;
import com.dat3m.dartagnan.utils.Result;
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

    static Iterable<Object[]> buildParameters(String litmusPath, String cat, Arch target) throws IOException {
        int n = ResourceHelper.LITMUS_RESOURCE_PATH.length();
        Map<String, Result> expectationMap = ResourceHelper.getExpectedResults();
        Wmm wmm = new ParserCat().parse(new File(ResourceHelper.CAT_RESOURCE_PATH + cat));

        Settings s1 = new Settings(Mode.KNASTER, Alias.CFIS, 1, false);
        Settings s2 = new Settings(Mode.IDL, Alias.CFIS, 1, false);
        Settings s3 = new Settings(Mode.KLEENE, Alias.CFIS, 1, false);

        return Files.walk(Paths.get(ResourceHelper.LITMUS_RESOURCE_PATH + litmusPath))
                .filter(Files::isRegularFile)
                .map(Path::toString)
                .filter(f -> f.endsWith("litmus"))
                .filter(f -> expectationMap.containsKey(f.substring(n)))
                .map(f -> new Object[]{f, expectationMap.get(f.substring(n))})
                .collect(ArrayList::new,
                        (l, f) -> {
                            l.add(new Object[]{f[0], f[1], target, wmm, s1});
                            l.add(new Object[]{f[0], f[1], target, wmm, s2});
                            l.add(new Object[]{f[0], f[1], target, wmm, s3});
                        }, ArrayList::addAll);
    }

    private String path;
    private Result expected;
    private Arch target;
    private Wmm wmm;
    private Settings settings;

    AbstractDartagnanTest(String path, Result expected, Arch target, Wmm wmm, Settings settings) {
        this.path = path;
        this.expected = expected;
        this.target = target;
        this.wmm = wmm;
        this.settings = settings;
    }

    @Test
    public void test() {
    	try {
            Program program = new ProgramParser().parse(new File(path));
            if (program.getAss() != null) {
                Context ctx = new Context();
                Solver solver = ctx.mkSolver(ctx.mkTactic(Settings.TACTIC));
                assertEquals(expected, runAnalysis(solver, ctx, program, wmm, target, settings));
                ctx.close();
            }
        } catch (IOException e){
            fail("Missing resource file");
        }
    }
}
