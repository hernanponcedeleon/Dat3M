package dartagnan.program.event;

import com.microsoft.z3.Expr;
import dartagnan.program.Location;

public abstract class MemEvent extends Event {
	
	protected Location loc;
	// Used by DF_RF to know what SSA number was assigned to the event location 
	public Expr ssaLoc;
	protected int memId;
	
	public Location getLoc() {
		return loc;
	}
}