package dartagnan.program.event;

import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

import com.microsoft.z3.*;

import dartagnan.expression.ExprInterface;
import dartagnan.program.*;
import dartagnan.program.Thread;
import dartagnan.utils.LastModMap;
import dartagnan.utils.MapSSA;
import dartagnan.utils.Pair;

public abstract class Event extends Thread {
	
	private Integer eid;
	private Integer hlId;
	private Integer unfCopy;
	protected String atomic;

	private Set<Register> condReg;
	protected LastModMap lastModMap;
	protected Set<String> filter = new HashSet<>();

	public boolean is(String param){
		return param != null && (filter.contains(param) || param.equals(atomic));
	}

	public void addFilters(String... params){
		filter.addAll(Arrays.asList(params));
	}
	
	public Integer getEId() {
		return eid;
	}
	
	public void setHLId(Integer id) {
		this.hlId = id;
	}

	public Integer getHLId() {
		return hlId;
	}
	
	public void setUnfCopy(Integer id) {
		this.unfCopy = id;
	}

	public Integer getUnfCopy() {
		return unfCopy;
	}
	
	public LastModMap getLastModMap() {
		assert(lastModMap.size() != 0);
		return lastModMap;
	}
		
	public LastModMap setLastModMap(LastModMap map) {
		this.lastModMap =  map;
		return map;
	}
	
	public void setGuard(BoolExpr guard, Context ctx) {
		myGuard = guard;
	}	

	public BoolExpr getGuard() {
		return myGuard;
	}
	
	public void incCondLevel() {
		condLevel++;
	}

	public Thread unroll(int steps, boolean obsTermination) {
		unfCopy = steps;
		return this;
	}
	
	public Thread unroll(int steps) {
		return unroll(steps, false);
	}

	public Thread compile(String target, boolean ctrl, boolean leading) {
		setHLId(hashCode());
		return this;
	}

	public Thread allCompile() {
		OptFence os = new OptFence("Sync");
		os.condLevel = condLevel;
		OptFence olws = new OptFence("Lwsync");
		olws.condLevel = condLevel;
		return new Seq(os, new Seq(olws, this));
	}

	public String repr() {
		return String.format("E%s", eid);
	}
	
	public BoolExpr executes(Context ctx) throws Z3Exception {
		return ctx.mkBoolConst(String.format("ex(%s)", repr()));
	}
	
	public Pair<BoolExpr, MapSSA> encodeDF(MapSSA map, Context ctx) throws Z3Exception {
		return new Pair<BoolExpr, MapSSA>(ctx.mkTrue(), map);
	}
	
	public void setMainThread(Integer t) {
		this.mainThread = t;
	}
	
	public Integer setEId(Integer i) {
		this.eid = i;
		return i+1;
	}

	public Integer setTId(Integer i) {
		this.tid = i;
		return i+1;
	}

	public Set<Event> getEvents() {
		Set<Event> ret = new HashSet<Event>();
		ret.add(this);
		return ret;
	}
	
	public BoolExpr encodeCF(Context ctx) throws Z3Exception {
		return ctx.mkEq(ctx.mkBoolConst(cfVar()), executes(ctx));
	}

	public BoolExpr allExecute(Context ctx) throws Z3Exception {
		return ctx.mkEq(ctx.mkBoolConst(cfVar()), executes(ctx));
	}

	public Set<Register> getCondRegs() {
		if(condReg == null) {
			System.out.println(String.format("Check getCondRegs for %s: null pointer!", repr()));
		}
		return condReg;
	}
	
	public void setCondRegs(Set<Register> regSet) {
		condReg = regSet;
	}

	public Register getReg() {
		// This should be never executes; should match a more concrete class
		System.out.println(String.format("Check getReg for %s", this));
		return null;
	}
	
	public Integer getSsaRegIndex() {
		System.out.println(String.format("Check getSSAReg for %s", this));
		return null;
	}
	
	public Location getLoc() {
		// This should be never executes; should match a more concrete class
		System.out.println(String.format("Check getLoc for %s", this));
		return null;
	}

	public ExprInterface getExpr() {
		// This should be never executes; should match a more concrete class
		System.out.println(String.format("Check getExpr for %s", this));
		return null;
	}
}