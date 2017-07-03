package dartagnan.program;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.ListIterator;
import java.util.Set;
import java.util.stream.Collectors;

import com.microsoft.z3.*;

import dartagnan.expression.Assert;
import dartagnan.utils.*;
import dartagnan.wmm.*;

public class Program {
	
	public String name;
	public Assert ass; 
	private List<Thread> threads;

	public Program (String name) {
		this.name = name;
		this.threads = new ArrayList<Thread>();
	}
	
	public void add(Thread t) {
		threads.add(t);
	}
	
	public String toString() {
		
		ListIterator<Thread> iter = threads.listIterator();
		String output = name + "\n";
		while (iter.hasNext()) {
			Thread next = iter.next();
			if(next instanceof Init) {
				continue;
			}
		    output = output.concat(String.format("\nthread %d\n%s\n", iter.nextIndex(), next));
		}
        return output;
	}
	
	public Program clone() {
		List<Thread> newThreads = new ArrayList<Thread>();
		
		ListIterator<Thread> iter = threads.listIterator();
		while (iter.hasNext()) {
			Thread t = iter.next();
			newThreads.add(t.clone());
		}
		Program newP = new Program(name);
		newP.setThreads(newThreads);
		return newP;
	}
	
	public void initialize() {
		initialize(1);
	}
	
	public void initialize(int steps) {
		List<Thread> unrolledThreads = new ArrayList<Thread>();
		
		ListIterator<Thread> iter = threads.listIterator();
		while (iter.hasNext()) {
			Thread t = iter.next();
			t = t.unroll(steps);
			unrolledThreads.add(t);
		}
		threads = unrolledThreads;
		
		Set<Location> locs = getEvents().stream().filter(e -> e instanceof MemEvent).map(e -> ((MemEvent) e).getLoc()).collect(Collectors.toSet());
		for(Location loc : locs) {
			threads.add(new Init(loc));
		}
	}
	
	public void compile() {
		List<Thread> compiledThreads = new ArrayList<Thread>();
		
		ListIterator<Thread> iter = threads.listIterator();
		while (iter.hasNext()) {
			Thread t = iter.next();
			t = t.compile();
			compiledThreads.add(t);
		}
		threads = compiledThreads;

		setTId();
		setEId();
		setMainThread();
		
		// Set the thread for the registers
		iter = threads.listIterator();
		while (iter.hasNext()) {
			Thread t = iter.next();
            t.setCondRegs(new HashSet<Register>());
            t.setLastModMap(new LastModMap());
			Set<Register> regs = t.getEvents().stream().filter(e -> e instanceof Load).map(e -> ((Load) e).getReg()).collect(Collectors.toSet());
			regs.addAll(t.getEvents().stream().filter(e -> e instanceof Store).map(e -> ((Store) e).getReg()).collect(Collectors.toSet()));
			regs.addAll(t.getEvents().stream().filter(e -> e instanceof Local).map(e -> ((Local) e).getReg()).collect(Collectors.toSet()));
			for(Register reg : regs) {
				reg.setMainThread(t.tid);
			}
		}
	}	

	public void optCompile(Integer firstEId) {
		List<Thread> compiledThreads = new ArrayList<Thread>();
		
		ListIterator<Thread> iter = threads.listIterator();
		while (iter.hasNext()) {
			Thread t = iter.next();
			t = t.optCompile();
			compiledThreads.add(t);
		}
		threads = compiledThreads;
		
		setTId();
		setEId(firstEId);
		setMainThread();
		
		// Set the thread for the registers
		iter = threads.listIterator();
		while (iter.hasNext()) {
			Thread t = iter.next();
            t.setCondRegs(new HashSet<Register>());
            t.setLastModMap(new LastModMap());
			Set<Register> regs = t.getEvents().stream().filter(e -> e instanceof Load).map(e -> ((Load) e).getReg()).collect(Collectors.toSet());
			regs.addAll(t.getEvents().stream().filter(e -> e instanceof Store).map(e -> ((Store) e).getReg()).collect(Collectors.toSet()));
			regs.addAll(t.getEvents().stream().filter(e -> e instanceof Local).map(e -> ((Local) e).getReg()).collect(Collectors.toSet()));
			for(Register reg : regs) {
				reg.setMainThread(t.tid);
			}
		}
	}
	
