package com.dat3m.dartagnan.parsers.program.visitors;

import com.dat3m.dartagnan.parsers.BoogieBaseVisitor;
import com.dat3m.dartagnan.parsers.BoogieVisitor;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;

public class VisitorBoogie extends BoogieBaseVisitor<Object> implements BoogieVisitor<Object> {

	private ProgramBuilder programBuilder;

	public VisitorBoogie(ProgramBuilder pb) {
		this.programBuilder = pb;
	}
}
