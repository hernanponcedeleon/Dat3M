package com.dat3m.ui.utils;

import com.dat3m.ui.option.Option;

import javax.swing.*;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;

import static com.google.common.base.Preconditions.checkNotNull;

public class BoundListener implements KeyListener {

    private JTextPane consolePane;
    private JButton graphButton;
    private JTextField boundField;
    private Option option;

    public BoundListener(JTextPane consolePane, JButton graphButton, JTextField boundField, Option option){
        this.consolePane = checkNotNull(consolePane);
        this.graphButton = checkNotNull(graphButton);
        this.boundField = checkNotNull(boundField);
        this.option = checkNotNull(option);
    }

    @Override
    public void keyTyped(KeyEvent event) {
        // Nothing to do here
    }

    @Override
    public void keyPressed(KeyEvent arg0) {
        // Nothing to do here
    }

    @Override
    public void keyReleased(KeyEvent arg0) {
        try {
            consolePane.setText("");
            graphButton.setEnabled(false);
            option.setBound(Integer.parseInt(boundField.getText()));
        } catch (Exception e) {
            // Nothing to do here
        }
    }
}
