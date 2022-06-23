package com.dat3m.dartagnan.program.event.arch.riscv;

import static com.dat3m.dartagnan.program.event.Tag.ANY;
import static com.dat3m.dartagnan.program.event.Tag.MEMORY;
import static com.dat3m.dartagnan.program.event.Tag.READ;
import static com.dat3m.dartagnan.program.event.Tag.REG_READER;
import static com.dat3m.dartagnan.program.event.Tag.REG_WRITER;
import static com.dat3m.dartagnan.program.event.Tag.VISIBLE;
import static com.dat3m.dartagnan.program.event.Tag.WRITE;

import java.util.HashSet;
import java.util.Set;

import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag.RISCV;
import com.dat3m.dartagnan.program.event.core.MemEvent;
import com.dat3m.dartagnan.program.event.core.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.google.common.collect.ImmutableSet;

public class AmoOp extends MemEvent implements RegWriter, RegReaderData {

    private final Register resultRegister;
    private final Register r2;
    private final IOpBin op;

    // TODO probably add AMO tag
    // Loads from address into rd and stores to address the value rd op r2 
	public AmoOp(Register rd, Register r2, IExpr address, String mo, IOpBin op) {
		super(address, mo);
        this.resultRegister = rd;
        this.r2 = r2;
        this.op = op;
        addFilters(ANY, VISIBLE, MEMORY, READ, WRITE, REG_WRITER, REG_READER, RISCV.AMO);
	}

    private AmoOp(AmoOp other){
        super(other);
        this.resultRegister = other.resultRegister;
        this.r2 = other.r2;
        this.op = other.op;
    }

	@Override
	public ImmutableSet<Register> getDataRegs() {
		Set<Register> ret = new HashSet<>();
		ret.add(resultRegister);
		ret.addAll(address.getRegs());
		return ImmutableSet.copyOf(ret);
	}

	@Override
	public Register getResultRegister() {
		return resultRegister;
	}

	public IOpBin getOp() {
		return op;
	}
	
	public Register getOperand() {
		return r2;
	}
	
	@Override
	public String toString() {
		return String.format("%s = amo%s(%s, %s%s)", resultRegister, op.toLinuxName(), address, r2, (mo != null ? ", " + mo : ""));
		
	}
    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public AmoOp getCopy(){
        return new AmoOp(this);
    }

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitAmoOp(this);
	}
}
