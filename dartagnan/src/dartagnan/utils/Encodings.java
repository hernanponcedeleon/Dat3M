package dartagnan.utils;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Model;
import dartagnan.program.memory.Location;
import dartagnan.program.Program;
import dartagnan.program.Register;
import dartagnan.program.event.Event;
import dartagnan.program.event.If;
import dartagnan.program.event.utils.RegWriter;
import dartagnan.program.utils.EventRepository;

import java.util.HashSet;
import java.util.Set;
import java.util.stream.Collectors;

import static dartagnan.utils.Utils.edge;
import static dartagnan.utils.Utils.ssaReg;

public class Encodings {

	public static BoolExpr encodeCommonExecutions(Program p1, Program p2, Context ctx) {
		BoolExpr enc = ctx.mkTrue();

		// TODO: With pointers, they do not necessarily point to the same memory address
		/*
		Set<Event> lEventsP1 = p1.getEventRepository().getEvents(EventRepository.MEMORY | EventRepository.LOCAL);
		Set<Event> lEventsP2 = p2.getEventRepository().getEvents(EventRepository.MEMORY | EventRepository.LOCAL);
		Set<Event> rEventsP1 = p1.getEventRepository().getEvents(EventRepository.LOAD);
		Set<Event> wEventsP1 = p1.getEventRepository().getEvents(EventRepository.STORE | EventRepository.INIT);
		Set<Event> rEventsP2 = p2.getEventRepository().getEvents(EventRepository.LOAD);
		Set<Event> wEventsP2 = p2.getEventRepository().getEvents(EventRepository.STORE | EventRepository.INIT);
		for(Event e1 : lEventsP1) {
			for(Event e2 : lEventsP2) {
				if(e1.getHLId() == e2.getHLId() && e1.getUnfCopy() == e2.getUnfCopy()) {
					enc = ctx.mkAnd(enc, ctx.mkEq(e1.executes(ctx), e2.executes(ctx)));
				}
			}
		}
		for(Event r1 : rEventsP1) {
			for(Event r2 : rEventsP2) {
				if(r1.getHLId() == r2.getHLId() && r1.getUnfCopy() == r2.getUnfCopy()) {
					for(Event w1 : wEventsP1) {
						for(Event w2 : wEventsP2) {
							if(r1.getLoc() != w1.getLoc()) {continue;}
							if(r2.getLoc() != w2.getLoc()) {continue;}
							if(w1.getHLId() == w2.getHLId() && w1.getUnfCopy() == w2.getUnfCopy()) {
								enc = ctx.mkAnd(enc, ctx.mkEq(edge("rf", w1, r1, ctx), edge("rf", w2, r2, ctx)));
							}
						}	
					}
				}
			}	
		}
		for(Event w1P1 : wEventsP1) {
			for(Event w1P2 : wEventsP2) {
				if(w1P1.getHLId() == w1P2.getHLId() && w1P1.getUnfCopy() == w1P2.getUnfCopy()) {
					for(Event w2P1 : wEventsP1) {
						for(Event w2P2 : wEventsP2) {
							if(w1P1.getLoc() != w2P1.getLoc()) {continue;}
							if(w1P1.getLoc() != w2P2.getLoc()) {continue;}
							if(w1P1 == w2P1 | w1P2 == w2P2) {continue;}
							if(w2P1.getHLId() == w2P2.getHLId() && w2P1.getUnfCopy() == w2P2.getUnfCopy()) {
								enc = ctx.mkAnd(enc, ctx.mkEq(edge("co", w1P1, w2P1, ctx), edge("co", w1P2, w2P2, ctx)));
							}
						}	
					}
				}
			}	
		}*/
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

	public static BoolExpr encodeMissingIndexes(If t, MapSSA map1, MapSSA map2, Context ctx) {

		BoolExpr ret = ctx.mkTrue();
		BoolExpr index = ctx.mkTrue();

		for(Object o : map1.keySet()) {
			int i1 = map1.get(o);
			int i2 = map2.get(o);
			if(i1 > i2) {
				if(o instanceof Register) {
					// If the ssa index of a register differs in the two branches
					// I need to maintain the value when the event is not executed
					// for testing reachability
					for(Event e : t.getEvents()) {
						if(e instanceof RegWriter && ((RegWriter)e).getSsaRegIndex() == i1 && ((RegWriter) e).getModifiedReg() == o){
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
			int i1 = map1.get(o);
			int i2 = map2.get(o);
			if(i2 > i1) {
				if(o instanceof Register) {
					for(Event e : t.getEvents()) {
						if(e instanceof RegWriter && ((RegWriter)e).getSsaRegIndex() == i2 && ((RegWriter) e).getModifiedReg() == o){
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