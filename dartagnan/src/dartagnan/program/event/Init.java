package dartagnan.program.event;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import dartagnan.expression.AConst;
import dartagnan.program.memory.Location;
import dartagnan.program.utils.EType;
import dartagnan.utils.MapSSA;
import dartagnan.utils.Pair;

import static dartagnan.utils.Utils.ssaLoc;

public class Init extends MemEvent {
	
	public Init(Location loc) {
		setHLId(hashCode());
		this.loc = loc;
		this.condLevel = 0;
		addFilters(EType.ANY, EType.MEMORY, EType.WRITE, EType.INIT);
	}

	@Override
	public String toString() {
		return nTimesCondLevel() + loc + " := " + loc.getIValue();
	}

	@Override
	public String label(){
		return "W " + loc;
	}

	@Override
	public Init clone() {
	    if(clone == null){
            clone = new Init(loc.clone());
            afterClone();
        }
		return (Init)clone;
	}

	@Override
	public Pair<BoolExpr, MapSSA> encodeDF(MapSSA map, Context ctx) {
		if(mainThread != null){
			Expr z3Loc = ssaLoc(loc, mainThread.getTId(), map.getFresh(loc), ctx);
			this.ssaLocMap.put(loc, z3Loc);
			return new Pair<>(ctx.mkEq(z3Loc, loc.getIValue().toZ3(ctx)), map);
		}
		throw new RuntimeException("Main thread is not set for " + toString());
	}

	public AConst getIValue(){
		return loc.getIValue();
	}
}