package dartagnan.program;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import dartagnan.asserts.AbstractAssert;
import dartagnan.program.event.*;
import dartagnan.program.utils.EventRepository;
import dartagnan.utils.MapSSA;
import dartagnan.utils.Pair;

import java.util.*;
import java.util.stream.Collectors;

import static dartagnan.utils.Utils.edge;
import static dartagnan.utils.Utils.ssaReg;

public class Program extends Thread {

	private String name;
	private AbstractAssert ass;
    private AbstractAssert assFilter;
	private List<Thread> threads;

	public Program (String name) {
		this.name = name;
		this.threads = new ArrayList<>();
	}

	public void setName(String name){
	    this.name = name;
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

    public void add(Thread t) {
		threads.add(t);
	}

    public List<Thread> getThreads() {
        return threads;
    }

	@Override
	public Set<Event> getEvents(){
		Set<Event> events = new HashSet<>();
		for(Thread t : getThreads()){
			events.addAll(t.getEvents());
		}
		return events;
	}

    @Override
	public Program clone() {
        Program newP = new Program(name);
		for(Thread t : threads){
		    t.beforeClone();
            newP.add(t.clone());
        }
		newP.setAss(ass.clone());
		if(assFilter != null){
			newP.setAssFilter(assFilter.clone());
		}
		return newP;
	}

	@Override
	public Thread unroll(int steps, boolean obsNoTermination) {
        for(int i = 0; i < threads.size(); i++){
            threads.set(i, threads.get(i).unroll(steps, obsNoTermination));
        }

		Set<Location> locs = getEventRepository().getEvents(EventRepository.EVENT_MEMORY).stream().map(e -> e.getLoc()).collect(Collectors.toSet());
		for(Location loc : locs) {
			threads.add(new Init(loc));
		}
        getEventRepository().clear();
		return this;
	}

    @Override
	public Thread unroll(int steps) {
        return unroll(steps, false);
	}

    @Override
	public Thread compile(String target, boolean ctrl, boolean leading) {
		return compile(target, ctrl, leading, 0, 0);
	}

	public Thread compile(String target, boolean ctrl, boolean leading, int firstEid) {
		return compile(target, ctrl, leading, firstEid, 0);
	}

	public Thread compile(String target, boolean ctrl, boolean leading, int firstEid, int firstTid) {
        for(int i = 0; i < threads.size(); i++){
            Thread t = threads.get(i).compile(target, ctrl, leading);
            firstTid = t.setTId(firstTid);
            firstEid = t.setEId(firstEid);
            t.setMainThread(t);
            threads.set(i, t);
        }

        for(Thread t : threads){
            Set<Register> regs = t.getEvents().stream().filter(e -> e instanceof Load || e instanceof Local).map(e -> e.getReg()).collect(Collectors.toSet());
            regs.addAll(t.getEvents().stream().filter(e -> (e instanceof Store && e.getReg() != null)).map(e -> e.getReg()).collect(Collectors.toSet()));
            for(Register reg : regs) {
                reg.setMainThreadId(t.tid);
            }
        }

        getEventRepository().clear();
		return this;
	}

	public BoolExpr encodeDF(Context ctx) {
		MapSSA lastMap = new MapSSA();
		BoolExpr enc = ctx.mkTrue();
		for(Thread t : threads){
            Pair<BoolExpr, MapSSA>recResult = t.encodeDF(lastMap, ctx);
            enc = ctx.mkAnd(enc, recResult.getFirst());
            lastMap = recResult.getSecond();
        }
		return enc;
	}

	public BoolExpr encodeCF(Context ctx) {
		BoolExpr enc = ctx.mkTrue();
        for(Thread t : threads){
            enc = ctx.mkAnd(enc, t.encodeCF(ctx));
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
	
	public BoolExpr encodeDF_RF(Context ctx) {
		BoolExpr enc = ctx.mkTrue();
		Set<Event> loadEvents = getEventRepository().getEvents(EventRepository.EVENT_LOAD);
		Set<Event> storeInitEvents = getEventRepository().getEvents(EventRepository.EVENT_STORE | EventRepository.EVENT_INIT);
		for (Event r : loadEvents) {
			Set<Event> storeSameLoc = storeInitEvents.stream().filter(w -> w.getLoc() == r.getLoc()).collect(Collectors.toSet());
			BoolExpr sameValue = ctx.mkTrue();
			for (Event w : storeSameLoc) {
				sameValue = ctx.mkAnd(sameValue, ctx.mkImplies(edge("rf", w, r, ctx), ctx.mkEq(((MemEvent) w).ssaLoc, ((Load) r).ssaLoc)));
			}
			enc = ctx.mkAnd(enc, sameValue);
		}
		return enc;
	}

    @Override
    public String toString() {
        ListIterator<Thread> it = threads.listIterator();
        StringBuilder sb = new StringBuilder();
        sb.append(name).append("\n");
        while (it.hasNext()) {
            Thread next = it.next();
            if(!(next instanceof Init)){
                sb.append("\nthread ").append(it.nextIndex()).append("\n").append(next).append("\n");
            }
        }
        return sb.toString();
    }
}