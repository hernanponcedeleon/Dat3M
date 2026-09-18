package com.dat3m.dartagnan.program.analysis.alias;

import com.dat3m.dartagnan.configuration.Alias;
import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.ProgressModel;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.ArrayType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.BranchEquivalence;
import com.dat3m.dartagnan.program.analysis.EventDomainRepository;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.analysis.ReachingDefinitionsAnalysis;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.program.event.core.Alloc;
import com.dat3m.dartagnan.program.event.core.Dealloc;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.Local;
import com.dat3m.dartagnan.program.event.core.MemoryCoreEvent;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.event.core.threading.ThreadArgument;
import com.dat3m.dartagnan.program.event.core.threading.ThreadCreate;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.verification.Context;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.sosy_lab.common.configuration.Configuration;

import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Set;

import static com.dat3m.dartagnan.configuration.OptionNames.ALIAS_METHOD;
import static com.dat3m.dartagnan.program.event.EventFactory.newJump;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

@RunWith(Parameterized.class)
public class AliasAnalysisEdgeCaseSoundnessTest {

    private static final TypeFactory types = TypeFactory.getInstance();
    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();

    @Parameterized.Parameters(name = "{0}")
    public static Collection<Alias> methods() {
        return List.of(Alias.values());
    }

    @Parameterized.Parameter
    public Alias method;

    @Test
    public void loopCarriedForwardDefinitionIsNotLost() throws Exception {
        /*
         * P0:
         *   carried = &x;
         * loop: pointer = carried; carried = &y;
         *   if (condition != 0) goto loop;
         *   *pointer = 0;
         */
        ProgramBuilder builder = ProgramBuilder.forLanguage(Program.SourceLanguage.LITMUS);
        MemoryObject x = builder.newMemoryObject("x", 8);
        MemoryObject y = builder.newMemoryObject("y", 8);
        builder.newThread(0);

        IntegerType type = types.getArchType();
        Register condition = builder.getOrNewRegister(0, "condition", type);
        Register carried = builder.getOrNewRegister(0, "carried", type);
        Register pointer = builder.getOrNewRegister(0, "pointer", type);
        Local conditionWriter = EventFactory.newLocal(condition, builder.newConstant(type));
        Local initialWriter = EventFactory.newLocal(carried, x);
        builder.addChildWithoutSourceLoc(0, conditionWriter);
        builder.addChildWithoutSourceLoc(0, initialWriter);
        Label loop = builder.getOrCreateLabel(0, "loop");
        builder.addChildWithoutSourceLoc(0, loop);
        Local pointerWriter = EventFactory.newLocal(pointer, carried);
        Local loopWriter = EventFactory.newLocal(carried, y);
        builder.addChildWithoutSourceLoc(0, pointerWriter);
        builder.addChildWithoutSourceLoc(0, loopWriter);
        builder.addChildWithoutSourceLoc(0,
                newJump(expressions.makeNEQ(condition, expressions.makeZero(type)), loop));
        Store indirect = addStore(builder, pointer);
        Store atX = addStore(builder, x);
        Store atY = addStore(builder, y);

        Program program = builder.build();
        ReachingDefinitionsAnalysis definitions = definitions(Map.of(
                condition, List.of(conditionWriter),
                carried, List.of(initialWriter, loopWriter),
                pointer, List.of(pointerWriter)));
        AliasAnalysis analysis = analyze(program, definitions);

        assertMayButNotMust(analysis, indirect, atX);
        assertMayButNotMust(analysis, indirect, atY);
        assertContains(analysis.addressableObjects(indirect), x, y);
    }

