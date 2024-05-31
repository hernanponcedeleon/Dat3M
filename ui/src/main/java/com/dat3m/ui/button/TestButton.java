package com.dat3m.ui.button;

import com.dat3m.ui.options.utils.ControlCode;

import javax.swing.*;
import java.awt.*;

import static com.dat3m.ui.options.OptionsPane.OPTWIDTH;

public class TestButton extends JButton {

    public TestButton() {
        super("Test");
        setActionCommand(ControlCode.TEST.actionCommand());
        setMaximumSize(new Dimension(OPTWIDTH, 50));
    }
}
