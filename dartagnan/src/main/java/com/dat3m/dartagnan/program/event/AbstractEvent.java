package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.program.Thread;
import com.google.common.base.Preconditions;
import org.sosy_lab.java_smt.api.BooleanFormula;

import java.util.*;

public abstract class AbstractEvent implements Event {

    // ID after parsing (original)
    protected int oId = -1;
    // ID after unrolling
    protected int uId = -1;
    // ID after compilation
    protected int cId = -1;
    // ID within a function
    protected int fId = -1;
    // line in the original C program
    protected int cLine = -1;
    // The thread this event belongs to
    protected Thread thread;

    protected final Set<String> filter;

    protected transient Event successor;

    protected transient BooleanFormula cfVar;

    protected Set<Event> listeners = new HashSet<>();

    private transient String repr;

    protected AbstractEvent() {
        filter = new HashSet<>();
    }

    protected AbstractEvent(AbstractEvent other) {
        this.oId = other.oId;
        this.uId = other.uId;
        this.cId = other.cId;
        this.fId = other.fId;
        this.cLine = other.cLine;
        this.filter = other.filter;
        this.thread = other.thread;
        this.listeners = other.listeners;
    }

    @Override public int getOId() { return oId; }
    @Override public void setOId(int id) { oId = id; }

    @Override public int getUId(){ return uId; }
    @Override public void setUId(int id) { uId = id; }

    @Override public int getCId() { return cId; }
    @Override public void setCId(int id) { cId = id; }

    // TODO: This should be called "LId" (localId) and be set once after all processing is done.
    @Override public int getFId() { return fId; }
    @Override public void setFId(int id) { fId = id; }

    @Override public int getCLine() { return cLine; }
    @Override public void setCLine(int line) { cLine = line; }

    @Override public BooleanFormula cf(){ return cfVar; }
    @Override public void setCfVar(BooleanFormula cfVar) { this.cfVar = cfVar; }

    @Override
    public Event getSuccessor(){
        return successor;
    }

    @Override
    public void setSuccessor(Event event){
        successor = event;
        if(successor != null) {
            successor.setThread(thread);
        }
    }

    @Override
    public Thread getThread() {
        return thread;
    }

    @Override
    public void setThread(Thread t) {
        Preconditions.checkNotNull(t);
        thread = t;
    }

    @Override
    public boolean is(String param){
        return param != null && (filter.contains(param));
    }

    @Override
    public void addFilters(String... params){
        filter.addAll(Arrays.asList(params));
    }

    @Override
    public boolean hasFilter(String f) {
        return filter.contains(f);
    }

    @Override
    public int compareTo(Event e){
        int result = Integer.compare(cId,e.getCId());
        if(result == 0){
            result = Integer.compare(uId,e.getUId());
            if(result == 0){
                result = Integer.compare(oId,e.getOId());
            }
        }
        return result;
    }

    @Override
    public void addListener(Event e) {
        listeners.add(e);
    }

    @Override
    public Set<Event> getListeners() {
        return listeners;
    }

    // Encoding
    // -----------------------------------------------------------------------------------------------------------------

    public String repr() {
        if (cId == -1) {
            // We have not yet compiled
            return "E" + oId;
        }
        if (repr == null) {
            // We cache the result, because this saves string concatenations
            // for every(!) single edge encoded in the program
            repr = "E" + cId;
        }
        return repr;
    }
}
