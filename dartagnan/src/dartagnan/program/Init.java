package dartagnan.program;

import com.microsoft.z3.*;

import dartagnan.utils.LastModMap;
import dartagnan.utils.MapSSA;
import dartagnan.utils.Pair;

import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

public class Init extends MemEvent {
	
	public Init(Location loc) {
		this.setHLId(hashCode());
		this.loc = loc;
		this.condLevel = 0;
	}
	
	public String toString() {
		return String.format("%s%s := 0", String.join("", Collections.nCopies(condLevel, "  ")), loc);
	}
	
	public Init clone() {
		Location newLoc = loc.clone();
		Init newInit = new Init(newLoc);
		newInit.condLevel = condLevel;
		newInit.setHLId(this.getHLId());
		return newInit;
	}

	public LastModMap setLastModMap(LastModMap map) {
		this.lastModMap = map;
		LastModMap retMap = map.clone();
		Set<Event> set = new HashSet<Event>();
		set.add(this);
		retMap.put(loc, set);
		return retMap;
	}
	
	public Pair<BoolExpr, MapSSA> encodeDF(MapSSA map, Context ctx) throws Z3Exception {
		if(mainThread == null){
			System.out.println(String.format("Check encodeDF for %s", this));
			return null;
		}
		else {
			Expr z3Loc = ctx.mkIntConst(String.format("T%s_%s_%s", mainThread, loc, map.getFresh(loc)));
			this.ssaLoc = z3Loc;
			return new Pair<BoolExpr, MapSSA>(ctx.mkEq(z3Loc, ctx.mkInt(0)), map);
		}
	}
}