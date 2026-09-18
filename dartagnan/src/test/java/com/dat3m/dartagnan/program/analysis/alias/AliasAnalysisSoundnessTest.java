package com.dat3m.dartagnan.program.analysis.alias;

import com.dat3m.dartagnan.configuration.Alias;
import com.dat3m.dartagnan.configuration.ProgressModel;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.ArrayType;
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
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.Load;
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
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.util.Collection;
import java.util.List;

import static com.dat3m.dartagnan.configuration.OptionNames.ALIAS_METHOD;
import static com.dat3m.dartagnan.program.event.EventFactory.newJump;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

@RunWith(Parameterized.class)
public class AliasAnalysisSoundnessTest {

    private static final TypeFactory types = TypeFactory.getInstance();
    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();

    @Parameterized.Parameters(name = "{0}")
    public static Collection<Alias> methods() {
        return java.util.List.of(Alias.values());
    }

    @Parameterized.Parameter
    public Alias method;

    @Test
    public void conditionalRegisterDefinitionMayAliasEitherObject() throws InvalidConfigurationException {
        /*
         * P0:
         *   condition = nondet; pointer = &x; *pointer = 0;
         *   if (condition != 0) pointer = &y;
         *   *pointer = 0;
         */
        ProgramBuilder builder = ProgramBuilder.forLanguage(Program.SourceLanguage.LITMUS);
        MemoryObject x = builder.newMemoryObject("x", 8);
        MemoryObject y = builder.newMemoryObject("y", 8);
        builder.newThread(0);

        IntegerType type = types.getArchType();
        Register condition = builder.getOrNewRegister(0, "condition", type);
        Register pointer = builder.getOrNewRegister(0, "pointer", type);
        builder.addChildWithoutSourceLoc(0, EventFactory.newLocal(condition, builder.newConstant(type)));
        builder.addChildWithoutSourceLoc(0, EventFactory.newLocal(pointer, x));
        Store before = EventFactory.newStore(pointer, expressions.makeZero(type));
        builder.addChildWithoutSourceLoc(0, before);
        Label use = builder.getOrCreateLabel(0, "use");
        builder.addChildWithoutSourceLoc(0,
                newJump(expressions.makeEQ(condition, expressions.makeZero(type)), use));
        builder.addChildWithoutSourceLoc(0, EventFactory.newLocal(pointer, y));
        builder.addChildWithoutSourceLoc(0, use);
        Store after = EventFactory.newStore(pointer, expressions.makeZero(type));
        builder.addChildWithoutSourceLoc(0, after);
        Store atX = EventFactory.newStore(x, expressions.makeZero(type));
        Store atY = EventFactory.newStore(y, expressions.makeZero(type));
        builder.addChildWithoutSourceLoc(0, atX);
        builder.addChildWithoutSourceLoc(0, atY);

        AnalysisResult result = analyze(builder.build(), before, after, atX, atY);
        MemoryCoreEvent processedBefore = result.event(0);
        MemoryCoreEvent processedAfter = result.event(1);
        MemoryCoreEvent processedX = result.event(2);
        MemoryCoreEvent processedY = result.event(3);

        assertMayButNotMust(result.analysis, processedBefore, processedAfter);
        assertMayButNotMust(result.analysis, processedAfter, processedX);
        assertMayButNotMust(result.analysis, processedAfter, processedY);
        assertContains(result.analysis.addressableObjects(processedAfter), x, y);
    }

