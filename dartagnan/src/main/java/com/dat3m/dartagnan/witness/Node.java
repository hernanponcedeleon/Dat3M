package com.dat3m.dartagnan.witness;

public class Node extends ElemWithAttributes implements Comparable<Node> {

	private String id;
	
	public Node(String id) {
		this.id = id;
	}
	
	public String getId() {
		return id;
	}
	
	public String toXML() {
		StringBuilder str = new StringBuilder();
		str.append("  <node id=\"" + getId() + "\">\n");
		for(String attr : attributes.keySet()) {
			str.append("    <data key=\"" + attr + "\">" + attributes.get(attr) + "</data>\n");
		}
		str.append("  </node>\n");
		return str.toString();
	}

	@Override
    public boolean equals(Object o) {
		if(o instanceof Node) {
			getId().equals(((Node)o).getId());
		}
		return false;
	}
	
	@Override
	public int compareTo(Node other) {
		return getId().compareTo(other.getId());
	}
}
