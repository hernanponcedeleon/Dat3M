package com.dat3m.dartagnan.miscellaneous;

import com.dat3m.dartagnan.configuration.Alias;
import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.op.BOpBin;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Program.SourceLanguage;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.analysis.BranchEquivalence;
import com.dat3m.dartagnan.program.analysis.Dependency;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.analysis.alias.AliasAnalysis;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.program.processing.LoopUnrolling;
import com.dat3m.dartagnan.program.processing.MemoryAllocation;
import com.dat3m.dartagnan.program.processing.compilation.Compilation;
import com.dat3m.dartagnan.verification.Context;
import org.junit.Test;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.math.BigInteger;
import java.util.List;

import static com.dat3m.dartagnan.GlobalSettings.getArchPrecision;
import static com.dat3m.dartagnan.configuration.Alias.FIELD_INSENSITIVE;
import static com.dat3m.dartagnan.configuration.Alias.FIELD_SENSITIVE;
import static com.dat3m.dartagnan.configuration.OptionNames.ALIAS_METHOD;
import static com.dat3m.dartagnan.expression.IValue.ONE;
import static com.dat3m.dartagnan.expression.IValue.ZERO;
import static com.dat3m.dartagnan.expression.op.COpBin.GT;
import static com.dat3m.dartagnan.expression.op.COpBin.LT;
import static com.dat3m.dartagnan.expression.op.IOpBin.MULT;
import static com.dat3m.dartagnan.expression.op.IOpBin.PLUS;
import static com.dat3m.dartagnan.program.event.EventFactory.*;
import static org.junit.Assert.*;

public class AnalysisTest {

    private enum Result {NONE, MAY, MUST}

    private static final Result NONE = Result.NONE;
    private static final Result MAY = Result.MAY;
    private static final Result MUST = Result.MUST;

