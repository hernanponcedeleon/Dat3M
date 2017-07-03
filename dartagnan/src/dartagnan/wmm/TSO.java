package dartagnan.wmm;

import java.util.Set;
import java.util.stream.Collectors;

import com.microsoft.z3.*;

import dartagnan.program.*;

public class TSO {
	
	public static BoolExpr encode(Program program, Context ctx) throws Z3Exception {
		Set<Event> events = program.getEvents().stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet());
		BoolExpr enc = Encodings.satUnion("co", "fr", events, ctx);
		enc = ctx.mkAnd(enc, Encodings.satUnion("com", "(co+fr)", "rf", events, ctx));
		enc = ctx.mkAnd(enc, Encodings.satUnion("poloc", "com", events, ctx));
	    enc = ctx.mkAnd(enc, Encodings.satUnion("com-tso", "(co+fr)", "rfe", events, ctx));
		enc = ctx.mkAnd(enc, Encodings.satMinus("po", "WR", events, ctx));
		enc = ctx.mkAnd(enc, Encodings.satUnion("fence-tso", "sync", "mfence", events, ctx));
	    enc = ctx.mkAnd(enc, Encodings.satUnion("po-tso", "(po\\WR)", "fence-tso", events, ctx));
		enc = ctx.mkAnd(enc, Encodings.satUnion("ghb-tso", "po-tso", "com-tso", events, ctx));
		return enc;
	}
	
	public static BoolExpr Consistent(Program program, Context ctx) throws Z3Exception {
		Set<Event> events = program.getEvents().stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet());
		return ctx.mkAnd(Encodings.satAcyclic("(poloc+com)", events, ctx), Encodings.satAcyclic("ghb-tso", events, ctx));
	}
	
	public static BoolExpr Inconsistent(Program program, Context ctx) throws Z3Exception {
		Set<Event> events = program.getEvents().stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet());
		BoolExpr enc = ctx.mkAnd(Encodings.satCycleDef("(poloc+com)", events, ctx), Encodings.satCycleDef("ghb-tso", events, ctx));
		enc = ctx.mkAnd(enc, ctx.mkOr(Encodings.satCycle("(poloc+com)", events, ctx), Encodings.satCycle("ghb-tso", events, ctx)));
		return enc;
	}
}