package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.program.expression.Expression;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.google.common.collect.ImmutableSet;

public class Store extends MemEvent implements RegReaderData {

    protected Expression value;

    public Store(IExpr address, Expression value, String mo){
    	super(address, mo);
        this.value = value;
        addFilters(Tag.WRITE);
    }
    
    protected Store(Store other){
        super(other);
        this.value = other.value;
    }

    @Override
    public ImmutableSet<Register> getDataRegs(){
        return value.getRegs();
    }

    @Override
    public String toString() {
        return "store(*" + address + ", " + value + (!mo.isEmpty() ? ", " + mo : "") + ")";
    }

    @Override
    public Expression getMemValue(){
        return value;
    }

    @Override
    public void setMemValue(Expression value){
        this.value = value;
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public Store getCopy(){
        return new Store(this);
    }

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitStore(this);
	}
}