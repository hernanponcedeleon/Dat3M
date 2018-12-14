package dartagnan.program.event;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.microsoft.z3.IntExpr;
import dartagnan.expression.AConst;
import dartagnan.program.memory.Address;
import dartagnan.program.memory.Location;
import dartagnan.program.utils.EType;
import dartagnan.utils.MapSSA;
import dartagnan.utils.Pair;

import static dartagnan.utils.Utils.ssaLoc;

public class Init extends MemEvent {

	private AConst value;
	
	public Init(Address address, AConst value) {
		this.address = address;
		this.value = value;
		this.condLevel = 0;
		addFilters(EType.ANY, EType.MEMORY, EType.WRITE, EType.INIT);
	}

	@Override
	public String toString() {
		return nTimesCondLevel() + "memory[" + address + "] := " + value;
	}

	@Override
	public String label(){
		return "W";
	}

	@Override
	public Init clone() {
	    if(clone == null){
            clone = new Init((Address) address.clone(), value.clone());
            afterClone();
        }
		return (Init)clone;
	}

	@Override
	public Pair<BoolExpr, MapSSA> encodeDF(MapSSA map, Context ctx) {
		if(mainThread == null){
			throw new RuntimeException("Main thread is not set for " + this);
		}
		if(locations.size() != 1){
			throw new RuntimeException("Invalid location set in " + this);
		}
		addressExpr = (IntExpr) address.toZ3(map, ctx);

		BoolExpr enc = ctx.mkTrue();
		for(Location loc : locations){
			Expr z3Loc = ssaLoc(loc, mainThread.getTId(), map.getFresh(loc), ctx);
			this.ssaLocMap.put(loc, z3Loc);
			enc = ctx.mkAnd(enc, ctx.mkImplies(executes(ctx), ctx.mkEq(z3Loc, value.toZ3(ctx))));
		}
		return new Pair<>(enc, map);
	}

	public AConst getValue(){
		return value;
	}
}