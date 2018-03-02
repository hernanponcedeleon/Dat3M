package dartagnan.program;

public class Location {

	private String name;
	private Integer iValue;
	private Integer min;
	private Integer max;
	
	public Location(String name) {
		this.name = name;
	}
	
	public String getName() {
		return name;
	}
	
	public void setIValue(int iValue) {
		this.iValue = iValue;
	}
	
	public Integer getIValue() {
		return iValue;
	}
	
	public void setMin(int min) {
		this.min = min;
	}
	
	public Integer getMin() {
		return min;
	}
	
	public void setMax(int max) {
		this.max = max;
	}
	
	public Integer getMax() {
		return max;
	}
	
	public String toString() {
		return name;
	}
	
	public Location clone() {
		return this;
	}
}
