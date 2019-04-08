package com.dat3m.ui.graph;

import java.awt.Dimension;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JRadioButton;

import com.dat3m.dartagnan.wmm.Wmm;

public class RelSelector extends JFrame implements ActionListener {

	private Wmm tmm;
	private Wmm smm;
	// To avoid repeating names of common relations between both MM
	private Set<String> names;
	private Set<String> selection = new HashSet<>();
	
	public void setTMM(Wmm mm) {
		this.tmm = mm;
	}

	public void setSMM(Wmm mm) {
		this.smm = mm;
	}

	public Set<String> getSelection() {
		return selection;
	}

	public void open() {
		names = new HashSet<>();
        JPanel radioPanel = new JPanel(new GridLayout(0, 1));
        // To have the height based on the number of options
        int nButton = 0;
        
        nButton = createButtons(smm, tmm, radioPanel, nButton);

        // To have a minimal height when there are no relations
        nButton = Math.max(nButton, 2);
        radioPanel.setPreferredSize(new Dimension(200, nButton * 30));
        setContentPane(radioPanel);
        pack();
        setVisible(true);
    }

	private int createButtons(Wmm smm, Wmm tmm, JPanel radioPanel, int nButtom) {
		List<String> rels = new ArrayList<>();
		if(smm != null) {
        	rels.addAll(smm.getRelationRepository().getRelations().stream()
        			.filter(ev -> !ev.getName().equals(ev.getTerm()))
        			.map(ev -> ev.getName()).collect(Collectors.toList()));
		}
    	if(tmm != null) {
        	rels.addAll(tmm.getRelationRepository().getRelations().stream()
        			.filter(ev -> !ev.getName().equals(ev.getTerm()))
        			.map(ev -> ev.getName()).collect(Collectors.toList()));        		
    	}
    	Collections.sort(rels);
    	for(String name : rels) {
    		if(names.contains(name)) {
    			continue;
    		}
    		names.add(name);
            JRadioButton button = new JRadioButton(name);
            button.setName(name);
            button.addActionListener(this);
            // To remember previous choice
            button.setSelected(selection.contains(name));
            radioPanel.add(button);
            nButtom ++;
    	}        	
		return nButtom;
	}

	@Override
	public void actionPerformed(ActionEvent e) {
		JRadioButton button = (JRadioButton)e.getSource();
		String name = button.getName();
		if(button.isSelected()) {
			selection.add(name);			
		} else {
			selection.remove(name);
		}
	}
}
