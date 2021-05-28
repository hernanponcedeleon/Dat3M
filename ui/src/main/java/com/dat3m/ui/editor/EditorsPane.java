package com.dat3m.ui.editor;

import com.google.common.collect.ImmutableMap;

import javax.swing.*;
import javax.swing.border.TitledBorder;

import java.awt.*;

public class EditorsPane {

    private final ImmutableMap<EditorCode, Editor> editors = ImmutableMap.of(
            EditorCode.PROGRAM, new Editor(EditorCode.PROGRAM, new JEditorPane(), "litmus", "pts", "bpl"),
            EditorCode.TARGET_MM, new Editor(EditorCode.TARGET_MM, new JEditorPane(), "cat")
    );

    private final JSplitPane mmPane;
    private final JSplitPane mainPane;
    private final JMenu menuImporter;
    private final JMenu menuExporter;

    public EditorsPane(){
        menuImporter = new JMenu("Import");
        menuImporter.add(editors.get(EditorCode.PROGRAM).getImporterItem());
        menuImporter.add(editors.get(EditorCode.TARGET_MM).getImporterItem());

        menuExporter = new JMenu("Export");
        menuExporter.add(editors.get(EditorCode.PROGRAM).getExporterItem());
        menuExporter.add(editors.get(EditorCode.TARGET_MM).getExporterItem());

        Dimension screenDimension = Toolkit.getDefaultToolkit().getScreenSize();
        Dimension editorsDimension = new Dimension((int)(screenDimension.getWidth() *1/3), (int)screenDimension.getHeight());
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

    public JMenu getMenuImporter(){
        return menuImporter;
    }

    public JMenu getMenuExporter(){
        return menuExporter;
    }

    public JSplitPane getMainPane(){
        return mainPane;
    }

    public Editor getEditor(EditorCode code){
        return editors.get(code);
    }
}
