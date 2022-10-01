package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

public class Load extends MemEvent implements RegWriter {

    protected final Register resultRegister;

    public Load(Register register, IExpr address, String mo) {
        super(address, mo);
        this.resultRegister = register;
        addFilters(Tag.ANY, Tag.VISIBLE, Tag.MEMORY, Tag.READ, Tag.REG_WRITER);
    }
    
    protected Load(Load other){
        super(other);
        this.resultRegister = other.resultRegister;
    }

    @Override
    public Register getResultRegister(){
        return resultRegister;
    }

    @Override
    public String toString() {
        return resultRegister + " = load(*" + address + (mo != null ? ", " + mo : "") + ")";
    }

    @Override
    public ExprInterface getMemValue(){
        return resultRegister;
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public Load getCopy(){
        return new Load(this);
    }

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitLoad(this);
	}
}