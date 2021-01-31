package com.dat3m.dartagnan.analysis;

import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.PASS;
import static com.dat3m.dartagnan.utils.Result.UNKNOWN;
import static com.dat3m.dartagnan.wmm.utils.Utils.edge;
import static com.dat3m.dartagnan.wmm.utils.Utils.intVar;
import static com.microsoft.z3.Status.SATISFIABLE;

import com.dat3m.dartagnan.expression.BConst;
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
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Solver;

public class DataRaces {
	
	// This analysis assumes that CAT file defining the memory model has a happens-before 
	// relation named hb: it should contain the following axiom "acyclic hb"

	public static Result checkForRaces(Solver solver, Context ctx, Program program, Wmm wmm, Arch target, Settings settings) {
    	program.unroll(settings.getBound(), 0);
        program.compile(target, 0);
        program.updateAssertion();

        solver.add(program.encodeCF(ctx));
        solver.add(program.encodeFinalRegisterValues(ctx));
        solver.add(wmm.encode(program, ctx, settings));
        solver.add(wmm.consistent(program, ctx));
        solver.push();
        solver.add(encodeRaces(program, ctx));
        
		if(solver.check() == SATISFIABLE) {
        	solver.add(program.encodeNoBoundEventExec(ctx));
			return solver.check() == SATISFIABLE ? FAIL : UNKNOWN;
        } else {
        	solver.pop();
			solver.add(ctx.mkNot(program.encodeNoBoundEventExec(ctx)));
        	return solver.check() == SATISFIABLE ? UNKNOWN : PASS;
        }
    }
    
    private static BoolExpr encodeRaces(Program p, Context ctx) {
    	BoolExpr enc = ctx.mkFalse();
    	for(Thread t1 : p.getThreads()) {
    		for(Thread t2 : p.getThreads()) {
    			if(t1.getId() == t2.getId()) {
    				continue;
    			}
    			for(Event e1 : t1.getCache().getEvents(FilterMinus.get(FilterBasic.get(EType.WRITE), FilterBasic.get(EType.INIT)))) {
    				MemEvent w = (MemEvent)e1;
    				for(Event e2 : t2.getCache().getEvents(FilterMinus.get(FilterBasic.get(EType.MEMORY), FilterBasic.get(EType.INIT)))) {
    					MemEvent m = (MemEvent)e2;
    					if(w.hasFilter(EType.RMW) && m.hasFilter(EType.RMW)) {
    						continue;
    					}
    					// TODO improve this: these events correspond to return statements
    					if(w.getMemValue() instanceof BConst && !((BConst)w.getMemValue()).getValue()) {
    						continue;
    					}
    					if(m.getMemValue() instanceof BConst && !((BConst)m.getMemValue()).getValue()) {
    						continue;
    					}
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
