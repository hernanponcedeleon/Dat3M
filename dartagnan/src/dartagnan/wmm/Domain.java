package dartagnan.wmm;

import static dartagnan.utils.Utils.edge;
import static dartagnan.utils.Utils.intVar;
import static dartagnan.utils.Utils.ssaReg;
import static dartagnan.wmm.Encodings.satTO;
import static dartagnan.wmm.Encodings.encodeEO;

import java.util.*;
import java.util.stream.Collectors;

import com.microsoft.z3.*;

import dartagnan.program.*;
import dartagnan.program.Thread;
import dartagnan.program.event.*;
import dartagnan.program.utils.EventRepository;

public class Domain {

	public static BoolExpr encode(Program program, Context ctx) throws Z3Exception {
		BoolExpr enc = ctx.mkTrue();
		Set<Event> eventsLoadLocal = program.getEventRepository().getEvents(EventRepository.EVENT_LOAD | EventRepository.EVENT_LOCAL);
		for(Event r1 : eventsLoadLocal) {
			Set<Event> modRegLater = eventsLoadLocal.stream().filter(e -> r1.getReg() == e.getReg() && r1.getEId() < e.getEId()).collect(Collectors.toSet());
			BoolExpr lastModReg = r1.executes(ctx);
			for(Event r2 : modRegLater) {
				lastModReg = ctx.mkAnd(lastModReg, ctx.mkNot(r2.executes(ctx)));
			}
			enc = ctx.mkAnd(enc, ctx.mkImplies(lastModReg, ctx.mkEq(r1.getReg().getLastValueExpr(ctx), ssaReg(r1.getReg(), r1.getSsaRegIndex(), ctx))));
		}

		enc = ctx.mkAnd(enc, encodeStaticRelations(program, ctx));
		enc = ctx.mkAnd(enc, encodeCommunicationRelations(program, ctx));
		return enc;
	}

