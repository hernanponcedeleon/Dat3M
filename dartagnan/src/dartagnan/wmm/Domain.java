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
import dartagnan.program.event.rcu.RCUReadLock;
import dartagnan.program.event.rcu.RCUReadUnlock;
import dartagnan.program.utils.EventRepository;

public class Domain {

	private static String[] threadInternalRelations = {
			"id", "po", "crit",
			"ii", "ic", "ci", "cc",
			"idd", "data", "ctrlDirect", "ctrl", "idd^+"};

	public static BoolExpr encode(Program program, Context ctx, boolean encCtrlPo) throws Z3Exception {
		BoolExpr enc = ctx.mkTrue();

		for(Event e : program.getEventRepository().getEvents(EventRepository.EVENT_MEMORY | EventRepository.EVENT_LOCAL)) {
			enc = ctx.mkAnd(enc, ctx.mkNot(edge("ii", e, e, ctx)));
			enc = ctx.mkAnd(enc, ctx.mkNot(edge("ic", e, e, ctx)));
			enc = ctx.mkAnd(enc, ctx.mkNot(edge("ci", e, e, ctx)));
			enc = ctx.mkAnd(enc, ctx.mkNot(edge("cc", e, e, ctx)));
		}

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
		enc = ctx.mkAnd(enc, encodeIdd(program, ctx));
		enc = ctx.mkAnd(enc, encodeCtrl(program, ctx, encCtrlPo));
		enc = ctx.mkAnd(enc, encodeCrit(program, ctx));
		return enc;
	}

	private static BoolExpr encodeStaticRelations(Program program, Context ctx){
		BoolExpr enc = ctx.mkTrue();

		for(Event e1 : program.getEventRepository().getEvents(EventRepository.EVENT_ALL)){
			for(Event e2 : program.getEventRepository().getEvents(EventRepository.EVENT_ALL)){
				if(e1.getMainThreadId() == e2.getMainThreadId()) {
					enc = ctx.mkAnd(enc, edge("int", e1, e2, ctx));
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("ext", e1, e2, ctx)));
				}
				else {
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("int", e1, e2, ctx)));
					enc = ctx.mkAnd(enc, edge("ext", e1, e2, ctx));
					for(String rel : threadInternalRelations){
						enc = ctx.mkAnd(enc, ctx.mkNot(edge(rel, e1, e2, ctx)));
					}
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

	private static BoolExpr encodeIdd(Program program, Context ctx){
		BoolExpr enc = ctx.mkTrue();

		for(Thread t : program.getThreads()){
			Collection<Event> nonRegWriters = t.getEventRepository().getEvents(EventRepository.EVENT_FENCE | EventRepository.EVENT_RCU | EventRepository.EVENT_SKIP | EventRepository.EVENT_INIT | EventRepository.EVENT_STORE | EventRepository.EVENT_IF);
			Collection<Event> nonRegReaders = t.getEventRepository().getEvents(EventRepository.EVENT_FENCE | EventRepository.EVENT_RCU | EventRepository.EVENT_SKIP | EventRepository.EVENT_INIT);
			for(Event e1 : nonRegWriters){
				for(Event e2 : nonRegReaders){
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("idd", e1, e2, ctx)));
				}
			}

			// TODO: Load can be also a regReader (for address dependency)
			Collection<Event> events = t.getEventRepository().getEvents(EventRepository.EVENT_STORE | EventRepository.EVENT_LOAD | EventRepository.EVENT_LOCAL);
			Set<Register> registers = events.stream().filter(e -> e.getReg() != null).map(e -> e.getReg()).collect(Collectors.toSet());
			Set<Event> eventsLoadLocal = t.getEventRepository().getEvents(EventRepository.EVENT_LOCAL | EventRepository.EVENT_LOAD);
			Set<Event> eventsStoreLocalIf = t.getEventRepository().getEvents(EventRepository.EVENT_STORE | EventRepository.EVENT_LOCAL | EventRepository.EVENT_IF);

