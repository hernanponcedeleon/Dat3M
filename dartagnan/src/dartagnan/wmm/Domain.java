package dartagnan.wmm;

import static dartagnan.utils.Utils.edge;
import static dartagnan.utils.Utils.intVar;
import static dartagnan.utils.Utils.lastValueLoc;
import static dartagnan.utils.Utils.lastValueReg;
import static dartagnan.utils.Utils.ssaReg;
import static dartagnan.wmm.Encodings.satTO;
import static dartagnan.wmm.Encodings.encodeEO;

import java.util.*;
import java.util.stream.Collectors;

import com.microsoft.z3.*;

import dartagnan.program.*;
import dartagnan.program.event.*;
import dartagnan.program.utils.EventRepository;

public class Domain {
	
	public static BoolExpr encode(Program program, Context ctx) throws Z3Exception {
		BoolExpr enc = ctx.mkTrue();

		EventRepository eventRepository = program.getEventRepository();
		Set<Event> eventsMem = eventRepository.getEvents(EventRepository.EVENT_MEMORY);
		Set<Event> eventsMemSkip = eventRepository.getEvents(EventRepository.EVENT_MEMORY | EventRepository.EVENT_SKIP);
		Set<Event> eventsMemSkipLocal = eventRepository.getEvents(EventRepository.EVENT_MEMORY | EventRepository.EVENT_SKIP | EventRepository.EVENT_LOCAL);
		Set<Event> eventsLocal = eventRepository.getEvents(EventRepository.EVENT_MEMORY | EventRepository.EVENT_LOCAL);
		Set<Event> eventsStoreInit = eventRepository.getEvents(EventRepository.EVENT_STORE | EventRepository.EVENT_INIT);
		Set<Event> eventsInit = eventRepository.getEvents(EventRepository.EVENT_INIT);
		Set<Event> eventsLoad = eventRepository.getEvents(EventRepository.EVENT_LOAD);
		Set<Event> eventsLoadLocal = eventRepository.getEvents(EventRepository.EVENT_LOAD | EventRepository.EVENT_LOCAL);

		for(Event e : eventsLocal) {
				enc = ctx.mkAnd(enc, ctx.mkNot(edge("ii", e, e, ctx)));
				enc = ctx.mkAnd(enc, ctx.mkNot(edge("ic", e, e, ctx)));
				enc = ctx.mkAnd(enc, ctx.mkNot(edge("ci", e, e, ctx)));
				enc = ctx.mkAnd(enc, ctx.mkNot(edge("cc", e, e, ctx)));
		}
		
		for(Event e1 : eventsMem) {
			for(Event e2 : eventsMem) {
				enc = ctx.mkAnd(enc, ctx.mkImplies(edge("rf", e1, e2, ctx), ctx.mkAnd(e1.executes(ctx), e2.executes(ctx))));
				enc = ctx.mkAnd(enc, ctx.mkImplies(edge("co", e1, e2, ctx), ctx.mkAnd(e1.executes(ctx), e2.executes(ctx))));

				if(e1 == e2) {
					enc = ctx.mkAnd(enc, edge("id", e1, e2, ctx));	
				}
				else {
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("id", e1, e2, ctx)));
				}
				if(e1.getMainThread() == e2.getMainThread()) {
					enc = ctx.mkAnd(enc, edge("int", e1, e2, ctx));
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("ext", e1, e2, ctx)));
				}
				else {
					enc = ctx.mkAnd(enc, edge("ext", e1, e2, ctx));
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("int", e1, e2, ctx)));
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("ii", e1, e2, ctx)));
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("ic", e1, e2, ctx)));
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("ci", e1, e2, ctx)));
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("cc", e1, e2, ctx)));
				}

				if(e1.getLoc() == e2.getLoc()) {
					enc = ctx.mkAnd(enc, edge("loc", e1, e2, ctx));
				}
				else {
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("loc", e1, e2, ctx)));
				}
				if(!((e1 instanceof Store || e1 instanceof Init) && e2 instanceof Load && e1.getLoc() == e2.getLoc())) {
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("rf", e1, e2, ctx)));
				}
				if(!((e1 instanceof Store || e1 instanceof Init) && (e2 instanceof Store || e2 instanceof Init) && e1.getLoc() == e2.getLoc())) {
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("co", e1, e2, ctx)));
				}
			}
		}

		for(Event e : program.getEventRepository().getEvents(EventRepository.EVENT_STORE)) {
			BoolExpr orClause = ctx.mkFalse();
			for(Event x : eventsLocal){
				if(!(x.getMainThread().equals(e.getMainThread()) || e.getEId() <= x.getEId())){
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("idd", x, e, ctx)));
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("data", x, e, ctx)));

				} else if(e.getReg() == null || !e.getLastModMap().get(e.getReg()).contains(x)){
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("idd", x, e, ctx)));

				} else {
					orClause = ctx.mkOr(orClause, edge("idd", x, e, ctx));
				}
			}
			if(!orClause.equals(ctx.mkFalse())){
				enc = ctx.mkAnd(enc, orClause);
			}
		}

		for(Event e : program.getEventRepository().getEvents(EventRepository.EVENT_LOAD)) {
			BoolExpr orClause = ctx.mkFalse();
			for(Event x : eventsLocal){
				if(!(x.getMainThread().equals(e.getMainThread()) || e.getEId() <= x.getEId())){
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("idd", x, e, ctx)));
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("data", x, e, ctx)));

				} else if(!e.getLastModMap().keySet().contains(e.getLoc())
					|| !e.getLastModMap().get(e.getLoc()).contains(x)){
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("idd", x, e, ctx)));

				} else {
					orClause = ctx.mkOr(orClause, edge("idd", x, e, ctx));
				}
			}
			if(!orClause.equals(ctx.mkFalse())){
				enc = ctx.mkAnd(enc, orClause);
			}
		}

		for(Event e : program.getEventRepository().getEvents(EventRepository.EVENT_LOCAL)) {
			Set<Event> mapEvents = new HashSet<>();
			for(Register reg : e.getExpr().getRegs()) {
				mapEvents.addAll(e.getLastModMap().get(reg));
			}

			if(!mapEvents.isEmpty()){
				BoolExpr orClause = ctx.mkFalse();
				for(Event x : eventsLocal){
					if(!(x.getMainThread().equals(e.getMainThread()) || e.getEId() <= x.getEId())){
						enc = ctx.mkAnd(enc, ctx.mkNot(edge("idd", x, e, ctx)));
						enc = ctx.mkAnd(enc, ctx.mkNot(edge("data", x, e, ctx)));
					} else if(!mapEvents.contains(x)){
						enc = ctx.mkAnd(enc, ctx.mkNot(edge("idd", x, e, ctx)));
					} else {
						orClause = ctx.mkOr(orClause, edge("idd", x, e, ctx));
					}
				}
				if(!orClause.equals(ctx.mkFalse())){
					enc = ctx.mkAnd(enc, orClause);
				}
			}
		}
		
		for(Event e1 : eventsMem) {
			for(Event e2 : eventsMem) {
				BoolExpr orClause = ctx.mkFalse();
				for(Event e3 : eventsMem) {
					orClause = ctx.mkOr(orClause, ctx.mkAnd(edge("rf", e3, e1, ctx), edge("co", e3, e2, ctx)));
				}
				enc = ctx.mkAnd(enc, ctx.mkEq(edge("fr", e1, e2, ctx), orClause));
				if(!orClause.equals(ctx.mkFalse())) {
					enc = ctx.mkAnd(enc, ctx.mkEq(edge("fr", e1, e2, ctx), orClause));
				}
			}
		}

		for(Event e1 : eventsLoadLocal) {
			Set<Event> eventsMemSkipLocalSameThread = eventsMemSkipLocal.stream().filter(e2 -> e2.getMainThread().equals(e1.getMainThread())).collect(Collectors.toSet());

			for(Event e2 : eventsMemSkipLocalSameThread){
				if(e2.getEId() > e1.getEId() && e2.getCondRegs().contains(e1.getReg())){
					enc = ctx.mkAnd(enc, edge("ctrlDirect", e1, e2, ctx));
				} else {
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("ctrlDirect", e1, e2, ctx)));
				}

				BoolExpr ctrlClause = edge("ctrlDirect", e1, e2, ctx);
				for(Event e3 : eventsMemSkipLocalSameThread) {
					ctrlClause = ctx.mkOr(ctrlClause, ctx.mkAnd(edge("ctrl", e1, e3, ctx), edge("po", e3, e2, ctx)));
					ctrlClause = ctx.mkOr(ctrlClause, ctx.mkAnd(edge("idd^+", e1, e3, ctx), edge("ctrl", e3, e2, ctx)));
				}
				enc = ctx.mkAnd(enc, ctx.mkEq(edge("ctrl", e1, e2, ctx), ctrlClause));
			}
		}

		for(Event e1 : eventsMemSkip) {
			for(Event e2 : eventsMemSkip) {
				if(e1.getMainThread() == e2.getMainThread()) {
					enc = ctx.mkAnd(enc, edge("int", e1, e2, ctx));
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("ext", e1, e2, ctx)));
					if(e1.getEId() < e2.getEId()) {
						enc = ctx.mkAnd(enc, edge("po", e1, e2, ctx));
					}
					else {
						enc = ctx.mkAnd(enc, ctx.mkNot(edge("po", e1, e2, ctx)));
					}
				} else {
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("po", e1, e2, ctx)));
				}
			}
		}

		Set<Location> locs = eventsMem.stream().map(e -> e.getLoc()).collect(Collectors.toSet());
		for(Location loc : locs) {
			Set<Event> writesEventsLoc = eventsStoreInit.stream().filter(e -> e.getLoc() == loc).collect(Collectors.toSet());
			enc = ctx.mkAnd(enc, satTO("co", writesEventsLoc, ctx));
		}
		
		for(Event e : eventsInit) {
			enc = ctx.mkAnd(enc, ctx.mkEq(intVar("co", e, ctx), ctx.mkInt(1)));
		}

		for(Event w1 : eventsStoreInit) {
			Set<Event> writeSameLoc = eventsStoreInit.stream().filter(e -> w1.getLoc() == e.getLoc()).collect(Collectors.toSet());
			BoolExpr lastCoOrder = w1.executes(ctx);
			for(Event w2 : writeSameLoc) {
				lastCoOrder = ctx.mkAnd(lastCoOrder, ctx.mkNot(edge("co", w1, w2, ctx)));
			}
			enc = ctx.mkAnd(enc, ctx.mkImplies(lastCoOrder, ctx.mkEq(lastValueLoc(w1.getLoc(), ctx), ((MemEvent) w1).ssaLoc)));
		}
		
		for(Event r1 : eventsLoadLocal) {
			Set<Event> modRegLater = eventsLoadLocal.stream().filter(e -> r1.getReg() == e.getReg() && r1.getEId() < e.getEId()).collect(Collectors.toSet());
			BoolExpr lastModReg = r1.executes(ctx);
			for(Event r2 : modRegLater) {
				lastModReg = ctx.mkAnd(lastModReg, ctx.mkNot(r2.executes(ctx)));
			}
			enc = ctx.mkAnd(enc, ctx.mkImplies(lastModReg, ctx.mkEq(lastValueReg(r1.getReg(), ctx), ssaReg(r1.getReg(), r1.getSsaRegIndex(), ctx))));
		}

		for(Event e : eventsLoad) {
			Set<Event> storeEventsLoc = eventsStoreInit.stream().filter(x -> e.getLoc() == x.getLoc()).collect(Collectors.toSet());
			Set<BoolExpr> rfPairs = new HashSet<BoolExpr>();
			for(Event w : storeEventsLoc) {
				rfPairs.add(edge("rf", w, e, ctx));
			}
			enc = ctx.mkAnd(enc, ctx.mkImplies(e.executes(ctx), encodeEO(rfPairs, ctx)));
		}
		return enc;
	}
}