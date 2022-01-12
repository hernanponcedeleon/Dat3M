package com.dat3m.dartagnan.program.memory;

import com.dat3m.dartagnan.expression.LastValueInterface;
import org.sosy_lab.java_smt.api.*;

public class Location implements LastValueInterface {

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
		if (this == obj) {
			return true;
		} else if (obj == null || getClass() != obj.getClass()) {
			return false;
		}

		return address.hashCode() == obj.hashCode();
	}

	@Override
	public Formula getLastValueExpr(SolverContext ctx){
		return address.getLastMemValueExpr(ctx,0);
	}
}