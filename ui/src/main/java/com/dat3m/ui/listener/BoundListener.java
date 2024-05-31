package com.dat3m.ui.listener;

import com.dat3m.ui.options.BoundField;

import java.awt.event.FocusEvent;
import java.awt.event.FocusListener;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;

import static com.dat3m.ui.utils.Utils.showError;

public class BoundListener implements KeyListener, FocusListener {

    private BoundField boundPane;

    public BoundListener(BoundField pane) {
        this.boundPane = pane;
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
        String cText = boundPane.getText();
        try {
            int cBound = Integer.parseInt(cText);
            if (cBound <= 0) {
                showError("The bound should be greater than 1", "Option error");
                boundPane.setText(boundPane.getStableBound());
            }
            boundPane.setStableBound(cText);
        } catch (Exception e) {
            // Empty string is allowed here to allow deleting. It will be handled by focusLost
            if (cText.isEmpty()) {
                return;
            }
            boundPane.setText(boundPane.getStableBound());
            showError("The bound should be greater than 1", "Option error");
        }
    }

    @Override
    public void focusGained(FocusEvent arg0) {
        // Nothing to be done here
    }

    @Override
    public void focusLost(FocusEvent arg0) {
        if (boundPane.getText().isEmpty()) {
            boundPane.setText(boundPane.getStableBound());
            showError("The bound should be greater than 1", "Option error");
        }
    }
}
