package com.dat3m.ui.listener;

import javax.swing.*;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;

public class EditorListener implements KeyListener {

    private JTextPane consolePane;

    public EditorListener(JTextPane pane) {
        this.consolePane = pane;
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
    }
}
