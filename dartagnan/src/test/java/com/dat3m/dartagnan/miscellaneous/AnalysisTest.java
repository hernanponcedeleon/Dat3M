package com.dat3m.dartagnan.miscellaneous;

import com.dat3m.dartagnan.configuration.Alias;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Program.SourceLanguage;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.analysis.BranchEquivalence;
import com.dat3m.dartagnan.program.analysis.Dependency;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.analysis.alias.AliasAnalysis;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.metadata.OriginalId;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.program.processing.LoopUnrolling;
import com.dat3m.dartagnan.program.processing.MemoryAllocation;
import com.dat3m.dartagnan.program.processing.ProcessingManager;
import com.dat3m.dartagnan.program.processing.compilation.Compilation;
import com.dat3m.dartagnan.verification.Context;
import org.junit.Test;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.util.List;

import static com.dat3m.dartagnan.configuration.Alias.*;
import static com.dat3m.dartagnan.configuration.OptionNames.ALIAS_METHOD;
import static com.dat3m.dartagnan.program.event.EventFactory.*;
import static org.junit.Assert.*;

public class AnalysisTest {

    private enum Result {NONE, MAY, MUST}

    private static final Result NONE = Result.NONE;
    private static final Result MAY = Result.MAY;
    private static final Result MUST = Result.MUST;

    private static final TypeFactory types = TypeFactory.getInstance();
    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();

    @Test
    public void dependencyMustOverride() throws InvalidConfigurationException {
        ProgramBuilder b = ProgramBuilder.forLanguage(SourceLanguage.LITMUS);
        b.newThread(0);
        Register r0 = b.getOrNewRegister(0, "r0");
        Register r1 = b.getOrNewRegister(0, "r1");
        Register r2 = b.getOrNewRegister(0, "r2");
        Label alt = b.getOrCreateLabel(0, "alt");
        b.addChild(0, newJump(b.newConstant(types.getBooleanType()), alt));
        Local e0 = newLocal(r0, value(1));
        b.addChild(0, e0);
        Local e1 = newLocal(r1, r0);
        b.addChild(0, e1);
        Label join = b.getOrCreateLabel(0,"join");
        b.addChild(0, newGoto(join));
        b.addChild(0, alt);
        Local e2 = newLocal(r1, value(2));
        b.addChild(0, e2);
        b.addChild(0, join);
        Local e3 = newLocal(r2, r0);
        b.addChild(0, e3);
        Local e4 = newLocal(r2, r1);
        b.addChild(0, e4);
        Local e5 = newLocal(r0, r2);
        b.addChild(0, e5);

        Program program = b.build();
        Compilation.newInstance().run(program);
        LoopUnrolling.newInstance().run(program);
        MemoryAllocation.newInstance().run(program);
        Configuration config = Configuration.defaultConfiguration();
        Context context = Context.create();
        context.register(BranchEquivalence.class, BranchEquivalence.fromConfig(program, config));
        context.register(ExecutionAnalysis.class, ExecutionAnalysis.fromConfig(program, context, config));
        Dependency dep = Dependency.fromConfig(program, context, config);
        Event me0 = findMatchingEventAfterProcessing(program, e0);
        Event me1 = findMatchingEventAfterProcessing(program, e1);
        Event me2 = findMatchingEventAfterProcessing(program, e2);
        Event me3 = findMatchingEventAfterProcessing(program, e3);
        Event me4 = findMatchingEventAfterProcessing(program, e4);
        Event me5 = findMatchingEventAfterProcessing(program, e5);
        assertTrue(dep.of(me1, r0).initialized);
        assertList(dep.of(me1, r0).may, me0);
        assertList(dep.of(me1, r0).must, me0);
        assertFalse(dep.of(me3, r0).initialized);
        assertList(dep.of(me3, r0).may, me0);
        assertList(dep.of(me3, r0).must, me0);
        assertTrue(dep.of(me4, r1).initialized);
        assertList(dep.of(me4, r1).may, me1, me2);
        assertList(dep.of(me4, r1).must, me1, me2);
        assertTrue(dep.of(me5, r2).initialized);
        assertList(dep.of(me5, r2).may, me4);
        assertList(dep.of(me5, r2).must, me4);
    }

