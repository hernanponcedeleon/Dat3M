package dartagnan.program;

import java.util.Collections;

public class Fence extends Event {

	protected String name;

	public Fence(String name, int condLevel){
		this.name = name;
		this.condLevel = condLevel;
	}

	public Fence(String name){
		this(name, 0);
	}

	public String getName(){
		return name;
	}

	public String toString() {
		return name + String.join("", Collections.nCopies(condLevel, "  "));
	}

	public Fence clone() {
		return new Fence(name, condLevel);
	}
}
