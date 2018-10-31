package dartagnan.parsers.utils.branch;

import dartagnan.expression.AExpr;
import dartagnan.program.event.Event;

public class Cmp extends Event {

    private AExpr left;
    private AExpr right;

    public Cmp(AExpr left, AExpr right){
        this.left = left;
        this.right = right;
    }

    public AExpr getLeft(){
        return left;
    }

    public AExpr getRight(){
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
