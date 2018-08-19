package dartagnan.wmm.arch;

import static dartagnan.utils.Utils.edge;
import static dartagnan.utils.Utils.intCount;
import static dartagnan.wmm.EncodingsCAT.satIntersection;
import static dartagnan.wmm.EncodingsCAT.satUnion;
import static dartagnan.wmm.EncodingsCAT.satEmpty;
import static dartagnan.wmm.EncodingsCAT.satComp;
import static dartagnan.wmm.EncodingsCAT.satTransRef;
import static dartagnan.wmm.EncodingsCAT.satIrref;
import static dartagnan.wmm.Encodings.satAcyclic;
import static dartagnan.wmm.EncodingsCAT.satTransFixPoint;
import static dartagnan.wmm.Encodings.satCycleDef;
import static dartagnan.wmm.Encodings.satCycle;
import static dartagnan.wmm.EncodingsCAT.satTransIDL;
import static dartagnan.wmm.EncodingsCAT.satTransRefIDL;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Set;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;

import dartagnan.program.event.Event;
import dartagnan.program.Program;
import dartagnan.program.event.filter.FilterBasic;
import dartagnan.program.utils.EventRepository;
import dartagnan.utils.Utils;
import dartagnan.wmm.relation.RelCartesian;
import dartagnan.wmm.WmmInterface;
import dartagnan.wmm.relation.RelFencerel;
import dartagnan.wmm.relation.Relation;
import dartagnan.wmm.relation.basic.RelCtrl;
import dartagnan.wmm.relation.basic.RelIdd;

public class ARM implements WmmInterface {

	private Collection<Relation> relations = new ArrayList<>(Arrays.asList(
			new RelIdd(),
			new RelCtrl(),
			new RelFencerel("Isb", "isb"),
			new RelFencerel("Ish", "ish"),
			new RelCartesian(new FilterBasic("R"), new FilterBasic("W"), "RW").setEventMask(EventRepository.EVENT_MEMORY),
			new RelCartesian(new FilterBasic("R"), new FilterBasic("R"), "RR").setEventMask(EventRepository.EVENT_MEMORY),
			new RelCartesian(new FilterBasic("W"), new FilterBasic("W"), "WW").setEventMask(EventRepository.EVENT_MEMORY)
	));
	
