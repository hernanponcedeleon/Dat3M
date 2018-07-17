package dartagnan.program;

import java.util.HashSet;
import java.util.Set;

import com.microsoft.z3.*;

import dartagnan.program.event.Event;
import dartagnan.program.event.Skip;
import dartagnan.utils.LastModMap;
import dartagnan.utils.MapSSA;
import dartagnan.utils.Pair;

public class Seq extends Thread {
	
	private Thread t1;
	private Thread t2;
	
	public Seq(Thread t1, Thread t2) {
		this.t1 = t1;
		this.t2 = t2;
		this.condLevel = 0;
	}
	
	public String toString() {
		if (t2 instanceof Skip)
			return t1.toString();
		else
			return String.format("%s;\n%s", t1, t2);
	}
	
	public Thread getT1() {
		return t1;
	}
	
	public Thread getT2() {
		return t2;
	}
	
	public void setGuard(BoolExpr guard, Context ctx) {
		t1.setGuard(guard, ctx);
		t2.setGuard(guard, ctx);
	}
	
	public LastModMap setLastModMap(LastModMap map) {
		LastModMap newMap = t1.setLastModMap(map);
		return t2.setLastModMap(newMap);
	}
	
	public void setCondRegs(Set<Register> setRegs) {
		t1.setCondRegs(setRegs);
		t2.setCondRegs(setRegs);
	}
	
	public void incCondLevel() {
		condLevel++;
		t1.incCondLevel();
		t2.incCondLevel();
	}
	
	public void decCondLevel() {
		condLevel--;
		t1.decCondLevel();
		t2.decCondLevel();
	}
	
	public Seq unroll(int steps, boolean obsNoTermination) {
		t1 = t1.unroll(steps, obsNoTermination);
		t2 = t2.unroll(steps, obsNoTermination);
		return this;
	}
	
	public Seq unroll(int steps) {
		return unroll(steps, false);
	}

	
	public Seq compile(String target, boolean ctrl, boolean leading) {
		t1 = t1.compile(target, ctrl, leading);
		t2 = t2.compile(target, ctrl, leading);
		return this;
	}
	
	public Seq optCompile(boolean ctrl, boolean leading) {
		t1 = t1.optCompile(ctrl, leading);
		t2 = t2.optCompile(ctrl, leading);
		return this;
	}

	public Seq allCompile() {
		t1 = t1.allCompile();
		t2 = t2.allCompile();
		return this;
	}
	
	public Seq clone() {
		Thread newT1 = t1.clone();
		Thread newT2 = t2.clone();
		Seq newSeq = new Seq(newT1, newT2);
		newSeq.condLevel = condLevel;
		return newSeq;
	}
	
	public Pair<BoolExpr, MapSSA> encodeDF(MapSSA map, Context ctx) throws Z3Exception {
		if(mainThread == null){
			System.out.println(String.format("Check encodeDF for %s", this));
			return null;
		}
		else {
			Pair<BoolExpr, MapSSA> p1 = t1.encodeDF(map, ctx);
			Pair<BoolExpr, MapSSA> p2 = t2.encodeDF(p1.getSecond(), ctx);
			return new Pair<BoolExpr, MapSSA>(ctx.mkAnd(p1.getFirst(), p2.getFirst()), p2.getSecond());
		}
	}
	
	public void setMainThread(Integer t) {
		this.mainThread = t;
		t1.setMainThread(t);
		t2.setMainThread(t);
	}
	
	public Integer setEId(Integer i) {
		i = t1.setEId(i);
		i = t2.setEId(i);
		return i;
	}
	
	public Integer setTId(Integer i) {
		this.tid = i;
		i++;
		i = t1.setTId(i);
		i = t2.setTId(i);
		return i;
	}

	public Set<Event> getEvents() {
		Set<Event> ret = new HashSet<Event>();
		ret.addAll(t1.getEvents());
		ret.addAll(t2.getEvents());
		return ret;
	}
	
	public BoolExpr encodeCF(Context ctx) throws Z3Exception {
		return ctx.mkAnd(
				ctx.mkImplies(ctx.mkOr(ctx.mkBoolConst(t1.cfVar()), ctx.mkBoolConst(t2.cfVar())), ctx.mkBoolConst(cfVar())),
				ctx.mkImplies(ctx.mkBoolConst(cfVar()), ctx.mkAnd(ctx.mkBoolConst(t1.cfVar()), ctx.mkBoolConst(t2.cfVar()))),
				t1.encodeCF(ctx),
				t2.encodeCF(ctx));
	}
	
	public BoolExpr allExecute(Context ctx) throws Z3Exception {
		return ctx.mkAnd(
				ctx.mkEq(ctx.mkAnd(ctx.mkBoolConst(t1.cfVar()), ctx.mkBoolConst(t2.cfVar())), ctx.mkBoolConst(cfVar())),
				t1.allExecute(ctx),
				t2.allExecute(ctx));
	}

}