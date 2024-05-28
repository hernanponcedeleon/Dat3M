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
import java.util.Arrays;
import java.util.HashSet;
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

    private Set<ActionListener> actionListeners = new HashSet<>();

    Editor(EditorCode code, RSyntaxTextArea editorPane, String... formats) {
        super(editorPane);
        this.code = code;
        this.editorPane = editorPane;
        this.editorPane.setSyntaxEditingStyle(SyntaxConstants.SYNTAX_STYLE_C);
        this.editorPane.setCodeFoldingEnabled(true);
        this.importerItem = new JMenuItem(code.toString());
        importerItem.setActionCommand(code.editorMenuImportActionCommand());
        importerItem.addActionListener(this);
        this.exporterItem = new JMenuItem(code.toString());
        exporterItem.setActionCommand(code.editorMenuExportActionCommand());
        exporterItem.addActionListener(this);

        this.allowedFormats = ImmutableSet.copyOf(Arrays.asList(formats));
        this.chooser = new JFileChooser();
        for (String format : allowedFormats) {
            chooser.addChoosableFileFilter(new FileNameExtensionFilter("*." + format, format));
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
            chooser.setCurrentDirectory(new File(getProperty("user.dir") + "/.."));
            if (chooser.showOpenDialog(null) == APPROVE_OPTION) {
                String path = chooser.getSelectedFile().getPath();
                loadedPath = path.substring(0, path.lastIndexOf('/') + 1);
                String format = path.substring(path.lastIndexOf('.') + 1).trim();
                if (allowedFormats.contains(format)) {
                    loadedFormat = format;
                    notifyListeners();
                    try {
                        editorPane.read(new InputStreamReader(new FileInputStream(path)), null);
                    } catch (IOException e) {
                        showError("Error reading input file");
                    }
                } else {
                    showError("Please select a *." + String.join(", *.", allowedFormats) + " file",
                            "Invalid file format");
                }
            }
        }
        if (code.editorMenuExportActionCommand().equals(event.getActionCommand())) {
            chooser.setCurrentDirectory(new File(getProperty("user.dir") + "/.."));
            if (chooser.showSaveDialog(null) == APPROVE_OPTION) {
                String path = chooser.getSelectedFile().getPath();
                String format = path.substring(path.lastIndexOf('.') + 1).trim();
                if (allowedFormats.contains(format)) {
                    notifyListeners();
                    try {
                        File newTextFile = new File(path);
                        FileWriter fw = new FileWriter(newTextFile);
                        fw.write(editorPane.getText());
                        fw.close();
                    } catch (IOException e) {
                        // This should never happen since the file is created above
                    }
                } else {
                    showError("Please select a *." + String.join(", *.", allowedFormats) + " file",
                            "Invalid file format");
                }
            }
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
