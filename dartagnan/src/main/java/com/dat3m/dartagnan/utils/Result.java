package com.dat3m.dartagnan.utils;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Solver;
import com.microsoft.z3.Status;

public enum Result {
	PASS, FAIL, UNKNOWN;

	public static Result getResult(Solver s, Program p, Context ctx) {
		Result res;
		if(s.check() == Status.SATISFIABLE) {
			res = FAIL;
		} else {
			BoolExpr enc = ctx.mkFalse();
			for(Event e : p.getCache().getEvents(FilterBasic.get(EType.BASSERTION))) {
				enc = ctx.mkOr(enc, e.exec());
			}
			s.pop();
			s.add(enc);
			res = s.check() == Status.SATISFIABLE ? UNKNOWN : PASS;	
		}
		if(p.getAss().getInvert()) {
			res = res.invert();
		}
		return res;
	}
	
	public Result invert() {
		switch (this) {
		case PASS:
			return FAIL;
		case FAIL:
			return PASS;
		default:
			return UNKNOWN;
		}
	}
}
