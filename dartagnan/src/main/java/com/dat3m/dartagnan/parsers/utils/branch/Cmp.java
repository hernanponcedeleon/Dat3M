package com.dat3m.dartagnan.parsers.utils.branch;

import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.event.Event;

public class Cmp extends Event {

    private IExpr left;
    private IExpr right;

    public Cmp(IExpr left, IExpr right){
        this.left = left;
        this.right = right;
    }

    IExpr getLeft(){
        return left;
    }

    IExpr getRight(){
        return right;
    }

    @Override
    public String toString(){
        return "cmp " + left + " " + right;
    }

    @Override
    public Cmp clone(){
        return new Cmp(left.clone(), right.clone());
    }
}
