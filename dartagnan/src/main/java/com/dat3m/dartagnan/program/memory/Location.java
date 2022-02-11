package com.dat3m.dartagnan.program.memory;

import com.dat3m.dartagnan.expression.LastValueInterface;
import org.sosy_lab.java_smt.api.*;

public class Location implements LastValueInterface {

	private final String name;
	private final MemoryObject base;
	private final int offset;

	public Location(String name, MemoryObject b, int o) {
		this.name = name;
		base = b;
		offset = o;
	}
	
	public String getName() {
		return name;
	}

	@Override
	public String toString() {
		return name;
	}

	@Override
	public int hashCode(){
		return base.hashCode() + offset;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj) {
			return true;
		} else if (obj == null || getClass() != obj.getClass()) {
			return false;
		}
		Location o = (Location)obj;
		return base.equals(o.base) && offset == o.offset;
	}

	@Override
	public Formula getLastValueExpr(SolverContext ctx){
		return base.getLastMemValueExpr(ctx,offset);
	}
}