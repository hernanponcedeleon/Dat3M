package dartagnan.program;

import java.util.Collections;

public class Isb extends Barrier {

	public Isb() {
		this.condLevel = 0;
	}
	
	public String toString() {
		return String.format("%sisb", String.join("", Collections.nCopies(condLevel, "  ")));
	}
	
	public Isb clone() {
		Isb newIsync = new Isb();
		newIsync.condLevel = condLevel;
		return newIsync;
	}
}
