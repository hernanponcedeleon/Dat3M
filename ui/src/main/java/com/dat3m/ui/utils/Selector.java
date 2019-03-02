package com.dat3m.ui;

import static java.awt.FlowLayout.LEFT;

import java.awt.FlowLayout;
import java.awt.event.ActionListener;

import javax.swing.JComboBox;
import javax.swing.JLabel;
import javax.swing.JPanel;

public class Selector extends JPanel {		
	
	private JComboBox<?> selector;
	
	public Selector(Object[] options, String label, ActionListener caller) {
		selector = new JComboBox<Object>(options);
		selector.setActionCommand(label);
		selector.addActionListener(caller);
		JLabel sLabel = new JLabel(label + ": ");
		this.setLayout(new FlowLayout(LEFT));
		this.add(sLabel);
		this.add(selector);
	}
	
	@Override
	public void setEnabled(boolean b) {
		selector.setEnabled(b);
	}
}
