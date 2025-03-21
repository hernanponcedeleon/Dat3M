package com.dat3m.ui.options;

import com.dat3m.ui.listener.BoundListener;

import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.HashSet;
import java.util.Set;

import static com.dat3m.ui.options.utils.ControlCode.BOUND;

public class BoundField extends JTextField {

    private String stableBound;

    private Set<ActionListener> actionListeners = new HashSet<>();

    public BoundField() {
        this.stableBound = "1";
        this.setColumns(3);
        this.setText("1");

        BoundListener listener = new BoundListener(this);
        this.addKeyListener(listener);
        this.addFocusListener(listener);
    }

    public void addActionListener(ActionListener actionListener) {
        actionListeners.add(actionListener);
    }

    public void setStableBound(String bound) {
        this.stableBound = bound;
        // Listeners are notified when a new stable bound is set
        ActionEvent boundChanged = new ActionEvent(this, ActionEvent.ACTION_PERFORMED, BOUND.actionCommand());
        for (ActionListener actionListener : actionListeners) {
            actionListener.actionPerformed(boundChanged);
        }
    }

    public String getStableBound() {
        return stableBound;
    }
}
