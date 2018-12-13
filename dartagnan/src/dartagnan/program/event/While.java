package dartagnan.program.event;

import dartagnan.expression.ExprInterface;
import dartagnan.program.Seq;
import dartagnan.program.Thread;

import java.util.ArrayList;
import java.util.List;

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
	public Thread unroll(int steps) {
		if(steps > 0){
		    t.beforeClone();
			Thread copyT = t.clone();
			copyT.decCondLevel();
			copyT = copyT.unroll(steps);
			ExprInterface newPred = pred.clone();
			Thread newThread = new If(newPred, new Seq(copyT, unroll(steps - 1)), new Skip());
			newThread.setCondLevel(condLevel);
			return newThread;
		}
		return new Skip();
	}

	@Override
	public List<Event> getEvents() {
		List<Event> ret = new ArrayList<>(t.getEvents());
		ret.add(this);
		return ret;
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