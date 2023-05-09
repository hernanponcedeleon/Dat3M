package com.dat3m.dartagnan.program.memory;

import com.dat3m.dartagnan.GlobalSettings;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;

public class Location extends IExpr {

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

	public MemoryObject getMemoryObject() {
		return base;
	}

	public int getOffset() {
		return offset;
	}

	@Override
	public <T> T visit(ExpressionVisitor<T> visitor) {
		return visitor.visit(this);
	}

	@Override
	public int getPrecision() {
		return GlobalSettings.getArchPrecision();
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
}