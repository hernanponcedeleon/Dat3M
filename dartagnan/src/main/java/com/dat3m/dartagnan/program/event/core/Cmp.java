package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.dat3m.dartagnan.program.expression.Expression;

public class Cmp extends Skip {

    private final Expression left;
    private final Expression right;

    public Cmp(Expression left, Expression right){
        this.left = left;
        this.right = right;
    }

    private Cmp(Cmp other){
        super(other);
        this.left = other.left;
        this.right = other.right;
    }

    public Expression getLeft(){
        return left;
    }

    public Expression getRight(){
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