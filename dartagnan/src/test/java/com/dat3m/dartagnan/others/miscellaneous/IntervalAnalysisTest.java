package com.dat3m.dartagnan.others.miscellaneous;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.IntervalAnalysisOptions;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.analysis.interval.Interval;
import com.dat3m.dartagnan.program.analysis.interval.IntervalAnalysis;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.program.processing.ProcessingManager;

import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Wmm;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import org.junit.Test;

import java.io.File;
import java.io.IOException;
import java.math.BigInteger;
import java.util.EnumSet;

import static com.dat3m.dartagnan.configuration.OptionNames.ENABLE_EXTENDED_RELATION_ANALYSIS;
import static com.dat3m.dartagnan.configuration.OptionNames.INTERVAL_ANALYSIS_METHOD;
import static com.dat3m.dartagnan.configuration.Property.PROGRAM_SPEC;
import static com.dat3m.dartagnan.program.event.EventFactory.*;
import static com.dat3m.dartagnan.program.event.EventFactory.newLocal;
import static com.dat3m.dartagnan.utils.ResourceHelper.getRootPath;
import static com.dat3m.dartagnan.verification.solving.ModelChecker.*;
import static org.junit.Assert.assertEquals;


public class IntervalAnalysisTest {
    private static final TypeFactory types = TypeFactory.getInstance();
    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();
    private IntervalAnalysis runIntervalAnalysis(Program p, IntervalAnalysisOptions method) throws InvalidConfigurationException, IOException {
        final String modelPath = "cat/sc.cat";
        Configuration config = Configuration.builder()
                .setOption(INTERVAL_ANALYSIS_METHOD,method.asStringOption())
                .setOption(ENABLE_EXTENDED_RELATION_ANALYSIS, "false")
                .build();
        ProcessingManager.fromConfig(config).run(p);
        final Wmm wmm = new ParserCat().parse(new File(getRootPath(modelPath)));
        final VerificationTask task = VerificationTask.builder()
                .withConfig(config)
                .withBound(1)
                .withTarget(Arch.C11)
                .build(p, wmm, EnumSet.of(PROGRAM_SPEC));
        wmm.configureAll(task.getConfig());
        final Context context = Context.create();
        performStaticProgramAnalyses(task,context,config);
        performStaticWmmAnalyses(task,context,config);
        performIntervalAnalysis(task,context,config);
        return context.get(IntervalAnalysis.class);



    }


    @Test
    public void straightlinePropagation() throws IOException, InvalidConfigurationException {
        ProgramBuilder b = ProgramBuilder.forLanguage(Program.SourceLanguage.LITMUS);
        b.newThread(0);
        IntegerType type = types.getArchType();
        Register r0 = b.getOrNewRegister(0, "r0");
        Register r1 = b.getOrNewRegister(0, "r1");
        Register r2 = b.getOrNewRegister(0, "r2");
        Local assignment0 = new Local(r0,expressions.makeZero(type));
        Local assignment1 = new Local(r1,expressions.makeValue(42,type));
        Local assignment2 = new Local(r2, expressions.makeValue(7,type));
        Label exit = b.getOrCreateLabel(0, "exit");

        b.addChild(0,assignment0);
        b.addChild(0,assignment1);
        b.addChild(0,assignment2);
        b.addChild(0,exit);

        Program p = b.build();
        IntervalAnalysis analysis = runIntervalAnalysis(p,IntervalAnalysisOptions.LOCAL);
        Interval i0 = new Interval(BigInteger.ZERO, BigInteger.ZERO,type);
        Interval i1 = new Interval(new BigInteger("42"),new BigInteger("42"),type);
        Interval i2 = new Interval(new BigInteger("7"),new BigInteger("7"),type);

        // r0
        assertEquals(i0, analysis.getIntervalAt(assignment1,r0));
        assertEquals(i0, analysis.getIntervalAt(assignment2,r0));
        assertEquals(i0, analysis.getIntervalAt(exit,r0));


        assertEquals(i1, analysis.getIntervalAt(assignment2,r1));
        assertEquals(i1, analysis.getIntervalAt(exit,r1));


        assertEquals(i2, analysis.getIntervalAt(exit,r2));


    }

