package com.dat3m.dartagnan.program.event.lang.catomic;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EType;
import com.dat3m.dartagnan.program.event.core.MemEvent;
import com.dat3m.dartagnan.program.event.core.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableSet;

import static com.dat3m.dartagnan.program.event.lang.catomic.utils.Mo.*;

public class AtomicStore extends MemEvent implements RegReaderData {

    private final ExprInterface value;
    private final ImmutableSet<Register> dataRegs;

    public AtomicStore(IExpr address, ExprInterface value, String mo){
        super(address, mo);
        Preconditions.checkArgument(!mo.equals(ACQUIRE) && !mo.equals(ACQUIRE_RELEASE), 
        		getClass().getName() + " can not have memory order: " + mo);
        this.value = value;
        this.dataRegs = value.getRegs();
        addFilters(EType.ANY, EType.VISIBLE, EType.MEMORY, EType.WRITE, EType.REG_READER);
    }

    private AtomicStore(AtomicStore other){
        super(other);
        this.value = other.value;
        this.dataRegs = other.dataRegs;
    }

    @Override
    public ImmutableSet<Register> getDataRegs(){
        return dataRegs;
    }

    @Override
    public String toString() {
    	String tag = mo != null ? "_explicit" : "";
        return "atomic_store" + tag + "(*" + address + ", " +  value + (mo != null ? ", " + mo : "") + ")";
    }

    @Override
    public ExprInterface getMemValue() {
    	return value;
    }
    
    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public AtomicStore getCopy(){
        return new AtomicStore(this);
    }

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visit(this);
	}
}