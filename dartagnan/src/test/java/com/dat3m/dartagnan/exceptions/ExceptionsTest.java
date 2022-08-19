package com.dat3m.dartagnan.exceptions;

import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.encoding.ProgramEncoder;
import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Program.SourceLanguage;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.core.Skip;
import com.dat3m.dartagnan.program.processing.BranchReordering;
import com.dat3m.dartagnan.program.processing.DeadCodeElimination;
import com.dat3m.dartagnan.program.processing.LoopUnrolling;
import com.dat3m.dartagnan.program.processing.compilation.Compilation;
import com.dat3m.dartagnan.utils.ResourceHelper;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Wmm;
import org.junit.Test;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.java_smt.api.ProverEnvironment;
import org.sosy_lab.java_smt.api.SolverContext;
import org.sosy_lab.java_smt.api.SolverContext.ProverOptions;

import java.io.File;

import static com.dat3m.dartagnan.utils.TestHelper.createContext;

public class ExceptionsTest {

    @Test(expected = MalformedProgramException.class)
    public void noThread() throws Exception {
    	ProgramBuilder pb = new ProgramBuilder(SourceLanguage.LITMUS);
    	// Thread 1 does not exists
    	pb.addChild(1, new Skip());
    }

    @Test(expected = MalformedProgramException.class)
    public void RegisterAlreadyExist() throws Exception {
    	ProgramBuilder pb = new ProgramBuilder(SourceLanguage.LITMUS);
    	pb.initThread(0);
    	Thread t = pb.build().getThreads().get(0);
    	t.newRegister("r1", -1);
    	// Adding same register a second time
    	t.newRegister("r1", -1);
    }


    @Test(expected = IllegalArgumentException.class)
    public void compileBeforeUnrollException() throws Exception {
    	ProgramBuilder pb = new ProgramBuilder(SourceLanguage.LITMUS);
    	pb.initThread(0);
    	// Program must be unrolled first
    	Compilation.newInstance().run(pb.build());
    }

    @Test(expected = IllegalArgumentException.class)
    public void unrollBeforeReorderException() throws Exception {
    	ProgramBuilder pb = new ProgramBuilder(SourceLanguage.LITMUS);
    	pb.initThread(0);
    	Program p = pb.build();
    	LoopUnrolling.newInstance().run(p);
    	// Reordering cannot be called after unrolling
    	BranchReordering.newInstance().run(p);
    }

    @Test(expected = IllegalArgumentException.class)
    public void initializedBeforeCompileException() throws Exception {
    	ProgramBuilder pb = new ProgramBuilder(SourceLanguage.LITMUS);
    	pb.initThread(0);
    	Program p = pb.build();
		Wmm cat = new ParserCat().parse(new File(ResourceHelper.CAT_RESOURCE_PATH+ "cat/tso.cat"));
		Configuration config = Configuration.defaultConfiguration();
		VerificationTask task = VerificationTask.builder()
                .withConfig(config)
                .build(p, cat, Property.getDefault());
		// The program must be compiled before being able to construct an Encoder for it
    	ProgramEncoder.fromConfig(task.getProgram(), Context.create(), config);
    }

    @Test(expected = IllegalArgumentException.class)
    public void unrollBeforeDCEException() throws Exception {
        ProgramBuilder pb = new ProgramBuilder(SourceLanguage.LITMUS);
        pb.initThread(0);
        Program p = pb.build();
        LoopUnrolling.newInstance().run(p);
        // DCE cannot be called after unrolling
        DeadCodeElimination.newInstance().run(p);
    }

    @Test(expected = IllegalArgumentException.class)
    public void diffPrecisionInt() throws Exception {
    	// Both arguments should have same precision
    	new IExprBin(new Register("a", 0, 32), IOpBin.PLUS, new Register("b", 0, 64));
    }

    @Test(expected = RuntimeException.class)
    public void noModelBNonDet() throws Exception {
	    try (SolverContext ctx = createContext();
	    		ProverEnvironment prover = ctx.newProverEnvironment(ProverOptions.GENERATE_MODELS))
	    {
            prover.isUnsat();
	    	BNonDet nonDet = new BNonDet(32);
	    	nonDet.getBoolValue(null, prover.getModel(), ctx);
	    }
    }

    @Test(expected = RuntimeException.class)
    public void noModelINonDet() throws Exception {
	    try (SolverContext ctx = createContext();
	    		ProverEnvironment prover = ctx.newProverEnvironment(ProverOptions.GENERATE_MODELS))
	    {
            prover.isUnsat();
	    	INonDet nonDet = new INonDet(INonDetTypes.INT, 32);
	    	nonDet.getIntValue(null, prover.getModel(), ctx);
	    }
    }
    
    @Test(expected = NullPointerException.class)
    public void JumpWithNullLabel() throws Exception {
        EventFactory.newJump(BConst.FALSE, null);
    }

    @Test(expected = NullPointerException.class)
    public void JumpWithNullExpr() throws Exception {
        EventFactory.newJump(null, EventFactory.newLabel("DUMMY"));
    }
    
    @Test(expected = MalformedProgramException.class)
    public void AtomicEndWithoutBegin() throws Exception {
    	new ProgramParser().parse(new File(ResourceHelper.TEST_RESOURCE_PATH + "exceptions/AtomicEndWithoutBegin.bpl"));
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