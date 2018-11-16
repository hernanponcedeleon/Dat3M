package dartagnan.program.event;

public class Skip extends Event {
	
	public Skip() {
		this.condLevel = 0;
	}

	@Override
	public String toString() {
		return nTimesCondLevel() + "skip";
	}

	@Override
	public Skip clone() {
		Skip newSkip = new Skip();
		newSkip.condLevel = condLevel;
		return newSkip;
	}
}