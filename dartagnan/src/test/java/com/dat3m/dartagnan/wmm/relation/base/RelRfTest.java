package com.dat3m.dartagnan.wmm.relation.base;

import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.utils.ResourceHelper;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.utils.Mode;
import com.dat3m.dartagnan.wmm.utils.Utils;
import com.dat3m.dartagnan.wmm.utils.alias.Alias;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Solver;
import com.microsoft.z3.Status;
import org.junit.Test;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import static com.dat3m.dartagnan.analysis.Base.runAnalysis;
import static com.dat3m.dartagnan.utils.Result.FAIL;
import static org.junit.Assert.*;

public class RelRfTest {

    @Test
    public void testUninitializedMemory() throws IOException {
        Settings settings = new Settings(Mode.KNASTER, Alias.CFIS, 1, false);
        settings.setFlag(Settings.FLAG_CAN_ACCESS_UNINITIALIZED_MEMORY, true);

        String programPath = ResourceHelper.TEST_RESOURCE_PATH + "wmm/relation/basic/rf/";
        String wmmPath = ResourceHelper.CAT_RESOURCE_PATH + "cat/linux-kernel.cat";

        Context ctx = new Context();
        Solver solver = ctx.mkSolver(ctx.mkTactic(Settings.TACTIC));
        Program p1 = new ProgramParser().parse(new File(programPath + "C-rf-01.litmus"));
        Program p2 = new ProgramParser().parse(new File(programPath + "C-rf-02.litmus"));

        Wmm wmm = new ParserCat().parse(new File(wmmPath));

        settings.setFlag(Settings.FLAG_USE_SEQ_ENCODING_REL_RF, false);
        assertTrue(runAnalysis(solver, ctx, p1, wmm, p1.getArch(), settings).equals(FAIL));
        solver.reset();
        assertTrue(runAnalysis(solver, ctx, p2, wmm, p2.getArch(), settings).equals(FAIL));
        solver.reset();

        settings.setFlag(Settings.FLAG_USE_SEQ_ENCODING_REL_RF, true);
        assertTrue(runAnalysis(solver, ctx, p1, wmm, p1.getArch(), settings).equals(FAIL));
        solver.reset();
        assertTrue(runAnalysis(solver, ctx, p2, wmm, p2.getArch(), settings).equals(FAIL));
        ctx.close();
    }

    @Test
    public void testDuplicatedEdges() throws IOException {
        String p1Path = ResourceHelper.TEST_RESOURCE_PATH + "wmm/relation/basic/rf/C-rf-03.litmus";
        String p2Path = ResourceHelper.TEST_RESOURCE_PATH + "wmm/relation/basic/rf/C-rf-04.litmus";

        String wmmPath = ResourceHelper.CAT_RESOURCE_PATH + "cat/linux-kernel.cat";
        Wmm wmm = new ParserCat().parse(new File(wmmPath));

        Settings settings = new Settings(Mode.KNASTER, Alias.CFIS, 1, false);

        settings.setFlag(Settings.FLAG_CAN_ACCESS_UNINITIALIZED_MEMORY, false);
        settings.setFlag(Settings.FLAG_USE_SEQ_ENCODING_REL_RF, false);
        doTestDuplicatedEdges(p1Path, wmm, settings);
        doTestDuplicatedEdges(p2Path, wmm, settings);
        settings.setFlag(Settings.FLAG_USE_SEQ_ENCODING_REL_RF, true);
        doTestDuplicatedEdges(p1Path, wmm, settings);
        doTestDuplicatedEdges(p2Path, wmm, settings);

        settings.setFlag(Settings.FLAG_CAN_ACCESS_UNINITIALIZED_MEMORY, true);
        settings.setFlag(Settings.FLAG_USE_SEQ_ENCODING_REL_RF, false);
        doTestDuplicatedEdges(p1Path, wmm, settings);
        doTestDuplicatedEdges(p2Path, wmm, settings);
        settings.setFlag(Settings.FLAG_USE_SEQ_ENCODING_REL_RF, true);
        doTestDuplicatedEdges(p1Path, wmm, settings);
        doTestDuplicatedEdges(p2Path, wmm, settings);
    }

    private void doTestDuplicatedEdges(String programPath, Wmm wmm, Settings settings) throws IOException {

    	Program program = new ProgramParser().parse(new File(programPath));
        program.unroll(settings.getBound(), 0);
        program.compile(program.getArch(), 0);

        Map<Integer, Event> events = new HashMap<Integer, Event>(){{
            put(2, null); put(5, null); put(8, null);
        }};
        extractEvents(program, events);

        Context ctx = new Context();
        Solver solver = ctx.mkSolver(ctx.mkTactic(Settings.TACTIC));
        
		solver.add(program.getAss().encode(ctx));
        if(program.getAssFilter() != null){
            solver.add(program.getAssFilter().encode(ctx));
        }
        solver.add(program.encodeCF(ctx));
        solver.add(program.encodeFinalRegisterValues(ctx));
        solver.add(wmm.encode(program, ctx, settings));
        // Don't add constraint of MM, they can also forbid illegal edges

        assertEquals(Status.SATISFIABLE, solver.check());

        BoolExpr edge1 = Utils.edge("rf", events.get(5), events.get(2), ctx);
        solver.add(edge1);
        assertEquals(Status.SATISFIABLE, solver.check());

        BoolExpr edge2 = Utils.edge("rf", events.get(8), events.get(2), ctx);
        solver.add(edge2);
        assertEquals(Status.UNSATISFIABLE, solver.check());

        ctx.close();
    }

    private void extractEvents(Program program, Map<Integer, Event> events){
        for(Event e : program.getCache().getEvents(FilterBasic.get(EType.ANY))){
            for(int id : events.keySet()){
                if(e.getCId() == id){
                    events.put(id, e);
                }
            }
        }
        for(int id : events.keySet()){
            assertNotNull(events.get(id));
        }
    }
}
