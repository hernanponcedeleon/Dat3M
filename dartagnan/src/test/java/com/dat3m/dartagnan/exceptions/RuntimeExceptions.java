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
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.CondJump;
import com.dat3m.dartagnan.program.event.Skip;
import org.junit.Test;
import org.sosy_lab.common.ShutdownManager;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.log.BasicLogManager;
import org.sosy_lab.java_smt.SolverContextFactory;
import org.sosy_lab.java_smt.api.ProverEnvironment;
import org.sosy_lab.java_smt.api.SolverContext;
import org.sosy_lab.java_smt.api.SolverContext.ProverOptions;

public class RuntimeExceptions {

    @Test(expected = RuntimeException.class)
    public void noThread() throws Exception {
    	ProgramBuilder pb = new ProgramBuilder();
    	// Thread 1 does not exists
    	pb.addChild(1, new Skip());
    }

    @Test(expected = RuntimeException.class)
    public void diffPrecisionAtom() throws Exception {
    	Atom atom = new Atom(new Register("a", 0, 32), COpBin.EQ, new Register("b", 0, 64));
    	atom.getPrecision();
    }

    @Test(expected = RuntimeException.class)
    public void diffPrecisionInt() throws Exception {
    	IExprBin bin = new IExprBin(new Register("a", 0, 32), IOpBin.PLUS, new Register("b", 0, 64));
    	bin.getPrecision();
    }

    @Test(expected = RuntimeException.class)
    public void lastValueIfExpr() throws Exception {
    	IfExpr ifE = new IfExpr(BConst.TRUE, new Register("a", 0, 32), new Register("b", 0, 64));
    	ifE.getLastValueExpr(null);
    }

    @Test(expected = RuntimeException.class)
    public void diffPrecisionIfExpr() throws Exception {
    	IfExpr ifE = new IfExpr(BConst.TRUE, new Register("a", 0, 32), new Register("b", 0, 64));
    	ifE.getPrecision();
    }

    @Test(expected = RuntimeException.class)
    public void noModelBNonDet() throws Exception {
	    Configuration config = Configuration.builder()
	            .setOption("solver.z3.usePhantomReferences", "true")
	            .build();
	    try (SolverContext ctx = SolverContextFactory.createSolverContext(
	            config,
	            BasicLogManager.create(config),
	            ShutdownManager.create().getNotifier(),
	            org.sosy_lab.java_smt.SolverContextFactory.Solvers.Z3);
	         ProverEnvironment prover = ctx.newProverEnvironment(ProverOptions.GENERATE_MODELS))
	    {
	    	BNonDet nonDet = new BNonDet(32);
	    	nonDet.getBoolValue(null, prover.getModel(), ctx);
	    }
    }

    @Test(expected = RuntimeException.class)
    public void noModelINonDet() throws Exception {
	    Configuration config = Configuration.builder()
	            .setOption("solver.z3.usePhantomReferences", "true")
	            .build();
	    try (SolverContext ctx = SolverContextFactory.createSolverContext(
	            config,
	            BasicLogManager.create(config),
	            ShutdownManager.create().getNotifier(),
	            org.sosy_lab.java_smt.SolverContextFactory.Solvers.Z3);
	         ProverEnvironment prover = ctx.newProverEnvironment(ProverOptions.GENERATE_MODELS))
	    {
	    	INonDet nonDet = new INonDet(INonDetTypes.INT, 32);
	    	nonDet.getIntValue(null, prover.getModel(), ctx);
	    }
    }
    
    @Test(expected = RuntimeException.class)
    public void JumpWithNullLabel() throws Exception {
    	ProgramBuilder pb = new ProgramBuilder();
    	pb.initThread(0);
    	pb.addChild(0, new CondJump(BConst.FALSE, null));
    	pb.build();
    }
}
