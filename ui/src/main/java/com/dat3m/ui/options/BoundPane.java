package com.dat3m.ui.options;

import javax.swing.JTextField;

import com.dat3m.ui.listener.BoundListener;

public class BoundPane extends JTextField {

	private String stableBound;
	
	public BoundPane() {
		this.stableBound = "1";
		this.setColumns(3);
		this.setText("1");

		BoundListener listener = new BoundListener(this);
		this.addKeyListener(listener);
		this.addFocusListener(listener);
	}
	
	public void setStableBound(String bound) {
		this.stableBound = bound;
	}

	public String getStableBound() {
		return stableBound;
	}
}
