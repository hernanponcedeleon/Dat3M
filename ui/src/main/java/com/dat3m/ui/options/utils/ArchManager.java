package com.dat3m.ui.options.utils;

import com.dat3m.dartagnan.wmm.utils.Arch;
import com.dat3m.ui.editor.Editor;
import com.dat3m.ui.editor.EditorCode;
import com.dat3m.ui.options.Selector;

import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class ArchManager implements ActionListener {

    private Selector<Arch> sourceSelector;
    private Selector<Arch> targetSelector;

    private boolean isEnabled = true;
    private boolean isSourceEnabled = false;

    public ArchManager(Selector<Arch> sourceSelector, Selector<Arch> targetSelector){
        this.targetSelector = targetSelector;
        this.sourceSelector = sourceSelector;
    }

    @Override
    public void actionPerformed(ActionEvent event) {
        String command = event.getActionCommand();
        if(EditorCode.PROGRAM.editorActionCommand().equals(command)){
            Editor editor = (Editor)event.getSource();
            isEnabled = !editor.getLoadedFormat().equals("litmus");
            updatedPanes();
        } else if(ControlCode.TASK.actionCommand().equals(command)){
            JComboBox<?> selector = (JComboBox<?>)event.getSource();
            isSourceEnabled = selector.getModel().getSelectedItem().equals(Task.PORTABILITY);
            updatedPanes();
        }
    }

    private void updatedPanes(){
        targetSelector.setEnabled(isEnabled);
        sourceSelector.setEnabled(isEnabled && isSourceEnabled);
    }
}
