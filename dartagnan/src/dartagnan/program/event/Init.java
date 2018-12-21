package dartagnan.program.event;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import dartagnan.expression.IConst;
import dartagnan.program.memory.Address;
import dartagnan.program.utils.EType;
import dartagnan.utils.MapSSA;
import dartagnan.utils.Pair;

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
		return nTimesCondLevel() + "memory[" + address + "] := " + value;
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
	public Pair<BoolExpr, MapSSA> encodeDF(MapSSA map, Context ctx) {
		addressExpr = address.toZ3Int(map, ctx);
		valueExpr = value.toZ3Int(ctx);
		return new Pair<>(ctx.mkTrue(), map);
	}

	public IConst getValue(){
		return value;
	}
}