    @Test
    public void twoPredecessors() throws IOException, InvalidConfigurationException {

        ProgramBuilder b = ProgramBuilder.forLanguage(Program.SourceLanguage.LITMUS);
        b.newThread(0);
        IntegerType type = types.getArchType();
        Register r0 = b.getOrNewRegister(0, "r0");
        Label trueb = b.getOrCreateLabel(0, "true");
        Label join = b.getOrCreateLabel(0, "join");
        Label exit = b.getOrCreateLabel(0, "exit");
        CondJump jump = newJump(b.newConstant(types.getBooleanType()), trueb);
        CondJump goto1 = newGoto(join);
        CondJump goto2 = newGoto(join);

        Local assignment0 = new Local(r0,expressions.makeZero(type));
        Local assignment1 = new Local(r0,expressions.makeValue(42,type));

        b.addChild(0,jump);
        b.addChild(0,assignment0);
        b.addChild(0,goto1);
        b.addChild(0,trueb);
        b.addChild(0,assignment1);
        b.addChild(0,goto2);
        b.addChild(0,join);
        b.addChild(0,exit);

        Program p = b.build();

        IntervalAnalysis analysis = runIntervalAnalysis(p,IntervalAnalysisOptions.LOCAL);
        Interval i0 = new Interval(BigInteger.ZERO,new BigInteger("42"),type);
        assertEquals(i0,analysis.getIntervalAt(join,r0));

    }



    @Test
    public void threePredecessors() throws IOException, InvalidConfigurationException {

        ProgramBuilder b = ProgramBuilder.forLanguage(Program.SourceLanguage.LITMUS);
        b.newThread(0);
        IntegerType type = types.getArchType();
        Register r0 = b.getOrNewRegister(0, "r0");
        Label branch1 = b.getOrCreateLabel(0, "branch1");
        Label branch2 = b.getOrCreateLabel(0, "branch2");
        Label join = b.getOrCreateLabel(0, "join");
        Label exit = b.getOrCreateLabel(0, "exit");
        CondJump jump1 = newJump(b.newConstant(types.getBooleanType()), branch1);
        CondJump jump2 = newJump(b.newConstant(types.getBooleanType()), branch2);

        CondJump goto1 = newGoto(join);
        CondJump goto2 = newGoto(join);
        CondJump goto3 = newGoto(join);

        Local assignment0 = new Local(r0,expressions.makeZero(type));
        Local assignment1 = new Local(r0,expressions.makeValue(42,type));
        Local assignment2 = new Local(r0,expressions.makeValue(7,type));

        b.addChild(0,jump1);
        b.addChild(0,jump2);
        b.addChild(0,assignment0);
        b.addChild(0,goto1);
        b.addChild(0,branch1);
        b.addChild(0,assignment1);
        b.addChild(0,goto2);
        b.addChild(0,branch2);
        b.addChild(0,assignment2);
        b.addChild(0,goto3);
        b.addChild(0,join);
        b.addChild(0,exit);

        Program p = b.build();

        IntervalAnalysis analysis = runIntervalAnalysis(p,IntervalAnalysisOptions.LOCAL);
        Interval i0 = new Interval(BigInteger.ZERO,new BigInteger("42"),type);
        assertEquals(i0,analysis.getIntervalAt(join,r0));

    }
    @Test
    public void evaluateSimpleExpressions() throws IOException, InvalidConfigurationException {
        ProgramBuilder b = ProgramBuilder.forLanguage(Program.SourceLanguage.LITMUS);
        b.newThread(0);
        IntegerType type = types.getArchType();
        Register r0 = b.getOrNewRegister(0,"r0");
        Register r1 = b.getOrNewRegister(0,"r1");
        Register r2 = b.getOrNewRegister(0,"r2");

        Local loc1 = newLocal(r0,expressions.makeZero(type));
        Local loc2 = newLocal(r1,r0);
        Local loc3 = newLocal(r1,r2);

        Label exit = b.getOrCreateLabel(0,"exit");
        b.addChild(0,loc1);
        b.addChild(0,loc2);
        b.addChild(0,loc3);
        b.addChild(0,exit);

        Program p = b.build();
        IntervalAnalysis analysis = runIntervalAnalysis(p,IntervalAnalysisOptions.LOCAL);
        Interval expected = new Interval(BigInteger.ZERO,BigInteger.ZERO,type);
        assertEquals(analysis.getIntervalAt(loc2,r0),expected);
        assertEquals(analysis.getIntervalAt(loc3,r1),expected);
        assertEquals(analysis.getIntervalAt(exit,r1),Interval.getTop(type));



    }
    @Test
    public void evaluateBinaryExpressions() throws IOException, InvalidConfigurationException {
        ProgramBuilder b = ProgramBuilder.forLanguage(Program.SourceLanguage.LITMUS);
        b.newThread(0);
        IntegerType type = types.getArchType();
        Register r0 = b.getOrNewRegister(0,"r0");
        Register r1 = b.getOrNewRegister(0,"r1");

        Local loc1 = newLocal(r0,expressions.makeZero(type));
        Local loc2 = newLocal(r0,expressions.makeAdd(r0,expressions.makeValue(1,type)));
        Local loc3 = newLocal(r1,expressions.makeAdd(r0,r0));
        Label exit = b.getOrCreateLabel(0,"exit");

        b.addChild(0,loc1);
        b.addChild(0,loc2);
        b.addChild(0,loc3);
        b.addChild(0,exit);

        Program p = b.build();
        IntervalAnalysis analysis = runIntervalAnalysis(p,IntervalAnalysisOptions.LOCAL);
        Interval r0Expected = new Interval(BigInteger.ONE,BigInteger.ONE,type);
        Interval r1Expected = new Interval(new BigInteger("2"),new BigInteger("2"),type);
        assertEquals(analysis.getIntervalAt(loc3,r0),r0Expected);
        assertEquals(analysis.getIntervalAt(exit,r1),r1Expected);

    }
    // @Test
    // public void

