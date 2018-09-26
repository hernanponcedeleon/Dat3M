package dartagnan.program;

import java.util.*;
import java.util.stream.Collectors;

import com.microsoft.z3.*;

import dartagnan.asserts.AbstractAssert;
import dartagnan.program.event.*;
import dartagnan.program.utils.ClonableWithMemorisation;
import dartagnan.program.utils.EventRepository;
import dartagnan.utils.*;
import static dartagnan.utils.Utils.edge;
import static dartagnan.utils.Utils.ssaReg;

public class Program extends Thread {

	private String name;
	private AbstractAssert ass;
    private AbstractAssert assFilter;
	private List<Thread> threads;
	private EventRepository eventRepository = new EventRepository(this);

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

	public Set<Event> getEvents(){
		Set<Event> events = new HashSet<>();
		for(Thread t : getThreads()){
			events.addAll(t.getEvents());
		}
		return events;
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

    public AbstractAssert getAssFilter() {
        return assFilter;
    }

    public void setAssFilter(AbstractAssert ass) {
        this.assFilter = ass;
    }
	
	public Program clone() {
		for(Thread thread : threads){
			if(thread instanceof ClonableWithMemorisation){
				((ClonableWithMemorisation) thread).resetPreparedClone();
			}
		}

		List<Thread> newThreads = new ArrayList<Thread>();
		
		ListIterator<Thread> iter = threads.listIterator();
		while (iter.hasNext()) {
			Thread t = iter.next();
			newThreads.add(t.clone());
		}
		Program newP = new Program(name);
		newP.setThreads(newThreads);
		newP.setAss(ass.clone());
		if(assFilter != null){
			newP.setAssFilter(assFilter.clone());
		}
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
		
		Set<Location> locs = eventRepository.getEvents(EventRepository.EVENT_MEMORY).stream()
				.map(e -> e.getLoc()).collect(Collectors.toSet());
		for(Location loc : locs) {
			threads.add(new Init(loc));
		}
		eventRepository.clear();
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

	public Thread compile(String target, boolean ctrl, boolean leading) {
		compile(target, ctrl, leading, 0, 0);
		return this;
	}

	public Thread compile(String target, boolean ctrl, boolean leading, int firstEid) {
		compile(target, ctrl, leading, firstEid, 0);
		return this;
	}

	public Thread compile(String target, boolean ctrl, boolean leading, int firstEid, int firstTid) {
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
			Set<Register> regs = t.getEvents().stream().filter(e -> e instanceof Load || e instanceof Local).map(e -> e.getReg()).collect(Collectors.toSet());
			regs.addAll(t.getEvents().stream().filter(e -> (e instanceof Store && e.getReg() != null)).map(e -> e.getReg()).collect(Collectors.toSet()));
			for(Register reg : regs) {
				reg.setMainThreadId(t.tid);
			}
		}
		eventRepository.clear();
		return this;
	}

	public void optCompile(int firstEId, boolean ctrl, boolean leading) {
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
			Set<Register> regs = t.getEvents().stream().filter(e -> e instanceof Load || e instanceof Local).map(e -> e.getReg()).collect(Collectors.toSet());
			regs.addAll(t.getEvents().stream().filter(e -> (e instanceof Store && e.getReg() != null)).map(e -> e.getReg()).collect(Collectors.toSet()));
			for(Register reg : regs) {
				reg.setMainThreadId(t.tid);
			}
		}
		eventRepository.clear();
	}

	public EventRepository getEventRepository(){
		return eventRepository;
	}

	public boolean hasRMWEvents(){
		return eventRepository.getEvents(EventRepository.EVENT_RMW_STORE).size() > 0;
	}
	
	private void setMainThread() {
		ListIterator<Thread> iter = threads.listIterator();
		while (iter.hasNext()) {
			Thread t = iter.next();
		    t.setMainThread(t);
		}
	}

	public Integer setEId(Integer lastId) {
		ListIterator<Thread> iter = threads.listIterator();
		while (iter.hasNext()) {
			Thread t = iter.next();
		    lastId = t.setEId(lastId);
		}
		return lastId;
	}

	private void setTId() {
		ListIterator<Thread> iter = threads.listIterator();
		Integer lastId = 1;
		while (iter.hasNext()) {
			Thread t = iter.next();
		    lastId = t.setTId(lastId);
		}
	}

	public Integer setTId(Integer lastId) {
		ListIterator<Thread> iter = threads.listIterator();
		while (iter.hasNext()) {
			Thread t = iter.next();
		    lastId = t.setTId(lastId);
		}
		return lastId;
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

	public BoolExpr encodeFinalValues(Context ctx){
		BoolExpr enc = ctx.mkTrue();
		Set<Event> eventsLoadLocal = getEventRepository().getEvents(EventRepository.EVENT_LOAD | EventRepository.EVENT_LOCAL);
		for(Event r1 : eventsLoadLocal) {
			Set<Event> modRegLater = eventsLoadLocal.stream().filter(e -> r1.getReg() == e.getReg() && r1.getEId() < e.getEId()).collect(Collectors.toSet());
			BoolExpr lastModReg = r1.executes(ctx);
			for(Event r2 : modRegLater) {
				lastModReg = ctx.mkAnd(lastModReg, ctx.mkNot(r2.executes(ctx)));
			}
			enc = ctx.mkAnd(enc, ctx.mkImplies(lastModReg, ctx.mkEq(r1.getReg().getLastValueExpr(ctx), ssaReg(r1.getReg(), r1.getSsaRegIndex(), ctx))));
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
		Set<Event> loadEvents = eventRepository.getEvents(EventRepository.EVENT_LOAD);
		Set<Event> storeInitEvents = eventRepository.getEvents(EventRepository.EVENT_STORE | EventRepository.EVENT_INIT);
		for (Event r : loadEvents) {
			Set<Event> storeSameLoc = storeInitEvents.stream().filter(w -> ((MemEvent) w).getLoc() == ((Load) r).getLoc()).collect(Collectors.toSet());
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