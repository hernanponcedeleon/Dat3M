package dartagnan.wmm;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.event.Event;
import dartagnan.utils.Utils;

import java.util.Collection;
import java.util.HashSet;
import java.util.Set;
import java.util.stream.Collectors;

import static dartagnan.utils.Utils.edge;

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
}