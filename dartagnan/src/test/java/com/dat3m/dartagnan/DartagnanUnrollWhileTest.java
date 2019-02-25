package com.dat3m.dartagnan;

import com.dat3m.dartagnan.asserts.AbstractAssert;
import com.dat3m.dartagnan.asserts.AssertBasic;
import com.dat3m.dartagnan.asserts.AssertCompositeAnd;
import com.dat3m.dartagnan.asserts.AssertNot;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.op.COpBin;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.utils.Alias;
import com.dat3m.dartagnan.utils.ResourceHelper;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.dat3m.dartagnan.wmm.utils.Mode;
import com.microsoft.z3.Context;
import com.microsoft.z3.Solver;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static org.junit.Assert.*;

@RunWith(Parameterized.class)
public class DartagnanUnrollWhileTest {

    @Parameterized.Parameters(name = "{index}: {0} bound={1}")
    public static Iterable<Object[]> data() throws IOException {
        Wmm wmm = new ParserCat().parse(ResourceHelper.CAT_RESOURCE_PATH + "cat/linux-kernel.cat", Arch.NONE);
        String input = ResourceHelper.TEST_RESOURCE_PATH + "unroll/C-unroll-01.litmus";

        List<Object[]> data = new ArrayList<>();
        data.add(new Object[]{input, 1, new int[]{1, 2, 3, 1, 1, 1}, wmm});
        data.add(new Object[]{input, 2, new int[]{2, 5, 9, 1, 2, 3}, wmm});
        data.add(new Object[]{input, 3, new int[]{3, 9, 19, 1, 3, 6}, wmm});
        data.add(new Object[]{input, 4, new int[]{4, 14, 34, 1, 4, 10}, wmm});
        data.add(new Object[]{input, 5, new int[]{5, 20, 55, 1, 5, 15}, wmm});
        return data;
    }

    private static AbstractAssert mkAssert(Program program, int[] data){
        Map<String, Register> registers = new HashMap<>();
        for(Register register : program.getCache().getRegisters()){
            registers.put(register.getName(), register);
        }

        AssertBasic assR1 = new AssertBasic(registers.get("r1"), COpBin.EQ, new IConst(data[0]));
        AssertBasic assR2 = new AssertBasic(registers.get("r2"), COpBin.EQ, new IConst(data[1]));
        AssertBasic assR3 = new AssertBasic(registers.get("r3"), COpBin.EQ, new IConst(data[2]));
        AssertBasic assR11 = new AssertBasic(registers.get("r11"), COpBin.EQ, new IConst(data[3]));
        AssertBasic assR22 = new AssertBasic(registers.get("r22"), COpBin.EQ, new IConst(data[4]));
        AssertBasic assR33 = new AssertBasic(registers.get("r33"), COpBin.EQ, new IConst(data[5]));

        AbstractAssert ass = new AssertCompositeAnd(assR1, assR2);
        ass = new AssertCompositeAnd(ass, new AssertCompositeAnd(assR3, assR11));
        ass = new AssertCompositeAnd(ass, new AssertCompositeAnd(assR22, assR33));
        ass = new AssertNot(ass);
        ass.setType(AbstractAssert.ASSERT_TYPE_FORALL);
        return ass;
    }

    private String input;
    private int bound;
    private int[] data;
    private Wmm wmm;

    public DartagnanUnrollWhileTest(String input, int bound, int[] data, Wmm wmm) {
        this.input = input;
        this.bound = bound;
        this.data = data;
        this.wmm = wmm;
    }

    @Test
    public void test() {
        try {
            Program program = new ProgramParser().parse(input);
            program.setAss(mkAssert(program, data));
            Context ctx = new Context();
            Solver solver = ctx.mkSolver(ctx.mkTactic(Dartagnan.TACTIC));
            assertTrue(Dartagnan.testProgram(solver, ctx, program, wmm, Arch.NONE, bound, Mode.KNASTER, Alias.CFIS));
            ctx.close();
        } catch (IOException e){
            fail("Missing resource file");
        }
    }
}
