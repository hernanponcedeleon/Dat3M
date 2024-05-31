package com.dat3m.ui.options;

import javax.swing.*;
import java.awt.*;

import static java.awt.FlowLayout.LEFT;

public class BoundPane extends JPanel {

    public BoundPane() {
        super(new FlowLayout(LEFT));
        add(new JLabel("Unrolling: "));
    }
}
