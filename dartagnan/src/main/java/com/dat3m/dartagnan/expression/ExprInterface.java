package com.dat3m.dartagnan.expression;

import com.google.common.collect.ImmutableSet;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.microsoft.z3.Model;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;

public interface ExprInterface {

	IConst reduce();
	
    Expr toZ3Int(Event e, Context ctx);

    BoolExpr toZ3Bool(Event e, Context ctx);

    Expr getLastValueExpr(Context ctx);

    int getIntValue(Event e, Model model, Context ctx);

    boolean getBoolValue(Event e, Model model, Context ctx);

    ImmutableSet<Register> getRegs();
    
    int getPrecision();
    
}
