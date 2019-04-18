package com.dat3m.ui.options;

import com.dat3m.ui.icon.IconCode;
import com.dat3m.ui.icon.IconHelper;
import com.dat3m.ui.options.utils.ControlCode;
import com.dat3m.ui.options.utils.Task;

import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class IconPane extends JLabel implements ActionListener {

    private int height;

    IconPane(IconCode code, int height, int horizontalAlignment){
        super(IconHelper.getIcon(code, height), horizontalAlignment);
        this.height = height;
    }

    @Override
    public void actionPerformed(ActionEvent event) {
        if(ControlCode.TASK.actionCommand().equals(event.getActionCommand())){
            JComboBox<?> selector = (JComboBox<?>)event.getSource();
            if(selector.getModel().getSelectedItem().equals(Task.PORTABILITY)){
                setIcon(IconHelper.getIcon(IconCode.PORTHOS, height));
            } else {
                setIcon(IconHelper.getIcon(IconCode.DARTAGNAN, height));
            }
        }
    }
}