    @Test
    public void fieldsensitive0() throws InvalidConfigurationException {
        program0(FIELD_SENSITIVE, MAY, MAY, NONE, NONE, NONE, NONE);
    }

    @Test
    public void fieldinsensitive0() throws InvalidConfigurationException {
        program0(FIELD_INSENSITIVE, MAY, NONE, MAY, NONE, MAY, NONE);
    }

    @Test
    public void full0() throws InvalidConfigurationException {
        program0(FULL, NONE, MAY, NONE, NONE, NONE, NONE);
    }

    private void program0(Alias method, Result... expect) throws InvalidConfigurationException {
        ProgramBuilder b = ProgramBuilder.forLanguage(SourceLanguage.LITMUS);

        MemoryObject x = b.newMemoryObject("x", 2);
        MemoryObject y = b.newMemoryObject("y", 1);

        b.newThread(0);
        Register r0 = b.getOrNewRegister(0, "r0");
        //this is undefined behavior in C11
        //the expression does not match a sum, but x occurs in it
        b.addChild(0, newLocal(r0, mult(x, 1)));
        Store e0 = newStore(r0);
        b.addChild(0, e0);
        Store e1 = newStore(plus(r0, 1));
        b.addChild(0, e1);
        Store e2 = newStore(x);
        b.addChild(0, e2);
        Store e3 = newStore(y);
        b.addChild(0, e3);

        Program program = b.build();
        AliasAnalysis a = analyze(program, method);
        MemoryCoreEvent me0 = (MemoryCoreEvent) findMatchingEventAfterProcessing(program, e0);
        MemoryCoreEvent me1 = (MemoryCoreEvent) findMatchingEventAfterProcessing(program, e1);
        MemoryCoreEvent me2 = (MemoryCoreEvent) findMatchingEventAfterProcessing(program, e2);
        MemoryCoreEvent me3 = (MemoryCoreEvent) findMatchingEventAfterProcessing(program, e3);

        assertAlias(expect[0], a, me0, me1);//precisely no
        assertAlias(expect[1], a, me0, me2);
        assertAlias(expect[2], a, me1, me2);
        assertAlias(expect[3], a, me0, me3);
        assertAlias(expect[4], a, me1, me3);
        assertAlias(expect[5], a, me2, me3);
    }

    @Test
    public void fieldsensitive1() throws InvalidConfigurationException {
        program1(FIELD_SENSITIVE, NONE, NONE, MUST, MUST, NONE, NONE);
    }

    @Test
    public void fieldinsensitive1() throws InvalidConfigurationException {
        program1(FIELD_INSENSITIVE, NONE, NONE, MUST, MAY, MAY, MAY);
    }

    @Test
    public void full1() throws InvalidConfigurationException {
        program1(FULL, NONE, NONE, MUST, MUST, NONE, NONE);
    }

    private void program1(Alias method, Result... expect) throws InvalidConfigurationException {
        ProgramBuilder b = ProgramBuilder.forLanguage(SourceLanguage.LITMUS);
        MemoryObject x = b.newMemoryObject("x", 3);
        x.setInitialValue(0, x);

        b.newThread(0);
        Store e0 = newStore(plus(x, 1));
        b.addChild(0, e0);
        Register r0 = b.getOrNewRegister(0, "r0");
        Load e1 = newLoad(r0, x);
        b.addChild(0, e1);
        Store e2 = newStore(r0);
        b.addChild(0, e2);
        Store e3 = newStore(plus(r0, 1), r0);
        b.addChild(0, e3);

        Program program = b.build();
        AliasAnalysis a = analyze(program, method);
        MemoryCoreEvent me0 = (MemoryCoreEvent) findMatchingEventAfterProcessing(program, e0);
        MemoryCoreEvent me1 = (MemoryCoreEvent) findMatchingEventAfterProcessing(program, e1);
        MemoryCoreEvent me2 = (MemoryCoreEvent) findMatchingEventAfterProcessing(program, e2);
        MemoryCoreEvent me3 = (MemoryCoreEvent) findMatchingEventAfterProcessing(program, e3);

        assertAlias(expect[0], a, me0, me1);
        assertAlias(expect[1], a, me0, me2);
        assertAlias(expect[2], a, me1, me2);
        assertAlias(expect[3], a, me0, me3);
        assertAlias(expect[4], a, me1, me3);
        assertAlias(expect[5], a, me2, me3);
    }

