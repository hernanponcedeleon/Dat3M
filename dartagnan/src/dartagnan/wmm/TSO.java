package dartagnan.wmm;

import static dartagnan.wmm.EncodingsCAT.satUnion;
import static dartagnan.wmm.EncodingsCAT.satMinus;
import static dartagnan.wmm.EncodingsCAT.satAcyclic;
import static dartagnan.wmm.EncodingsCAT.satCycle;
import static dartagnan.wmm.EncodingsCAT.satCycleDef;

import java.util.Set;
import java.util.stream.Collectors;

import com.microsoft.z3.*;

import dartagnan.program.*;

public class TSO {
	
	public static BoolExpr encode(Program program, Context ctx) throws Z3Exception {
		Set<Event> events = program.getEvents().stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet());
		BoolExpr enc = satUnion("co", "fr", events, ctx);
		enc = ctx.mkAnd(enc, satUnion("com", "(co+fr)", "rf", events, ctx));
		enc = ctx.mkAnd(enc, satUnion("poloc", "com", events, ctx));
	    enc = ctx.mkAnd(enc, satUnion("com-tso", "(co+fr)", "rfe", events, ctx));
		enc = ctx.mkAnd(enc, satMinus("po", "WR", events, ctx));
	    enc = ctx.mkAnd(enc, satUnion("po-tso", "(po\\WR)", "mfence", events, ctx));
		enc = ctx.mkAnd(enc, satUnion("ghb-tso", "po-tso", "com-tso", events, ctx));
		return enc;
	}
	
	public static BoolExpr Consistent(Program program, Context ctx) throws Z3Exception {
		Set<Event> events = program.getEvents().stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet());
		return ctx.mkAnd(satAcyclic("(poloc+com)", events, ctx), satAcyclic("ghb-tso", events, ctx));
	}
	
	public static BoolExpr Inconsistent(Program program, Context ctx) throws Z3Exception {
		Set<Event> events = program.getEvents().stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet());
		BoolExpr enc = ctx.mkAnd(satCycleDef("(poloc+com)", events, ctx), satCycleDef("ghb-tso", events, ctx));
		enc = ctx.mkAnd(enc, ctx.mkOr(satCycle("(poloc+com)", events, ctx), satCycle("ghb-tso", events, ctx)));
		return enc;
	}
}