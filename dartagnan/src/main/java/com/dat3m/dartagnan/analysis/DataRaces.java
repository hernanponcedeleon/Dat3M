package com.dat3m.dartagnan.analysis;

import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.PASS;
import static com.dat3m.dartagnan.utils.Result.UNKNOWN;
import static com.dat3m.dartagnan.wmm.utils.Utils.edge;
import static com.dat3m.dartagnan.wmm.utils.Utils.intVar;
import static com.microsoft.z3.Status.SATISFIABLE;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.MemEvent;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.filter.FilterMinus;
import com.dat3m.dartagnan.wmm.filter.FilterUnion;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Solver;

public class DataRaces {

    public static Result runAnalysis(Solver s1, Context ctx, Program program, Wmm wmm, Arch target, Settings settings) {
    	program.unroll(settings.getBound(), 0);
        program.compile(target, 0);
        program.updateAssertion();
       	
        // Using two solvers is much faster than using
        // an incremental solver or check-sat-assuming
        Solver s2 = ctx.mkSolver();
        
        BoolExpr encodeCF = program.encodeCF(ctx);
		s1.add(encodeCF);
        s2.add(encodeCF);
        
        BoolExpr encodeFinalRegisterValues = program.encodeFinalRegisterValues(ctx);
		s1.add(encodeFinalRegisterValues);
        s2.add(encodeFinalRegisterValues);
        
        BoolExpr encodeWmm = wmm.encode(program, ctx, settings);
		s1.add(encodeWmm);
        s2.add(encodeWmm);
        
        BoolExpr encodeConsistency = wmm.consistent(program, ctx);
		s1.add(encodeConsistency);
        s2.add(encodeConsistency);
       	
        s1.add(encodeRaces(program, ctx));

        BoolExpr encodeNoBoundEventExec = program.encodeNoBoundEventExec(ctx);

        Result res;
		if(s1.check() == SATISFIABLE) {
			s1.add(encodeNoBoundEventExec);
			res = s1.check() == SATISFIABLE ? FAIL : UNKNOWN;	
		} else {
			s2.add(ctx.mkNot(encodeNoBoundEventExec));
			res = s2.check() == SATISFIABLE ? UNKNOWN : PASS;	
		}
        
		if(program.getAss().getInvert()) {
			res = res.invert();
		}
		return res;
    }
	
    public static Result runAnalysisIncrementalSolver(Solver solver, Context ctx, Program program, Wmm wmm, Arch target, Settings settings) {
    	program.unroll(settings.getBound(), 0);
        program.compile(target, 0);
        program.updateAssertion();

        solver.add(program.encodeCF(ctx));
        solver.add(program.encodeFinalRegisterValues(ctx));
        solver.add(wmm.encode(program, ctx, settings));
        solver.add(wmm.consistent(program, ctx));
        solver.push();
        solver.add(encodeRaces(program, ctx));

        Result res = UNKNOWN;
		if(solver.check() == SATISFIABLE) {
        	solver.add(program.encodeNoBoundEventExec(ctx));
			res = solver.check() == SATISFIABLE ? FAIL : UNKNOWN;
        } else {
        	solver.pop();
			solver.add(ctx.mkNot(program.encodeNoBoundEventExec(ctx)));
        	res = solver.check() == SATISFIABLE ? UNKNOWN : PASS;
        }

        return res;
    }
    
    private static BoolExpr encodeRaces(Program p, Context ctx) {
    	BoolExpr enc = ctx.mkFalse();
    	for(Thread t1 : p.getThreads()) {
    		for(Thread t2 : p.getThreads()) {
    			if(t1.getId() >= t2.getId()) {
    				continue;
    			}
    			for(Event e1 : t1.getCache().getEvents(FilterBasic.get(EType.WRITE))) {
    				MemEvent w = (MemEvent)e1;
    				for(Event e2 : t2.getCache().getEvents(FilterMinus.get(FilterBasic.get(EType.MEMORY), FilterUnion.get(FilterBasic.get(EType.RMW), FilterBasic.get(EType.INIT))))) {
    					MemEvent m = (MemEvent)e2;
    					if(w.canRace() && m.canRace() && MemEvent.canAddressTheSameLocation(w, m)) {
        					BoolExpr conflict = ctx.mkAnd(m.exec(), w.exec(), ctx.mkEq(w.getMemAddressExpr(), m.getMemAddressExpr()), 
        							edge("hb", m, w, ctx), ctx.mkEq(intVar("hb", w, ctx), ctx.mkAdd(intVar("hb", m, ctx), ctx.mkInt(1))));
    						enc = ctx.mkOr(enc, conflict);    						
    					}
    				}
    			}

    		}
    	}
    	return enc;
    }
}