    @Test
    public void integerSizeCastsDoNotLosePossibleAliases() throws Exception {
        /*
         * P0:
         *   zeroExtended = zext128(&x); signExtended = sext128(&x);
         *   truncated = trunc32(&x); roundTrip = zext64(truncated);
         *   Dereference every result and compare it with a direct access to x.
         */
        ProgramBuilder builder = ProgramBuilder.forLanguage(Program.SourceLanguage.LITMUS);
        MemoryObject x = builder.newMemoryObject("x", 8);
        builder.newThread(0);

        IntegerType i32 = types.getIntegerType(32);
        IntegerType i64 = types.getArchType();
        IntegerType i128 = types.getIntegerType(128);
        Register zeroExtended = addCast(builder, "zeroExtended", x, i128, false);
        Register signExtended = addCast(builder, "signExtended", x, i128, true);
        Register truncated = addCast(builder, "truncated", x, i32, false);
        Register roundTrip = addCast(builder, "roundTrip", truncated, i64, false);
        Store throughZeroExtension = addStore(builder, zeroExtended);
        Store throughSignExtension = addStore(builder, signExtended);
        Store throughTruncation = addStore(builder, truncated);
        Store throughRoundTrip = addStore(builder, roundTrip);
        Store direct = addStore(builder, x);

        AliasAnalysis analysis = analyze(builder.build());

        assertMayAlias(analysis, throughZeroExtension, direct);
        assertMayButNotMust(analysis, throughSignExtension, direct);
        assertMayButNotMust(analysis, throughTruncation, direct);
        assertMayButNotMust(analysis, throughRoundTrip, direct);
        assertContains(analysis.addressableObjects(throughZeroExtension), x);
        assertContains(analysis.addressableObjects(throughSignExtension), x);
        assertContains(analysis.addressableObjects(throughTruncation), x);
        assertContains(analysis.addressableObjects(throughRoundTrip), x);
    }

    @Test
    public void boundsReductionDoesNotLoseBoundaryAliases() throws Exception {
        /*
         * P0:
         *   first = &x + index * 16; last = &x + 8 + index * 16;
         *   interior = &x + 8; recoveredBase = interior - 8;
         *   Dereference first, last, and recoveredBase for a 16-byte object x.
         */
        ProgramBuilder builder = ProgramBuilder.forLanguage(Program.SourceLanguage.LITMUS);
        MemoryObject x = builder.newMemoryObject("x", 16);
        builder.newThread(0);

        IntegerType type = types.getArchType();
        Register index = builder.getOrNewRegister(0, "index", type);
        Register firstOrOutOfBounds = builder.getOrNewRegister(0, "firstOrOutOfBounds", type);
        Register lastOrOutOfBounds = builder.getOrNewRegister(0, "lastOrOutOfBounds", type);
        Register interior = builder.getOrNewRegister(0, "interior", type);
        Register recoveredBase = builder.getOrNewRegister(0, "recoveredBase", type);
        builder.addChildWithoutSourceLoc(0, EventFactory.newLocal(index, builder.newConstant(type)));
        Expression stride = expressions.makeMul(index, expressions.makeValue(16, type));
        builder.addChildWithoutSourceLoc(0,
                EventFactory.newLocal(firstOrOutOfBounds, expressions.makeAdd(x, stride)));
        Expression last = expressions.makeAdd(x, expressions.makeValue(8, type));
        builder.addChildWithoutSourceLoc(0,
                EventFactory.newLocal(lastOrOutOfBounds, expressions.makeAdd(last, stride)));
        builder.addChildWithoutSourceLoc(0, EventFactory.newLocal(interior, last));
        builder.addChildWithoutSourceLoc(0, EventFactory.newLocal(
                recoveredBase, expressions.makeSub(interior, expressions.makeValue(8, type))));
        Store throughFirst = addStore(builder, firstOrOutOfBounds);
        Store throughLast = addStore(builder, lastOrOutOfBounds);
        Store throughRecoveredBase = addStore(builder, recoveredBase);
        Store atFirst = addStore(builder, x);
        Store atLast = addStore(builder, last);

        AliasAnalysis analysis = analyze(builder.build());

        assertMayAlias(analysis, throughFirst, atFirst);
        assertMayAlias(analysis, throughLast, atLast);
        assertMayAlias(analysis, throughRecoveredBase, atFirst);
        assertContains(analysis.addressableObjects(throughFirst), x);
        assertContains(analysis.addressableObjects(throughLast), x);
        assertContains(analysis.addressableObjects(throughRecoveredBase), x);
    }

