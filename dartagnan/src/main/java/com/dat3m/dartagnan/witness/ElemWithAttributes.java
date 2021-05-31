package com.dat3m.dartagnan.witness;

import java.util.SortedMap;
import java.util.TreeMap;

public class ElemWithAttributes {

	protected SortedMap<String, String> attributes = new TreeMap<>();
	
	public void addAttribute(String key, String value) {
		attributes.put(key, value);
	}
	
	public boolean hasAttributed(String key) {
		return attributes.containsKey(key);
	}

	public String getAttributed(String key) {
		return attributes.get(key);
	}
}
