package com.dat3m.ui.button;

import java.awt.Dimension;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.JButton;
import javax.swing.JComboBox;

import com.dat3m.dartagnan.wmm.utils.Mode;
import com.dat3m.ui.options.RelSelector;
import com.dat3m.ui.options.OptionsPane;
import com.dat3m.ui.options.utils.ControlCode;

public class RelsButton extends JButton implements ActionListener {

	private boolean graphSelected = false;
	private boolean modeAllowed = false;
	private final RelSelector relSelector;
	
	public RelsButton(RelSelector relSelector) {
        super("Relation Selector");
        this.relSelector = relSelector;
        setActionCommand(ControlCode.RELS.actionCommand());
		setToolTipText("Knaster-Tarski mode does not allow to generate execution graph");
		setMaximumSize(new Dimension(OptionsPane.OPTWIDTH / 2, 50));
		setEnabled(false);
		addActionListener(this);
	}
	
	@Override
	public void actionPerformed(ActionEvent e) {
		String command = e.getActionCommand();
		if(ControlCode.GRAPH.actionCommand().equals(command)){
			graphSelected = ((GraphButton)e.getSource()).isSelected();
			refresh();
		} else if(ControlCode.MODE.actionCommand().equals(command)){
			modeAllowed = Mode.KNASTER != ((JComboBox<?>)e.getSource()).getSelectedItem();
			refresh();
		} else if(ControlCode.RELS.actionCommand().equals(command)){
			relSelector.open();
		}
	}

	private void refresh() {
		setEnabled(graphSelected && modeAllowed);
	}
}
