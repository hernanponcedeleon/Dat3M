package com.dat3m.dartagnan.wmm.relation.base;

import com.dat3m.dartagnan.Dartagnan;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.ResourceHelper;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.Mode;
import com.dat3m.dartagnan.wmm.utils.alias.Alias;
import com.microsoft.z3.Context;
import com.microsoft.z3.Solver;
import org.junit.Test;

import java.io.File;
import java.io.IOException;

import static org.junit.Assert.assertTrue;

public class RelRfTest {

    @Test
    public void testUninitializedMemory() throws IOException {
        Settings settings = new Settings(Mode.KNASTER, Alias.CFIS, 1);
        settings.setFlag(Settings.FLAG_CAN_ACCESS_UNINITIALIZED_MEMORY, true);

        String programPath = ResourceHelper.TEST_RESOURCE_PATH + "wmm/relation/basic/rf/";
        String wmmPath = ResourceHelper.CAT_RESOURCE_PATH + "cat/linux-kernel.cat";

        Context ctx = new Context();
        Solver solver = ctx.mkSolver(ctx.mkTactic(Settings.TACTIC));
        Program p1 = new ProgramParser().parse(new File(programPath + "C-rf-01.litmus"));
        Program p2 = new ProgramParser().parse(new File(programPath + "C-rf-02.litmus"));

        Wmm wmm = new ParserCat().parse(new File(wmmPath));

        assertTrue(Dartagnan.testProgram(solver, ctx, p1, wmm, p1.getArch(), settings));
        solver.reset();
        assertTrue(Dartagnan.testProgram(solver, ctx, p2, wmm, p2.getArch(), settings));
        ctx.close();
    }
}
