package dartagnan.program;

import java.util.Collections;

public class Lwsync extends Barrier {

	public Lwsync() {
		this.condLevel = 0;
	}
	
	public String toString() {
		return String.format("%slwsync", String.join("", Collections.nCopies(condLevel, "  ")));
	}
	
	public Lwsync clone() {
		Lwsync newLwsync = new Lwsync();
		newLwsync.condLevel = condLevel;
		return newLwsync;
	}
}
