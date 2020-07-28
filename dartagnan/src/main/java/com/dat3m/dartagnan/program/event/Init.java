package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.program.memory.Address;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.utils.EncodingConf;

public class Init extends MemEvent {

	private final IConst value;
	
	public Init(Address address, IConst value) {
		super(address, null);
		this.value = value;
		addFilters(EType.ANY, EType.VISIBLE, EType.MEMORY, EType.WRITE, EType.INIT);
	}

	private Init(Init other){
		super(other);
		this.value = other.value;
	}

	public IConst getValue(){
		return value;
	}

	@Override
	public void initialise(EncodingConf conf) {
		super.initialise(conf);
		memValueExpr = value.toZ3NumExpr(conf);
	}

	@Override
	public String toString() {
		return "*" + address + " := " + value;
	}

	@Override
	public String label(){
		return "W";
	}

	@Override
	public IConst getMemValue(){
		return value;
	}


	// Unrolling
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public Init getCopy(){
		return new Init(this);
	}
}