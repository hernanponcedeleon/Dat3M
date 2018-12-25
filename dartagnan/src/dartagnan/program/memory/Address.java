package dartagnan.program.memory;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.IntExpr;
import dartagnan.expression.IConst;
import dartagnan.expression.ExprInterface;
import dartagnan.expression.IntExprInterface;
import dartagnan.program.Register;
import dartagnan.utils.MapSSA;

import java.util.HashSet;
import java.util.Set;

public class Address extends IConst implements IntExprInterface, ExprInterface {

    private final int index;

    Address(int index){
        super(index);
        this.index = index;
    }

    @Override
    public Set<Register> getRegs(){
        return new HashSet<>();
    }

    @Override
    public IntExpr toZ3Int(MapSSA map, Context ctx){
        return toZ3Int(ctx);
    }

    @Override
    public IntExpr getLastValueExpr(Context ctx){
        return toZ3Int(ctx);
    }

    @Override
    public BoolExpr toZ3Bool(MapSSA map, Context ctx){
        return ctx.mkTrue();
    }

    @Override
    public Address clone(){
        return new Address(index);
    }

    @Override
    public String toString(){
        return "&mem" + index;
    }

    @Override
    public IntExpr toZ3Int(Context ctx){
        return ctx.mkIntConst("memory_" + index);
    }
}
