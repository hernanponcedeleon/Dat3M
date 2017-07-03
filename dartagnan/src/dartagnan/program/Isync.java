package dartagnan.program;

import java.util.Collections;

public class Isync extends Barrier {

	public Isync() {
		this.condLevel = 0;
	}
	
	public String toString() {
		return String.format("%sisync", String.join("", Collections.nCopies(condLevel, "  ")));
	}
	
	public Isync clone() {
		Isync newIsync = new Isync();
		newIsync.condLevel = condLevel;
		return newIsync;
	}
}
