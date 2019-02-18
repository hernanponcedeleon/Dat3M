package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.program.utils.EType;

public class Skip extends Event {
	
	public Skip() {
		this.condLevel = 0;
		addFilters(EType.ANY);
	}

	@Override
	public String toString() {
		return nTimesCondLevel() + "skip";
	}

	@Override
	public Skip clone() {
		if(clone == null){
			clone = new Skip();
			afterClone();
		}
		return (Skip)clone;
	}
}