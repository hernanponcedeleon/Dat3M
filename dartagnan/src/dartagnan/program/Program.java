package dartagnan.program;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import dartagnan.asserts.AbstractAssert;
import dartagnan.program.event.*;
import dartagnan.program.event.utils.RegWriter;
import dartagnan.program.memory.Location;
import dartagnan.program.memory.Memory;
import dartagnan.program.utils.EventRepository;
import dartagnan.utils.MapSSA;
import dartagnan.utils.Pair;

import java.util.*;

import static dartagnan.utils.Utils.ssaReg;

public class Program extends Thread {

	private String name;
	private AbstractAssert ass;
    private AbstractAssert assFilter;
	private List<Thread> threads;
	private Memory memory;

    public Program(Memory memory){
        this("", memory);
    }

	public Program (String name, Memory memory) {
		this.name = name;
		this.memory = memory;
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

    public Set<Location> getLocations(){
        return memory.getLocations();
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
        Program newP = new Program(name, memory);
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
		for(Location location : memory.getLocations()) {
			threads.add(new Init(location));
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
            for(Register reg : t.getEventRepository().getRegisters()) {
                reg.setMainThreadId(t.tid);
            }
            t.getEventRepository().clear();
			threads.set(i, t);
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
        Map<Register, List<Event>> eMap = new HashMap<>();
        for(Event e : getEventRepository().getEvents(EventRepository.ALL)){
            if(e instanceof RegWriter){
                Register reg = ((RegWriter)e).getModifiedReg();
                eMap.putIfAbsent(reg, new ArrayList<>());
                eMap.get(reg).add(e);
            }
        }

        BoolExpr enc = ctx.mkTrue();
        for (Register reg : eMap.keySet()) {
            List<Event> events = eMap.get(reg);
            events.sort((e1, e2) -> Integer.compare(e2.getEId(), e1.getEId()));
            for(int i = 0; i <  events.size(); i++){
                BoolExpr lastModReg = eMap.get(reg).get(i).executes(ctx);
                for(int j = 0; j < i; j++){
                    lastModReg = ctx.mkAnd(lastModReg, ctx.mkNot(events.get(j).executes(ctx)));
                }
                enc = ctx.mkAnd(enc, ctx.mkImplies(lastModReg,
                        ctx.mkEq(reg.getLastValueExpr(ctx), ssaReg(reg, ((RegWriter)events.get(i)).getSsaRegIndex(), ctx))));
            }
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