	private static BoolExpr encodeStaticRelations(Program program, Context ctx){
		BoolExpr enc = ctx.mkTrue();

		for(Event e1 : program.getEventRepository().getEvents(EventRepository.EVENT_ALL)){
			for(Event e2 : program.getEventRepository().getEvents(EventRepository.EVENT_ALL)){
				if(!(e1 instanceof MemEvent) || !(e2 instanceof MemEvent)
						|| !(e1.getMainThreadId() == e2.getMainThreadId())
						|| e1.getEId() == e2.getEId()){
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("ii", e1, e2, ctx)));
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("ic", e1, e2, ctx)));
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("ci", e1, e2, ctx)));
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("cc", e1, e2, ctx)));
				}
			}
		}

		for(Event e1 : program.getEventRepository().getEvents(EventRepository.EVENT_ALL)){
			for(Event e2 : program.getEventRepository().getEvents(EventRepository.EVENT_ALL)){
				if(e1.getMainThreadId() == e2.getMainThreadId()) {
					enc = ctx.mkAnd(enc, edge("int", e1, e2, ctx));
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("ext", e1, e2, ctx)));
				}
				else {
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("int", e1, e2, ctx)));
					enc = ctx.mkAnd(enc, edge("ext", e1, e2, ctx));
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("po", e1, e2, ctx)));
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("id", e1, e2, ctx)));
				}
			}
		}

		for(Thread t : program.getThreads()){
			Collection<Event> events = t.getEventRepository().getEvents(EventRepository.EVENT_ALL);
			for(Event e1 : events){
				for(Event e2 : events){
					BoolExpr po = edge("po", e1, e2, ctx);
					BoolExpr id = edge("id", e1, e2, ctx);
					if(e1.getEId() >= e2.getEId()){
						po = ctx.mkNot(po);
					}
					if(!(e1.getEId().equals(e2.getEId()))){
						id = ctx.mkNot(id);
					}
					enc = ctx.mkAnd(enc, ctx.mkAnd(po, id));
				}
			}
		}

		return enc;
	}

	private static BoolExpr encodeCommunicationRelations(Program program, Context ctx){
		BoolExpr enc = ctx.mkTrue();
		EventRepository eventRepository = program.getEventRepository();
		Collection<Event> memEvents = eventRepository.getEvents(EventRepository.EVENT_MEMORY);
		Collection<Event> nonMemEvents = eventRepository.getEvents(EventRepository.EVENT_FENCE | EventRepository.EVENT_RCU | EventRepository.EVENT_SKIP | EventRepository.EVENT_IF);

		for(Event e1 : nonMemEvents){
			for(Event e2 : nonMemEvents){
				enc = ctx.mkAnd(enc, ctx.mkNot(edge("loc", e1, e2, ctx)));
				enc = ctx.mkAnd(enc, ctx.mkNot(edge("rf", e1, e2, ctx)));
				enc = ctx.mkAnd(enc, ctx.mkNot(edge("co", e1, e2, ctx)));
				enc = ctx.mkAnd(enc, ctx.mkNot(edge("fr", e1, e2, ctx)));
			}
		}

		for(Event e1 : nonMemEvents){
			for(Event e2 : memEvents){
				enc = ctx.mkAnd(enc, ctx.mkNot(edge("loc", e1, e2, ctx)));
				enc = ctx.mkAnd(enc, ctx.mkNot(edge("loc", e2, e1, ctx)));
				enc = ctx.mkAnd(enc, ctx.mkNot(edge("rf", e1, e2, ctx)));
				enc = ctx.mkAnd(enc, ctx.mkNot(edge("rf", e2, e1, ctx)));
				enc = ctx.mkAnd(enc, ctx.mkNot(edge("co", e1, e2, ctx)));
				enc = ctx.mkAnd(enc, ctx.mkNot(edge("co", e2, e1, ctx)));
				enc = ctx.mkAnd(enc, ctx.mkNot(edge("fr", e1, e2, ctx)));
				enc = ctx.mkAnd(enc, ctx.mkNot(edge("fr", e2, e1, ctx)));
			}
		}

		for(Event e1 : memEvents){
			for(Event e2 : memEvents){
				if(e1.getLoc() == e2.getLoc()) {
					enc = ctx.mkAnd(enc, edge("loc", e1, e2, ctx));
					enc = ctx.mkAnd(enc, ctx.mkImplies(edge("rf", e1, e2, ctx), ctx.mkAnd(e1.executes(ctx), e2.executes(ctx))));
					enc = ctx.mkAnd(enc, ctx.mkImplies(edge("co", e1, e2, ctx), ctx.mkAnd(e1.executes(ctx), e2.executes(ctx))));
					if(!((e1 instanceof Store || e1 instanceof Init) && e2 instanceof Load)) {
						enc = ctx.mkAnd(enc, ctx.mkNot(edge("rf", e1, e2, ctx)));
					}
					if(!((e1 instanceof Store || e1 instanceof Init) && (e2 instanceof Store || e2 instanceof Init))) {
						enc = ctx.mkAnd(enc, ctx.mkNot(edge("co", e1, e2, ctx)));
					}

					BoolExpr orClause = ctx.mkFalse();
					for(Event e3 : memEvents) {
						orClause = ctx.mkOr(orClause, ctx.mkAnd(edge("rf", e3, e1, ctx), edge("co", e3, e2, ctx)));
					}
					enc = ctx.mkAnd(enc, ctx.mkEq(edge("fr", e1, e2, ctx), orClause));
					if(!orClause.equals(ctx.mkFalse())) {
						enc = ctx.mkAnd(enc, ctx.mkEq(edge("fr", e1, e2, ctx), orClause));
					}
				}
				else {
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("loc", e1, e2, ctx)));
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("rf", e1, e2, ctx)));
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("co", e1, e2, ctx)));
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("fr", e1, e2, ctx)));
				}
			}
		}

		Collection<Location> locations = memEvents.stream().map(e -> e.getLoc()).collect(Collectors.toSet());
		Collection<Event> eventsStoreInit = eventRepository.getEvents(EventRepository.EVENT_INIT | EventRepository.EVENT_STORE);
		Collection<Event> eventsLoad = eventRepository.getEvents(EventRepository.EVENT_LOAD);

		for(Location loc : locations) {
			Collection<Event> eventsStoreInitByLocation = eventsStoreInit.stream().filter(e -> e.getLoc() == loc).collect(Collectors.toSet());
			Collection<Event> eventsLoadByLocation = eventsLoad.stream().filter(e -> e.getLoc() == loc).collect(Collectors.toSet());

			enc = ctx.mkAnd(enc, satTO("co", eventsStoreInitByLocation, ctx));

			for(Event w1 : eventsStoreInitByLocation){
				BoolExpr lastCoOrder = w1.executes(ctx);
				for(Event w2 : eventsStoreInitByLocation){
					lastCoOrder = ctx.mkAnd(lastCoOrder, ctx.mkNot(edge("co", w1, w2, ctx)));
				}
				enc = ctx.mkAnd(enc, ctx.mkImplies(lastCoOrder, ctx.mkEq(w1.getLoc().getLastValueExpr(ctx), ((MemEvent) w1).ssaLoc)));
			}

			for(Event r : eventsLoadByLocation){
				Set<BoolExpr> rfPairs = new HashSet<BoolExpr>();
				for(Event w : eventsStoreInitByLocation) {
					rfPairs.add(edge("rf", w, r, ctx));
				}
				enc = ctx.mkAnd(enc, ctx.mkImplies(r.executes(ctx), encodeEO(rfPairs, ctx)));
			}
		}

		for(Event e : eventRepository.getEvents(EventRepository.EVENT_INIT)) {
			enc = ctx.mkAnd(enc, ctx.mkEq(intVar("co", e, ctx), ctx.mkInt(1)));
		}

		return enc;
	}
}