    @Test
    public void fieldsensitive2() throws InvalidConfigurationException {
        program2(FIELD_SENSITIVE, NONE, NONE, NONE, MAY, NONE, MAY);
    }

    @Test
    public void fieldinsensitive2() throws InvalidConfigurationException {
        program2(FIELD_INSENSITIVE, NONE, NONE, NONE, MAY, MAY, MAY);
    }

    @Test
    public void full2() throws InvalidConfigurationException {
        program2(FULL, NONE, NONE, NONE, MAY, NONE, MAY);
    }

    private void program2(Alias method, Result... expect) throws InvalidConfigurationException {
        ProgramBuilder b = ProgramBuilder.forLanguage(SourceLanguage.LITMUS);
        IntegerType type = types.getArchType();
        MemoryObject x = b.newMemoryObject("x", 3);

        b.newThread(0);
        Register r0 = b.getOrNewRegister(0, "r0");
        b.addChild(0, newLocal(r0, b.newConstant(type)));
        Label l0 = b.getOrCreateLabel(0,"l0");
        b.addChild(0, newJump(expressions.makeOr(
                expressions.makeGT(r0, expressions.makeOne(type), true),
                expressions.makeLT(r0, expressions.makeZero(type), true)), l0));
        Store e0 = newStore(x);
        b.addChild(0, e0);
        Store e1 = newStore(plus(x, 1));
        b.addChild(0, e1);
        Store e2 = newStore(plus(x, 2));
        b.addChild(0, e2);
        Register r1 = b.getOrNewRegister(0, "r1");
        b.addChild(0, newLocal(r1, expressions.makeZero(type)));
        Store e3 = newStore(expressions.makeAdd(
                expressions.makeAdd(x, mult(r0, 2)),
                mult(r1, 4)));
        b.addChild(0, e3);
        b.addChild(0, l0);

        Program program = b.build();
        AliasAnalysis a = analyze(program, method);
        MemoryCoreEvent me0 = (MemoryCoreEvent) findMatchingEventAfterProcessing(program, e0);
        MemoryCoreEvent me1 = (MemoryCoreEvent) findMatchingEventAfterProcessing(program, e1);
        MemoryCoreEvent me2 = (MemoryCoreEvent) findMatchingEventAfterProcessing(program, e2);
        MemoryCoreEvent me3 = (MemoryCoreEvent) findMatchingEventAfterProcessing(program, e3);

        assertAlias(expect[0], a, me0, me1);
        assertAlias(expect[1], a, me0, me2);
        assertAlias(expect[2], a, me1, me2);
        assertAlias(expect[3], a, me0, me3);
        assertAlias(expect[4], a, me1, me3);
        assertAlias(expect[5], a, me2, me3);
    }

    @Test
    public void fieldsensitive3() throws InvalidConfigurationException {
        program3(FIELD_SENSITIVE, MUST, NONE, NONE, MAY, MAY, MAY);
    }

    @Test
    public void fieldinsensitive3() throws InvalidConfigurationException {
        program3(FIELD_INSENSITIVE, MUST, NONE, NONE, MAY, MAY, MAY);
    }

    @Test
    public void full3() throws InvalidConfigurationException {
        program3(FULL, MUST, NONE, NONE, MAY, MAY, MAY);
    }

