package dartagnan.wmm;

import static dartagnan.utils.Utils.edge;
import static dartagnan.utils.Utils.intVar;
import static dartagnan.utils.Utils.lastValueLoc;
import static dartagnan.utils.Utils.lastValueReg;
import static dartagnan.utils.Utils.ssaReg;
import static dartagnan.wmm.EncodingsCAT.satTO;
import static dartagnan.wmm.EncodingsCAT.encodeEO;

import java.util.HashSet;
import java.util.Set;
import java.util.stream.Collectors;

import com.microsoft.z3.*;

import dartagnan.expression.AConst;
import dartagnan.program.Barrier;
import dartagnan.program.Event;
import dartagnan.program.Init;
import dartagnan.program.Isb;
import dartagnan.program.Ish;
import dartagnan.program.Isync;
import dartagnan.program.Load;
import dartagnan.program.Local;
import dartagnan.program.Location;
import dartagnan.program.Lwsync;
import dartagnan.program.MemEvent;
import dartagnan.program.Mfence;
import dartagnan.program.Program;
import dartagnan.program.Register;
import dartagnan.program.Store;
import dartagnan.program.Sync;

public class Domain {
	
	public static BoolExpr encode(Program program, Context ctx) throws Z3Exception {
		BoolExpr enc = ctx.mkTrue();
		
		Set<Event> mEvents = program.getEvents().stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet());
		Set<Event> barriers = program.getEvents().stream().filter(e -> e instanceof Barrier).collect(Collectors.toSet());
		Set<Event> eventsL = program.getEvents().stream().filter(e -> e instanceof MemEvent || e instanceof Local).collect(Collectors.toSet());

		for(Event e : eventsL) {
				enc = ctx.mkAnd(enc, ctx.mkNot(edge("ii", e, e, ctx)));
				enc = ctx.mkAnd(enc, ctx.mkNot(edge("ic", e, e, ctx)));
				enc = ctx.mkAnd(enc, ctx.mkNot(edge("ci", e, e, ctx)));
				enc = ctx.mkAnd(enc, ctx.mkNot(edge("cc", e, e, ctx)));
		}
		
