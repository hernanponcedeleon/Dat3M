package com.dat3m.ui.button;

import static com.dat3m.dartagnan.wmm.utils.Mode.KNASTER;
import static com.dat3m.ui.options.OptionsPane.OPTWIDTH;

import java.awt.Dimension;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.JButton;
import javax.swing.JComboBox;

import com.dat3m.ui.options.utils.ControlCode;

public class RelsButton extends JButton implements ActionListener {

	private boolean graphSelected = false;
	private boolean modeAllowed = false;
	
	public RelsButton() {
        super("Relation Selector");
        setActionCommand(ControlCode.RELS.actionCommand());
        setEnabled(false);
		setToolTipText("Knaster-Tarski mode does not allow to generate execution graph");
		setMaximumSize(new Dimension(OPTWIDTH/2, 50));
	}

	public void refresh() {
		setEnabled(graphSelected && modeAllowed);
	}
	
	@Override
	public void actionPerformed(ActionEvent e) {
		if(e.getActionCommand().equals(ControlCode.GRAPH.actionCommand()) && e.getSource() instanceof GraphButton){
			graphSelected = ((GraphButton)e.getSource()).isSelected();
			refresh();
		}
		if(e.getActionCommand().equals(ControlCode.MODE.actionCommand()) && e.getSource() instanceof JComboBox<?>){
			modeAllowed = !(((JComboBox<?>)e.getSource()).getSelectedItem()).equals(KNASTER);
			refresh();
		}
	}
}
