package dartagnan.program;

import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

import com.microsoft.z3.*;

import dartagnan.utils.LastModMap;
import dartagnan.utils.MapSSA;
import dartagnan.utils.Pair;

public class Store extends MemEvent {

	private Register reg;
	
	public Store(Location loc, Register reg) {
		this.reg = reg;
		this.loc = loc;
		this.condLevel = 0;
	}
	
	public Register getReg() {
		return reg;
	}
	
	public String toString() {
		return String.format("%s%s := %s", String.join("", Collections.nCopies(condLevel, "  ")), loc, reg);
	}

	public LastModMap setLastModMap(LastModMap map) {
		this.lastModMap = map;
		LastModMap retMap = map.clone();
		Set<Event> set = new HashSet<Event>();
		set.add(this);
		retMap.put(loc, set);
		return retMap;
	}
	
	public Store clone() {
		Register newReg = reg.clone();
		Location newLoc = loc.clone();
		Store newStore = new Store(newLoc, newReg);
		newStore.condLevel = condLevel;
		newStore.setHLId(getHLId());
		return newStore;
	}

	public Pair<BoolExpr, MapSSA> encodeDF(MapSSA map, Context ctx) throws Z3Exception {
		if(mainThread == null){
			System.out.println(String.format("Check encodeDF for %s", this));
			return null;
		}
		else {
			Expr z3Loc = ctx.mkIntConst(String.format("T%s_%s_%s", mainThread, loc, map.getFresh(loc))); 
			this.ssaLoc = z3Loc;
			Expr z3Reg = ctx.mkIntConst(String.format("T%s_%s_%s", mainThread, reg, map.get(reg)));
			return new Pair<BoolExpr, MapSSA>(ctx.mkImplies(executes(ctx), ctx.mkEq(z3Loc, z3Reg)), map);
		}		
	}
}