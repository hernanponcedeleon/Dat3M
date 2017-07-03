package dartagnan.expression;

import java.util.HashMap;
import java.util.Map;

import com.microsoft.z3.*;

import dartagnan.program.Location;
import dartagnan.program.Register;
import dartagnan.utils.MapSSA;

public class Assert {

	Map<Register, Integer> regValue = new HashMap<Register, Integer>();
	Map<Location, Integer> locValue = new HashMap<Location, Integer>();
	String type;
	public boolean existsQuery;
	
	public Assert(String type) {
		this.type = type;
		this.existsQuery = true;
	}
	
	public void addPair(Register reg, Integer value) {
		regValue.put(reg, value);
	}
	
	public void addPair(Location loc, Integer value) {
		locValue.put(loc, value);
	}
	
	public BoolExpr encode(Context ctx, MapSSA lastMap) throws Z3Exception {
		BoolExpr enc = ctx.mkTrue();
		for(Register reg: regValue.keySet()) {
			enc = ctx.mkAnd(enc, ctx.mkEq(ctx.mkIntConst(String.format("T%s_%s_%s", reg.getMainThread(), reg.getName(), lastMap.get(reg))), ctx.mkInt(regValue.get(reg))));
		}
		for(Location loc: locValue.keySet()) {
			enc = ctx.mkAnd(enc, ctx.mkEq(ctx.mkIntConst(loc.getName() + "_final"), ctx.mkInt(locValue.get(loc))));
		}
		return enc;
	}
	
	public String toString() {
		return regValue.toString() + locValue.toString();
	}
}
