package dartagnan.wmm;

import static dartagnan.wmm.Encodings.satAcyclic;
import static dartagnan.wmm.Encodings.satCycle;
import static dartagnan.wmm.Encodings.satCycleDef;
import static dartagnan.wmm.EncodingsCAT.satIntersection;
import static dartagnan.wmm.EncodingsCAT.satMinus;
import static dartagnan.wmm.EncodingsCAT.satTransFixPoint;
import static dartagnan.wmm.EncodingsCAT.satUnion;

import java.util.Set;
import java.util.stream.Collectors;

import com.microsoft.z3.*;

import dartagnan.program.*;

public class RMO {

	public static final String[] fences = {"mfence", "sync", "isync"};
	
	public static BoolExpr encode(Program program, boolean approx, Context ctx) throws Z3Exception {
		if(program.hasRMWEvents()){
			throw new RuntimeException("RMW is not implemented for RMO");
		}

		Set<Event> events = program.getEvents().stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet());
		Set<Event> eventsL = program.getEvents().stream().filter(e -> e instanceof MemEvent || e instanceof Local).collect(Collectors.toSet());

		BoolExpr enc = Domain.encodeFences(program, ctx, fences);
		enc = ctx.mkAnd(enc, EncodingsCAT.satUnion("co", "fr", events, ctx));
		enc = ctx.mkAnd(enc, satUnion("com", "(co+fr)", "rf", events, ctx));
		enc = ctx.mkAnd(enc, satMinus("poloc", "RR", events, ctx));
		enc = ctx.mkAnd(enc, satUnion("(poloc\\RR)", "com", events, ctx));
		enc = ctx.mkAnd(enc, satUnion("com-rmo", "(co+fr)", "rfe", events, ctx));
		enc = ctx.mkAnd(enc, satTransFixPoint("idd", eventsL, approx, ctx));
		enc = ctx.mkAnd(enc, satIntersection("data", "idd^+", "RW", eventsL, ctx));
		enc = ctx.mkAnd(enc, satIntersection("poloc", "WR", events, ctx));
		enc = ctx.mkAnd(enc, satUnion("data", "(poloc&WR)", events, ctx));
		enc = ctx.mkAnd(enc, satTransFixPoint("(data+(poloc&WR))", events, approx, ctx));
		enc = ctx.mkAnd(enc, satIntersection("(data+(poloc&WR))^+", "RM", events, ctx));
		enc = ctx.mkAnd(enc, satIntersection("ctrl", "RW", events, ctx));
		enc = ctx.mkAnd(enc, satUnion("(ctrl&RW)", "ctrlisync", events, ctx));
		enc = ctx.mkAnd(enc, satUnion("dp-rmo", "((ctrl&RW)+ctrlisync)", "((data+(poloc&WR))^+&RM)", events, ctx));
		enc = ctx.mkAnd(enc, satUnion("fence-rmo", "sync", "mfence", events, ctx));
		enc = ctx.mkAnd(enc, satUnion("po-rmo", "dp-rmo", "fence-rmo", events, ctx));
		enc = ctx.mkAnd(enc, satUnion("ghb-rmo", "po-rmo", "com-rmo", events, ctx));
		return enc;
	}
	
	public static BoolExpr Consistent(Program program, Context ctx) throws Z3Exception {
		Set<Event> events = program.getEvents().stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet());
		return ctx.mkAnd(satAcyclic("((poloc\\RR)+com)", events, ctx), satAcyclic("ghb-rmo", events, ctx));
	}
	
	public static BoolExpr Inconsistent(Program program, Context ctx) throws Z3Exception {
		Set<Event> events = program.getEvents().stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet());
		BoolExpr enc = ctx.mkAnd(satCycleDef("((poloc\\RR)+com)", events, ctx), satCycleDef("ghb-rmo", events, ctx));
		enc = ctx.mkAnd(enc, ctx.mkOr(satCycle("((poloc\\RR)+com)", events, ctx), satCycle("ghb-rmo", events, ctx)));
		return enc;
	}
}