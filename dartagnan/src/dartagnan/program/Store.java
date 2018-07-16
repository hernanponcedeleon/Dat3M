package dartagnan.program;

import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

import com.microsoft.z3.*;

import dartagnan.expression.AConst;
import dartagnan.utils.LastModMap;
import dartagnan.utils.MapSSA;
import dartagnan.utils.Pair;

import static dartagnan.utils.Utils.ssaReg;
import static dartagnan.utils.Utils.ssaLoc;

public class Store extends MemEvent {

	protected Register reg;
	protected AConst val;

	public Store(Location loc, Register reg) {
		this.reg = reg;
		this.loc = loc;
		this.condLevel = 0;
	}

	public Store(Location loc, AConst val) {
		this.val = val;
		this.loc = loc;
		this.condLevel = 0;
	}

	public Register getReg() {
		return reg;
	}
	
	public String toString() {
		if(reg != null){
            return String.format("%s%s := %s", String.join("", Collections.nCopies(condLevel, "  ")), loc, reg);
		}
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
        Store newStore;
        Location newLoc = loc.clone();
		if(reg != null){
            Register newReg = reg.clone();
            newStore = new Store(newLoc, newReg);
        } else {
            AConst newVal = val.clone();
            newStore = new Store(newLoc, newVal);
        }
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