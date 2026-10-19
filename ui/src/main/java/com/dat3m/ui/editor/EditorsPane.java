package com.dat3m.ui.editor;

import com.dat3m.dartagnan.GlobalSettings;
import com.dat3m.ui.components.Surface;

import org.fife.ui.rsyntaxtextarea.SyntaxConstants;

import javax.swing.*;
import java.awt.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Set;

import static com.dat3m.dartagnan.parsers.program.ProgramParser.EXTENSION_LITMUS;

// The program and the memory model, side by side.
public class EditorsPane {

    // Store buffering under TSO, relative to the home directory of Dat3M and its directory of memory models.
    private static final Path DEFAULT_PROGRAM = Path.of("litmus", "X86", "SB.litmus");
    private static final String DEFAULT_MODEL = "tso.cat";

    private final Editor programEditor;
    private final Editor modelEditor;
    private final JSplitPane mainPane;

    public EditorsPane(Set<String> programExtensions) {
        CatTokenMaker.register();
        programEditor = new Editor("Program", programExtensions, true, SyntaxConstants.SYNTAX_STYLE_C);
        modelEditor = new Editor("Memory model", Set.of(".cat"), false, CatTokenMaker.SYNTAX_STYLE_CAT);
        programEditor.getFormatSelector().setSelectedItem(EXTENSION_LITMUS);

        // The memory models that ship with Dat3M are the most likely ones to be opened.
        final Path catDirectory = GlobalSettings.getCatDirectory().toAbsolutePath();
        modelEditor.setInitialDirectory(catDirectory.toFile());
        // Start with a small example, so that the tool can be tried right away.
        loadIfPresent(programEditor, GlobalSettings.getHomeDirectory().toAbsolutePath().resolve(DEFAULT_PROGRAM));
        loadIfPresent(modelEditor, catDirectory.resolve(DEFAULT_MODEL));

        final Surface programFrame = Surface.panel(new BorderLayout()).lines(0, 0, 0, 1);
        programFrame.add(programEditor, BorderLayout.CENTER);
        final Surface modelFrame = Surface.panel(new BorderLayout()).lines(0, 1, 0, 0);
        modelFrame.add(modelEditor, BorderLayout.CENTER);
        mainPane = new JSplitPane(JSplitPane.HORIZONTAL_SPLIT, programFrame, modelFrame);
        mainPane.setResizeWeight(0.5);
        mainPane.setDividerSize(5);
        mainPane.setBorder(BorderFactory.createEmptyBorder());
    }

    private static void loadIfPresent(Editor editor, Path file) {
        if (Files.isReadable(file)) {
            editor.load(file.toFile());
        }
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
