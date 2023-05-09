package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

public class Cmp extends Skip {

    private final IExpr left;
    private final IExpr right;

    public Cmp(IExpr left, IExpr right){
        this.left = left;
        this.right = right;
    }

    private Cmp(Cmp other){
        super(other);
        this.left = other.left;
        this.right = other.right;
    }

    public IExpr getLeft(){
        return left;
    }

    public IExpr getRight(){
        return right;
    }

    @Override
    public String toString(){
        return "cmp(" + left + "," + right + ")";
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public Cmp getCopy(){
        return new Cmp(this);
    }

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitCmp(this);
	}
}