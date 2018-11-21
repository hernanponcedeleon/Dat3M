package dartagnan.program.event;

import com.google.common.collect.ImmutableSet;
import com.google.common.collect.Sets;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.microsoft.z3.IntExpr;
import dartagnan.program.memory.Location;

public abstract class MemEvent extends Event {

    protected Location loc;
    protected Expr ssaLoc;
    protected int memId;
    protected ImmutableSet<Location> locations;

    public ImmutableSet<Location> getMaximumLocationSet(){
        if(locations == null){
            locations = ImmutableSet.of(loc);
        }
        return locations;
    }

    public Expr getSsaLoc(Location location){
        // TODO: Implementation
        return ssaLoc;
    }

    public IntExpr getAddressExpr(Context ctx){
        // TODO: Implementation
        return ctx.mkInt(loc.getAddress());
    }

    public static boolean canAddressTheSameLocation(MemEvent e1, MemEvent e2){
        return !Sets.intersection(e1.getMaximumLocationSet(), e2.getMaximumLocationSet()).isEmpty();
    }
}