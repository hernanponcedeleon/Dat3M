package dartagnan.wmm;

import static dartagnan.utils.Utils.edge;
import static dartagnan.utils.Utils.intCount;

import java.util.Collection;
import java.util.stream.IntStream;

import static java.lang.String.format;

import com.microsoft.z3.*;

import dartagnan.program.event.Event;

public class EncodingsCAT {

	public static BoolExpr satComp(String name, String r1, String r2, Collection<Event> events, Context ctx) throws Z3Exception {
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

	public static BoolExpr satComp(String r1, String r2, Collection<Event> events, Context ctx) throws Z3Exception {
		String name = format("(%s;%s)", r1, r2);
		return satComp(name, r1, r2, events, ctx);
	}
	
	public static BoolExpr satEmpty(String name, Collection<Event> events, Context ctx) throws Z3Exception {
		BoolExpr enc = ctx.mkTrue();
		for(Event e1 : events) {
			for(Event e2 : events) {
				enc = ctx.mkAnd(enc, ctx.mkNot(edge(name, e1, e2, ctx)));
			}
		}
		return enc;
	}
	
	public static BoolExpr satUnion(String name, String r1, String r2, Collection<Event> events, Context ctx) throws Z3Exception {
		BoolExpr enc = ctx.mkTrue();
		for(Event e1 : events) {
			for(Event e2 : events) {
				enc = ctx.mkAnd(enc, ctx.mkEq(edge(name, e1, e2, ctx), ctx.mkOr(edge(r1, e1, e2, ctx), edge(r2, e1, e2, ctx))));
			}
		}
		return enc;
	}
	
	public static BoolExpr satUnion(String r1, String r2, Collection<Event> events, Context ctx) throws Z3Exception {
		String name = format("(%s+%s)", r1, r2);
		return satUnion(name, r1, r2, events, ctx);
	}

	public static BoolExpr satIntersection(String name, String r1, String r2, Collection<Event> events, Context ctx) throws Z3Exception {
		BoolExpr enc = ctx.mkTrue();
		for(Event e1 : events) {
			for(Event e2 : events) {
				enc = ctx.mkAnd(enc, ctx.mkEq(edge(name, e1, e2, ctx), ctx.mkAnd(edge(r1, e1, e2, ctx), edge(r2, e1, e2, ctx))));
			}
		}
		return enc;
	}
	
	public static BoolExpr satIntersection(String r1, String r2, Collection<Event> events, Context ctx) throws Z3Exception {
		String name = format("(%s&%s)", r1, r2);
		return satIntersection(name, r1, r2, events, ctx);
	}
	
	public static BoolExpr satMinus(String name, String r1, String r2, Collection<Event> events, Context ctx) throws Z3Exception {
		BoolExpr enc = ctx.mkTrue();
		for(Event e1 : events) {
			for(Event e2 : events) {
				enc = ctx.mkAnd(enc, ctx.mkEq(edge(name, e1, e2, ctx), ctx.mkAnd(edge(r1, e1, e2, ctx), ctx.mkNot(edge(r2, e1, e2, ctx)))));
			}
		}
		return enc;
	}
	
	public static BoolExpr satMinus(String r1, String r2, Collection<Event> events, Context ctx) throws Z3Exception {
		String name = format("(%s\\%s)", r1, r2);
		return satMinus(name, r1, r2, events, ctx);
	}
	
	public static BoolExpr satTransFixPoint(String name, Collection<Event> events, boolean approx, Context ctx) throws Z3Exception {
		BoolExpr enc = ctx.mkTrue();
        if (approx) {
            for (Event e1 : events) {
                for (Event e2 : events) {
                    //transitive
                    BoolExpr orClause = ctx.mkFalse();
                    for (Event e3 : events) {
                        orClause = ctx.mkOr(orClause, ctx.mkAnd(edge(format("%s^+", name), e1, e3, ctx), edge(format("%s^+", name), e3, e2, ctx)));
                    }
                    //original relation
                    orClause = ctx.mkOr(orClause, edge(name, e1, e2, ctx));
                    //putting it together:
                    enc = ctx.mkAnd(enc, ctx.mkEq(edge(format("%s^+", name), e1, e2, ctx), orClause));
                }
            }
        } else {
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
	        }
		return enc;
	}
	
	public static BoolExpr satTransRef(String name, Collection<Event> events, boolean approx, Context ctx) throws Z3Exception {
		BoolExpr enc = satTransFixPoint(name, events, approx, ctx);
		enc = ctx.mkAnd(enc, satUnion(format("(%s)*", name), "id", format("%s^+", name), events, ctx));
		return enc;
	}

	public static BoolExpr satTransIDL(String name, Collection<Event> events, boolean approx, Context ctx) throws Z3Exception {
		BoolExpr enc = ctx.mkTrue();
		for(Event e1 : events) {
			for(Event e2 : events) {
		        if (approx) {
                    //transitive
                    BoolExpr orClause = ctx.mkFalse();
                    for (Event e3 : events) {
                        orClause = ctx.mkOr(orClause, ctx.mkAnd(edge(format("%s^+", name), e1, e3, ctx), edge(format("%s^+", name), e3, e2, ctx)));
                    }
                    //original relation
                    orClause = ctx.mkOr(orClause, edge(name, e1, e2, ctx));
                    //putting it together:
                    enc = ctx.mkAnd(enc, ctx.mkEq(edge(format("%s^+", name), e1, e2, ctx), orClause));
                } else {
					BoolExpr orClause = ctx.mkFalse();
					for(Event e3 : events) {
						orClause = ctx.mkOr(orClause, ctx.mkAnd(edge(format("%s^+", name), e1, e3, ctx), edge(format("%s^+", name), e3, e2, ctx)));
					}
					enc = ctx.mkAnd(enc, ctx.mkEq(edge(format("(%s^+;%s^+)", name, name), e1, e2, ctx), orClause));
	    	        enc = ctx.mkAnd(enc, ctx.mkEq(edge(format("%s^+", name),e1,e2, ctx), ctx.mkOr(
	    	        		ctx.mkAnd(edge(name,e1,e2, ctx), ctx.mkGt(intCount(format("%s^+", name),e1,e2, ctx), intCount(name,e1,e2, ctx))),
	                        ctx.mkAnd(edge(format("(%s^+;%s^+)", name, name),e1,e2, ctx), ctx.mkGt(intCount(format("%s^+", name),e1,e2, ctx), intCount(format("(%s^+;%s^+)", name, name),e1,e2, ctx))))));			
	    	        enc = ctx.mkAnd(enc, ctx.mkEq(edge(format("%s^+", name),e1,e2, ctx), ctx.mkOr(edge(name,e1,e2, ctx), edge(format("(%s^+;%s^+)", name, name),e1,e2, ctx))));			
                }
			}
		}
		return enc;
	}
	
	public static BoolExpr satTransRefIDL(String name, Collection<Event> events, boolean approx, Context ctx) throws Z3Exception {
		BoolExpr enc = satTransIDL(name, events, approx, ctx);
		enc = ctx.mkAnd(enc, satUnion(format("(%s)*", name), "id", format("%s^+", name), events, ctx));
		return enc;
	}
	
	public static BoolExpr satIrref(String name, Collection<Event> events, Context ctx) throws Z3Exception {
	    BoolExpr enc = ctx.mkTrue();
	    for(Event e : events){
	    	enc = ctx.mkAnd(enc, ctx.mkNot(edge(name, e, e, ctx)));
	    }
	    return enc;
	}	
}