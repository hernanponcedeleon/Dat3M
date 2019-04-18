package com.dat3m.ui.button;

import static com.dat3m.ui.options.OptionsPane.OPTWIDTH;

import java.awt.Dimension;

import javax.swing.JButton;

import com.dat3m.ui.options.utils.ControlCode;

public class TestButton extends JButton {

	public TestButton() {
		super("Test");
        setActionCommand(ControlCode.TEST.actionCommand());
		setMaximumSize(new Dimension(OPTWIDTH, 50));
	}
}
