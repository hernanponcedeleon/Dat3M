package dartagnan.wmm.arch;

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
import dartagnan.program.event.Event;
import dartagnan.program.event.Local;
import dartagnan.program.event.MemEvent;
import dartagnan.wmm.Domain;
import dartagnan.wmm.EncodingsCAT;
import dartagnan.wmm.WmmInterface;

public class RMO implements WmmInterface {

	public final String[] fences = {"mfence", "isync"};
	
	public BoolExpr encode(Program program, Context ctx, boolean approx, boolean idl) throws Z3Exception {
		if(program.hasRMWEvents()){
			throw new RuntimeException("RMW is not implemented for RMO");
		}

		Set<Event> events = program.getEvents().stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet());
		Set<Event> eventsL = program.getEvents().stream().filter(e -> e instanceof MemEvent || e instanceof Local).collect(Collectors.toSet());

		BoolExpr enc = Domain.encodeFences(program, ctx, fences);
		enc = ctx.mkAnd(enc, EncodingsCAT.satUnion("co", "fr", events, ctx));
		enc = ctx.mkAnd(enc, satUnion("com", "(co+fr)", "rf", events, ctx));
		enc = ctx.mkAnd(enc, satMinus("po-loc", "RR", events, ctx));
		enc = ctx.mkAnd(enc, satUnion("(po-loc\\RR)", "com", events, ctx));
		enc = ctx.mkAnd(enc, satUnion("com-rmo", "(co+fr)", "rfe", events, ctx));
		enc = ctx.mkAnd(enc, satTransFixPoint("idd", eventsL, approx, ctx));
		enc = ctx.mkAnd(enc, satIntersection("data", "idd^+", "RW", eventsL, ctx));
		enc = ctx.mkAnd(enc, satIntersection("po-loc", "WR", events, ctx));
		enc = ctx.mkAnd(enc, satUnion("data", "(po-loc&WR)", events, ctx));
		enc = ctx.mkAnd(enc, satTransFixPoint("(data+(po-loc&WR))", events, approx, ctx));
		enc = ctx.mkAnd(enc, satIntersection("(data+(po-loc&WR))^+", "RM", events, ctx));
		enc = ctx.mkAnd(enc, satIntersection("ctrl", "RW", events, ctx));
		enc = ctx.mkAnd(enc, satUnion("(ctrl&RW)", "ctrlisync", events, ctx));
		enc = ctx.mkAnd(enc, satUnion("dp-rmo", "((ctrl&RW)+ctrlisync)", "((data+(po-loc&WR))^+&RM)", events, ctx));
		enc = ctx.mkAnd(enc, satUnion("po-rmo", "dp-rmo", "mfence", events, ctx));
		enc = ctx.mkAnd(enc, satUnion("ghb-rmo", "po-rmo", "com-rmo", events, ctx));
		return enc;
	}
	
	public BoolExpr Consistent(Program program, Context ctx) throws Z3Exception {
		Set<Event> events = program.getEvents().stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet());
		return ctx.mkAnd(satAcyclic("((po-loc\\RR)+com)", events, ctx), satAcyclic("ghb-rmo", events, ctx));
	}
	
	public BoolExpr Inconsistent(Program program, Context ctx) throws Z3Exception {
		Set<Event> events = program.getEvents().stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet());
		BoolExpr enc = ctx.mkAnd(satCycleDef("((po-loc\\RR)+com)", events, ctx), satCycleDef("ghb-rmo", events, ctx));
		enc = ctx.mkAnd(enc, ctx.mkOr(satCycle("((po-loc\\RR)+com)", events, ctx), satCycle("ghb-rmo", events, ctx)));
		return enc;
	}
}