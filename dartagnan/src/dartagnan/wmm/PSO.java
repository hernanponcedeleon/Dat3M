package dartagnan.wmm;

import java.util.Set;
import java.util.stream.Collectors;

import com.microsoft.z3.*;

import dartagnan.program.*;

public class PSO {
	
	public static BoolExpr encode(Program program, Context ctx) throws Z3Exception {
		Set<Event> events = program.getEvents().stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet());
		
	    BoolExpr enc = Encodings.satUnion("co", "fr", events, ctx);
	    enc = ctx.mkAnd(enc, Encodings.satUnion("com", "(co+fr)", "rf", events, ctx));
	    enc = ctx.mkAnd(enc, Encodings.satUnion("poloc", "com", events, ctx));
	    enc = ctx.mkAnd(enc, Encodings.satUnion("com-pso", "(co+fr)", "rfe", events, ctx));
	    enc = ctx.mkAnd(enc, Encodings.satIntersection("po", "RM", events, ctx));
	    enc = ctx.mkAnd(enc, Encodings.satUnion("fence-pso", "sync", "mfence", events, ctx));
	    enc = ctx.mkAnd(enc, Encodings.satUnion("po-pso", "(po&RM)", "fence-pso", events, ctx));
	    enc = ctx.mkAnd(enc, Encodings.satUnion("ghb-pso", "po-pso", "com-pso", events, ctx));
		return enc;
	}
	
	public static BoolExpr Consistent(Program program, Context ctx) throws Z3Exception {
		Set<Event> events = program.getEvents().stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet());
		return ctx.mkAnd(Encodings.satAcyclic("(poloc+com)", events, ctx), Encodings.satAcyclic("ghb-pso", events, ctx));
	}
	
	public static BoolExpr Inconsistent(Program program, Context ctx) throws Z3Exception {
		Set<Event> events = program.getEvents().stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet());
		BoolExpr enc = ctx.mkAnd(Encodings.satCycleDef("(poloc+com)", events, ctx), Encodings.satCycleDef("ghb-pso", events, ctx));
		enc = ctx.mkAnd(enc, ctx.mkOr(Encodings.satCycle("(poloc+com)", events, ctx), Encodings.satCycle("ghb-pso", events, ctx)));
		return enc;
	}
}