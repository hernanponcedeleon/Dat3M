package com.dat3m.ui.editor;

import javax.swing.JEditorPane;
import javax.swing.JFileChooser;

public interface IEditor {
	
	final JFileChooser chooser = new JFileChooser();

	public JEditorPane getEditor();
	public void createImporter();
}
