package com.dat3m.dartagnan;

import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.wmm.utils.Mode;
import com.dat3m.dartagnan.parsers.boogie.C2BoogieRunner;
import com.dat3m.dartagnan.parsers.boogie.SVCOMPSanitizer;
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
import static com.dat3m.dartagnan.utils.ResourceHelper.getSVCOMPResults;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;

public abstract class AbstractSVCOMPTest {

    static Iterable<Object[]> buildParameters(String benchmarkPath, String cat, Arch target) throws IOException {
        Map<String, Result> expectationMap = getSVCOMPResults(ResourceHelper.BENCHMARK_RESOURCE_PATH + benchmarkPath);
        Wmm wmm = new ParserCat().parse(new File(ResourceHelper.CAT_RESOURCE_PATH + cat));        
        Settings s1 = new Settings(Mode.KNASTER, Alias.CFIS, 1);

        return Files.walk(Paths.get(ResourceHelper.BENCHMARK_RESOURCE_PATH + benchmarkPath))
                .filter(Files::isRegularFile)
                .map(Path::toString)
                .filter(f -> f.endsWith("i"))
                .map(f -> new Object[]{f, expectationMap.get(f)})
                .collect(ArrayList::new,
                        (l, f) -> {
                            l.add(new Object[]{f[0], f[1], target, wmm, s1});
                        }, ArrayList::addAll);
    }

    private String path;
    private Result expected;
    private Arch target;
    private Wmm wmm;
    private Settings settings;

    AbstractSVCOMPTest(String path, Result expected, Arch target, Wmm wmm, Settings settings) {
        this.path = new C2BoogieRunner(new SVCOMPSanitizer(path).run()).run();;
        this.expected = expected;
        this.target = target;
        this.wmm = wmm;
        this.settings = settings;
    }

    @Test
    public void test() {   	
    	try {
    		File file = new File(path);
            Program program = new ProgramParser().parse(file);
            file.delete();
            Context ctx = new Context();
            Solver solver = ctx.mkSolver(ctx.mkTactic(Settings.TACTIC));
            assertEquals(expected, Dartagnan.testProgram(solver, ctx, program, wmm, target, settings));
            ctx.close();
        } catch (IOException e){
            fail("Missing resource file");
        }
    }
}