    @Test
    public void replacementRedirectsAddressAndLoadEdges() throws Exception {
        /*
         * P0:
         *   loadedPointer = *address; address = &slot + 8;
         *   *loadedPointer = 0; *(&slot + 8) = &target;
         * The reaching-definition oracle models address's forward definition.
         */
        ProgramBuilder builder = ProgramBuilder.forLanguage(Program.SourceLanguage.LITMUS);
        MemoryObject slot = builder.newMemoryObject("slot", 16);
        MemoryObject target = builder.newMemoryObject("target", 8);
        builder.newThread(0);

        IntegerType type = types.getArchType();
        Register address = builder.getOrNewRegister(0, "address", type);
        Register loadedPointer = builder.getOrNewRegister(0, "loadedPointer", type);
        Load load = EventFactory.newLoad(loadedPointer, address);
        Local addressWriter = EventFactory.newLocal(
                address, expressions.makeAdd(slot, expressions.makeValue(8, type)));
        builder.addChildWithoutSourceLoc(0, load);
        builder.addChildWithoutSourceLoc(0, addressWriter);
        Store indirect = addStore(builder, loadedPointer);
        Store pointerStore = EventFactory.newStore(
                expressions.makeAdd(slot, expressions.makeValue(8, type)), target);
        builder.addChildWithoutSourceLoc(0, pointerStore);
        Store atTarget = addStore(builder, target);

        Program program = builder.build();
        AliasAnalysis analysis = analyze(program, definitions(Map.of(
                address, List.of(addressWriter),
                loadedPointer, List.of(load))));

        assertMayAlias(analysis, indirect, atTarget);
        assertContains(analysis.addressableObjects(load), slot);
        assertContains(analysis.addressableObjects(indirect), target);
        assertContains(analysis.communicableObjects(pointerStore), target);
    }

    @Test
    public void allocationAndThreadArgumentProducePointers() throws Exception {
        /*
         * P0: spawn P1(&argumentTarget); allocatedPointer = alloc(); *allocatedPointer = 0;
         * P1(argument): *argument = 0;
         * The allocation event is associated with the concrete object allocated.
         */
        ProgramBuilder builder = ProgramBuilder.forLanguage(Program.SourceLanguage.LITMUS);
        MemoryObject argumentTarget = builder.newMemoryObject("argumentTarget", 8);
        MemoryObject allocated = builder.newMemoryObject("allocated", 8);
        builder.newThread(0);
        Thread spawnedThread = builder.newThread(1);

        IntegerType type = types.getArchType();
        ThreadCreate create = EventFactory.newThreadCreate(List.of(argumentTarget));
        create.setSpawnedThread(spawnedThread);
        builder.addChildWithoutSourceLoc(0, create);
        Register argument = builder.getOrNewRegister(1, "argument", type);
        ThreadArgument threadArgument = EventFactory.newThreadArgument(argument, create, 0);
        builder.addChildWithoutSourceLoc(1, threadArgument);
        Store throughArgument = EventFactory.newStore(argument, expressions.makeZero(type));
        builder.addChildWithoutSourceLoc(1, throughArgument);

        Register allocatedPointer = builder.getOrNewRegister(0, "allocatedPointer", types.getPointerType());
        Alloc alloc = EventFactory.newAlloc(
                allocatedPointer, type, expressions.makeValue(1, type), false, false);
        alloc.setAllocatedObject(allocated);
        builder.addChildWithoutSourceLoc(0, alloc);
        Store throughAllocation = EventFactory.newStore(allocatedPointer, expressions.makeZero(type));
        builder.addChildWithoutSourceLoc(0, throughAllocation);
        Store atArgumentTarget = addStore(builder, argumentTarget);
        Store atAllocation = addStore(builder, allocated);

        AliasAnalysis analysis = analyze(builder.build());

        assertMayAlias(analysis, throughArgument, atArgumentTarget);
        assertMayAlias(analysis, throughAllocation, atAllocation);
        assertContains(analysis.addressableObjects(throughArgument), argumentTarget);
        assertContains(analysis.addressableObjects(throughAllocation), allocated);
    }

