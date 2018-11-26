package dartagnan.program.event;

import com.google.common.collect.ImmutableSet;
import com.google.common.collect.Sets;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.microsoft.z3.IntExpr;
import dartagnan.program.memory.Location;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;

public abstract class MemEvent extends Event {

    protected Location loc;
    protected int memId;
    protected Set<Location> locations;
    protected Map<Location, Expr> ssaLocMap = new HashMap<>();

    public Set<Location> getMaxLocationSet(){
        if(locations == null){
            if(loc == null){
                // TODO: Assign all locations to such events during compilation
                throw new RuntimeException("Location set is not specified for address event " + getClass().getName() + " " + getEId() + ": " + this);
            }
            locations = ImmutableSet.of(loc);
        }
        return locations;
    }

    public Expr getSsaLoc(Location location){
        return ssaLocMap.get(location);
    }

    public IntExpr getAddressExpr(Context ctx){
        return loc.getAddress().toZ3(ctx);
    }

    public static boolean canAddressTheSameLocation(MemEvent e1, MemEvent e2){
        return !Sets.intersection(e1.getMaxLocationSet(), e2.getMaxLocationSet()).isEmpty();
    }

    @Override
    protected void afterClone(){
        super.afterClone();
        clone.setHLId(memId);
    }
}