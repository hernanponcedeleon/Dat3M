package dartagnan.program;

import java.util.Collections;

public class Sync extends Barrier {

	public Sync() {
		this.condLevel = 0;
	}
	
	public String toString() {
		return String.format("%ssync", String.join("", Collections.nCopies(condLevel, "  ")));
	}
	
	public Sync clone() {
		Sync newSync = new Sync();
		newSync.condLevel = condLevel;
		return newSync;
	}
}
