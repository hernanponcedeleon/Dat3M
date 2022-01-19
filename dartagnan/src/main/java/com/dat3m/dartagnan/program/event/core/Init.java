package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.dat3m.dartagnan.program.memory.Address;
import org.sosy_lab.java_smt.api.SolverContext;

public class Init extends MemEvent {

	private final Address base;
	private final int offset;
	
	public Init(Address b, int o) {
		super(b.add(o), null);
		base = b;
		offset = o;
		addFilters(Tag.ANY, Tag.VISIBLE, Tag.MEMORY, Tag.WRITE, Tag.INIT);
	}

	public Address getBase() {
		return base;
	}

	public int getOffset() {
		return offset;
	}

	public IConst getValue(){
		return base.getInitialValue(offset);
	}

	@Override
	public void initializeEncoding(SolverContext ctx) {
		super.initializeEncoding(ctx);
		memValueExpr = getValue().toIntFormula(ctx);
	}

	@Override
	public String toString() {
		return String.format("%s[%d] := %s",base,offset,getValue());
	}

	@Override
	public IConst getMemValue(){
		return getValue();
	}

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitInit(this);
	}
}