			for(Event regReader : eventsStoreLocalIf){
				Set<Register> readerRegisters = regReader.getExpr().getRegs();
				for(Event regWriter : eventsLoadLocal){
					if(!readerRegisters.contains(regWriter.getReg())){
						enc = ctx.mkAnd(enc, ctx.mkNot(edge("idd", regWriter, regReader, ctx)));
					}
				}
			}

			for(Register r : registers){
				Set<Event> regWriters = eventsLoadLocal.stream().filter(e -> e.getReg().equals(r)).collect(Collectors.toSet());
				Set<Event> regReaders = eventsStoreLocalIf.stream().filter(e -> e.getExpr().getRegs().contains(r)).collect(Collectors.toSet());

				for(Event e1 : regWriters){
					for(Event e2 : regReaders){
						if(e1.getEId() >= e2.getEId()){
							enc = ctx.mkAnd(enc, ctx.mkNot(edge("idd", e1, e2, ctx)));
						} else {
							BoolExpr clause = ctx.mkAnd(e1.executes(ctx), e2.executes(ctx));
							for(Event e3 : regWriters){
								if(e3.getEId() > e1.getEId() && e3.getEId() < e2.getEId()){
									clause = ctx.mkAnd(clause, ctx.mkNot(e3.executes(ctx)));
								}
							}
							enc = ctx.mkAnd(enc, ctx.mkEq(clause, edge("idd", e1, e2, ctx)));
						}
					}
				}
			}
		}

		return enc;
	}

	private static BoolExpr encodeCtrl(Program program, Context ctx, boolean encCtrlPo){
		BoolExpr enc = ctx.mkTrue();

		for(Event e1 : program.getEventRepository().getEvents(EventRepository.EVENT_IF)){
			Set<Event> branchEvents = ((If) e1).getT1().getEvents();
			branchEvents.addAll(((If) e1).getT2().getEvents());
			for(Event e2 : e1.getMainThread().getEventRepository().getEvents(EventRepository.EVENT_ALL)){
				if(branchEvents.contains(e2)){
					enc = ctx.mkAnd(enc, edge("ctrlDirect", e1, e2, ctx));
				} else {
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("ctrlDirect", e1, e2, ctx)));
				}
			}
		}

		for(Thread t : program.getThreads()){
			for(Event e1 : t.getEventRepository().getEvents(EventRepository.EVENT_LOAD | EventRepository.EVENT_LOCAL | EventRepository.EVENT_IF)) {
				for(Event e2 : t.getEventRepository().getEvents(EventRepository.EVENT_ALL)){
					BoolExpr ctrlClause = edge("ctrlDirect", e1, e2, ctx);
					for(Event e3 : t.getEventRepository().getEvents(EventRepository.EVENT_ALL)) {
						ctrlClause = ctx.mkOr(ctrlClause, ctx.mkAnd(edge("idd^+", e1, e3, ctx), edge("ctrl", e3, e2, ctx)));
						if(encCtrlPo) {
							ctrlClause = ctx.mkOr(ctrlClause, ctx.mkAnd(edge("ctrl", e1, e3, ctx), edge("po", e3, e2, ctx)));
						}
					}
					enc = ctx.mkAnd(enc, ctx.mkEq(edge("ctrl", e1, e2, ctx), ctrlClause));
				}
			}
		}

		return enc;
	}

	private static BoolExpr encodeCrit(Program program, Context ctx){
		BoolExpr enc = ctx.mkTrue();
		for(Event unlock : program.getEventRepository().getEvents(EventRepository.EVENT_RCU_UNLOCK)){
			RCUReadLock myLock = ((RCUReadUnlock)unlock).getLockEvent();
			enc = ctx.mkAnd(enc, edge("crit", myLock, unlock, ctx));
			for(Event lock : program.getEventRepository().getEvents(EventRepository.EVENT_RCU_LOCK)){
				if(!lock.equals(myLock)){
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("crit", lock, unlock, ctx)));
				}
			}
		}
		return enc;
	}
}