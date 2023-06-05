package com.dat3m.dartagnan.program.event.lang.linux;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

import java.util.Set;

public class RMWCmpXchg extends RMWAbstract {

    private final ExprInterface cmp;

    public RMWCmpXchg(IExpr address, Register register, ExprInterface cmp, IExpr value, String mo) {
        super(address, register, value, mo);
        this.cmp = cmp;
    }

    private RMWCmpXchg(RMWCmpXchg other){
        super(other);
        this.cmp = other.cmp;
    }

    @Override
    public String toString() {
        return resultRegister + " := atomic_cmpxchg" + Tag.Linux.toText(mo) + "(" + address + ", " + cmp + ", " + value + ")\t### LKMM";
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
    public RMWCmpXchg getCopy(){
        return new RMWCmpXchg(this);
    }

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitRMWCmpXchg(this);
	}
}