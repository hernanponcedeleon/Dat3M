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

import java.util.ArrayList;
import java.util.Collection;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

import static com.dat3m.dartagnan.configuration.OptionNames.ALIAS_METHOD;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

@RunWith(Parameterized.class)
public class AliasAnalysisSoundnessOracleTest {

    private static final TypeFactory types = TypeFactory.getInstance();
    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();

    @Parameterized.Parameters(name = "{0}")
    public static Collection<Alias> methods() {
        return List.of(Alias.values());
    }

    @Parameterized.Parameter
    public Alias method;

    @Test
    public void exhaustiveSmallDomain() throws Exception {
        /*
         * P0 contains one access for every generated pointer expression:
         *   pointer = atom | choice(atom...) | object + choice(0, 1) * 8;
         *   *pointer = 0;
         * All pairs are compared against their explicit sets of concrete (object, offset) targets.
         */
        ProgramBuilder builder = ProgramBuilder.forLanguage(Program.SourceLanguage.LITMUS);
        builder.newThread(0);
        MemoryObject x = builder.newMemoryObject("x", 32);
        MemoryObject y = builder.newMemoryObject("y", 32);
        MemoryObject z = builder.newMemoryObject("z", 32);

        List<PointerValue> atoms = List.of(
                new PointerValue(x, 0),
                new PointerValue(x, 8),
                new PointerValue(y, 0),
                new PointerValue(y, 8),
                new PointerValue(z, 0));
        List<AccessCase> accesses = new ArrayList<>();

        for (PointerValue atom : atoms) {
            accesses.add(addAccess(builder, atom.toExpression(), Set.of(atom), atom.toString()));
        }
        for (int first = 0; first < atoms.size(); first++) {
            for (int second = first + 1; second < atoms.size(); second++) {
                PointerValue left = atoms.get(first);
                PointerValue right = atoms.get(second);
                Expression choice = makeChoice(builder, left.toExpression(), right.toExpression());
                accesses.add(addAccess(builder, choice, Set.of(left, right), "choice(" + left + "," + right + ")"));
            }
        }
        for (int first = 0; first < atoms.size(); first++) {
            for (int second = first + 1; second < atoms.size(); second++) {
                for (int third = second + 1; third < atoms.size(); third++) {
                    PointerValue one = atoms.get(first);
                    PointerValue two = atoms.get(second);
                    PointerValue three = atoms.get(third);
                    Expression inner = makeChoice(builder, two.toExpression(), three.toExpression());
                    Expression choice = makeChoice(builder, one.toExpression(), inner);
                    accesses.add(addAccess(builder, choice, Set.of(one, two, three),
                            "choice(" + one + "," + two + "," + three + ")"));
                }
            }
        }
        for (MemoryObject object : List.of(x, y, z)) {
            IntegerType type = types.getArchType();
            Expression index = makeChoice(builder, expressions.makeZero(type), expressions.makeOne(type));
            Expression address = expressions.makeAdd(
                    object, expressions.makeMul(index, expressions.makeValue(8, type)));
            accesses.add(addAccess(builder, address,
                    Set.of(new PointerValue(object, 0), new PointerValue(object, 8)),
                    object.getName() + "[0..1]"));
        }

        Program program = builder.build();
        Configuration configuration = Configuration.builder()
                .setOption(ALIAS_METHOD, method.asStringOption())
                .build();
        ProcessingManager.fromConfig(configuration).run(program);
        AliasAnalysis analysis = analyze(program, configuration);
        List<AnalyzedAccess> analyzed = accesses.stream()
                .map(access -> new AnalyzedAccess(
                        findProcessedEvent(program, access.event), access.values, access.description))
                .toList();

        for (int first = 0; first < analyzed.size(); first++) {
            AnalyzedAccess left = analyzed.get(first);
            assertTrue("An event must may-alias itself: " + left.description,
                    analysis.mayAlias(left.event, left.event));
            assertTrue("An event must must-alias itself: " + left.description,
                    analysis.mustAlias(left.event, left.event));
            for (int second = first + 1; second < analyzed.size(); second++) {
                checkPair(analysis, left, analyzed.get(second));
            }
        }
    }

    private AccessCase addAccess(ProgramBuilder builder, Expression address,
            Set<PointerValue> values, String description) {
        IntegerType type = types.getArchType();
        Register pointer = builder.getOrNewRegister(0, "pointer" + nextId(), type);
        builder.addChildWithoutSourceLoc(0, EventFactory.newLocal(pointer, address));
        Store store = EventFactory.newStore(pointer, expressions.makeZero(type));
        builder.addChildWithoutSourceLoc(0, store);
        return new AccessCase(store, values, description);
    }

    private Expression makeChoice(ProgramBuilder builder, Expression first, Expression second) {
        IntegerType type = types.getArchType();
        Register condition = builder.getOrNewRegister(0, "condition" + nextId(), type);
        builder.addChildWithoutSourceLoc(0, EventFactory.newLocal(condition, builder.newConstant(type)));
        return expressions.makeITE(expressions.makeEQ(condition, expressions.makeZero(type)), first, second);
    }

    private AliasAnalysis analyze(Program program, Configuration configuration) throws Exception {
        Context context = Context.create();
        context.register(EventDomainRepository.class, EventDomainRepository.forProgram(program));
        context.register(BranchEquivalence.class, BranchEquivalence.fromConfig(program, configuration));
        context.register(ExecutionAnalysis.class, ExecutionAnalysis.fromConfig(
                program, ProgressModel.uniform(ProgressModel.FAIR), context, configuration));
        context.register(ReachingDefinitionsAnalysis.class,
                ReachingDefinitionsAnalysis.fromConfig(program, context, configuration));
        return AliasAnalysis.fromConfig(program, context, configuration, false);
    }

    private MemoryCoreEvent findProcessedEvent(Program program, Event original) {
        return (MemoryCoreEvent) program.getThreadEvents().stream()
                .filter(event -> event.hasEqualMetadata(original, OriginalId.class))
                .findFirst()
                .orElseThrow();
    }

    private void checkPair(AliasAnalysis analysis, AnalyzedAccess left, AnalyzedAccess right) {
        Set<PointerValue> intersection = new LinkedHashSet<>(left.values);
        intersection.retainAll(right.values);
        boolean exactMayAlias = !intersection.isEmpty();
        boolean exactMustAlias = left.values.size() == 1 && left.values.equals(right.values);
        String pair = left.description + " vs " + right.description;

        if (exactMayAlias) {
            assertTrue("False negative may-alias result for " + pair,
                    analysis.mayAlias(left.event, right.event));
            assertTrue("Asymmetric may-alias result for " + pair,
                    analysis.mayAlias(right.event, left.event));
        }
        if (!exactMustAlias) {
            assertFalse("False positive must-alias result for " + pair,
                    analysis.mustAlias(left.event, right.event));
            assertFalse("Asymmetric must-alias result for " + pair,
                    analysis.mustAlias(right.event, left.event));
        }
    }

    private int id;

    private int nextId() {
        return id++;
    }

    private record PointerValue(MemoryObject object, int offset) {
        private Expression toExpression() {
            return offset == 0 ? object : expressions.makeAdd(
                    object, expressions.makeValue(offset, types.getArchType()));
        }

        @Override
        public String toString() {
            return object.getName() + "+" + offset;
        }
    }

    private record AccessCase(Store event, Set<PointerValue> values, String description) { }

    private record AnalyzedAccess(MemoryCoreEvent event, Set<PointerValue> values, String description) { }
}
