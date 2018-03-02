package dartagnan.wmm;

import static dartagnan.utils.Utils.edge;
import static dartagnan.utils.Utils.cycleEdge;
import static dartagnan.utils.Utils.cycleVar;
import static dartagnan.utils.Utils.intVar;

import java.util.HashSet;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import static java.lang.String.format;

import com.microsoft.z3.*;

import dartagnan.program.Event;

public class EncodingsCAT {

	public static BoolExpr satComp(String name, String r1, String r2, Set<Event> events, Context ctx) throws Z3Exception {
		BoolExpr enc = ctx.mkTrue();
		for(Event e1 : events) {
			for(Event e2 : events) {
				BoolExpr orClause = ctx.mkFalse();
				for(Event e3 : events) {
					orClause = ctx.mkOr(orClause, ctx.mkAnd(edge(r1, e1, e3, ctx), edge(r2, e3, e2, ctx)));
				}
				enc = ctx.mkAnd(enc, ctx.mkEq(edge(name, e1, e2, ctx), orClause));
			}
		}
		return enc;
	}

	public static BoolExpr satComp(String r1, String r2, Set<Event> events, Context ctx) throws Z3Exception {
		String name = format("(%s;%s)", r1, r2);
		return satComp(name, r1, r2, events, ctx);
	}
	
	public static BoolExpr satEmpty(String name, Set<Event> events, Context ctx) throws Z3Exception {
		BoolExpr enc = ctx.mkTrue();
		for(Event e1 : events) {
			for(Event e2 : events) {
				enc = ctx.mkAnd(enc, ctx.mkNot(edge(name, e1, e2, ctx)));
			}
		}
		return enc;
	}
	
	public static BoolExpr satUnion(String name, String r1, String r2, Set<Event> events, Context ctx) throws Z3Exception {
		BoolExpr enc = ctx.mkTrue();
		for(Event e1 : events) {
			for(Event e2 : events) {
				enc = ctx.mkAnd(enc, ctx.mkEq(edge(name, e1, e2, ctx), ctx.mkOr(edge(r1, e1, e2, ctx), edge(r2, e1, e2, ctx))));
			}
		}
		return enc;
	}
	
	public static BoolExpr satUnion(String r1, String r2, Set<Event> events, Context ctx) throws Z3Exception {
		String name = format("(%s+%s)", r1, r2);
		return satUnion(name, r1, r2, events, ctx);
	}

	public static BoolExpr satIntersection(String name, String r1, String r2, Set<Event> events, Context ctx) throws Z3Exception {
		BoolExpr enc = ctx.mkTrue();
		for(Event e1 : events) {
			for(Event e2 : events) {
				enc = ctx.mkAnd(enc, ctx.mkEq(edge(name, e1, e2, ctx), ctx.mkAnd(edge(r1, e1, e2, ctx), edge(r2, e1, e2, ctx))));
			}
		}
		return enc;
	}
	
	public static BoolExpr satIntersection(String r1, String r2, Set<Event> events, Context ctx) throws Z3Exception {
		String name = format("(%s&%s)", r1, r2);
		return satIntersection(name, r1, r2, events, ctx);
	}
	
	public static BoolExpr satMinus(String name, String r1, String r2, Set<Event> events, Context ctx) throws Z3Exception {
		BoolExpr enc = ctx.mkTrue();
		for(Event e1 : events) {
			for(Event e2 : events) {
				enc = ctx.mkAnd(enc, ctx.mkEq(edge(name, e1, e2, ctx), ctx.mkAnd(edge(r1, e1, e2, ctx), ctx.mkNot(edge(r2, e1, e2, ctx)))));
			}
		}
		return enc;
	}
	
	public static BoolExpr satMinus(String r1, String r2, Set<Event> events, Context ctx) throws Z3Exception {
		String name = format("(%s\\%s)", r1, r2);
		return satMinus(name, r1, r2, events, ctx);
	}
	
	public static BoolExpr satTO(String name, Set<Event> events, Context ctx) throws Z3Exception {
		BoolExpr enc = ctx.mkTrue();
		for(Event e1 : events) {
			enc = ctx.mkAnd(enc, ctx.mkImplies(e1.executes(ctx), ctx.mkGt(intVar(name, e1, ctx), ctx.mkInt(0))));
			enc = ctx.mkAnd(enc, ctx.mkImplies(e1.executes(ctx), ctx.mkLe(intVar(name, e1, ctx), ctx.mkInt(events.size()))));
			for(Event e2 : events) {
				enc = ctx.mkAnd(enc, ctx.mkImplies(edge(name, e1, e2, ctx),
												ctx.mkLt(intVar(name, e1, ctx), intVar(name, e2, ctx))));
				enc = ctx.mkAnd(enc, ctx.mkImplies(ctx.mkAnd(e1.executes(ctx), e2.executes(ctx)),
										ctx.mkImplies(ctx.mkLt(intVar(name, e1, ctx), intVar(name, e2, ctx)),
											edge(name, e1, e2, ctx))));
				if(e1 != e2) {
					enc = ctx.mkAnd(enc, ctx.mkImplies(ctx.mkAnd(e1.executes(ctx), e2.executes(ctx)),
							ctx.mkNot(ctx.mkEq(intVar(name, e1, ctx), intVar(name, e2, ctx)))));
					enc = ctx.mkAnd(enc, ctx.mkImplies(ctx.mkAnd(e1.executes(ctx), e2.executes(ctx)),
											ctx.mkOr(edge(name, e1, e2, ctx), edge(name, e2, e1, ctx))));
				}
			}
		}
		return enc;
	}

