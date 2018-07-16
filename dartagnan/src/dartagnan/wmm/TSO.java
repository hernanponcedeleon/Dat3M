package dartagnan.wmm;

import static dartagnan.wmm.Encodings.satAcyclic;
import static dartagnan.wmm.Encodings.satCycle;
import static dartagnan.wmm.Encodings.satCycleDef;
import static dartagnan.wmm.EncodingsCAT.*;

import java.util.Set;
import java.util.stream.Collectors;

import com.microsoft.z3.*;

import dartagnan.program.*;

public class TSO {

	public static final String[] fences = {"mfence"};
	
	public static BoolExpr encode(Program program, Context ctx) throws Z3Exception {
		Set<Event> events = program.getEvents().stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet());

		BoolExpr enc = Domain.encodeFences(program, ctx, fences);
		enc = ctx.mkAnd(enc, satUnion("co", "fr", events, ctx));
		enc = ctx.mkAnd(enc, satUnion("com", "(co+fr)", "rf", events, ctx));
		enc = ctx.mkAnd(enc, satUnion("poloc", "com", events, ctx));
	    enc = ctx.mkAnd(enc, satUnion("com-tso", "(co+fr)", "rfe", events, ctx));
		enc = ctx.mkAnd(enc, satMinus("po", "WR", events, ctx));
	    enc = ctx.mkAnd(enc, satUnion("po-tso", "(po\\WR)", "mfence", events, ctx));

	    if(program.hasRMWEvents()){
			enc = ctx.mkAnd(enc, Domain.encodeRMW(program, ctx));
			enc = ctx.mkAnd(enc, satComp("fre", "coe", events, ctx));
			enc = ctx.mkAnd(enc, satIntersection("rmw", "(fre;coe)", events, ctx));
			enc = ctx.mkAnd(enc, satUnion("MA", "AM", events, ctx));
			enc = ctx.mkAnd(enc, satIntersection("po", "WR", events, ctx));
			enc = ctx.mkAnd(enc, satIntersection("implied", "(po&WR)", "(MA+AM)", events, ctx));
			enc = ctx.mkAnd(enc, satUnion("po-tso", "com-tso", events, ctx));
			enc = ctx.mkAnd(enc, satUnion("ghb-tso", "(po-tso+com-tso)", "implied", events, ctx));
		} else {
			enc = ctx.mkAnd(enc, satUnion("ghb-tso", "po-tso", "com-tso", events, ctx));
		}

		return enc;
	}
	
	public static BoolExpr Consistent(Program program, Context ctx) throws Z3Exception {
		Set<Event> events = program.getEvents().stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet());
		BoolExpr enc = ctx.mkAnd(satAcyclic("(poloc+com)", events, ctx), satAcyclic("ghb-tso", events, ctx));
		if(program.hasRMWEvents()){
			Empty rmw = new Empty(new BasicRelation("(rmw&(fre;coe))"));
			enc = ctx.mkAnd(enc, rmw.Consistent(program.getEvents(), ctx));
		}
		return enc;
	}

	public static BoolExpr Inconsistent(Program program, Context ctx) throws Z3Exception {
		Set<Event> events = program.getEvents().stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet());
		BoolExpr enc = ctx.mkAnd(satCycleDef("(poloc+com)", events, ctx), satCycleDef("ghb-tso", events, ctx));
		enc = ctx.mkAnd(enc, ctx.mkOr(satCycle("(poloc+com)", events, ctx), satCycle("ghb-tso", events, ctx)));
		if(program.hasRMWEvents()){
			Empty rmw = new Empty(new BasicRelation("(rmw&(fre;coe))"));
			enc = ctx.mkAnd(enc, rmw.Inconsistent(program.getEvents(), ctx));
		}
		return enc;
	}
}