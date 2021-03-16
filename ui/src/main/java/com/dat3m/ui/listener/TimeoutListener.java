package com.dat3m.ui.listener;

import static com.dat3m.ui.utils.Utils.showError;

import java.awt.event.FocusEvent;
import java.awt.event.FocusListener;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;

import com.dat3m.ui.options.TimeoutField;

public class TimeoutListener implements KeyListener, FocusListener {
	
	private TimeoutField timeoutPane;

	public TimeoutListener(TimeoutField pane) {
		this.timeoutPane = pane;
	}
	
	@Override
	public void keyPressed(KeyEvent e) {
		runTest();
	}

	@Override
	public void keyReleased(KeyEvent e) {
		runTest();	
	}

	@Override
	public void keyTyped(KeyEvent e) {
		runTest();
	}
	
	private void runTest() {
		String cText = timeoutPane.getText();
		try {
			int cBound = Integer.parseInt(cText);
			if(cBound <= 0) {
				showError("The timeout should be greater than 1", "Option error");
				timeoutPane.setText(timeoutPane.getStableBound());
			}
			timeoutPane.setStableBound(cText);			
		} catch (Exception e) {
			// Empty string is allowed here to allow deleting. It will be handled by focusLost
			if(cText.equals("")) {
				return;
			}
			timeoutPane.setText(timeoutPane.getStableBound());
			showError("The timeout should be greater than 1", "Option error");
		}
	}

	@Override
	public void focusGained(FocusEvent arg0) {
		// Nothing t be done here
	}

	@Override
	public void focusLost(FocusEvent arg0) {
		if(timeoutPane.getText().equals("")) {
			timeoutPane.setText(timeoutPane.getStableBound());
			showError("The timeout should be greater than 1", "Option error");
		}
	}
}
