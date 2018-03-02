package dartagnan.wmm;

import java.util.Set;
import java.util.stream.Collectors;

import com.microsoft.z3.*;

import dartagnan.program.*;

public class Alpha {
	
	public static BoolExpr encode(Program program, Context ctx) throws Z3Exception {
		Set<Event> events = program.getEvents().stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet());
		Set<Event> eventsL = program.getEvents().stream().filter(e -> e instanceof MemEvent || e instanceof Local).collect(Collectors.toSet());
		
	    BoolExpr enc = EncodingsCAT.satUnion("co", "fr", events, ctx);
	    enc = ctx.mkAnd(enc, EncodingsCAT.satUnion("com", "(co+fr)", "rf", events, ctx));
	    enc = ctx.mkAnd(enc, EncodingsCAT.satUnion("poloc", "com", events, ctx));
	    enc = ctx.mkAnd(enc, EncodingsCAT.satUnion("com-alpha", "(co+fr)", "rfe", events, ctx));
	    enc = ctx.mkAnd(enc, EncodingsCAT.satTransFixPoint("idd", eventsL, ctx));
	    enc = ctx.mkAnd(enc, EncodingsCAT.satIntersection("data", "idd^+", "RW", eventsL, ctx));
	    enc = ctx.mkAnd(enc, EncodingsCAT.satIntersection("poloc", "WR", events, ctx));
	    enc = ctx.mkAnd(enc, EncodingsCAT.satUnion("data", "(poloc&WR)", events, ctx));
	    enc = ctx.mkAnd(enc, EncodingsCAT.satTransFixPoint("(data+(poloc&WR))", events, ctx));
	    enc = ctx.mkAnd(enc, EncodingsCAT.satIntersection("(data+(poloc&WR))^+", "RM", events, ctx));
	    enc = ctx.mkAnd(enc, EncodingsCAT.satIntersection("ctrl", "RW", events, ctx));
	    enc = ctx.mkAnd(enc, EncodingsCAT.satUnion("(ctrl&RW)", "ctrlisync", events, ctx));
	    enc = ctx.mkAnd(enc, EncodingsCAT.satUnion("dp-alpha", "((ctrl&RW)+ctrlisync)", "((data+(poloc&WR))^+&RM)", events, ctx));
	    enc = ctx.mkAnd(enc, EncodingsCAT.satUnion("dp-alpha", "rf", events, ctx));
	    enc = ctx.mkAnd(enc, EncodingsCAT.satUnion("WW", "RM", events, ctx));
	    enc = ctx.mkAnd(enc, EncodingsCAT.satIntersection("(WW+RM)", "loc", events, ctx));
	    enc = ctx.mkAnd(enc, EncodingsCAT.satIntersection("po", "((WW+RM)&loc)", events, ctx));
	    enc = ctx.mkAnd(enc, EncodingsCAT.satUnion("po-alpha", "(po&((WW+RM)&loc))", "mfence", events, ctx));
	    enc = ctx.mkAnd(enc, EncodingsCAT.satUnion("ghb-alpha", "po-alpha", "com-alpha", events, ctx));
	    return enc;
	}

	public static BoolExpr Consistent(Program program, Context ctx) throws Z3Exception {
		Set<Event> events = program.getEvents().stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet());
		return ctx.mkAnd(EncodingsCAT.satAcyclic("(poloc+com)", events, ctx), EncodingsCAT.satAcyclic("(dp-alpha+rf)", events, ctx), EncodingsCAT.satAcyclic("ghb-alpha", events, ctx));
	}
	
	public static BoolExpr Inconsistent(Program program, Context ctx) throws Z3Exception {
		Set<Event> events = program.getEvents().stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet());
		BoolExpr enc = ctx.mkAnd(EncodingsCAT.satCycleDef("(poloc+com)", events, ctx), EncodingsCAT.satCycleDef("(dp-alpha+rf)", events, ctx), EncodingsCAT.satCycleDef("ghb-alpha", events, ctx));
		enc = ctx.mkAnd(enc, ctx.mkOr(EncodingsCAT.satCycle("(poloc+com)", events, ctx), EncodingsCAT.satCycle("(dp-alpha+rf)", events, ctx), EncodingsCAT.satCycle("ghb-alpha", events, ctx)));
		return enc;
	}

	
}