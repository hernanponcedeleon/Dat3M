package com.dat3m.dartagnan.program.analysis.alias;

import com.dat3m.dartagnan.configuration.Alias;
import com.dat3m.dartagnan.configuration.ProgressModel;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.analysis.BranchEquivalence;
import com.dat3m.dartagnan.program.analysis.EventDomainRepository;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.analysis.ReachingDefinitionsAnalysis;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.core.MemoryCoreEvent;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.event.metadata.OriginalId;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.program.processing.ProcessingManager;
import com.dat3m.dartagnan.verification.Context;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.sosy_lab.common.configuration.Configuration;

import java.util.Collection;
import java.util.List;

import static com.dat3m.dartagnan.configuration.OptionNames.ALIAS_METHOD;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

@RunWith(Parameterized.class)
public class AliasAnalysisCyclicSoundnessTest {

    private static final TypeFactory types = TypeFactory.getInstance();
    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();

    @Parameterized.Parameters(name = "{0}")
    public static Collection<Alias> methods() {
        return List.of(Alias.values());
    }

    @Parameterized.Parameter
    public Alias method;

    @Test
    public void threeNodeCommunicationCycle() throws Exception {
        /*
         * Initially: slotA = &x; slotB = &y; slotC = &z
         * P0: pointerA = *slotA; *slotB = pointerA; *pointerA = 0;
         * P1: pointerB = *slotB; *slotC = pointerB; *pointerB = 0;
         * P2: pointerC = *slotC; *slotA = pointerC; *pointerC = 0;
         */
        ProgramBuilder builder = ProgramBuilder.forLanguage(Program.SourceLanguage.LITMUS);
        MemoryObject slotA = builder.newMemoryObject("slotA", 8);
        MemoryObject slotB = builder.newMemoryObject("slotB", 8);
        MemoryObject slotC = builder.newMemoryObject("slotC", 8);
        MemoryObject x = builder.newMemoryObject("x", 8);
        MemoryObject y = builder.newMemoryObject("y", 8);
        MemoryObject z = builder.newMemoryObject("z", 8);
        slotA.setInitialValue(0, x);
        slotB.setInitialValue(0, y);
        slotC.setInitialValue(0, z);
        builder.newThread(0);
        builder.newThread(1);
        builder.newThread(2);

        Register pointerA = loadAndForward(builder, 0, "pointerA", slotA, slotB);
        Register pointerB = loadAndForward(builder, 1, "pointerB", slotB, slotC);
        Register pointerC = loadAndForward(builder, 2, "pointerC", slotC, slotA);
        Store indirectA = addStore(builder, 0, pointerA);
        Store indirectB = addStore(builder, 1, pointerB);
        Store indirectC = addStore(builder, 2, pointerC);
        Store atX = addStore(builder, 0, x);
        Store atY = addStore(builder, 1, y);
        Store atZ = addStore(builder, 2, z);

        AnalysisResult result = analyze(builder.build(),
                indirectA, indirectB, indirectC, atX, atY, atZ);
        for (int indirect = 0; indirect < 3; indirect++) {
            for (int direct = 3; direct < 6; direct++) {
                assertMayButNotMust(result.analysis, result.event(indirect), result.event(direct));
            }
        }
        assertMayButNotMust(result.analysis, result.event(0), result.event(1));
        assertMayButNotMust(result.analysis, result.event(0), result.event(2));
        assertMayButNotMust(result.analysis, result.event(1), result.event(2));
    }

