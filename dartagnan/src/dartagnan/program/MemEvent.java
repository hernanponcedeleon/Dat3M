package dartagnan.program;

import com.microsoft.z3.Expr;

public class MemEvent extends Event {
	
	protected Location loc;
	// Used by DF_RF to know what SSA number was assigned to the event location 
	public Expr ssaLoc;
	protected int memId;
	
	public MemEvent() {}
	
	public Location getLoc() {
		return loc;
	}
}