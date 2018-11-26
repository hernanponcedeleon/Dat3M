package dartagnan.program.memory;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.IntExpr;
import dartagnan.expression.AConst;
import dartagnan.expression.ExprInterface;
import dartagnan.expression.IntExprInterface;
import dartagnan.utils.MapSSA;

public class Address extends AConst implements IntExprInterface, ExprInterface {

    private int address;

    Address(int address){
        super(address);
        this.address = address;
    }

    @Override
    public IntExpr toZ3(Context ctx){
        return ctx.mkInt(address);
    }

    @Override
    public IntExpr toZ3(MapSSA map, Context ctx){
        return ctx.mkInt(address);
    }

    @Override
    public IntExpr getLastValueExpr(Context ctx){
        return ctx.mkInt(address);
    }

    @Override
    public BoolExpr toZ3Boolean(MapSSA map, Context ctx){
        return ctx.mkTrue();
    }

    @Override
    public Address clone(){
        return new Address(address);
    }

    @Override
    public String toString(){
        return Integer.toString(address);
    }
}
