package dartagnan.program;

import java.util.Collections;

import dartagnan.expression.BExpr;

public class While extends Thread {
	
	private BExpr pred;
	private Thread t;
	
	public While(BExpr pred, Thread t) {
		this.pred = pred;
		this.t = t;
		t.incCondLevel();
	}
	
	public String toString() {
		return String.format("%swhile %s {\n%s\n%s}", String.join("", Collections.nCopies(condLevel, "  ")), pred, t, String.join("", Collections.nCopies(condLevel, "  ")));
	}
	
	public void incCondLevel() {
		condLevel++;
		t.incCondLevel();
	}
	
	public void decCondLevel() {
		condLevel--;
		t.decCondLevel();
	}
	
	public Thread unroll(int steps) {
		if(steps == 0)
			return new Skip();
		else {
			Thread copyT = t.clone();
			copyT.decCondLevel();
			copyT = copyT.unroll(steps);
			int oldCondLevel = condLevel;
			Thread newThread = new If(pred, new Seq(copyT, this.unroll(steps - 1)), new Skip());
			newThread.condLevel = oldCondLevel;
			return newThread;
		}
	}
	
	public While clone() {
		BExpr newPred = pred.clone();
		Thread newT = t.clone();
		newT.decCondLevel();
		While newWhile = new While(newPred, newT);
		newWhile.condLevel = condLevel;
		return newWhile;
	}
}