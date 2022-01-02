package com.dat3m.dartagnan.miscellaneous;

import org.junit.Test;
import org.sosy_lab.java_smt.SolverContextFactory.Solvers;

import com.dat3m.dartagnan.Dartagnan;
import com.dat3m.dartagnan.analysis.Analysis;
import com.dat3m.dartagnan.analysis.Method;
import com.dat3m.dartagnan.utils.ResourceHelper;

import static com.dat3m.dartagnan.Dartagnan.*;
import static com.dat3m.dartagnan.analysis.Analysis.*;
import static com.dat3m.dartagnan.analysis.Method.*;

public class ApplicationTest {

    @Test
    public void Two() throws Exception {
    	Dartagnan.main(createandFillOptions(REACHABILITY, TWO));
    }

    @Test
    public void Assume() throws Exception {
    	Dartagnan.main(createandFillOptions(REACHABILITY, ASSUME));
    }

    @Test
    public void Incremental() throws Exception {
    	Dartagnan.main(createandFillOptions(REACHABILITY, INCREMENTAL));
    }

    @Test
    public void CAAT() throws Exception {
    	Dartagnan.main(createandFillOptions(REACHABILITY, CAAT));
    }

    @Test
    public void Races() throws Exception {
    	Dartagnan.main(createandFillOptions(RACES, ASSUME));
    }

	private String[] createandFillOptions(Analysis analysis, Method method) {
		String[] dartagnanOptions = new String[10];
		
	    dartagnanOptions[0] = ResourceHelper.TEST_RESOURCE_PATH + "locks/ttas-5.bpl";
	    dartagnanOptions[1] = ResourceHelper.CAT_RESOURCE_PATH + "cat/svcomp.cat";
	    dartagnanOptions[2] = "-unroll";
	    dartagnanOptions[3] = "2";
	    dartagnanOptions[4] = "-" + ANALYSIS;
	    dartagnanOptions[5] = analysis.asStringOption();
	    dartagnanOptions[6] = "-" + METHOD;
	    dartagnanOptions[7] = method.asStringOption();	    	
	    dartagnanOptions[8] = "-" + SOLVER;
	    dartagnanOptions[9] = Solvers.Z3.toString().toLowerCase();
	    
	    return dartagnanOptions;
	}
}