	public BoolExpr encodeConsistent(Context ctx, String mcm) throws Z3Exception {
		BoolExpr enc = ctx.mkTrue();
		switch (mcm){
		case "sc":
			enc = ctx.mkAnd(enc, SC.encode(this, ctx));
			enc = ctx.mkAnd(enc, SC.Consistent(this, ctx));
			break;
		case "tso":
			enc = ctx.mkAnd(enc, TSO.encode(this, ctx));
			enc = ctx.mkAnd(enc, TSO.Consistent(this, ctx));
			break;
		case "pso":
			enc = ctx.mkAnd(enc, PSO.encode(this, ctx));
			enc = ctx.mkAnd(enc, PSO.Consistent(this, ctx));
			break;
		case "rmo":
			enc = ctx.mkAnd(enc, RMO.encode(this, ctx));
			enc = ctx.mkAnd(enc, RMO.Consistent(this, ctx));
			break;
		case "alpha":
			enc = ctx.mkAnd(enc, Alpha.encode(this, ctx));
			enc = ctx.mkAnd(enc, Alpha.Consistent(this, ctx));
			break;
		case "power":
			enc = ctx.mkAnd(enc, Power.encode(this, ctx));
			enc = ctx.mkAnd(enc, Power.Consistent(this, ctx));
			break;
		default:
			System.out.println("Check encodeConsistent!");
			break;
		}
		return enc;
	}
	
	public BoolExpr encodeInconsistent(Context ctx, String mcm) throws Z3Exception {
		BoolExpr enc = ctx.mkTrue();
		switch (mcm) {
		case "sc":
			enc = ctx.mkAnd(enc, SC.encode(this, ctx));
			enc = ctx.mkAnd(enc, SC.Inconsistent(this, ctx));
			break;
		case "tso":
			enc = ctx.mkAnd(enc, TSO.encode(this, ctx));
			enc = ctx.mkAnd(enc, TSO.Inconsistent(this, ctx));
			break;
		case "pso":
			enc = ctx.mkAnd(enc, PSO.encode(this, ctx));
			enc = ctx.mkAnd(enc, PSO.Inconsistent(this, ctx));
			break;
		case "rmo":
			enc = ctx.mkAnd(enc, RMO.encode(this, ctx));
			enc = ctx.mkAnd(enc, RMO.Inconsistent(this, ctx));
			break;
		case "alpha":
			enc = ctx.mkAnd(enc, Alpha.encode(this, ctx));
			enc = ctx.mkAnd(enc, Alpha.Inconsistent(this, ctx));
			break;
		case "power":
			enc = ctx.mkAnd(enc, Power.encode(this, ctx));
			enc = ctx.mkAnd(enc, Power.Inconsistent(this, ctx));
			break;
		default:
			System.out.println("Check encodeInconsistent!");
			break;
		}
		return enc;
	}
	
	public BoolExpr encodePortability(Context ctx, String source, String target) throws Z3Exception {
		BoolExpr enc = encodeDF(ctx, false);
		enc = ctx.mkAnd(enc, encodeCF(ctx));
		enc = ctx.mkAnd(enc, encodeDF_RF(ctx));
		enc = ctx.mkAnd(enc, Domain.encode(this, ctx));
		enc = ctx.mkAnd(enc, encodeInconsistent(ctx, source));
		enc = ctx.mkAnd(enc, encodeConsistent(ctx, target));
		return enc;
	}
	
	public Set<Event> getEvents() {
		Set<Event> ret = new HashSet<Event>();
		ListIterator<Thread> iter = threads.listIterator();
		while (iter.hasNext()) {
			ret.addAll(iter.next().getEvents());
		}
		return ret;
	}
	
	public void setMainThread() {
		ListIterator<Thread> iter = threads.listIterator();
		while (iter.hasNext()) {
			Thread t = iter.next();
		    t.setMainThread(t.tid);
		}
	}
	
	public void setEId() {
		ListIterator<Thread> iter = threads.listIterator();
		Integer lastId = 1;
		while (iter.hasNext()) {
			Thread t = iter.next();
		    lastId = t.setEId(lastId);
		}
	}

	public void setEId(Integer lastId) {
		ListIterator<Thread> iter = threads.listIterator();
		while (iter.hasNext()) {
			Thread t = iter.next();
		    lastId = t.setEId(lastId);
		}
	}

	public void setTId() {
		ListIterator<Thread> iter = threads.listIterator();
		Integer lastId = 1;
		while (iter.hasNext()) {
			Thread t = iter.next();
		    lastId = t.setTId(lastId);
		}
	}

