package com.dat3m.ui.button;

import com.dat3m.ui.options.utils.ControlCode;

import javax.swing.*;
import java.awt.*;

import static com.dat3m.ui.options.OptionsPane.OPTWIDTH;

public class ClearButton extends JButton {

    public ClearButton() {
        super("Clear Console");
        setActionCommand(ControlCode.CLEAR.actionCommand());
        setMaximumSize(new Dimension(OPTWIDTH, 50));
    }
}
