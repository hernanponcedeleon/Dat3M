package com.dat3m.dartagnan.program.event.lang.catomic;

import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;


public class AtomicCmpXchg extends AtomicAbstract {

    private IExpr expectedAddr;
    private boolean isStrong;

    public AtomicCmpXchg(Register register, IExpr address, IExpr expectedAddr, IExpr value, String mo, boolean isStrong) {
        super(address, register, value, mo);
        this.expectedAddr = expectedAddr;
        this.isStrong = isStrong;
    }

    private AtomicCmpXchg(AtomicCmpXchg other){
        super(other);
        this.expectedAddr = other.expectedAddr;
        this.isStrong = other.isStrong;
    }

    public boolean isStrong() { return this.isStrong; }
    public boolean isWeak() { return !this.isStrong; }

    //TODO: Override getDataRegs???

    public IExpr getExpectedAddr() {
    	return expectedAddr;
    }
    
    public void setExpectedAddr(IExpr expectedAddr) {
    	this.expectedAddr = expectedAddr;
    }
    
    @Override
    public String toString() {
        return resultRegister + " = atomic_compare_exchange" + (isStrong ? "_strong" : "_weak") +
            "(*" + address + ", " + expectedAddr + ", " + value + ", " + mo + ")\t### C11";
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public AtomicCmpXchg getCopy(){
        return new AtomicCmpXchg(this);
    }

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitAtomicCmpXchg(this);
	}
}