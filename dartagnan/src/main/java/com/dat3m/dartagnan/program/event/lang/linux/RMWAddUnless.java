package com.dat3m.dartagnan.program.event.lang.linux;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

import java.util.Set;

public class RMWAddUnless extends RMWAbstract {

    private final ExprInterface cmp;

    public RMWAddUnless(ExprInterface address, Register register, ExprInterface cmp, ExprInterface value) {
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
    public Set<Register.Read> getRegisterReads(){
        return Register.collectRegisterReads(cmp, Register.UsageType.DATA, super.getRegisterReads());
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