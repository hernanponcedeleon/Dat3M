package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.dat3m.dartagnan.program.memory.Address;
import org.sosy_lab.java_smt.api.SolverContext;

public class Init extends MemEvent {

	private final Address base;
	private final int offset;
	private final IConst value;
	
	public Init(Address b, int o, IConst value) {
		super(b.add(o), null);
		base = b;
		offset = o;
		this.value = value;
		addFilters(Tag.ANY, Tag.VISIBLE, Tag.MEMORY, Tag.WRITE, Tag.INIT);
	}

	public Address getBase() {
		return base;
	}

	public int getOffset() {
		return offset;
	}

	public IConst getValue(){
		return value;
	}

	@Override
	public void initializeEncoding(SolverContext ctx) {
		super.initializeEncoding(ctx);
		memValueExpr = value.toIntFormula(ctx);
	}

	@Override
	public String toString() {
		return String.format("%s[%d] := %s",base,offset,value);
	}

	@Override
	public IConst getMemValue(){
		return value;
	}

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitInit(this);
	}
}