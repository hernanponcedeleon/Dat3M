package dartagnan.program.event.address;

import com.microsoft.z3.Context;
import com.microsoft.z3.IntExpr;
import dartagnan.program.Register;
import dartagnan.program.event.MemEvent;
import dartagnan.program.memory.Location;

import java.util.Set;

public abstract class MemEventAddress extends MemEvent {

    protected Register address;
    protected IntExpr addressExpr;
    protected Set<Location> locations;

    public void setMemoryMaxSet(Set<Location> locations){
        this.locations = locations;
    }

    public Register getAddressReg(){
        return address;
    }

    @Override
    public IntExpr getAddressExpr(Context ctx){
        return addressExpr;
    }

}
