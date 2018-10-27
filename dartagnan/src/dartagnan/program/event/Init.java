package dartagnan.program.event;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import dartagnan.program.HighLocation;
import dartagnan.program.Location;
import dartagnan.program.event.filter.FilterUtils;
import dartagnan.utils.MapSSA;
import dartagnan.utils.Pair;

import static dartagnan.utils.Utils.initValue;
import static dartagnan.utils.Utils.ssaLoc;

public class Init extends MemEvent {
	
	public Init(Location loc) {
		setHLId(hashCode());
		this.loc = loc;
		this.condLevel = 0;
		addFilters(
				FilterUtils.EVENT_TYPE_ANY,
				FilterUtils.EVENT_TYPE_MEMORY,
				FilterUtils.EVENT_TYPE_INIT,
				FilterUtils.EVENT_TYPE_WRITE
		);
	}

	@Override
	public String toString() {
		return nTimesCondLevel() + loc + " := 0";
	}

	@Override
	public String label(){
		return "W " + loc;
	}

	@Override
	public Init clone() {
		Location newLoc = loc.clone();
		Init newInit = new Init(newLoc);
		newInit.condLevel = condLevel;
		newInit.setHLId(getHLId());
		return newInit;
	}

	@Override
	public Pair<BoolExpr, MapSSA> encodeDF(MapSSA map, Context ctx) {
		if(mainThread != null){
			Expr z3Loc = ssaLoc(loc, mainThread.getTId(), map.getFresh(loc), ctx);
			this.ssaLoc = z3Loc;
			Expr initValue;
			if(loc.getIValue() == null) {
				initValue = ctx.mkInt(0);
			}
			else {
				initValue = ctx.mkInt(loc.getIValue());
			}
			if(loc instanceof HighLocation && loc.getIValue() == null) {
				initValue = initValue(this, ctx);
			}
			return new Pair<>(ctx.mkEq(z3Loc, initValue), map);
		}
		throw new RuntimeException("Main thread is not set for " + toString());
	}
}