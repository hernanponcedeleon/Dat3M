package dartagnan.program.event;

import dartagnan.program.utils.EType;

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
		this.addFilters(EType.ANY, EType.FENCE, name);
	}

	public String getName(){
		return name;
	}

	@Override
	public String toString() {
		if(atomic == null){
			return nTimesCondLevel() + name;
		}
		return nTimesCondLevel() + name + " " + atomic;
	}

	@Override
	public Fence clone() {
		return new Fence(name, condLevel, atomic);
	}

	@Override
	public String label(){
		return getName();
	}
}
