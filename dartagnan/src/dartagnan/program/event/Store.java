package dartagnan.program.event;

import java.util.Collections;

import com.microsoft.z3.*;

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

	public Register getReg() {
		return reg;
	}

	public String toString() {
        return String.format("%s%s := %s", String.join("", Collections.nCopies(condLevel, "  ")), loc, val);
	}

	public ExprInterface getExpr(){
		return val;
	}
	
	public Store clone() {
        Location newLoc = loc.clone();
        ExprInterface newVal = val.clone();
		Store newStore = new Store(newLoc, newVal, atomic);
		newStore.condLevel = condLevel;
		newStore.setHLId(getHLId());
		newStore.setUnfCopy(getUnfCopy());
		return newStore;
	}

	public Pair<BoolExpr, MapSSA> encodeDF(MapSSA map, Context ctx) throws Z3Exception {
		if(mainThread == null){
			throw new RuntimeException("Main thread is not set in " + this);
		}

		Expr z3Expr = val.toZ3(map, ctx);
		Expr z3Loc = ssaLoc(loc, mainThread.getTId(), map.getFresh(loc), ctx);
		this.ssaLoc = z3Loc;
		return new Pair<>(ctx.mkImplies(executes(ctx), val.encodeAssignment(map, ctx, z3Loc, z3Expr)), map);
	}
}