package dartagnan.wmm;

import java.util.HashSet;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import com.microsoft.z3.*;

import dartagnan.program.Event;
import dartagnan.program.Init;
import dartagnan.program.Load;
import dartagnan.program.MemEvent;
import dartagnan.program.Program;
import dartagnan.program.Store;
import dartagnan.utils.Utils;

public class Encodings {

	public static BoolExpr satComp(String name, String r1, String r2, Set<Event> events, Context ctx) throws Z3Exception {
		BoolExpr enc = ctx.mkTrue();
		for(Event e1 : events) {
			for(Event e2 : events) {
				BoolExpr orClause = ctx.mkFalse();
				for(Event e3 : events) {
					orClause = ctx.mkOr(orClause, ctx.mkAnd(Utils.edge(r1, e1, e3, ctx), Utils.edge(r2, e3, e2, ctx)));
				}
				enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge(name, e1, e2, ctx), orClause));
			}
		}
		return enc;
	}

	public static BoolExpr satComp(String r1, String r2, Set<Event> events, Context ctx) throws Z3Exception {
		String name = String.format("(%s;%s)", r1, r2);
		return satComp(name, r1, r2, events, ctx);
	}
	
	public static BoolExpr satEmpty(String name, Set<Event> events, Context ctx) throws Z3Exception {
		BoolExpr enc = ctx.mkTrue();
		for(Event e1 : events) {
			for(Event e2 : events) {
				enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge(name, e1, e2, ctx)));
			}
		}
		return enc;
	}
	
	public static BoolExpr satUnion(String name, String r1, String r2, Set<Event> events, Context ctx) throws Z3Exception {
		BoolExpr enc = ctx.mkTrue();
		for(Event e1 : events) {
			for(Event e2 : events) {
				enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge(name, e1, e2, ctx), ctx.mkOr(Utils.edge(r1, e1, e2, ctx), Utils.edge(r2, e1, e2, ctx))));
			}
		}
		return enc;
	}
	
	public static BoolExpr satUnion(String r1, String r2, Set<Event> events, Context ctx) throws Z3Exception {
		String name = String.format("(%s+%s)", r1, r2);
		return satUnion(name, r1, r2, events, ctx);
	}

	public static BoolExpr satIntersection(String name, String r1, String r2, Set<Event> events, Context ctx) throws Z3Exception {
		BoolExpr enc = ctx.mkTrue();
		for(Event e1 : events) {
			for(Event e2 : events) {
				enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge(name, e1, e2, ctx), ctx.mkAnd(Utils.edge(r1, e1, e2, ctx), Utils.edge(r2, e1, e2, ctx))));
			}
		}
		return enc;
	}
	
	public static BoolExpr satIntersection(String r1, String r2, Set<Event> events, Context ctx) throws Z3Exception {
		String name = String.format("(%s&%s)", r1, r2);
		return satIntersection(name, r1, r2, events, ctx);
	}
	
	public static BoolExpr satMinus(String name, String r1, String r2, Set<Event> events, Context ctx) throws Z3Exception {
		BoolExpr enc = ctx.mkTrue();
		for(Event e1 : events) {
			for(Event e2 : events) {
				enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge(name, e1, e2, ctx), ctx.mkAnd(Utils.edge(r1, e1, e2, ctx), ctx.mkNot(Utils.edge(r2, e1, e2, ctx)))));
			}
		}
		return enc;
	}
	
	public static BoolExpr satMinus(String r1, String r2, Set<Event> events, Context ctx) throws Z3Exception {
		String name = String.format("(%s\\%s)", r1, r2);
		return satMinus(name, r1, r2, events, ctx);
	}
	
	public static BoolExpr satTO(String name, Set<Event> events, Context ctx) throws Z3Exception {
		BoolExpr enc = ctx.mkTrue();
		for(Event e1 : events) {
			enc = ctx.mkAnd(enc, ctx.mkImplies(e1.executes(ctx), ctx.mkGt(Utils.intVar(name, e1, ctx), ctx.mkInt(0))));
			enc = ctx.mkAnd(enc, ctx.mkImplies(e1.executes(ctx), ctx.mkLe(Utils.intVar(name, e1, ctx), ctx.mkInt(events.size()))));
			for(Event e2 : events) {
				enc = ctx.mkAnd(enc, ctx.mkImplies(Utils.edge(name, e1, e2, ctx),
												ctx.mkLt(Utils.intVar(name, e1, ctx), Utils.intVar(name, e2, ctx))));
				enc = ctx.mkAnd(enc, ctx.mkImplies(ctx.mkAnd(e1.executes(ctx), e2.executes(ctx)),
										ctx.mkImplies(ctx.mkLt(Utils.intVar(name, e1, ctx), Utils.intVar(name, e2, ctx)),
											Utils.edge(name, e1, e2, ctx))));
				if(e1 != e2) {
					enc = ctx.mkAnd(enc, ctx.mkImplies(ctx.mkAnd(e1.executes(ctx), e2.executes(ctx)),
							ctx.mkNot(ctx.mkEq(Utils.intVar(name, e1, ctx), Utils.intVar(name, e2, ctx)))));
					enc = ctx.mkAnd(enc, ctx.mkImplies(ctx.mkAnd(e1.executes(ctx), e2.executes(ctx)),
											ctx.mkOr(Utils.edge(name, e1, e2, ctx), Utils.edge(name, e2, e1, ctx))));
				}
			}
		}
		return enc;
	}

	public static BoolExpr satAcyclic(String name, Set<Event> events, Context ctx) throws Z3Exception {
		BoolExpr enc = ctx.mkTrue();
		for(Event e1 : events) {
			enc = ctx.mkAnd(enc, ctx.mkImplies(e1.executes(ctx), ctx.mkGt(Utils.intVar(name, e1, ctx), ctx.mkInt(0))));
			for(Event e2 : events) {
				enc = ctx.mkAnd(enc, ctx.mkImplies(Utils.edge(name, e1, e2, ctx), ctx.mkLt(Utils.intVar(name, e1, ctx), Utils.intVar(name, e2, ctx))));
			}
		}
		return enc;
	}
	
	public static BoolExpr satCycle(String name, Set<Event> events, Context ctx) throws Z3Exception {
		BoolExpr oneEventInCycle = ctx.mkFalse();
		for(Event e : events) {
			oneEventInCycle = ctx.mkOr(oneEventInCycle, Utils.cycleVar(name, e, ctx));
		}
		return oneEventInCycle;
	}
	
	public static BoolExpr satCycleDef(String name, Set<Event> events, Context ctx) throws Z3Exception {
		BoolExpr enc = ctx.mkTrue();
		for(Event e1 : events) {
			Set<BoolExpr> source = new HashSet<BoolExpr>();
			Set<BoolExpr> target = new HashSet<BoolExpr>();
			for(Event e2 : events) {
					source.add(Utils.cycleEdge(name, e1, e2, ctx));
					target.add(Utils.cycleEdge(name, e2, e1, ctx));
					enc = ctx.mkAnd(enc, ctx.mkImplies(Utils.cycleEdge(name, e1, e2, ctx),
							ctx.mkAnd(Utils.edge(name, e1, e2, ctx), Utils.cycleVar(name, e1, ctx), Utils.cycleVar(name, e2, ctx))));
				}
			enc = ctx.mkAnd(enc, ctx.mkImplies(Utils.cycleVar(name, e1, ctx), ctx.mkAnd(encodeEO(source, ctx), encodeEO(target, ctx))));
			}
		return enc;
	}
	
	public static BoolExpr satTransFixPoint(String name, Set<Event> events, Context ctx) throws Z3Exception {
		BoolExpr enc = ctx.mkTrue();
		int bound = (int) (Math.ceil(Math.log(events.size())) + 1);
		for(Event e1 : events) {
			for(Event e2 : events) {
				enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge(String.format("%s0", name), e1, e2, ctx), Utils.edge(name, e1, e2, ctx)));
				enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge(String.format("%s^+", name), e1, e2, ctx), 
											Utils.edge(String.format("%s%s", name, bound), e1, e2, ctx)));
			}
		}
		for (int i : IntStream.range(0, bound).toArray()) {
			for(Event e1 : events) {
				for(Event e2 : events) {
					BoolExpr orClause = ctx.mkFalse();
					for(Event e3 : events) {
						orClause = ctx.mkOr(orClause, ctx.mkAnd(Utils.edge(String.format("%s%s", name, i), e1, e3, ctx), 
																Utils.edge(String.format("%s%s", name, i), e3, e2, ctx)));
					}
					enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge(String.format("%s%s", name, i+1), e1, e2, ctx), ctx.mkOr(Utils.edge(name, e1, e2, ctx), orClause)));
				}
			}
		}
		return enc;
	}
	
	public static BoolExpr encodeEO(Set<BoolExpr> set, Context ctx) throws Z3Exception {
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

	public static BoolExpr encodeALO(Set<BoolExpr> set, Context ctx) throws Z3Exception {
		BoolExpr enc = ctx.mkFalse();
		for(BoolExpr exp : set) {
			enc = ctx.mkOr(enc, exp);
		}
		return enc;
	}

	public static BoolExpr satTransRef(String name, Set<Event> events, Context ctx) throws Z3Exception {
		BoolExpr enc = satTransFixPoint(name, events, ctx);
		enc = ctx.mkAnd(enc, satUnion(String.format("(%s)*", name), "id", String.format("%s^+", name), events, ctx));
		return enc;
	}


	public static BoolExpr satTransRef2(String name, Set<Event> events, Context ctx) throws Z3Exception {
		BoolExpr enc = ctx.mkTrue();
		for(Event e : events) {
			enc = ctx.mkAnd(enc, Utils.edge(String.format("(%s)", name), e, e, ctx));
		}
		for(Event e1 : events) {
			for(Event e2 : events) {
				enc = ctx.mkAnd(enc, ctx.mkImplies(Utils.edge(name, e1, e2, ctx), Utils.edge(String.format("(%s)*", name), e1, e2, ctx)));
				BoolExpr orClause = ctx.mkFalse();
				for(Event e3 : events) {
					orClause = ctx.mkOr(orClause, ctx.mkAnd(Utils.edge(String.format("(%s)*", name), e1, e3, ctx), Utils.edge(String.format("(%s)*", name), e3, e2, ctx)));
				}
				enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge(String.format("(%s)*", name), e1, e2, ctx), orClause));
			}
		}
		return enc;
	}

	public static BoolExpr satIrref(String name, Set<Event> events, Context ctx) throws Z3Exception {
	    BoolExpr enc = ctx.mkTrue();
	    for(Event e : events){
	    	enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge(name, e, e, ctx)));
	    }
	    return enc;
	}
	
	public static BoolExpr encodeCommonExecutions(Program p1, Program p2, Context ctx) throws Z3Exception {
		BoolExpr enc = ctx.mkTrue();
		Set<Event> memEventsP1 = p1.getEvents().stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet());
		Set<Event> memEventsP2 = p2.getEvents().stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet());
		Set<Event> rEventsP1 = p1.getEvents().stream().filter(e -> e instanceof Load).collect(Collectors.toSet());
		Set<Event> wEventsP1 = p1.getEvents().stream().filter(e -> e instanceof Store || e instanceof Init).collect(Collectors.toSet());
		Set<Event> rEventsP2 = p2.getEvents().stream().filter(e -> e instanceof Load).collect(Collectors.toSet());
		Set<Event> wEventsP2 = p2.getEvents().stream().filter(e -> e instanceof Store || e instanceof Init).collect(Collectors.toSet());
		for(Event e1 : memEventsP1) {
			for(Event e2 : memEventsP2) {
				if(((MemEvent) e1).hlId.equals(((MemEvent) e2).hlId)) {
					enc = ctx.mkAnd(enc, ctx.mkEq(e1.executes(ctx), e2.executes(ctx)));
				}	
			}
		}
		for(Event r1 : rEventsP1) {
			for(Event r2 : rEventsP2) {
				if(((MemEvent) r1).hlId.equals(((MemEvent) r2).hlId)) {
					for(Event w1 : wEventsP1) {
						for(Event w2 : wEventsP2) {
							if(r1.getLoc() != w1.getLoc()) {continue;}
							if(r2.getLoc() != w2.getLoc()) {continue;}
							if(((MemEvent) w1).hlId.equals(((MemEvent) w2).hlId)) {
								enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge("rf", w1, r1, ctx), Utils.edge("rf", w2, r2, ctx)));
							}
						}	
					}
				}
			}	
		}
		for(Event w1P1 : wEventsP1) {
			for(Event w1P2 : wEventsP2) {
				if(((MemEvent) w1P1).hlId.equals(((MemEvent) w1P2).hlId)) {
					for(Event w2P1 : wEventsP1) {
						for(Event w2P2 : wEventsP2) {
							if(w1P1.getLoc() != w2P1.getLoc()) {continue;}
							if(w1P1.getLoc() != w2P2.getLoc()) {continue;}
							if(w1P1 == w2P1 | w1P2 == w2P2) {continue;}
							if(((MemEvent) w2P1).hlId.equals(((MemEvent) w2P2).hlId)) {
								enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge("co", w1P1, w2P1, ctx), Utils.edge("co", w1P2, w2P2, ctx)));
							}
						}	
					}
				}
			}	
		}
		return enc;
	}

}