    @Test
    public void dependencyMustOverride() throws InvalidConfigurationException {
        ProgramBuilder b = new ProgramBuilder(SourceLanguage.LITMUS);
        b.initThread(0);
        Register r0 = b.getOrCreateRegister(0, "r0", getArchPrecision());
        Register r1 = b.getOrCreateRegister(0, "r1", getArchPrecision());
        Register r2 = b.getOrCreateRegister(0, "r2", getArchPrecision());
        Label alt = b.getOrCreateLabel("alt");
        b.addChild(0, newJump(new BNonDet(getArchPrecision()), alt));
        Local e0 = newLocal(r0, value(1));
        b.addChild(0, e0);
        Local e1 = newLocal(r1, r0);
        b.addChild(0, e1);
        Label join = b.getOrCreateLabel("join");
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

    private void program0(Alias method, Result... expect) throws InvalidConfigurationException {
        ProgramBuilder b = new ProgramBuilder(SourceLanguage.LITMUS);

        MemoryObject x = b.newObject("x", 2);
        MemoryObject y = b.getOrNewObject("y");

        b.initThread(0);
        Register r0 = b.getOrCreateRegister(0, "r0", getArchPrecision());
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
        Compilation.newInstance().run(program);
        LoopUnrolling.newInstance().run(program);
        MemoryAllocation.newInstance().run(program);
        AliasAnalysis a = analyze(program, method);
        MemEvent me0 = (MemEvent) findMatchingEventAfterProcessing(program, e0);
        MemEvent me1 = (MemEvent) findMatchingEventAfterProcessing(program, e1);
        MemEvent me2 = (MemEvent) findMatchingEventAfterProcessing(program, e2);
        MemEvent me3 = (MemEvent) findMatchingEventAfterProcessing(program, e3);

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

    private void program1(Alias method, Result... expect) throws InvalidConfigurationException {
        ProgramBuilder b = new ProgramBuilder(SourceLanguage.LITMUS);
        MemoryObject x = b.newObject("x", 3);
        x.setInitialValue(0, x);

        b.initThread(0);
        Store e0 = newStore(plus(x, 1));
        b.addChild(0, e0);
        Register r0 = b.getOrCreateRegister(0, "r0", getArchPrecision());
        Load e1 = newLoad(r0, x);
        b.addChild(0, e1);
        Store e2 = newStore(r0);
        b.addChild(0, e2);
        Store e3 = newStore(plus(r0, 1), r0);
        b.addChild(0, e3);

        Program program = b.build();
        Compilation.newInstance().run(program);
        LoopUnrolling.newInstance().run(program);
        MemoryAllocation.newInstance().run(program);
        AliasAnalysis a = analyze(program, method);
        MemEvent me0 = (MemEvent) findMatchingEventAfterProcessing(program, e0);
        MemEvent me1 = (MemEvent) findMatchingEventAfterProcessing(program, e1);
        MemEvent me2 = (MemEvent) findMatchingEventAfterProcessing(program, e2);
        MemEvent me3 = (MemEvent) findMatchingEventAfterProcessing(program, e3);

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

    private void program2(Alias method, Result... expect) throws InvalidConfigurationException {
        ProgramBuilder b = new ProgramBuilder(SourceLanguage.LITMUS);
        MemoryObject x = b.newObject("x", 3);

        b.initThread(0);
        Register r0 = b.getOrCreateRegister(0, "r0", getArchPrecision());
        b.addChild(0, newLocal(r0, new INonDet(INonDetTypes.INT, getArchPrecision())));
        Label l0 = b.getOrCreateLabel("l0");
        b.addChild(0, newJump(new BExprBin(new Atom(r0, GT, ONE), BOpBin.OR, new Atom(r0, LT, ZERO)), l0));
        Store e0 = newStore(x);
        b.addChild(0, e0);
        Store e1 = newStore(plus(x, 1));
        b.addChild(0, e1);
        Store e2 = newStore(plus(x, 2));
        b.addChild(0, e2);
        Register r1 = b.getOrCreateRegister(0, "r1", getArchPrecision());
        b.addChild(0, newLocal(r1, ZERO));
        Store e3 = newStore(new IExprBin(new IExprBin(x, PLUS, mult(r0, 2)), PLUS, mult(r1, 4)));
        b.addChild(0, e3);
        b.addChild(0, l0);

        Program program = b.build();
        Compilation.newInstance().run(program);
        LoopUnrolling.newInstance().run(program);
        MemoryAllocation.newInstance().run(program);
        AliasAnalysis a = analyze(program, method);
        MemEvent me0 = (MemEvent) findMatchingEventAfterProcessing(program, e0);
        MemEvent me1 = (MemEvent) findMatchingEventAfterProcessing(program, e1);
        MemEvent me2 = (MemEvent) findMatchingEventAfterProcessing(program, e2);
        MemEvent me3 = (MemEvent) findMatchingEventAfterProcessing(program, e3);

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

    private void program3(Alias method, Result... expect) throws InvalidConfigurationException {
        ProgramBuilder b = new ProgramBuilder(SourceLanguage.LITMUS);
        MemoryObject x = b.newObject("x", 3);
        x.setInitialValue(0, x);

        b.initThread(0);
        Register r0 = b.getOrCreateRegister(0, "r0", getArchPrecision());
        Load e0 = newLoad(r0, x);
        b.addChild(0, e0);
        Store e1 = newStore(x, plus(r0, 1));
        b.addChild(0, e1);
        Store e2 = newStore(plus(x, 2));
        b.addChild(0, e2);
        Store e3 = newStore(r0);
        b.addChild(0, e3);

        Program program = b.build();
        Compilation.newInstance().run(program);
        LoopUnrolling.newInstance().run(program);
        MemoryAllocation.newInstance().run(program);
        AliasAnalysis a = analyze(program, method);
        MemEvent me0 = (MemEvent) findMatchingEventAfterProcessing(program, e0);
        MemEvent me1 = (MemEvent) findMatchingEventAfterProcessing(program, e1);
        MemEvent me2 = (MemEvent) findMatchingEventAfterProcessing(program, e2);
        MemEvent me3 = (MemEvent) findMatchingEventAfterProcessing(program, e3);

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

    private void program4(Alias method, Result... expect) throws InvalidConfigurationException {
        ProgramBuilder b = new ProgramBuilder(SourceLanguage.LITMUS);
        MemoryObject x = b.getOrNewObject("x");
        MemoryObject y = b.getOrNewObject("y");
        MemoryObject z = b.getOrNewObject("z");

        b.initThread(0);
        Register r0 = b.getOrCreateRegister(0, "r0", getArchPrecision());
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
        MemEvent me0 = (MemEvent) findMatchingEventAfterProcessing(program, e0);
        MemEvent me1 = (MemEvent) findMatchingEventAfterProcessing(program, e1);
        MemEvent me2 = (MemEvent) findMatchingEventAfterProcessing(program, e2);
        MemEvent me3 = (MemEvent) findMatchingEventAfterProcessing(program, e3);

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

    private void program5(Alias method, Result... expect) throws InvalidConfigurationException {
        ProgramBuilder b = new ProgramBuilder(SourceLanguage.LITMUS);
        MemoryObject x = b.getOrNewObject("x");
        MemoryObject y = b.getOrNewObject("y");
        MemoryObject z = b.getOrNewObject("z");

        b.initThread(0);
        Register r0 = b.getOrCreateRegister(0, "r0", getArchPrecision());
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
        MemEvent me0 = (MemEvent) findMatchingEventAfterProcessing(program, e0);
        MemEvent me1 = (MemEvent) findMatchingEventAfterProcessing(program, e1);
        MemEvent me2 = (MemEvent) findMatchingEventAfterProcessing(program, e2);
        MemEvent me3 = (MemEvent) findMatchingEventAfterProcessing(program, e3);

        assertAlias(expect[0], a, me0, me1);//precisely no
        assertAlias(expect[1], a, me0, me2);//precisely must
        assertAlias(expect[2], a, me1, me2);
        assertAlias(expect[3], a, me0, me3);
        assertAlias(expect[4], a, me1, me3);
        assertAlias(expect[5], a, me2, me3);
    }

    private Load newLoad(Register value, IExpr address) {
        return EventFactory.newLoad(value, address, "");
    }

    private Store newStore(IExpr address) {
        return newStore(address, ZERO);
    }

    private Store newStore(IExpr address, IExpr value) {
        return EventFactory.newStore(address, value, "");
    }

    private IValue value(long v) {
        return new IValue(BigInteger.valueOf(v), getArchPrecision());
    }

    private IExpr plus(IExpr lhs, long rhs) {
        return new IExprBin(lhs, PLUS, value(rhs));
    }

    private IExpr mult(IExpr lhs, long rhs) {
        return new IExprBin(lhs, MULT, value(rhs));
    }

    private AliasAnalysis analyze(Program program, Alias method) throws InvalidConfigurationException {
        Compilation.newInstance().run(program);
        LoopUnrolling.newInstance().run(program);
        return AliasAnalysis.fromConfig(program, Configuration.builder().setOption(ALIAS_METHOD, method.asStringOption()).build());
    }

    private void assertAlias(Result expect, AliasAnalysis a, MemEvent x, MemEvent y) {
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
        return p.getEvents().stream().filter(e -> e.getOId() == orig.getOId()).findFirst().get();
    }
}
