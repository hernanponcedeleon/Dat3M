package com.dat3m.dartagnan.program.event.lang.catomic;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

import static com.dat3m.dartagnan.program.event.Tag.STRONG;

public class AtomicCmpXchg extends AtomicAbstract implements RegWriter, RegReaderData {

    private IExpr expectedAddr;

    public AtomicCmpXchg(Register register, IExpr address, IExpr expectedAddr, IExpr value, String mo, boolean strong) {
        super(address, register, value, mo);
        this.expectedAddr = expectedAddr;
        if(strong) {
        	addFilters(STRONG);
        }
    }

    private AtomicCmpXchg(AtomicCmpXchg other){
        super(other);
        this.expectedAddr = other.expectedAddr;
    }

    //TODO: Override getDataRegs???

    public IExpr getExpectedAddr() {
    	return expectedAddr;
    }
    
    public void setExpectedAddr(IExpr expectedAddr) {
    	this.expectedAddr = expectedAddr;
    }
    
    @Override
    public String toString() {
    	String tag = is(STRONG) ? "_strong" : "_weak";
    	tag += mo != null ? "_explicit" : "";
        return resultRegister + " = atomic_compare_exchange" + tag + "(*" + address + ", " + expectedAddr + ", " + value + (mo != null ? ", " + mo : "") + ")\t### C11";
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