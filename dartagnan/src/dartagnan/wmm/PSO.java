package dartagnan.wmm;

import java.util.Set;
import java.util.stream.Collectors;

import com.microsoft.z3.*;

import dartagnan.program.*;

public class PSO {
	
	public static BoolExpr encode(Program program, Context ctx) throws Z3Exception {
		Set<Event> events = program.getEvents().stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet());
		
	    BoolExpr enc = EncodingsCAT.satUnion("co", "fr", events, ctx);
	    enc = ctx.mkAnd(enc, EncodingsCAT.satUnion("com", "(co+fr)", "rf", events, ctx));
	    enc = ctx.mkAnd(enc, EncodingsCAT.satUnion("poloc", "com", events, ctx));
	    enc = ctx.mkAnd(enc, EncodingsCAT.satUnion("com-pso", "(co+fr)", "rfe", events, ctx));
	    enc = ctx.mkAnd(enc, EncodingsCAT.satIntersection("po", "RM", events, ctx));
	    enc = ctx.mkAnd(enc, EncodingsCAT.satUnion("po-pso", "(po&RM)", "mfence", events, ctx));
	    enc = ctx.mkAnd(enc, EncodingsCAT.satUnion("ghb-pso", "po-pso", "com-pso", events, ctx));
		return enc;
	}
	
	public static BoolExpr Consistent(Program program, Context ctx) throws Z3Exception {
		Set<Event> events = program.getEvents().stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet());
		return ctx.mkAnd(EncodingsCAT.satAcyclic("(poloc+com)", events, ctx), EncodingsCAT.satAcyclic("ghb-pso", events, ctx));
	}
	
	public static BoolExpr Inconsistent(Program program, Context ctx) throws Z3Exception {
		Set<Event> events = program.getEvents().stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet());
		BoolExpr enc = ctx.mkAnd(EncodingsCAT.satCycleDef("(poloc+com)", events, ctx), EncodingsCAT.satCycleDef("ghb-pso", events, ctx));
		enc = ctx.mkAnd(enc, ctx.mkOr(EncodingsCAT.satCycle("(poloc+com)", events, ctx), EncodingsCAT.satCycle("ghb-pso", events, ctx)));
		return enc;
	}
}