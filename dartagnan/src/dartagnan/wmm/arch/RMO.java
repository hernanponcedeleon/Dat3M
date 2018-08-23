package dartagnan.wmm.arch;

import static dartagnan.wmm.Encodings.satAcyclic;
import static dartagnan.wmm.Encodings.satCycle;
import static dartagnan.wmm.Encodings.satCycleDef;
import static dartagnan.wmm.EncodingsCAT.satIntersection;
import static dartagnan.wmm.EncodingsCAT.satMinus;
import static dartagnan.wmm.EncodingsCAT.satTransFixPoint;
import static dartagnan.wmm.EncodingsCAT.satUnion;

import java.util.*;

import com.microsoft.z3.*;

import dartagnan.program.*;
import dartagnan.program.event.Event;
import dartagnan.program.event.filter.FilterBasic;
import dartagnan.program.utils.EventRepository;
import dartagnan.wmm.relation.RelCartesian;
import dartagnan.wmm.WmmInterface;
import dartagnan.wmm.relation.RelFencerel;
import dartagnan.wmm.relation.Relation;
import dartagnan.wmm.relation.basic.RelCtrl;
import dartagnan.wmm.relation.basic.RelIdd;

public class RMO implements WmmInterface {

	private Collection<Relation> relations = new ArrayList<>(Arrays.asList(
			new RelIdd(),
			new RelCtrl(),
			new RelFencerel("Mfence", "mfence"),
			new RelFencerel("Isync", "isync"),
			new RelCartesian(new FilterBasic("R"), new FilterBasic("R"), "RR").setEventMask(EventRepository.EVENT_MEMORY),
			new RelCartesian(new FilterBasic("R"), new FilterBasic("W"), "RW").setEventMask(EventRepository.EVENT_MEMORY),
			new RelCartesian(new FilterBasic("W"), new FilterBasic("R"), "WR").setEventMask(EventRepository.EVENT_MEMORY),
			new RelCartesian(new FilterBasic("R"), new FilterBasic("M"), "RM").setEventMask(EventRepository.EVENT_MEMORY)
	));
	
	public BoolExpr encode(Program program, Context ctx, boolean approx, boolean idl) throws Z3Exception {
		if(program.hasRMWEvents()){
			throw new RuntimeException("RMW is not implemented for RMO");
		}

		EventRepository eventRepository = program.getEventRepository();
		Set<Event> events = eventRepository.getEvents(EventRepository.EVENT_MEMORY);
		Set<Event> eventsL = eventRepository.getEvents(EventRepository.EVENT_MEMORY | EventRepository.EVENT_LOCAL | EventRepository.EVENT_IF);
		Set<Event> eventsS = eventRepository.getEvents(EventRepository.EVENT_MEMORY | EventRepository.EVENT_SKIP);

		BoolExpr enc = satIntersection("ctrlisync", "ctrl", "isync", eventsS, ctx);
		enc = ctx.mkAnd(enc, satIntersection("rfe", "rf", "ext", events, ctx));
		enc = ctx.mkAnd(enc, satIntersection("po-loc", "po", "loc", events, ctx));

		enc = ctx.mkAnd(enc, satUnion("co", "fr", events, ctx));
		enc = ctx.mkAnd(enc, satUnion("com", "(co+fr)", "rf", events, ctx));
		enc = ctx.mkAnd(enc, satMinus("po-loc", "RR", events, ctx));
		enc = ctx.mkAnd(enc, satUnion("(po-loc\\RR)", "com", events, ctx));
		enc = ctx.mkAnd(enc, satUnion("com-rmo", "(co+fr)", "rfe", events, ctx));
		enc = ctx.mkAnd(enc, satTransFixPoint("idd", eventsL, approx, ctx));
		enc = ctx.mkAnd(enc, satIntersection("data", "idd^+", "RW", events, ctx));
		enc = ctx.mkAnd(enc, satIntersection("po-loc", "WR", events, ctx));
		enc = ctx.mkAnd(enc, satUnion("data", "(po-loc&WR)", events, ctx));
		enc = ctx.mkAnd(enc, satTransFixPoint("(data+(po-loc&WR))", events, approx, ctx));
		enc = ctx.mkAnd(enc, satIntersection("(data+(po-loc&WR))^+", "RM", events, ctx));
		enc = ctx.mkAnd(enc, satIntersection("ctrl", "RW", events, ctx));
		enc = ctx.mkAnd(enc, satUnion("(ctrl&RW)", "ctrlisync", events, ctx));
		enc = ctx.mkAnd(enc, satUnion("dp-rmo", "((ctrl&RW)+ctrlisync)", "((data+(po-loc&WR))^+&RM)", events, ctx));
		enc = ctx.mkAnd(enc, satUnion("po-rmo", "dp-rmo", "mfence", events, ctx));
		enc = ctx.mkAnd(enc, satUnion("ghb-rmo", "po-rmo", "com-rmo", events, ctx));

		for(Relation relation : relations){
			enc = ctx.mkAnd(enc, relation.encode(program, ctx, null));
		}

		return enc;
	}
	
	public BoolExpr Consistent(Program program, Context ctx) throws Z3Exception {
		Set<Event> events = program.getEventRepository().getEvents(EventRepository.EVENT_MEMORY);
		return ctx.mkAnd(satAcyclic("((po-loc\\RR)+com)", events, ctx), satAcyclic("ghb-rmo", events, ctx));
	}
	
	public BoolExpr Inconsistent(Program program, Context ctx) throws Z3Exception {
		Set<Event> events = program.getEventRepository().getEvents(EventRepository.EVENT_MEMORY);
		BoolExpr enc = ctx.mkAnd(satCycleDef("((po-loc\\RR)+com)", events, ctx), satCycleDef("ghb-rmo", events, ctx));
		enc = ctx.mkAnd(enc, ctx.mkOr(satCycle("((po-loc\\RR)+com)", events, ctx), satCycle("ghb-rmo", events, ctx)));
		return enc;
	}
}