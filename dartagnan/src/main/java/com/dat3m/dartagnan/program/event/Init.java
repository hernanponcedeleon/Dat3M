package com.dat3m.dartagnan.program.event;

import com.microsoft.z3.Context;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.program.memory.Address;
import com.dat3m.dartagnan.program.utils.EType;

public class Init extends MemEvent {

	private IConst value;
	
	public Init(Address address, IConst value) {
		this.address = address;
		this.value = value;
		this.condLevel = 0;
		addFilters(EType.ANY, EType.VISIBLE, EType.MEMORY, EType.WRITE, EType.INIT);
	}

	@Override
	public void initialise(Context ctx) {
		memAddressExpr = address.toZ3Int(this, ctx);
		memValueExpr = value.toZ3Int(ctx);
	}

	@Override
	public String toString() {
		return nTimesCondLevel() + "*" + address + " := " + value;
	}

	@Override
	public String label(){
		return "W";
	}

	@Override
	public Init clone() {
	    if(clone == null){
            clone = new Init((Address) address, value);
            afterClone();
        }
		return (Init)clone;
	}

	public IConst getValue(){
		return value;
	}
}