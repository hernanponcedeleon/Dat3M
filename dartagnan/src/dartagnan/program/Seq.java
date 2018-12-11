package dartagnan.program;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import dartagnan.program.event.Event;
import dartagnan.program.event.Skip;
import dartagnan.utils.MapSSA;
import dartagnan.utils.Pair;

import java.util.ArrayList;
import java.util.List;

public class Seq extends Thread {
	
	private Thread t1;
	private Thread t2;
	
	public Seq(Thread t1, Thread t2) {
		this.t1 = t1;
		this.t2 = t2;
		this.condLevel = 0;
	}
	
	public Thread getT1() {
		return t1;
	}
	
	public Thread getT2() {
		return t2;
	}

    @Override
    public void setMainThread(Thread t) {
        this.mainThread = t;
        t1.setMainThread(t);
        t2.setMainThread(t);
    }

    @Override
    public int setTId(int i) {
        this.tid = i;
        i++;
        i = t1.setTId(i);
        i = t2.setTId(i);
        return i;
    }

    @Override
	public void incCondLevel() {
		condLevel++;
		t1.incCondLevel();
		t2.incCondLevel();
	}

    @Override
	public void decCondLevel() {
		condLevel--;
		t1.decCondLevel();
		t2.decCondLevel();
	}

    @Override
    public int setEId(int i) {
        i = t1.setEId(i);
        i = t2.setEId(i);
        return i;
    }

    @Override
    public List<Event> getEvents() {
        List<Event> ret = new ArrayList<>();
        ret.addAll(t1.getEvents());
        ret.addAll(t2.getEvents());
        return ret;
    }

    @Override
    public void beforeClone(){
        t1.beforeClone();
        t2.beforeClone();
    }

    @Override
    public Seq clone() {
        Thread newT1 = t1.clone();
        Thread newT2 = t2.clone();
        Seq newSeq = new Seq(newT1, newT2);
        newSeq.condLevel = condLevel;
        return newSeq;
    }

    @Override
	public Seq unroll(int steps, boolean obsNoTermination) {
		t1 = t1.unroll(steps, obsNoTermination);
		t2 = t2.unroll(steps, obsNoTermination);
		return this;
	}

    @Override
	public Seq unroll(int steps) {
		return unroll(steps, false);
	}

    @Override
	public Seq compile(String target, boolean ctrl, boolean leading) {
		t1 = t1.compile(target, ctrl, leading);
		t2 = t2.compile(target, ctrl, leading);
		return this;
	}

    @Override
	public Pair<BoolExpr, MapSSA> encodeDF(MapSSA map, Context ctx) {
		if(mainThread != null){
			Pair<BoolExpr, MapSSA> p1 = t1.encodeDF(map, ctx);
			Pair<BoolExpr, MapSSA> p2 = t2.encodeDF(p1.getSecond(), ctx);
			return new Pair<>(ctx.mkAnd(p1.getFirst(), p2.getFirst()), p2.getSecond());
		}
		throw new RuntimeException("Main thread is not set for " + toString());
	}

    @Override
	public BoolExpr encodeCF(Context ctx) {
		return ctx.mkAnd(
				ctx.mkImplies(ctx.mkOr(ctx.mkBoolConst(t1.cfVar()), ctx.mkBoolConst(t2.cfVar())), ctx.mkBoolConst(cfVar())),
				ctx.mkImplies(ctx.mkBoolConst(cfVar()), ctx.mkAnd(ctx.mkBoolConst(t1.cfVar()), ctx.mkBoolConst(t2.cfVar()))),
				t1.encodeCF(ctx),
				t2.encodeCF(ctx));
	}

	@Override
    public String toString() {
        return t2 instanceof Skip ? t1.toString() : t1 + ";\n" + t2;
    }
}