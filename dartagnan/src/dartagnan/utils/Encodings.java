package dartagnan.utils;

import com.microsoft.z3.*;
import dartagnan.program.HighLocation;
import dartagnan.program.Location;
import dartagnan.program.Program;
import dartagnan.program.Register;
import dartagnan.program.event.*;
import dartagnan.program.utils.EventRepository;

import java.util.Set;
import java.util.stream.Collectors;

import static dartagnan.utils.Utils.*;

public class Encodings {

	public static BoolExpr encodeCommonExecutions(Program p1, Program p2, Context ctx) {
		BoolExpr enc = ctx.mkTrue();
		Set<Event> lEventsP1 = p1.getEventRepository().getEvents(EventRepository.EVENT_MEMORY | EventRepository.EVENT_LOCAL);
		Set<Event> lEventsP2 = p2.getEventRepository().getEvents(EventRepository.EVENT_MEMORY | EventRepository.EVENT_LOCAL);
		Set<Event> rEventsP1 = p1.getEventRepository().getEvents(EventRepository.EVENT_LOAD);
		Set<Event> wEventsP1 = p1.getEventRepository().getEvents(EventRepository.EVENT_STORE | EventRepository.EVENT_INIT);
		Set<Event> rEventsP2 = p2.getEventRepository().getEvents(EventRepository.EVENT_LOAD);
		Set<Event> wEventsP2 = p2.getEventRepository().getEvents(EventRepository.EVENT_STORE | EventRepository.EVENT_INIT);
		for(Event e1 : lEventsP1) {
			for(Event e2 : lEventsP2) {
				if(e1.getHLId().equals(e2.getHLId()) && e1.getUnfCopy().equals(e2.getUnfCopy())) {
					enc = ctx.mkAnd(enc, ctx.mkEq(e1.executes(ctx), e2.executes(ctx)));
				}	
			}
		}
		for(Event r1 : rEventsP1) {
			for(Event r2 : rEventsP2) {
				if(r1.getHLId().equals(r2.getHLId()) && r1.getUnfCopy().equals(r2.getUnfCopy())) {
					for(Event w1 : wEventsP1) {
						for(Event w2 : wEventsP2) {
							if(r1.getLoc() != w1.getLoc()) {continue;}
							if(r2.getLoc() != w2.getLoc()) {continue;}
							if(w1.getHLId().equals(w2.getHLId()) && w1.getUnfCopy().equals(w2.getUnfCopy())) {
								enc = ctx.mkAnd(enc, ctx.mkEq(edge("rf", w1, r1, ctx), edge("rf", w2, r2, ctx)));
							}
						}	
					}
				}
			}	
		}
		for(Event w1P1 : wEventsP1) {
			for(Event w1P2 : wEventsP2) {
				if(w1P1.getHLId().equals(w1P2.getHLId()) && w1P1.getUnfCopy().equals(w1P2.getUnfCopy())) {
					for(Event w2P1 : wEventsP1) {
						for(Event w2P2 : wEventsP2) {
							if(w1P1.getLoc() != w2P1.getLoc()) {continue;}
							if(w1P1.getLoc() != w2P2.getLoc()) {continue;}
							if(w1P1 == w2P1 | w1P2 == w2P2) {continue;}
							if(w2P1.getHLId().equals(w2P2.getHLId()) && w2P1.getUnfCopy().equals(w2P2.getUnfCopy())) {
								enc = ctx.mkAnd(enc, ctx.mkEq(edge("co", w1P1, w2P1, ctx), edge("co", w1P2, w2P2, ctx)));
							}
						}	
					}
				}
			}	
		}
		return enc;
	}

