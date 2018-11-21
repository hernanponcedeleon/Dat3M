package dartagnan.program.event;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
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
			return new Pair<>(ctx.mkEq(z3Loc, ctx.mkInt(loc.getIValue())), map);
		}
		throw new RuntimeException("Main thread is not set for " + toString());
	}

	public int getIValue(){
		return loc.getIValue();
	}
}