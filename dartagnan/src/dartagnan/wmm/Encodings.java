package dartagnan.wmm;

import static dartagnan.utils.Utils.edge;
import static java.lang.String.format;

import java.util.Collection;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;
import java.util.stream.Collectors;

import com.microsoft.z3.*;

import dartagnan.asserts.*;
import dartagnan.program.*;
import dartagnan.program.event.*;
import dartagnan.program.utils.EventRepository;
import dartagnan.utils.Utils;

public class Encodings {

	public static BoolExpr satTO(String name, Collection<Event> events, Context ctx) throws Z3Exception {
		BoolExpr enc = ctx.mkTrue();
		for(Event e1 : events) {
			enc = ctx.mkAnd(enc, ctx.mkImplies(e1.executes(ctx), ctx.mkGt(Utils.intVar(name, e1, ctx), ctx.mkInt(0))));
			enc = ctx.mkAnd(enc, ctx.mkImplies(e1.executes(ctx), ctx.mkLe(Utils.intVar(name, e1, ctx), ctx.mkInt(events.size()))));
			for(Event e2 : events) {
				enc = ctx.mkAnd(enc, ctx.mkImplies(edge(name, e1, e2, ctx),
												ctx.mkLt(Utils.intVar(name, e1, ctx), Utils.intVar(name, e2, ctx))));
				enc = ctx.mkAnd(enc, ctx.mkImplies(ctx.mkAnd(e1.executes(ctx), e2.executes(ctx)),
										ctx.mkImplies(ctx.mkLt(Utils.intVar(name, e1, ctx), Utils.intVar(name, e2, ctx)),
											edge(name, e1, e2, ctx))));
				if(e1 != e2) {
					enc = ctx.mkAnd(enc, ctx.mkImplies(ctx.mkAnd(e1.executes(ctx), e2.executes(ctx)),
							ctx.mkNot(ctx.mkEq(Utils.intVar(name, e1, ctx), Utils.intVar(name, e2, ctx)))));
					enc = ctx.mkAnd(enc, ctx.mkImplies(ctx.mkAnd(e1.executes(ctx), e2.executes(ctx)),
											ctx.mkOr(edge(name, e1, e2, ctx), edge(name, e2, e1, ctx))));
				}
			}
		}
		return enc;
	}

	public static BoolExpr satAcyclic(String name, Collection<Event> events, Context ctx) throws Z3Exception {
		BoolExpr enc = ctx.mkTrue();
		for(Event e1 : events) {
			enc = ctx.mkAnd(enc, ctx.mkImplies(e1.executes(ctx), ctx.mkGt(Utils.intVar(name, e1, ctx), ctx.mkInt(0))));
			for(Event e2 : events) {
				enc = ctx.mkAnd(enc, ctx.mkImplies(edge(name, e1, e2, ctx), ctx.mkLt(Utils.intVar(name, e1, ctx), Utils.intVar(name, e2, ctx))));
			}
		}
		return enc;
	}
	
	public static BoolExpr satCycle(String name, Collection<Event> events, Context ctx) throws Z3Exception {
		BoolExpr oneEventInCycle = ctx.mkFalse();
		for(Event e : events) {
			oneEventInCycle = ctx.mkOr(oneEventInCycle, Utils.cycleVar(name, e, ctx));
		}
		return oneEventInCycle;
	}
	
	public static BoolExpr satCycleDef(String name, Collection<Event> events, Context ctx) throws Z3Exception {
		BoolExpr enc = ctx.mkTrue();
		for(Event e1 : events) {
			Set<BoolExpr> source = new HashSet<BoolExpr>();
			Set<BoolExpr> target = new HashSet<BoolExpr>();
			for(Event e2 : events) {
					source.add(Utils.cycleEdge(name, e1, e2, ctx));
					target.add(Utils.cycleEdge(name, e2, e1, ctx));
					enc = ctx.mkAnd(enc, ctx.mkImplies(Utils.cycleEdge(name, e1, e2, ctx),
							ctx.mkAnd(e1.executes(ctx), e2.executes(ctx), edge(name, e1, e2, ctx), Utils.cycleVar(name, e1, ctx), Utils.cycleVar(name, e2, ctx))));
				}
			enc = ctx.mkAnd(enc, ctx.mkImplies(Utils.cycleVar(name, e1, ctx), ctx.mkAnd(encodeEO(source, ctx), encodeEO(target, ctx))));
			}
		return enc;
	}
	
	public static BoolExpr encodeEO(Collection<BoolExpr> set, Context ctx) throws Z3Exception {
		BoolExpr enc = ctx.mkFalse();
		for(BoolExpr exp : set) {
			BoolExpr thisYesOthersNot = exp;
			for(BoolExpr x : set.stream().filter(x -> x != exp).collect(Collectors.toSet())) {
				thisYesOthersNot = ctx.mkAnd(thisYesOthersNot, ctx.mkNot(x));
			}
			enc = ctx.mkOr(enc, thisYesOthersNot);
		}
		return enc;
	}

	public static BoolExpr encodeALO(Collection<BoolExpr> set, Context ctx) throws Z3Exception {
		BoolExpr enc = ctx.mkFalse();
		for(BoolExpr exp : set) {
			enc = ctx.mkOr(enc, exp);
		}
		return enc;
	}

