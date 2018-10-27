package dartagnan.program.event;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import dartagnan.expression.ExprInterface;
import dartagnan.program.Location;
import dartagnan.program.Register;
import dartagnan.program.event.filter.FilterUtils;
import dartagnan.utils.MapSSA;
import dartagnan.utils.Pair;

import static dartagnan.utils.Utils.ssaLoc;

public class Store extends MemEvent {

	protected ExprInterface val;
	protected Register reg;

	public Store(Location loc, ExprInterface val, String atomic) {
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

	@Override
	public Register getReg() {
		return reg;
	}

	@Override
	public String toString() {
        return nTimesCondLevel() + loc + " := " + val;
	}

	@Override
	public String label(){
		return "W[" + atomic + "] " + loc;
	}

	@Override
	public ExprInterface getExpr(){
		return val;
	}

	@Override
	public Store clone() {
        Location newLoc = loc.clone();
        ExprInterface newVal = val.clone();
		Store newStore = new Store(newLoc, newVal, atomic);
		newStore.condLevel = condLevel;
		newStore.setHLId(getHLId());
		newStore.setUnfCopy(getUnfCopy());
		return newStore;
	}

	@Override
	public Pair<BoolExpr, MapSSA> encodeDF(MapSSA map, Context ctx) {
		if(mainThread != null){
			Expr z3Expr = val.toZ3(map, ctx);
			Expr z3Loc = ssaLoc(loc, mainThread.getTId(), map.getFresh(loc), ctx);
			this.ssaLoc = z3Loc;
			return new Pair<>(ctx.mkImplies(executes(ctx), val.encodeAssignment(map, ctx, z3Loc, z3Expr)), map);
		}
		throw new RuntimeException("Main thread is not set for " + toString());
	}
}