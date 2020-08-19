package com.dat3m.dartagnan.wmm.relation.base.rmw;

import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.arch.aarch64.utils.EType;
import com.dat3m.dartagnan.utils.ResourceHelper;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.filter.FilterIntersection;
import com.dat3m.dartagnan.wmm.relation.EdgeTestHelper;
import com.dat3m.dartagnan.wmm.utils.Flag;
import com.dat3m.dartagnan.wmm.utils.Mode;
import com.dat3m.dartagnan.wmm.utils.alias.Alias;
import com.microsoft.z3.*;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.File;
import java.io.IOException;
import java.util.*;

import static com.dat3m.dartagnan.analysis.Base.runAnalysis;
import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.PASS;
import static org.junit.Assert.*;

@RunWith(Parameterized.class)
public class ExclusivePairsTest {

    @Parameterized.Parameters(name = "{index}: {0}")
    public static Iterable<Object[]> data() throws IOException {
        Settings settings = new Settings(Mode.KNASTER, Alias.CFIS, 1, false);
        Wmm wmm = new ParserCat().parse(new File(ResourceHelper.CAT_RESOURCE_PATH + "cat/aarch64.cat"));
        String path = ResourceHelper.TEST_RESOURCE_PATH + "wmm/relation/basic/rmw/aarch64/";

        List<Object[]> data = new ArrayList<>();
        data.add(new Object[]{path + "AArch64-exclusive-01.litmus", wmm, settings, FAIL,  false, new int[]{2, 4}});
        data.add(new Object[]{path + "AArch64-exclusive-02.litmus", wmm, settings, FAIL,  false, new int[]{}});
        data.add(new Object[]{path + "AArch64-exclusive-03.litmus", wmm, settings, FAIL,  true,  new int[]{}});
        data.add(new Object[]{path + "AArch64-exclusive-04.litmus", wmm, settings, FAIL,  true,  new int[]{}});
        data.add(new Object[]{path + "AArch64-exclusive-05.litmus", wmm, settings, PASS, false, null});
        data.add(new Object[]{path + "AArch64-exclusive-06.litmus", wmm, settings, PASS, false, null});
        data.add(new Object[]{path + "AArch64-exclusive-07.litmus", wmm, settings, FAIL,  false, new int[]{}});
        data.add(new Object[]{path + "AArch64-exclusive-08.litmus", wmm, settings, FAIL,  false, new int[]{}});
        data.add(new Object[]{path + "AArch64-exclusive-09.litmus", wmm, settings, PASS, false, null});
        data.add(new Object[]{path + "AArch64-exclusive-10.litmus", wmm, settings, FAIL,  false, new int[]{4, 5}});
        data.add(new Object[]{path + "AArch64-exclusive-11.litmus", wmm, settings, FAIL,  false, new int[]{5, 6}});
        data.add(new Object[]{path + "AArch64-exclusive-12.litmus", wmm, settings, PASS, false, null});
        data.add(new Object[]{path + "AArch64-exclusive-13.litmus", wmm, settings, FAIL,  false, new int[]{4, 5}});
        data.add(new Object[]{path + "AArch64-exclusive-14.litmus", wmm, settings, FAIL,  true,  null});
        data.add(new Object[]{path + "AArch64-exclusive-15.litmus", wmm, settings, FAIL,  true,  null});
        return data;
    }

    private String path;
    private Wmm wmm;
    private Result expectedState;
    private boolean expectedFlag;
    private int[] expectedEdges;
    private Settings settings;

    public ExclusivePairsTest(String path, Wmm wmm, Settings settings, Result expectedState, boolean expectedFlag, int[] expectedEdges) {
        this.path = path;
        this.wmm = wmm;
        this.settings = settings;
        this.expectedState = expectedState;
        this.expectedFlag = expectedFlag;
        this.expectedEdges = expectedEdges;
    }

    @Test
    public void testReachableStates() {
        try{
            Context ctx = new Context();
            Solver solver = ctx.mkSolver(ctx.mkTactic(Settings.TACTIC));
            Program program = new ProgramParser().parse(new File(path));

            // Test final state
            assertEquals(expectedState, runAnalysis(solver, ctx, program, wmm, program.getArch(), settings));

            // Test edges
            if(expectedEdges != null){
                EdgeTestHelper helper = new EdgeTestHelper(
                        program,
                        wmm.getRelationRepository().getRelation("rmw"),
                        FilterIntersection.get(FilterBasic.get(EType.EXCL), FilterBasic.get(EType.READ)),
                        FilterIntersection.get(FilterBasic.get(EType.EXCL), FilterBasic.get(EType.WRITE))
                );
                solver.add(helper.encodeIllegalEdges(expectedEdges, ctx));
                assertSame(Status.UNSATISFIABLE, solver.check());
            }

            ctx.close();

        } catch (IOException e){
            fail("Missing resource file");
        }
    }

    @Test
    public void testUnpredictableBehaviourFlag(){
        try{
            Context ctx = new Context();
            Solver solver = ctx.mkSolver(ctx.mkTactic(Settings.TACTIC));
            
            Program program = new ProgramParser().parse(new File(path));

            // Add program without assertions
            program.unroll(1, 0);
            program.compile(program.getArch(), 0);
            solver.add(program.encodeCF(ctx));
            solver.add(program.encodeFinalRegisterValues(ctx));
            solver.add(wmm.encode(program, ctx, settings));
            solver.add(wmm.consistent(program, ctx));

            // Check flag
            solver.add(ctx.mkEq(Flag.ARM_UNPREDICTABLE_BEHAVIOUR.repr(ctx), ctx.mkTrue()));
            assertEquals(expectedFlag, solver.check() == Status.SATISFIABLE);
            ctx.close();

        } catch (IOException e){
            fail("Missing resource file");
        }
    }
}
