package com.dat3m.porthos;

import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.dat3m.dartagnan.wmm.utils.Mode;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.alias.Alias;
import com.microsoft.z3.Context;
import com.microsoft.z3.Solver;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import static org.junit.Assert.*;

@RunWith(Parameterized.class)
public class PorthosTest {

    private static final String CAT_RESOURCE_PATH = "../";
    private static final String BENCHMARKS_RESOURCE_PATH = "src/test/resources/pts/";

    @Parameterized.Parameters(name = "{index}: {0} {2} -> {3} {6}")
    public static Iterable<Object[]> data() throws IOException {

        Wmm wmmSc = new ParserCat().parse(new File(CAT_RESOURCE_PATH + "cat/sc.cat"));
        Wmm wmmTso = new ParserCat().parse(new File(CAT_RESOURCE_PATH + "cat/tso.cat"));
        Wmm wmmPpc = new ParserCat().parse(new File(CAT_RESOURCE_PATH + "cat/power.cat"));
        Wmm wmmArm = new ParserCat().parse(new File(CAT_RESOURCE_PATH + "cat/arm.cat"));

        Settings s1 = new Settings(Mode.KNASTER, Alias.CFIS, 2, false);
        Settings s2 = new Settings(Mode.IDL, Alias.CFIS, 2, false);
        Settings s3 = new Settings(Mode.KLEENE, Alias.CFIS, 2, false);

        return Arrays.asList(new Object[][] {
                { BENCHMARKS_RESOURCE_PATH + "Bakery.pts", false, Arch.NONE, Arch.TSO, wmmSc, wmmTso, s1 },
                { BENCHMARKS_RESOURCE_PATH + "Burns.pts", false, Arch.NONE, Arch.TSO, wmmSc, wmmTso, s1 },
                { BENCHMARKS_RESOURCE_PATH + "Dekker.pts", false, Arch.NONE, Arch.TSO, wmmSc, wmmTso, s1 },
                { BENCHMARKS_RESOURCE_PATH + "Lamport.pts", false, Arch.NONE, Arch.TSO, wmmSc, wmmTso, s1 },
                { BENCHMARKS_RESOURCE_PATH + "Parker.pts", false, Arch.NONE, Arch.TSO, wmmSc, wmmTso, s1 },
                { BENCHMARKS_RESOURCE_PATH + "Peterson.pts", false, Arch.NONE, Arch.TSO, wmmSc, wmmTso, s1 },
                { BENCHMARKS_RESOURCE_PATH + "Szymanski.pts", false, Arch.NONE, Arch.TSO, wmmSc, wmmTso, s1 },

                { BENCHMARKS_RESOURCE_PATH + "Bakery.pts", false, Arch.NONE, Arch.TSO, wmmSc, wmmTso, s2 },
                { BENCHMARKS_RESOURCE_PATH + "Burns.pts", false, Arch.NONE, Arch.TSO, wmmSc, wmmTso, s2 },
                { BENCHMARKS_RESOURCE_PATH + "Dekker.pts", false, Arch.NONE, Arch.TSO, wmmSc, wmmTso, s2 },
                { BENCHMARKS_RESOURCE_PATH + "Lamport.pts", false, Arch.NONE, Arch.TSO, wmmSc, wmmTso, s2 },
                { BENCHMARKS_RESOURCE_PATH + "Parker.pts", false, Arch.NONE, Arch.TSO, wmmSc, wmmTso, s2 },
                { BENCHMARKS_RESOURCE_PATH + "Peterson.pts", false, Arch.NONE, Arch.TSO, wmmSc, wmmTso, s2 },
                { BENCHMARKS_RESOURCE_PATH + "Szymanski.pts", false, Arch.NONE, Arch.TSO, wmmSc, wmmTso, s2 },

                { BENCHMARKS_RESOURCE_PATH + "Bakery.pts", false, Arch.NONE, Arch.TSO, wmmSc, wmmTso, s3 },
                { BENCHMARKS_RESOURCE_PATH + "Burns.pts", false, Arch.NONE, Arch.TSO, wmmSc, wmmTso, s3 },
                { BENCHMARKS_RESOURCE_PATH + "Dekker.pts", false, Arch.NONE, Arch.TSO, wmmSc, wmmTso, s3 },
                { BENCHMARKS_RESOURCE_PATH + "Lamport.pts", false, Arch.NONE, Arch.TSO, wmmSc, wmmTso, s3 },
                { BENCHMARKS_RESOURCE_PATH + "Parker.pts", false, Arch.NONE, Arch.TSO, wmmSc, wmmTso, s3 },
                { BENCHMARKS_RESOURCE_PATH + "Peterson.pts", false, Arch.NONE, Arch.TSO, wmmSc, wmmTso, s3 },
                { BENCHMARKS_RESOURCE_PATH + "Szymanski.pts", false, Arch.NONE, Arch.TSO, wmmSc, wmmTso, s3 },

                { BENCHMARKS_RESOURCE_PATH + "Bakery.pts", true, Arch.TSO, Arch.POWER, wmmTso, wmmPpc, s1 },
                { BENCHMARKS_RESOURCE_PATH + "Burns.pts", true, Arch.TSO, Arch.POWER, wmmTso, wmmPpc, s1 },
                { BENCHMARKS_RESOURCE_PATH + "Dekker.pts", true, Arch.TSO, Arch.POWER, wmmTso, wmmPpc, s1 },
                { BENCHMARKS_RESOURCE_PATH + "Lamport.pts", false, Arch.TSO, Arch.POWER, wmmTso, wmmPpc, s1 },
                { BENCHMARKS_RESOURCE_PATH + "Parker.pts", false, Arch.TSO, Arch.POWER, wmmTso, wmmPpc, s1 },
                { BENCHMARKS_RESOURCE_PATH + "Peterson.pts", true, Arch.TSO, Arch.POWER, wmmTso, wmmPpc, s1 },
                { BENCHMARKS_RESOURCE_PATH + "Szymanski.pts", true, Arch.TSO, Arch.POWER, wmmTso, wmmPpc, s1 },

                { BENCHMARKS_RESOURCE_PATH + "Bakery.pts", true, Arch.TSO, Arch.POWER, wmmTso, wmmPpc, s2 },
                { BENCHMARKS_RESOURCE_PATH + "Burns.pts", true, Arch.TSO, Arch.POWER, wmmTso, wmmPpc, s2 },
                { BENCHMARKS_RESOURCE_PATH + "Dekker.pts", true, Arch.TSO, Arch.POWER, wmmTso, wmmPpc, s2 },
                { BENCHMARKS_RESOURCE_PATH + "Lamport.pts", false, Arch.TSO, Arch.POWER, wmmTso, wmmPpc, s2 },
                { BENCHMARKS_RESOURCE_PATH + "Parker.pts", false, Arch.TSO, Arch.POWER, wmmTso, wmmPpc, s2 },
                { BENCHMARKS_RESOURCE_PATH + "Peterson.pts", true, Arch.TSO, Arch.POWER, wmmTso, wmmPpc, s2 },
                { BENCHMARKS_RESOURCE_PATH + "Szymanski.pts", true, Arch.TSO, Arch.POWER, wmmTso, wmmPpc, s2 },

                { BENCHMARKS_RESOURCE_PATH + "Bakery.pts", true, Arch.TSO, Arch.POWER, wmmTso, wmmPpc, s3 },
                { BENCHMARKS_RESOURCE_PATH + "Burns.pts", true, Arch.TSO, Arch.POWER, wmmTso, wmmPpc, s3 },
                { BENCHMARKS_RESOURCE_PATH + "Dekker.pts", true, Arch.TSO, Arch.POWER, wmmTso, wmmPpc, s3 },
                { BENCHMARKS_RESOURCE_PATH + "Lamport.pts", false, Arch.TSO, Arch.POWER, wmmTso, wmmPpc, s3 },
                { BENCHMARKS_RESOURCE_PATH + "Parker.pts", false, Arch.TSO, Arch.POWER, wmmTso, wmmPpc, s3 },
                { BENCHMARKS_RESOURCE_PATH + "Peterson.pts", true, Arch.TSO, Arch.POWER, wmmTso, wmmPpc, s3 },
                { BENCHMARKS_RESOURCE_PATH + "Szymanski.pts", true, Arch.TSO, Arch.POWER, wmmTso, wmmPpc, s3 },

                { BENCHMARKS_RESOURCE_PATH + "Bakery.pts", true, Arch.TSO, Arch.ARM, wmmTso, wmmArm, s1 },
                { BENCHMARKS_RESOURCE_PATH + "Burns.pts", true, Arch.TSO, Arch.ARM, wmmTso, wmmArm, s1 },
                { BENCHMARKS_RESOURCE_PATH + "Dekker.pts", true, Arch.TSO, Arch.ARM, wmmTso, wmmArm, s1 },
                { BENCHMARKS_RESOURCE_PATH + "Lamport.pts", false, Arch.TSO, Arch.ARM, wmmTso, wmmArm, s1 },
                { BENCHMARKS_RESOURCE_PATH + "Parker.pts", false, Arch.TSO, Arch.ARM, wmmTso, wmmArm, s1 },
                { BENCHMARKS_RESOURCE_PATH + "Peterson.pts", true, Arch.TSO, Arch.ARM, wmmTso, wmmArm, s1 },
                { BENCHMARKS_RESOURCE_PATH + "Szymanski.pts", true, Arch.TSO, Arch.ARM, wmmTso, wmmArm, s1 },

                { BENCHMARKS_RESOURCE_PATH + "Bakery.pts", true, Arch.TSO, Arch.ARM, wmmTso, wmmArm, s2 },
                { BENCHMARKS_RESOURCE_PATH + "Burns.pts", true, Arch.TSO, Arch.ARM, wmmTso, wmmArm, s2 },
                { BENCHMARKS_RESOURCE_PATH + "Dekker.pts", true, Arch.TSO, Arch.ARM, wmmTso, wmmArm, s2 },
                { BENCHMARKS_RESOURCE_PATH + "Lamport.pts", false, Arch.TSO, Arch.ARM, wmmTso, wmmArm, s2 },
                { BENCHMARKS_RESOURCE_PATH + "Parker.pts", false, Arch.TSO, Arch.ARM, wmmTso, wmmArm, s2 },
                { BENCHMARKS_RESOURCE_PATH + "Peterson.pts", true, Arch.TSO, Arch.ARM, wmmTso, wmmArm, s2 },
                { BENCHMARKS_RESOURCE_PATH + "Szymanski.pts", true, Arch.TSO, Arch.ARM, wmmTso, wmmArm, s2 },

                { BENCHMARKS_RESOURCE_PATH + "Bakery.pts", true, Arch.TSO, Arch.ARM, wmmTso, wmmArm, s3 },
                { BENCHMARKS_RESOURCE_PATH + "Burns.pts", true, Arch.TSO, Arch.ARM, wmmTso, wmmArm, s3 },
                { BENCHMARKS_RESOURCE_PATH + "Dekker.pts", true, Arch.TSO, Arch.ARM, wmmTso, wmmArm, s3 },
                { BENCHMARKS_RESOURCE_PATH + "Lamport.pts", false, Arch.TSO, Arch.ARM, wmmTso, wmmArm, s3 },
                { BENCHMARKS_RESOURCE_PATH + "Parker.pts", false, Arch.TSO, Arch.ARM, wmmTso, wmmArm, s3 },
                { BENCHMARKS_RESOURCE_PATH + "Peterson.pts", true, Arch.TSO, Arch.ARM, wmmTso, wmmArm, s3 },
                { BENCHMARKS_RESOURCE_PATH + "Szymanski.pts", true, Arch.TSO, Arch.ARM, wmmTso, wmmArm, s3 }
        });
    }

