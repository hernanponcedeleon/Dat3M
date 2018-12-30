package dartagnan.program.event;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import dartagnan.expression.IConst;
import dartagnan.program.memory.Address;
import dartagnan.program.utils.EType;

public class Init extends MemEvent {

	private IConst value;
	
	public Init(Address address, IConst value) {
		this.address = address;
		this.value = value;
		this.condLevel = 0;
		addFilters(EType.ANY, EType.MEMORY, EType.WRITE, EType.INIT);
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
            clone = new Init((Address) address.clone(), value.clone());
            afterClone();
        }
		return (Init)clone;
	}

	@Override
	public BoolExpr encodeDF(Context ctx) {
		addressExpr = address.toZ3Int(this, ctx);
		valueExpr = value.toZ3Int(ctx);
		return ctx.mkTrue();
	}

	public IConst getValue(){
		return value;
	}
}