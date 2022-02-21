package com.dat3m.dartagnan.miscellaneous;

import com.dat3m.dartagnan.configuration.Alias;
import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.op.BOpBin;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.analysis.AliasAnalysis;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.program.processing.LoopUnrolling;
import com.dat3m.dartagnan.program.processing.compilation.Compilation;
import org.junit.Test;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.math.BigInteger;

import static com.dat3m.dartagnan.configuration.Alias.*;
import static com.dat3m.dartagnan.configuration.OptionNames.ALIAS_METHOD;
import static com.dat3m.dartagnan.expression.IValue.*;
import static com.dat3m.dartagnan.expression.op.COpBin.*;
import static com.dat3m.dartagnan.expression.op.IOpBin.*;
import static com.dat3m.dartagnan.program.event.EventFactory.*;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

public class AliasAnalysisTest {

    private enum Result {NONE,MAY,MUST}
    private static final Result NONE = Result.NONE;
    private static final Result MAY = Result.MAY;
    private static final Result MUST = Result.MUST;

    @Test
    public void fieldsensitive0() throws InvalidConfigurationException {
        program0(FIELD_SENSITIVE,MAY,MAY,NONE,NONE,NONE,NONE);
    }

    @Test
    public void fieldinsensitive0() throws InvalidConfigurationException {
        program0(FIELD_INSENSITIVE,MAY,NONE,MAY,NONE,MAY,NONE);
    }

    private void program0(Alias method, Result... expect) throws InvalidConfigurationException {
        ProgramBuilder b = new ProgramBuilder();

        MemoryObject x = b.newObject("x",2);
        MemoryObject y = b.getOrNewObject("y");

        b.initThread(0);
        Register r0 = b.getOrCreateRegister(0,"r0",-1);
        //this is undefined behavior in C11
        //the expression does not match a sum, but x occurs in it
        b.addChild(0,newLocal(r0,mult(x,1)));
        Store e0 = newStore(r0);
        b.addChild(0,e0);
        Store e1 = newStore(plus(r0,1));
        b.addChild(0,e1);
        Store e2 = newStore(x);
        b.addChild(0,e2);
        Store e3 = newStore(y);
        b.addChild(0,e3);

        AliasAnalysis a = analyze(b,method);
        assertAlias(expect[0],a,e0,e1);//precisely no
        assertAlias(expect[1],a,e0,e2);
        assertAlias(expect[2],a,e1,e2);
        assertAlias(expect[3],a,e0,e3);
        assertAlias(expect[4],a,e1,e3);
        assertAlias(expect[5],a,e2,e3);
    }

    @Test
    public void fieldsensitive1() throws InvalidConfigurationException {
        program1(FIELD_SENSITIVE,NONE,NONE,MUST,MUST,NONE,NONE);
    }

    @Test
    public void fieldinsensitive1() throws InvalidConfigurationException {
        program1(FIELD_INSENSITIVE,NONE,NONE,MUST,MAY,MAY,MAY);
    }

    private void program1(Alias method, Result... expect) throws InvalidConfigurationException {
        ProgramBuilder b = new ProgramBuilder();
        MemoryObject x = b.newObject("x",3);
        x.setInitialValue(0,x);

        b.initThread(0);
        Store e0 = newStore(plus(x,1));
        b.addChild(0,e0);
        Register r0 = b.getOrCreateRegister(0,"r0",-1);
        Load e1 = newLoad(r0,x);
        b.addChild(0,e1);
        Store e2 = newStore(r0);
        b.addChild(0,e2);
        Store e3 = newStore(plus(r0,1),r0);
        b.addChild(0,e3);

        AliasAnalysis a = analyze(b,method);
        assertAlias(expect[0],a,e0,e1);
        assertAlias(expect[1],a,e0,e2);
        assertAlias(expect[2],a,e1,e2);
        assertAlias(expect[3],a,e0,e3);
        assertAlias(expect[4],a,e1,e3);
        assertAlias(expect[5],a,e2,e3);
    }