    private void program3(Alias method, Result... expect) throws InvalidConfigurationException {
        ProgramBuilder b = ProgramBuilder.forLanguage(SourceLanguage.LITMUS);
        MemoryObject x = b.newMemoryObject("x", 3);
        x.setInitialValue(0, x);

        b.newThread(0);
        Register r0 = b.getOrNewRegister(0, "r0");
        Load e0 = newLoad(r0, x);
        b.addChild(0, e0);
        Store e1 = newStore(x, plus(r0, 1));
        b.addChild(0, e1);
        Store e2 = newStore(plus(x, 2));
        b.addChild(0, e2);
        Store e3 = newStore(r0);
        b.addChild(0, e3);

        Program program = b.build();
        AliasAnalysis a = analyze(program, method);
        MemoryCoreEvent me0 = (MemoryCoreEvent) findMatchingEventAfterProcessing(program, e0);
        MemoryCoreEvent me1 = (MemoryCoreEvent) findMatchingEventAfterProcessing(program, e1);
        MemoryCoreEvent me2 = (MemoryCoreEvent) findMatchingEventAfterProcessing(program, e2);
        MemoryCoreEvent me3 = (MemoryCoreEvent) findMatchingEventAfterProcessing(program, e3);

        assertAlias(expect[0], a, me0, me1);
        assertAlias(expect[1], a, me0, me2);
        assertAlias(expect[2], a, me1, me2);
        assertAlias(expect[3], a, me0, me3);
        assertAlias(expect[4], a, me1, me3);
        assertAlias(expect[5], a, me2, me3);//precisely no
    }

    @Test
    public void fieldsensitive4() throws InvalidConfigurationException {
        program4(FIELD_SENSITIVE, MAY, MAY, NONE, NONE, NONE, NONE);
    }

    @Test
    public void fieldinsensitive4() throws InvalidConfigurationException {
        program4(FIELD_INSENSITIVE, NONE, MUST, NONE, NONE, NONE, NONE);
    }

    @Test
    public void full4() throws InvalidConfigurationException {
        program4(FULL, NONE, MUST, NONE, NONE, NONE, NONE);
    }

    private void program4(Alias method, Result... expect) throws InvalidConfigurationException {
        ProgramBuilder b = ProgramBuilder.forLanguage(SourceLanguage.LITMUS);
        MemoryObject x = b.newMemoryObject("x", 1);
        MemoryObject y = b.newMemoryObject("y", 1);
        MemoryObject z = b.newMemoryObject("z", 1);

        b.newThread(0);
        Register r0 = b.getOrNewRegister(0, "r0");
        b.addChild(0, newLocal(r0, mult(x, 0)));
        b.addChild(0, newLocal(r0, y));
        Store e0 = newStore(r0);
        b.addChild(0, e0);
        Store e1 = newStore(x);
        b.addChild(0, e1);
        Store e2 = newStore(y);
        b.addChild(0, e2);
        Store e3 = newStore(z);
        b.addChild(0, e3);

        Program program = b.build();
        AliasAnalysis a = analyze(program, method);
        MemoryCoreEvent me0 = (MemoryCoreEvent) findMatchingEventAfterProcessing(program, e0);
        MemoryCoreEvent me1 = (MemoryCoreEvent) findMatchingEventAfterProcessing(program, e1);
        MemoryCoreEvent me2 = (MemoryCoreEvent) findMatchingEventAfterProcessing(program, e2);
        MemoryCoreEvent me3 = (MemoryCoreEvent) findMatchingEventAfterProcessing(program, e3);

        assertAlias(expect[0], a, me0, me1);//precisely no
        assertAlias(expect[1], a, me0, me2);//precisely must
        assertAlias(expect[2], a, me1, me2);
        assertAlias(expect[3], a, me0, me3);
        assertAlias(expect[4], a, me1, me3);
        assertAlias(expect[5], a, me2, me3);
    }

    @Test
    public void fieldsensitive5() throws InvalidConfigurationException {
        program5(FIELD_SENSITIVE, MAY, MAY, NONE, NONE, NONE, NONE);
    }

    @Test
    public void fieldinsensitive5() throws InvalidConfigurationException {
        program5(FIELD_INSENSITIVE, MUST, NONE, NONE, NONE, NONE, NONE);
    }

    @Test
    public void full5() throws InvalidConfigurationException {
        program5(FULL, NONE, MUST, NONE, NONE, NONE, NONE);
    }

