package dartagnan.program.event;

import dartagnan.program.Thread;

import java.util.Collections;

public class Skip extends Event {
	
	public Skip() {
		this.condLevel = 0;
	}
	
	public String toString() {
		return String.format("%sskip", String.join("", Collections.nCopies(condLevel, "  ")));
	}
	
	public Skip clone() {
		Skip newSkip = new Skip();
		newSkip.condLevel = condLevel;
		return newSkip;
	}
	
	public Thread allCompile() {
		return this;
	}
}