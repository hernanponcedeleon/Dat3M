package com.dat3m.dartagnan.program.event.arch.riscv;

import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag.RISCV;
import com.dat3m.dartagnan.program.event.core.MemEvent;
import com.dat3m.dartagnan.program.event.core.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableSet;

import static com.dat3m.dartagnan.program.event.Tag.*;

import java.util.HashSet;
import java.util.Set;

import org.sosy_lab.java_smt.api.Formula;

public abstract class AmoAbstract extends MemEvent implements RegWriter, RegReaderData {

    protected final Register resultRegister;
    protected final Register r2;
    protected Formula memLoadValueExpr;
    protected Formula memStoreValueExpr;

    AmoAbstract(Register rd, Register r2, IExpr address, String mo) {
        super(address, mo);
        this.resultRegister = rd;
        this.r2 = r2;
        addFilters(ANY, VISIBLE, MEMORY, READ, WRITE, REG_WRITER, REG_READER, RISCV.AMO);
    }

    AmoAbstract(AmoAbstract other){
        super(other);
        this.resultRegister = other.resultRegister;
        this.r2 = other.r2;
    }

	@Override
	public ImmutableSet<Register> getDataRegs() {
		Set<Register> ret = new HashSet<>();
		ret.add(resultRegister);
		ret.add(r2);
		ret.addAll(address.getRegs());
		return ImmutableSet.copyOf(ret);
	}

	@Override
	public Register getResultRegister() {
		return resultRegister;
	}

    public Formula getMemValueExpr(){
    	throw new RuntimeException("MemValueExpr is not available for event " + this.getClass().getName());
    }

    public Formula getLoadMemValueExpr(){
    	Preconditions.checkState(memLoadValueExpr != null);
    	return memLoadValueExpr;
    }

    public Formula getStoreMemValueExpr(){
    	Preconditions.checkState(memStoreValueExpr != null);
    	return memStoreValueExpr;
    }

    @Override
    public Formula getResultRegisterExpr(){
        return memLoadValueExpr;
    }

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitRMWAbstract(this);
	}
}