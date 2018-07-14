package dartagnan.program;

import java.util.Collections;

public class Fence extends Event {

	protected String name;

	public Fence(String name){
		this.condLevel = 0;
		this.name = name;
	}

	public String getName(){
		return name;
	}

	public String toString() {
		return name + String.join("", Collections.nCopies(condLevel, "  "));
	}

	public Fence clone() {
		Fence newBarrier = new Fence(name);
		newBarrier.condLevel = condLevel;
		return newBarrier;
	}
}
