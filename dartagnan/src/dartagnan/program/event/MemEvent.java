package dartagnan.program.event;

import com.google.common.collect.ImmutableSet;
import com.google.common.collect.Sets;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.microsoft.z3.IntExpr;
import dartagnan.program.memory.Location;

import java.util.HashMap;
import java.util.Map;

public abstract class MemEvent extends Event {

    protected Location loc;
    protected int memId;
    protected ImmutableSet<Location> locations;
    protected Map<Location, Expr> ssaLocMap = new HashMap<>();

    public ImmutableSet<Location> getMaximumLocationSet(){
        if(locations == null){
            locations = ImmutableSet.of(loc);
        }
        return locations;
    }

    public Expr getSsaLoc(Location location){
        return ssaLocMap.get(location);
    }

    public IntExpr getAddressExpr(Context ctx){
        return ctx.mkInt(loc.getAddress());
    }

    public static boolean canAddressTheSameLocation(MemEvent e1, MemEvent e2){
        return !Sets.intersection(e1.getMaximumLocationSet(), e2.getMaximumLocationSet()).isEmpty();
    }
}