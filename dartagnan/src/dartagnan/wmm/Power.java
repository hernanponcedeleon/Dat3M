package dartagnan.wmm;

import static dartagnan.utils.Utils.edge;
import static dartagnan.utils.Utils.intCount;
import static dartagnan.wmm.EncodingsCAT.satIntersection;
import static dartagnan.wmm.EncodingsCAT.satUnion;
import static dartagnan.wmm.EncodingsCAT.satEmpty;
import static dartagnan.wmm.EncodingsCAT.satComp;
import static dartagnan.wmm.EncodingsCAT.satMinus;
import static dartagnan.wmm.EncodingsCAT.satTransRef;
import static dartagnan.wmm.EncodingsCAT.satIrref;
import static dartagnan.wmm.EncodingsCAT.satAcyclic;
import static dartagnan.wmm.EncodingsCAT.satTransFixPoint;
import static dartagnan.wmm.EncodingsCAT.satCycleDef;
import static dartagnan.wmm.EncodingsCAT.satCycle;

import java.util.Set;
import java.util.stream.Collectors;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;

import dartagnan.program.Event;
import dartagnan.program.Local;
import dartagnan.program.MemEvent;
import dartagnan.program.Program;

public class Power {
	
	public static BoolExpr encode(Program program, boolean approx, Context ctx) throws Z3Exception {
		Set<Event> events = program.getEvents().stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet());
		Set<Event> eventsL = program.getEvents().stream().filter(e -> e instanceof MemEvent || e instanceof Local).collect(Collectors.toSet());
		
		BoolExpr enc = satUnion("co", "fr", events, ctx);
		enc = ctx.mkAnd(enc, satUnion("com", "(co+fr)", "rf", events, ctx));
		enc = ctx.mkAnd(enc, satUnion("poloc", "com", events, ctx));
		
	    enc = ctx.mkAnd(enc, satTransFixPoint("idd", eventsL, approx, ctx));
	    
	    enc = ctx.mkAnd(enc, satIntersection("data", "idd^+", "RW", events, ctx));
	    enc = ctx.mkAnd(enc, satEmpty("addr", events, ctx));
	    enc = ctx.mkAnd(enc, satUnion("dp", "addr", "data", events, ctx));
	    enc = ctx.mkAnd(enc, satComp("fre", "rfe", events, ctx));
	    enc = ctx.mkAnd(enc, satComp("coe", "rfe", events, ctx));
    	
	    enc = ctx.mkAnd(enc, satIntersection("rdw", "poloc", "(fre;rfe)", events, ctx));
	    enc = ctx.mkAnd(enc, satIntersection("detour", "poloc", "(coe;rfe)", events,ctx));
	    // Base case for program order
	    enc = ctx.mkAnd(enc, satUnion("dp", "rdw", events, ctx));
	    enc = ctx.mkAnd(enc, satUnion("ii0", "(dp+rdw)", "rfi", events, ctx));
	    enc = ctx.mkAnd(enc, satEmpty("ic0", events, ctx));
	    enc = ctx.mkAnd(enc, satUnion("ci0", "ctrlisync", "detour", events, ctx));
	    enc = ctx.mkAnd(enc, satUnion("dp", "poloc", events, ctx));
	    enc = ctx.mkAnd(enc, satUnion("(dp+poloc)", "ctrl", events, ctx));
	    enc = ctx.mkAnd(enc, satComp("addr", "po", events, ctx));
	    enc = ctx.mkAnd(enc, satPowerPPO(events, ctx));
	    
	    enc = ctx.mkAnd(enc, satUnion("cc0", "((dp+poloc)+ctrl)", "(addr;po)", events, ctx));
	    enc = ctx.mkAnd(enc, satIntersection("RR", "ii", events, ctx));
	    enc = ctx.mkAnd(enc, satIntersection("RW", "ic", events, ctx));
	    enc = ctx.mkAnd(enc, satUnion("po-power", "(RR&ii)", "(RW&ic)", events, ctx));
	    // Fences in Power
	    enc = ctx.mkAnd(enc, satMinus("lwsync", "WR", events, ctx));
	    enc = ctx.mkAnd(enc, satUnion("fence-power", "sync", "(lwsync\\WR)", events, ctx));
	    // Happens before
	    enc = ctx.mkAnd(enc, satUnion("po-power", "rfe", events, ctx));
	    enc = ctx.mkAnd(enc, satUnion("hb-power", "(po-power+rfe)", "fence-power", events, ctx));
	    // Prop-base
	    enc = ctx.mkAnd(enc, satComp("rfe", "fence-power", events, ctx));
	    enc = ctx.mkAnd(enc, satUnion("fence-power", "(rfe;fence-power)", events, ctx));
	    enc = ctx.mkAnd(enc, satTransRef("hb-power", events, approx, ctx));
	    enc = ctx.mkAnd(enc, satComp("prop-base", "(fence-power+(rfe;fence-power))", "(hb-power)*", events, ctx));
	    // Propagation for Power
	    enc = ctx.mkAnd(enc, satTransRef("com", events, approx, ctx));

