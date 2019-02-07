package com.dat3m.dartagnan.program;

import com.dat3m.dartagnan.program.event.MemEvent;
import com.dat3m.dartagnan.program.memory.Address;
import com.dat3m.dartagnan.program.memory.Variable;
import com.dat3m.dartagnan.program.utils.SSAReg;
import com.google.common.collect.ImmutableSet;
import com.microsoft.z3.Context;
import com.microsoft.z3.IntExpr;
import com.microsoft.z3.Model;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.event.Event;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

public class Register extends IExpr implements ExprInterface, Variable {

	private static int dummyCount = 0;

	private final String name;
    private final int threadId;
	private int mainThreadId = -1;
	private Set<Variable> aliasEdges = new HashSet<>();
	private Set<Address> aliasAddresses = new HashSet<>();
	private Set<MemEvent> aliasEvents = new HashSet<>();
	private Map<Integer, SSAReg> SSAIds = new HashMap<>();

	public Register(String name, int threadId) {
		if(name == null){
			name = "DUMMY_REG_" + dummyCount++;
		}
		this.name = name;
		this.threadId = threadId;
	}
	
	public String getName() {
		return name;
	}

	void setMainThreadId(int t) {
		this.mainThreadId = t;
	}

	public int getThreadId(){
		return threadId;
	}

	@Override
	public Set<Variable> getAliasEdges() {
		return aliasEdges;
	}

	@Override
	public Set<Address> getAliasAddresses() {
		return aliasAddresses;
	}

	public Set<MemEvent> getAliasEvents() {
		return aliasEvents ;
	}

	public SSAReg getSSAReg(int i){
		SSAIds.putIfAbsent(i, new SSAReg(i, this));
		return SSAIds.get(i);
	}

	@Override
	public String toString() {
        return name;
	}

    @Override
    public int hashCode(){
        return (name.hashCode() << 8) + threadId;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;

        if (obj == null || getClass() != obj.getClass())
            return false;

        Register rObj = (Register) obj;
        return name.equals(rObj.name) && threadId == rObj.threadId;
    }

    @Deprecated
	@Override
	public Register clone() {
		Register register = new Register(name, threadId);
		register.setMainThreadId(mainThreadId);
		return register;
	}

	@Override
	public IntExpr toZ3Int(Event e, Context ctx) {
		return ctx.mkIntConst(getName() + "(" + e.repr() + ")");
	}

	public IntExpr toZ3IntResult(Event e, Context ctx) {
		return ctx.mkIntConst(getName() + "(" + e.repr() + "_result)");
	}

	@Override
	public ImmutableSet<Register> getRegs() {
		return ImmutableSet.of(this);
	}

	@Override
	public IntExpr getLastValueExpr(Context ctx){
		if(mainThreadId > -1) {
			return ctx.mkIntConst(getName() + "_" + mainThreadId + "_final");
		}
		throw new RuntimeException("Main thread is not set for " + this);
	}

	@Override
	public int getIntValue(Event e, Context ctx, Model model){
		return Integer.parseInt(model.getConstInterp(toZ3Int(e, ctx)).toString());
	}
}