    @Test
    public void communicableObjectsCoverEveryValueKind() throws Exception {
        /*
         * P0:
         *   loaded = *slot; *slot = 0; *slot = &x;
         *   *slot = condition == 0 ? &x : &y; free(&x);
         * Query the values that each memory event can communicate.
         */
        ProgramBuilder builder = ProgramBuilder.forLanguage(Program.SourceLanguage.LITMUS);
        MemoryObject slot = builder.newMemoryObject("slot", 8);
        MemoryObject x = builder.newMemoryObject("x", 8);
        MemoryObject y = builder.newMemoryObject("y", 8);
        builder.newThread(0);

        IntegerType type = types.getArchType();
        Register loaded = builder.getOrNewRegister(0, "loaded", type);
        Register condition = builder.getOrNewRegister(0, "condition", type);
        builder.addChildWithoutSourceLoc(0, EventFactory.newLocal(condition, builder.newConstant(type)));
        Load load = EventFactory.newLoad(loaded, slot);
        Store scalarStore = EventFactory.newStore(slot, expressions.makeZero(type));
        Store directPointerStore = EventFactory.newStore(slot, x);
        Store choiceStore = EventFactory.newStore(slot, expressions.makeITE(
                expressions.makeEQ(condition, expressions.makeZero(type)), x, y));
        Dealloc dealloc = EventFactory.newDealloc(x);
        builder.addChildWithoutSourceLoc(0, load);
        builder.addChildWithoutSourceLoc(0, scalarStore);
        builder.addChildWithoutSourceLoc(0, directPointerStore);
        builder.addChildWithoutSourceLoc(0, choiceStore);
        builder.addChildWithoutSourceLoc(0, dealloc);

        AliasAnalysis analysis = analyze(builder.build());

        assertContains(analysis.communicableObjects(load), slot, x, y);
        assertContains(analysis.communicableObjects(scalarStore), slot, x, y);
        assertEquals(Set.of(x), Set.copyOf(analysis.communicableObjects(directPointerStore)));
        assertEquals(Set.of(x, y), Set.copyOf(analysis.communicableObjects(choiceStore)));
        assertTrue(analysis.communicableObjects(dealloc).isEmpty());
    }

    @Test
    public void mixedSizeDetectionHandlesIndirectSharedBases() throws Exception {
        /*
         * P0:
         *   pointer = condition == 0 ? &x : &y;
         *   store64(pointer, 0); store8(&x + 4, 0);
         * If pointer selects x, offset 4 is a mixed-size overlap point of the wide access.
         */
        ProgramBuilder builder = ProgramBuilder.forLanguage(Program.SourceLanguage.LITMUS);
        MemoryObject x = builder.newMemoryObject("x", 16);
        MemoryObject y = builder.newMemoryObject("y", 16);
        builder.newThread(0);

        IntegerType type = types.getArchType();
        Register condition = builder.getOrNewRegister(0, "condition", type);
        Register pointer = builder.getOrNewRegister(0, "pointer", type);
        builder.addChildWithoutSourceLoc(0, EventFactory.newLocal(condition, builder.newConstant(type)));
        builder.addChildWithoutSourceLoc(0, EventFactory.newLocal(pointer, expressions.makeITE(
                expressions.makeEQ(condition, expressions.makeZero(type)), x, y)));
        Store wide = EventFactory.newStore(pointer, expressions.makeZero(type));
        Store narrow = EventFactory.newStore(
                expressions.makeAdd(x, expressions.makeValue(4, type)), expressions.makeFalse());
        builder.addChildWithoutSourceLoc(0, wide);
        builder.addChildWithoutSourceLoc(0, narrow);

        AliasAnalysis analysis = analyze(builder.build(), true);

        assertTrue(analysis.mayMixedSizeAccesses(wide).contains(4));
        assertTrue(analysis.mayMixedSizeAccesses(narrow).isEmpty());
    }

