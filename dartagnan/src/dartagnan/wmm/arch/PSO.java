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
import dartagnan.program.event.MemEvent;
import dartagnan.program.event.filter.FilterBasic;
import dartagnan.wmm.relation.RelCartesian;
import dartagnan.wmm.EncodingsCAT;
import dartagnan.wmm.WmmInterface;
import dartagnan.wmm.relation.RelFencerel;

public class PSO implements WmmInterface {

	private Set<RelFencerel> fenceRelations = new HashSet<RelFencerel>(Arrays.asList(
			new RelFencerel("Mfence", "mfence")
	));

	private Set<RelCartesian> cartesianRelations = new HashSet<>(Arrays.asList(
			new RelCartesian(new FilterBasic("R"), new FilterBasic("M"), "RM")
	));
	
	public BoolExpr encode(Program program, Context ctx, boolean approx, boolean idl) throws Z3Exception {
		if(program.hasRMWEvents()){
			throw new RuntimeException("RMW is not implemented for PSO");
		}

		Set<Event> events = program.getEvents().stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet());

		BoolExpr enc = RelFencerel.encodeBatch(program, ctx, fenceRelations);
	    enc = ctx.mkAnd(enc, EncodingsCAT.satUnion("co", "fr", events, ctx));
	    enc = ctx.mkAnd(enc, EncodingsCAT.satUnion("com", "(co+fr)", "rf", events, ctx));
	    enc = ctx.mkAnd(enc, EncodingsCAT.satUnion("po-loc", "com", events, ctx));
	    enc = ctx.mkAnd(enc, EncodingsCAT.satUnion("com-pso", "(co+fr)", "rfe", events, ctx));
	    enc = ctx.mkAnd(enc, EncodingsCAT.satIntersection("po", "RM", events, ctx));
	    enc = ctx.mkAnd(enc, EncodingsCAT.satUnion("po-pso", "(po&RM)", "mfence", events, ctx));
	    enc = ctx.mkAnd(enc, EncodingsCAT.satUnion("ghb-pso", "po-pso", "com-pso", events, ctx));

		for(RelCartesian relation : cartesianRelations){
			enc = ctx.mkAnd(enc, relation.encode(events, ctx, null));
		}

		return enc;
	}
	
	public BoolExpr Consistent(Program program, Context ctx) throws Z3Exception {
		Set<Event> events = program.getEvents().stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet());
		return ctx.mkAnd(satAcyclic("(po-loc+com)", events, ctx), satAcyclic("ghb-pso", events, ctx));
	}
	
	public BoolExpr Inconsistent(Program program, Context ctx) throws Z3Exception {
		Set<Event> events = program.getEvents().stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet());
		BoolExpr enc = ctx.mkAnd(satCycleDef("(po-loc+com)", events, ctx), satCycleDef("ghb-pso", events, ctx));
		enc = ctx.mkAnd(enc, ctx.mkOr(satCycle("(po-loc+com)", events, ctx), satCycle("ghb-pso", events, ctx)));
		return enc;
	}
}