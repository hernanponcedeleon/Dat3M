package com.dat3m.ui.graph;

import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JRadioButton;

import com.dat3m.dartagnan.wmm.Wmm;

public class RelSelector extends JFrame implements ActionListener {

    private static final int COLS = 5;

	private Wmm tmm;
	private Wmm smm;
	// To avoid repeating names of common relations between both MM
	private Set<String> names;
	// To remember previous selections
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

		setTitle("Relations");
        List<JRadioButton> relButtons = createButtons(smm, tmm);
        JPanel radioPanel = new JPanel(new GridLayout(0, COLS));

        Iterator<JRadioButton> it = relButtons.iterator();
        while(it.hasNext()) {
        	radioPanel.add(it.next());
        }
        setContentPane(radioPanel);
        pack();
        setVisible(true);
    }

	private List<JRadioButton> createButtons(Wmm smm, Wmm tmm) {
		List<JRadioButton> ret = new ArrayList<>();
		
		List<String> relNames = new ArrayList<>();
		if(smm != null) {
        	relNames.addAll(smm.getRelationRepository().getRelations().stream()
        			.filter(ev -> !ev.getName().equals(ev.getTerm()))
        			.map(ev -> ev.getName()).collect(Collectors.toList()));
		}
    	if(tmm != null) {
        	relNames.addAll(tmm.getRelationRepository().getRelations().stream()
        			.filter(ev -> !ev.getName().equals(ev.getTerm()))
        			.map(ev -> ev.getName()).collect(Collectors.toList()));        		
    	}
    	Collections.sort(relNames);
    	
    	for(String name : relNames) {
    		if(names.contains(name)) {
    			continue;
    		}
    		names.add(name);
            JRadioButton button = new JRadioButton(name);
            button.setName(name);
            button.addActionListener(this);
            // To remember previous choice
            button.setSelected(selection.contains(name));
            ret.add(button);
    	}        
    	
		return ret;
	}

	@Override
	public void actionPerformed(ActionEvent e) {
		if(e.getSource() instanceof JRadioButton) {
			JRadioButton button = (JRadioButton)e.getSource();
			String name = button.getName();
			if(button.isSelected()) {
				selection.add(name);			
			} else {
				selection.remove(name);
			}			
		}
	}
}
