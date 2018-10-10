package dartagnan.program.event;

import dartagnan.program.event.filter.FilterUtils;

import java.util.Collections;

public class Fence extends Event {

	protected String name;

	public Fence(String name){
		this(name, 0, null);
	}

	public Fence(String name, int condLevel){
		this(name, condLevel, null);
	}

	public Fence(String name, int condLevel, String atomic){
		this.name = name;
		this.condLevel = condLevel;
		this.atomic = atomic;
		this.addFilters(
				FilterUtils.EVENT_TYPE_ANY,
				FilterUtils.EVENT_TYPE_FENCE,
				name
		);
	}

	public String getName(){
		return name;
	}

	public String toString() {
		if(atomic == null){
			return String.join("", Collections.nCopies(condLevel, "  ")) + name;
		}
		return String.join("", Collections.nCopies(condLevel, "  ")) + name + " " + atomic;
	}

	public Fence clone() {
		return new Fence(name, condLevel, atomic);
	}

	@Override
	public String label(){
		return getName();
	}
}
