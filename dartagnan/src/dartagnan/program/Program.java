package dartagnan.program;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.ListIterator;
import java.util.Set;
import java.util.stream.Collectors;

import com.microsoft.z3.*;

import dartagnan.asserts.AbstractAssert;
import dartagnan.program.rmw.RMWStore;
import dartagnan.utils.*;
import static dartagnan.utils.Utils.edge;
import dartagnan.wmm.*;

public class Program {

	private String name;
	public AbstractAssert ass;
	private List<Thread> threads;

	public Program(){
        this("");
    }

	public Program (String name) {
		this.name = name;
		this.threads = new ArrayList<Thread>();
	}

	public void setName(String name){
	    this.name = name;
    }

    public void add(Thread t) {
		threads.add(t);
	}

	public boolean hasRMWEvents(){
		return getEvents().stream().anyMatch(e -> e instanceof RMWStore);
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

	public AbstractAssert getAss() {
		return ass;
	}

	public void setAss(AbstractAssert ass) {
		this.ass = ass;
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
	
	public void initialize(int steps, boolean obsNoTermination) {
		List<Thread> unrolledThreads = new ArrayList<Thread>();
		
		ListIterator<Thread> iter = threads.listIterator();
		while (iter.hasNext()) {
			Thread t = iter.next();
			t = t.unroll(steps, obsNoTermination);
			unrolledThreads.add(t);
		}
		threads = unrolledThreads;
		
		Set<Location> locs = getEvents().stream().filter(e -> e instanceof MemEvent).map(e -> ((MemEvent) e).getLoc()).collect(Collectors.toSet());
		for(Location loc : locs) {
			threads.add(new Init(loc));
		}
	}
	
	public void initialize(int steps) {
		initialize(steps, false);
	}
	
	public void setGuards(Context ctx) {
		ListIterator<Thread> iter = threads.listIterator();
		while (iter.hasNext()) {
			Thread t = iter.next();
			t.setGuard(ctx.mkTrue(), ctx);
		}		
	}

	public void compile(String target, boolean ctrl, boolean leading) {
		compile(target, ctrl, leading, 0, 0);
	}

	public void compile(String target, boolean ctrl, boolean leading, Integer firstEid) {
		compile(target, ctrl, leading, firstEid, 0);
	}

	public void compile(String target, boolean ctrl, boolean leading, Integer firstEid, Integer firstTid) {
		List<Thread> compiledThreads = new ArrayList<Thread>();

		ListIterator<Thread> iter = threads.listIterator();
		while (iter.hasNext()) {
			Thread t = iter.next();
			t = t.compile(target, ctrl, leading);
			compiledThreads.add(t);
		}
		threads = compiledThreads;

		setTId(firstTid);
		setEId(firstEid);
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
				if(reg != null) {
					reg.setMainThread(t.tid);
				}
			}
		}
	}

