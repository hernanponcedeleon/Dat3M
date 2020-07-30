package com.dat3m.dartagnan.expression;

import com.google.common.collect.ImmutableSet;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Expr;
import com.microsoft.z3.Model;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.utils.EncodingConf;

public interface ExprInterface {

	IConst reduce();
	
    Expr toZ3Int(Event e, EncodingConf conf);

    BoolExpr toZ3Bool(Event e, EncodingConf conf);

    Expr getLastValueExpr(EncodingConf conf);

    int getIntValue(Event e, Model model, EncodingConf conf);

    boolean getBoolValue(Event e, Model model, EncodingConf conf);

    ImmutableSet<Register> getRegs();
    
    int getPrecision();
    
}
