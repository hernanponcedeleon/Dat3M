package dartagnan.program.rmw;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.Location;
import dartagnan.program.MemEvent;
import dartagnan.program.Register;
import dartagnan.utils.MapSSA;
import dartagnan.utils.Pair;

public abstract class AbstractRMW extends MemEvent {

    protected Register reg;
    protected String atomic;

    public AbstractRMW(Location location, Register register, String atomic) {
        this.loc = location;
        this.reg = register;
        this.atomic = atomic;
        this.condLevel = 0;
        this.memId = hashCode();
    }

    public Register getReg() {
        return reg;
    }

    public Pair<BoolExpr, MapSSA> encodeDF(MapSSA map, Context ctx) throws Z3Exception {
        System.out.println(String.format("Check encodeDF for %s", this));
        return null;
    }
}
