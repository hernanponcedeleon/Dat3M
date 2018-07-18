package dartagnan.wmm.arch;

import static dartagnan.wmm.Encodings.satAcyclic;
import static dartagnan.wmm.Encodings.satCycle;
import static dartagnan.wmm.Encodings.satCycleDef;
import static dartagnan.wmm.EncodingsCAT.*;

import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;
import java.util.stream.Collectors;

import com.microsoft.z3.*;

import dartagnan.program.*;
import dartagnan.program.event.Event;
import dartagnan.program.event.MemEvent;
import dartagnan.program.event.filter.FilterBasic;
import dartagnan.wmm.Domain;
import dartagnan.wmm.relation.RelCartesian;
import dartagnan.wmm.WmmInterface;
import dartagnan.wmm.axiom.Empty;
import dartagnan.wmm.relation.BasicRelation;

public class TSO implements WmmInterface {

	private final String[] fences = {"mfence"};

	private Set<RelCartesian> cartesianRelations = new HashSet<>(Arrays.asList(
			new RelCartesian(new FilterBasic("W"), new FilterBasic("R"), "WR")
	));
	
	public BoolExpr encode(Program program, Context ctx, boolean approx, boolean idl) throws Z3Exception {
		Set<Event> events = program.getEvents().stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet());

		BoolExpr enc = Domain.encodeFences(program, ctx, fences);
		enc = ctx.mkAnd(enc, satUnion("co", "fr", events, ctx));
		enc = ctx.mkAnd(enc, satUnion("com", "(co+fr)", "rf", events, ctx));
		enc = ctx.mkAnd(enc, satUnion("po-loc", "com", events, ctx));
	    enc = ctx.mkAnd(enc, satUnion("com-tso", "(co+fr)", "rfe", events, ctx));
		enc = ctx.mkAnd(enc, satMinus("po", "WR", events, ctx));
	    enc = ctx.mkAnd(enc, satUnion("po-tso", "(po\\WR)", "mfence", events, ctx));

	    if(program.hasRMWEvents()){
			cartesianRelations.add(new RelCartesian(new FilterBasic("M"), new FilterBasic("A"), "MA"));
			cartesianRelations.add(new RelCartesian(new FilterBasic("A"), new FilterBasic("M"), "AM"));
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

		for(RelCartesian relation : cartesianRelations){
			enc = ctx.mkAnd(enc, relation.encode(events, ctx));
		}

		return enc;
	}
	
	public BoolExpr Consistent(Program program, Context ctx) throws Z3Exception {
		Set<Event> events = program.getEvents().stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet());
		BoolExpr enc = ctx.mkAnd(satAcyclic("(po-loc+com)", events, ctx), satAcyclic("ghb-tso", events, ctx));
		if(program.hasRMWEvents()){
			Empty rmw = new Empty(new BasicRelation("(rmw&(fre;coe))"));
			enc = ctx.mkAnd(enc, rmw.Consistent(program.getEvents(), ctx));
		}
		return enc;
	}

	public BoolExpr Inconsistent(Program program, Context ctx) throws Z3Exception {
		Set<Event> events = program.getEvents().stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet());
		BoolExpr enc = ctx.mkAnd(satCycleDef("(po-loc+com)", events, ctx), satCycleDef("ghb-tso", events, ctx));
		enc = ctx.mkAnd(enc, ctx.mkOr(satCycle("(po-loc+com)", events, ctx), satCycle("ghb-tso", events, ctx)));
		if(program.hasRMWEvents()){
			Empty rmw = new Empty(new BasicRelation("(rmw&(fre;coe))"));
			enc = ctx.mkAnd(enc, rmw.Inconsistent(program.getEvents(), ctx));
		}
		return enc;
	}
}