	public BoolExpr encode(Program program, Context ctx, boolean approx, boolean idl) throws Z3Exception {
		if(program.hasRMWEvents()){
			throw new RuntimeException("RMW is not implemented for ARM");
		}

		EventRepository eventRepository = program.getEventRepository();
		Set<Event> events = eventRepository.getEvents(EventRepository.EVENT_MEMORY);
		Set<Event> eventsL = eventRepository.getEvents(EventRepository.EVENT_MEMORY | EventRepository.EVENT_LOCAL | EventRepository.EVENT_IF);
		Set<Event> eventsS = eventRepository.getEvents(EventRepository.EVENT_MEMORY | EventRepository.EVENT_SKIP);

		BoolExpr enc = satIntersection("ctrlisb", "ctrl", "isb", eventsS, ctx);
		enc = ctx.mkAnd(enc, satIntersection("rfe", "rf", "ext", events, ctx));
		enc = ctx.mkAnd(enc, satIntersection("rfi", "rf", "int", events, ctx));
		enc = ctx.mkAnd(enc, satIntersection("coe", "co", "ext", events, ctx));
		enc = ctx.mkAnd(enc, satIntersection("fre", "fr", "ext", events, ctx));
		enc = ctx.mkAnd(enc, satIntersection("po-loc", "po", "loc", events, ctx));

		enc = ctx.mkAnd(enc, satUnion("co", "fr", events, ctx));
		enc = ctx.mkAnd(enc, satUnion("com", "(co+fr)", "rf", events, ctx));
		enc = ctx.mkAnd(enc, satUnion("po-loc", "com", events, ctx));

		if (idl) {
		    enc = ctx.mkAnd(enc, satTransIDL("idd", eventsL, approx, ctx));			
		} else {
			enc = ctx.mkAnd(enc, satTransFixPoint("idd", eventsL, approx, ctx));	
		}

	    enc = ctx.mkAnd(enc, satIntersection("data", "idd^+", "RW", events, ctx));
	    enc = ctx.mkAnd(enc, satEmpty("addr", events, ctx));
	    enc = ctx.mkAnd(enc, satUnion("dp", "addr", "data", events, ctx));
	    enc = ctx.mkAnd(enc, satComp("fre", "rfe", events, ctx));
	    enc = ctx.mkAnd(enc, satComp("coe", "rfe", events, ctx));
    	
	    enc = ctx.mkAnd(enc, satIntersection("rdw", "po-loc", "(fre;rfe)", events, ctx));
	    enc = ctx.mkAnd(enc, satIntersection("detour", "po-loc", "(coe;rfe)", events,ctx));
	    // Base case for program order
	    enc = ctx.mkAnd(enc, satUnion("dp", "rdw", events, ctx));
	    enc = ctx.mkAnd(enc, satUnion("ii0", "(dp+rdw)", "rfi", events, ctx));
	    enc = ctx.mkAnd(enc, satEmpty("ic0", events, ctx));
	    enc = ctx.mkAnd(enc, satUnion("ci0", "ctrlisb", "detour", events, ctx));
	    enc = ctx.mkAnd(enc, satUnion("dp", "ctrl", events, ctx));
	    enc = ctx.mkAnd(enc, satComp("addr", "po", events, ctx));
	    enc = ctx.mkAnd(enc, satARMPPO(events, approx, ctx));
	    
	    enc = ctx.mkAnd(enc, satUnion("cc0", "(dp+ctrl)", "(addr;po)", events, ctx));
	    enc = ctx.mkAnd(enc, satIntersection("RR", "ii", events, ctx));
	    enc = ctx.mkAnd(enc, satIntersection("RW", "ic", events, ctx));
	    enc = ctx.mkAnd(enc, satUnion("po-arm", "(RR&ii)", "(RW&ic)", events, ctx));
	    // Happens before
	    enc = ctx.mkAnd(enc, satUnion("po-arm", "rfe", events, ctx));
	    enc = ctx.mkAnd(enc, satUnion("hb-arm", "(po-arm+rfe)", "ish", events, ctx));
	    // Prop-base
	    enc = ctx.mkAnd(enc, satComp("rfe", "ish", events, ctx));
	    enc = ctx.mkAnd(enc, satUnion("ish", "(rfe;ish)", events, ctx));
	    if (idl) {
		    enc = ctx.mkAnd(enc, satTransRefIDL("hb-arm", events, approx, ctx));	    	
	    } else {
		    enc = ctx.mkAnd(enc, satTransRef("hb-arm", events, approx, ctx));
	    }
	    enc = ctx.mkAnd(enc, satComp("prop-base", "(ish+(rfe;ish))", "(hb-arm)*", events, ctx));
	    // Propagation for ARM
	    if (idl) {
		    enc = ctx.mkAnd(enc, satTransRefIDL("com", events, approx, ctx));	    	
	    } else {
		    enc = ctx.mkAnd(enc, satTransRef("com", events, approx, ctx));
	    }
        
	    if (idl) {
		    enc = ctx.mkAnd(enc, satTransRefIDL("prop-base", events, approx, ctx));	    	
	    } else {
		    enc = ctx.mkAnd(enc, satTransRef("prop-base", events, approx, ctx));
	    }
	    enc = ctx.mkAnd(enc, satComp("(com)*", "(prop-base)*", events, ctx));
	    enc = ctx.mkAnd(enc, satComp("((com)*;(prop-base)*)", "ish", events, ctx));
	    enc = ctx.mkAnd(enc, satComp("(((com)*;(prop-base)*);ish)", "(hb-arm)*", events, ctx));
	    enc = ctx.mkAnd(enc, satIntersection("WW", "prop-base", events, ctx));
	    enc = ctx.mkAnd(enc, satUnion("prop", "(WW&prop-base)", "((((com)*;(prop-base)*);ish);(hb-arm)*)", events, ctx));
	    enc = ctx.mkAnd(enc, satComp("fre", "prop", events, ctx));
	    enc = ctx.mkAnd(enc, satComp("(fre;prop)", "(hb-arm)*", events, ctx));
	    enc = ctx.mkAnd(enc, satUnion("co", "prop", events, ctx));

		for(Relation relation : relations){
			enc = ctx.mkAnd(enc, relation.encode(program, ctx, null));
		}

	    return enc;
	}
	
