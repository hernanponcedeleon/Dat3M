package com.dat3m.dartagnan.program;

import com.dat3m.dartagnan.wmm.utils.Arch;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Skip;
import com.dat3m.dartagnan.program.utils.ThreadCache;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;

public abstract class Thread {

	protected Thread mainThread;
	protected int tid;
	protected int condLevel;
    ThreadCache cache;

    public abstract void beforeClone();

    public void setMainThread(Thread t) {
        this.mainThread = t;
    }

    public int getTId() {
        return this.tid;
    }

    public int setTId(int i) {
        this.tid = i;
        return i + 1;
    }

    public int getCondLevel() {
        return condLevel;
    }

    public void setCondLevel(int condLevel) {
        this.condLevel = condLevel;
    }

    public void incCondLevel() {
        condLevel++;
    }

    public void decCondLevel() {
        condLevel--;
    }

    public ThreadCache getCache(){
        if(cache == null){
            cache = new ThreadCache(this);
        }
        return cache;
    }

	public String cfVar() {
		return "CF" + hashCode();
	}

    protected final String nTimesCondLevel() {
        return String.join("", Collections.nCopies(condLevel, "  "));
    }

    @Override
    public Thread clone(){
        // We can safely implement clone for all uncompilable classes, but we do not need it
        throw new UnsupportedOperationException("Cloning is not supported for " + this.getClass().getName());
    }

    public List<Event> getEvents(){
        // We can safely implement getEvents for all uncompilable classes, but we do not need it
        throw new UnsupportedOperationException("Retrieving events is not supported for " + this.getClass().getName());
    }

    public Thread unroll(int steps) {
        throw new UnsupportedOperationException("Unrolling is not allowed for " + this.getClass().getName());
    }

	public Thread compile(Arch target) {
        throw new UnsupportedOperationException("Compilation is not allowed for " + this.getClass().getName());
	}

    public int setEId(int i){
        throw new UnsupportedOperationException("Event ID cannot be set for " + this.getClass().getName());
    }

	public BoolExpr encodeCF(Context ctx){
        throw new UnsupportedOperationException("Encoding is not allowed for " + this.getClass().getName());
    }

	public static Thread fromArray(boolean createSkipOnNull, Thread... threads) {
		return fromList(createSkipOnNull, Arrays.asList(threads));
	}

	public static Thread fromList(boolean createSkipOnNull, List<Thread> threads) {
		Thread result = null;
		for (Thread t : threads) {
			if(t != null){
				result = result == null ? t : new Seq(result, t);
			}
		}
		if(result == null && createSkipOnNull){
			result = new Skip();
		}
		return result;
	}
}
