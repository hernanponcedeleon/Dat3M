package dartagnan.wmm.arch;

import static dartagnan.wmm.Encodings.satAcyclic;
import static dartagnan.wmm.Encodings.satCycle;
import static dartagnan.wmm.Encodings.satCycleDef;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Set;

import com.microsoft.z3.*;

import dartagnan.program.*;
import dartagnan.program.event.Event;
import dartagnan.program.event.filter.FilterBasic;
import dartagnan.program.utils.EventRepository;
import dartagnan.wmm.relation.basic.RelCartesian;
import dartagnan.wmm.EncodingsCAT;
import dartagnan.wmm.WmmInterface;
import dartagnan.wmm.relation.basic.RelFencerel;
import dartagnan.wmm.relation.Relation;
import dartagnan.wmm.relation.basic.RelCtrl;
import dartagnan.wmm.relation.basic.RelIdd;

public class Alpha implements WmmInterface {

	private Collection<Relation> relations = new ArrayList<>(Arrays.asList(
			new RelIdd(),
			new RelCtrl(),
			new RelFencerel("Mfence", "mfence"),
			new RelFencerel("Isync", "isync"),
			new RelCartesian(new FilterBasic("R"), new FilterBasic("W"), "RW").setEventMask(EventRepository.EVENT_MEMORY),
			new RelCartesian(new FilterBasic("W"), new FilterBasic("R"), "WR").setEventMask(EventRepository.EVENT_MEMORY),
			new RelCartesian(new FilterBasic("R"), new FilterBasic("M"), "RM").setEventMask(EventRepository.EVENT_MEMORY),
			new RelCartesian(new FilterBasic("W"), new FilterBasic("W"), "WW").setEventMask(EventRepository.EVENT_MEMORY)
	));
	
	public BoolExpr encode(Program program, Context ctx, boolean approx, boolean idl) throws Z3Exception {
		if(program.hasRMWEvents()){
			throw new RuntimeException("RMW is not implemented for Alpha");
		}

		EventRepository eventRepository = program.getEventRepository();
		Set<Event> events = eventRepository.getEvents(EventRepository.EVENT_MEMORY);
		Set<Event> eventsL = eventRepository.getEvents(EventRepository.EVENT_MEMORY | EventRepository.EVENT_LOCAL | EventRepository.EVENT_IF);
		Set<Event> eventsS = eventRepository.getEvents(EventRepository.EVENT_MEMORY | EventRepository.EVENT_SKIP);

		BoolExpr enc = EncodingsCAT.satIntersection("ctrlisync", "ctrl", "isync", eventsS, ctx);
		enc = ctx.mkAnd(enc, EncodingsCAT.satIntersection("rfe", "rf", "ext", events, ctx));
		enc = ctx.mkAnd(enc, EncodingsCAT.satIntersection("po-loc", "po", "loc", events, ctx));

		enc = ctx.mkAnd(enc, EncodingsCAT.satUnion("co", "fr", events, ctx));
	    enc = ctx.mkAnd(enc, EncodingsCAT.satUnion("com", "(co+fr)", "rf", events, ctx));
	    enc = ctx.mkAnd(enc, EncodingsCAT.satUnion("po-loc", "com", events, ctx));
	    enc = ctx.mkAnd(enc, EncodingsCAT.satUnion("com-alpha", "(co+fr)", "rfe", events, ctx));
	    enc = ctx.mkAnd(enc, EncodingsCAT.satTransFixPoint("idd", eventsL, approx, ctx));
	    enc = ctx.mkAnd(enc, EncodingsCAT.satIntersection("data", "idd^+", "RW", events, ctx));
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

		for(Relation relation : relations){
			enc = ctx.mkAnd(enc, relation.encode(program, ctx, null));
		}

	    return enc;
	}

	public BoolExpr Consistent(Program program, Context ctx) throws Z3Exception {
		Set<Event> events = program.getEventRepository().getEvents(EventRepository.EVENT_MEMORY);
		return ctx.mkAnd(satAcyclic("(po-loc+com)", events, ctx), satAcyclic("(dp-alpha+rf)", events, ctx), satAcyclic("ghb-alpha", events, ctx));
	}
	
	public BoolExpr Inconsistent(Program program, Context ctx) throws Z3Exception {
		Set<Event> events = program.getEventRepository().getEvents(EventRepository.EVENT_MEMORY);
		BoolExpr enc = ctx.mkAnd(satCycleDef("(po-loc+com)", events, ctx), satCycleDef("(dp-alpha+rf)", events, ctx), satCycleDef("ghb-alpha", events, ctx));
		enc = ctx.mkAnd(enc, ctx.mkOr(satCycle("(po-loc+com)", events, ctx), satCycle("(dp-alpha+rf)", events, ctx), satCycle("ghb-alpha", events, ctx)));
		return enc;
	}

	
}