	public BoolExpr Consistent(Program program, Context ctx) throws Z3Exception {
		Set<Event> events = program.getEventRepository().getEvents(EventRepository.EVENT_MEMORY);
	    return ctx.mkAnd(satAcyclic("hb-arm", events, ctx),
	    				satIrref("((fre;prop);(hb-arm)*)", events, ctx),
	    				satAcyclic("(co+prop)", events, ctx),
	    				satAcyclic("(po-loc+com)", events, ctx));
	}

	public BoolExpr Inconsistent(Program program, Context ctx) throws Z3Exception {
		Set<Event> events = program.getEventRepository().getEvents(EventRepository.EVENT_MEMORY);
		BoolExpr enc = ctx.mkAnd(satCycleDef("hb-arm", events, ctx), 
								satCycleDef("(co+prop)", events, ctx),
								satCycleDef("(po-loc+com)", events, ctx));
		enc = ctx.mkAnd(enc, ctx.mkOr(satCycle("hb-arm", events, ctx),
									ctx.mkNot(satIrref("((fre;prop);(hb-arm)*)", events, ctx)),
									satCycle("(co+prop)", events, ctx),
									satCycle("(po-loc+com)", events, ctx)));
		return enc;
	}
	
	private BoolExpr satARMPPO(Set<Event> events, boolean approx, Context ctx) throws Z3Exception {
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
	    	        orClause1 = ctx.mkOr(orClause1, ctx.mkAnd(Utils.edge("ic",e1,e3, ctx), edge("ci",e3,e2, ctx)));
	    	    	orClause2 = ctx.mkOr(orClause2, ctx.mkAnd(Utils.edge("ii",e1,e3, ctx), edge("ii",e3,e2, ctx)));
	    	        orClause3 = ctx.mkOr(orClause3, ctx.mkAnd(Utils.edge("ic",e1,e3, ctx), edge("cc",e3,e2, ctx)));
	    	    	orClause4 = ctx.mkOr(orClause4, ctx.mkAnd(Utils.edge("ii",e1,e3, ctx), edge("ic",e3,e2, ctx)));
	    	    	orClause5 = ctx.mkOr(orClause5, ctx.mkAnd(Utils.edge("ci",e1,e3, ctx), edge("ii",e3,e2, ctx)));
	    	    	orClause6 = ctx.mkOr(orClause6, ctx.mkAnd(Utils.edge("cc",e1,e3, ctx), edge("ci",e3,e2, ctx)));
	    	    	orClause7 = ctx.mkOr(orClause7, ctx.mkAnd(Utils.edge("ci",e1,e3, ctx), edge("ic",e3,e2, ctx)));
	    	    	orClause8 = ctx.mkOr(orClause8, ctx.mkAnd(Utils.edge("cc",e1,e3, ctx), edge("cc",e3,e2, ctx)));
					
				}
    	        enc = ctx.mkAnd(enc, ctx.mkEq(edge("ic;ci",e1,e2, ctx), orClause1));
    	        enc = ctx.mkAnd(enc, ctx.mkEq(edge("ii;ii",e1,e2, ctx), orClause2));
    	        enc = ctx.mkAnd(enc, ctx.mkEq(edge("ic;cc",e1,e2, ctx), orClause3));
    	        enc = ctx.mkAnd(enc, ctx.mkEq(edge("ii;ic",e1,e2, ctx), orClause4));
    	        enc = ctx.mkAnd(enc, ctx.mkEq(edge("ci;ii",e1,e2, ctx), orClause5));
    	        enc = ctx.mkAnd(enc, ctx.mkEq(edge("cc;ci",e1,e2, ctx), orClause6));
    	        enc = ctx.mkAnd(enc, ctx.mkEq(edge("ci;ic",e1,e2, ctx), orClause7));
    	        enc = ctx.mkAnd(enc, ctx.mkEq(edge("cc;cc",e1,e2, ctx), orClause8));
    	        
