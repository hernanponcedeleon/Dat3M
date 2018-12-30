package dartagnan.program.event;

import com.google.common.collect.Sets;
import com.microsoft.z3.IntExpr;
import dartagnan.expression.IExpr;
import dartagnan.program.Register;
import dartagnan.program.memory.Address;

import java.util.Set;

public abstract class MemEvent extends Event {

    protected IExpr address;
    protected IntExpr addressExpr;
    protected IntExpr valueExpr;

    protected Set<Address> addresses;

    public IntExpr getAddressExpr(){
        if(addressExpr != null){
            return addressExpr;
        }
        throw new RuntimeException("Attempt to access not initialised address expression in " + this);
    }

    public IntExpr getValueExpr(){
        if(valueExpr != null){
            return valueExpr;
        }
        throw new RuntimeException("Attempt to access not initialised value expression in " + this);
    }

    public Set<Address> getMaxAddressSet(){
        if(addresses != null){
            return addresses;
        }
        throw new RuntimeException("Location set has not been initialised for memory event " + this);
    }

    public void setMaxAddressSet(Set<Address> addresses){
        this.addresses = addresses;
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
        ((MemEvent)clone).setMaxAddressSet(addresses);
    }
}