package com.dat3m.ui.listener;

import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;

import javax.swing.JButton;
import javax.swing.JTextPane;

public class EditorListener implements KeyListener {
	
	private JTextPane consolePane;
	private JButton clearButton;

	public EditorListener(JTextPane pane, JButton button) {
		this.consolePane = pane;
		this.clearButton = button;
	}
	
	@Override
	public void keyPressed(KeyEvent e) {
		// Nothing to be done
	}

	@Override
	public void keyReleased(KeyEvent e) {
		// Nothing to be done	
	}

	@Override
	public void keyTyped(KeyEvent e) {
		consolePane.setText("");
		clearButton.setEnabled(false);
	}	
}
