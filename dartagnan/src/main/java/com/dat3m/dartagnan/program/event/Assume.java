package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.program.utils.EType;

public class Assume extends Event {

	public Assume() {
		addFilters(EType.AASSERTION);
	}
	
	@Override
	public String toString() {
		return "Assume Failed";
	}
	
	@Override
	public Assume getCopy() {
		return new Assume();
		
	}
}