    	        enc = ctx.mkAnd(enc, ctx.mkEq(edge("ii",e1,e2, ctx), ctx.mkOr(edge("ii0",e1,e2, ctx), edge("ci",e1,e2, ctx), edge("ic;ci",e1,e2, ctx), edge("ii;ii",e1,e2, ctx))));
    	        enc = ctx.mkAnd(enc, ctx.mkEq(edge("ic",e1,e2, ctx), ctx.mkOr(edge("ic0",e1,e2, ctx), edge("ii",e1,e2, ctx), edge("cc",e1,e2, ctx), edge("ic;cc",e1,e2, ctx), edge("ii;ic",e1,e2, ctx))));
    	        enc = ctx.mkAnd(enc, ctx.mkEq(edge("ci",e1,e2, ctx), ctx.mkOr(edge("ci0",e1,e2, ctx), edge("ci;ii",e1,e2, ctx), edge("cc;ci",e1,e2, ctx))));
    	        enc = ctx.mkAnd(enc, ctx.mkEq(edge("cc",e1,e2, ctx), ctx.mkOr(edge("cc0",e1,e2, ctx), edge("ci",e1,e2, ctx), edge("ci;ic",e1,e2, ctx), edge("cc;cc",e1,e2, ctx))));
    	        
    	        if(approx) {
        	        enc = ctx.mkAnd(enc, ctx.mkImplies(edge("ii",e1,e2, ctx), 
        	        		ctx.mkOr(edge("ii0",e1,e2, ctx), 
							  edge("ci",e1,e2, ctx),
							  edge("ic;ci",e1,e2, ctx),
							  edge("ii;ii",e1,e2, ctx))));

        	        enc = ctx.mkAnd(enc, ctx.mkImplies(edge("ic",e1,e2, ctx), 
        	        		ctx.mkOr(edge("ic0",e1,e2, ctx),
							   edge("ii",e1,e2, ctx),
							   edge("cc",e1,e2, ctx),
							   edge("ic;cc",e1,e2, ctx),
							   edge("ii;ic",e1,e2, ctx))));

        	        enc = ctx.mkAnd(enc, ctx.mkImplies(edge("ci",e1,e2, ctx), 
        	        		ctx.mkOr(edge("ci0",e1,e2, ctx),
							   edge("ci;ii",e1,e2, ctx),
							   edge("cc;ci",e1,e2, ctx))));
                                    
        	        enc = ctx.mkAnd(enc, ctx.mkImplies(edge("cc",e1,e2, ctx), 
        	        		ctx.mkOr(edge("cc0",e1,e2, ctx),
							   edge("ci",e1,e2, ctx),
							   edge("ci;ic",e1,e2, ctx),
							   edge("cc;cc",e1,e2, ctx))));    	        	
    	        } else {
        	        enc = ctx.mkAnd(enc, ctx.mkImplies(edge("ii",e1,e2, ctx), 
        	        		ctx.mkOr(ctx.mkAnd(edge("ii0",e1,e2, ctx), ctx.mkGt(intCount("ii",e1,e2, ctx), intCount("ii0",e1,e2, ctx))),
        	        				 ctx.mkAnd(edge("ci",e1,e2, ctx), ctx.mkGt(intCount("ii",e1,e2, ctx), intCount("ci",e1,e2, ctx))),
        	        				 ctx.mkAnd(edge("ic;ci",e1,e2, ctx), ctx.mkGt(intCount("ii",e1,e2, ctx), intCount("ic;ci",e1,e2, ctx))),
        	        				 ctx.mkAnd(edge("ii;ii",e1,e2, ctx), ctx.mkGt(intCount("ii",e1,e2, ctx), intCount("ii;ii",e1,e2, ctx))))));
    
        	        enc = ctx.mkAnd(enc, ctx.mkImplies(edge("ic",e1,e2, ctx), 
        	        		ctx.mkOr(ctx.mkAnd(edge("ic0",e1,e2, ctx), ctx.mkGt(intCount("ic",e1,e2, ctx), intCount("ic0",e1,e2, ctx))),
        	        				 ctx.mkAnd(edge("ii",e1,e2, ctx), ctx.mkGt(intCount("ic",e1,e2, ctx), intCount("ii",e1,e2, ctx))),
        	        				 ctx.mkAnd(edge("cc",e1,e2, ctx), ctx.mkGt(intCount("ic",e1,e2, ctx), intCount("cc",e1,e2, ctx))),
        	        				 ctx.mkAnd(edge("ic;cc",e1,e2, ctx), ctx.mkGt(intCount("ic",e1,e2, ctx), intCount("ic;cc",e1,e2, ctx))),
        	        				 ctx.mkAnd(edge("ii;ic",e1,e2, ctx), ctx.mkGt(intCount("ic",e1,e2, ctx), intCount("ii;ic",e1,e2, ctx))))));
                                                 
        	        enc = ctx.mkAnd(enc, ctx.mkImplies(edge("ci",e1,e2, ctx), 
        	        		ctx.mkOr(ctx.mkAnd(edge("ci0",e1,e2, ctx), ctx.mkGt(intCount("ci",e1,e2, ctx), intCount("ci0",e1,e2, ctx))),
        	        				 ctx.mkAnd(edge("ci;ii",e1,e2, ctx), ctx.mkGt(intCount("ci",e1,e2, ctx), intCount("ci;ii",e1,e2, ctx))),
        	        				 ctx.mkAnd(edge("cc;ci",e1,e2, ctx), ctx.mkGt(intCount("ci",e1,e2, ctx), intCount("cc;ci",e1,e2, ctx))))));
                                                                                              
        	        enc = ctx.mkAnd(enc, ctx.mkImplies(edge("cc",e1,e2, ctx), 
        	        		ctx.mkOr(ctx.mkAnd(edge("cc0",e1,e2, ctx), ctx.mkGt(intCount("cc",e1,e2, ctx), intCount("cc0",e1,e2, ctx))),
        	        				 ctx.mkAnd(edge("ci",e1,e2, ctx), ctx.mkGt(intCount("cc",e1,e2, ctx), intCount("ci",e1,e2, ctx))),
        	        				 ctx.mkAnd(edge("ci;ic",e1,e2, ctx), ctx.mkGt(intCount("cc",e1,e2, ctx), intCount("ci;ic",e1,e2, ctx))),
        	        				 ctx.mkAnd(edge("cc;cc",e1,e2, ctx), ctx.mkGt(intCount("cc",e1,e2, ctx), intCount("cc;cc",e1,e2, ctx))))));
        	        
        	        enc = ctx.mkAnd(enc, ctx.mkImplies(edge("ii",e1,e2, ctx), 
        	        		ctx.mkOr(edge("ii0",e1,e2, ctx), 
							  edge("ci",e1,e2, ctx),
							  edge("ic;ci",e1,e2, ctx),
							  edge("ii;ii",e1,e2, ctx))));

        	        enc = ctx.mkAnd(enc, ctx.mkImplies(edge("ic",e1,e2, ctx), 
        	        		ctx.mkOr(edge("ic0",e1,e2, ctx),
							   edge("ii",e1,e2, ctx),
							   edge("cc",e1,e2, ctx),
							   edge("ic;cc",e1,e2, ctx),
							   edge("ii;ic",e1,e2, ctx))));

        	        enc = ctx.mkAnd(enc, ctx.mkImplies(edge("ci",e1,e2, ctx), 
        	        		ctx.mkOr(edge("ci0",e1,e2, ctx),
							   edge("ci;ii",e1,e2, ctx),
							   edge("cc;ci",e1,e2, ctx))));
                                    
        	        enc = ctx.mkAnd(enc, ctx.mkImplies(edge("cc",e1,e2, ctx), 
        	        		ctx.mkOr(edge("cc0",e1,e2, ctx),
							   edge("ci",e1,e2, ctx),
							   edge("ci;ic",e1,e2, ctx),
							   edge("cc;cc",e1,e2, ctx))));    
    	        }
			}
		}
 	    return enc;
	}
}
