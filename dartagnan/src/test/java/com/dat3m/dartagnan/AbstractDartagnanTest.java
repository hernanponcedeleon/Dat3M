package com.dat3m.dartagnan;

import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.wmm.utils.alias.Alias;
import com.dat3m.dartagnan.wmm.utils.Mode;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.ResourceHelper;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.Arch;
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

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;

public abstract class AbstractDartagnanTest {

    static Iterable<Object[]> buildParameters(String litmusPath, String cat, Arch target, int unroll) throws IOException {
        int n = ResourceHelper.LITMUS_RESOURCE_PATH.length();
        Map<String, Boolean> expectationMap = ResourceHelper.getExpectedResults();
        Wmm wmm = new ParserCat().parse(new File(ResourceHelper.CAT_RESOURCE_PATH + cat));

        return Files.walk(Paths.get(ResourceHelper.LITMUS_RESOURCE_PATH + litmusPath))
                .filter(Files::isRegularFile)
                .map(Path::toString)
                .filter(f -> f.endsWith("litmus"))
                .filter(f -> expectationMap.containsKey(f.substring(n)))
                .map(f -> new Object[]{f, expectationMap.get(f.substring(n))})
                .collect(ArrayList::new,
                        (l, f) -> {
                            l.add(new Object[]{f[0], f[1], target, wmm, unroll, Mode.KNASTER});
                            l.add(new Object[]{f[0], f[1], target, wmm, unroll, Mode.IDL});
                            l.add(new Object[]{f[0], f[1], target, wmm, unroll, Mode.KLEENE});
                        }, ArrayList::addAll);
    }

    private String path;
    private boolean expected;
    private Arch target;
    private Wmm wmm;
    private int unroll;
    private Mode mode;

    AbstractDartagnanTest(String path, boolean expected, Arch target, Wmm wmm, int unroll, Mode mode) {
        this.path = path;
        this.expected = expected;
        this.target = target;
        this.wmm = wmm;
        this.unroll = unroll;
        this.mode = mode;
    }

    @Test
    public void test() {
        try {
            Program program = new ProgramParser().parse(new File(path));
            if (program.getAss() != null) {
                Context ctx = new Context();
                Solver solver = ctx.mkSolver(ctx.mkTactic(Dartagnan.TACTIC));
                assertEquals(expected, Dartagnan.testProgram(solver, ctx, program, wmm, target, unroll, mode, Alias.CFIS));
                ctx.close();
            }
        } catch (IOException e){
            fail("Missing resource file");
        }
    }
}
