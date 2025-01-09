package com.dat3m.dartagnan.miscellaneous;

import com.dat3m.dartagnan.configuration.Alias;
import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.ProgressModel;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Program.SourceLanguage;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.analysis.BranchEquivalence;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.analysis.ReachingDefinitionsAnalysis;
import com.dat3m.dartagnan.program.analysis.alias.AliasAnalysis;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.functions.Return;
import com.dat3m.dartagnan.program.event.metadata.OriginalId;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.program.processing.LoopUnrolling;
import com.dat3m.dartagnan.program.processing.MemoryAllocation;
import com.dat3m.dartagnan.program.processing.ProcessingManager;
import com.dat3m.dartagnan.program.processing.compilation.Compilation;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import org.junit.Test;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.io.File;
import java.util.EnumSet;
import java.util.LinkedList;
import java.util.List;

import static com.dat3m.dartagnan.configuration.Alias.*;
import static com.dat3m.dartagnan.configuration.OptionNames.*;
import static com.dat3m.dartagnan.configuration.Property.PROGRAM_SPEC;
import static com.dat3m.dartagnan.program.event.EventFactory.*;
import static com.dat3m.dartagnan.utils.ResourceHelper.getRootPath;
import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;
import static com.dat3m.dartagnan.verification.solving.ModelChecker.*;
import static com.dat3m.dartagnan.wmm.RelationNameRepository.LOC;
import static org.junit.Assert.*;

public class AnalysisTest {

    private enum Result {NONE, MAY, MUST}

    private static final Result NONE = Result.NONE;
    private static final Result MAY = Result.MAY;
    private static final Result MUST = Result.MUST;

    private static final TypeFactory types = TypeFactory.getInstance();
    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();

    @Test
    public void reachingDefinitionMustOverride() throws InvalidConfigurationException {
        reachingDefinitionMustOverride(ReachingDefinitionsAnalysis.Method.BACKWARD);
        reachingDefinitionMustOverride(ReachingDefinitionsAnalysis.Method.FORWARD);
    }

    private void reachingDefinitionMustOverride(ReachingDefinitionsAnalysis.Method method) throws InvalidConfigurationException {
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
        Label join = b.getOrCreateLabel(0, "join");
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
        Configuration config = Configuration.builder().setOption(REACHING_DEFINITIONS_METHOD, method.name()).build();
        Context context = Context.create();
        context.register(BranchEquivalence.class, BranchEquivalence.fromConfig(program, config));
        context.register(ExecutionAnalysis.class, ExecutionAnalysis.fromConfig(program, ProgressModel.FAIR, context, config));
        final ReachingDefinitionsAnalysis rd = ReachingDefinitionsAnalysis.fromConfig(program, context, config);
        var me0 = (RegReader) findMatchingEventAfterProcessing(program, e0);
        var me1 = (RegReader) findMatchingEventAfterProcessing(program, e1);
        var me2 = (RegReader) findMatchingEventAfterProcessing(program, e2);
        var me3 = (RegReader) findMatchingEventAfterProcessing(program, e3);
        var me4 = (RegReader) findMatchingEventAfterProcessing(program, e4);
        var me5 = (RegReader) findMatchingEventAfterProcessing(program, e5);
        assertTrue(rd.getWriters(me1).ofRegister(r0).mustBeInitialized());
        assertList(rd.getWriters(me1).ofRegister(r0).getMayWriters(), me0);
        assertList(rd.getWriters(me1).ofRegister(r0).getMustWriters(), me0);
        assertFalse(rd.getWriters(me3).ofRegister(r0).mustBeInitialized());
        assertList(rd.getWriters(me3).ofRegister(r0).getMayWriters(), me0);
        assertList(rd.getWriters(me3).ofRegister(r0).getMustWriters(), me0);
        assertTrue(rd.getWriters(me4).ofRegister(r1).mustBeInitialized());
        assertList(rd.getWriters(me4).ofRegister(r1).getMayWriters(), me1, me2);
        assertList(rd.getWriters(me4).ofRegister(r1).getMustWriters(), me1, me2);
        assertTrue(rd.getWriters(me5).ofRegister(r2).mustBeInitialized());
        assertList(rd.getWriters(me5).ofRegister(r2).getMayWriters(), me4);
        assertList(rd.getWriters(me5).ofRegister(r2).getMustWriters(), me4);
    }



