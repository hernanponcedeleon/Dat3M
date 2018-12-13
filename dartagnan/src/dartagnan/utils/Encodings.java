package dartagnan.utils;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Model;
import dartagnan.program.Program;
import dartagnan.program.Register;
import dartagnan.program.event.Event;
import dartagnan.program.event.MemEvent;
import dartagnan.program.event.utils.RegWriter;
import dartagnan.program.memory.Location;
import dartagnan.program.utils.EventRepository;
import dartagnan.wmm.utils.Tuple;
import dartagnan.wmm.utils.TupleSet;

import java.util.HashSet;
import java.util.Set;
import java.util.stream.Collectors;

public class Encodings {

	public static BoolExpr encodeCommonExecutions(Program p1, Program p2, Context ctx) {
		BoolExpr enc = ctx.mkTrue();

		Set<Event> lEventsP1 = p1.getEventRepository().getEvents(EventRepository.MEMORY | EventRepository.LOCAL);
		Set<Event> lEventsP2 = p2.getEventRepository().getEvents(EventRepository.MEMORY | EventRepository.LOCAL);
		Set<Event> rEventsP1 = p1.getEventRepository().getEvents(EventRepository.LOAD);
		Set<Event> wEventsP1 = p1.getEventRepository().getEvents(EventRepository.STORE | EventRepository.INIT);
		Set<Event> rEventsP2 = p2.getEventRepository().getEvents(EventRepository.LOAD);
		Set<Event> wEventsP2 = p2.getEventRepository().getEvents(EventRepository.STORE | EventRepository.INIT);


		for(Event e1 : lEventsP1) {
			for(Event e2 : lEventsP2) {
				if(e1.getHLId() == e2.getHLId()) {
					enc = ctx.mkAnd(enc, ctx.mkEq(e1.executes(ctx), e2.executes(ctx)));
				}
			}
		}

		Set<Tuple> rTuples = new TupleSet();
		Set<Tuple> wTuples = new TupleSet();

		for(Event r1 : rEventsP1) {
			for(Event r2 : rEventsP2) {
				if(r1.getHLId() == r2.getHLId()) {
					enc = ctx.mkAnd(enc, ctx.mkEq(((MemEvent)r1).getAddressExpr(), ((MemEvent)r2).getAddressExpr()));
					rTuples.add(new Tuple(r1, r2));
					break;
				}
			}
		}

		for(Event w1 : wEventsP1) {
			for(Event w2 : wEventsP2) {
				if(w1.getHLId() == w2.getHLId()) {
					enc = ctx.mkAnd(enc, ctx.mkEq(((MemEvent)w1).getAddressExpr(), ((MemEvent)w2).getAddressExpr()));
					wTuples.add(new Tuple(w1, w2));
					break;
				}
			}
		}

		for(Tuple rTuple : rTuples){
			Event r1 = rTuple.getFirst();
			Event r2 = rTuple.getSecond();
			for(Tuple wTuple : wTuples){
				enc = ctx.mkAnd(enc, ctx.mkEq(
						Utils.edge("rf", wTuple.getFirst(), r1, ctx),
						Utils.edge("rf", wTuple.getSecond(), r2, ctx)
				));
			}
		}

		for(Tuple wTupleFrom : wTuples){
			Event w1From = wTupleFrom.getFirst();
			Event w2From = wTupleFrom.getSecond();
			for(Tuple wTupleTo : wTuples){
				if(w1From.getEId() != wTupleTo.getFirst().getEId()){
					enc = ctx.mkAnd(enc, ctx.mkEq(
							Utils.edge("co", w1From, wTupleTo.getFirst(), ctx),
							Utils.edge("co", w2From, wTupleTo.getSecond(), ctx)
					));
				}
			}
		}
		return enc;
	}
	
	public static BoolExpr encodeReachedState(Program p, Model model, Context ctx) {
		BoolExpr reachedState = ctx.mkTrue();
		for(Location loc : p.getLocations()) {
			reachedState = ctx.mkAnd(reachedState, ctx.mkEq(loc.getLastValueExpr(ctx), model.getConstInterp(loc.getLastValueExpr(ctx))));
		}
		Set<RegWriter> executedEvents = p.getEventRepository().getEvents(EventRepository.ALL).stream()
                .filter(e -> model.getConstInterp(e.executes(ctx)).isTrue())
				.filter(e -> e instanceof RegWriter)
                .map(e -> (RegWriter)e)
                .collect(Collectors.toSet());
		Set<Register> regs = new HashSet<>();
		for(RegWriter e : executedEvents){
			regs.add(e.getModifiedReg());
		}
		for(Register reg : regs) {
			reachedState = ctx.mkAnd(reachedState, ctx.mkEq(reg.getLastValueExpr(ctx), model.getConstInterp(reg.getLastValueExpr(ctx))));
		}
		return reachedState;
	}
}