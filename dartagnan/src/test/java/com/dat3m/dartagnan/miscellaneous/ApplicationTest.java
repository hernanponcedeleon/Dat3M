package com.dat3m.dartagnan.miscellaneous;

import org.junit.Test;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.java_smt.SolverContextFactory.Solvers;

import com.dat3m.dartagnan.Dartagnan;
import com.dat3m.dartagnan.utils.ResourceHelper;

import static com.dat3m.dartagnan.analysis.Analysis.*;
import static com.dat3m.dartagnan.analysis.Method.*;
import static com.dat3m.dartagnan.configuration.OptionNames.*;
import static com.dat3m.dartagnan.utils.ResourceHelper.LITMUS_RESOURCE_PATH;

public class ApplicationTest {

    @Test
    public void Two() throws Exception {
    	Dartagnan.main(createAndFillOptions(REACHABILITY.asStringOption(), 
    										TWO.asStringOption(),
    										Solvers.Z3.toString()));
    }

    @Test
    public void Assume() throws Exception {
    	Dartagnan.main(createAndFillOptions(REACHABILITY.asStringOption(), 
    										ASSUME.asStringOption(),
    										Solvers.Z3.toString()));
    }

    @Test
    public void Incremental() throws Exception {
    	Dartagnan.main(createAndFillOptions(REACHABILITY.asStringOption(), 
    										INCREMENTAL.asStringOption(),
    										Solvers.Z3.toString()));
    }

    @Test
    public void CAAT() throws Exception {
    	Dartagnan.main(createAndFillOptions(REACHABILITY.asStringOption(), 
    										CAAT.asStringOption(),
    										Solvers.Z3.toString()));
    }

    @Test
    public void Races() throws Exception {
    	Dartagnan.main(createAndFillOptions(RACES.asStringOption(), 
    										ASSUME.asStringOption(),
    										Solvers.Z3.toString()));
    }

    @Test
    public void Validation() throws Exception {
		String[] options = new String[3];
		
	    options[0] = ResourceHelper.TEST_RESOURCE_PATH + "witness/lazy01-for-witness.bpl";
	    options[1] = ResourceHelper.CAT_RESOURCE_PATH + "cat/svcomp.cat";
    	options[2] = String.format("--%s=%s", VALIDATE, ResourceHelper.TEST_RESOURCE_PATH + "witness/lazy01.graphml");

    	Dartagnan.main(options);
    }

    @Test
    public void Litmus() throws Exception {
		String[] options = new String[2];
		
	    options[0] = LITMUS_RESOURCE_PATH + "litmus/X86/2+2W.litmus";
	    options[1] = ResourceHelper.CAT_RESOURCE_PATH + "cat/tso.cat";

    	Dartagnan.main(options);
    }

    @Test(expected = IllegalArgumentException.class)
    public void WrongProgramFormat() throws Exception {
		String[] options = new String[1];
		
	    options[0] = ResourceHelper.TEST_RESOURCE_PATH + "witness/lazy01-for-witness.bc";

    	Dartagnan.main(options);
    }

    @Test(expected = IllegalArgumentException.class)
    public void WrongCATFormat() throws Exception {
		String[] options = new String[2];
		
	    options[0] = ResourceHelper.TEST_RESOURCE_PATH + "witness/lazy01-for-witness.bpl";
	    options[1] = ResourceHelper.CAT_RESOURCE_PATH + "cat/linux-kernel.bell";

    	Dartagnan.main(options);
    }

    @Test(expected = InvalidConfigurationException.class)
    public void UnsupportedAnalysis() throws Exception {
    	Dartagnan.main(createAndFillOptions("unsupported-analysis", 
    										ASSUME.asStringOption(),
    										Solvers.Z3.toString()));
    }

    @Test(expected = InvalidConfigurationException.class)
    public void UnsupportedMethod() throws Exception {
    	Dartagnan.main(createAndFillOptions(REACHABILITY.asStringOption(), 
    										"unsupported-method",
    										Solvers.Z3.toString()));
    }

    @Test(expected = InvalidConfigurationException.class)
    public void UnsupportedSolver() throws Exception {
    	Dartagnan.main(createAndFillOptions(REACHABILITY.asStringOption(), 
    										ASSUME.asStringOption(),
    										"unsupported-solver"));
    }

	private String[] createAndFillOptions(String analysis, String method, String solver) {
		String[] dartagnanOptions = new String[6];
		
	    dartagnanOptions[0] = ResourceHelper.TEST_RESOURCE_PATH + "locks/ttas-5.bpl";
	    dartagnanOptions[1] = ResourceHelper.CAT_RESOURCE_PATH + "cat/svcomp.cat";
	    dartagnanOptions[2] = String.format("--%s=%s", BOUND, 2);
	    dartagnanOptions[3] = String.format("--%s=%s", ANALYSIS, analysis);
	    dartagnanOptions[4] = String.format("--%s=%s", METHOD, method);
	    dartagnanOptions[5] = String.format("--%s=%s", SOLVER, solver);
	    
	    return dartagnanOptions;
	}
}