    private void program5(Alias method, Result... expect) throws InvalidConfigurationException {
        ProgramBuilder b = ProgramBuilder.forLanguage(SourceLanguage.LITMUS);
        MemoryObject x = b.newMemoryObject("x", 1);
        MemoryObject y = b.newMemoryObject("y", 1);
        MemoryObject z = b.newMemoryObject("z", 1);

        b.newThread(0);
        Register r0 = b.getOrNewRegister(0, "r0");
        b.addChild(0, newLocal(r0, y));
        Store e0 = newStore(r0);
        b.addChild(0, e0);
        b.addChild(0, newLocal(r0, mult(x, 0)));
        Store e1 = newStore(x);
        b.addChild(0, e1);
        Store e2 = newStore(y);
        b.addChild(0, e2);
        Store e3 = newStore(z);
        b.addChild(0, e3);

        Program program = b.build();
        AliasAnalysis a = analyze(program, method);
        MemoryCoreEvent me0 = (MemoryCoreEvent) findMatchingEventAfterProcessing(program, e0);
        MemoryCoreEvent me1 = (MemoryCoreEvent) findMatchingEventAfterProcessing(program, e1);
        MemoryCoreEvent me2 = (MemoryCoreEvent) findMatchingEventAfterProcessing(program, e2);
        MemoryCoreEvent me3 = (MemoryCoreEvent) findMatchingEventAfterProcessing(program, e3);

        assertAlias(expect[0], a, me0, me1);//precisely no
        assertAlias(expect[1], a, me0, me2);//precisely must
        assertAlias(expect[2], a, me1, me2);
        assertAlias(expect[3], a, me0, me3);
        assertAlias(expect[4], a, me1, me3);
        assertAlias(expect[5], a, me2, me3);
    }

    @Test
    public void fullPropagation0() throws InvalidConfigurationException {
        ProgramBuilder b = ProgramBuilder.forLanguage(SourceLanguage.LITMUS);
        MemoryObject x = b.newMemoryObject("x", 1);
        MemoryObject y = b.newMemoryObject("y", 1);
        x.setInitialValue(0, y);
        y.setInitialValue(0, x);

        b.newThread(0);
        Register r0 = b.getOrNewRegister(0, "r0");
        Register r1 = b.getOrNewRegister(0, "r1");
        Register r2 = b.getOrNewRegister(0, "r2");
        Register r3 = b.getOrNewRegister(0, "r3");
        Load e0 = newLoad(r0, y); // reads x
        b.addChild(0, e0);
        Load e1 = newLoad(r1, r0); // reads y
        b.addChild(0, e1);
        Load e2 = newLoad(r2, r1); // reads x
        b.addChild(0, e2);
        Load e3 = newLoad(r3, r2); // reads y
        b.addChild(0, e3);
        Store e4 = newStore(y, r3); // stores y
        b.addChild(0, e4);

        Program program = b.build();
        AliasAnalysis a = analyze(program, FULL);
        MemoryCoreEvent me0 = (MemoryCoreEvent) findMatchingEventAfterProcessing(program, e0);
        MemoryCoreEvent me1 = (MemoryCoreEvent) findMatchingEventAfterProcessing(program, e1);
        MemoryCoreEvent me2 = (MemoryCoreEvent) findMatchingEventAfterProcessing(program, e2);
        MemoryCoreEvent me3 = (MemoryCoreEvent) findMatchingEventAfterProcessing(program, e3);

        assertAlias(MAY, a, me0, me1);
        assertAlias(MAY, a, me0, me2);
        assertAlias(MAY, a, me1, me2);
        assertAlias(MAY, a, me0, me3);
        assertAlias(MAY, a, me1, me3);
        assertAlias(MAY, a, me2, me3);
    }

