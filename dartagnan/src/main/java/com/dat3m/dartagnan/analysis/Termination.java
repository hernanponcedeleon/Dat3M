package com.dat3m.dartagnan.analysis;

import static com.dat3m.dartagnan.utils.Result.PASS;
import static com.dat3m.dartagnan.utils.Result.UNKNOWN;
import static com.microsoft.z3.Status.SATISFIABLE;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.microsoft.z3.Context;
import com.microsoft.z3.Solver;

public class Termination {

    public static Result runAnalysis(Solver s1, Context ctx, Program program, Wmm wmm, Arch target, Settings settings) {
    	program.unroll(settings.getBound(), 0);
        program.compile(target, 0);
        
		s1.add(program.encodeCF(ctx));
		s1.add(program.encodeFinalRegisterValues(ctx));
		s1.add(wmm.encode(program, ctx, settings));
		s1.add(wmm.consistent(program, ctx));       	
		s1.add(program.encodeNoBoundEventExec(ctx));
		return s1.check() == SATISFIABLE ? PASS : UNKNOWN;	
    }
}
