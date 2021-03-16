package com.dat3m.ui.options;

import static com.dat3m.ui.options.utils.ControlCode.BOUND;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.HashSet;
import java.util.Set;

import javax.swing.JTextField;

import com.dat3m.ui.listener.TimeoutListener;

public class TimeoutField extends JTextField {

	private String stableTimeout;
	
    private Set<ActionListener> actionListeners = new HashSet<>();

	public TimeoutField() {
		this.stableTimeout = "60";
		this.setColumns(3);
		this.setText("60");

		TimeoutListener listener = new TimeoutListener(this);
		this.addKeyListener(listener);
		this.addFocusListener(listener);
	}
	
    public void addActionListener(ActionListener actionListener){
        actionListeners.add(actionListener);
    }

	public void setStableBound(String bound) {
		this.stableTimeout = bound;
		// Listeners are notified when a new stable bound is set
        ActionEvent boundChanged = new ActionEvent(this, ActionEvent.ACTION_PERFORMED, BOUND.actionCommand());
        for(ActionListener actionListener : actionListeners){
            actionListener.actionPerformed(boundChanged);
        }
	}

	public String getStableBound() {
		return stableTimeout;
	}
}