	public static BoolExpr encodePreserveFences(Program p1, Program p2, Context ctx) {
		BoolExpr enc = ctx.mkTrue();
		Set<Event> memEventsP1 = p1.getEventRepository().getEvents(EventRepository.EVENT_MEMORY);
		Set<Event> memEventsP2 = p2.getEventRepository().getEvents(EventRepository.EVENT_MEMORY);
		for(Event e1P1 : memEventsP1) {
			for(Event e1P2 : memEventsP2) {
				if(e1P1.getHLId().equals(e1P2.getHLId())) {
					for(Event e2P1 : memEventsP1) {
						for(Event e2P2 : memEventsP2) {
							if(e1P1.getMainThreadId() != e2P1.getMainThreadId()) {continue;}
							if(e1P2.getMainThreadId() != e2P2.getMainThreadId()) {continue;}
							if(e1P1.getEId() >= e2P1.getEId() | e1P2.getEId() >= e2P2.getEId()) {continue;}
							if(e2P1.getHLId().equals(e2P2.getHLId())) {
								enc = ctx.mkAnd(enc, ctx.mkImplies(edge("sync", e1P1, e2P1, ctx), edge("sync", e1P2, e2P2, ctx)));
								enc = ctx.mkAnd(enc, ctx.mkImplies(edge("lwsync", e1P1, e2P1, ctx), ctx.mkOr(edge("lwsync", e1P2, e2P2, ctx), edge("sync", e1P2, e2P2, ctx))));
							}
						}
					}
				}
			}
		}
		return enc;
	}
	
	public static BoolExpr encodeReachedState(Program p, Model model, Context ctx) {
		Set<Location> locs = p.getEventRepository().getEvents(EventRepository.EVENT_MEMORY).stream().map(e -> e.getLoc()).collect(Collectors.toSet());
		BoolExpr reachedState = ctx.mkTrue();
		for(Location loc : locs) {
			reachedState = ctx.mkAnd(reachedState, ctx.mkEq(loc.getLastValueExpr(ctx), model.getConstInterp(loc.getLastValueExpr(ctx))));
		}
		Set<Event> executedEvents = p.getEventRepository().getEvents(EventRepository.EVENT_ALL).stream().filter(e -> model.getConstInterp(e.executes(ctx)).isTrue()).collect(Collectors.toSet());
		Set<Register> regs = executedEvents.stream().filter(e -> e instanceof Local | e instanceof Load).map(e -> e.getReg()).collect(Collectors.toSet());
		for(Register reg : regs) {
			reachedState = ctx.mkAnd(reachedState, ctx.mkEq(reg.getLastValueExpr(ctx), model.getConstInterp(reg.getLastValueExpr(ctx))));
		}
		return reachedState;
	}

	public static BoolExpr getReachedStateLow(Program p, Model model, Context ctx) {
		Set<Location> locs = p.getEventRepository().getEvents(EventRepository.EVENT_MEMORY).stream().map(e -> e.getLoc()).filter(l -> !(l instanceof HighLocation)).collect(Collectors.toSet());
		BoolExpr reachedState = ctx.mkTrue();
		for(Location loc : locs) {
			reachedState = ctx.mkAnd(reachedState, ctx.mkEq(loc.getLastValueExpr(ctx), model.getConstInterp(loc.getLastValueExpr(ctx))));
		}
		return reachedState;
	}

	public static BoolExpr getInitialHigh(Program p, Model model, Context ctx, boolean var1, boolean val1) {
		Set<Event> highInits = p.getEventRepository().getEvents(EventRepository.EVENT_INIT).stream().filter(e -> e.getLoc() instanceof HighLocation).collect(Collectors.toSet());
		BoolExpr reachedState = ctx.mkTrue();
		for(Event e : highInits) {
			IntExpr var = var1 ? initValue(e,ctx) : initValue2(e,ctx);
			IntExpr val = val1 ? initValue(e,ctx) : initValue2(e,ctx);
			if(e.getLoc().getIValue() == null) {
				reachedState = ctx.mkAnd(reachedState, ctx.mkEq(var, model.getConstInterp(val)));
			}
		}
		return reachedState;
	}

