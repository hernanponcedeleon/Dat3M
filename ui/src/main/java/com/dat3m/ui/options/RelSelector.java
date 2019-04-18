package com.dat3m.ui.options;

import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.*;

import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JRadioButton;

import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.ui.editor.Editor;
import com.dat3m.ui.options.utils.Task;

import static com.dat3m.ui.utils.Utils.showError;

public class RelSelector extends JFrame implements ActionListener {

    private static final int COLS = 5;

    private final Selector<Task> taskSelector;
	private Editor sourceWmmEditor;
	private Editor targetWmmEditor;
	private Set<String> selection = new HashSet<>();

	RelSelector(Selector<Task> taskSelector){
		this.taskSelector = taskSelector;
	}

	Set<String> getSelection() {
		return selection;
	}

	public void setSourceWmmEditor(Editor editor){
		sourceWmmEditor = editor;
	}

	public void setTargetWmmEditor(Editor editor){
		targetWmmEditor = editor;
	}

	public void open() {
		SortedSet<String> relations = mkRelations();
		if(relations != null){
			setTitle("Relations");
			JPanel radioPanel = new JPanel(new GridLayout(0, COLS));
			for(String relation : relations){
				JRadioButton button = new JRadioButton(relation);
				button.setName(relation);
				button.addActionListener(this);
				button.setSelected(selection.contains(relation));
				radioPanel.add(button);
			}
			setContentPane(radioPanel);
			pack();
			setVisible(true);
		}
    }

    private SortedSet<String> mkRelations(){
		SortedSet<String> relations = new TreeSet<>();
		try {
			addWmmRelations(relations, targetWmmEditor);
			if(Task.PORTABILITY == taskSelector.getSelectedItem()){
				addWmmRelations(relations, sourceWmmEditor);
			}
			return relations;
		} catch (Exception e){
			String msg = e.getMessage() == null? "Memory model cannot be parsed" : e.getMessage();
			showError("Relation Selector requires the memory model to be correctly parsed.\n" + msg, "Memory model error");
			return null;
		}
	}

    private void addWmmRelations(SortedSet<String> set, Editor editor){
		if(editor == null){
			throw new RuntimeException("Editor is not set in " + getClass().getName());
		}
		Wmm wmm = new ParserCat().parse(editor.getEditorPane().getText());
		for(Relation relation : wmm.getRelationRepository().getRelations()){
			if(!relation.getName().equals(relation.getTerm())){
				set.add(relation.getName());
			}
		}
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