    @Test
    public void pointerLoadedFromSharedMemoryMayComeFromEitherWrite() throws InvalidConfigurationException {
        /*
         * Initially: slot = &x
         * P0: pointer = *slot; *pointer = 0;
         * P1: *slot = &y;
         */
        ProgramBuilder builder = ProgramBuilder.forLanguage(Program.SourceLanguage.LITMUS);
        MemoryObject slot = builder.newMemoryObject("slot", 8);
        MemoryObject x = builder.newMemoryObject("x", 8);
        MemoryObject y = builder.newMemoryObject("y", 8);
        slot.setInitialValue(0, x);
        builder.newThread(0);
        builder.newThread(1);

        Register pointer = builder.getOrNewRegister(0, "pointer", types.getArchType());
        Load load = EventFactory.newLoad(pointer, slot);
        builder.addChildWithoutSourceLoc(0, load);
        Store indirect = EventFactory.newStore(pointer, expressions.makeZero(types.getArchType()));
        builder.addChildWithoutSourceLoc(0, indirect);
        Store atX = EventFactory.newStore(x, expressions.makeZero(types.getArchType()));
        Store atY = EventFactory.newStore(y, expressions.makeZero(types.getArchType()));
        builder.addChildWithoutSourceLoc(0, atX);
        builder.addChildWithoutSourceLoc(0, atY);
        builder.addChildWithoutSourceLoc(1, EventFactory.newStore(slot, y));

        AnalysisResult result = analyze(builder.build(), indirect, atX, atY);
        MemoryCoreEvent processedIndirect = result.event(0);
        MemoryCoreEvent processedX = result.event(1);
        MemoryCoreEvent processedY = result.event(2);

        assertMayButNotMust(result.analysis, processedIndirect, processedX);
        assertMayButNotMust(result.analysis, processedIndirect, processedY);
        assertContains(result.analysis.addressableObjects(processedIndirect), x, y);
    }

    @Test
    public void conditionalExpressionMayAliasEitherObject() throws InvalidConfigurationException {
        /*
         * P0:
         *   condition = nondet;
         *   pointer = condition == 0 ? &x : &y;
         *   *pointer = 0; destination = pointer;
         */
        ProgramBuilder builder = ProgramBuilder.forLanguage(Program.SourceLanguage.LITMUS);
        MemoryObject x = builder.newMemoryObject("x", 8);
        MemoryObject y = builder.newMemoryObject("y", 8);
        MemoryObject destination = builder.newMemoryObject("destination", 8);
        builder.newThread(0);

        IntegerType type = types.getArchType();
        Register condition = builder.getOrNewRegister(0, "condition", type);
        Register pointer = builder.getOrNewRegister(0, "pointer", type);
        builder.addChildWithoutSourceLoc(0, EventFactory.newLocal(condition, builder.newConstant(type)));
        Expression choice = expressions.makeITE(
                expressions.makeEQ(condition, expressions.makeZero(type)), x, y);
        builder.addChildWithoutSourceLoc(0, EventFactory.newLocal(pointer, choice));
        Store indirect = EventFactory.newStore(pointer, expressions.makeZero(type));
        Store atX = EventFactory.newStore(x, expressions.makeZero(type));
        Store atY = EventFactory.newStore(y, expressions.makeZero(type));
        Store valueStore = EventFactory.newStore(destination, pointer);
        builder.addChildWithoutSourceLoc(0, indirect);
        builder.addChildWithoutSourceLoc(0, atX);
        builder.addChildWithoutSourceLoc(0, atY);
        builder.addChildWithoutSourceLoc(0, valueStore);

        AnalysisResult result = analyze(builder.build(), indirect, atX, atY, valueStore);
        MemoryCoreEvent processedIndirect = result.event(0);
        MemoryCoreEvent processedX = result.event(1);
        MemoryCoreEvent processedY = result.event(2);
        MemoryCoreEvent processedValueStore = result.event(3);

        assertMayButNotMust(result.analysis, processedIndirect, processedX);
        assertMayButNotMust(result.analysis, processedIndirect, processedY);
        assertContains(result.analysis.addressableObjects(processedIndirect), x, y);
        assertContains(result.analysis.communicableObjects(processedValueStore), x, y);
    }

