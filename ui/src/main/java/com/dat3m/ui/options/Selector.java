package com.dat3m.ui.options;

import com.dat3m.ui.options.utils.ControlCode;
import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionListener;
import java.util.Arrays;
import java.util.Comparator;

public class Selector<T> extends JPanel {

    private JComboBox<T> selector;

    Selector(T[] options, ControlCode code) {
        @SuppressWarnings("unchecked")
		T[] sorted = (T[]) Arrays.stream(options)
        			.sorted(Comparator.comparing(T::toString))
        			.toArray();
        selector = new JComboBox<>(sorted);
        selector.setActionCommand(code.actionCommand());
        this.setLayout(new FlowLayout(FlowLayout.LEFT));
        this.add(new JLabel(code.toString() + ": "));
        this.add(selector);
    }

    @Override
    public void setEnabled(boolean flag) {
        selector.setEnabled(flag);
    }

    public void addActionListener(ActionListener listener){
        selector.addActionListener(listener);
    }

    public Object getSelectedItem(){
        return selector.getSelectedItem();
    }

    public void setSelectedItem(Object selected){
        selector.setSelectedItem(selected);
    }
}

