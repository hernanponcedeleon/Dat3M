package dartagnan.wmm.arch;

import static dartagnan.wmm.Encodings.satAcyclic;
import static dartagnan.wmm.Encodings.satCycle;
import static dartagnan.wmm.Encodings.satCycleDef;

import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;
import java.util.stream.Collectors;

import com.microsoft.z3.*;

import dartagnan.program.*;
import dartagnan.program.event.Event;
import dartagnan.program.event.Local;
import dartagnan.program.event.MemEvent;
import dartagnan.program.event.filter.FilterBasic;
import dartagnan.wmm.relation.RelCartesian;
import dartagnan.wmm.EncodingsCAT;
import dartagnan.wmm.WmmInterface;
import dartagnan.wmm.relation.RelFencerel;

public class Alpha implements WmmInterface {

	private Set<RelFencerel> fenceRelations = new HashSet<RelFencerel>(Arrays.asList(
			new RelFencerel("Mfence", "mfence"),
			new RelFencerel("Isync", "isync")
	));

	private Set<RelCartesian> cartesianRelations = new HashSet<>(Arrays.asList(
			new RelCartesian(new FilterBasic("R"), new FilterBasic("W"), "RW"),
			new RelCartesian(new FilterBasic("W"), new FilterBasic("R"), "WR"),
			new RelCartesian(new FilterBasic("R"), new FilterBasic("M"), "RM"),
			new RelCartesian(new FilterBasic("W"), new FilterBasic("W"), "WW")
	));
	
	public BoolExpr encode(Program program, Context ctx, boolean approx, boolean idl) throws Z3Exception {
		if(program.hasRMWEvents()){
			throw new RuntimeException("RMW is not implemented for Alpha");
		}

		Set<Event> events = program.getEvents().stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet());
		Set<Event> eventsL = program.getEvents().stream().filter(e -> e instanceof MemEvent || e instanceof Local).collect(Collectors.toSet());

		BoolExpr enc = RelFencerel.encodeBatch(program, ctx, fenceRelations);
		enc = ctx.mkAnd(enc, EncodingsCAT.satUnion("co", "fr", events, ctx));
	    enc = ctx.mkAnd(enc, EncodingsCAT.satUnion("com", "(co+fr)", "rf", events, ctx));
	    enc = ctx.mkAnd(enc, EncodingsCAT.satUnion("po-loc", "com", events, ctx));
	    enc = ctx.mkAnd(enc, EncodingsCAT.satUnion("com-alpha", "(co+fr)", "rfe", events, ctx));
	    enc = ctx.mkAnd(enc, EncodingsCAT.satTransFixPoint("idd", eventsL, approx, ctx));
	    enc = ctx.mkAnd(enc, EncodingsCAT.satIntersection("data", "idd^+", "RW", eventsL, ctx));
	    enc = ctx.mkAnd(enc, EncodingsCAT.satIntersection("po-loc", "WR", events, ctx));
	    enc = ctx.mkAnd(enc, EncodingsCAT.satUnion("data", "(po-loc&WR)", events, ctx));
	    enc = ctx.mkAnd(enc, EncodingsCAT.satTransFixPoint("(data+(po-loc&WR))", events, approx, ctx));
	    enc = ctx.mkAnd(enc, EncodingsCAT.satIntersection("(data+(po-loc&WR))^+", "RM", events, ctx));
	    enc = ctx.mkAnd(enc, EncodingsCAT.satIntersection("ctrl", "RW", events, ctx));
	    enc = ctx.mkAnd(enc, EncodingsCAT.satUnion("(ctrl&RW)", "ctrlisync", events, ctx));
	    enc = ctx.mkAnd(enc, EncodingsCAT.satUnion("dp-alpha", "((ctrl&RW)+ctrlisync)", "((data+(po-loc&WR))^+&RM)", events, ctx));
	    enc = ctx.mkAnd(enc, EncodingsCAT.satUnion("dp-alpha", "rf", events, ctx));
	    enc = ctx.mkAnd(enc, EncodingsCAT.satUnion("WW", "RM", events, ctx));
	    enc = ctx.mkAnd(enc, EncodingsCAT.satIntersection("(WW+RM)", "loc", events, ctx));
	    enc = ctx.mkAnd(enc, EncodingsCAT.satIntersection("po", "((WW+RM)&loc)", events, ctx));
	    enc = ctx.mkAnd(enc, EncodingsCAT.satUnion("po-alpha", "(po&((WW+RM)&loc))", "mfence", events, ctx));
	    enc = ctx.mkAnd(enc, EncodingsCAT.satUnion("ghb-alpha", "po-alpha", "com-alpha", events, ctx));

		for(RelCartesian relation : cartesianRelations){
			enc = ctx.mkAnd(enc, relation.encode(events, ctx));
		}

	    return enc;
	}

	public BoolExpr Consistent(Program program, Context ctx) throws Z3Exception {
		Set<Event> events = program.getEvents().stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet());
		return ctx.mkAnd(satAcyclic("(po-loc+com)", events, ctx), satAcyclic("(dp-alpha+rf)", events, ctx), satAcyclic("ghb-alpha", events, ctx));
	}
	
	public BoolExpr Inconsistent(Program program, Context ctx) throws Z3Exception {
		Set<Event> events = program.getEvents().stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet());
		BoolExpr enc = ctx.mkAnd(satCycleDef("(po-loc+com)", events, ctx), satCycleDef("(dp-alpha+rf)", events, ctx), satCycleDef("ghb-alpha", events, ctx));
		enc = ctx.mkAnd(enc, ctx.mkOr(satCycle("(po-loc+com)", events, ctx), satCycle("(dp-alpha+rf)", events, ctx), satCycle("ghb-alpha", events, ctx)));
		return enc;
	}

	
}