    @Test
    public void fieldsensitive2() throws InvalidConfigurationException {
        program2(FIELD_SENSITIVE,NONE,NONE,NONE,MAY,NONE,MAY);
    }

    @Test
    public void fieldinsensitive2() throws InvalidConfigurationException {
        program2(FIELD_INSENSITIVE,NONE,NONE,NONE,MAY,MAY,MAY);
    }

    private void program2(Alias method, Result... expect) throws InvalidConfigurationException {
        ProgramBuilder b = new ProgramBuilder();
        MemoryObject x = b.newObject("x",3);

        b.initThread(0);
        Register r0 = b.getOrCreateRegister(0,"r0",-1);
        b.addChild(0,newLocal(r0,new INonDet(INonDetTypes.INT,-1)));
        Label l0 = b.getOrCreateLabel("l0");
        b.addChild(0,newJump(new BExprBin(new Atom(r0,GT,ONE),BOpBin.OR,new Atom(r0,LT,ZERO)),l0));
        Store e0 = newStore(x);
        b.addChild(0,e0);
        Store e1 = newStore(plus(x,1));
        b.addChild(0,e1);
        Store e2 = newStore(plus(x,2));
        b.addChild(0,e2);
        Register r1 = b.getOrCreateRegister(0,"r1",-1);
        b.addChild(0,newLocal(r1,ZERO));
        Store e3 = newStore(new IExprBin(new IExprBin(x,PLUS,mult(r0,2)),PLUS,mult(r1,4)));
        b.addChild(0,e3);
        b.addChild(0,l0);

        AliasAnalysis a = analyze(b,method);
        assertAlias(expect[0],a,e0,e1);
        assertAlias(expect[1],a,e0,e2);
        assertAlias(expect[2],a,e1,e2);
        assertAlias(expect[3],a,e0,e3);
        assertAlias(expect[4],a,e1,e3);
        assertAlias(expect[5],a,e2,e3);
    }

    @Test
    public void fieldsensitive3() throws InvalidConfigurationException {
        program3(FIELD_SENSITIVE,MUST,NONE,NONE,MAY,MAY,MAY);
    }

    @Test
    public void fieldinsensitive3() throws InvalidConfigurationException {
        program3(FIELD_INSENSITIVE,MUST,NONE,NONE,MAY,MAY,MAY);
    }

    private void program3(Alias method, Result... expect) throws InvalidConfigurationException {
        ProgramBuilder b = new ProgramBuilder();
        MemoryObject x = b.newObject("x",3);
        x.setInitialValue(0,x);

        b.initThread(0);
        Register r0 = b.getOrCreateRegister(0,"r0",-1);
        Load e0 = newLoad(r0,x);
        b.addChild(0,e0);
        Store e1 = newStore(x,plus(r0,1));
        b.addChild(0,e1);
        Store e2 = newStore(plus(x,2));
        b.addChild(0,e2);
        Store e3 = newStore(r0);
        b.addChild(0,e3);

        AliasAnalysis a = analyze(b,method);
        assertAlias(expect[0],a,e0,e1);
        assertAlias(expect[1],a,e0,e2);
        assertAlias(expect[2],a,e1,e2);
        assertAlias(expect[3],a,e0,e3);
        assertAlias(expect[4],a,e1,e3);
        assertAlias(expect[5],a,e2,e3);//precisely no
    }

    @Test
    public void fieldsensitive4() throws InvalidConfigurationException {
        program4(FIELD_SENSITIVE,MAY,MAY,NONE,NONE,NONE,NONE);
    }

    @Test
    public void fieldinsensitive4() throws InvalidConfigurationException {
        program4(FIELD_INSENSITIVE,NONE,MUST,NONE,NONE,NONE,NONE);
    }