	public void optCompile(Integer firstEId, boolean ctrl, boolean leading) {
		List<Thread> compiledThreads = new ArrayList<Thread>();
		
		ListIterator<Thread> iter = threads.listIterator();
		while (iter.hasNext()) {
			Thread t = iter.next();
			t = t.optCompile(ctrl, leading);
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
				if(reg != null) {
					reg.setMainThread(t.tid);
				}
			}
		}
	}
	
	public BoolExpr encodeMM(Context ctx, String mcm, boolean approx, boolean idl) throws Z3Exception {
		BoolExpr enc = ctx.mkTrue();
		switch (mcm){
		case "sc":
			enc = ctx.mkAnd(enc, SC.encode(this, ctx));
			break;
		case "tso":
			enc = ctx.mkAnd(enc, TSO.encode(this, ctx));
			break;
		case "pso":
			enc = ctx.mkAnd(enc, PSO.encode(this, ctx));
			break;
		case "rmo":
			enc = ctx.mkAnd(enc, RMO.encode(this, approx, ctx));
			break;
		case "alpha":
			enc = ctx.mkAnd(enc, Alpha.encode(this, approx, ctx));
			break;
		case "power":
			enc = ctx.mkAnd(enc, Power.encode(this, approx, idl, ctx));
			break;
		case "arm":
			enc = ctx.mkAnd(enc, ARM.encode(this, approx, idl, ctx));
			break;
		default:
			System.out.println("Check encodeMM!");
			break;
		}
		return enc;
	}

	public BoolExpr encodeConsistent(Context ctx, String mcm) throws Z3Exception {
		BoolExpr enc = ctx.mkTrue();
		switch (mcm){
		case "sc":
			enc = ctx.mkAnd(enc, SC.Consistent(this, ctx));
			break;
		case "tso":
			enc = ctx.mkAnd(enc, TSO.Consistent(this, ctx));
			break;
		case "pso":
			enc = ctx.mkAnd(enc, PSO.Consistent(this, ctx));
			break;
		case "rmo":
			enc = ctx.mkAnd(enc, RMO.Consistent(this, ctx));
			break;
		case "alpha":
			enc = ctx.mkAnd(enc, Alpha.Consistent(this, ctx));
			break;
		case "power":
			enc = ctx.mkAnd(enc, Power.Consistent(this, ctx));
			break;
		case "arm":
			enc = ctx.mkAnd(enc, ARM.Consistent(this, ctx));
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
			enc = ctx.mkAnd(enc, SC.Inconsistent(this, ctx));
			break;
		case "tso":
			enc = ctx.mkAnd(enc, TSO.Inconsistent(this, ctx));
			break;
		case "pso":
			enc = ctx.mkAnd(enc, PSO.Inconsistent(this, ctx));
			break;
		case "rmo":
			enc = ctx.mkAnd(enc, RMO.Inconsistent(this, ctx));
			break;
		case "alpha":
			enc = ctx.mkAnd(enc, Alpha.Inconsistent(this, ctx));
			break;
		case "power":
			enc = ctx.mkAnd(enc, Power.Inconsistent(this, ctx));
			break;
		case "arm":
			enc = ctx.mkAnd(enc, ARM.Inconsistent(this, ctx));
			break;
		default:
			System.out.println("Check encodeInconsistent!");
			break;
		}
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
	
	public Set<Event> getMemEvents() {
		return getEvents().stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet());
    }
	
	private void setMainThread() {
		ListIterator<Thread> iter = threads.listIterator();
		while (iter.hasNext()) {
			Thread t = iter.next();
		    t.setMainThread(t.tid);
		}
	}

	private void setEId(Integer lastId) {
		ListIterator<Thread> iter = threads.listIterator();
		while (iter.hasNext()) {
			Thread t = iter.next();
		    lastId = t.setEId(lastId);
		}
	}

	private void setTId() {
		ListIterator<Thread> iter = threads.listIterator();
		Integer lastId = 1;
		while (iter.hasNext()) {
			Thread t = iter.next();
		    lastId = t.setTId(lastId);
		}
	}

	private void setTId(Integer lastId) {
		ListIterator<Thread> iter = threads.listIterator();
		while (iter.hasNext()) {
			Thread t = iter.next();
		    lastId = t.setTId(lastId);
		}
	}

	public BoolExpr encodeDF(Context ctx) throws Z3Exception {
		ListIterator<Thread> iter = threads.listIterator();
		MapSSA lastMap = new MapSSA();
		BoolExpr enc = ctx.mkTrue();
		while (iter.hasNext()) {
			Thread t = iter.next();
			Pair<BoolExpr, MapSSA>recResult = t.encodeDF(lastMap, ctx);
		    enc = ctx.mkAnd(enc, recResult.getFirst());
		    lastMap = recResult.getSecond();
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
	
	public BoolExpr allExecute(Context ctx) throws Z3Exception {
		ListIterator<Thread> iter = threads.listIterator();
		BoolExpr enc = ctx.mkTrue();
		while (iter.hasNext()) {
			Thread t = iter.next();
		    enc = ctx.mkAnd(enc, t.allExecute(ctx));
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
				sameValue = ctx.mkAnd(sameValue, ctx.mkImplies(edge("rf", w, r, ctx), ctx.mkEq(((MemEvent) w).ssaLoc, ((Load) r).ssaLoc)));
			}
			enc = ctx.mkAnd(enc, sameValue);
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