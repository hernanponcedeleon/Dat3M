package com.dat3m.dartagnan.witness;

import java.util.HashMap;
import java.util.Map;

public class ElemWithAttributes {

	protected Map<String, String> attributes = new HashMap<>();
	
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
