package dartagnan.asserts;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.Location;
import static dartagnan.utils.Utils.lastValueLoc;

public class AssertLocation implements AssertInterface{

    private Location location;
    private int value;

    public AssertLocation(Location location, int value){
        this.location = location;
        this.value = value;
    }

    public BoolExpr encode(Context ctx) throws Z3Exception{
        return ctx.mkEq(lastValueLoc(location, ctx), ctx.mkInt(value));
    }

    public String toString(){
        return location.getName() + "=" + value;
    }
}
