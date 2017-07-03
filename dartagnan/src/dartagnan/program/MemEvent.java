package dartagnan.program;

import com.microsoft.z3.Expr;

public class MemEvent extends Event {
	
	protected Integer hlId;
	protected Location loc;
	// Used by DF_RF to know what SSA number was assigned to the event location 
	public Expr ssaLoc;
	
	public MemEvent() {}
	
	public void setHLId(Integer id) {
		this.hlId = id;
	}

	public Integer getHLId() {
		return hlId;
	}
	
	public Location getLoc() {
		return loc;
	}
}