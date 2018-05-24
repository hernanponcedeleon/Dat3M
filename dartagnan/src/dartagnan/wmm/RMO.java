package dartagnan.wmm;

import java.util.Set;
import java.util.stream.Collectors;

import com.microsoft.z3.*;

import dartagnan.program.*;

public class RMO {
	
	public static BoolExpr encode(Program program, boolean approx, Context ctx) throws Z3Exception {
		Set<Event> events = program.getEvents().stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet());
		Set<Event> eventsL = program.getEvents().stream().filter(e -> e instanceof MemEvent || e instanceof Local).collect(Collectors.toSet());
		
		BoolExpr enc = EncodingsCAT.satUnion("co", "fr", events, ctx);
		enc = ctx.mkAnd(enc, EncodingsCAT.satUnion("com", "(co+fr)", "rf", events, ctx));
		enc = ctx.mkAnd(enc, EncodingsCAT.satMinus("poloc", "RR", events, ctx));
		enc = ctx.mkAnd(enc, EncodingsCAT.satUnion("(poloc\\RR)", "com", events, ctx));
		enc = ctx.mkAnd(enc, EncodingsCAT.satUnion("com-rmo", "(co+fr)", "rfe", events, ctx));
		enc = ctx.mkAnd(enc, EncodingsCAT.satTransFixPoint("idd", eventsL, approx, ctx));
		enc = ctx.mkAnd(enc, EncodingsCAT.satIntersection("data", "idd^+", "RW", eventsL, ctx));
		enc = ctx.mkAnd(enc, EncodingsCAT.satIntersection("poloc", "WR", events, ctx));
		enc = ctx.mkAnd(enc, EncodingsCAT.satUnion("data", "(poloc&WR)", events, ctx));
		enc = ctx.mkAnd(enc, EncodingsCAT.satTransFixPoint("(data+(poloc&WR))", events, approx, ctx));
		enc = ctx.mkAnd(enc, EncodingsCAT.satIntersection("(data+(poloc&WR))^+", "RM", events, ctx));
		enc = ctx.mkAnd(enc, EncodingsCAT.satIntersection("ctrl", "RW", events, ctx));
		enc = ctx.mkAnd(enc, EncodingsCAT.satUnion("(ctrl&RW)", "ctrlisync", events, ctx));
		enc = ctx.mkAnd(enc, EncodingsCAT.satUnion("dp-rmo", "((ctrl&RW)+ctrlisync)", "((data+(poloc&WR))^+&RM)", events, ctx));
		enc = ctx.mkAnd(enc, EncodingsCAT.satUnion("fence-rmo", "sync", "mfence", events, ctx));
		enc = ctx.mkAnd(enc, EncodingsCAT.satUnion("po-rmo", "dp-rmo", "fence-rmo", events, ctx));
		enc = ctx.mkAnd(enc, EncodingsCAT.satUnion("ghb-rmo", "po-rmo", "com-rmo", events, ctx));
		return enc;
	}
	
	public static BoolExpr Consistent(Program program, Context ctx) throws Z3Exception {
		Set<Event> events = program.getEvents().stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet());
		return ctx.mkAnd(EncodingsCAT.satAcyclic("((poloc\\RR)+com)", events, ctx), EncodingsCAT.satAcyclic("ghb-rmo", events, ctx));
	}
	
	public static BoolExpr Inconsistent(Program program, Context ctx) throws Z3Exception {
		Set<Event> events = program.getEvents().stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet());
		BoolExpr enc = ctx.mkAnd(EncodingsCAT.satCycleDef("((poloc\\RR)+com)", events, ctx), EncodingsCAT.satCycleDef("ghb-rmo", events, ctx));
		enc = ctx.mkAnd(enc, ctx.mkOr(EncodingsCAT.satCycle("((poloc\\RR)+com)", events, ctx), EncodingsCAT.satCycle("ghb-rmo", events, ctx)));
		return enc;
	}
}