    @Test
    public void fullPropagation1() throws InvalidConfigurationException {
        ProgramBuilder b = ProgramBuilder.forLanguage(SourceLanguage.LITMUS);
        MemoryObject x = b.newMemoryObject("x", 1);
        MemoryObject y = b.newMemoryObject("y", 1);
        x.setInitialValue(0, y);
        y.setInitialValue(0, x);

        b.newThread(0);
        Register r0 = b.getOrNewRegister(0, "r0");
        Register r1 = b.getOrNewRegister(0, "r1");
        Register r2 = b.getOrNewRegister(0, "r2");
        Load e0 = newLoad(r0, y); // reads x
        b.addChild(0, e0);
        Label l0 = newLabel("l0");
        b.addChild(0, newJump(expressions.makeEQ(r0, x), l0));
        Load e1 = newLoad(r0, x); // reads y
        b.addChild(0, e1);
        b.addChild(0, l0);
        Load e2 = newLoad(r1, r0); // reads x
        b.addChild(0, e2);
        Load e3 = newLoad(r2, r1); // reads y
        b.addChild(0, e3);
        Store e4 = newStore(r0, r2); // stores y
        b.addChild(0, e4);

        Program program = b.build();
        AliasAnalysis a = analyze(program, FULL);
        MemoryCoreEvent me0 = (MemoryCoreEvent) findMatchingEventAfterProcessing(program, e0);
        MemoryCoreEvent me1 = (MemoryCoreEvent) findMatchingEventAfterProcessing(program, e1);
        MemoryCoreEvent me2 = (MemoryCoreEvent) findMatchingEventAfterProcessing(program, e2);
        MemoryCoreEvent me3 = (MemoryCoreEvent) findMatchingEventAfterProcessing(program, e3);
        MemoryCoreEvent me4 = (MemoryCoreEvent) findMatchingEventAfterProcessing(program, e4);

        assertAlias(NONE, a, me0, me1);
        assertAlias(MAY, a, me0, me2);
        assertAlias(MAY, a, me1, me2);
        assertAlias(MAY, a, me0, me3);
        assertAlias(MAY, a, me1, me3);
        assertAlias(MAY, a, me2, me3);
        assertAlias(MAY, a, me0, me4);
        assertAlias(MAY, a, me1, me4);
        assertAlias(MUST, a, me2, me4);
        assertAlias(MAY, a, me3, me4);
    }

    private Load newLoad(Register value, Expression address) {
        return EventFactory.newLoad(value, address);
    }

    private Store newStore(Expression address) {
        return newStore(address, expressions.makeZero(types.getArchType()));
    }

    private Store newStore(Expression address, Expression value) {
        return EventFactory.newStore(address, value);
    }

    private Expression value(long v) {
        return expressions.makeValue(v, types.getArchType());
    }

    private Expression plus(Expression lhs, long rhs) {
        return expressions.makeAdd(lhs, value(rhs));
    }

    private Expression mult(Expression lhs, long rhs) {
        return expressions.makeMul(lhs, value(rhs));
    }

    private AliasAnalysis analyze(Program program, Alias method) throws InvalidConfigurationException {
        Configuration configuration = Configuration.builder()
                .setOption(ALIAS_METHOD, method.asStringOption())
                .build();
        ProcessingManager.fromConfig(configuration).run(program);
        Context analysisContext = Context.create();
        analysisContext.register(BranchEquivalence.class, BranchEquivalence.fromConfig(program, configuration));
        analysisContext.register(ExecutionAnalysis.class, ExecutionAnalysis.fromConfig(program, analysisContext, configuration));
        analysisContext.register(Dependency.class, Dependency.fromConfig(program, analysisContext, configuration));
        return AliasAnalysis.fromConfig(program, analysisContext, configuration);
    }

    private void assertAlias(Result expect, AliasAnalysis a, MemoryCoreEvent x, MemoryCoreEvent y) {
        switch (expect) {
            case NONE:
                assertFalse(a.mayAlias(x, y));
                assertFalse(a.mustAlias(x, y));
                break;
            case MAY:
                assertTrue(a.mayAlias(x, y));
                assertFalse(a.mustAlias(x, y));
                break;
            case MUST:
                assertTrue(a.mayAlias(x, y));
                assertTrue(a.mustAlias(x, y));
                break;
        }
    }

    private void assertList(List<?> results, Object... expected) {
        assertArrayEquals(expected, results.toArray());
    }

    private Event findMatchingEventAfterProcessing(Program p, Event orig) {
        return p.getThreadEvents().stream().filter(e -> e.hasEqualMetadata(orig, OriginalId.class)).findFirst().get();
    }
}
