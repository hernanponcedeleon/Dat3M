package com.dat3m.ui.button;

import static com.dat3m.ui.options.OptionsPane.OPTWIDTH;

import java.awt.Dimension;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.JButton;

import com.dat3m.ui.options.utils.ControlCode;

public class RelsButton extends JButton implements ActionListener {

	private boolean drawGraphSelected = false;
	//private boolean mmParsed = false;
	
	public RelsButton() {
        super("Relation Selector");
        setActionCommand(ControlCode.RELS.actionCommand());
        setEnabled(false);
		setMaximumSize(new Dimension(OPTWIDTH/2, 50));
	}

	public void refreshButton() {
		setEnabled(drawGraphSelected);
	}
	
	@Override
	public void actionPerformed(ActionEvent e) {
		if(e.getActionCommand().equals(ControlCode.GRAPH.actionCommand())){
			drawGraphSelected = ((GraphButton)e.getSource()).isSelected();
			refreshButton();
		}
	}
}
