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
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.wmm.utils.alias.Alias;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.utils.ResourceHelper;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.dat3m.dartagnan.wmm.utils.Mode;
import com.microsoft.z3.Context;
import com.microsoft.z3.Solver;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static org.junit.Assert.*;

@RunWith(Parameterized.class)
public class DartagnanUnrollWhileTest {

    @Parameterized.Parameters(name = "{index}: {0} bound={2}")
    public static Iterable<Object[]> data() throws IOException {
        Wmm wmm = new ParserCat().parse(new File(ResourceHelper.CAT_RESOURCE_PATH + "cat/linux-kernel.cat"));
        String test1 = ResourceHelper.TEST_RESOURCE_PATH + "unroll/C-unroll-01.litmus";
        String test2 = ResourceHelper.TEST_RESOURCE_PATH + "unroll/C-unroll-02.litmus";
        String test3 = ResourceHelper.TEST_RESOURCE_PATH + "unroll/C-unroll-03.litmus";

        List<Object[]> data = new ArrayList<>();

        data.add(new Object[]{test1, wmm, 1, new String[]{"r1", "r2", "r3", "r4", "r5", "r6"}, new int[]{1, 2, 3, 1, 1, 1}});
        data.add(new Object[]{test1, wmm, 2, new String[]{"r1", "r2", "r3", "r4", "r5", "r6"}, new int[]{2, 5, 9, 1, 2, 3}});
        data.add(new Object[]{test1, wmm, 3, new String[]{"r1", "r2", "r3", "r4", "r5", "r6"}, new int[]{3, 9, 19, 1, 3, 6}});
        data.add(new Object[]{test1, wmm, 4, new String[]{"r1", "r2", "r3", "r4", "r5", "r6"}, new int[]{4, 14, 34, 1, 4, 10}});
        data.add(new Object[]{test1, wmm, 5, new String[]{"r1", "r2", "r3", "r4", "r5", "r6"}, new int[]{5, 20, 55, 1, 5, 15}});

        data.add(new Object[]{test2, wmm, 1, new String[]{"r1", "r2", "r3", "r4", "r5", "r6", "r7"}, new int[]{1, 1, 1, 1, 0, 0, 1}});
        data.add(new Object[]{test2, wmm, 2, new String[]{"r1", "r2", "r3", "r4", "r5", "r6", "r7"}, new int[]{2, 2, 1, 2, 0, 0, 2}});
        data.add(new Object[]{test2, wmm, 3, new String[]{"r1", "r2", "r3", "r4", "r5", "r6", "r7"}, new int[]{3, 3, 1, 3, 0, 0, 3}});

        data.add(new Object[]{test3, wmm, 1, new String[]{"r1", "r2", "r3", "r4", "r5", "r6", "r7"}, new int[]{1, 1, 0, 1, 1, 1, 1}});
        data.add(new Object[]{test3, wmm, 2, new String[]{"r1", "r2", "r3", "r4", "r5", "r6", "r7"}, new int[]{1, 2, 0, 3, 2, 1, 1}});
        data.add(new Object[]{test3, wmm, 3, new String[]{"r1", "r2", "r3", "r4", "r5", "r6", "r7"}, new int[]{1, 3, 0, 6, 3, 1, 1}});
        data.add(new Object[]{test3, wmm, 4, new String[]{"r1", "r2", "r3", "r4", "r5", "r6", "r7"}, new int[]{1, 4, 0, 10, 4, 1, 1}});
        data.add(new Object[]{test3, wmm, 5, new String[]{"r1", "r2", "r3", "r4", "r5", "r6", "r7"}, new int[]{1, 5, 0, 15, 5, 1, 1}});

        return data;
    }


    private String path;
    private Wmm wmm;
    private int bound;
    private String[] names;
    private int[] values;

    public DartagnanUnrollWhileTest(String path, Wmm wmm, int bound, String[] names, int[] values) {
        this.path = path;
        this.wmm = wmm;
        this.bound = bound;
        this.names = names;
        this.values = values;
    }

    @Test
    public void test() {
        try {
            Program program = new ProgramParser().parse(new File(path));
            program.setAss(mkAssert(program, names, values));
            Context ctx = new Context();
            Solver solver = ctx.mkSolver(ctx.mkTactic(Dartagnan.TACTIC));
            assertTrue(Dartagnan.testProgram(solver, ctx, program, wmm, Arch.NONE, bound, Mode.KNASTER, Alias.CFIS));
            ctx.close();

            for(Thread thread : program.getThreads()){
                List<Event> events = thread.getCache().getEvents(FilterBasic.get(EType.ANY));
                Event lastEvent = events.get(0);
                for(int i = 1; i < events.size(); i++){
                    Event thisEvent = events.get(i);
                    if(lastEvent.getUId() > thisEvent.getUId() || lastEvent.getCId() >= thisEvent.getCId()){
                        fail("Malformed thread " + thread.getId());
                    }
                    lastEvent = thisEvent;
                }
            }

        } catch (IOException e){
            fail("Missing resource file");
        }
    }

    private AbstractAssert mkAssert(Program program, String[] names, int[] values){
        Map<String, Register> registers = new HashMap<>();
        for(Register register : program.getCache().getRegisters()){
            registers.put(register.getName(), register);
        }
        AbstractAssert ass = new AssertBasic(new IConst(0), COpBin.EQ, new IConst(0));
        for(int i = 0; i < names.length; i++){
            ass = new AssertCompositeAnd(ass, new AssertBasic(registers.get(names[i]), COpBin.EQ, new IConst(values[i])));
        }
        ass = new AssertNot(ass);
        ass.setType(AbstractAssert.ASSERT_TYPE_FORALL);
        return ass;
    }
}