	public static BoolExpr encodeCommonExecutions(Program p1, Program p2, Context ctx) throws Z3Exception {
		BoolExpr enc = ctx.mkTrue();
		Set<Event> lEventsP1 = p1.getEventRepository().getEvents(EventRepository.EVENT_MEMORY | EventRepository.EVENT_LOCAL);
		Set<Event> lEventsP2 = p2.getEventRepository().getEvents(EventRepository.EVENT_MEMORY | EventRepository.EVENT_LOCAL);
		Set<Event> rEventsP1 = p1.getEventRepository().getEvents(EventRepository.EVENT_LOAD);
		Set<Event> wEventsP1 = p1.getEventRepository().getEvents(EventRepository.EVENT_STORE | EventRepository.EVENT_INIT);
		Set<Event> rEventsP2 = p2.getEventRepository().getEvents(EventRepository.EVENT_LOAD);
		Set<Event> wEventsP2 = p2.getEventRepository().getEvents(EventRepository.EVENT_STORE | EventRepository.EVENT_INIT);
		for(Event e1 : lEventsP1) {
			for(Event e2 : lEventsP2) {
				if(e1.getHLId().equals(e2.getHLId())) {
					enc = ctx.mkAnd(enc, ctx.mkEq(e1.executes(ctx), e2.executes(ctx)));
				}	
			}
		}
		for(Event r1 : rEventsP1) {
			for(Event r2 : rEventsP2) {
				if(r1.getHLId().equals(r2.getHLId())) {
					for(Event w1 : wEventsP1) {
						for(Event w2 : wEventsP2) {
							if(r1.getLoc() != w1.getLoc()) {continue;}
							if(r2.getLoc() != w2.getLoc()) {continue;}
							if(w1.getHLId().equals(w2.getHLId())) {
								enc = ctx.mkAnd(enc, ctx.mkEq(edge("rf", w1, r1, ctx), edge("rf", w2, r2, ctx)));
							}
						}	
					}
				}
			}	
		}
		for(Event w1P1 : wEventsP1) {
			for(Event w1P2 : wEventsP2) {
				if(w1P1.getHLId().equals(w1P2.getHLId())) {
					for(Event w2P1 : wEventsP1) {
						for(Event w2P2 : wEventsP2) {
							if(w1P1.getLoc() != w2P1.getLoc()) {continue;}
							if(w1P1.getLoc() != w2P2.getLoc()) {continue;}
							if(w1P1 == w2P1 | w1P2 == w2P2) {continue;}
							if(w2P1.getHLId().equals(w2P2.getHLId())) {
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

	public static AbstractAssert AssertFromModel(Program p, Model model, Context ctx) {
		AssertCompositeAnd ass = new AssertCompositeAnd();
		Set<Location> locs = p.getEventRepository().getEvents(EventRepository.EVENT_MEMORY).stream().map(e -> e.getLoc()).collect(Collectors.toSet());
		for(Location loc : locs) {
			ass.addChild(new AssertLocation(loc, Integer.valueOf(model.getConstInterp(ctx.mkIntConst(loc.getName() + "_final")).toString())));
		}
		Set<Event> executedEvents = p.getEventRepository().getEvents(EventRepository.EVENT_ALL).stream().filter(e -> model.getConstInterp(e.executes(ctx)).isTrue()).collect(Collectors.toSet());
		Set<Register> regs = executedEvents.stream().filter(e -> e instanceof Local | e instanceof Load).map(e -> e.getReg()).collect(Collectors.toSet());
		for(Register reg : regs) {
			Set<Integer> ssaRegIndexes = new HashSet<Integer>();
			for(Event e : executedEvents) {
				if(!(e instanceof Load | e instanceof Local)) {continue;}
				if(e.getReg() != reg) {continue;}
				ssaRegIndexes.add(e.getSsaRegIndex());
			}
			Integer lastRegIndex = Collections.max(ssaRegIndexes);
			String regVarName = format("T%s_%s_%s", reg.getMainThread(), reg.getName(), lastRegIndex);
			ass.addChild(new AssertRegister(reg.getMainThread().toString(), reg, Integer.valueOf(model.getConstInterp(ctx.mkIntConst(regVarName)).toString())));
		}
		return ass;
	}

	public static BoolExpr encodeReachedState(Program p, Model model, Context ctx) {
		Set<Location> locs = p.getEventRepository().getEvents(EventRepository.EVENT_MEMORY).stream().map(e -> e.getLoc()).collect(Collectors.toSet());
		BoolExpr reachedState = ctx.mkTrue();
		for(Location loc : locs) {
			reachedState = ctx.mkAnd(reachedState, ctx.mkEq(ctx.mkIntConst(loc.getName() + "_final"), model.getConstInterp(ctx.mkIntConst(loc.getName() + "_final"))));
		}
		Set<Event> executedEvents = p.getEventRepository().getEvents(EventRepository.EVENT_ALL).stream().filter(e -> model.getConstInterp(e.executes(ctx)).isTrue()).collect(Collectors.toSet());
		Set<Register> regs = executedEvents.stream().filter(e -> e instanceof Local | e instanceof Load).map(e -> e.getReg()).collect(Collectors.toSet());
		for(Register reg : regs) {
			Set<Integer> ssaRegIndexes = new HashSet<Integer>();
			for(Event e : executedEvents) {
				if(!(e instanceof Load | e instanceof Local)) {continue;}
				if(e.getReg() != reg) {continue;}
				ssaRegIndexes.add(e.getSsaRegIndex());
			}
			Integer lastRegIndex = Collections.max(ssaRegIndexes);
			String regVarName = format("T%s_%s_%s", reg.getMainThread(), reg.getName(), lastRegIndex);
			reachedState = ctx.mkAnd(reachedState, ctx.mkEq(ctx.mkIntConst(regVarName), model.getConstInterp(ctx.mkIntConst(regVarName))));
		}
		return reachedState;
	}
}