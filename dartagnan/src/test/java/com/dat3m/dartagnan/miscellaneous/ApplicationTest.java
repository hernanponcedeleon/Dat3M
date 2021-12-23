package com.dat3m.dartagnan.miscellaneous;

import org.junit.Test;
import org.sosy_lab.java_smt.SolverContextFactory.Solvers;

import com.dat3m.dartagnan.Dartagnan;
import com.dat3m.dartagnan.analysis.Analysis;
import com.dat3m.dartagnan.analysis.Method;
import com.dat3m.dartagnan.utils.ResourceHelper;

import static com.dat3m.dartagnan.analysis.Analysis.*;
import static com.dat3m.dartagnan.analysis.Method.*;
import static com.dat3m.dartagnan.utils.options.BaseOptions.*;
import static com.dat3m.dartagnan.utils.options.DartagnanOptions.ANALYSIS_OPTION;

public class ApplicationTest {

    @Test
    public void Two() throws Exception {
	    String[] dartagnanOptions = new String[12];
	    fillOptions(dartagnanOptions, REACHABILITY, TWO);
    	Dartagnan.main(dartagnanOptions);
    }

    @Test
    public void Assume() throws Exception {
	    String[] dartagnanOptions = new String[12];
	    fillOptions(dartagnanOptions, REACHABILITY, ASSUME);
    	Dartagnan.main(dartagnanOptions);
    }

    @Test
    public void Incremental() throws Exception {
	    String[] dartagnanOptions = new String[12];
	    fillOptions(dartagnanOptions, REACHABILITY, INCREMENTAL);
    	Dartagnan.main(dartagnanOptions);
    }

    @Test
    public void CAAT() throws Exception {
	    String[] dartagnanOptions = new String[12];
	    fillOptions(dartagnanOptions, REACHABILITY, CAAT);
    	Dartagnan.main(dartagnanOptions);
    }

    @Test
    public void Races() throws Exception {
	    String[] dartagnanOptions = new String[12];
	    fillOptions(dartagnanOptions, RACES, ASSUME);
    	Dartagnan.main(dartagnanOptions);
    }

	private void fillOptions(String[] dartagnanOptions, Analysis analysis, Method method) {
		dartagnanOptions[0] = "-i";
	    dartagnanOptions[1] = ResourceHelper.TEST_RESOURCE_PATH + "locks/ttas-5.bpl";
	    dartagnanOptions[2] = "-cat";
	    dartagnanOptions[3] = ResourceHelper.CAT_RESOURCE_PATH + "cat/svcomp.cat";
	    dartagnanOptions[4] = "-unroll";
	    dartagnanOptions[5] = "2";
	    dartagnanOptions[6] = "-" + ANALYSIS_OPTION;
	    dartagnanOptions[7] = analysis.asStringOption();
	    dartagnanOptions[8] = "-" + METHOD_OPTION;
	    dartagnanOptions[9] = method.asStringOption();	    	
	    dartagnanOptions[10] = "-" + SMTSOLVER_OPTION;
	    dartagnanOptions[11] = Solvers.Z3.toString().toLowerCase();
	}
}
