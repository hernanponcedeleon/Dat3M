package com.dat3m.dartagnan.exceptions;

import com.dat3m.dartagnan.expression.Atom;
import com.dat3m.dartagnan.expression.BConst;
import com.dat3m.dartagnan.expression.BNonDet;
import com.dat3m.dartagnan.expression.IExprBin;
import com.dat3m.dartagnan.expression.INonDet;
import com.dat3m.dartagnan.expression.INonDetTypes;
import com.dat3m.dartagnan.expression.IfExpr;
import com.dat3m.dartagnan.expression.op.COpBin;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.parsers.program.exception.*;
import com.dat3m.dartagnan.parsers.program.utils.*;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.CondJump;
import com.dat3m.dartagnan.program.event.Label;
import com.dat3m.dartagnan.program.event.Skip;
import com.dat3m.dartagnan.utils.ResourceHelper;
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

    @Test(expected = AlreadyExistentVariableException.class)
    public void RegisterAlreadyExist() throws Exception {
    	ProgramBuilder pb = new ProgramBuilder();
    	pb.initThread(0);
    	Program p = pb.build();
    	Thread t = p.getThreads().get(0);
    	t.addRegister("r1", -1);
    	t.addRegister("r1", -1);
    }

    @Test(expected = IllegalStateException.class)
    public void CallMethodOrderException() throws Exception {
    	ProgramBuilder pb = new ProgramBuilder();
    	pb.initThread(0);
    	Program p = pb.build();
    	p.compile(Arch.NONE, 0);
    }

    @Test(expected = ExprTypeMismatchException.class)
    public void diffPrecisionAtom() throws Exception {
    	Atom atom = new Atom(new Register("a", 0, 32), COpBin.EQ, new Register("b", 0, 64));
    	atom.getPrecision();
    }

    @Test(expected = ExprTypeMismatchException.class)
    public void diffPrecisionInt() throws Exception {
    	IExprBin bin = new IExprBin(new Register("a", 0, 32), IOpBin.PLUS, new Register("b", 0, 64));
    	bin.getPrecision();
    }

    @Test(expected = ExprTypeMismatchException.class)
    public void diffPrecisionIfExpr() throws Exception {
    	IfExpr ifE = new IfExpr(BConst.TRUE, new Register("a", 0, 32), new Register("b", 0, 64));
    	ifE.getPrecision();
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
    
    @Test(expected = IllegalArgumentException.class)
    public void JumpWithNullLabel() throws Exception {
    	ProgramBuilder pb = new ProgramBuilder();
    	pb.initThread(0);
    	pb.addChild(0, new CondJump(BConst.FALSE, null));
    }

    @Test(expected = IllegalArgumentException.class)
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

    @Test(expected = UninitialisedVariableException.class)
    public void LocationNotInitialized() throws Exception {
    	new ProgramParser().parse(new File(ResourceHelper.TEST_RESOURCE_PATH + "exceptions/LocationNotInitialized.litmus"));
    }

    @Test(expected = UninitialisedVariableException.class)
    public void RegisterNotInitialized() throws Exception {
    	new ProgramParser().parse(new File(ResourceHelper.TEST_RESOURCE_PATH + "exceptions/RegisterNotInitialized.litmus"));
    }
}
