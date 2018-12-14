package dartagnan.program.memory;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.microsoft.z3.IntExpr;
import dartagnan.expression.AConst;
import dartagnan.expression.ExprInterface;
import dartagnan.expression.IntExprInterface;
import dartagnan.program.Register;
import dartagnan.utils.MapSSA;

import java.util.HashSet;
import java.util.Set;

public class Address extends AConst implements IntExprInterface, ExprInterface {

    private static int nextIndex = 0;

    private final int index;

    Address(){
        super(nextIndex);
        this.index = nextIndex;
        nextIndex++;
    }

    private Address(int index){
        super(nextIndex);
        this.index = index;
    }

    @Override
    public BoolExpr encodeAssignment(MapSSA map, Context ctx, Expr target, Expr value){
        return ctx.mkEq(target, value);
    }

    @Override
    public Set<Register> getRegs(){
        return new HashSet<>();
    }

    @Override
    public IntExpr toZ3(MapSSA map, Context ctx){
        return toZ3(ctx);
    }

    @Override
    public IntExpr getLastValueExpr(Context ctx){
        return toZ3(ctx);
    }

    @Override
    public BoolExpr toZ3Boolean(MapSSA map, Context ctx){
        return ctx.mkTrue();
    }

    @Override
    public Address clone(){
        return new Address(index);
    }

    @Override
    public String toString(){
        return "memory_" + index;
    }

    public IntExpr toZ3(Context ctx){
        return ctx.mkIntConst("memory_" + index);
    }
}
