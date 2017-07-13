package dartagnan.program;

import java.util.Collections;

public class Ish extends Barrier {

	public Ish() {
		this.condLevel = 0;
	}
	
	public String toString() {
		return String.format("%sish", String.join("", Collections.nCopies(condLevel, "  ")));
	}
	
	public Ish clone() {
		Ish newSync = new Ish();
		newSync.condLevel = condLevel;
		return newSync;
	}
}
