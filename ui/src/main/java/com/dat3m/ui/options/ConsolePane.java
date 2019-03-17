package com.dat3m.ui.options;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.JTextPane;

import com.dat3m.ui.editor.EditorCode;
import com.dat3m.ui.options.utils.ControlCode;

public class ConsolePane extends JTextPane implements ActionListener {

	@Override
	public void actionPerformed(ActionEvent event) {
	    String command = event.getActionCommand();
	    // TODO(HP): cleaner way?
	    if(ControlCode.TASK.actionCommand().equals(command)){
	    	setText("");
	    }
	    if(ControlCode.TARGET.actionCommand().equals(command)){
	    	setText("");
	    }
	    if(ControlCode.SOURCE.actionCommand().equals(command)){
	    	setText("");
	    }
	    if(ControlCode.BOUND.actionCommand().equals(command)){
	    	setText("");
	    }
	    if(ControlCode.CLEAR.actionCommand().equals(command)){
	    	setText("");
	    }
	    if(EditorCode.PROGRAM.editorActionCommand().equals(command)){
	    	setText("");
	    }
	    if(EditorCode.SOURCE_MM.editorActionCommand().equals(command)){
	    	setText("");
	    }
	    if(EditorCode.TARGET_MM.editorActionCommand().equals(command)){
	    	setText("");
	    }
	}	
}