    @Test
    public void nestedAggregateExtractionDoesNotLoseTheSelectedPointer() throws Exception {
        /*
         * P0:
         *   aggregate = [[&x, &x], [&y, &y]];
         *   pointer = aggregate[0][1]; *pointer = 0;
         */
        // Regression: each index was previously applied to the original outer aggregate. Thus, extracting [0, 1]
        // incorrectly followed outer[1] instead of outer[0][1], losing the actual target from the points-to set.
        ProgramBuilder builder = ProgramBuilder.forLanguage(Program.SourceLanguage.LITMUS);
        MemoryObject x = builder.newMemoryObject("x", 8);
        MemoryObject y = builder.newMemoryObject("y", 8);
        builder.newThread(0);

        IntegerType type = types.getArchType();
        ArrayType innerType = types.getArrayType(type, 2);
        ArrayType outerType = types.getArrayType(innerType, 2);
        Expression innerX = expressions.makeArray(innerType, List.of(x, x));
        Expression innerY = expressions.makeArray(innerType, List.of(y, y));
        Register aggregate = builder.getOrNewRegister(0, "aggregate", outerType);
        Register pointer = builder.getOrNewRegister(0, "pointer", type);
        builder.addChildWithoutSourceLoc(0, EventFactory.newLocal(
                aggregate, expressions.makeArray(outerType, List.of(innerX, innerY))));
        builder.addChildWithoutSourceLoc(0, EventFactory.newLocal(
                pointer, expressions.makeExtract(aggregate, List.of(0, 1))));
        Store indirect = addStore(builder, pointer);
        Store atX = addStore(builder, x);
        Store atY = addStore(builder, y);

        AliasAnalysis analysis = analyze(builder.build());

        assertMayAlias(analysis, indirect, atX);
        assertFalse(analysis.mustAlias(indirect, atY));
        assertContains(analysis.addressableObjects(indirect), x);
    }

    @Test
    public void pointerCommunicationThroughDynamicOffsetDoesNotLoseTargets() throws Exception {
        /*
         * P0:
         *   address = &slot + index * 8; pointer = *address;
         *   *pointer = 0; *(&slot + 8) = &target;
         * The index value selecting slot+8 makes pointer equal &target.
         */
        ProgramBuilder builder = ProgramBuilder.forLanguage(Program.SourceLanguage.LITMUS);
        MemoryObject slot = builder.newMemoryObject("slot", 16);
        MemoryObject target = builder.newMemoryObject("target", 8);
        builder.newThread(0);

        IntegerType type = types.getArchType();
        Register index = builder.getOrNewRegister(0, "index", type);
        Register address = builder.getOrNewRegister(0, "address", type);
        Register pointer = builder.getOrNewRegister(0, "pointer", type);
        builder.addChildWithoutSourceLoc(0, EventFactory.newLocal(index, builder.newConstant(type)));
        builder.addChildWithoutSourceLoc(0, EventFactory.newLocal(address, expressions.makeAdd(
                slot, expressions.makeMul(index, expressions.makeValue(8, type)))));
        Load load = EventFactory.newLoad(pointer, address);
        builder.addChildWithoutSourceLoc(0, load);
        Store indirect = addStore(builder, pointer);
        Store pointerStore = EventFactory.newStore(
                expressions.makeAdd(slot, expressions.makeValue(8, type)), target);
        builder.addChildWithoutSourceLoc(0, pointerStore);
        Store atTarget = addStore(builder, target);

        AliasAnalysis analysis = analyze(builder.build());

        assertMayAlias(analysis, indirect, atTarget);
        assertContains(analysis.addressableObjects(indirect), target);
    }

