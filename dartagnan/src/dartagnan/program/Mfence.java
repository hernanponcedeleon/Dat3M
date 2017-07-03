package dartagnan.program;

import java.util.Collections;

public class Mfence extends Barrier {

	public Mfence() {
		this.condLevel = 0;
	}
	
	public String toString() {
		return String.format("%smfence", String.join("", Collections.nCopies(condLevel, "  ")));
	}
	
	public Mfence clone() {
		Mfence newMfence = new Mfence();
		newMfence.condLevel = condLevel;
		return newMfence;
	}
}