    private void program4(Alias method, Result... expect) throws InvalidConfigurationException {
        ProgramBuilder b = new ProgramBuilder();
        MemoryObject x = b.getOrNewObject("x");
        MemoryObject y = b.getOrNewObject("y");
        MemoryObject z = b.getOrNewObject("z");

        b.initThread(0);
        Register r0 = b.getOrCreateRegister(0,"r0",-1);
        b.addChild(0,newLocal(r0,mult(x,0)));
        b.addChild(0,newLocal(r0,y));
        Store e0 = newStore(r0);
        b.addChild(0,e0);
        Store e1 = newStore(x);
        b.addChild(0,e1);
        Store e2 = newStore(y);
        b.addChild(0,e2);
        Store e3 = newStore(z);
        b.addChild(0,e3);

        AliasAnalysis a = analyze(b,method);
        assertAlias(expect[0],a,e0,e1);//precisely no
        assertAlias(expect[1],a,e0,e2);//precisely must
        assertAlias(expect[2],a,e1,e2);
        assertAlias(expect[3],a,e0,e3);
        assertAlias(expect[4],a,e1,e3);
        assertAlias(expect[5],a,e2,e3);
    }

    @Test
    public void fieldsensitive5() throws InvalidConfigurationException {
        program5(FIELD_SENSITIVE,MAY,MAY,NONE,NONE,NONE,NONE);
    }

    @Test
    public void fieldinsensitive5() throws InvalidConfigurationException {
        program5(FIELD_INSENSITIVE,MUST,NONE,NONE,NONE,NONE,NONE);
    }

    private void program5(Alias method, Result... expect) throws InvalidConfigurationException {
        ProgramBuilder b = new ProgramBuilder();
        MemoryObject x = b.getOrNewObject("x");
        MemoryObject y = b.getOrNewObject("y");
        MemoryObject z = b.getOrNewObject("z");

        b.initThread(0);
        Register r0 = b.getOrCreateRegister(0,"r0",-1);
        b.addChild(0,newLocal(r0,y));
        Store e0 = newStore(r0);
        b.addChild(0,e0);
        b.addChild(0,newLocal(r0,mult(x,0)));
        Store e1 = newStore(x);
        b.addChild(0,e1);
        Store e2 = newStore(y);
        b.addChild(0,e2);
        Store e3 = newStore(z);
        b.addChild(0,e3);

        AliasAnalysis a = analyze(b,method);
        assertAlias(expect[0],a,e0,e1);//precisely no
        assertAlias(expect[1],a,e0,e2);//precisely must
        assertAlias(expect[2],a,e1,e2);
        assertAlias(expect[3],a,e0,e3);
        assertAlias(expect[4],a,e1,e3);
        assertAlias(expect[5],a,e2,e3);
    }

    private Load newLoad(Register value, IExpr address) {
        return EventFactory.newLoad(value,address,null);
    }

    private Store newStore(IExpr address) {
        return newStore(address,ZERO);
    }

    private Store newStore(IExpr address, IExpr value) {
        return EventFactory.newStore(address,value,null);
    }

    private IExpr plus(IExpr lhs, long rhs) {
        return new IExprBin(lhs,PLUS,new IValue(BigInteger.valueOf(rhs),-1));
    }

    private IExpr mult(IExpr lhs, long rhs) {
        return new IExprBin(lhs,MULT,new IValue(BigInteger.valueOf(rhs),-1));
    }

    private AliasAnalysis analyze(ProgramBuilder builder, Alias method) throws InvalidConfigurationException {
        Program program = builder.build();
        LoopUnrolling.newInstance().run(program);
        Compilation.newInstance().run(program);
        return AliasAnalysis.fromConfig(program,Configuration.builder().setOption(ALIAS_METHOD,method.asStringOption()).build());
    }

    private void assertAlias(Result expect, AliasAnalysis a, MemEvent x, MemEvent y) {
        switch(expect) {
            case NONE:
                assertFalse(a.mayAlias(x,y));
                assertFalse(a.mustAlias(x,y));
                break;
            case MAY:
                assertTrue(a.mayAlias(x,y));
                assertFalse(a.mustAlias(x,y));
                break;
            case MUST:
                assertTrue(a.mayAlias(x,y));
                assertTrue(a.mustAlias(x,y));
                break;
        }
    }

}