    private Register addCast(ProgramBuilder builder, String name, Expression operand,
            IntegerType targetType, boolean signed) {
        Register register = builder.getOrNewRegister(0, name, targetType);
        builder.addChildWithoutSourceLoc(0,
                EventFactory.newLocal(register, expressions.makeIntegerCast(operand, targetType, signed)));
        return register;
    }

    private Store addStore(ProgramBuilder builder, Expression address) {
        Store store = EventFactory.newStore(address, expressions.makeZero(types.getArchType()));
        builder.addChildWithoutSourceLoc(0, store);
        return store;
    }

    private AliasAnalysis analyze(Program program) throws Exception {
        return analyze(program, false);
    }

    private AliasAnalysis analyze(Program program, boolean detectMixedSizeAccesses) throws Exception {
        Configuration configuration = Configuration.builder()
                .setOption(ALIAS_METHOD, method.asStringOption())
                .build();
        program.setArch(Arch.C11);
        program.markAsUnrolled(1);
        program.markAsCompiled();
        Context context = Context.create();
        context.register(EventDomainRepository.class, EventDomainRepository.forProgram(program));
        context.register(BranchEquivalence.class, BranchEquivalence.fromConfig(program, configuration));
        context.register(ExecutionAnalysis.class, ExecutionAnalysis.fromConfig(
                program, ProgressModel.uniform(ProgressModel.FAIR), context, configuration));
        context.register(ReachingDefinitionsAnalysis.class,
                ReachingDefinitionsAnalysis.fromConfig(program, context, configuration));
        return AliasAnalysis.fromConfig(program, context, configuration, detectMixedSizeAccesses);
    }

    private AliasAnalysis analyze(Program program, ReachingDefinitionsAnalysis definitions) throws Exception {
        Configuration configuration = Configuration.builder()
                .setOption(ALIAS_METHOD, method.asStringOption())
                .build();
        program.setArch(Arch.C11);
        program.markAsCompiled();
        Context context = Context.create();
        context.register(ReachingDefinitionsAnalysis.class, definitions);
        return AliasAnalysis.fromConfig(program, context, configuration, false);
    }

    private ReachingDefinitionsAnalysis definitions(Map<Register, List<RegWriter>> writers) {
        return new ReachingDefinitionsAnalysis() {
            @Override
            public Writers getWriters(RegReader reader) {
                Set<Register> registers = reader.getRegisterReads().stream()
                        .map(Register.Read::register)
                        .collect(java.util.stream.Collectors.toSet());
                return new Writers() {
                    @Override
                    public Set<Register> getUsedRegisters() {
                        return registers;
                    }

                    @Override
                    public RegisterWriters ofRegister(Register register) {
                        List<RegWriter> definitions = writers.getOrDefault(register, List.of());
                        return new RegisterWriters() {
                            @Override
                            public boolean mustBeInitialized() {
                                return !definitions.isEmpty();
                            }

                            @Override
                            public List<RegWriter> getMayWriters() {
                                return definitions;
                            }

                            @Override
                            public List<RegWriter> getMustWriters() {
                                return definitions.size() == 1 ? definitions : List.of();
                            }
                        };
                    }
                };
            }

            @Override
            public Writers getFinalWriters() {
                throw new UnsupportedOperationException();
            }
        };
    }

    private void assertMayAlias(AliasAnalysis analysis, MemoryCoreEvent first, MemoryCoreEvent second) {
        assertTrue(analysis.mayAlias(first, second));
        assertTrue(analysis.mayAlias(second, first));
    }

    private void assertMayButNotMust(AliasAnalysis analysis, MemoryCoreEvent first, MemoryCoreEvent second) {
        assertMayAlias(analysis, first, second);
        assertFalse(analysis.mustAlias(first, second));
        assertFalse(analysis.mustAlias(second, first));
    }

    private void assertContains(Collection<MemoryObject> actual, MemoryObject... expected) {
        for (MemoryObject object : expected) {
            assertTrue(actual.contains(object));
        }
    }
}
