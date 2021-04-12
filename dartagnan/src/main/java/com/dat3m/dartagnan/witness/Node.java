package com.dat3m.dartagnan.witness;

public class Node extends ElemWithAttributes implements Comparable<Node> {

	private Integer id;
	
	public Node(Integer id) {
		this.id = id;
	}
	
	public Integer getId() {
		return id;
	}
	
	@Override
	public String toString() {
		return "N" + id;
	}
	
	public String toXML() {
		StringBuilder str = new StringBuilder();
		str.append("  <node id=\"" + toString() + "\">\n");
		for(String attr : attributes.keySet()) {
			str.append("    <data key=\"" + attr + "\">" + attributes.get(attr) + "</data>\n");
		}
		str.append("  </node>\n");
		return str.toString();
	}
	
	@Override
	public int compareTo(Node other) {
		return id.compareTo(other.id);
	}
}
