package dartagnan.program.event;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import dartagnan.program.Location;
import dartagnan.program.Thread;
import dartagnan.utils.MapSSA;
import dartagnan.utils.Pair;

import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

public abstract class Event extends Thread {

	private int eid;
	private int hlId;
	private int unfCopy;
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

	public int getUnfCopy() {
		return unfCopy;
	}
	
	public void setUnfCopy(int id) {
		this.unfCopy = id;
	}

	public String repr() {
		return "E" + eid;
	}

	public BoolExpr executes(Context ctx) {
		return ctx.mkBoolConst("ex(" + repr() + ")");
	}

	public String label(){
		throw new UnsupportedOperationException("Label is not available for events not shown in execution graph " + this.getClass().getName());
	}

	public boolean is(String param){
		return param != null && (filter.contains(param) || param.equals(atomic));
	}

	public void addFilters(String... params){
		filter.addAll(Arrays.asList(params));
	}

    @Override
	public Set<Event> getEvents() {
		Set<Event> ret = new HashSet<>();
		ret.add(this);
		return ret;
	}

    @Override
	public Thread unroll(int steps, boolean obsTermination) {
		unfCopy = steps;
		return this;
	}

    @Override
	public Thread unroll(int steps) {
		return unroll(steps, false);
	}

    @Override
	public Thread compile(String target, boolean ctrl, boolean leading) {
		setHLId(hashCode());
		return this;
	}

    @Override
	public Pair<BoolExpr, MapSSA> encodeDF(MapSSA map, Context ctx) {
		return new Pair<>(ctx.mkTrue(), map);
	}

	@Override
	public BoolExpr encodeCF(Context ctx) {
		return ctx.mkEq(ctx.mkBoolConst(cfVar()), executes(ctx));
	}

	// TODO: Interface
	public Location getLoc() {
		throw new UnsupportedOperationException("Location is not available for " + this.getClass().getName());
	}
}