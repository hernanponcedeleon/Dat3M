package com.dat3m.ui.editor;

import com.google.common.collect.ImmutableMap;

import javax.swing.*;
import javax.swing.border.TitledBorder;

public class Editor {

    private final ImmutableMap<EditorCode, EditorPane> editorPanes = ImmutableMap.of(
            EditorCode.PROGRAM, new EditorPane(EditorCode.PROGRAM, new JEditorPane(), "litmus", "pts"),
            EditorCode.SOURCE_MM, new EditorPane(EditorCode.SOURCE_MM, new JEditorPane(), "cat"),
            EditorCode.TARGET_MM, new EditorPane(EditorCode.TARGET_MM, new JEditorPane(), "cat")
    );

    private final JMenu menu;
    private final JMenuBar menuBar;

    private final JSplitPane mmPane;
    private final JSplitPane mainPane;


    public Editor(){
        menu = new JMenu("Import");
        menu.add(editorPanes.get(EditorCode.PROGRAM).getMenuItem());
        menu.add(editorPanes.get(EditorCode.TARGET_MM).getMenuItem());
        this.menuBar = new JMenuBar();
        menuBar.add(menu);

        mmPane = new JSplitPane(JSplitPane.VERTICAL_SPLIT);
        mmPane.setBottomComponent(editorPanes.get(EditorCode.TARGET_MM));
        mmPane.setOneTouchExpandable(true);
        mmPane.setDividerSize(0);
        mmPane.setBorder(new TitledBorder(""));

        mainPane = new JSplitPane(JSplitPane.HORIZONTAL_SPLIT, editorPanes.get(EditorCode.PROGRAM), mmPane);
        mainPane.setOneTouchExpandable(true);
        mainPane.setDividerSize(2);
        mainPane.setDividerLocation(0.5);
        mainPane.setBorder(new TitledBorder(""));
    }

    public JMenuBar getMenuBar(){
        return menuBar;
    }

    public JSplitPane getMainPane(){
        return mainPane;
    }

    public JEditorPane getEditor(EditorCode code){
        return editorPanes.get(code).getEditor();
    }

    public String getLoadedFormat(EditorCode code){
        return editorPanes.get(code).getLoadedFormat();
    }

    public void setShowSourceMM(boolean flag){
        if(flag){
            mmPane.setTopComponent(editorPanes.get(EditorCode.SOURCE_MM));
            mmPane.setDividerLocation(0.5);
            menu.add(editorPanes.get(EditorCode.SOURCE_MM).getMenuItem(), 1);
        } else {
            mmPane.remove(editorPanes.get(EditorCode.SOURCE_MM));
            menu.remove(editorPanes.get(EditorCode.SOURCE_MM).getMenuItem());
        }
    }
}
