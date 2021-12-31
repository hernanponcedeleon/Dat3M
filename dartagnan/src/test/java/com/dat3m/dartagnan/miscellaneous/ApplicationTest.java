package com.dat3m.dartagnan.miscellaneous;

import org.junit.Test;
import org.sosy_lab.java_smt.SolverContextFactory.Solvers;

import com.dat3m.dartagnan.Dartagnan;
import com.dat3m.dartagnan.analysis.Analysis;
import com.dat3m.dartagnan.analysis.Method;
import com.dat3m.dartagnan.utils.ResourceHelper;
import com.dat3m.dartagnan.wmm.utils.Arch;

import static com.dat3m.dartagnan.analysis.Analysis.*;
import static com.dat3m.dartagnan.analysis.Method.*;
import static com.dat3m.dartagnan.utils.options.BaseOptions.*;
import static com.dat3m.dartagnan.utils.options.DartagnanOptions.ANALYSIS_OPTION;
import static com.dat3m.dartagnan.wmm.utils.Arch.*;

public class ApplicationTest {

    @Test
    public void Two() throws Exception {
    	Dartagnan.main(createandFillOptions(REACHABILITY, TWO, NONE));
    }

    @Test
    public void Assume() throws Exception {
    	Dartagnan.main(createandFillOptions(REACHABILITY, ASSUME, TSO));
    }

    @Test
    public void Incremental() throws Exception {
    	Dartagnan.main(createandFillOptions(REACHABILITY, INCREMENTAL, ARM8));
    }

    @Test
    public void CAAT() throws Exception {
    	Dartagnan.main(createandFillOptions(REACHABILITY, CAAT, POWER));
    }

    @Test
    public void Races() throws Exception {
    	Dartagnan.main(createandFillOptions(RACES, ASSUME, NONE));
    }

	private String[] createandFillOptions(Analysis analysis, Method method, Arch target) {
		String[] dartagnanOptions = new String[14];
		
		dartagnanOptions[0] = "-" + INPUT_OPTION;
	    dartagnanOptions[1] = ResourceHelper.TEST_RESOURCE_PATH + "locks/ttas-5.bpl";
	    dartagnanOptions[2] = "-" + CAT_OPTION;
	    dartagnanOptions[3] = ResourceHelper.CAT_RESOURCE_PATH + "cat/svcomp.cat";
	    dartagnanOptions[4] = "-" + UNROLL_OPTION;
	    dartagnanOptions[5] = "2";
	    dartagnanOptions[6] = "-" + ANALYSIS_OPTION;
	    dartagnanOptions[7] = analysis.asStringOption();
	    dartagnanOptions[8] = "-" + METHOD_OPTION;
	    dartagnanOptions[9] = method.asStringOption();	    	
	    dartagnanOptions[10] = "-" + SMTSOLVER_OPTION;
	    dartagnanOptions[11] = Solvers.Z3.toString().toLowerCase();
	    dartagnanOptions[12] = "-" + TARGET_OPTION;
	    dartagnanOptions[13] = target.asStringOption();
	    
	    return dartagnanOptions;
	}
}