    @Test
    public void unsupportedPointerExpressionFallsBackConservatively() throws InvalidConfigurationException {
        /*
         * P0:
         *   mask = nondet; pointer = &x & mask;
         *   *pointer = 0;
         */
        ProgramBuilder builder = ProgramBuilder.forLanguage(Program.SourceLanguage.LITMUS);
        MemoryObject x = builder.newMemoryObject("x", 8);
        builder.newThread(0);

        IntegerType type = types.getArchType();
        Register mask = builder.getOrNewRegister(0, "mask", type);
        Register pointer = builder.getOrNewRegister(0, "pointer", type);
        builder.addChildWithoutSourceLoc(0, EventFactory.newLocal(mask, builder.newConstant(type)));
        builder.addChildWithoutSourceLoc(0, EventFactory.newLocal(pointer, expressions.makeIntAnd(x, mask)));
        Store indirect = EventFactory.newStore(pointer, expressions.makeZero(type));
        Store direct = EventFactory.newStore(x, expressions.makeZero(type));
        builder.addChildWithoutSourceLoc(0, indirect);
        builder.addChildWithoutSourceLoc(0, direct);

        AnalysisResult result = analyze(builder.build(), indirect, direct);
        assertMayButNotMust(result.analysis, result.event(0), result.event(1));
        assertContains(result.analysis.addressableObjects(result.event(0)), x);
    }

    @Test
    public void extractedFieldFromConditionalAggregateMayAliasEitherObject()
            throws InvalidConfigurationException {
        /*
         * P0:
         *   aggregate = [&x, &y];
         *   if (condition != 0) aggregate = [&y, &x];
         *   pointer = aggregate[0]; *pointer = 0;
         */
        ProgramBuilder builder = ProgramBuilder.forLanguage(Program.SourceLanguage.LITMUS);
        MemoryObject x = builder.newMemoryObject("x", 8);
        MemoryObject y = builder.newMemoryObject("y", 8);
        builder.newThread(0);

        IntegerType type = types.getArchType();
        ArrayType aggregateType = types.getArrayType(type, 2);
        Register condition = builder.getOrNewRegister(0, "condition", type);
        Register aggregate = builder.getOrNewRegister(0, "aggregate", aggregateType);
        Register pointer = builder.getOrNewRegister(0, "pointer", type);
        builder.addChildWithoutSourceLoc(0, EventFactory.newLocal(condition, builder.newConstant(type)));
        builder.addChildWithoutSourceLoc(0, EventFactory.newLocal(
                aggregate, expressions.makeArray(aggregateType, List.of(x, y))));
        Label use = builder.getOrCreateLabel(0, "use");
        builder.addChildWithoutSourceLoc(0,
                newJump(expressions.makeEQ(condition, expressions.makeZero(type)), use));
        builder.addChildWithoutSourceLoc(0, EventFactory.newLocal(
                aggregate, expressions.makeArray(aggregateType, List.of(y, x))));
        builder.addChildWithoutSourceLoc(0, use);
        builder.addChildWithoutSourceLoc(0,
                EventFactory.newLocal(pointer, expressions.makeExtract(aggregate, 0)));
        Store indirect = EventFactory.newStore(pointer, expressions.makeZero(type));
        Store atX = EventFactory.newStore(x, expressions.makeZero(type));
        Store atY = EventFactory.newStore(y, expressions.makeZero(type));
        builder.addChildWithoutSourceLoc(0, indirect);
        builder.addChildWithoutSourceLoc(0, atX);
        builder.addChildWithoutSourceLoc(0, atY);

        AnalysisResult result = analyze(builder.build(), indirect, atX, atY);
        assertMayButNotMust(result.analysis, result.event(0), result.event(1));
        assertMayButNotMust(result.analysis, result.event(0), result.event(2));
        assertContains(result.analysis.addressableObjects(result.event(0)), x, y);
    }