    @Test
    public void binaryExpressionsWithTopReturnsTop() throws IOException, InvalidConfigurationException {
        ProgramBuilder b = ProgramBuilder.forLanguage(Program.SourceLanguage.LITMUS);
        b.newThread(0);
        IntegerType type = types.getArchType();
        Register r0 = b.getOrNewRegister(0,"r0");
        Register r1 = b.getOrNewRegister(0,"r1");

        Local loc1 = newLocal(r0,expressions.makeZero(type));
        Local loc2 = newLocal(r0,expressions.makeAdd(r0,expressions.makeValue(1,type)));
        Local loc3 = newLocal(r1,expressions.makeAdd(r0,r1));
        Label exit = b.getOrCreateLabel(0,"exit");

        b.addChild(0,loc1);
        b.addChild(0,loc2);
        b.addChild(0,loc3);
        b.addChild(0,exit);

        Program p = b.build();
        IntervalAnalysis analysis = runIntervalAnalysis(p,IntervalAnalysisOptions.LOCAL);
        Interval r0Expected = new Interval(BigInteger.ONE,BigInteger.ONE,type);
        Interval r1Expected = Interval.getTop(type);
        assertEquals(analysis.getIntervalAt(loc3,r0),r0Expected);
        assertEquals(analysis.getIntervalAt(exit,r1),r1Expected);

    }

    @Test
    public void castExpressionsAlwaysFit() throws IOException, InvalidConfigurationException {

        ProgramBuilder b = ProgramBuilder.forLanguage(Program.SourceLanguage.LITMUS);
        b.newThread(0);
        IntegerType byteType = types.getByteType();
        IntegerType wordType = types.getIntegerType(16);
        IntegerType intType  = types.getIntegerType(32);
        Register r0 = b.getOrNewRegister(0,"r0",wordType);
        Register r1 = b.getOrNewRegister(0,"r1",byteType);
        Register r2 = b.getOrNewRegister(0,"r2",intType);
        Local loc1 = newLocal(r0,expressions.makeValue(200,wordType));
        Local loc2 = newLocal(r1,expressions.makeIntegerCast(r0,byteType,true));
        Local loc3 = newLocal(r2,expressions.makeIntegerCast(r0,intType,true));
        Label exit = b.getOrCreateLabel(0,"exit");

        b.addChild(0,loc1);
        b.addChild(0,loc2);
        b.addChild(0,loc3);
        b.addChild(0,exit);

        Program p = b.build();
        IntervalAnalysis analysis = runIntervalAnalysis(p,IntervalAnalysisOptions.LOCAL);
        Interval truncExpected = new Interval(new BigInteger("200"),new BigInteger("200"),byteType);
        Interval extExpected = new Interval(new BigInteger("200"),new BigInteger("200"),intType);
        assertEquals(analysis.getIntervalAt(loc3,r1),truncExpected);
        assertEquals(analysis.getIntervalAt(exit,r2),extExpected);
    }

