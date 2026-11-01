package com.dat3m.dartagnan.wmm.analysis;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.RelationAnalysisMethod;
import com.dat3m.dartagnan.frontend.cat.ParserCat;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.analysis.alias.AliasAnalysis;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.MemoryCoreEvent;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.task.Context;
import com.dat3m.dartagnan.task.Task;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.axiom.Emptiness;
import com.dat3m.dartagnan.wmm.definition.Difference;
import com.dat3m.dartagnan.wmm.processing.WmmProcessingManager;
import com.dat3m.dartagnan.wmm.utils.graph.EventGraph;
import org.junit.Test;
import org.sosy_lab.common.configuration.Configuration;

import java.util.EnumSet;
import java.util.List;
import java.util.Set;

import static com.dat3m.dartagnan.configuration.OptionNames.ENABLE_EXTENDED_RELATION_ANALYSIS;
import static com.dat3m.dartagnan.configuration.OptionNames.RELATION_ANALYSIS;
import static com.dat3m.dartagnan.configuration.Property.PROGRAM_SPEC;
import static com.dat3m.dartagnan.test.ResourceHelper.getRootPath;
import static com.dat3m.dartagnan.test.ResourceHelper.getTestResourcePath;
import static com.dat3m.dartagnan.test.TestHelper.parseProgram;
import static com.dat3m.dartagnan.test.TestHelper.parseWmm;
import static com.dat3m.dartagnan.task.SMTModelChecker.*;
import static org.junit.Assert.*;

public class InvariantBoundsTest {

    @Test
    public void boundsFromInvariants() throws Exception {
        final Wmm wmm = parseWmm(getRootPath("cat/rc11.cat"));
        WmmProcessingManager.newInstance().run(wmm);
        final InvariantBounds bounds = InvariantBounds.fromInvariants(wmm);
        final Relation loc = wmm.getRelation("loc");
        final Relation eco = wmm.getRelation("eco");

        assertEquals(Set.of(loc, eco), bounds.getBounds(wmm.getRelation("fr")));
        // Only loc is known before fr is computed (eco depends on fr)
        assertEquals(Set.of(loc), bounds.getComputedBeforeBounds(wmm.getRelation("fr")));
    }

    /*
        A write through a pointer that may point to x or y may alias both a read of x and a write to y.
        Without knowing that fr is contained in loc, (rf^-1;co) would relate the read of x with the write to y.
     */
    @Test
    public void composedRelationsRespectAliasing() throws Exception {
        for (RelationAnalysisMethod method : List.of(RelationAnalysisMethod.NATIVE, RelationAnalysisMethod.LAZY)) {
            final Wmm wmm = parseWmm(getRootPath("cat/rc11.cat"));
            final Analyzed a = analyze("relation-analysis/loc-composition.ll", wmm, method, false);

            // The program has a read and a write that cannot alias, but which are related by
            // the may-sets of rf^-1 and co via a write through a pointer.
            final EventGraph mayRf = a.ra.getKnowledge(wmm.getRelation("rf")).getMaySet();
            final EventGraph mayCo = a.ra.getKnowledge(wmm.getRelation("co")).getMaySet();
            final boolean hasNonAliasingComposition = a.program.getThreadEvents(Load.class).stream().anyMatch(r ->
                    a.program.getThreadEvents(Store.class).stream().anyMatch(w -> !a.alias.mayAlias(r, w)
                            && mayRf.getDomain().stream().anyMatch(w1 -> mayRf.contains(w1, r) && mayCo.contains(w1, w))));
            assertTrue("Test program does not exercise the restriction", hasNonAliasingComposition);

            for (Relation rel : List.of(wmm.getRelation("fr"), wmm.getRelation("rf"), wmm.getRelation("co"))) {
                final EventGraph may = a.ra.getKnowledge(rel).getMaySet();
                may.apply((Event e1, Event e2) -> assertTrue(method + ": " + rel + " relates non-aliasing events",
                        e1 instanceof MemoryCoreEvent m1 && e2 instanceof MemoryCoreEvent m2 && a.alias.mayAlias(m1, m2)));
            }
        }
    }

