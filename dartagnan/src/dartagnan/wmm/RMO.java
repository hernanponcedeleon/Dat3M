package dartagnan.wmm;

import java.util.Set;
import java.util.stream.Collectors;

import com.microsoft.z3.*;

import dartagnan.program.*;

public class RMO {
	
	public static BoolExpr encode(Program program, Context ctx) throws Z3Exception {
		Set<Event> events = program.getEvents().stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet());
		Set<Event> eventsL = program.getEvents().stream().filter(e -> e instanceof MemEvent || e instanceof Local).collect(Collectors.toSet());
		
		BoolExpr enc = Encodings.satUnion("co", "fr", events, ctx);
		enc = ctx.mkAnd(enc, Encodings.satUnion("com", "(co+fr)", "rf", events, ctx));
		enc = ctx.mkAnd(enc, Encodings.satMinus("poloc", "RR", events, ctx));
		enc = ctx.mkAnd(enc, Encodings.satUnion("(poloc\\RR)", "com", events, ctx));
		enc = ctx.mkAnd(enc, Encodings.satUnion("com-rmo", "(co+fr)", "rfe", events, ctx));
		enc = ctx.mkAnd(enc, Encodings.satTransIDL("idd", eventsL, ctx));
		enc = ctx.mkAnd(enc, Encodings.satIntersection("data", "idd^+", "RW", eventsL, ctx));
		enc = ctx.mkAnd(enc, Encodings.satIntersection("poloc", "WR", events, ctx));
		enc = ctx.mkAnd(enc, Encodings.satUnion("data", "(poloc&WR)", events, ctx));
		enc = ctx.mkAnd(enc, Encodings.satTransIDL("(data+(poloc&WR))", events, ctx));
		enc = ctx.mkAnd(enc, Encodings.satIntersection("(data+(poloc&WR))^+", "RM", events, ctx));
		enc = ctx.mkAnd(enc, Encodings.satIntersection("ctrl", "RW", events, ctx));
		enc = ctx.mkAnd(enc, Encodings.satUnion("(ctrl&RW)", "ctrlisync", events, ctx));
		enc = ctx.mkAnd(enc, Encodings.satUnion("dp-rmo", "((ctrl&RW)+ctrlisync)", "((data+(poloc&WR))^+&RM)", events, ctx));
		enc = ctx.mkAnd(enc, Encodings.satUnion("fence-rmo", "sync", "mfence", events, ctx));
		enc = ctx.mkAnd(enc, Encodings.satUnion("po-rmo", "dp-rmo", "fence-rmo", events, ctx));
		enc = ctx.mkAnd(enc, Encodings.satUnion("ghb-rmo", "po-rmo", "com-rmo", events, ctx));
		return enc;
	}
	
	public static BoolExpr Consistent(Program program, Context ctx) throws Z3Exception {
		Set<Event> events = program.getEvents().stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet());
		return ctx.mkAnd(Encodings.satAcyclic("((poloc\\RR)+com)", events, ctx), Encodings.satAcyclic("ghb-rmo", events, ctx));
	}
	
	public static BoolExpr Inconsistent(Program program, Context ctx) throws Z3Exception {
		Set<Event> events = program.getEvents().stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet());
		BoolExpr enc = ctx.mkAnd(Encodings.satCycleDef("((poloc\\RR)+com)", events, ctx), Encodings.satCycleDef("ghb-rmo", events, ctx));
		enc = ctx.mkAnd(enc, ctx.mkOr(Encodings.satCycle("((poloc\\RR)+com)", events, ctx), Encodings.satCycle("ghb-rmo", events, ctx)));
		return enc;
	}
}