		for(Event e1 : mEvents) {
			for(Event e2 : mEvents) {
				enc = ctx.mkAnd(enc, ctx.mkImplies(edge("rf", e1, e2, ctx), ctx.mkAnd(e1.executes(ctx), e2.executes(ctx))));
				enc = ctx.mkAnd(enc, ctx.mkImplies(edge("co", e1, e2, ctx), ctx.mkAnd(e1.executes(ctx), e2.executes(ctx))));
				if(!(e1 instanceof Init)) {
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("IM", e1, e2, ctx)));
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("IW", e1, e2, ctx)));
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("IR", e1, e2, ctx)));
				}
				else {
					enc = ctx.mkAnd(enc, edge("IM", e1, e2, ctx));
				}
				if(!(e2 instanceof Init)) {
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("MI", e1, e2, ctx)));
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("WI", e1, e2, ctx)));
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("RI", e1, e2, ctx)));
				}
				else {
					enc = ctx.mkAnd(enc, edge("MI", e1, e2, ctx));
				}
				if(!(e1 instanceof Load)) {
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("RM", e1, e2, ctx)));
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("RW", e1, e2, ctx)));
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("RR", e1, e2, ctx)));
				}
				else {
					enc = ctx.mkAnd(enc, edge("RM", e1, e2, ctx));
				}
				if(!(e2 instanceof Load)) {
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("MR", e1, e2, ctx)));
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("WR", e1, e2, ctx)));
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("RR", e1, e2, ctx)));
				}
				else {
					enc = ctx.mkAnd(enc, edge("MR", e1, e2, ctx));
				}
				if(!(e1 instanceof Store || e1 instanceof Init)) {
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("WM", e1, e2, ctx)));
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("WW", e1, e2, ctx)));
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("WR", e1, e2, ctx)));
				}
				else {
					enc = ctx.mkAnd(enc, edge("WM", e1, e2, ctx));
				}
				if(!(e2 instanceof Store || e2 instanceof Init)) {
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("MW", e1, e2, ctx)));
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("WW", e1, e2, ctx)));
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("RW", e1, e2, ctx)));
				}
				else {
					enc = ctx.mkAnd(enc, edge("MW", e1, e2, ctx));
				}
				if(e1 instanceof Load && e2 instanceof Load) {
					enc = ctx.mkAnd(enc, edge("RR", e1, e2, ctx));
				}
				if(e1 instanceof Load && (e2 instanceof Init || e2 instanceof Store)) {
					enc = ctx.mkAnd(enc, edge("RW", e1, e2, ctx));
				}
				if((e1 instanceof Init || e1 instanceof Store) && (e2 instanceof Init || e2 instanceof Store)) {
					enc = ctx.mkAnd(enc, edge("WW", e1, e2, ctx));
				}
				if((e1 instanceof Init || e1 instanceof Store) && e2 instanceof Load) {
					enc = ctx.mkAnd(enc, edge("WR", e1, e2, ctx));
				}
				if(e1 == e2) {
					enc = ctx.mkAnd(enc, edge("id", e1, e2, ctx));	
				}
				else {
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("id", e1, e2, ctx)));
				}
				if(e1.getMainThread() == e2.getMainThread()) {
					enc = ctx.mkAnd(enc, edge("int", e1, e2, ctx));
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("ext", e1, e2, ctx)));
					if(e1.getEId() < e2.getEId()) {
						enc = ctx.mkAnd(enc, edge("po", e1, e2, ctx));
						if(e1.getCondLevel() < e2.getCondLevel() && e1 instanceof Load && e2.getCondRegs().contains(e1.getReg())) {
							enc = ctx.mkAnd(enc, edge("ctrlDirect", e1, e2, ctx));
						}
						else {
							enc = ctx.mkAnd(enc, ctx.mkNot(edge("ctrlDirect", e1, e2, ctx)));								
						}
					}
					else {
						enc = ctx.mkAnd(enc, ctx.mkNot(edge("po", e1, e2, ctx)));
						enc = ctx.mkAnd(enc, ctx.mkNot(edge("ctrl", e1, e2, ctx)));
					}
					boolean noMfence = true;
					boolean noSync = true;
					boolean noLwsync = true;
					boolean noIsync = true;
					boolean noIsh = true;
					boolean noIsb = true;
					for(Event b : barriers.stream().filter(e -> e.getMainThread() == e1.getMainThread()
															&& e1.getEId() < e.getEId()
															&& e.getEId() < e2.getEId()).collect(Collectors.toSet())) {
						if(b instanceof Mfence) {
							noMfence = false;
						}
						if(b instanceof Sync) {
							noSync = false;
						}
						if(b instanceof Lwsync) {
							noLwsync = false;
						}
						if(b instanceof Isync) {
							noIsync = false;
						}
						if(b instanceof Ish) {
							noIsh = false;
						}
						if(b instanceof Isb) {
							noIsb = false;
						}
					}
					if(noMfence) {
						enc = ctx.mkAnd(enc, ctx.mkNot(edge("mfence", e1, e2, ctx)));
					}
					if(noSync) {
						enc = ctx.mkAnd(enc, ctx.mkNot(edge("sync", e1, e2, ctx)));
					}
					if(noLwsync) {
						enc = ctx.mkAnd(enc, ctx.mkNot(edge("lwsync", e1, e2, ctx)));
					}
					if(noIsync) {
						enc = ctx.mkAnd(enc, ctx.mkNot(edge("isync", e1, e2, ctx)));
					}
					if(noIsh) {
						enc = ctx.mkAnd(enc, ctx.mkNot(edge("ish", e1, e2, ctx)));
					}
					if(noIsb) {
						enc = ctx.mkAnd(enc, ctx.mkNot(edge("isb", e1, e2, ctx)));
					}
				}
				else {
					enc = ctx.mkAnd(enc, edge("ext", e1, e2, ctx));
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("int", e1, e2, ctx)));
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("po", e1, e2, ctx)));
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("ctrl", e1, e2, ctx)));
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("ii", e1, e2, ctx)));
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("ic", e1, e2, ctx)));
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("ci", e1, e2, ctx)));
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("cc", e1, e2, ctx)));
				}
				if(e1.getLoc() == e2.getLoc()) {
					enc = ctx.mkAnd(enc, edge("loc", e1, e2, ctx));
				}
				else {
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("loc", e1, e2, ctx)));
				}
				if(!((e1 instanceof Store || e1 instanceof Init) && e2 instanceof Load && e1.getLoc() == e2.getLoc())) {
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("rf", e1, e2, ctx)));
				}
				if(!((e1 instanceof Store || e1 instanceof Init) && (e2 instanceof Store || e2 instanceof Init) && e1.getLoc() == e2.getLoc())) {
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("co", e1, e2, ctx)));
				}
				if(!(e1.getMainThread() == e2.getMainThread() && e1.getEId() < e2.getEId())) {
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("mfence", e1, e2, ctx)));
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("sync", e1, e2, ctx)));
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("lwsync", e1, e2, ctx)));
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("isync", e1, e2, ctx)));
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("ish", e1, e2, ctx)));
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("isb", e1, e2, ctx)));
				}
				enc = ctx.mkAnd(enc, ctx.mkEq(edge("rfe", e1, e2, ctx),
										ctx.mkAnd(edge("rf", e1, e2, ctx), edge("ext", e1, e2, ctx))));
				enc = ctx.mkAnd(enc, ctx.mkEq(edge("rfi", e1, e2, ctx),
										ctx.mkAnd(edge("rf", e1, e2, ctx), edge("int", e1, e2, ctx))));
				enc = ctx.mkAnd(enc, ctx.mkEq(edge("coe", e1, e2, ctx),
										ctx.mkAnd(edge("co", e1, e2, ctx), edge("ext", e1, e2, ctx))));
				enc = ctx.mkAnd(enc, ctx.mkEq(edge("coi", e1, e2, ctx),
										ctx.mkAnd(edge("co", e1, e2, ctx), edge("int", e1, e2, ctx))));
				enc = ctx.mkAnd(enc, ctx.mkEq(edge("fre", e1, e2, ctx),
										ctx.mkAnd(edge("fr", e1, e2, ctx), edge("ext", e1, e2, ctx))));
				enc = ctx.mkAnd(enc, ctx.mkEq(edge("fri", e1, e2, ctx),
										ctx.mkAnd(edge("fr", e1, e2, ctx), edge("int", e1, e2, ctx))));
				enc = ctx.mkAnd(enc, ctx.mkEq(edge("poloc", e1, e2, ctx),
										ctx.mkAnd(edge("po", e1, e2, ctx), edge("loc", e1, e2, ctx))));
				enc = ctx.mkAnd(enc, ctx.mkEq(edge("ctrlisync", e1, e2, ctx),
										ctx.mkAnd(edge("ctrl", e1, e2, ctx), edge("isync", e1, e2, ctx))));
				enc = ctx.mkAnd(enc, ctx.mkEq(edge("ctrlisb", e1, e2, ctx),
										ctx.mkAnd(edge("ctrl", e1, e2, ctx), edge("isb", e1, e2, ctx))));
			}
		}
				
		for(Event e1 : mEvents) {
			for(Event e2 : mEvents) {
				BoolExpr mfences = ctx.mkFalse();
				BoolExpr syncs = ctx.mkFalse();
				BoolExpr lwsyncs = ctx.mkFalse();
				BoolExpr isyncs = ctx.mkFalse();
				BoolExpr ishs = ctx.mkFalse();
				BoolExpr isbs = ctx.mkFalse();

				for(Event b : barriers) {
					if(b instanceof Mfence && e1.getMainThread() == b.getMainThread() && b.getMainThread() == e2.getMainThread()
							&& e1.getEId() < b.getEId() && b.getEId() < e2.getEId()) {
						mfences = ctx.mkOr(mfences, b.executes(ctx));
						enc = ctx.mkAnd(enc, ctx.mkImplies(ctx.mkAnd(e1.executes(ctx), ctx.mkAnd(b.executes(ctx), e2.executes(ctx))),
								edge("mfence", e1, e2, ctx)));
			        }
					if(b instanceof Sync && e1.getMainThread() == b.getMainThread() && b.getMainThread() == e2.getMainThread()
							&& e1.getEId() < b.getEId() && b.getEId() < e2.getEId()) {
						syncs = ctx.mkOr(syncs, b.executes(ctx));
						enc = ctx.mkAnd(enc, ctx.mkImplies(ctx.mkAnd(e1.executes(ctx), ctx.mkAnd(b.executes(ctx), e2.executes(ctx))),
								edge("sync", e1, e2, ctx)));
			        }
					if(b instanceof Lwsync && e1.getMainThread() == b.getMainThread() && b.getMainThread() == e2.getMainThread()
							&& e1.getEId() < b.getEId() && b.getEId() < e2.getEId()) {
						lwsyncs = ctx.mkOr(lwsyncs, b.executes(ctx));
						enc = ctx.mkAnd(enc, ctx.mkImplies(ctx.mkAnd(e1.executes(ctx), ctx.mkAnd(b.executes(ctx), e2.executes(ctx))),
								edge("lwsync", e1, e2, ctx)));
			        }
					if(b instanceof Isync && e1.getMainThread() == b.getMainThread() && b.getMainThread() == e2.getMainThread()
							&& e1.getEId() < b.getEId() && b.getEId() < e2.getEId()) {
						isyncs = ctx.mkOr(isyncs, b.executes(ctx));
						enc = ctx.mkAnd(enc, ctx.mkImplies(ctx.mkAnd(e1.executes(ctx), ctx.mkAnd(b.executes(ctx), e2.executes(ctx))),
								edge("isync", e1, e2, ctx)));
			        }
					if(b instanceof Ish && e1.getMainThread() == b.getMainThread() && b.getMainThread() == e2.getMainThread()
							&& e1.getEId() < b.getEId() && b.getEId() < e2.getEId()) {
						ishs = ctx.mkOr(ishs, b.executes(ctx));
						enc = ctx.mkAnd(enc, ctx.mkImplies(ctx.mkAnd(e1.executes(ctx), ctx.mkAnd(b.executes(ctx), e2.executes(ctx))),
								edge("ish", e1, e2, ctx)));
			        }
					if(b instanceof Isb && e1.getMainThread() == b.getMainThread() && b.getMainThread() == e2.getMainThread()
							&& e1.getEId() < b.getEId() && b.getEId() < e2.getEId()) {
						isbs = ctx.mkOr(isbs, b.executes(ctx));
						enc = ctx.mkAnd(enc, ctx.mkImplies(ctx.mkAnd(e1.executes(ctx), ctx.mkAnd(b.executes(ctx), e2.executes(ctx))),
								edge("isb", e1, e2, ctx)));
			        }
				}
				enc = ctx.mkAnd(enc, ctx.mkImplies(edge("mfence", e1, e2, ctx), mfences));
				enc = ctx.mkAnd(enc, ctx.mkImplies(edge("sync", e1, e2, ctx), syncs));
				enc = ctx.mkAnd(enc, ctx.mkImplies(edge("lwsync", e1, e2, ctx), lwsyncs));
				enc = ctx.mkAnd(enc, ctx.mkImplies(edge("isync", e1, e2, ctx), isyncs));
				enc = ctx.mkAnd(enc, ctx.mkImplies(edge("ish", e1, e2, ctx), ishs));
				enc = ctx.mkAnd(enc, ctx.mkImplies(edge("isb", e1, e2, ctx), isbs));
			}
		}

		for(Event e1 : eventsL) {
			for(Event e2 : eventsL) {
				if(e1.getMainThread() != e2.getMainThread() || e2.getEId() < e1.getEId() || e1 == e2) {
                    enc = ctx.mkAnd(enc, ctx.mkNot(edge("idd", e1, e2, ctx)));
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("data", e1, e2, ctx)));
				}

				if(e2 instanceof Store) {
                    if(e2.getReg() != null && !e2.getLastModMap().get(e2.getReg()).contains(e1)) {
                        enc = ctx.mkAnd(enc, ctx.mkNot(edge("idd", e1, e2, ctx)));
                    }

                    // TODO: Why does e2.getLoc() use location of e2 not of e1?
                    if(e2.getReg() == null && !e2.getLastModMap().keySet().contains(e2.getLoc())){
                        enc = ctx.mkAnd(enc, ctx.mkNot(edge("idd", e1, e2, ctx)));
                    }
				}
				if(e2 instanceof Load) {
                    // TODO: Why does e2.getLoc() use location of e2 not of e1?
					if(!e2.getLastModMap().keySet().contains(e2.getLoc())) {
						enc = ctx.mkAnd(enc, ctx.mkNot(edge("idd", e1, e2, ctx)));
					}
				}
				if(e2 instanceof Local && e2.getExpr() instanceof AConst) {
					enc = ctx.mkAnd(enc, ctx.mkNot(edge("idd", e1, e2, ctx)));
				}
			}
		}

		for(Event e : eventsL) {
			if(e instanceof Store) {
                if(e.getReg() == null && !e.getLastModMap().keySet().contains(e.getLoc())) {
                    continue;
                }

				BoolExpr orClause = ctx.mkFalse();
				for(Event x : eventsL) {
                    if(e.getReg() == null && e.getLastModMap().get(e.getLoc()).contains(x)){
                        orClause = ctx.mkOr(orClause, edge("idd", x, e, ctx));
                    } else if(e.getReg() != null && e.getLastModMap().get(e.getReg()).contains(x)){
                        orClause = ctx.mkOr(orClause, edge("idd", x, e, ctx));
                    } else {
                        enc = ctx.mkAnd(enc, ctx.mkNot(edge("idd",x,e,ctx)));
                    }
				}
				enc = ctx.mkAnd(enc, orClause);
			}
			if(e instanceof Load) {
				if(!e.getLastModMap().keySet().contains(e.getLoc())) {
					continue;
				}
				BoolExpr orClause = ctx.mkFalse();
				for(Event x : eventsL) {
					if(e.getLastModMap().get(e.getLoc()).contains(x)) {
						orClause = ctx.mkOr(orClause, edge("idd", x, e, ctx));						
					}
					else {
						enc = ctx.mkAnd(enc, ctx.mkNot(edge("idd",x,e,ctx)));
					}
				}
				enc = ctx.mkAnd(enc, orClause);
			}
			if(e instanceof Local) {
				for(Register reg : e.getExpr().getRegs()) {
					BoolExpr orClause = ctx.mkFalse();
					for(Event x : eventsL) {
						if(e.getLastModMap().get(reg).contains(x)) {
							orClause = ctx.mkOr(orClause, edge("idd", x, e, ctx));							
						}
						else {
							enc = ctx.mkAnd(enc, ctx.mkNot(edge("idd",x,e,ctx)));
						}
					}
					enc = ctx.mkAnd(enc, orClause);	
				}
			}
		}
		
		for(Event e1 : mEvents) {
			for(Event e2 : mEvents) {
				BoolExpr ctrlClause = edge("ctrlDirect",e1,e2,ctx);
				BoolExpr orClause = ctx.mkFalse();
				for(Event e3 : mEvents) {
					ctrlClause = ctx.mkOr(ctrlClause, ctx.mkAnd(edge("ctrl", e1, e3, ctx), edge("po", e3, e2, ctx)));
					orClause = ctx.mkOr(orClause, ctx.mkAnd(edge("rf", e3, e1, ctx), edge("co", e3, e2, ctx)));
				}
				enc = ctx.mkAnd(enc, ctx.mkEq(edge("fr", e1, e2, ctx), orClause));
				enc = ctx.mkAnd(enc, ctx.mkEq(edge("ctrl", e1, e2, ctx), ctrlClause));
			}
		}
		
		Set<Location> locs = mEvents.stream().filter(e -> e instanceof MemEvent).map(e -> e.getLoc()).collect(Collectors.toSet());
		for(Location loc : locs) {
			Set<Event> writesEventsLoc = mEvents.stream().filter(e -> (e instanceof Store || e instanceof Init) && e.getLoc() == loc).collect(Collectors.toSet());
			enc = ctx.mkAnd(enc, satTO("co", writesEventsLoc, ctx));
		}
		
		for(Event e : mEvents.stream().filter(e -> e instanceof Init).collect(Collectors.toSet())) {
			enc = ctx.mkAnd(enc, ctx.mkEq(intVar("co", e, ctx), ctx.mkInt(1)));
		}

		for(Event w1 : mEvents.stream().filter(e -> e instanceof Init || e instanceof Store).collect(Collectors.toSet())) {
			Set<Event> writeSameLoc = mEvents.stream().filter(e -> (e instanceof Init || e instanceof Store) && w1.getLoc() == e.getLoc()).collect(Collectors.toSet());
			BoolExpr lastCoOrder = w1.executes(ctx);
			for(Event w2 : writeSameLoc) {
				lastCoOrder = ctx.mkAnd(lastCoOrder, ctx.mkNot(edge("co", w1, w2, ctx)));
			}
			enc = ctx.mkAnd(enc, ctx.mkImplies(lastCoOrder, ctx.mkEq(lastValueLoc(w1.getLoc(), ctx), ((MemEvent) w1).ssaLoc)));
		}				
		
		for(Event r1 : eventsL.stream().filter(e -> e instanceof Load || e instanceof Local).collect(Collectors.toSet())) {
			Set<Event> modRegLater = eventsL.stream().filter(e -> (e instanceof Load || e instanceof Local) && r1.getReg() == e.getReg() && r1.getEId() < e.getEId()).collect(Collectors.toSet());
			BoolExpr lastModReg = r1.executes(ctx);
			for(Event r2 : modRegLater) {
				lastModReg = ctx.mkAnd(lastModReg, ctx.mkNot(r2.executes(ctx)));
			}
			enc = ctx.mkAnd(enc, ctx.mkImplies(lastModReg, ctx.mkEq(lastValueReg(r1.getReg(), ctx), ssaReg(r1.getReg(), r1.getSsaRegIndex(), ctx))));
		}				
		
		for(Event e : mEvents.stream().filter(e -> e instanceof Load).collect(Collectors.toSet())) {
			Set<Event> storeEventsLoc = mEvents.stream().filter(x -> (x instanceof Store || x instanceof Init) && e.getLoc() == x.getLoc()).collect(Collectors.toSet());
			Set<BoolExpr> rfPairs = new HashSet<BoolExpr>();
			for(Event w : storeEventsLoc) {
				rfPairs.add(edge("rf", w, e, ctx));
			}
			enc = ctx.mkAnd(enc, ctx.mkImplies(e.executes(ctx), encodeEO(rfPairs, ctx)));
		}
		return enc;
	}
}