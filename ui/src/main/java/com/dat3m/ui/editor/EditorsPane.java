package com.dat3m.ui.editor;

import com.google.common.collect.ImmutableMap;
import com.dat3m.ui.log.LogPane;
import org.fife.ui.rsyntaxtextarea.RSyntaxTextArea;

import javax.swing.*;
import javax.swing.border.TitledBorder;
import java.awt.*;
import java.util.Set;

public class EditorsPane {

    private static final int EDITOR_DIVIDER_SIZE = 12;
    private static final int LOG_HEIGHT = 240;

    private final ImmutableMap<EditorCode, Editor> editors;

    private final JSplitPane editorsPane;
    private final JSplitPane mainPane;
    private final LogPane logPane = new LogPane();
    private final JMenu menuImporter;
    private final JMenu menuExporter;

    public EditorsPane(Set<String> programExtensions) {
        editors = ImmutableMap.of(
                EditorCode.PROGRAM, new Editor(EditorCode.PROGRAM, new RSyntaxTextArea(), programExtensions),
                EditorCode.TARGET_MM, new Editor(EditorCode.TARGET_MM, new RSyntaxTextArea(), Set.of(".cat"))
        );
        menuImporter = new JMenu("Import");
        menuImporter.add(editors.get(EditorCode.PROGRAM).getImporterItem());
        menuImporter.add(editors.get(EditorCode.TARGET_MM).getImporterItem());

        menuExporter = new JMenu("Export");
        menuExporter.add(editors.get(EditorCode.PROGRAM).getExporterItem());
        menuExporter.add(editors.get(EditorCode.TARGET_MM).getExporterItem());

        Dimension screenDimension = Toolkit.getDefaultToolkit().getScreenSize();
        Dimension editorsDimension = new Dimension((int) (screenDimension.getWidth() * 1 / 3), (int) screenDimension.getHeight());
        editors.get(EditorCode.PROGRAM).setPreferredSize(editorsDimension);
        editors.get(EditorCode.TARGET_MM).setPreferredSize(editorsDimension);

        editorsPane = new JSplitPane(JSplitPane.HORIZONTAL_SPLIT,
                editors.get(EditorCode.PROGRAM), editors.get(EditorCode.TARGET_MM));
        editorsPane.setOneTouchExpandable(true);
        editorsPane.setDividerSize(EDITOR_DIVIDER_SIZE);
        editorsPane.setDividerLocation(0.5);
        editorsPane.setBorder(new TitledBorder(""));
        editorsPane.setMinimumSize(new Dimension(0, 120));

        mainPane = new JSplitPane(JSplitPane.VERTICAL_SPLIT, editorsPane, logPane);
        mainPane.setResizeWeight(0.75);
        mainPane.setDividerSize(0);
        mainPane.setBorder(new TitledBorder(""));
        setLogVisible(false);
    }

    public JMenu getMenuImporter() {
        return menuImporter;
    }

    public JMenu getMenuExporter() {
        return menuExporter;
    }

    public JSplitPane getMainPane() {
        return mainPane;
    }

    public Editor getEditor(EditorCode code) {
        return editors.get(code);
    }

    public LogPane getLogPane() {
        return logPane;
    }

    public void setLogVisible(boolean visible) {
        logPane.setVisible(visible);
        mainPane.setDividerSize(visible ? 2 : 0);
        if (visible) {
            SwingUtilities.invokeLater(() -> mainPane.setDividerLocation(Math.max(
                    mainPane.getMinimumDividerLocation(),
                    Math.min(mainPane.getHeight() - LOG_HEIGHT, mainPane.getMaximumDividerLocation())
            )));
        }
        mainPane.revalidate();
        mainPane.repaint();
    }
}
