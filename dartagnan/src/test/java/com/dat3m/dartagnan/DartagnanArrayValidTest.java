package com.dat3m.dartagnan;

import com.dat3m.dartagnan.program.utils.Alias;
import com.dat3m.dartagnan.wmm.utils.Mode;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.ResourceHelper;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.microsoft.z3.Context;
import com.microsoft.z3.Solver;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.stream.Collectors;

import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;

@RunWith(Parameterized.class)
public class DartagnanArrayValidTest {

    @Parameterized.Parameters(name = "{index}: {0}")
    public static Iterable<Object[]> data() throws IOException {
        Wmm wmm = new ParserCat().parse(ResourceHelper.CAT_RESOURCE_PATH + "cat/linux-kernel.cat", Arch.NONE);
        return Files.walk(Paths.get(ResourceHelper.TEST_RESOURCE_PATH + "arrays/ok/"))
                .filter(Files::isRegularFile)
                .filter(f -> (f.toString().endsWith("litmus")))
                .map(f -> new Object[]{f.toString(), wmm})
                .collect(Collectors.toList());
    };

    private String input;
    private Wmm wmm;

    public DartagnanArrayValidTest(String input, Wmm wmm) {
        this.input = input;
        this.wmm = wmm;
    }

    @Test
    public void test() {
        try{
            Program program = Dartagnan.parseProgram(input);
            Context ctx = new Context();
            Solver solver = ctx.mkSolver(ctx.mkTactic(Dartagnan.TACTIC));
            assertTrue(Dartagnan.testProgram(solver, ctx, program, wmm, Arch.NONE, 2, Mode.KNASTER, Alias.CFIS));
        } catch (IOException e){
            fail("Missing resource file");
        }
    }
}
