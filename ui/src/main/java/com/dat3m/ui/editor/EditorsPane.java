package com.dat3m.ui.editor;

import com.dat3m.ui.options.utils.ControlCode;
import com.dat3m.ui.utils.Task;
import com.google.common.collect.ImmutableMap;

import javax.swing.*;
import javax.swing.border.TitledBorder;

import static com.dat3m.ui.utils.Utils.getMainScreenHeight;
import static com.dat3m.ui.utils.Utils.getMainScreenWidth;

import java.awt.Dimension;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class EditorsPane implements ActionListener {

    private final ImmutableMap<EditorCode, Editor> editors = ImmutableMap.of(
            EditorCode.PROGRAM, new Editor(EditorCode.PROGRAM, new JEditorPane(), "litmus", "pts"),
            EditorCode.SOURCE_MM, new Editor(EditorCode.SOURCE_MM, new JEditorPane(), "cat"),
            EditorCode.TARGET_MM, new Editor(EditorCode.TARGET_MM, new JEditorPane(), "cat")
    );

    private final JSplitPane mmPane;
    private final JSplitPane mainPane;
    private final JMenu menu;

    public EditorsPane(){
        menu = new JMenu("Import");
        menu.add(editors.get(EditorCode.PROGRAM).getMenuItem());
        menu.add(editors.get(EditorCode.TARGET_MM).getMenuItem());
        
        Dimension editorsDimension = new Dimension(2 * getMainScreenWidth() / 5, getMainScreenHeight());
		editors.get(EditorCode.PROGRAM).setPreferredSize(editorsDimension);
        editors.get(EditorCode.TARGET_MM).setPreferredSize(editorsDimension);
        
        mmPane = new JSplitPane(JSplitPane.VERTICAL_SPLIT);
        mmPane.setBottomComponent(editors.get(EditorCode.TARGET_MM));
        mmPane.setOneTouchExpandable(true);
        mmPane.setDividerSize(0);
        mmPane.setBorder(new TitledBorder(""));

        mainPane = new JSplitPane(JSplitPane.HORIZONTAL_SPLIT, editors.get(EditorCode.PROGRAM), mmPane);
        mainPane.setOneTouchExpandable(true);
        mainPane.setDividerSize(2);
        mainPane.setDividerLocation(0.5);
        mainPane.setBorder(new TitledBorder(""));
    }

    public JMenu getMenu(){
        return menu;
    }

    public JSplitPane getMainPane(){
        return mainPane;
    }

    public Editor getEditor(EditorCode code){
        return editors.get(code);
    }

    @Override
    public void actionPerformed(ActionEvent event) {
        if(ControlCode.TASK.actionCommand().equals(event.getActionCommand())){
            JComboBox<?> selector = (JComboBox<?>)event.getSource();
            if(selector.getModel().getSelectedItem().equals(Task.PORTABILITY)){
                mmPane.setTopComponent(editors.get(EditorCode.SOURCE_MM));
                mmPane.setDividerSize(2);
                mmPane.setDividerLocation(0.5);
                menu.add(editors.get(EditorCode.SOURCE_MM).getMenuItem(), 1);
            } else {
                mmPane.remove(editors.get(EditorCode.SOURCE_MM));
                menu.remove(editors.get(EditorCode.SOURCE_MM).getMenuItem());
            }
        }
    }
}
