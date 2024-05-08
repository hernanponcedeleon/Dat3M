package com.dat3m.dartagnan.witness.graphml;

public class Node extends ElemWithAttributes implements Comparable<Node> {

	private final String id;
	
	public Node(String id) {
		this.id = id;
	}
	
	public String getId() {
		return id;
	}
	
	public String toXML() {
		StringBuilder str = new StringBuilder();
		str.append("  <node id=\"").append(getId()).append("\">\n");
		for(String attr : attributes.keySet()) {
			str.append("    <data key=\"").append(attr).append("\">").append(attributes.get(attr)).append("</data>\n");
		}
		str.append("  </node>\n");
		return str.toString();
	}

	@Override
    public boolean equals(Object o) {
		if(o instanceof Node node) {
			return getId().equals(node.getId());
		}
		return false;
	}
	
	@Override
	public int compareTo(Node other) {
		return getId().compareTo(other.getId());
	}
}
