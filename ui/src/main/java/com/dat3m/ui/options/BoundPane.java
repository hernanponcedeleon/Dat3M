package com.dat3m.ui.options;

import static java.awt.FlowLayout.LEFT;

import java.awt.FlowLayout;

import javax.swing.JLabel;
import javax.swing.JPanel;

public class BoundPane extends JPanel {

	public BoundPane() {
        super(new FlowLayout(LEFT));
        add(new JLabel("Unrolling Bound: "));
	}
}
