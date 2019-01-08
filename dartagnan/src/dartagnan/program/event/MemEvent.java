package dartagnan.program.event;

import com.google.common.collect.Sets;
import com.microsoft.z3.IntExpr;
import dartagnan.expression.IExpr;
import dartagnan.program.Register;
import dartagnan.program.memory.Address;

import java.util.Set;

public abstract class MemEvent extends Event {

    protected IExpr address;
    protected Set<Address> maxAddressSet;

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

    public Set<Address> getMaxAddressSet(){
        if(maxAddressSet != null){
            return maxAddressSet;
        }
        throw new RuntimeException("Location set has not been initialised for memory event " + this);
    }

    public void setMaxAddressSet(Set<Address> addresses){
        this.maxAddressSet = addresses;
    }

    public Set<Register> getAddressRegs(){
        return address.getRegs();
    }

    public IExpr getAddress(){
        return address;
    }

    public static boolean canAddressTheSameLocation(MemEvent e1, MemEvent e2){
        return !Sets.intersection(e1.getMaxAddressSet(), e2.getMaxAddressSet()).isEmpty();
    }

    @Override
    protected void afterClone(){
        super.afterClone();
        ((MemEvent)clone).setMaxAddressSet(maxAddressSet);
    }
}