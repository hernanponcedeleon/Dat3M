package dartagnan.program;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import dartagnan.program.event.Event;
import dartagnan.program.event.Skip;
import dartagnan.program.utils.EventRepository;
import dartagnan.utils.MapSSA;
import dartagnan.utils.Pair;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Set;

public abstract class Thread {

	protected Thread mainThread;
	protected int tid;
	protected int condLevel;
	private EventRepository eventRepository;

    public void setMainThread(Thread t) {
        this.mainThread = t;
    }

    public Thread getMainThread() {
        if(mainThread != null){
            return mainThread;
        }
        throw new RuntimeException("Main thread is not initialised for " + this);
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

    public EventRepository getEventRepository(){
        if(eventRepository == null){
            eventRepository = new EventRepository(this);
        }
        return eventRepository;
    }

	public String cfVar() {
		return "CF" + hashCode();
	}

	public void beforeClone(){}

    protected final String nTimesCondLevel() {
        return String.join("", Collections.nCopies(condLevel, "  "));
    }

    @Override
    public Thread clone(){
        // We can safely implement clone for all uncompilable classes, but we do not need it
        throw new UnsupportedOperationException("Cloning is not supported for " + this.getClass().getName());
    }

    public Set<Event> getEvents(){
        // We can safely implement getEvents for all uncompilable classes, but we do not need it
        throw new UnsupportedOperationException("Retrieving events is not supported for " + this.getClass().getName());
    }

    public Thread unroll(int steps, boolean obsNoTermination) {
        throw new UnsupportedOperationException("Unrolling is not allowed for " + this.getClass().getName());
    }

    public Thread unroll(int steps) {
        throw new UnsupportedOperationException("Unrolling is not allowed for " + this.getClass().getName());
    }

	public Thread compile(String target, boolean ctrl, boolean leading) {
        throw new UnsupportedOperationException("Compilation is not allowed for " + this.getClass().getName());
	}

    public int setEId(int i){
        throw new UnsupportedOperationException("Event ID cannot be set for " + this.getClass().getName());
    }

	public BoolExpr encodeCF(Context ctx){
        throw new UnsupportedOperationException("Encoding is not allowed for " + this.getClass().getName());
    }

	public Pair<BoolExpr, MapSSA> encodeDF(MapSSA map, Context ctx){
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