    private String programFilePath;
    private boolean expected;
    private Arch source;
    private Arch target;
    private Wmm sourceWmm;
    private Wmm targetWmm;
    private Settings settings;

    public PorthosTest(String path, boolean expected, Arch source, Arch target, Wmm sourceWmm, Wmm targetWmm, Settings settings) {
        this.programFilePath = path;
        this.expected = expected;
        this.source = source;
        this.target = target;
        this.sourceWmm = sourceWmm;
        this.targetWmm = targetWmm;
        this.settings = settings;
    }

    @Test
    public void test() {
        try {
            ProgramParser programParser = new ProgramParser();
            Program pSource = programParser.parse(new File(programFilePath));
            Program pTarget = programParser.parse(new File(programFilePath));

            Context ctx = new Context();
            
            Solver s1 = ctx.mkSolver(ctx.mkTactic(Settings.TACTIC));
            Solver s2 = ctx.mkSolver(ctx.mkTactic(Settings.TACTIC));
            PorthosResult result = Porthos.testProgram(s1, s2, ctx, pSource, pTarget,
                    source, target, sourceWmm, targetWmm, settings);
            assertEquals(expected, result.getIsPortable());
            ctx.close();

            for(Thread thread : pSource.getThreads()){
                List<Event> events = thread.getCache().getEvents(FilterBasic.get(EType.ANY));
                Event lastEvent = events.get(0);
                for(int i = 1; i < events.size(); i++){
                    Event thisEvent = events.get(i);
                    if(lastEvent.getUId() > thisEvent.getUId() || lastEvent.getCId() >= thisEvent.getCId()){
                        fail("Malformed thread " + thread.getId() + " in program compiled to " + source);
                    }
                    lastEvent = thisEvent;
                }
            }

            for(Thread thread : pTarget.getThreads()){
                List<Event> events = thread.getCache().getEvents(FilterBasic.get(EType.ANY));
                Event lastEvent = events.get(0);
                for(int i = 1; i < events.size(); i++){
                    Event thisEvent = events.get(i);
                    if(lastEvent.getUId() > thisEvent.getUId() || lastEvent.getCId() >= thisEvent.getCId()){
                        fail("Malformed thread " + thread.getId() + " in program compiled to " + target);
                    }
                    lastEvent = thisEvent;
                }
            }

        } catch (IOException e){
            fail("Missing resource file");
        }
    }
}