	public static BoolExpr getExecutedInstanciatedEvents(Program p, Model model, Context ctx) {
		BoolExpr enc = ctx.mkTrue();
		for(Event e : p.getEventRepository().getEvents(EventRepository.EVENT_ALL)) {
			if(!(e instanceof MemEvent)) {
				continue;
			}
			if(model.getConstInterp(e.executes(ctx)).isTrue()) {
				enc = ctx.mkAnd(enc, e.executes(ctx));
				Expr dfEvent = model.getConstInterp(((MemEvent) e).ssaLoc);
				enc = ctx.mkAnd(enc, ctx.mkEq(((MemEvent) e).ssaLoc, dfEvent));
			}
		}
		return enc;
	}

	public static BoolExpr diffInitialHigh(Program p, Context ctx) {
		Set<Event> highInits = p.getEventRepository().getEvents(EventRepository.EVENT_INIT).stream().filter(e -> e.getLoc() instanceof HighLocation).collect(Collectors.toSet());
		BoolExpr initState = ctx.mkTrue();
		for(Event e : highInits) {
			if(e.getLoc().getIValue() == null) {
				initState = ctx.mkAnd(initState, ctx.mkNot(ctx.mkEq(initValue(e,ctx), initValue2(e,ctx))));
			}
		}
		return initState;
	}

	public static BoolExpr encodeMissingIndexes(If t, MapSSA map1, MapSSA map2, Context ctx) {

		BoolExpr ret = ctx.mkTrue();
		BoolExpr index = ctx.mkTrue();

		for(Object o : map1.keySet()) {
			Integer i1 = map1.get(o);
			Integer i2 = map2.get(o);
			if(i1 > i2) {
				if(o instanceof Register) {
					// If the ssa index of a register differs in the two branches
					// I need to maintain the value when the event is not executed
					// for testing reachability
					for(Event e : t.getEvents()) {
						if(!(e instanceof Load || e instanceof Local)) {continue;}
						if(e.getSsaRegIndex() == i1 && e.getReg() == o) {
							ret = ctx.mkAnd(ret, ctx.mkImplies(ctx.mkNot(e.executes(ctx)), ctx.mkEq(ssaReg((Register)o, i1, ctx), ssaReg((Register)o, i1-1, ctx))));
						}
					}
					index = ctx.mkEq(ssaReg((Register)o, i1, ctx), ssaReg((Register)o, i2, ctx));
				}
				if(o instanceof Location) {
					index = ctx.mkEq(ctx.mkIntConst(o.toString() + "_" + i1), ctx.mkIntConst(o.toString() + "_" + i2));
				}
				ret = ctx.mkAnd(ret, ctx.mkImplies(ctx.mkBoolConst(t.getT2().cfVar()), index));
			}
		}
		
		for(Object o : map2.keySet()) {
			Integer i1 = map1.get(o);
			Integer i2 = map2.get(o);
			if(i2 > i1) {
				if(o instanceof Register) {
					for(Event e : t.getEvents()) {
						if(!(e instanceof Load || e instanceof Local)) {continue;}
						if(e.getSsaRegIndex() == i2 && e.getReg() == o) {
							ret = ctx.mkAnd(ret, ctx.mkImplies(ctx.mkNot(e.executes(ctx)), ctx.mkEq(ssaReg((Register)o, i2, ctx), ssaReg((Register)o, i2-1, ctx))));
						}
					}
					index = ctx.mkEq(ssaReg((Register)o, i2, ctx), ssaReg((Register)o, i1, ctx));
				}
				if(o instanceof Location) {
					index = ctx.mkEq(ctx.mkIntConst(o.toString() + "_" + i2), ctx.mkIntConst(o.toString() + "_" + i1));
				}
				ret = ctx.mkAnd(ret, ctx.mkImplies(ctx.mkBoolConst(t.getT1().cfVar()), index));
			}
		}
		return ret;	
	}
}