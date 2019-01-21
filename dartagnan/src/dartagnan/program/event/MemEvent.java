package dartagnan.program.event;

import com.google.common.collect.ImmutableSet;
import com.google.common.collect.Sets;
import com.microsoft.z3.IntExpr;
import dartagnan.expression.ExprInterface;
import dartagnan.expression.IExpr;
import dartagnan.program.memory.Address;

public abstract class MemEvent extends Event {

    protected IExpr address;
    protected ImmutableSet<Address> maxAddressSet;

    protected IntExpr memAddressExpr;
    protected IntExpr memValueExpr;

    public IntExpr getMemAddressExpr(){
        if(memAddressExpr != null){
            return memAddressExpr;
        }
        throw new RuntimeException("Attempt to access not initialised address expression in " + this);
    }

    public IntExpr getMemValueExpr(){
        if(memValueExpr != null){
            return memValueExpr;
        }
        throw new RuntimeException("Attempt to access not initialised value expression in " + this);
    }

    public ImmutableSet<Address> getMaxAddressSet(){
        if(maxAddressSet != null){
            return maxAddressSet;
        }
        throw new RuntimeException("Location set has not been initialised for memory event " + this);
    }

    public void setMaxAddressSet(ImmutableSet<Address> maxAddressSet){
        this.maxAddressSet = maxAddressSet;
    }

    public IExpr getAddress(){
        return address;
    }

    public ExprInterface getMemValue(){
        throw new RuntimeException("MemValue is not available for event " + this.getClass().getName());
    }

    @Override
    protected void afterClone(){
        super.afterClone();
        ((MemEvent)clone).setMaxAddressSet(maxAddressSet);
    }

    public static boolean canAddressTheSameLocation(MemEvent e1, MemEvent e2){
        return !Sets.intersection(e1.getMaxAddressSet(), e2.getMaxAddressSet()).isEmpty();
    }
}