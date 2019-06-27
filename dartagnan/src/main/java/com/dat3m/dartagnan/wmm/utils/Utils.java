package com.dat3m.dartagnan.wmm.utils;

import com.dat3m.dartagnan.program.Register;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.IntExpr;
import com.dat3m.dartagnan.program.event.Event;

public class Utils {

	public static BoolExpr edge(String relName, Event e1, Event e2, Context ctx) {
		return ctx.mkBoolConst(relName + "(" + e1.repr() + "," + e2.repr() + ")");
	}

	public static BoolExpr bindRegVal(Register register, Event w, Event r, Context ctx){
		return ctx.mkBoolConst("BindRegVal(E" + w.getCId() + ",E" + r.getCId() + "," + register.getName() + ")");
	}

	public static IntExpr intVar(String relName, Event e, Context ctx) {
		return ctx.mkIntConst(relName + "(" + e.repr() + ")");
	}
	
	public static IntExpr intCount(String relName, Event e1, Event e2, Context ctx) {
		return ctx.mkIntConst(relName + "(" + e1.repr() + "," + e2.repr() + ")");
	}
}