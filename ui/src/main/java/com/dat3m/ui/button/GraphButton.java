package com.dat3m.ui.button;

import static com.dat3m.ui.options.OptionsPane.OPTWIDTH;

import java.awt.Dimension;

import javax.swing.JButton;

import com.dat3m.ui.options.utils.ControlCode;

public class GraphButton extends JButton {

	public GraphButton() {
        super("Execution Witness");
        setActionCommand(ControlCode.GRAPH.actionCommand());
        setEnabled(false);
		setMaximumSize(new Dimension(OPTWIDTH, 50));
	}
}
