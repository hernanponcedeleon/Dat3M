package com.dat3m.dartagnan.program;

import com.dat3m.dartagnan.program.utils.Alias;
import com.dat3m.dartagnan.program.utils.AliasAnalysis;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.google.common.collect.ImmutableSet;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.dat3m.dartagnan.asserts.AbstractAssert;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Init;
import com.dat3m.dartagnan.program.event.utils.RegWriter;
import com.dat3m.dartagnan.program.memory.Location;
import com.dat3m.dartagnan.program.memory.Memory;
import com.dat3m.dartagnan.program.utils.EventRepository;

import java.util.*;

public class Program extends Thread {

    private String name;
	private AbstractAssert ass;
    private AbstractAssert assFilter;
	private List<Thread> threads;
	private final ImmutableSet<Location> locations;
	private Memory memory;
	private Arch arch;

    public Program(Memory memory, ImmutableSet<Location> locations){
        this("", memory, locations);
    }

	public Program (String name, Memory memory, ImmutableSet<Location> locations) {
		this.name = name;
		this.memory = memory;
		this.locations = locations;
		this.threads = new ArrayList<>();
	}

	public void setName(String name){
	    this.name = name;
    }

	public void setArch(Arch arch){
	    this.arch = arch;
    }

	public Arch getArch(){
	    return arch;
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

    public ImmutableSet<Location> getLocations(){
        return locations;
    }

	@Override
	public List<Event> getEvents(){
        List<Event> events = new ArrayList<>();
		for(Thread t : threads){
			events.addAll(t.getEvents());
		}
		return events;
	}

    @Override
	public void beforeClone(){}

	@Override
	public Thread unroll(int steps) {
        for(int i = 0; i < threads.size(); i++){
            threads.set(i, threads.get(i).unroll(steps));
        }
        getEventRepository().clear();
		return this;
	}

    @Override
	public Thread compile(Arch target) {
		return compile(target, Alias.CFIS, 0, 0);
	}

    public Thread compile(Arch target, Alias alias) {
        return compile(target, alias, 0, 0);
    }

	public Thread compile(Arch target, Alias alias, int firstEid) {
		return compile(target, alias, firstEid, 0);
	}

	public Thread compile(Arch target, Alias alias, int firstEid, int firstTid) {
        for(int i = 0; i < threads.size(); i++){
            Thread t = threads.get(i).compile(target);
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
        new AliasAnalysis().calculateLocationSets(this, memory, alias);
		return this;
	}

	@Override
	public BoolExpr encodeCF(Context ctx) {
        for(Event e : getEvents()){
            e.initialise(ctx);
        }
        BoolExpr enc = memory.encode(ctx);
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
                Register reg = ((RegWriter)e).getResultRegister();
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
                        ctx.mkEq(reg.getLastValueExpr(ctx), ((RegWriter)events.get(i)).getResultRegisterExpr())));
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