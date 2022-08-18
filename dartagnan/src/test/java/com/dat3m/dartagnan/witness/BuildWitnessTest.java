package com.dat3m.dartagnan.witness;

import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.ResourceHelper;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.TestHelper;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.verification.solving.IncrementalSolver;
import com.dat3m.dartagnan.wmm.Wmm;
import org.junit.Test;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.ProverEnvironment;
import org.sosy_lab.java_smt.api.SolverContext;
import org.sosy_lab.java_smt.api.SolverContext.ProverOptions;

import java.io.File;

import static com.dat3m.dartagnan.configuration.OptionNames.BOUND;
import static com.dat3m.dartagnan.configuration.OptionNames.WITNESS_ORIGINAL_PROGRAM_PATH;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

public class BuildWitnessTest {

    @Test
    public void BuildWriteEncode() throws Exception {
    	
    	Configuration config = Configuration.builder().
    			setOption(WITNESS_ORIGINAL_PROGRAM_PATH, ResourceHelper.TEST_RESOURCE_PATH + "witness/lazy01-for-witness.bpl").
    			setOption(BOUND, "1").
    			build();
    	
    	Program p = new ProgramParser().parse(new File(ResourceHelper.TEST_RESOURCE_PATH + "witness/lazy01-for-witness.bpl"));
    	Wmm wmm = new ParserCat().parse(new File(ResourceHelper.CAT_RESOURCE_PATH + "cat/svcomp.cat"));
    	VerificationTask task = VerificationTask.builder().withConfig(config).build(p, wmm, Property.getDefault());
    	try (SolverContext ctx = TestHelper.createContext();
    			ProverEnvironment prover = ctx.newProverEnvironment(ProverOptions.GENERATE_MODELS))
    	{
    		Result res = IncrementalSolver.run(ctx, prover, task);
    		WitnessBuilder witnessBuilder = new WitnessBuilder(task, ctx, prover, res);
    		config.inject(witnessBuilder);
			WitnessGraph graph = witnessBuilder.build();
    		File witnessFile = new File(System.getenv("DAT3M_OUTPUT") + "/lazy01-for-witness.graphml");
    		// The file should not exist
			assertFalse(witnessFile.exists());
    		// Write to file
    		graph.write();
    		// The file should exist now
			assertTrue(witnessFile.exists());
			// Delete the file
			witnessFile.delete();
    		// Create encoding
    		BooleanFormula enc = graph.encode(p, ctx);
    		BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
    		// Check the formula is not trivial
			assertFalse(bmgr.isFalse(enc));
			assertFalse(bmgr.isTrue(enc));
    	}
    }
}
