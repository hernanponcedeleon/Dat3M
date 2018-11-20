package dartagnan.program.event;

import com.microsoft.z3.Expr;
import dartagnan.program.memory.Location;

public abstract class MemEvent extends Event {
	
	protected Location loc;
	protected Expr ssaLoc;
	protected int memId;

	public Expr getSsaLoc(){
		return ssaLoc;
	}

	@Override
	public Location getLoc() {
		return loc;
	}
}