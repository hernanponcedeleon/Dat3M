package com.dat3m.ui.editor;

import com.dat3m.ui.components.Surface;

import org.fife.ui.rsyntaxtextarea.SyntaxConstants;

import javax.swing.*;
import java.awt.*;
import java.util.Set;

import static com.dat3m.dartagnan.parsers.program.ProgramParser.EXTENSION_LITMUS;

// The program and the memory model, side by side.
public class EditorsPane {

    private final Editor programEditor;
    private final Editor modelEditor;
    private final JSplitPane mainPane;

    public EditorsPane(Set<String> programExtensions) {
        CatTokenMaker.register();
        programEditor = new Editor("Program", programExtensions, true, SyntaxConstants.SYNTAX_STYLE_C);
        modelEditor = new Editor("Memory model", Set.of(".cat"), false, CatTokenMaker.SYNTAX_STYLE_CAT);
        programEditor.getFormatSelector().setSelectedItem(EXTENSION_LITMUS);

        final Surface programFrame = Surface.panel(new BorderLayout()).lines(0, 0, 0, 1);
        programFrame.add(programEditor, BorderLayout.CENTER);
        final Surface modelFrame = Surface.panel(new BorderLayout()).lines(0, 1, 0, 0);
        modelFrame.add(modelEditor, BorderLayout.CENTER);
        mainPane = new JSplitPane(JSplitPane.HORIZONTAL_SPLIT, programFrame, modelFrame);
        mainPane.setResizeWeight(0.5);
        mainPane.setDividerSize(5);
        mainPane.setBorder(BorderFactory.createEmptyBorder());
    }

    public JSplitPane getMainPane() {
        return mainPane;
    }

    public Editor getProgramEditor() {
        return programEditor;
    }

    public Editor getModelEditor() {
        return modelEditor;
    }
}