    @Test
    public void truncationCausesOverflow() throws IOException, InvalidConfigurationException {

        ProgramBuilder b = ProgramBuilder.forLanguage(Program.SourceLanguage.LITMUS);
        b.newThread(0);
        IntegerType wordType = types.getIntegerType(16);
        IntegerType byteType = types.getByteType();
        Register r0 = b.getOrNewRegister(0,"r0",wordType);
        Register r1 = b.getOrNewRegister(0,"r1",byteType);

        Local loc1  = newLocal(r0,expressions.makeValue(1000,wordType));
        Local loc2  = newLocal(r1,expressions.makeIntegerCast(r0,byteType,true));
        Label exit = b.getOrCreateLabel(0,"exit");

        b.addChild(0,loc1);
        b.addChild(0,loc2);
        b.addChild(0,exit);
        Program p = b.build();
        IntervalAnalysis analysis = runIntervalAnalysis(p,IntervalAnalysisOptions.LOCAL);
        Interval expected = Interval.getTop(byteType);
        assertEquals(expected,analysis.getIntervalAt(exit,r1));

    }



    @Test
    public void combineBranchesOfITE() throws IOException, InvalidConfigurationException {
        ProgramBuilder b = ProgramBuilder.forLanguage(Program.SourceLanguage.LITMUS);
        b.newThread(0);
        IntegerType type = types.getArchType();
        Register r0 = b.getOrNewRegister(0,"r0",type);

        Local loc1 = newLocal(r0,expressions.makeITE(b.newConstant(types.getBooleanType()), expressions.makeZero(type),expressions.makeOne(type)));
        Label exit = b.getOrCreateLabel(0,"exit");

        b.addChild(0,loc1);
        b.addChild(0,exit);

        Program p = b.build();
        IntervalAnalysis analysis = runIntervalAnalysis(p,IntervalAnalysisOptions.LOCAL);

        Interval expected = new Interval(BigInteger.ZERO,BigInteger.ONE,type);
        assertEquals(expected,analysis.getIntervalAt(exit,r0));
    }






    @Test
    public void globalAnalysisFixpointIteration() throws IOException, InvalidConfigurationException {
        // Create sample program
        ProgramBuilder b = ProgramBuilder.forLanguage(Program.SourceLanguage.LITMUS);
        MemoryObject x = b.newMemoryObject("x", 1);
        MemoryObject y = b.newMemoryObject("y", 1);
	IntegerType type = types.getArchType();
        x.setInitialValue(0, expressions.makeZero(type));
        y.setInitialValue(0, expressions.makeZero(type));
        b.newThread(0);
        b.newThread(1);
        b.newThread(2);
        // Interval is TOP during local analysis and should become [0,3] after local analyses are done
        Register r0 = b.getOrNewRegister(0,"r0");

        // Interval is calculated by joining each store
        Register r1 = b.getOrNewRegister(1,"r1");
        Register r2 = b.getOrNewRegister(2,"r2");

        // New load values propagated to RegReader
        Register r4 = b.getOrNewRegister(0,"r4");

        Local loc0 = newLocal(r4,r0);

        Load l0 = newLoad(r0,x);
        Load l1 = newLoad(r1,y);
        Load l2 = newLoad(r2,y);


        Store s0 = newStore(x,r1);
        Store s1 = newStore(y,expressions.makeValue(1,type));
        Store s2 = newStore(y,expressions.makeValue(2,type));
        Store s3 = newStore(y,expressions.makeValue(3,type));

        Label exit0 =  b.getOrCreateLabel(0, "exit0");
        Label exit1 =  b.getOrCreateLabel(1, "exit1");
        Label exit2 =  b.getOrCreateLabel(2, "exit2");


        // T0
        b.addChild(0,l0);
        b.addChild(0,loc0);
        b.addChild(0,exit0);

        // T1
        b.addChild(1,l1);
        b.addChild(1,s0);
        b.addChild(1,exit1);

        // T2
        b.addChild(2,l2);
        b.addChild(2,s1);
        b.addChild(2,s2);
        b.addChild(2,s3);
        b.addChild(2,exit2);



        Program p = b.build();
        IntervalAnalysis analysis = runIntervalAnalysis(p,IntervalAnalysisOptions.GLOBAL);
        assertEquals(new Interval(BigInteger.ZERO,new BigInteger("3"),type), analysis.getIntervalAt(exit0,r0));
        assertEquals(new Interval(BigInteger.ZERO,new BigInteger("3"),type), analysis.getIntervalAt(exit0,r4));
        assertEquals(new Interval(BigInteger.ZERO,new BigInteger("3"),type), analysis.getIntervalAt(exit1,r1));
        assertEquals(new Interval(BigInteger.ZERO,BigInteger.ZERO,type), analysis.getIntervalAt(exit2,r2));



    }

}