	public static BoolExpr satAcyclic(String name, Set<Event> events, Context ctx) throws Z3Exception {
		BoolExpr enc = ctx.mkTrue();
		for(Event e1 : events) {
			enc = ctx.mkAnd(enc, ctx.mkImplies(e1.executes(ctx), ctx.mkGt(intVar(name, e1, ctx), ctx.mkInt(0))));
			for(Event e2 : events) {
				enc = ctx.mkAnd(enc, ctx.mkImplies(edge(name, e1, e2, ctx), ctx.mkLt(intVar(name, e1, ctx), intVar(name, e2, ctx))));
			}
		}
		return enc;
	}
	
	public static BoolExpr satCycle(String name, Set<Event> events, Context ctx) throws Z3Exception {
		BoolExpr oneEventInCycle = ctx.mkFalse();
		for(Event e : events) {
			oneEventInCycle = ctx.mkOr(oneEventInCycle, cycleVar(name, e, ctx));
		}
		return oneEventInCycle;
	}
	
	public static BoolExpr satCycleDef(String name, Set<Event> events, Context ctx) throws Z3Exception {
		BoolExpr enc = ctx.mkTrue();
		for(Event e1 : events) {
			Set<BoolExpr> source = new HashSet<BoolExpr>();
			Set<BoolExpr> target = new HashSet<BoolExpr>();
			for(Event e2 : events) {
					source.add(cycleEdge(name, e1, e2, ctx));
					target.add(cycleEdge(name, e2, e1, ctx));
					enc = ctx.mkAnd(enc, ctx.mkImplies(cycleEdge(name, e1, e2, ctx),
							ctx.mkAnd(e1.executes(ctx), e2.executes(ctx), edge(name, e1, e2, ctx), cycleVar(name, e1, ctx), cycleVar(name, e2, ctx))));
				}
			enc = ctx.mkAnd(enc, ctx.mkImplies(cycleVar(name, e1, ctx), ctx.mkAnd(encodeEO(source, ctx), encodeEO(target, ctx))));
			}
		return enc;
	}
	
	public static BoolExpr satTransFixPoint(String name, Set<Event> events, Context ctx) throws Z3Exception {
		BoolExpr enc = ctx.mkTrue();
		int bound = (int) (Math.ceil(Math.log(events.size())) + 1);
		for(Event e1 : events) {
			for(Event e2 : events) {
				enc = ctx.mkAnd(enc, ctx.mkEq(edge(format("%s0", name), e1, e2, ctx), edge(name, e1, e2, ctx)));
				enc = ctx.mkAnd(enc, ctx.mkEq(edge(format("%s^+", name), e1, e2, ctx), edge(format("%s%s", name, bound), e1, e2, ctx)));
			}
		}
		for (int i : IntStream.range(0, bound).toArray()) {
			for(Event e1 : events) {
				for(Event e2 : events) {
					BoolExpr orClause = ctx.mkFalse();
					for(Event e3 : events) {
						orClause = ctx.mkOr(orClause, ctx.mkAnd(edge(format("%s%s", name, i), e1, e3, ctx), 
																edge(format("%s%s", name, i), e3, e2, ctx)));
					}
					enc = ctx.mkAnd(enc, ctx.mkEq(edge(format("%s%s", name, i+1), e1, e2, ctx), ctx.mkOr(edge(name, e1, e2, ctx), orClause)));
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

	public static BoolExpr satTransRef(String name, Set<Event> events, Context ctx) throws Z3Exception {
		BoolExpr enc = satTransFixPoint(name, events, ctx);
		enc = ctx.mkAnd(enc, satUnion(format("(%s)*", name), "id", format("%s^+", name), events, ctx));
		return enc;
	}

	public static BoolExpr satIrref(String name, Set<Event> events, Context ctx) throws Z3Exception {
	    BoolExpr enc = ctx.mkTrue();
	    for(Event e : events){
	    	enc = ctx.mkAnd(enc, ctx.mkNot(edge(name, e, e, ctx)));
	    }
	    return enc;
	}	
}