    @Test
    public void offsetBearingCommunicationCycle() throws Exception {
        /*
         * Initially: slotA = &x; slotB = &y + 8
         * P0: pointer = *slotA; shifted = pointer + 8; *slotB = shifted;
         * P1: shifted = *slotB; pointer = shifted - 8; *slotA = pointer;
         * Both the base pointers and their +8 variants are subsequently dereferenced.
         */
        ProgramBuilder builder = ProgramBuilder.forLanguage(Program.SourceLanguage.LITMUS);
        MemoryObject slotA = builder.newMemoryObject("slotA", 8);
        MemoryObject slotB = builder.newMemoryObject("slotB", 8);
        MemoryObject x = builder.newMemoryObject("x", 32);
        MemoryObject y = builder.newMemoryObject("y", 32);
        IntegerType type = types.getArchType();
        Expression xPlusEight = add(x, 8);
        Expression yPlusEight = add(y, 8);
        slotA.setInitialValue(0, x);
        slotB.setInitialValue(0, yPlusEight);
        builder.newThread(0);
        builder.newThread(1);

        Register pointer = builder.getOrNewRegister(0, "pointer", type);
        Register pointerPlusEight = builder.getOrNewRegister(0, "pointerPlusEight", type);
        builder.addChildWithoutSourceLoc(0, EventFactory.newLoad(pointer, slotA));
        builder.addChildWithoutSourceLoc(0,
                EventFactory.newLocal(pointerPlusEight, add(pointer, 8)));
        builder.addChildWithoutSourceLoc(0, EventFactory.newStore(slotB, pointerPlusEight));
        Store throughPointer = addStore(builder, 0, pointer);
        Store throughPointerPlusEight = addStore(builder, 0, pointerPlusEight);

        Register shiftedPointer = builder.getOrNewRegister(1, "shiftedPointer", type);
        Register shiftedPointerMinusEight = builder.getOrNewRegister(1, "shiftedPointerMinusEight", type);
        builder.addChildWithoutSourceLoc(1, EventFactory.newLoad(shiftedPointer, slotB));
        builder.addChildWithoutSourceLoc(1,
                EventFactory.newLocal(shiftedPointerMinusEight, add(shiftedPointer, -8)));
        builder.addChildWithoutSourceLoc(1, EventFactory.newStore(slotA, shiftedPointerMinusEight));
        Store throughShiftedPointer = addStore(builder, 1, shiftedPointer);
        Store throughShiftedPointerMinusEight = addStore(builder, 1, shiftedPointerMinusEight);

        Store atX = addStore(builder, 0, x);
        Store atY = addStore(builder, 1, y);
        Store atXPlusEight = addStore(builder, 0, xPlusEight);
        Store atYPlusEight = addStore(builder, 1, yPlusEight);

        AnalysisResult result = analyze(builder.build(),
                throughPointer, throughPointerPlusEight,
                throughShiftedPointer, throughShiftedPointerMinusEight,
                atX, atY, atXPlusEight, atYPlusEight);

        assertMayBothButNotMust(result.analysis, result.event(0), result.event(4), result.event(5));
        assertMayBothButNotMust(result.analysis, result.event(3), result.event(4), result.event(5));
        assertMayBothButNotMust(result.analysis, result.event(1), result.event(6), result.event(7));
        assertMayBothButNotMust(result.analysis, result.event(2), result.event(6), result.event(7));
        assertMayButNotMust(result.analysis, result.event(0), result.event(3));
        assertMayButNotMust(result.analysis, result.event(1), result.event(2));
    }

    private Register loadAndForward(ProgramBuilder builder, int threadId, String name,
            MemoryObject source, MemoryObject destination) {
        Register pointer = builder.getOrNewRegister(threadId, name, types.getArchType());
        builder.addChildWithoutSourceLoc(threadId, EventFactory.newLoad(pointer, source));
        builder.addChildWithoutSourceLoc(threadId, EventFactory.newStore(destination, pointer));
        return pointer;
    }

    private Store addStore(ProgramBuilder builder, int threadId, Expression address) {
        Store store = EventFactory.newStore(address, expressions.makeZero(types.getArchType()));
        builder.addChildWithoutSourceLoc(threadId, store);
        return store;
    }

    private Expression add(Expression expression, long offset) {
        return expressions.makeAdd(expression, expressions.makeValue(offset, types.getArchType()));
    }

    private AnalysisResult analyze(Program program, Event... originalEvents) throws Exception {
        Configuration configuration = Configuration.builder()
                .setOption(ALIAS_METHOD, method.asStringOption())
                .build();
        ProcessingManager.fromConfig(configuration).run(program);
        Context context = Context.create();
        context.register(EventDomainRepository.class, EventDomainRepository.forProgram(program));
        context.register(BranchEquivalence.class, BranchEquivalence.fromConfig(program, configuration));
        context.register(ExecutionAnalysis.class, ExecutionAnalysis.fromConfig(
                program, ProgressModel.uniform(ProgressModel.FAIR), context, configuration));
        context.register(ReachingDefinitionsAnalysis.class,
                ReachingDefinitionsAnalysis.fromConfig(program, context, configuration));
        AliasAnalysis analysis = AliasAnalysis.fromConfig(program, context, configuration, false);
        MemoryCoreEvent[] events = java.util.Arrays.stream(originalEvents)
                .map(original -> findProcessedEvent(program, original))
                .toArray(MemoryCoreEvent[]::new);
        return new AnalysisResult(analysis, events);
    }

    private MemoryCoreEvent findProcessedEvent(Program program, Event original) {
        return (MemoryCoreEvent) program.getThreadEvents().stream()
                .filter(event -> event.hasEqualMetadata(original, OriginalId.class))
                .findFirst()
                .orElseThrow();
    }

    private void assertMayBothButNotMust(AliasAnalysis analysis,
            MemoryCoreEvent event, MemoryCoreEvent first, MemoryCoreEvent second) {
        assertMayButNotMust(analysis, event, first);
        assertMayButNotMust(analysis, event, second);
    }

    private void assertMayButNotMust(AliasAnalysis analysis,
            MemoryCoreEvent first, MemoryCoreEvent second) {
        assertTrue(analysis.mayAlias(first, second));
        assertTrue(analysis.mayAlias(second, first));
        assertFalse(analysis.mustAlias(first, second));
        assertFalse(analysis.mustAlias(second, first));
    }

    private record AnalysisResult(AliasAnalysis analysis, MemoryCoreEvent[] events) {
        private MemoryCoreEvent event(int index) {
            return events[index];
        }
    }
}
