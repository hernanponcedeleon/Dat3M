package com.dat3m.dartagnan.program.event.arch.tso;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.program.Register;
import static com.dat3m.dartagnan.program.event.Tag.*;

import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.MemEvent;
import com.dat3m.dartagnan.program.event.core.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.dat3m.dartagnan.program.memory.Address;
import com.google.common.collect.ImmutableSet;

public class Xchg extends MemEvent implements RegWriter, RegReaderData {

    private final Register resultRegister;
    private final ImmutableSet<Register> dataRegs;

    public Xchg(Address address, Register register) {
        super(address, null);
        this.resultRegister = register;
        this.dataRegs = ImmutableSet.of(resultRegister);
        addFilters(ANY, VISIBLE, MEMORY, READ, WRITE, Tag.TSO.ATOM, REG_WRITER, REG_READER);
    }

    private Xchg(Xchg other){
        super(other);
        this.resultRegister = other.resultRegister;
        this.dataRegs = other.dataRegs;
    }

    @Override
    public Register getResultRegister(){
        return resultRegister;
    }

    @Override
    public ImmutableSet<Register> getDataRegs(){
        return dataRegs;
    }

    @Override
    public String toString() {
        return "xchg(*" + address + ", " + resultRegister + ")";
    }

    @Override
    public ExprInterface getMemValue(){
        return resultRegister;
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public Xchg getCopy(){
        return new Xchg(this);
    }

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitXchg(this);
	}
}