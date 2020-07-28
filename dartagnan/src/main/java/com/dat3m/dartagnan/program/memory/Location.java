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
import com.dat3m.dartagnan.utils.EncodingConf;

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
	public Expr getLastValueExpr(EncodingConf conf){
		return address.getLastMemValueExpr(conf);
	}

	@Override
	public Expr toZ3Int(Event e, EncodingConf conf){
		if(e instanceof MemEvent){
			return ((MemEvent) e).getMemValueExpr();
		}
		throw new RuntimeException("Attempt to encode memory value for illegal event");
	}

	@Override
	public BoolExpr toZ3Bool(Event e, EncodingConf conf){
		if(e instanceof MemEvent){
			Context ctx = conf.getCtx();
			return conf.getBP() ? ctx.mkBVSGT((BitVecExpr)((MemEvent) e).getMemValueExpr(), ctx.mkBV(0, 32)) : ctx.mkGt((IntExpr)((MemEvent) e).getMemValueExpr(), ctx.mkInt(0));
		}
		throw new RuntimeException("Attempt to encode memory value for illegal event");
	}

	@Override
	public int getIntValue(Event e, Model model, EncodingConf conf){
		if(e instanceof MemEvent){
			return ((MemEvent) e).getMemValue().getIntValue(e, model, conf);
		}
		throw new RuntimeException("Attempt to encode memory value for illegal event");
	}

	@Override
	public boolean getBoolValue(Event e, Model model, EncodingConf conf){
		if(e instanceof MemEvent){
			return ((MemEvent) e).getMemValue().getBoolValue(e, model, conf);
		}
		throw new RuntimeException("Attempt to encode memory value for illegal event");
	}

	@Override
	public IConst reduce() {
		throw new UnsupportedOperationException("Reduce not supported for " + this);
	}
}
