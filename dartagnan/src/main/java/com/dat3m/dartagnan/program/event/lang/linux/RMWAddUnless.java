package com.dat3m.dartagnan.program.event.lang.linux;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.google.common.collect.ImmutableSet;

public class RMWAddUnless extends RMWAbstract implements RegWriter, RegReaderData {

    private final ExprInterface cmp;

    public RMWAddUnless(IExpr address, Register register, ExprInterface cmp, IExpr value) {
        super(address, register, value, Tag.Linux.MO_MB);
        this.cmp = cmp;
    }

    private RMWAddUnless(RMWAddUnless other){
        super(other);
        this.cmp = other.cmp;
    }

    @Override
    public String toString() {
        return resultRegister + " := atomic_add_unless" + "(" + address + ", " + value + ", " + cmp + ")\t### LKMM";
    }

    public ExprInterface getCmp() {
    	return cmp;
    }
    
    @Override
    public ImmutableSet<Register> getDataRegs(){
        return new ImmutableSet.Builder<Register>().addAll(value.getRegs()).addAll(cmp.getRegs()).build();
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public RMWAddUnless getCopy(){
        return new RMWAddUnless(this);
    }

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitRMWAddUnless(this);
	}
}