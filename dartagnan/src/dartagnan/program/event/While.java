package dartagnan.program.event;

import dartagnan.expression.ExprInterface;
import dartagnan.program.Seq;
import dartagnan.program.Thread;

import java.util.HashSet;
import java.util.Set;

public class While extends Event {

	private ExprInterface pred;
	private Thread t;
	
	public While(ExprInterface pred, Thread t) {
		this.pred = pred;
		this.t = t;
		t.incCondLevel();
	}

	@Override
	public void incCondLevel() {
		condLevel++;
		t.incCondLevel();
	}

    @Override
	public void decCondLevel() {
		condLevel--;
		t.decCondLevel();
	}

    @Override
	public Thread unroll(int steps, boolean obsNoTermination) {
		if(steps == 0) {
			if(obsNoTermination) {
				/*
				Register rTerm = new Register("rTerm");
				Local newLocal = new Local(rTerm, new AConst(1));
				newLocal.condLevel = condLevel;
				Location termination = new Location("termination_" + hashCode());
				Store newStore = new Store(termination, rTerm, "_rx");
				newStore.condLevel = condLevel;
				ExprInterface newPred = pred.clone();
				Thread newThread = new If(newPred, new Seq(newLocal, newStore), new Skip());
				newThread.condLevel = condLevel;
				return newThread;
				*/
			}
			return new Skip();
		}
		else {
			Thread copyT = t.clone();
			copyT.decCondLevel();
			copyT = copyT.unroll(steps);
			ExprInterface newPred = pred.clone();
			Thread newThread = new If(newPred, new Seq(copyT, unroll(steps - 1, obsNoTermination)), new Skip());
			newThread.setCondLevel(condLevel);
			return newThread;
		}
	}

	@Override
	public Set<Event> getEvents() {
		Set<Event> ret = new HashSet<>(t.getEvents());
		ret.add(this);
		return ret;
	}

    @Override
	public Thread unroll(int steps) {
		return unroll(steps, false);
	}

    @Override
    public void beforeClone(){
	    super.beforeClone();
        t.beforeClone();
    }

    @Override
	public While clone() {
		if(clone == null){
			Thread newT = t.clone();
			newT.decCondLevel();
			clone = new While(pred.clone(), newT);
			afterClone();
		}
		return (While)clone;
	}

    @Override
    public String toString() {
        return nTimesCondLevel() + "while " + pred + " {\n" + t + "\n" + nTimesCondLevel() + "}";
    }
}