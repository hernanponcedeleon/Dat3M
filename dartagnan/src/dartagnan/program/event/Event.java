package dartagnan.program.event;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import dartagnan.program.Thread;

import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

public abstract class Event extends Thread {

	public static final int PRINT_PAD_EXTRA = 50;

	private int eid;
	protected int hlId;
	protected Event clone;
	protected String atomic;
	protected Set<String> filter = new HashSet<>();
	
	public int getEId() {
		return eid;
	}

	public int setEId(int i) {
		this.eid = i;
		return i + 1;
	}

	public int getHLId() {
		return hlId;
	}
	
	public void setHLId(int id) {
		this.hlId = id;
	}

	public String repr() {
		return "E" + eid;
	}

	public BoolExpr executes(Context ctx) {
		return ctx.mkBoolConst("ex(" + repr() + ")");
	}

	public String label(){
		return repr() + " " + getClass().getSimpleName();
	}

	public boolean is(String param){
		return param != null && (filter.contains(param) || param.equals(atomic));
	}

	public void addFilters(String... params){
		filter.addAll(Arrays.asList(params));
	}

	public void initialise(Context ctx){}

	@Override
	public void beforeClone(){
		clone = null;
	}

	protected void afterClone(){
        clone.setCondLevel(condLevel);
        clone.setHLId(hlId);
    }

    @Override
	public Set<Event> getEvents() {
		Set<Event> ret = new HashSet<>();
		ret.add(this);
		return ret;
	}

    @Override
	public Thread unroll(int steps) {
		return this;
	}

    @Override
	public Thread compile(String target, boolean ctrl, boolean leading) {
		return this;
	}

	@Override
	public BoolExpr encodeCF(Context ctx) {
		return ctx.mkEq(ctx.mkBoolConst(cfVar()), executes(ctx));
	}
}