	public BoolExpr encodeDF(Context ctx, boolean reachQuery) throws Z3Exception {
		ListIterator<Thread> iter = threads.listIterator();
		MapSSA lastMap = new MapSSA();
		BoolExpr enc = ctx.mkTrue();
		while (iter.hasNext()) {
			Thread t = iter.next();
			Pair<BoolExpr, MapSSA>recResult = t.encodeDF(lastMap, ctx);
		    enc = ctx.mkAnd(enc, recResult.getFirst());
		    lastMap = recResult.getSecond();
		}
		if(reachQuery) {
			enc = ctx.mkAnd(enc, ass.encode(ctx, lastMap));			
		}
		return enc;
	}

	public BoolExpr encodeCF(Context ctx) throws Z3Exception {
		ListIterator<Thread> iter = threads.listIterator();
		BoolExpr enc = ctx.mkTrue();
		while (iter.hasNext()) {
			Thread t = iter.next();
		    enc = ctx.mkAnd(enc, t.encodeCF(ctx));
		    // Main threads are active
		    enc = ctx.mkAnd(enc, ctx.mkBoolConst(t.cfVar()));
		}
		return enc;
	}
	
	public BoolExpr encodeDF_RF(Context ctx) throws Z3Exception {
		BoolExpr enc = ctx.mkTrue();
		Set<Event> loadEvents = getEvents().stream().filter(e -> e instanceof Load).collect(Collectors.toSet());
		for (Event r : loadEvents) {
			Set<Event> storeSameLoc = getEvents().stream().filter(w -> (w instanceof Store || w instanceof Init) && ((MemEvent) w).loc == ((Load) r).loc).collect(Collectors.toSet());
			BoolExpr sameValue = ctx.mkTrue();
			for (Event w : storeSameLoc) {
				sameValue = ctx.mkAnd(sameValue, ctx.mkImplies(Utils.edge("rf", w, r, ctx), ctx.mkEq(((MemEvent) w).ssaLoc, ((Load) r).ssaLoc)));
			}
			enc = ctx.mkAnd(enc, sameValue);
		}
		return enc;
	}

	public BoolExpr encodeCommonExecutions(Program p,Context ctx) throws Z3Exception {
		BoolExpr enc = ctx.mkTrue();
		Set<Event> rEventsP1 = getEvents().stream().filter(e -> e instanceof Load).collect(Collectors.toSet());
		Set<Event> wEventsP1 = getEvents().stream().filter(e -> e instanceof Store || e instanceof Init).collect(Collectors.toSet());
		Set<Event> rEventsP2 = p.getEvents().stream().filter(e -> e instanceof Load).collect(Collectors.toSet());
		Set<Event> wEventsP2 = p.getEvents().stream().filter(e -> e instanceof Store || e instanceof Init).collect(Collectors.toSet());
		for(Event r1 : rEventsP1) {
			for(Event r2 : rEventsP2) {			
				if(((MemEvent) r1).hlId.equals(((MemEvent) r2).hlId)) {
					for(Event w1 : wEventsP1) {
						for(Event w2 : wEventsP2) {
							if(w1 == w2) {continue;}
							if(((MemEvent) w1).hlId.equals(((MemEvent) w2).hlId)) {
								enc = ctx.mkAnd(enc, ctx.mkIff(Utils.edge("rf", w1, r1, ctx), Utils.edge("rf", w2, r2, ctx)));
								enc = ctx.mkAnd(enc, ctx.mkIff(Utils.edge("fr", r1, w1, ctx), Utils.edge("fr", r2, w2, ctx)));
							}
						}	
					}
				}
			}	
		}
		for(Event w1P1 : rEventsP1) {
			for(Event w1P2 : rEventsP2) {			
				if(w1P1 == w1P2) {continue;}
				if(((MemEvent) w1P1).hlId.equals(((MemEvent) w1P2).hlId)) {
					for(Event w2P1 : wEventsP1) {
						for(Event w2P2 : wEventsP2) {
							if(w2P1 == w2P2) {continue;}
							if(((MemEvent) w2P2).hlId.equals(((MemEvent) w2P2).hlId)) {
								enc = ctx.mkAnd(enc, ctx.mkIff(Utils.edge("co", w1P1, w1P2, ctx), Utils.edge("co", w2P2, w2P2, ctx)));
							}
						}	
					}
				}
			}	
		}
		return enc;
	}

	public List<Thread> getThreads() {
		return this.threads;
	}
	
	public void setThreads(List<Thread> threads) {
		this.threads = threads;
	}

}