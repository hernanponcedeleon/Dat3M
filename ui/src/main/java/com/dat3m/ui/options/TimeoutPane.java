package com.dat3m.ui.options;

import javax.swing.*;
import java.awt.*;

import static java.awt.FlowLayout.LEFT;

public class TimeoutPane extends JPanel {

    public TimeoutPane() {
        super(new FlowLayout(LEFT));
        add(new JLabel("Solver timeout: "));
    }
}
