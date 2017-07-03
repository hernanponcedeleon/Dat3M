package dartagnan.program;

import java.util.Set;
import java.util.stream.IntStream;

import com.microsoft.z3.*;

import dartagnan.utils.LastModMap;
import dartagnan.utils.MapSSA;
import dartagnan.utils.Pair;

public class Thread {

	protected int condLevel;
	// Main thread where this Event, Seq, etc belongs
	protected Integer mainThread;
	protected Integer tid;
	
	public int getCondLevel() {
		return condLevel;
	}
	
	public void setCondLevel(int condLevel) {
		IntStream.range(0, condLevel).forEachOrdered(n -> {
		    incCondLevel();
		});
	}
	
	public void incCondLevel() {
		condLevel++;
	}
	
	public void decCondLevel() {
		condLevel--;
	}
	
	public Thread unroll(int steps) {
		System.out.println("Check unroll!");
		return this;
	}
	
	public Thread compile() {
		System.out.println("Check compile!");
		return this;
	}
	
	public Thread optCompile() {
		return compile();
	}

	public Thread clone() {
		System.out.println("Problem with clone!");
		return new Thread();
	}

	public Integer getMainThread() {
		return mainThread;
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

	public void setMainThread(Integer t) {
		// TODO Auto-generated method stub
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
		//return "CF" + tid.toString();
	}

	public void setCondRegs(Set<Register> setRegs) {
		// TODO Auto-generated method stub
		
	}

	public LastModMap setLastModMap(LastModMap newMap) {
		// TODO Auto-generated method stub
		return null;
	}

	public Integer getTId() {
		return this.tid;
	}
}
