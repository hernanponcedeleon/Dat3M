package com.dat3m.ui.options;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.JTextPane;

import com.dat3m.ui.options.utils.ControlCode;

public class ConsolePane extends JTextPane implements ActionListener {

	@Override
	public void actionPerformed(ActionEvent event) {
	    String command = event.getActionCommand();
	    if(ControlCode.CLEAR.actionCommand().equals(command)){
	    	setText("");
	    }
	    if(ControlCode.TASK.actionCommand().equals(command)){
	    	setText("");
	    }
	    // TODO clear the console when every option is changed
	}	
}
