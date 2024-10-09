package com.dat3m.ui.editor;

import com.google.common.collect.ImmutableSet;
import org.fife.ui.rsyntaxtextarea.RSyntaxTextArea;
import org.fife.ui.rsyntaxtextarea.SyntaxConstants;
import org.fife.ui.rtextarea.RTextScrollPane;

import javax.swing.*;
import javax.swing.border.TitledBorder;
import javax.swing.filechooser.FileNameExtensionFilter;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;
import java.io.*;
import java.util.HashSet;
import java.util.Objects;
import java.util.Set;

import static com.dat3m.ui.utils.Utils.showError;
import static java.lang.System.getProperty;
import static javax.swing.BorderFactory.createTitledBorder;
import static javax.swing.JFileChooser.APPROVE_OPTION;

public class Editor extends RTextScrollPane implements ActionListener {

    private final EditorCode code;

    private final RSyntaxTextArea editorPane;
    private final JMenuItem importerItem;
    private final JMenuItem exporterItem;
    private final JFileChooser chooser;

    private final ImmutableSet<String> allowedFormats;
    private String loadedFormat = "";
    private String loadedPath = "";

    private final Set<ActionListener> actionListeners = new HashSet<>();

    Editor(EditorCode code, RSyntaxTextArea editorPane) {
        super(editorPane);
        this.code = code;
        this.editorPane = editorPane;
        this.editorPane.setSyntaxEditingStyle(SyntaxConstants.SYNTAX_STYLE_C);
        this.editorPane.setCodeFoldingEnabled(true);
        this.importerItem = new JMenuItem(code.toString());
        this.importerItem.setActionCommand(code.editorMenuImportActionCommand());
        this.importerItem.addActionListener(this);
        this.exporterItem = new JMenuItem(code.toString());
        this.exporterItem.setActionCommand(code.editorMenuExportActionCommand());
        this.exporterItem.addActionListener(this);

        this.allowedFormats = ImmutableSet.copyOf(code.supportedExtensions());
        this.chooser = new JFileChooser();
        for (String format : allowedFormats) {
            chooser.addChoosableFileFilter(new FileNameExtensionFilter("*" + format, format));
        }

        setVerticalScrollBarPolicy(JScrollPane.VERTICAL_SCROLLBAR_AS_NEEDED);
        setHorizontalScrollBarPolicy(JScrollPane.HORIZONTAL_SCROLLBAR_AS_NEEDED);

        TitledBorder border = createTitledBorder(code.toString());
        border.setTitleJustification(TitledBorder.CENTER);
        setBorder(border);

        editorPane.addKeyListener(new KeyAdapter() {
            @Override
            public void keyPressed(KeyEvent e) {
                if (e.isControlDown() && e.getKeyChar() == '+') {
                    changeFontSize(1);
                } else if (e.isControlDown() && e.getKeyChar() == '-') {
                    changeFontSize(-1);
                }
            }
        });
    }

    private void changeFontSize(int change) {
        Font scaledFont = new Font(Font.DIALOG, Font.PLAIN, editorPane.getFont().getSize() + change);
        editorPane.setFont(scaledFont);
    }

    public void addActionListener(ActionListener actionListener) {
        actionListeners.add(actionListener);
    }

    public String getLoadedFormat() {
        return loadedFormat;
    }

    public String getLoadedPath() {
        return loadedPath;
    }

    @Override
    public void actionPerformed(ActionEvent event) {
        if (code.editorMenuImportActionCommand().equals(event.getActionCommand())) {
            doImportDialog();
            return;
        }
        if (code.editorMenuExportActionCommand().equals(event.getActionCommand())) {
            doExportDialog();
            return;
        }
    }

    private void doImportDialog() {
        chooser.setCurrentDirectory(new File(getProperty("user.dir") + "/.."));
        if (chooser.showOpenDialog(null) != APPROVE_OPTION) {
            return;
        }
        final File selectedFile = chooser.getSelectedFile();
        loadedPath = Objects.requireNonNullElse(selectedFile.getParent(), "");
        loadedFormat = allowedFormats.stream().filter(selectedFile.getName()::endsWith).findAny().orElse("");
        if (loadedFormat.isEmpty()) {
            showError("Please select a *" + String.join(", *", allowedFormats) + " file", "Invalid file format");
            return;
        }
        notifyListeners();
        try(final var r = new FileReader(selectedFile)) {
            editorPane.read(r, null);
        } catch (IOException e) {
            showError("Error reading input file", e.getMessage());
        }
    }

    private void doExportDialog() {
        chooser.setCurrentDirectory(new File(getProperty("user.dir") + "/.."));
        if (chooser.showSaveDialog(null) != APPROVE_OPTION) {
            return;
        }
        final File selectedFile = chooser.getSelectedFile();
        if (allowedFormats.stream().noneMatch(selectedFile.getName()::endsWith)) {
            showError("Please select a *" + String.join(", *", allowedFormats) + " file", "Invalid file format");
            return;
        }
        notifyListeners();
        try(final var w = new FileWriter(selectedFile)) {
            editorPane.write(w);
        } catch (IOException e) {
            showError("Error writing program file", e.getMessage());
        }
    }

    JMenuItem getImporterItem() {
        return importerItem;
    }

    JMenuItem getExporterItem() {
        return exporterItem;
    }

    public RSyntaxTextArea getEditorPane() {
        return editorPane;
    }

    private void notifyListeners() {
        ActionEvent dataLoadedEvent = new ActionEvent(this, ActionEvent.ACTION_PERFORMED, code.editorActionCommand());
        for (ActionListener actionListener : actionListeners) {
            actionListener.actionPerformed(dataLoadedEvent);
        }
    }
}
