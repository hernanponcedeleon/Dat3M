package com.dat3m.dartagnan.expression;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Model;

import java.util.HashSet;
import java.util.Set;

import com.dat3m.dartagnan.program.event.Event;

public abstract class IExpr implements ExprInterface {
	
    private Set<Event> modifiedBy = new HashSet<Event>();

    @Override
	public BoolExpr toZ3Bool(Event e, Context ctx) {
		return ctx.mkGt(toZ3Int(e, ctx), ctx.mkInt(0));
	}

    @Override
    public boolean getBoolValue(Event e, Context ctx, Model model){
        return getIntValue(e, ctx, model) > 0;
    }
    
	public void addModifiedBy(Event e) {
		modifiedBy.add(e);
	}
	
	public Set<Event> getModifiedBy() {
		return modifiedBy;
	}
}
