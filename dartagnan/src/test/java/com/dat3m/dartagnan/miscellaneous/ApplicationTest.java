package com.dat3m.dartagnan.miscellaneous;

import org.junit.Test;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.java_smt.SolverContextFactory.Solvers;

import com.dat3m.dartagnan.Dartagnan;
import com.dat3m.dartagnan.utils.ResourceHelper;

import static com.dat3m.dartagnan.analysis.Analysis.*;
import static com.dat3m.dartagnan.analysis.Method.*;
import static com.dat3m.dartagnan.configuration.OptionNames.*;

public class ApplicationTest {

    @Test
    public void Two() throws Exception {
    	Dartagnan.main(createandFillOptions(REACHABILITY.asStringOption(), 
    										TWO.asStringOption(),
    										Solvers.Z3.toString()));
    }

    @Test
    public void Assume() throws Exception {
    	Dartagnan.main(createandFillOptions(REACHABILITY.asStringOption(), 
    										ASSUME.asStringOption(),
    										Solvers.Z3.toString()));
    }

    @Test
    public void Incremental() throws Exception {
    	Dartagnan.main(createandFillOptions(REACHABILITY.asStringOption(), 
    										INCREMENTAL.asStringOption(),
    										Solvers.Z3.toString()));
    }

    @Test
    public void CAAT() throws Exception {
    	Dartagnan.main(createandFillOptions(REACHABILITY.asStringOption(), 
    										CAAT.asStringOption(),
    										Solvers.Z3.toString()));
    }

    @Test
    public void Races() throws Exception {
    	Dartagnan.main(createandFillOptions(RACES.asStringOption(), 
    										ASSUME.asStringOption(),
    										Solvers.Z3.toString()));
    }

    @Test(expected = InvalidConfigurationException.class)
    public void UnsupportedAnalysis() throws Exception {
    	Dartagnan.main(createandFillOptions("unsupported-analysis", 
    										ASSUME.asStringOption(),
    										Solvers.Z3.toString()));
    }

    @Test(expected = InvalidConfigurationException.class)
    public void UnsupportedMethod() throws Exception {
    	Dartagnan.main(createandFillOptions(REACHABILITY.asStringOption(), 
    										"unsupported-method",
    										Solvers.Z3.toString()));
    }

    @Test(expected = InvalidConfigurationException.class)
    public void UnsupportedSolver() throws Exception {
    	Dartagnan.main(createandFillOptions(REACHABILITY.asStringOption(), 
    										ASSUME.asStringOption(),
    										"unsupported-solver"));
    }

	private String[] createandFillOptions(String analysis, String method, String solver) {
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
