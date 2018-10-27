package dartagnan.program;

import dartagnan.expression.AConst;
import dartagnan.expression.ExprInterface;
import dartagnan.program.event.If;
import dartagnan.program.event.Local;
import dartagnan.program.event.Skip;
import dartagnan.program.event.Store;

public class While extends Thread {

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
			}
			return new Skip();
		}
		else {
			Thread copyT = t.clone();
			copyT.decCondLevel();
			copyT = copyT.unroll(steps);
			ExprInterface newPred = pred.clone();
			Thread newThread = new If(newPred, new Seq(copyT, unroll(steps - 1, obsNoTermination)), new Skip());
			newThread.condLevel = condLevel;
			return newThread;
		}
	}

    @Override
	public Thread unroll(int steps) {
		return unroll(steps, false);
	}

    @Override
    public void beforeClone(){
        t.beforeClone();
    }

    @Override
	public While clone() {
		Thread newT = t.clone();
		newT.decCondLevel();
		ExprInterface newPred = pred.clone();
		While newWhile = new While(newPred, newT);
		newWhile.condLevel = condLevel;
		return newWhile;
	}

    @Override
    public String toString() {
        return nTimesCondLevel() + "while " + pred + " {\n" + t + "\n" + nTimesCondLevel() + "}";
    }
}