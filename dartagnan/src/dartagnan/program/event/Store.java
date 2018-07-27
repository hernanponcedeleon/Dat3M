package dartagnan.program.event;

import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

import com.microsoft.z3.*;

import dartagnan.expression.AExpr;
import dartagnan.program.Location;
import dartagnan.program.Register;
import dartagnan.program.event.filter.FilterUtils;
import dartagnan.utils.LastModMap;
import dartagnan.utils.MapSSA;
import dartagnan.utils.Pair;

import static dartagnan.utils.Utils.ssaReg;
import static dartagnan.utils.Utils.ssaLoc;

public class Store extends MemEvent {

	protected AExpr val;
	protected Register reg;

	public Store(Location loc, AExpr val, String atomic) {
		this.val = val;
		this.reg = (val instanceof Register) ? (Register) val : null;
		this.loc = loc;
		this.atomic = atomic;
		this.condLevel = 0;
		addFilters(
				FilterUtils.EVENT_TYPE_ANY,
				FilterUtils.EVENT_TYPE_MEMORY,
				FilterUtils.EVENT_TYPE_WRITE
		);
	}

	public Register getReg() {
		return reg;
	}
	
	public String toString() {
        return String.format("%s%s := %s", String.join("", Collections.nCopies(condLevel, "  ")), loc, val);
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
        Location newLoc = loc.clone();
        AExpr newVal = val.clone();
		Store newStore = new Store(newLoc, newVal, atomic);
		newStore.condLevel = condLevel;
		newStore.setHLId(getHLId());
		newStore.setUnfCopy(getUnfCopy());
		return newStore;
	}

	public Pair<BoolExpr, MapSSA> encodeDF(MapSSA map, Context ctx) throws Z3Exception {
		if(mainThread == null){
			System.out.println(String.format("Check encodeDF for %s", this));
			return null;
		}
		else {
			Expr z3Loc = ssaLoc(loc, mainThread, map.getFresh(loc), ctx); 
			this.ssaLoc = z3Loc;
			if(reg != null){
                Expr z3Reg = ssaReg(reg, map.get(reg), ctx);
                return new Pair<BoolExpr, MapSSA>(ctx.mkImplies(executes(ctx), ctx.mkEq(z3Loc, z3Reg)), map);
            } else {
                return new Pair<BoolExpr, MapSSA>(ctx.mkImplies(executes(ctx), ctx.mkEq(z3Loc, ctx.mkInt(val.toString()))), map);
            }
		}		
	}
}