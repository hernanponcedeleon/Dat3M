package com.dat3m.dartagnan.witness;

import static java.lang.Integer.compare;
import static java.lang.Integer.parseInt;

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
		str.append("  <node id=\"").append(getId()).append("\">\n");
		for(String attr : attributes.keySet()) {
			str.append("    <data key=\"").append(attr).append("\">").append(attributes.get(attr)).append("</data>\n");
		}
		str.append("  </node>\n");
		return str.toString();
	}

	@Override
    public boolean equals(Object o) {
		if(o instanceof Node) {
			return getId().equals(((Node)o).getId());
		}
		return false;
	}
	
	@Override
	public int compareTo(Node other) {
		// We get rid of the 'N'
		return compare(parseInt(getId().substring(1)), parseInt(other.getId().substring(1)));
	}
}
