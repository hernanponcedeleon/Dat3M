package com.dat3m.dartagnan.program.analysis.alias;

import com.dat3m.dartagnan.configuration.Alias;
import com.dat3m.dartagnan.configuration.ProgressModel;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
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
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.program.processing.ProcessingManager;
import com.dat3m.dartagnan.verification.Context;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.Timeout;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.sosy_lab.common.configuration.Configuration;

import java.util.Collection;
import java.util.List;

import static com.dat3m.dartagnan.configuration.OptionNames.ALIAS_METHOD;

@RunWith(Parameterized.class)
public class AliasAnalysisTerminationTest {

    private static final TypeFactory types = TypeFactory.getInstance();
    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();

    @Rule
    public final Timeout timeout = Timeout.seconds(1);

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
         * P0: pointerA = *slotA; *slotB = pointerA + 8; *pointerA = 0;
         * P1: pointerB = *slotB; *slotC = pointerB + 8; *pointerB = 0;
         * P2: pointerC = *slotC; *slotA = pointerC + 8; *pointerC = 0;
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

        Register pointerA = loadAndIncrease(builder, 0, "pointerA", slotA, slotB);
        Register pointerB = loadAndIncrease(builder, 1, "pointerB", slotB, slotC);
        Register pointerC = loadAndIncrease(builder, 2, "pointerC", slotC, slotA);
        Store indirectA = addStore(builder, 0, pointerA);
        Store indirectB = addStore(builder, 1, pointerB);
        Store indirectC = addStore(builder, 2, pointerC);
        Store atX = addStore(builder, 0, x);
        Store atY = addStore(builder, 1, y);
        Store atZ = addStore(builder, 2, z);

        analyze(builder.build(), indirectA, indirectB, indirectC, atX, atY, atZ);
    }

    private Register loadAndIncrease(ProgramBuilder builder, int threadId, String name,
            MemoryObject source, MemoryObject destination) {
        Register pointer = builder.getOrNewRegister(threadId, name, types.getArchType());
        Expression next = expressions.makeAdd(pointer, expressions.makeValue(8, types.getArchType()));
        builder.addChildWithoutSourceLoc(threadId, EventFactory.newLoad(pointer, source));
        builder.addChildWithoutSourceLoc(threadId, EventFactory.newStore(destination, next));
        return pointer;
    }

    private Store addStore(ProgramBuilder builder, int threadId, Expression address) {
        Store store = EventFactory.newStore(address, expressions.makeZero(types.getArchType()));
        builder.addChildWithoutSourceLoc(threadId, store);
        return store;
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
                .filter(event -> event.hasEqualMetadata(original, Event.OriginalId.class))
                .findFirst()
                .orElseThrow();
    }

    private record AnalysisResult(AliasAnalysis analysis, MemoryCoreEvent[] events) {}
}
