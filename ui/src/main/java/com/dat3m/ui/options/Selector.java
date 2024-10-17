package com.dat3m.ui.options;

import com.dat3m.ui.options.utils.ControlCode;
import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionListener;

public class Selector<T> extends JPanel {

    private final Class<T> elementClass;
    private final JComboBox<T> selector;

    Selector(Class<T> cls, T[] options, ControlCode code) {
        elementClass = cls;
        selector = new JComboBox<>(options);
        selector.setActionCommand(code.actionCommand());
        this.setLayout(new FlowLayout(FlowLayout.LEFT));
        this.add(new JLabel(code + ": "));
        this.add(selector);
    }

    @Override
    public void setEnabled(boolean flag) {
        selector.setEnabled(flag);
    }

    public void addActionListener(ActionListener listener) {
        selector.addActionListener(listener);
    }

    public T getSelectedItem() {
        return elementClass.cast(selector.getSelectedItem());
    }

    public void setSelectedItem(Object selected) {
        selector.setSelectedItem(selected);
    }
}