	    enc = ctx.mkAnd(enc, satTransRef("prop-base", events, approx, ctx));
	    enc = ctx.mkAnd(enc, satComp("(com)*", "(prop-base)*", events, ctx));
	    enc = ctx.mkAnd(enc, satComp("((com)*;(prop-base)*)", "sync", events, ctx));
	    enc = ctx.mkAnd(enc, satComp("(((com)*;(prop-base)*);sync)", "(hb-power)*", events, ctx));
	    enc = ctx.mkAnd(enc, satIntersection("WW", "prop-base", events, ctx));
	    enc = ctx.mkAnd(enc, satUnion("prop", "(WW&prop-base)", "((((com)*;(prop-base)*);sync);(hb-power)*)", events, ctx));
	    enc = ctx.mkAnd(enc, satComp("fre", "prop", events, ctx));
	    enc = ctx.mkAnd(enc, satComp("(fre;prop)", "(hb-power)*", events, ctx));
	    enc = ctx.mkAnd(enc, satUnion("co", "prop", events, ctx));
	    return enc;
	}
	
	public static BoolExpr Consistent(Program program, Context ctx) throws Z3Exception {
		Set<Event> events = program.getEvents().stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet());
	    return ctx.mkAnd(satAcyclic("hb-power", events, ctx),
	    				satIrref("((fre;prop);(hb-power)*)", events, ctx),
	    				satAcyclic("(co+prop)", events, ctx),
	    				satAcyclic("(poloc+com)", events, ctx));
	}

	public static BoolExpr Inconsistent(Program program, Context ctx) throws Z3Exception {
		Set<Event> events = program.getEvents().stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet());
		BoolExpr enc = ctx.mkAnd(satCycleDef("hb-power", events, ctx), 
								satCycleDef("(co+prop)", events, ctx),
								satCycleDef("(poloc+com)", events, ctx));
		enc = ctx.mkAnd(enc, ctx.mkOr(satCycle("hb-power", events, ctx),
									ctx.mkNot(satIrref("((fre;prop);(hb-power)*)", events, ctx)),
									satCycle("(co+prop)", events, ctx),
									satCycle("(poloc+com)", events, ctx)));
		return enc;
	}
	
	private static BoolExpr satPowerPPO(Set<Event> events, boolean approx, Context ctx) throws Z3Exception {
		BoolExpr enc = ctx.mkTrue();
		for(Event e1 : events) {
			for(Event e2 : events) {
				BoolExpr orClause1 = ctx.mkFalse();
				BoolExpr orClause2 = ctx.mkFalse();
				BoolExpr orClause3 = ctx.mkFalse();
				BoolExpr orClause4 = ctx.mkFalse();
				BoolExpr orClause5 = ctx.mkFalse();
				BoolExpr orClause6 = ctx.mkFalse();
				BoolExpr orClause7 = ctx.mkFalse();
				BoolExpr orClause8 = ctx.mkFalse();
				for(Event e3 : events) {
	    	        orClause1 = ctx.mkOr(orClause1, ctx.mkAnd(edge("ic",e1,e3, ctx), edge("ci",e3,e2, ctx)));
	    	    	orClause2 = ctx.mkOr(orClause2, ctx.mkAnd(edge("ii",e1,e3, ctx), edge("ii",e3,e2, ctx)));
	    	        orClause3 = ctx.mkOr(orClause3, ctx.mkAnd(edge("ic",e1,e3, ctx), edge("cc",e3,e2, ctx)));
	    	    	orClause4 = ctx.mkOr(orClause4, ctx.mkAnd(edge("ii",e1,e3, ctx), edge("ic",e3,e2, ctx)));
	    	    	orClause5 = ctx.mkOr(orClause5, ctx.mkAnd(edge("ci",e1,e3, ctx), edge("ii",e3,e2, ctx)));
	    	    	orClause6 = ctx.mkOr(orClause6, ctx.mkAnd(edge("cc",e1,e3, ctx), edge("ci",e3,e2, ctx)));
	    	    	orClause7 = ctx.mkOr(orClause7, ctx.mkAnd(edge("ci",e1,e3, ctx), edge("ic",e3,e2, ctx)));
	    	    	orClause8 = ctx.mkOr(orClause8, ctx.mkAnd(edge("cc",e1,e3, ctx), edge("cc",e3,e2, ctx)));
					
				}
    	        enc = ctx.mkAnd(enc, ctx.mkEq(edge("(ic;ci)",e1,e2, ctx), orClause1));
    	        enc = ctx.mkAnd(enc, ctx.mkEq(edge("(ii;ii)",e1,e2, ctx), orClause2));
    	        enc = ctx.mkAnd(enc, ctx.mkEq(edge("(ic;cc)",e1,e2, ctx), orClause3));
    	        enc = ctx.mkAnd(enc, ctx.mkEq(edge("(ii;ic)",e1,e2, ctx), orClause4));
    	        enc = ctx.mkAnd(enc, ctx.mkEq(edge("(ci;ii)",e1,e2, ctx), orClause5));
    	        enc = ctx.mkAnd(enc, ctx.mkEq(edge("(cc;ci)",e1,e2, ctx), orClause6));
    	        enc = ctx.mkAnd(enc, ctx.mkEq(edge("(ci;ic)",e1,e2, ctx), orClause7));
    	        enc = ctx.mkAnd(enc, ctx.mkEq(edge("(cc;cc)",e1,e2, ctx), orClause8));
    	        
    	        enc = ctx.mkAnd(enc, ctx.mkEq(edge("ii",e1,e2, ctx), ctx.mkOr(edge("ii0",e1,e2, ctx), edge("ci",e1,e2, ctx), edge("(ic;ci)",e1,e2, ctx), edge("(ii;ii)",e1,e2, ctx))));
    	        enc = ctx.mkAnd(enc, ctx.mkEq(edge("ic",e1,e2, ctx), ctx.mkOr(edge("ic0",e1,e2, ctx), edge("ii",e1,e2, ctx), edge("cc",e1,e2, ctx), edge("(ic;cc)",e1,e2, ctx), edge("(ii;ic)",e1,e2, ctx))));
    	        enc = ctx.mkAnd(enc, ctx.mkEq(edge("ci",e1,e2, ctx), ctx.mkOr(edge("ci0",e1,e2, ctx), edge("(ci;ii)",e1,e2, ctx), edge("(cc;ci)",e1,e2, ctx))));
    	        enc = ctx.mkAnd(enc, ctx.mkEq(edge("cc",e1,e2, ctx), ctx.mkOr(edge("cc0",e1,e2, ctx), edge("ci",e1,e2, ctx), edge("(ci;ic)",e1,e2, ctx), edge("(cc;cc)",e1,e2, ctx))));

    	        if(approx) {
                    enc = ctx.mkAnd(enc, ctx.mkEq(edge("ii", e1, e2, ctx), 
                    		ctx.mkOr(edge("ii0", e1, e2, ctx),
                    				 edge("ci", e1, e2, ctx),
                    				 edge("ic;ci", e1, e2, ctx),
                    				 edge("ii;ii", e1, e2, ctx))));

                    enc = ctx.mkAnd(enc, ctx.mkEq(edge("ic", e1, e2, ctx), 
                    		ctx.mkOr(edge("ic0", e1, e2, ctx),
                    				 edge("ii", e1, e2, ctx),
                    				 edge("cc", e1, e2, ctx),
                    				 edge("ic;cc", e1, e2, ctx),
                    				 edge("ii;ic", e1, e2, ctx))));

                    enc = ctx.mkAnd(enc, ctx.mkEq(edge("ci", e1, e2, ctx), 
                    		ctx.mkOr(edge("ci0", e1, e2, ctx),
                    				 edge("ci;ii", e1, e2, ctx),
                    				 edge("cc;ci", e1, e2, ctx))));
                    
                    enc = ctx.mkAnd(enc, ctx.mkEq(edge("cc", e1, e2, ctx), 
                    		ctx.mkOr(edge("cc0", e1, e2, ctx),
                    				 edge("ci", e1, e2, ctx), 
                    				 edge("ci;ic", e1, e2, ctx), 
                    				 edge("cc;cc", e1, e2, ctx))));
    	        } else {
	    	        enc = ctx.mkAnd(enc, ctx.mkEq(edge("ii",e1,e2, ctx), 
	    	        		ctx.mkOr(ctx.mkAnd(edge("ii0",e1,e2, ctx), ctx.mkGt(intCount("ii",e1,e2, ctx), intCount("ii0",e1,e2, ctx))),
	    	        				 ctx.mkAnd(edge("ci",e1,e2, ctx), ctx.mkGt(intCount("ii",e1,e2, ctx), intCount("ci",e1,e2, ctx))),
	    	        				 ctx.mkAnd(edge("(ic;ci)",e1,e2, ctx), ctx.mkGt(intCount("ii",e1,e2, ctx), intCount("(ic;ci)",e1,e2, ctx))),
	    	        				 ctx.mkAnd(edge("(ii;ii)",e1,e2, ctx), ctx.mkGt(intCount("ii",e1,e2, ctx), intCount("(ii;ii)",e1,e2, ctx))))));
	
					enc = ctx.mkAnd(enc, ctx.mkEq(edge("ic",e1,e2, ctx), 
							ctx.mkOr(ctx.mkAnd(edge("ic0",e1,e2, ctx), ctx.mkGt(intCount("ic",e1,e2, ctx), intCount("ic0",e1,e2, ctx))),
									 ctx.mkAnd(edge("ii",e1,e2, ctx), ctx.mkGt(intCount("ic",e1,e2, ctx), intCount("ii",e1,e2, ctx))),
									 ctx.mkAnd(edge("cc",e1,e2, ctx), ctx.mkGt(intCount("ic",e1,e2, ctx), intCount("cc",e1,e2, ctx))),
									 ctx.mkAnd(edge("(ic;cc)",e1,e2, ctx), ctx.mkGt(intCount("ic",e1,e2, ctx), intCount("(ic;cc)",e1,e2, ctx))),
									 ctx.mkAnd(edge("(ii;ic)",e1,e2, ctx), ctx.mkGt(intCount("ic",e1,e2, ctx), intCount("(ii;ic)",e1,e2, ctx))))));
					                                             
					enc = ctx.mkAnd(enc, ctx.mkEq(edge("ci",e1,e2, ctx), ctx.
								mkOr(ctx.mkAnd(edge("ci0",e1,e2, ctx), ctx.mkGt(intCount("ci",e1,e2, ctx), intCount("ci0",e1,e2, ctx))),
									 ctx.mkAnd(edge("(ci;ii)",e1,e2, ctx), ctx.mkGt(intCount("ci",e1,e2, ctx), intCount("(ci;ii)",e1,e2, ctx))),
									 ctx.mkAnd(edge("(cc;ci)",e1,e2, ctx), ctx.mkGt(intCount("ci",e1,e2, ctx), intCount("(cc;ci)",e1,e2, ctx))))));
					                                                                                          
					enc = ctx.mkAnd(enc, ctx.mkEq(edge("cc",e1,e2, ctx), 
								ctx.mkOr(ctx.mkAnd(edge("cc0",e1,e2, ctx), ctx.mkGt(intCount("cc",e1,e2, ctx), intCount("cc0",e1,e2, ctx))),
										 ctx.mkAnd(edge("ci",e1,e2, ctx), ctx.mkGt(intCount("cc",e1,e2, ctx), intCount("ci",e1,e2, ctx))),
										 ctx.mkAnd(edge("(ci;ic)",e1,e2, ctx), ctx.mkGt(intCount("cc",e1,e2, ctx), intCount("(ci;ic)",e1,e2, ctx))),
										 ctx.mkAnd(edge("(cc;cc)",e1,e2, ctx), ctx.mkGt(intCount("cc",e1,e2, ctx), intCount("(cc;cc)",e1,e2, ctx))))));
    	        }
			}
		}
 	    return enc;
	}
}