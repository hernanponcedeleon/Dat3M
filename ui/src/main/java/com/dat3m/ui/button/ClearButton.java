package com.dat3m.ui.button;

import static com.dat3m.ui.options.OptionsPane.OPTWIDTH;

import java.awt.Dimension;

import javax.swing.JButton;

import com.dat3m.ui.options.utils.ControlCode;

public class ClearButton extends JButton {

	public ClearButton() {
		super("Clear Console");
        setActionCommand(ControlCode.CLEAR.actionCommand());
		setMaximumSize(new Dimension(OPTWIDTH, 50));
	}
}
