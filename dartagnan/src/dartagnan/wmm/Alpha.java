package dartagnan.wmm;

import java.util.Set;
import java.util.stream.Collectors;

import com.microsoft.z3.*;

import dartagnan.program.*;

public class Alpha {
	
	public static BoolExpr encode(Program program, Context ctx) throws Z3Exception {
		Set<Event> events = program.getEvents().stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet());
		Set<Event> eventsL = program.getEvents().stream().filter(e -> e instanceof MemEvent || e instanceof Local).collect(Collectors.toSet());
		
	    BoolExpr enc = Encodings.satUnion("co", "fr", events, ctx);
	    enc = ctx.mkAnd(enc, Encodings.satUnion("com", "(co+fr)", "rf", events, ctx));
	    enc = ctx.mkAnd(enc, Encodings.satUnion("poloc", "com", events, ctx));
	    enc = ctx.mkAnd(enc, Encodings.satUnion("com-alpha", "(co+fr)", "rfe", events, ctx));
	    enc = ctx.mkAnd(enc, Encodings.satTransFixPoint("idd", eventsL, ctx));
	    enc = ctx.mkAnd(enc, Encodings.satIntersection("data", "idd^+", "RW", eventsL, ctx));
	    enc = ctx.mkAnd(enc, Encodings.satIntersection("poloc", "WR", events, ctx));
	    enc = ctx.mkAnd(enc, Encodings.satUnion("data", "(poloc&WR)", events, ctx));
	    enc = ctx.mkAnd(enc, Encodings.satTransFixPoint("(data+(poloc&WR))", events, ctx));
	    enc = ctx.mkAnd(enc, Encodings.satIntersection("(data+(poloc&WR))^+", "RM", events, ctx));
	    enc = ctx.mkAnd(enc, Encodings.satIntersection("ctrl", "RW", events, ctx));
	    enc = ctx.mkAnd(enc, Encodings.satUnion("(ctrl&RW)", "ctrlisync", events, ctx));
	    enc = ctx.mkAnd(enc, Encodings.satUnion("dp-alpha", "((ctrl&RW)+ctrlisync)", "((data+(poloc&WR))^+&RM)", events, ctx));
	    enc = ctx.mkAnd(enc, Encodings.satUnion("dp-alpha", "rf", events, ctx));
	    enc = ctx.mkAnd(enc, Encodings.satUnion("WW", "RM", events, ctx));
	    enc = ctx.mkAnd(enc, Encodings.satIntersection("(WW+RM)", "loc", events, ctx));
	    enc = ctx.mkAnd(enc, Encodings.satIntersection("po", "((WW+RM)&loc)", events, ctx));
	    enc = ctx.mkAnd(enc, Encodings.satUnion("po-alpha", "(po&((WW+RM)&loc))", "mfence", events, ctx));
	    enc = ctx.mkAnd(enc, Encodings.satUnion("ghb-alpha", "po-alpha", "com-alpha", events, ctx));
	    return enc;
	}

	public static BoolExpr Consistent(Program program, Context ctx) throws Z3Exception {
		Set<Event> events = program.getEvents().stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet());
		return ctx.mkAnd(Encodings.satAcyclic("(poloc+com)", events, ctx), Encodings.satAcyclic("(dp-alpha+rf)", events, ctx), Encodings.satAcyclic("ghb-alpha", events, ctx));
	}
	
	public static BoolExpr Inconsistent(Program program, Context ctx) throws Z3Exception {
		Set<Event> events = program.getEvents().stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet());
		BoolExpr enc = ctx.mkAnd(Encodings.satCycleDef("(poloc+com)", events, ctx), Encodings.satCycleDef("(dp-alpha+rf)", events, ctx), Encodings.satCycleDef("ghb-alpha", events, ctx));
		enc = ctx.mkAnd(enc, ctx.mkOr(Encodings.satCycle("(poloc+com)", events, ctx), Encodings.satCycle("(dp-alpha+rf)", events, ctx), Encodings.satCycle("ghb-alpha", events, ctx)));
		return enc;
	}

	
}