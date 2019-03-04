package com.dat3m.dartagnan.wmm.relation.basic;

import com.dat3m.dartagnan.Dartagnan;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.arch.linux.utils.EType;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.utils.Utils;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.alias.Alias;
import com.dat3m.dartagnan.utils.ResourceHelper;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.dat3m.dartagnan.wmm.utils.Mode;
import com.google.common.collect.*;
import com.microsoft.z3.*;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;
import java.util.*;

import static org.junit.Assert.*;

@RunWith(Parameterized.class)
public class RelCritTest {

    @Parameterized.Parameters(name = "{index}: {0}")
    public static Iterable<Object[]> data() throws IOException {
        Wmm wmm = new ParserCat().parse(ResourceHelper.CAT_RESOURCE_PATH + "cat/linux-kernel.cat");
        String path = ResourceHelper.TEST_RESOURCE_PATH + "wmm/relation/basic/crit/";
        List<Object[]> data = new ArrayList<>();

        data.add(new Object[]{path + "C-crit-01.litmus", wmm, ImmutableSetMultimap.of(2, 3, 4, 5)});
        data.add(new Object[]{path + "C-crit-02.litmus", wmm, ImmutableSetMultimap.of(2, 5, 3, 4)});
        data.add(new Object[]{path + "C-crit-03.litmus", wmm, ImmutableSetMultimap.of(3, 4)});
        data.add(new Object[]{path + "C-crit-04.litmus", wmm, ImmutableSetMultimap.of(3, 4)});
        data.add(new Object[]{path + "C-crit-05.litmus", wmm, ImmutableSetMultimap.of(2, 3, 5, 8, 6, 7)});
        data.add(new Object[]{path + "C-crit-06.litmus", wmm, ImmutableSetMultimap.of(2, 11, 3, 6, 4, 5, 7, 10, 8, 9)});
        data.add(new Object[]{path + "C-crit-07.litmus", wmm, ImmutableSetMultimap.of(2, 4)});
        data.add(new Object[]{path + "C-crit-08.litmus", wmm, ImmutableSetMultimap.of(2, 6)});
        data.add(new Object[]{path + "C-crit-09.litmus", wmm, ImmutableSetMultimap.of(2, 7, 8, 10)});

        return data;
    }

    private String input;
    private Wmm wmm;
    private SetMultimap<Integer, Integer> expected;

    public RelCritTest(String input, Wmm wmm, SetMultimap<Integer, Integer> expected) {
        this.input = input;
        this.wmm = wmm;
        this.expected = expected;
    }

    @Test
    public void test() {
        try{
            Context ctx = new Context();
            Solver solver = ctx.mkSolver(ctx.mkTactic(Dartagnan.TACTIC));
            Program program = new ProgramParser().parse(input);

            // Force encoding all possible "crit" relations
            wmm.setDrawExecutionGraph();
            wmm.addDrawRelations(Arrays.asList("crit"));

            // Sanity check, can be skipped
            assertTrue(Dartagnan.testProgram(solver, ctx, program, wmm, Arch.NONE, 1, Mode.KNASTER, Alias.CFIS));

            Set<Tuple> allTuples = mkAllTuples(program);
            Set<Tuple> expectedTuples = mkExpectedTuples(program, allTuples);
            Set<Tuple> maxTupleSet = wmm.getRelationRepository().getRelation("crit").getMaxTupleSet();

            // Encode violation of expected event pairs in the relation
            for(Tuple tuple : allTuples){
                BoolExpr edge = Utils.edge("crit", tuple.getFirst(), tuple.getSecond(), ctx);
                if(expectedTuples.contains(tuple)){
                    solver.add(ctx.mkNot(edge));
                } else if(maxTupleSet.contains(tuple)){
                    solver.add(edge);
                }
            }

            // Check that violation is unsatisfiable
            assertSame(Status.UNSATISFIABLE, solver.check());
            ctx.close();

        } catch (IOException e){
            fail("Missing resource file");
        }
    }

    // Generate set of all possible lock-to-unlock pair (can be greater than maxTupleSet of the relation)
    private Set<Tuple> mkAllTuples(Program program){
        Set<Tuple> allTuples = new HashSet<>();
        for(Event lock : program.getCache().getEvents(FilterBasic.get(EType.RCU_LOCK))){
            for(Event unlock : program.getCache().getEvents(FilterBasic.get(EType.RCU_UNLOCK))){
                allTuples.add(new Tuple(lock, unlock));
            }
        }
        return allTuples;
    }

    // Convert expected result to a set of tuples
    private Set<Tuple> mkExpectedTuples(Program program, Set<Tuple> allTuples){
        Set<Tuple> expectedTuples = new HashSet<>();
        for(Tuple tuple : allTuples){
            int id1 = tuple.getFirst().getOId();
            int id2 = tuple.getSecond().getOId();
            if(expected.containsEntry(id1, id2)){
                expectedTuples.add(tuple);
            }
        }
        return expectedTuples;
    }
}
