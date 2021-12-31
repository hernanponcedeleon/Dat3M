package com.dat3m.dartagnan.exceptions;

import com.dat3m.dartagnan.expression.BConst;
import com.dat3m.dartagnan.expression.BNonDet;
import com.dat3m.dartagnan.expression.IExprBin;
import com.dat3m.dartagnan.expression.INonDet;
import com.dat3m.dartagnan.expression.INonDetTypes;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.exception.*;
import com.dat3m.dartagnan.parsers.program.utils.*;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.CondJump;
import com.dat3m.dartagnan.program.event.Label;
import com.dat3m.dartagnan.program.event.Skip;
import com.dat3m.dartagnan.utils.ResourceHelper;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.utils.TestHelper;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.Arch;

import static com.dat3m.dartagnan.utils.TestHelper.createContext;

import java.io.File;

import org.junit.Test;
import org.sosy_lab.java_smt.api.ProverEnvironment;
import org.sosy_lab.java_smt.api.SolverContext;
import org.sosy_lab.java_smt.api.SolverContext.ProverOptions;

public class ExceptionsTest {

    @Test(expected = MalformedProgramException.class)
    public void noThread() throws Exception {
    	ProgramBuilder pb = new ProgramBuilder();
    	// Thread 1 does not exists
    	pb.addChild(1, new Skip());
    }

    @Test(expected = MalformedProgramException.class)
    public void RegisterAlreadyExist() throws Exception {
    	ProgramBuilder pb = new ProgramBuilder();
    	pb.initThread(0);
    	Program p = pb.build();
    	Thread t = p.getThreads().get(0);
    	t.addRegister("r1", -1);
    	t.addRegister("r1", -1);
    }

    @Test(expected = IllegalStateException.class)
    public void performRelationalAnalysisException() throws Exception {
		Wmm cat = new ParserCat().parse(new File(ResourceHelper.CAT_RESOURCE_PATH+ "cat/tso.cat"));
		cat.performRelationalAnalysis(true);
    }

    @Test(expected = IllegalStateException.class)
    public void encodeConsistencyException() throws Exception {
		Wmm cat = new ParserCat().parse(new File(ResourceHelper.CAT_RESOURCE_PATH+ "cat/tso.cat"));
		cat.encodeConsistency(TestHelper.createContext());
    }

    @Test(expected = IllegalStateException.class)
    public void compileBeforeUnrollException() throws Exception {
    	ProgramBuilder pb = new ProgramBuilder();
    	pb.initThread(0);
    	Program p = pb.build();
    	p.compile(Arch.NONE, 0);
    }

    @Test(expected = IllegalStateException.class)
    public void unrollBeforeReorderException() throws Exception {
    	ProgramBuilder pb = new ProgramBuilder();
    	pb.initThread(0);
    	Program p = pb.build();
    	p.unroll(1, 0);
    	p.reorder();
    }

    @Test(expected = IllegalStateException.class)
    public void initializedBeforeCompileException() throws Exception {
    	ProgramBuilder pb = new ProgramBuilder();
    	pb.initThread(0);
    	Program p = pb.build();
		Wmm cat = new ParserCat().parse(new File(ResourceHelper.CAT_RESOURCE_PATH+ "cat/tso.cat"));
    	VerificationTask task = new VerificationTask(p, cat, Arch.TSO, new Settings(1, 10));
    	p.initialise(task, TestHelper.createContext());
    }

    @Test(expected = IllegalStateException.class)
    public void unrollBeforeDCEException() throws Exception {
    	ProgramBuilder pb = new ProgramBuilder();
    	pb.initThread(0);
    	Program p = pb.build();
    	p.unroll(1, 0);
    	p.eliminateDeadCode();
    }

    @Test(expected = IllegalStateException.class)
    public void encodeCFException() throws Exception {
    	ProgramBuilder pb = new ProgramBuilder();
    	pb.initThread(0);
    	Program p = pb.build();
    	p.encodeCF(TestHelper.createContext());
    }

    @Test(expected = IllegalStateException.class)
    public void encodeFinalRegisterValuesException() throws Exception {
    	ProgramBuilder pb = new ProgramBuilder();
    	pb.initThread(0);
    	Program p = pb.build();
    	p.encodeFinalRegisterValues(TestHelper.createContext());
    }

    @Test(expected = IllegalStateException.class)
    public void encodeNoBoundEventExecException() throws Exception {
    	ProgramBuilder pb = new ProgramBuilder();
    	pb.initThread(0);
    	Program p = pb.build();
    	p.encodeNoBoundEventExec(TestHelper.createContext());
    }

    @Test(expected = IllegalArgumentException.class)
    public void diffPrecisionInt() throws Exception {
    	IExprBin bin = new IExprBin(new Register("a", 0, 32), IOpBin.PLUS, new Register("b", 0, 64));
    	bin.getPrecision();
    }

    @Test(expected = RuntimeException.class)
    public void noModelBNonDet() throws Exception {
	    try (SolverContext ctx = createContext();
	    		ProverEnvironment prover = ctx.newProverEnvironment(ProverOptions.GENERATE_MODELS))
	    {
	    	BNonDet nonDet = new BNonDet(32);
	    	nonDet.getBoolValue(null, prover.getModel(), ctx);
	    }
    }

    @Test(expected = RuntimeException.class)
    public void noModelINonDet() throws Exception {
	    try (SolverContext ctx = createContext();
	    		ProverEnvironment prover = ctx.newProverEnvironment(ProverOptions.GENERATE_MODELS))
	    {
	    	INonDet nonDet = new INonDet(INonDetTypes.INT, 32);
	    	nonDet.getIntValue(null, prover.getModel(), ctx);
	    }
    }
    
    @Test(expected = NullPointerException.class)
    public void JumpWithNullLabel() throws Exception {
    	ProgramBuilder pb = new ProgramBuilder();
    	pb.initThread(0);
    	pb.addChild(0, new CondJump(BConst.FALSE, null));
    }

    @Test(expected = NullPointerException.class)
    public void JumpWithNullExpr() throws Exception {
    	ProgramBuilder pb = new ProgramBuilder();
    	pb.initThread(0);
    	Label end = pb.getOrCreateLabel("END");
    	pb.addChild(0, new CondJump(null, end));
    }
    
    @Test(expected = MalformedProgramException.class)
    public void DuplicatedLabel() throws Exception {
    	new ProgramParser().parse(new File(ResourceHelper.TEST_RESOURCE_PATH + "exceptions/DuplicatedLabel.litmus"));
    }

    @Test(expected = MalformedProgramException.class)
    public void IllegalJump() throws Exception {
    	new ProgramParser().parse(new File(ResourceHelper.TEST_RESOURCE_PATH + "exceptions/IllegalJump.litmus"));
    }

    @Test(expected = IllegalStateException.class)
    public void LocationNotInitialized() throws Exception {
    	new ProgramParser().parse(new File(ResourceHelper.TEST_RESOURCE_PATH + "exceptions/LocationNotInitialized.litmus"));
    }

    @Test(expected = IllegalStateException.class)
    public void RegisterNotInitialized() throws Exception {
    	new ProgramParser().parse(new File(ResourceHelper.TEST_RESOURCE_PATH + "exceptions/RegisterNotInitialized.litmus"));
    }
}
