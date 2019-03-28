package com.dat3m.ui.graph;

import java.awt.Dimension;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.HashSet;
import java.util.Set;
import java.util.stream.Collectors;

import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JRadioButton;

import com.dat3m.dartagnan.wmm.Wmm;

public class RelSelector extends JFrame implements ActionListener {

	private Wmm tmm;
	private Wmm smm;
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
        int nButton = 0;
        
        nButton = createButtons(tmm, radioPanel, nButton);
        nButton = createButtons(smm, radioPanel, nButton);

        nButton = Math.max(nButton, 2);
        radioPanel.setPreferredSize(new Dimension(200, nButton * 30));
        setContentPane(radioPanel);
        pack();
        setVisible(true);
    }

	public int createButtons(Wmm mm, JPanel radioPanel, int nButtom) {
		if(mm != null) {
        	Set<String> rels = mm.getRelationRepository().getRelations().stream()
        			.filter(ev -> !ev.getName().equals(ev.getTerm()))
        			.map(ev -> ev.getName()).collect(Collectors.toSet());
        	for(String name : rels) {
        		if(names.contains(name)) {
        			continue;
        		}
        		names.add(name);
                JRadioButton button = new JRadioButton(name);
                button.setName(name);
                button.addActionListener(this);
                button.setSelected(selection.contains(name));
                radioPanel.add(button);
                nButtom ++;
        	}        	
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
