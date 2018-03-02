package dartagnan.utils;

import static dartagnan.utils.Utils.edge;
import static dartagnan.utils.Utils.lastValueLoc;
import static dartagnan.utils.Utils.lastValueReg;
import static dartagnan.utils.Utils.initValue;
import static dartagnan.utils.Utils.initValue2;
import static dartagnan.utils.Utils.uniqueValue;
import static dartagnan.utils.Utils.ssaReg;

import java.util.Set;
import java.util.stream.Collectors;

import com.microsoft.z3.*;

import dartagnan.program.Event;
import dartagnan.program.HighLocation;
import dartagnan.program.If;
import dartagnan.program.Init;
import dartagnan.program.Load;
import dartagnan.program.Local;
import dartagnan.program.Location;
import dartagnan.program.MemEvent;
import dartagnan.program.Program;
import dartagnan.program.Register;
import dartagnan.program.Store;
import dartagnan.utils.MapSSA;

public class Encodings {

	public static BoolExpr encodeCommonExecutions(Program p1, Program p2, Context ctx) throws Z3Exception {
		BoolExpr enc = ctx.mkTrue();
		Set<Event> lEventsP1 = p1.getEvents().stream().filter(e -> e instanceof MemEvent | e instanceof Local).collect(Collectors.toSet());
		Set<Event> lEventsP2 = p2.getEvents().stream().filter(e -> e instanceof MemEvent | e instanceof Local).collect(Collectors.toSet());
		Set<Event> rEventsP1 = p1.getEvents().stream().filter(e -> e instanceof Load).collect(Collectors.toSet());
		Set<Event> wEventsP1 = p1.getEvents().stream().filter(e -> e instanceof Store || e instanceof Init).collect(Collectors.toSet());
		Set<Event> rEventsP2 = p2.getEvents().stream().filter(e -> e instanceof Load).collect(Collectors.toSet());
		Set<Event> wEventsP2 = p2.getEvents().stream().filter(e -> e instanceof Store || e instanceof Init).collect(Collectors.toSet());
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
		Set<Event> memEventsP1 = p1.getEvents().stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet());
		Set<Event> memEventsP2 = p2.getEvents().stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet());
		for(Event e1P1 : memEventsP1) {
			for(Event e1P2 : memEventsP2) {
				if(e1P1.getHLId().equals(e1P2.getHLId())) {
					for(Event e2P1 : memEventsP1) {
						for(Event e2P2 : memEventsP2) {
							if(e1P1.getMainThread() != e2P1.getMainThread()) {continue;}
							if(e1P2.getMainThread() != e2P2.getMainThread()) {continue;}
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
		Set<Location> locs = p.getEvents().stream().filter(e -> e instanceof MemEvent).map(e -> e.getLoc()).collect(Collectors.toSet());
		BoolExpr reachedState = ctx.mkTrue();
		for(Location loc : locs) {
			reachedState = ctx.mkAnd(reachedState, ctx.mkEq(lastValueLoc(loc, ctx), model.getConstInterp(lastValueLoc(loc, ctx))));
		}
		Set<Event> executedEvents = p.getEvents().stream().filter(e -> model.getConstInterp(e.executes(ctx)).isTrue()).collect(Collectors.toSet());
		Set<Register> regs = executedEvents.stream().filter(e -> e instanceof Local | e instanceof Load).map(e -> e.getReg()).collect(Collectors.toSet());
		for(Register reg : regs) {
			reachedState = ctx.mkAnd(reachedState, ctx.mkEq(lastValueReg(reg, ctx), model.getConstInterp(lastValueReg(reg, ctx))));
		}
		return reachedState;
	}

	public static BoolExpr getReachedStateLow(Program p, Model model, Context ctx) {
		Set<Location> locs = p.getEvents().stream().filter(e -> e instanceof MemEvent).map(e -> e.getLoc()).filter(l -> !(l instanceof HighLocation)).collect(Collectors.toSet());
		BoolExpr reachedState = ctx.mkTrue();
		for(Location loc : locs) {
			reachedState = ctx.mkAnd(reachedState, ctx.mkEq(lastValueLoc(loc, ctx), model.getConstInterp(lastValueLoc(loc, ctx))));
		}
		return reachedState;
	}

	public static BoolExpr getInitialHigh(Program p, Model model, Context ctx, boolean var1, boolean val1) {
		Set<Event> highInits = p.getEvents().stream().filter(e -> e instanceof Init).filter(e -> e.getLoc() instanceof HighLocation).collect(Collectors.toSet());
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

	public static BoolExpr getExecutedGuards(Program p, Model model, Context ctx) {
		BoolExpr enc = ctx.mkTrue();
		for(Event e : p.getEvents()) {
			if(model.getConstInterp(e.executes(ctx)).isTrue()) {
				enc = ctx.mkAnd(enc, e.getGuard());
			}
		}
		return enc;
	}

	public static BoolExpr getExecutedInstanciatedEvents(Program p, Model model, Context ctx) {
		BoolExpr enc = ctx.mkTrue();
		for(Event e : p.getEvents()) {
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
		Set<Event> highInits = p.getEvents().stream().filter(e -> e instanceof Init).filter(e -> e.getLoc() instanceof HighLocation).collect(Collectors.toSet());
		BoolExpr initState = ctx.mkTrue();
		for(Event e : highInits) {
			if(e.getLoc().getIValue() == null) {
				initState = ctx.mkAnd(initState, ctx.mkNot(ctx.mkEq(initValue(e,ctx), initValue2(e,ctx))));				
			}
		}
		return initState;
	}

	public static BoolExpr encodeMissingIndexes(If t, MapSSA map1, MapSSA map2, Context ctx) throws Z3Exception {

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
					index = ctx.mkEq(ctx.mkIntConst(String.format("%s_%s", o, i1)), ctx.mkIntConst(String.format("%s_%s", o, i2)));
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
					index = ctx.mkEq(ctx.mkIntConst(String.format("%s_%s", o, i2)), ctx.mkIntConst(String.format("%s_%s", o, i1)));
				}
				ret = ctx.mkAnd(ret, ctx.mkImplies(ctx.mkBoolConst(t.getT1().cfVar()), index));
			}
		}
		return ret;	
	}
	
	public static BoolExpr initsUniquePath(Program p, Context ctx) {
		BoolExpr prec = ctx.mkTrue();
		BoolExpr post = ctx.mkTrue();
		for(Event e : p.getEvents().stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet())) {
			prec = ctx.mkAnd(prec, ctx.mkOr(e.getGuard(), ctx.mkNot(e.executes(ctx))));
		}
		for(Event e : p.getEvents().stream().filter(e -> e instanceof Init && e.getLoc() instanceof HighLocation).collect(Collectors.toSet())) {
			BoolExpr guards = ctx.mkAnd(ctx.mkLt(ctx.mkSub(uniqueValue(e, ctx), ctx.mkInt(1)), initValue(e, ctx)), ctx.mkGt(ctx.mkAdd(uniqueValue(e, ctx), ctx.mkInt(1)), initValue(e, ctx)));
			post = ctx.mkAnd(post, guards);
		}
		return ctx.mkImplies(prec, post);
	}
}