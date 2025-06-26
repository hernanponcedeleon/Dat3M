package com.dat3m.dartagnan.others.miscellaneous;

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
import com.dat3m.dartagnan.verification.solving.ModelChecker;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.axiom.Emptiness;
import com.dat3m.dartagnan.wmm.definition.Composition;
import com.dat3m.dartagnan.wmm.definition.Intersection;
import org.junit.Test;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.io.File;
import java.util.ArrayList;
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
import static com.dat3m.dartagnan.wmm.RelationNameRepository.*;
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
        context.register(ExecutionAnalysis.class, ExecutionAnalysis.fromConfig(program, ProgressModel.uniform(ProgressModel.FAIR), context, config));
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
        program0(FULL, NONE, MUST, NONE, NONE, NONE, NONE);
    }

    private void program0(Alias method, Result... expect) throws InvalidConfigurationException {
        ProgramBuilder b = ProgramBuilder.forLanguage(SourceLanguage.LITMUS);

        MemoryObject x = b.newMemoryObject("x", 16);
        MemoryObject y = b.newMemoryObject("y", 8);

        b.newThread(0);
        Register r0 = b.getOrNewRegister(0, "r0");
        //In C11, this is well-defined: ((uint64_t*) ((uintptr_t) x * 1))
        b.addChild(0, newLocal(r0, mult(x, 1)));
        Store e0 = newStore(r0);
        b.addChild(0, e0);
        Store e1 = newStore(plus(r0, 8));
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
        MemoryObject x = b.newMemoryObject("x", 24);
        x.setInitialValue(0, x);

        b.newThread(0);
        Store e0 = newStore(plus(x, 8));
        b.addChild(0, e0);
        Register r0 = b.getOrNewRegister(0, "r0");
        Load e1 = newLoad(r0, x);
        b.addChild(0, e1);
        Store e2 = newStore(r0);
        b.addChild(0, e2);
        Store e3 = newStore(plus(r0, 8), r0);
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
        MemoryObject x = b.newMemoryObject("x", 24);

        b.newThread(0);
        Register r0 = b.getOrNewRegister(0, "r0");
        b.addChild(0, newLocal(r0, b.newConstant(type)));
        Label l0 = b.getOrCreateLabel(0,"l0");
        b.addChild(0, newJump(expressions.makeOr(
                expressions.makeGT(r0, expressions.makeOne(type), true),
                expressions.makeLT(r0, expressions.makeZero(type), true)), l0));
        Store e0 = newStore(x);
        b.addChild(0, e0);
        Store e1 = newStore(plus(x, 8));
        b.addChild(0, e1);
        Store e2 = newStore(plus(x, 16));
        b.addChild(0, e2);
        Register r1 = b.getOrNewRegister(0, "r1");
        b.addChild(0, newLocal(r1, expressions.makeZero(type)));
        Store e3 = newStore(expressions.makeAdd(
                expressions.makeAdd(x, mult(r0, 16)),
                mult(r1, 32)));
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
        MemoryObject x = b.newMemoryObject("x", 24);
        x.setInitialValue(0, x);

        b.newThread(0);
        Register r0 = b.getOrNewRegister(0, "r0");
        Load e0 = newLoad(r0, x);
        b.addChild(0, e0);
        Store e1 = newStore(x, plus(r0, 8));
        b.addChild(0, e1);
        Store e2 = newStore(plus(x, 16));
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
        MemoryObject x = b.newMemoryObject("x", 8);
        MemoryObject y = b.newMemoryObject("y", 8);
        MemoryObject z = b.newMemoryObject("z", 8);

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
        MemoryObject x = b.newMemoryObject("x", 8);
        MemoryObject y = b.newMemoryObject("y", 8);
        MemoryObject z = b.newMemoryObject("z", 8);

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
        MemoryObject x = b.newMemoryObject("x", 8);
        MemoryObject y = b.newMemoryObject("y", 8);
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
        MemoryObject x = b.newMemoryObject("x", 8);
        MemoryObject y = b.newMemoryObject("y", 8);
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
        program6(FIELD_SENSITIVE, MUST, NONE, MUST, MUST);
    }

    @Test
    public void fieldinsensitive6() throws InvalidConfigurationException {
        program6(FIELD_INSENSITIVE, MUST, NONE, MAY, MUST);
    }

    @Test
    public void full6() throws InvalidConfigurationException {
        program6(FULL, MUST, NONE, MUST, MUST);
    }

    private void program6(Alias method, Result... expect) throws InvalidConfigurationException {
        ProgramBuilder b = ProgramBuilder.forLanguage(SourceLanguage.LITMUS);

        MemoryObject x = b.newMemoryObject("x", 1);

        b.newThread(0);
        Register r0 = b.getOrNewRegister(0, "r0");
        MemAlloc a = newHeapAlloc(r0, 2);                  // r0 = malloc(2)
        b.addChild(0, a);
        Store e0 = newStore(r0, value(2));              // *r0 = 2
        b.addChild(0, e0);
        Register r1 = b.getOrNewRegister(0, "r1");
        Load e1 = newLoad(r1, x);                       // r1 = x
        b.addChild(0, e1);
        Store e2 = newStore(plus(r0, 1), r1);           // *(r0 + 1) = r1
        b.addChild(0, e2);
        MemFree f = newFree(r0);                        // free(r0)
        b.addChild(0, f);

        Program program = b.build();
        AliasAnalysis aa = analyze(program, method);
        MemAlloc al = (MemAlloc) findMatchingEventAfterProcessing(program, a);
        MemoryCoreEvent me0 = (MemoryCoreEvent) findMatchingEventAfterProcessing(program, e0);
        MemoryCoreEvent me1 = (MemoryCoreEvent) findMatchingEventAfterProcessing(program, e1);
        MemoryCoreEvent me2 = (MemoryCoreEvent) findMatchingEventAfterProcessing(program, e2);
        MemFree fr = (MemFree) findMatchingEventAfterProcessing(program, f);

        assertObjectAlias(expect[0], aa, al, me0);
        assertObjectAlias(expect[1], aa, al, me1);
        assertObjectAlias(expect[2], aa, al, me2);
        assertAlias(expect[3], aa, al, fr);
    }

    @Test
    public void fieldsensitive7() throws InvalidConfigurationException {
        program7(FIELD_SENSITIVE, MUST, NONE, MUST, NONE, MAY, NONE, MUST, NONE, MUST, MAY, MUST, NONE, NONE, MUST, NONE);
    }

    @Test
    public void fieldinsensitive7() throws InvalidConfigurationException {
        program7(FIELD_INSENSITIVE, MUST, NONE, MAY, MAY, MAY, NONE, MUST, MAY, MAY, MAY, MUST, NONE, NONE, MUST, NONE);
    }

    @Test
    public void full7() throws InvalidConfigurationException {
        program7(FULL, MUST, NONE, MUST, NONE, NONE, NONE, MUST, NONE, MUST, MUST, MUST, NONE, NONE, MUST, NONE);
    }

    private void program7(Alias method, Result... expect) throws InvalidConfigurationException{
        ProgramBuilder b = ProgramBuilder.forLanguage(SourceLanguage.LITMUS);

        b.newThread(0);
        Register r0 = b.getOrNewRegister(0, "r0");
        MemAlloc a0 = newHeapAlloc(r0, 3);                    // r0 = malloc(3)
        b.addChild(0, a0);
        Register r1 = b.getOrNewRegister(0, "r1");
        MemAlloc a1 = newHeapAlloc(r1, 4);                    // r1 = malloc(4)
        b.addChild(0, a1);
        Store e0 = newStore(r0, r1);                       // *r0 = r1
        b.addChild(0, e0);
        Store e1 = newStore(r1, r0);                       // *r1 = r0
        b.addChild(0, e1);
        Register r2 = b.getOrNewRegister(0, "r2");
        b.addChild(0, newLocal(r2, r0));                   // r2 = r0
        Store e2 = newStore(plus(r2, 2), value(1));        // *(r2 + 2) = 1
        b.addChild(0, e2);
        Register r3 = b.getOrNewRegister(0, "r3");
        b.addChild(0, newLocal(r3, r1));                   // r3 = r1
        Store e3 = newStore(plus(r3, 3), value(1));        // *(r3 + 3) = 1
        b.addChild(0, e3);
        Register r4 = b.getOrNewRegister(0, "r4");
        b.addChild(0, newLocal(r4, r0));                   // r4 = r0
        b.addChild(0, newLocal(r4, r1));                   // r4 = r1
        Store e4 = newStore(r4, value(1));                 // *r4 = 1
        b.addChild(0, e4);
        MemFree f0 = newFree(r0);                          // free(r0)
        b.addChild(0, f0);
        MemFree f1 = newFree(r1);                          // free(r1)
        b.addChild(0, f1);

        Program program = b.build();
        AliasAnalysis aa = analyze(program, method);
        MemAlloc al0 = (MemAlloc) findMatchingEventAfterProcessing(program, a0);
        MemAlloc al1 = (MemAlloc) findMatchingEventAfterProcessing(program, a1);
        MemoryCoreEvent me0 = (MemoryCoreEvent) findMatchingEventAfterProcessing(program, e0);
        MemoryCoreEvent me1 = (MemoryCoreEvent) findMatchingEventAfterProcessing(program, e1);
        MemoryCoreEvent me2 = (MemoryCoreEvent) findMatchingEventAfterProcessing(program, e2);
        MemoryCoreEvent me3 = (MemoryCoreEvent) findMatchingEventAfterProcessing(program, e3);
        MemoryCoreEvent me4 = (MemoryCoreEvent) findMatchingEventAfterProcessing(program, e4);
        MemFree fr0 = (MemFree) findMatchingEventAfterProcessing(program, f0);
        MemFree fr1 = (MemFree) findMatchingEventAfterProcessing(program, f1);

        assertObjectAlias(expect[0], aa, al0, me0);
        assertObjectAlias(expect[1], aa, al0, me1);
        assertObjectAlias(expect[2], aa, al0, me2);
        assertObjectAlias(expect[3], aa, al0, me3);
        assertObjectAlias(expect[4], aa, al0, me4);
        assertObjectAlias(expect[5], aa, al1, me0);
        assertObjectAlias(expect[6], aa, al1, me1);
        assertObjectAlias(expect[7], aa, al1, me2);
        assertObjectAlias(expect[8], aa, al1, me3);
        assertObjectAlias(expect[9], aa, al1, me4);
        assertAlias(expect[10], aa, al0, fr0);
        assertAlias(expect[11], aa, al0, fr1);
        assertAlias(expect[12], aa, al1, fr0);
        assertAlias(expect[13], aa, al1, fr1);
        assertAlias(expect[14], aa, fr0, fr1);
    }

    @Test
    public void fieldsensitive8() throws InvalidConfigurationException {
        program8(FIELD_SENSITIVE, MUST, MUST, MUST, MUST, MUST, NONE, MUST);
    }

    @Test
    public void fieldinsensitive8() throws InvalidConfigurationException {
        program8(FIELD_INSENSITIVE, MUST, MAY, MAY, MUST, MAY, NONE, MUST);
    }

    @Test
    public void full8() throws InvalidConfigurationException {
        program8(FULL, MUST, MUST, MUST, MUST, MUST, NONE, MUST);
    }

    private void program8(Alias method, Result... expect) throws InvalidConfigurationException {
        ProgramBuilder b = ProgramBuilder.forLanguage(SourceLanguage.LITMUS);

        MemoryObject x = b.newMemoryObject("x", 1);

        b.newThread(0);
        Register r0 = b.getOrNewRegister(0, "r0");
        MemAlloc a0 = newHeapAlloc(r0, 4);                    // r0 = malloc(4)
        b.addChild(0, a0);
        Store e0 = newStore(r0, value(1));                 // *r0 = 1
        b.addChild(0, e0);
        Register r1 = b.getOrNewRegister(0, "r1");
        b.addChild(0, newLocal(r1, plus(r0, 2)));          // r1 = r0 + 2
        Store e1 = newStore(r1, value(1));                 // *r1 = 1
        b.addChild(0, e1);
        Register r2 = b.getOrNewRegister(0, "r2");
        b.addChild(0, newLocal(r2, plus(r0, 3)));          // r2 = r0 + 3
        Store e2 = newStore(r2, value(1));                 // *r2 = 1
        b.addChild(0, e2);
        Register r3 = b.getOrNewRegister(0, "r3");
        b.addChild(0, newLocal(r3, r0));                   // r3 = r0
        Store e3 = newStore(r3, value(1));                 // *r3 = 1
        b.addChild(0, e3);
        Register r4 = b.getOrNewRegister(0, "r4");
        b.addChild(0, newLocal(r4, r1));                   // r4 = r1
        Store e4 = newStore(r4, value(1));                 // *r4 = 1
        b.addChild(0, e4);
        Store e5 = newStore(x, value(1));                  // x = 1
        b.addChild(0, e5);
        MemFree f0 = newFree(r3);                          // free(r3)
        b.addChild(0, f0);

        Program program = b.build();
        AliasAnalysis aa = analyze(program, method);
        MemAlloc al0 = (MemAlloc) findMatchingEventAfterProcessing(program, a0);
        MemoryCoreEvent me0 = (MemoryCoreEvent) findMatchingEventAfterProcessing(program, e0);
        MemoryCoreEvent me1 = (MemoryCoreEvent) findMatchingEventAfterProcessing(program, e1);
        MemoryCoreEvent me2 = (MemoryCoreEvent) findMatchingEventAfterProcessing(program, e2);
        MemoryCoreEvent me3 = (MemoryCoreEvent) findMatchingEventAfterProcessing(program, e3);
        MemoryCoreEvent me4 = (MemoryCoreEvent) findMatchingEventAfterProcessing(program, e4);
        MemoryCoreEvent me5 = (MemoryCoreEvent) findMatchingEventAfterProcessing(program, e5);
        MemFree fr0 = (MemFree) findMatchingEventAfterProcessing(program, f0);

        assertObjectAlias(expect[0], aa, al0, me0);
        assertObjectAlias(expect[1], aa, al0, me1);
        assertObjectAlias(expect[2], aa, al0, me2);
        assertObjectAlias(expect[3], aa, al0, me3);
        assertObjectAlias(expect[4], aa, al0, me4);
        assertObjectAlias(expect[5], aa, al0, me5);
        assertAlias(expect[6], aa, al0, fr0);
    }

    @Test
    public void fieldsensitive9() throws InvalidConfigurationException {
        program9(FIELD_SENSITIVE, MUST, NONE, MUST, NONE, NONE, NONE, NONE, NONE, NONE,
                NONE, MUST, NONE, NONE, NONE, NONE, NONE, NONE, NONE,
                NONE, MUST, NONE, NONE, NONE, NONE, NONE, NONE,
                NONE, NONE, NONE, NONE, NONE, NONE, NONE,
                NONE, NONE, NONE, NONE, NONE, NONE,
                NONE, MUST, NONE, NONE, NONE,
                NONE, NONE, NONE, NONE,
                NONE, NONE, NONE,
                NONE, NONE,
                NONE);
    }

    @Test
    public void fieldinsensitive9() throws InvalidConfigurationException {
        program9(FIELD_INSENSITIVE, MUST, NONE, MUST, NONE, MAY, NONE, MAY, MAY, MAY,
                NONE, MUST, NONE, NONE, MAY, NONE, MAY, MAY, MAY,
                NONE, MUST, NONE, MAY, NONE, MAY, MAY, MAY,
                NONE, NONE, MAY, NONE, MAY, MAY, MAY,
                NONE, MAY, NONE, MAY, MAY, MAY,
                MAY, MUST, MAY, MAY, MAY,
                MAY, MAY, MAY, MAY,
                MAY, MAY, MAY,
                MAY, MAY,
                MAY);
    }

    @Test
    public void full9() throws InvalidConfigurationException {
        program9(FULL, MUST, NONE, MUST, NONE, NONE, NONE, NONE, NONE, NONE,
                NONE, MUST, NONE, NONE, NONE, NONE, NONE, NONE, NONE,
                NONE, MUST, NONE, NONE, NONE, NONE, NONE, NONE,
                NONE, NONE, NONE, NONE, NONE, NONE, NONE,
                NONE, NONE, NONE, NONE, NONE, NONE,
                NONE, MUST, NONE, NONE, NONE,
                NONE, NONE, NONE, NONE,
                NONE, NONE, NONE,
                NONE, NONE,
                NONE);
    }

    // This program is wrong because it frees the same memory multiple times.
    // But it is suitable to test the alias analysis.
    private void program9(Alias method, Result... expect) throws InvalidConfigurationException {
        ProgramBuilder b = ProgramBuilder.forLanguage(SourceLanguage.LITMUS);

        MemoryObject x = b.newMemoryObject("x", 2);
        x.setInitialValue(0, x);
        MemoryObject y = b.newMemoryObject("y", 2);

        b.newThread(0);
        Register r0 = b.getOrNewRegister(0, "r0");
        MemAlloc a0 = newHeapAlloc(r0, 2);                    // r0 = malloc(2)
        b.addChild(0, a0);
        Register r1 = b.getOrNewRegister(0, "r1");
        MemAlloc a1 = newHeapAlloc(r1, 3);                    // r1 = malloc(3)
        b.addChild(0, a1);
        Register r2 = b.getOrNewRegister(0, "r2");
        b.addChild(0, newLocal(r2, r0));                   // r2 = r0
        Register r3 = b.getOrNewRegister(0, "r3");
        b.addChild(0, newLoad(r3, x));                     // r3 = x
        Register r4 = b.getOrNewRegister(0, "r4");
        b.addChild(0, newLocal(r4, plus(r3, 1)));          // r4 = r3 + 1
        MemFree f0 = newFree(r0);                          // free(r0)
        b.addChild(0, f0);
        MemFree f1 = newFree(r1);                          // free(r1)
        b.addChild(0, f1);
        MemFree f2 = newFree(r2);                          // free(r2)
        b.addChild(0, f2);
        MemFree f3 = newFree(r3);                          // free(r3)
        b.addChild(0, f3);
        MemFree f4 = newFree(r4);                          // free(r4)
        b.addChild(0, f4);
        MemFree f5 = newFree(x);                           // free(x)
        b.addChild(0, f5);
        Register r5 = b.getOrNewRegister(0, "r5");
        b.addChild(0, newLocal(r5, plus(r0, 1)));          // r5 = r0 + 1
        MemFree f6 = newFree(r5);                          // free(r5)
        b.addChild(0, f6);
        MemFree f7 = newFree(plus(r1, 2));                 // free(r1 + 2)
        b.addChild(0, f7);
        Register r6 = b.getOrNewRegister(0, "r6");
        b.addChild(0, newLoad(r6, y));                     // r6 = y
        MemFree f8 = newFree(r6);                          // free(r6)
        b.addChild(0, f8);

        Program program = b.build();
        AliasAnalysis aa = analyze(program, method);
        MemAlloc al0 = (MemAlloc) findMatchingEventAfterProcessing(program, a0);
        MemAlloc al1 = (MemAlloc) findMatchingEventAfterProcessing(program, a1);
        MemFree fr0 = (MemFree) findMatchingEventAfterProcessing(program, f0);
        MemFree fr1 = (MemFree) findMatchingEventAfterProcessing(program, f1);
        MemFree fr2 = (MemFree) findMatchingEventAfterProcessing(program, f2);
        MemFree fr3 = (MemFree) findMatchingEventAfterProcessing(program, f3);
        MemFree fr4 = (MemFree) findMatchingEventAfterProcessing(program, f4);
        MemFree fr5 = (MemFree) findMatchingEventAfterProcessing(program, f5);
        MemFree fr6 = (MemFree) findMatchingEventAfterProcessing(program, f6);
        MemFree fr7 = (MemFree) findMatchingEventAfterProcessing(program, f7);
        MemFree fr8 = (MemFree) findMatchingEventAfterProcessing(program, f8);

        assertAlias(expect[0], aa, al0, fr0);
        assertAlias(expect[1], aa, al0, fr1);
        assertAlias(expect[2], aa, al0, fr2);
        assertAlias(expect[3], aa, al0, fr3);
        assertAlias(expect[4], aa, al0, fr4);
        assertAlias(expect[5], aa, al0, fr5);
        assertAlias(expect[6], aa, al0, fr6);
        assertAlias(expect[7], aa, al0, fr7);
        assertAlias(expect[8], aa, al0, fr8);

        assertAlias(expect[9], aa, al1, fr0);
        assertAlias(expect[10], aa, al1, fr1);
        assertAlias(expect[11], aa, al1, fr2);
        assertAlias(expect[12], aa, al1, fr3);
        assertAlias(expect[13], aa, al1, fr4);
        assertAlias(expect[14], aa, al1, fr5);
        assertAlias(expect[15], aa, al1, fr6);
        assertAlias(expect[16], aa, al1, fr7);
        assertAlias(expect[17], aa, al1, fr8);

        assertAlias(expect[18], aa, fr0, fr1);
        assertAlias(expect[19], aa, fr0, fr2);
        assertAlias(expect[20], aa, fr0, fr3);
        assertAlias(expect[21], aa, fr0, fr4);
        assertAlias(expect[22], aa, fr0, fr5);
        assertAlias(expect[23], aa, fr0, fr6);
        assertAlias(expect[24], aa, fr0, fr7);
        assertAlias(expect[25], aa, fr0, fr8);

        assertAlias(expect[26], aa, fr1, fr2);
        assertAlias(expect[27], aa, fr1, fr3);
        assertAlias(expect[28], aa, fr1, fr4);
        assertAlias(expect[29], aa, fr1, fr5);
        assertAlias(expect[30], aa, fr1, fr6);
        assertAlias(expect[31], aa, fr1, fr7);
        assertAlias(expect[32], aa, fr1, fr8);

        assertAlias(expect[33], aa, fr2, fr3);
        assertAlias(expect[34], aa, fr2, fr4);
        assertAlias(expect[35], aa, fr2, fr5);
        assertAlias(expect[36], aa, fr2, fr6);
        assertAlias(expect[37], aa, fr2, fr7);
        assertAlias(expect[38], aa, fr2, fr8);

        assertAlias(expect[39], aa, fr3, fr4);
        assertAlias(expect[40], aa, fr3, fr5);
        assertAlias(expect[41], aa, fr3, fr6);
        assertAlias(expect[42], aa, fr3, fr7);
        assertAlias(expect[43], aa, fr3, fr8);

        assertAlias(expect[44], aa, fr4, fr5);
        assertAlias(expect[45], aa, fr4, fr6);
        assertAlias(expect[46], aa, fr4, fr7);
        assertAlias(expect[47], aa, fr4, fr8);

        assertAlias(expect[48], aa, fr5, fr6);
        assertAlias(expect[49], aa, fr5, fr7);
        assertAlias(expect[50], aa, fr5, fr8);

        assertAlias(expect[51], aa, fr6, fr7);
        assertAlias(expect[52], aa, fr6, fr8);

        assertAlias(expect[53], aa, fr7, fr8);
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

    private MemAlloc newHeapAlloc(Register resultReg, int size) {
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
        analysisContext.register(ExecutionAnalysis.class, ExecutionAnalysis.fromConfig(program, ProgressModel.uniform(ProgressModel.FAIR), analysisContext, configuration));
        analysisContext.register(ReachingDefinitionsAnalysis.class, ReachingDefinitionsAnalysis.fromConfig(program, analysisContext, configuration));
        return AliasAnalysis.fromConfig(program, analysisContext, configuration, false);
    }

    private void assertAlias(Result expect, AliasAnalysis a, Event x, Event y) {
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

    private void assertObjectAlias(Result expect, AliasAnalysis a, Event x, Event y) {
        switch (expect) {
            case NONE:
                assertFalse(a.mayObjectAlias(x, y));
                assertFalse(a.mustObjectAlias(x, y));
                break;
            case MAY:
                assertTrue(a.mayObjectAlias(x, y));
                assertFalse(a.mustObjectAlias(x, y));
                break;
            case MUST:
                assertTrue(a.mayObjectAlias(x, y));
                assertTrue(a.mustObjectAlias(x, y));
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

    @Test
    public void allKindsOfMixedSizeAccesses() throws Exception {
        TypeFactory types = TypeFactory.getInstance();
        ExpressionFactory expressions = ExpressionFactory.getInstance();
        IntegerType pointerType = types.getArchType();
        ProgramBuilder b = ProgramBuilder.forLanguage(Program.SourceLanguage.LITMUS);
        b.newThread(0);
        Register r8 = b.getOrNewRegister(0, "r8", types.getIntegerType(8));
        Register r16 = b.getOrNewRegister(0, "r16", types.getIntegerType(16));
        Register r32 = b.getOrNewRegister(0, "r32", types.getIntegerType(32));
        Register r64 = b.getOrNewRegister(0, "r64", types.getIntegerType(64));
        final var expected = new ArrayList<String>();
        final int OBJECT_SIZE = 16; // two times max size (in bytes)
        for (int i = 0; i < 16; i++) { // squared number of access sizes (four)
            final Register r = List.of(r8, r16, r32, r64).get(i % 4);
            final Register s = List.of(r8, r16, r32, r64).get(i / 4);
            final int rBytes = List.of(1, 2, 4, 8).get(i % 4);
            final int sBytes = List.of(1, 2, 4, 8).get(i / 4);
            final StringBuilder exp = new StringBuilder();
            for (int offset = 0; offset < 9; offset++) {
                final MemoryObject x = b.getOrNewMemoryObject(String.format("x%d:%d", i, offset), OBJECT_SIZE);
                final Expression address = expressions.makeAdd(x, expressions.makeValue(offset, pointerType));
                b.addChild(0, newLoad(r, x));
                b.addChild(0, newLoad(s, address));
                if (0 < offset && offset < rBytes) {
                    exp.append(offset);
                }
                if (0 < offset + sBytes && offset + sBytes < rBytes) {
                    exp.append(offset + sBytes);
                }
                exp.append(',');
                if (offset < rBytes && rBytes < offset + sBytes) {
                    exp.append(rBytes - offset);
                }
                exp.append(' ');
            }
            expected.add(exp.toString());
        }

        Program program = b.build();
        Configuration config = Configuration.defaultConfiguration();
        ProcessingManager.fromConfig(config).run(program);

        // For this test, initializations are ignored.
        assertFalse(program.getThreadEvents(Init.class).isEmpty());
        program.getThreadEvents(Init.class).forEach(Event::tryDelete);

        Context analysisContext = Context.create();
        analysisContext.register(BranchEquivalence.class, BranchEquivalence.fromConfig(program, config));
        analysisContext.register(ExecutionAnalysis.class, ExecutionAnalysis.fromConfig(program,
                ProgressModel.defaultHierarchy(), analysisContext, config));
        analysisContext.register(ReachingDefinitionsAnalysis.class,
                ReachingDefinitionsAnalysis.fromConfig(program, analysisContext, config));
        assertTrue(program.getThreadEvents(Init.class).isEmpty());
        AliasAnalysis alias = AliasAnalysis.fromConfig(program, analysisContext, config, true);
        List<MemoryCoreEvent> events = program.getThreadEvents(MemoryCoreEvent.class);
        final var actual = new ArrayList<String>();
        for (int i = 0; i < 16; i++) {
            final var act = new StringBuilder();
            for (int offset = 0; offset < 9; offset++) {
                alias.mayMixedSizeAccesses(events.get(i * 18 + offset * 2)).forEach(act::append);
                act.append(',');
                alias.mayMixedSizeAccesses(events.get(i * 18 + offset * 2 + 1)).forEach(act::append);
                act.append(' ');
            }
            actual.add(act.toString());
        }
        assertArrayEquals(expected.toArray(), actual.toArray());
    }

    @Test
    public void mixedSizeReadModifyWrite() throws Exception {
        TypeFactory types = TypeFactory.getInstance();
        ExpressionFactory expressions = ExpressionFactory.getInstance();
        ProgramBuilder b = ProgramBuilder.forLanguage(Program.SourceLanguage.LITMUS);
        MemoryObject x = b.getOrNewMemoryObject("x", 16);
        b.newThread(0);
        b.newThread(1);
        IntegerType u32 = types.getIntegerType(32);
        IntegerType u64 = types.getIntegerType(64);
        Register r64 = b.getOrNewRegister(0, "r64", u64);
        b.addChild(0, newRMWLoadExclusive(r64, x));
        b.addChild(0, newRMWStoreExclusive(x, expressions.makeValue(0, u64), true));
        b.addChild(1, newStore(x, expressions.makeValue(0, u32)));

        Program program = b.build();
        Wmm wmm = new Wmm();
        Relation rmw = wmm.getOrCreatePredefinedRelation(LXSX);
        Relation rf = wmm.getOrCreatePredefinedRelation(RF);
        Relation co = wmm.getOrCreatePredefinedRelation(CO);
        Relation rfRmw = wmm.addDefinition(new Composition(wmm.newRelation(), rf, rmw));
        Relation coCo = wmm.addDefinition(new Composition(wmm.newRelation(), co, co));
        wmm.addConstraint(new Emptiness(wmm.addDefinition(new Intersection(wmm.newRelation(), rfRmw, coCo))));
        Configuration config = Configuration.builder().setOption(MIXED_SIZE, "true").build();
        VerificationTask task = VerificationTask.builder().build(program, wmm, EnumSet.of(PROGRAM_SPEC));
        Context analysisContext = Context.create();
        ModelChecker.preprocessProgram(task, config);
        ModelChecker.performStaticProgramAnalyses(task, analysisContext, config);
        ModelChecker.performStaticWmmAnalyses(task, analysisContext, config);

        RelationAnalysis.Knowledge rmwKnowledge = analysisContext.get(RelationAnalysis.class).getKnowledge(rmw);
        assertEquals(4, rmwKnowledge.getMaySet().size());
    }
}