    @Test
    public void dynamicOffsetMayAliasEveryReachableElement() throws InvalidConfigurationException {
        /*
         * P0:
         *   index = nondet; pointer = &x + index * 8;
         *   *pointer = 0;
         * The valid in-bounds targets are x+0 and x+8.
         */
        ProgramBuilder builder = ProgramBuilder.forLanguage(Program.SourceLanguage.LITMUS);
        MemoryObject x = builder.newMemoryObject("x", 16);
        builder.newThread(0);

        IntegerType type = types.getArchType();
        Register index = builder.getOrNewRegister(0, "index", type);
        Register pointer = builder.getOrNewRegister(0, "pointer", type);
        builder.addChildWithoutSourceLoc(0, EventFactory.newLocal(index, builder.newConstant(type)));
        Expression offset = expressions.makeMul(index, expressions.makeValue(8, type));
        builder.addChildWithoutSourceLoc(0,
                EventFactory.newLocal(pointer, expressions.makeAdd(x, offset)));
        Store indirect = EventFactory.newStore(pointer, expressions.makeZero(type));
        Store first = EventFactory.newStore(x, expressions.makeZero(type));
        Store second = EventFactory.newStore(
                expressions.makeAdd(x, expressions.makeValue(8, type)), expressions.makeZero(type));
        builder.addChildWithoutSourceLoc(0, indirect);
        builder.addChildWithoutSourceLoc(0, first);
        builder.addChildWithoutSourceLoc(0, second);

        AnalysisResult result = analyze(builder.build(), indirect, first, second);
        assertMayButNotMust(result.analysis, result.event(0), result.event(1));
        assertMayButNotMust(result.analysis, result.event(0), result.event(2));
        assertContains(result.analysis.addressableObjects(result.event(0)), x);
    }

    @Test
    public void unknownAddressFallsBackToAllObjects() throws InvalidConfigurationException {
        /*
         * P0:
         *   *(address with no known object base) = 0;
         * The conservative fallback must retain both x and y as possible objects.
         */
        ProgramBuilder builder = ProgramBuilder.forLanguage(Program.SourceLanguage.LITMUS);
        MemoryObject x = builder.newMemoryObject("x", 8);
        MemoryObject y = builder.newMemoryObject("y", 8);
        builder.newThread(0);

        IntegerType type = types.getArchType();
        Store unknown = EventFactory.newStore(expressions.makeZero(type), expressions.makeZero(type));
        Store atX = EventFactory.newStore(x, expressions.makeZero(type));
        Store atY = EventFactory.newStore(y, expressions.makeZero(type));
        builder.addChildWithoutSourceLoc(0, unknown);
        builder.addChildWithoutSourceLoc(0, atX);
        builder.addChildWithoutSourceLoc(0, atY);

        AnalysisResult result = analyze(builder.build(), unknown, atX, atY);
        assertMayButNotMust(result.analysis, result.event(0), result.event(1));
        assertMayButNotMust(result.analysis, result.event(0), result.event(2));
        assertContains(result.analysis.addressableObjects(result.event(0)), x, y);
    }

    private AnalysisResult analyze(Program program, Event... originalEvents) throws InvalidConfigurationException {
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
        MemoryCoreEvent[] processedEvents = java.util.Arrays.stream(originalEvents)
                .map(original -> findProcessedEvent(program, original))
                .toArray(MemoryCoreEvent[]::new);
        return new AnalysisResult(analysis, processedEvents);
    }

    private MemoryCoreEvent findProcessedEvent(Program program, Event original) {
        return (MemoryCoreEvent) program.getThreadEvents().stream()
                .filter(event -> event.hasEqualMetadata(original, OriginalId.class))
                .findFirst()
                .orElseThrow();
    }

    private void assertMayButNotMust(AliasAnalysis analysis, MemoryCoreEvent first, MemoryCoreEvent second) {
        assertTrue(analysis.mayAlias(first, second));
        assertTrue(analysis.mayAlias(second, first));
        assertFalse(analysis.mustAlias(first, second));
        assertFalse(analysis.mustAlias(second, first));
    }

    private void assertContains(Collection<MemoryObject> actual, MemoryObject... expected) {
        for (MemoryObject object : expected) {
            assertTrue(actual.contains(object));
        }
    }

    private record AnalysisResult(AliasAnalysis analysis, MemoryCoreEvent[] events) {
        private MemoryCoreEvent event(int index) {
            return events[index];
        }
    }
}
