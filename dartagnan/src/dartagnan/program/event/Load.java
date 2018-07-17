package dartagnan.program.event;

import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

import com.microsoft.z3.*;

import dartagnan.program.Location;
import dartagnan.program.Register;
import dartagnan.utils.LastModMap;
import dartagnan.utils.MapSSA;
import dartagnan.utils.Pair;
import static dartagnan.utils.Utils.ssaLoc;
import static dartagnan.utils.Utils.ssaReg;

public class Load extends MemEvent {

	private Register reg;
	private Integer ssaRegIndex;
	
	public Load(Register reg, Location loc) {
		this.reg = reg;
		this.loc = loc;
		this.condLevel = 0;
	}
	
	public Register getReg() {
		return reg;
	}
	
	public String toString() {
		return String.format("%s%s <- %s", String.join("", Collections.nCopies(condLevel, "  ")), reg, loc);
	}
	
	public LastModMap setLastModMap(LastModMap map) {
		this.lastModMap = map;
		LastModMap retMap = map.clone();
		Set<Event> set = new HashSet<Event>();
		set.add(this);
		retMap.put(reg, set);
		return retMap;
	}
	
	public Load clone() {
		Register newReg = reg.clone();
		Location newLoc = loc.clone();
		Load newLoad = new Load(newReg, newLoc);
		newLoad.condLevel = condLevel;
		newLoad.setHLId(getHLId());
		newLoad.setUnfCopy(getUnfCopy());
		return newLoad;
	}
	
	public Pair<BoolExpr, MapSSA> encodeDF(MapSSA map, Context ctx) throws Z3Exception {
		if(mainThread == null){
			System.out.println(String.format("Check encodeDF for %s", this));
			return null;
		}
		else {
			Expr z3Reg = ssaReg(reg, map.getFresh(reg), ctx);
			Expr z3Loc = ssaLoc(loc, mainThread, map.getFresh(loc), ctx);
			this.ssaLoc = z3Loc;
			this.ssaRegIndex = map.get(reg);
			return new Pair<BoolExpr, MapSSA>(ctx.mkImplies(executes(ctx), ctx.mkEq(z3Reg, z3Loc)), map);
		}		
	}
	
	public Integer getSsaRegIndex() {
		return ssaRegIndex;
	}
}