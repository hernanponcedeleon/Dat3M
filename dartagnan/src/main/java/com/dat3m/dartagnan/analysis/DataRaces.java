package com.dat3m.dartagnan.analysis;

import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.PASS;
import static com.dat3m.dartagnan.utils.Result.UNKNOWN;
import static com.dat3m.dartagnan.wmm.utils.Utils.edge;
import static com.dat3m.dartagnan.wmm.utils.Utils.intVar;
import static com.microsoft.z3.Status.SATISFIABLE;

import com.dat3m.dartagnan.asserts.AssertTrue;
import com.dat3m.dartagnan.expression.BConst;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.arch.pts.event.Write;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.MemEvent;
import com.dat3m.dartagnan.program.event.Store;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.utils.printer.Printer;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.filter.FilterMinus;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Model;
import com.microsoft.z3.Solver;

public class DataRaces {

    public static Result runAnalysis(Solver s1, Context ctx, Program program, Wmm wmm, Arch target, Settings settings) {
    	program.unroll(settings.getBound(), 0);
        program.compile(target, 0);
        // AssertionInline depends on compiled events (copies)
        // Thus we need to set the assertion after compilation
        program.updateAssertion();
       	if(program.getAss() instanceof AssertTrue) {
       		return PASS;
       	}
       	
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
       	
        s1.add(program.getAss().encode(ctx));
        if(program.getAssFilter() != null){
            BoolExpr encodeFilter = program.getAssFilter().encode(ctx);
			s1.add(encodeFilter);
            s2.add(encodeFilter);
        }

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

       	Printer p = new Printer();
       	System.out.print(p.print(program));
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

		if(res.equals(Result.FAIL)) {
			Model model = solver.getModel();
			for(Event e : program.getCache().getEvents(FilterBasic.get(EType.MEMORY))) {
				if(model.getConstInterp(e.exec()).isTrue()) {
//					System.out.println(e.repr());
//					System.out.println(model.getConstInterp(intVar("hb", e, ctx)));
//					System.out.println("===");
				}
			}
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
    				for(Event e2 : t2.getCache().getEvents(FilterMinus.get(FilterBasic.get(EType.MEMORY), FilterBasic.get(EType.RMW)))) {
    					MemEvent m = (MemEvent)e2;
    					if(w.canRace() && m.canRace() && MemEvent.canAddressTheSameLocation(w, m)) {
    						if(w.getMemValue() instanceof BConst && !((BConst)w.getMemValue()).getValue()) {
    							continue;
    						}
    						if(m.getMemValue() instanceof BConst && !((BConst)m.getMemValue()).getValue()) {
    							continue;
    						}
        					BoolExpr conflict = ctx.mkEq(w.getMemAddressExpr(), m.getMemAddressExpr());
        					conflict = ctx.mkAnd(conflict, m.exec(), w.exec());
        					BoolExpr o1 = ctx.mkAnd(edge("hb", m, w, ctx), ctx.mkEq(intVar("hb", w, ctx), ctx.mkAdd(intVar("hb", m, ctx), ctx.mkInt(1))));
        					BoolExpr o2 = ctx.mkAnd(edge("hb", w, m, ctx), ctx.mkEq(intVar("hb", m, ctx), ctx.mkAdd(intVar("hb", w, ctx), ctx.mkInt(1))));
							conflict = ctx.mkAnd(conflict, ctx.mkOr(o1, o2));
    						enc = ctx.mkOr(enc, conflict);    						
    					}
    				}
    			}

    		}
    	}
//    	System.out.println(enc.simplify());
    	return enc;
    }
}
