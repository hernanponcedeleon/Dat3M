package com.dat3m.dartagnan.program.event.lang.catomic;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;

import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

public class Dat3mCAS extends AtomicAbstract {

    private final ExprInterface expectedValue;

    public Dat3mCAS(Register register, IExpr address, ExprInterface expectedVal, IExpr desiredValue, String mo) {
        super(address, register, desiredValue, mo);
        this.expectedValue = expectedVal;
    }

    private Dat3mCAS(Dat3mCAS other){
        super(other);
        this.expectedValue = other.expectedValue;
    }

    @Override
    public String toString() {
        return resultRegister + " = __DAT3M_CAS(*" + address + ", " + expectedValue + ", " + value + (mo != null ? ", " + mo : "") + ")";
    }

    @Override
    public ExprInterface getMemValue() {
    	return value;
    }
    
    public ExprInterface getExpectedValue() {
    	return expectedValue;
    }
    
    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public Dat3mCAS getCopy(){
        return new Dat3mCAS(this);
    }

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitDat3mCAS(this);
	}
}