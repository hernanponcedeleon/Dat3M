package dartagnan.program;

public class Location {

	private String name;
	
	public Location(String name) {
		this.name = name;
	}
	
	public String getName() {
		return name;
	}
	
	public String toString() {
		return String.format("%s", name);
	}
	
	public Location clone() {
		return this;
	}
}
