package dartagnan.wmm.arch;

import static dartagnan.wmm.Encodings.satAcyclic;
import static dartagnan.wmm.Encodings.satCycle;
import static dartagnan.wmm.Encodings.satCycleDef;
import static dartagnan.wmm.EncodingsCAT.*;

import java.util.*;

import com.microsoft.z3.*;

import dartagnan.program.*;
import dartagnan.program.event.Event;
import dartagnan.program.event.filter.FilterBasic;
import dartagnan.program.utils.EventRepository;
import dartagnan.wmm.relation.*;
import dartagnan.wmm.WmmInterface;
import dartagnan.wmm.axiom.Empty;

public class TSO implements WmmInterface {

	private Collection<Relation> relations = new ArrayList<>(Arrays.asList(
			new RelFencerel("Mfence", "mfence"),
			new RelCartesian(new FilterBasic("W"), new FilterBasic("R"), "WR").setEventMask(EventRepository.EVENT_MEMORY)
	));

	public BoolExpr encode(Program program, Context ctx, boolean approx, boolean idl) throws Z3Exception {
		Set<Event> events = program.getEventRepository().getEvents(EventRepository.EVENT_MEMORY);

		BoolExpr enc = satIntersection("rfe", "rf", "ext", events, ctx);
		enc = ctx.mkAnd(enc, satIntersection("po-loc", "po", "loc", events, ctx));
		enc = ctx.mkAnd(enc, satUnion("co", "fr", events, ctx));
		enc = ctx.mkAnd(enc, satUnion("com", "(co+fr)", "rf", events, ctx));
		enc = ctx.mkAnd(enc, satUnion("po-loc", "com", events, ctx));
		enc = ctx.mkAnd(enc, satUnion("com-tso", "(co+fr)", "rfe", events, ctx));
		enc = ctx.mkAnd(enc, satMinus("po", "WR", events, ctx));
		enc = ctx.mkAnd(enc, satUnion("po-tso", "(po\\WR)", "mfence", events, ctx));

		if(program.hasRMWEvents()){
			relations.add(new RelCartesian(new FilterBasic("M"), new FilterBasic("A"), "MA").setEventMask(EventRepository.EVENT_MEMORY));
			relations.add(new RelCartesian(new FilterBasic("A"), new FilterBasic("M"), "AM").setEventMask(EventRepository.EVENT_MEMORY));

			enc = ctx.mkAnd(enc, new RelRMW().encode(program, ctx, null));
			enc = ctx.mkAnd(enc, satIntersection("coe", "co", "ext", events, ctx));
			enc = ctx.mkAnd(enc, satIntersection("fre", "fr", "ext", events, ctx));
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

		for(Relation relation : relations){
			enc = ctx.mkAnd(enc, relation.encode(program, ctx, null));
		}

		return enc;
	}

	public BoolExpr Consistent(Program program, Context ctx) throws Z3Exception {
		Set<Event> events = program.getEventRepository().getEvents(EventRepository.EVENT_MEMORY);
		BoolExpr enc = ctx.mkAnd(satAcyclic("(po-loc+com)", events, ctx), satAcyclic("ghb-tso", events, ctx));
		if(program.hasRMWEvents()){
			Empty rmw = new Empty(new BasicRelation("(rmw&(fre;coe))"));
			enc = ctx.mkAnd(enc, rmw.Consistent(events, ctx));
		}
		return enc;
	}

	public BoolExpr Inconsistent(Program program, Context ctx) throws Z3Exception {
		Set<Event> events = program.getEventRepository().getEvents(EventRepository.EVENT_MEMORY);
		BoolExpr enc = ctx.mkAnd(satCycleDef("(po-loc+com)", events, ctx), satCycleDef("ghb-tso", events, ctx));
		enc = ctx.mkAnd(enc, ctx.mkOr(satCycle("(po-loc+com)", events, ctx), satCycle("ghb-tso", events, ctx)));
		if(program.hasRMWEvents()){
			Empty rmw = new Empty(new BasicRelation("(rmw&(fre;coe))"));
			enc = ctx.mkAnd(enc, rmw.Inconsistent(events, ctx));
		}
		return enc;
	}
}