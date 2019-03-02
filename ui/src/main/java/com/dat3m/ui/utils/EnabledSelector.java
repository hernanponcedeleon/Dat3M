package com.dat3m.ui.utils;

import static java.awt.FlowLayout.LEFT;

import java.awt.FlowLayout;
import java.awt.event.ActionListener;

import javax.swing.JComboBox;
import javax.swing.JLabel;
import javax.swing.JPanel;

public class EnabledSelector extends JPanel {		
	
	private JComboBox<?> selector;
	
	public EnabledSelector(Object[] options, String label, ActionListener caller) {
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
