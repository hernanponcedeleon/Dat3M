package com.dat3m.dartagnan.program.memory;

import com.google.common.collect.ImmutableSet;
import com.microsoft.z3.BitVecExpr;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.microsoft.z3.IntExpr;
import com.microsoft.z3.Model;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.MemEvent;

public class Location implements ExprInterface {

	public static final int DEFAULT_INIT_VALUE = 0;

	private final String name;
	private final Address address;

	public Location(String name, Address address) {
		this.name = name;
		this.address = address;
	}
	
	public String getName() {
		return name;
	}

	public Address getAddress() {
		return address;
	}

	@Override
	public String toString() {
		return name;
	}

	@Override
	public int hashCode(){
		return address.hashCode();
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;

		if (obj == null || getClass() != obj.getClass())
			return false;

		return address.hashCode() == obj.hashCode();
	}

	@Override
	public ImmutableSet<Register> getRegs(){
		return ImmutableSet.of();
	}

	@Override
	public Expr getLastValueExpr(Context ctx, boolean bp){
		return address.getLastMemValueExpr(ctx, bp);
	}

	@Override
	public Expr toZ3NumExpr(Event e, Context ctx, boolean bp){
		if(e instanceof MemEvent){
			return ((MemEvent) e).getMemValueExpr();
		}
		throw new RuntimeException("Attempt to encode memory value for illegal event");
	}

	@Override
	public BoolExpr toZ3Bool(Event e, Context ctx, boolean bp){
		if(e instanceof MemEvent){
			return bp ? ctx.mkBVSGT((BitVecExpr)((MemEvent) e).getMemValueExpr(), ctx.mkBV(0, 32)) : ctx.mkGt((IntExpr)((MemEvent) e).getMemValueExpr(), ctx.mkInt(0));
		}
		throw new RuntimeException("Attempt to encode memory value for illegal event");
	}

	@Override
	public int getIntValue(Event e, Context ctx, Model model, boolean bp){
		if(e instanceof MemEvent){
			return ((MemEvent) e).getMemValue().getIntValue(e, ctx, model, bp);
		}
		throw new RuntimeException("Attempt to encode memory value for illegal event");
	}

	@Override
	public boolean getBoolValue(Event e, Context ctx, Model model, boolean bp){
		if(e instanceof MemEvent){
			return ((MemEvent) e).getMemValue().getBoolValue(e, ctx, model, bp);
		}
		throw new RuntimeException("Attempt to encode memory value for illegal event");
	}

	@Override
	public IConst reduce() {
		throw new UnsupportedOperationException("Reduce not supported for " + this);
	}
}