    @Test
    public void reachingDefinitionSupportsLoops() throws InvalidConfigurationException {
        ProgramBuilder b = ProgramBuilder.forLanguage(SourceLanguage.LITMUS);
        b.newFunction("test", 0, types.getFunctionType(types.getArchType(), List.of()), List.of());
        Register r0 = b.getOrNewRegister(0, "r0");
        Register r1 = b.getOrNewRegister(0, "r1");
        Register r2 = b.getOrNewRegister(0, "r2");
        Register r3 = b.getOrNewRegister(0, "r3");
        //  if * {
        Label skip0 = b.getOrCreateLabel(0, "skip0");
        b.addChild(0, newJump(b.newConstant(types.getBooleanType()), skip0));
        //      r0 = r0
        Local r00 = newLocal(r0, r0);
        b.addChild(0, r00);
        //  }
        b.addChild(0, skip0);
        //  r1 = r0
        Local r10 = newLocal(r1, r0);
        b.addChild(0, r10);
        //  r2 = r0
        Local r20 = newLocal(r2, r0);
        b.addChild(0, r20);
        //  r3 = 0
        Local r30 = newLocal(r3, expressions.makeZero(types.getArchType()));
        b.addChild(0, r30);
        //  do {
        Label begin = b.getOrCreateLabel(0, "begin");
        b.addChild(0, begin);
        //      if * {
        Label skip1 = b.getOrCreateLabel(0, "skip1");
        b.addChild(0, newJump(b.newConstant(types.getBooleanType()), skip1));
        //          r0 = r1
        Local r01 = newLocal(r0, r1);
        b.addChild(0, r01);
        //          r1 = r1
        Local r11 = newLocal(r1, r1);
        b.addChild(0, r11);
        //          r2 = r1
        Local r21 = newLocal(r2, r1);
        b.addChild(0, r21);
        //      }
        b.addChild(0, skip1);
        //      r3 = r1
        Local r31 = newLocal(r3, r1);
        b.addChild(0, r31);
        //  } while *
        b.addChild(0, newJump(b.newConstant(types.getBooleanType()), begin));
        //  if * {
        Label skip2 = b.getOrCreateLabel(0, "skip2");
        b.addChild(0, newJump(b.newConstant(types.getBooleanType()), skip2));
        //      r0 = r2
        Local r02 = newLocal(r0, r2);
        b.addChild(0, r02);
        //      r1 = r2
        Local r12 = newLocal(r1, r2);
        b.addChild(0, r12);
        //  }
        b.addChild(0, skip2);
        //  r2 = r2
        Local r22 = newLocal(r2, r2);
        b.addChild(0, r22);
        //  if * {
        Label skip3 = b.getOrCreateLabel(0, "skip3");
        b.addChild(0, newJump(b.newConstant(types.getBooleanType()), skip3));
        //      r3 = r2
        Local r32 = newLocal(r3, r2);
        b.addChild(0, r32);
        //  }
        b.addChild(0, skip3);
        //  return (r0 + r1) ^ (r2 | r3)
        Return ret = newFunctionReturn(
                expressions.makeIntXor(expressions.makeAdd(r0, r1), expressions.makeIntOr(r2, r3)));
        b.addChild(0, ret);

        Program program = b.build();
        Configuration config = Configuration.builder()
                .setOption(REACHING_DEFINITIONS_METHOD, ReachingDefinitionsAnalysis.Method.BACKWARD.name())
                .build();
        final ReachingDefinitionsAnalysis dep = ReachingDefinitionsAnalysis.configure(config)
                .forFunction(program.getFunctions().get(0));
        assertFalse(dep.getWriters(r00).ofRegister(r0).mustBeInitialized());
        assertList(dep.getWriters(r00).ofRegister(r0).getMayWriters());
        assertFalse(dep.getWriters(r10).ofRegister(r0).mustBeInitialized());
        assertList(dep.getWriters(r10).ofRegister(r0).getMayWriters(), r00);
        assertFalse(dep.getWriters(r20).ofRegister(r0).mustBeInitialized());
        assertList(dep.getWriters(r20).ofRegister(r0).getMayWriters(), r00);
        assertTrue(dep.getWriters(r30).getUsedRegisters().isEmpty());
        assertList(dep.getWriters(r30).ofRegister(r0).getMayWriters());
        assertTrue(dep.getWriters(r01).ofRegister(r1).mustBeInitialized());
        assertList(dep.getWriters(r01).ofRegister(r1).getMayWriters(), r10, r11);
        assertTrue(dep.getWriters(r11).ofRegister(r1).mustBeInitialized());
        assertList(dep.getWriters(r11).ofRegister(r1).getMayWriters(), r10, r11);
        assertTrue(dep.getWriters(r21).ofRegister(r1).mustBeInitialized());
        assertList(dep.getWriters(r21).ofRegister(r1).getMayWriters(), r11);
        assertTrue(dep.getWriters(r31).ofRegister(r1).mustBeInitialized());
        assertList(dep.getWriters(r31).ofRegister(r1).getMayWriters(), r10, r11);
        assertTrue(dep.getWriters(r02).ofRegister(r2).mustBeInitialized());
        assertList(dep.getWriters(r02).ofRegister(r2).getMayWriters(), r20, r21);
        assertTrue(dep.getWriters(r12).ofRegister(r2).mustBeInitialized());
        assertList(dep.getWriters(r12).ofRegister(r2).getMayWriters(), r20, r21);
        assertTrue(dep.getWriters(r22).ofRegister(r2).mustBeInitialized());
        assertList(dep.getWriters(r22).ofRegister(r2).getMayWriters(), r20, r21);
        assertTrue(dep.getWriters(r32).ofRegister(r2).mustBeInitialized());
        assertList(dep.getWriters(r32).ofRegister(r2).getMayWriters(), r22);
        assertFalse(dep.getWriters(ret).ofRegister(r0).mustBeInitialized());
        assertList(dep.getWriters(ret).ofRegister(r0).getMayWriters(), r00, r01, r02);
        assertTrue(dep.getWriters(ret).ofRegister(r1).mustBeInitialized());
        assertList(dep.getWriters(ret).ofRegister(r1).getMayWriters(), r10, r11, r12);
        assertTrue(dep.getWriters(ret).ofRegister(r2).mustBeInitialized());
        assertList(dep.getWriters(ret).ofRegister(r2).getMayWriters(), r22);
        assertTrue(dep.getWriters(ret).ofRegister(r3).mustBeInitialized());
        assertList(dep.getWriters(ret).ofRegister(r3).getMayWriters(), r31, r32);
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
        program0(FULL, NONE, MAY, MAY, NONE, NONE, NONE);
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

    @Test
    public void fieldsensitive6() throws InvalidConfigurationException {
        program6(FIELD_SENSITIVE, MUST, NONE);
    }

    @Test
    public void fieldinsensitive6() throws InvalidConfigurationException {
        program6(FIELD_INSENSITIVE, MAY, NONE);
    }

    private void program6(Alias method, Result... expect) throws InvalidConfigurationException {
        ProgramBuilder b = ProgramBuilder.forLanguage(SourceLanguage.LITMUS);
        MemoryObject x = b.newMemoryObject("x", 1);

        b.newThread(0);
        Register r0 = b.getOrNewRegister(0, "r0");
        Alloc a = newHeapAlloc(r0, 2);
        b.addChild(0, a);
        Store e0 = newStore(r0, value(1));
        b.addChild(0, e0);
        Register r1 = b.getOrNewRegister(0, "r1");
        Load e1 = newLoad(r1, x);
        b.addChild(0, e1);
        b.addChild(0, EventFactory.newFree(r0));

        Program program = b.build();
        AliasAnalysis aa = analyze(program, method);
        Alloc al = (Alloc) findMatchingEventAfterProcessing(program, a);
        MemoryCoreEvent me0 = (MemoryCoreEvent) findMatchingEventAfterProcessing(program, e0);
        MemoryCoreEvent me1 = (MemoryCoreEvent) findMatchingEventAfterProcessing(program, e1);

        assertAlias(expect[0], aa, al, me0);
        assertAlias(expect[1], aa, al, me1);
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

    private Alloc newHeapAlloc(Register resultReg, int size) {
        return EventFactory.newAlloc(resultReg, types.getByteType(), value(size), true, true);
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
        analysisContext.register(ExecutionAnalysis.class, ExecutionAnalysis.fromConfig(program, ProgressModel.FAIR, analysisContext, configuration));
        analysisContext.register(ReachingDefinitionsAnalysis.class, ReachingDefinitionsAnalysis.fromConfig(program, analysisContext, configuration));
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

    private void assertAlias(Result expect, AliasAnalysis a, Alloc x, MemoryCoreEvent y) {
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

    /*
     * This test may fail to show the presence of an error immediately.
     * When it fails during a merge, consider repeating it on the head of the target branch.
     */
    @Test
    public void aliasAnalysisDeterminism() throws Exception {
        final String programPath = getTestResourcePath("libvsync/bounded_mpmc_check_empty-opt.ll");
        final String modelPath = "cat/c11.cat";
        final int ITERATIONS = 10;
        final Program program = new ProgramParser().parse(new File(programPath));
        final Wmm wmm = new ParserCat().parse(new File(getRootPath(modelPath)));
        final Configuration config = Configuration.builder()
                .setOption(ENABLE_EXTENDED_RELATION_ANALYSIS, "false")
                .build();
        final VerificationTask task = VerificationTask.builder()
                .withConfig(config)
                .withBound(1)
                .withTarget(Arch.C11)
                .build(program, wmm, EnumSet.of(PROGRAM_SPEC));
        wmm.configureAll(task.getConfig());
        preprocessProgram(task, task.getConfig());
        final Relation loc = wmm.getRelation(LOC);
        final List<Integer> sizes = new LinkedList<>();
        for (int i = 0; i < ITERATIONS; i++) {
            final Context context = Context.create();
            performStaticProgramAnalyses(task, context, config);
            performStaticWmmAnalyses(task, context, config);
            final RelationAnalysis relationAnalysis = context.get(RelationAnalysis.class);
            sizes.add(relationAnalysis.getKnowledge(loc).getMaySet().size());
        }
        for (int i = 1; i < ITERATIONS; i++) {
            assertEquals(sizes.get(i - 1), sizes.get(i));
        }
    }

    private void assertList(List<?> results, Object... expected) {
        assertArrayEquals(expected, results.toArray());
    }

    private Event findMatchingEventAfterProcessing(Program p, Event orig) {
        return p.getThreadEvents().stream().filter(e -> e.hasEqualMetadata(orig, OriginalId.class)).findFirst().get();
    }
}
