package dartagnan.program.event;

import com.google.common.collect.Sets;
import com.microsoft.z3.Expr;
import com.microsoft.z3.IntExpr;
import dartagnan.expression.AExpr;
import dartagnan.program.Register;
import dartagnan.program.memory.Location;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;

public abstract class MemEvent extends Event {

    protected AExpr address;
    protected IntExpr addressExpr;

    protected Set<Location> locations;
    protected Map<Location, Expr> ssaLocMap = new HashMap<>();

    protected int memId;

    public IntExpr getAddressExpr(){
        if(addressExpr != null){
            return addressExpr;
        }
        throw new RuntimeException("Attempt to access not initialised address expression in " + this);
    }

    public Set<Location> getMaxLocationSet(){
        if(locations != null){
            return locations;
        }
        throw new RuntimeException("Location set has not been initialised for memory event " + this);
    }

    public void setMaxLocationSet(Set<Location> locations){
        this.locations = locations;
    }

    public Register getAddressReg(){
        if(address instanceof Register){
            return (Register) address;
        }
        return null;
    }

    public AExpr getAddress(){
        return address;
    }

    public Expr getSsaLoc(Location location){
        return ssaLocMap.get(location);
    }

    public static boolean canAddressTheSameLocation(MemEvent e1, MemEvent e2){
        return !Sets.intersection(e1.getMaxLocationSet(), e2.getMaxLocationSet()).isEmpty();
    }

    @Override
    protected void afterClone(){
        super.afterClone();
        clone.setHLId(memId);
        ((MemEvent)clone).setMaxLocationSet(locations);
    }
}