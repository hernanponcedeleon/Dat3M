package dartagnan.program;

import java.util.Set;

import com.microsoft.z3.*;

import dartagnan.program.event.Event;
import dartagnan.program.utils.EventRepository;
import dartagnan.utils.LastModMap;
import dartagnan.utils.MapSSA;
import dartagnan.utils.Pair;

public class Thread {

	protected int condLevel;
	// Main thread where this Event, Seq, etc belongs
	protected Thread mainThread;
	protected Integer tid;
	protected BoolExpr myGuard;

	private EventRepository eventRepository;

	public EventRepository getEventRepository(){
		if(eventRepository == null){
			eventRepository = new EventRepository(this);
		}
		return eventRepository;
	}
	
	public int getCondLevel() {
		return condLevel;
	}

	public void setCondLevel(int condLevel) {
		this.condLevel = condLevel;
	}
	
	public void setGuard(BoolExpr guard, Context ctx) {
		System.out.println("Check setGuard!");
	}
	
	public void incCondLevel() {
		condLevel++;
	}
	
	public void decCondLevel() {
		condLevel--;
	}
	
	public Thread unroll(int steps, boolean obsNoTermination) {
		System.out.println("Check unroll!");
		return this;
	}
	
	public Thread unroll(int steps) {
		System.out.println("Check unroll!");
		return this;
	}
	
	public Thread compile(String target, boolean ctrl, boolean leading) {
		System.out.println("Check compile!");
		return this;
	}
	
	public Thread optCompile(boolean ctrl, boolean leading) {
		// CHECK!
		return compile("", false, true);
	}
	
	public Thread allCompile() {
		System.out.println("Problem all compile!");
		return null;
	}

	public Thread clone() {
		System.out.println("Problem with clone!");
		return new Thread();
	}

	public void setMainThread(Thread t) {
		this.mainThread = t;
	}

	public Thread getMainThread() {
		if(mainThread == null){
			throw new RuntimeException("Main thread is not initialised for \n" + this + "\n");
		}
		return mainThread;
	}

	public Integer getMainThreadId() {
		if(mainThread == null){
			throw new RuntimeException("Main thread is not initialised for \n" + this + "\n");
		}
		return mainThread.getTId();
	}
	
	public BoolExpr encodeCF(Context ctx) throws Z3Exception {
		System.out.println("Check encodeCF!");
		// TODO Auto-generated method stub
		return null;
	}

	public Pair<BoolExpr, MapSSA> encodeDF(MapSSA map, Context ctx) throws Z3Exception {
		// TODO Auto-generated method stub
		return null;
	}

	public Integer setEId(Integer i) {
		// TODO Auto-generated method stub
		return null;
	}

	public Set<Event> getEvents() {
		// TODO Auto-generated method stub
		return null;
	}

	public Integer setTId(Integer i) {
		// TODO Auto-generated method stub
		return null;
	}

	public String cfVar() {
		return "CF" + hashCode();
	}

	public LastModMap setLastModMap(LastModMap newMap) {
		// TODO Auto-generated method stub
		return null;
	}

	public Integer getTId() {
		return this.tid;
	}

	public BoolExpr allExecute(Context ctx) {
		// TODO Auto-generated method stub
		System.out.println("Check allExecute!");
		return null;
	}
}
