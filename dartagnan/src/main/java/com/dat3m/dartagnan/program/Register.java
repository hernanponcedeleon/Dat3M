package com.dat3m.dartagnan.program;

import com.dat3m.dartagnan.program.expression.AbstractExpression;
import com.dat3m.dartagnan.program.expression.ExpressionVisitor;
import com.dat3m.dartagnan.program.expression.type.Type;
import com.google.common.collect.ImmutableSet;

public class Register extends AbstractExpression {

	public static final int NO_THREAD = -1;

	private final String name;
	private String cVar;
    private final int threadId;

	public Register(String name, int threadId, Type type) {
		super(type);
		this.name = name;
		this.threadId = threadId;
	}
	
	public String getName() {
		return name;
	}

	public String getCVar() {
		return cVar;
	}

	public void setCVar(String name) {
		this.cVar = name;
	}

	public int getThreadId(){
		return threadId;
	}

	@Override
	public ImmutableSet<Register> getRegs() {
		return ImmutableSet.of(this);
	}

	@Override
	public <T> T visit(ExpressionVisitor<T> visitor) {
		return visitor.visit(this);
	}

    @Override
    public int hashCode(){
        return name.hashCode() + threadId;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
			return true;
		} else if (obj == null || getClass() != obj.getClass()) {
			return false;
		}

        Register rObj = (Register) obj;
        return name.equals(rObj.name) && threadId == rObj.threadId;
    }

	@Override
	public String toString() {
		return name;
	}
}