    /*
        After the (extended) relation analysis, the may-set of every relation is contained
        in the may-set of each of its invariant bounds.
     */
    @Test
    public void mayRespectsBoundsAfterExtendedAnalysis() throws Exception {
        for (String model : List.of("cat/rc11.cat", "cat/vmm.cat")) {
            for (String program : List.of("relation-analysis/loc-composition.ll", "lfds/treiber.ll")) {
                final Wmm wmm = parseWmm(getRootPath(model));
                final Analyzed a = analyze(program, wmm, RelationAnalysisMethod.NATIVE, true);
                final InvariantBounds bounds = InvariantBounds.fromInvariants(wmm);
                for (Relation r : wmm.getRelations()) {
                    final EventGraph may = a.ra.getKnowledge(r).getMaySet();
                    for (Relation t : bounds.getBounds(r)) {
                        final EventGraph boundMay = a.ra.getKnowledge(t).getMaySet();
                        may.apply((e1, e2) -> assertTrue(String.format("%s/%s: %s not within bound %s",
                                model, program, r, t), boundMay.contains(e1, e2)));
                    }
                }
            }
        }
    }

    /*
        An invariant that is not inferred (yet): since every read reads from a single write,
        rf;rf^-1 is contained in the identity. The extended analysis uses it to prune rf;rf^-1.
        This mimics a future pass that adds invariants other than transitive bounds.
     */
    @Test
    public void nonTransitiveInvariantPrunesMaySet() throws Exception {
        final String model = """
                let w2 = rf;rf^-1
                acyclic po | rf | co | fr
                empty w2 \\ w2
                """;
        final Wmm without = new ParserCat().parse(model);
        final Analyzed a = analyze("lfds/treiber.ll", without, RelationAnalysisMethod.NATIVE, true);
        final EventGraph mayWithout = a.ra.getKnowledge(without.getRelation("w2")).getMaySet();
        assertTrue("Test program does not exercise the invariant",
                mayWithout.getDomain().stream().anyMatch(e -> mayWithout.getRange(e).stream().anyMatch(f -> e != f)));

        final Wmm with = new ParserCat().parse(model);
        final Relation diff = with.addDefinition(new Difference(with.newRelation(), with.getRelation("w2"),
                with.getOrCreatePredefinedRelation("id")));
        with.addConstraint(new Emptiness(diff, false, false, true));
        final Analyzed b = analyze("lfds/treiber.ll", with, RelationAnalysisMethod.NATIVE, true);
        final EventGraph mayWith = b.ra.getKnowledge(with.getRelation("w2")).getMaySet();
        assertFalse(mayWith.isEmpty());
        mayWith.apply((e1, e2) -> assertSame(e1, e2));
    }

    /*
        The helper relations of invariants may be differences whose minuend relates invisible events
        (e.g. idd ⊆ idd+). Their may-sets must be representable.
     */
    @Test
    public void differenceWithInvisibleEvents() throws Exception {
        final Wmm wmm = new ParserCat().parse("""
                let d = __idd \\ loc
                empty d
                """);
        final Analyzed a = analyze("lfds/treiber.ll", wmm, RelationAnalysisMethod.NATIVE, false);
        assertFalse(a.ra.getKnowledge(wmm.getRelation("d")).getMaySet().isEmpty());
    }

    private record Analyzed(Program program, RelationAnalysis ra, AliasAnalysis alias) {}

    private Analyzed analyze(String programPath, Wmm wmm, RelationAnalysisMethod method, boolean extended)
            throws Exception {
        final Program program = parseProgram(getTestResourcePath(programPath));
        final Configuration config = Configuration.builder()
                .setOption(RELATION_ANALYSIS, method.toString())
                .setOption(ENABLE_EXTENDED_RELATION_ANALYSIS, Boolean.toString(extended))
                .build();
        final Task task = Task.builder()
                .withConfig(config)
                .withBound(1)
                .withTarget(Arch.C11)
                .build(program, wmm, EnumSet.of(PROGRAM_SPEC));
        preprocessProgram(task, config);
        preprocessMemoryModel(task);
        final Context context = Context.create();
        performStaticProgramAnalyses(task, context, config);
        performStaticWmmAnalyses(task, context, config);
        return new Analyzed(program, context.requires(RelationAnalysis.class), context.requires(AliasAnalysis.class));
    }
}
