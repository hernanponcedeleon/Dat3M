package com.dat3m.ui.button;

import com.dat3m.ui.options.utils.ControlCode;

import javax.swing.*;
import java.awt.*;

import static com.dat3m.ui.options.OptionsPane.OPTWIDTH;

public class CancelButton extends JButton {

    public CancelButton() {
        super("Cancel");
        setActionCommand(ControlCode.CANCEL.actionCommand());
        setEnabled(false);
        setMaximumSize(new Dimension(OPTWIDTH, 50));
    }
}
