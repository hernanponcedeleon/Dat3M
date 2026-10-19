package com.dat3m.ui.editor;

import com.dat3m.ui.components.Buttons;
import com.dat3m.ui.components.Icons;
import com.dat3m.ui.components.Surface;
import com.dat3m.ui.components.Text;
import com.dat3m.ui.theme.Theme;
import com.google.common.collect.ImmutableSet;
import org.fife.ui.rsyntaxtextarea.RSyntaxTextArea;
import org.fife.ui.rsyntaxtextarea.Style;
import org.fife.ui.rsyntaxtextarea.SyntaxScheme;
import org.fife.ui.rsyntaxtextarea.Token;
import org.fife.ui.rtextarea.RTextScrollPane;

import javax.swing.*;
import javax.swing.event.DocumentEvent;
import javax.swing.event.DocumentListener;
import javax.swing.filechooser.FileNameExtensionFilter;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.Optional;
import java.util.Set;

import static com.dat3m.ui.utils.Utils.showError;
import static java.lang.System.getProperty;
import static javax.swing.JFileChooser.APPROVE_OPTION;

// A source editor with a header that names the edited file and offers to open and save it.
public class Editor extends JPanel {

    private static final String UNTITLED = "untitled";
    private static final int HEADER_HEIGHT = 44;

    private final String title;
    private final RSyntaxTextArea editorPane = new RSyntaxTextArea();
    private final RTextScrollPane scrollPane = new RTextScrollPane(editorPane);
    private final Text fileLabel = new Text(UNTITLED, Text.Role.MONO_MUTED);
    private final JFileChooser chooser = new JFileChooser(new File(getProperty("user.dir") + "/.."));

    private final ImmutableSet<String> allowedFormats;
    private final JComboBox<String> formatSelector;
    private File loadedFile;
    private float fontSize = 13f;

    private final List<Runnable> changeListeners = new ArrayList<>();
    private final DocumentListener documentListener = new DocumentListener() {
        @Override
        public void insertUpdate(DocumentEvent event) {
            notifyListeners();
        }

        @Override
        public void removeUpdate(DocumentEvent event) {
            notifyListeners();
        }

        @Override
        public void changedUpdate(DocumentEvent event) {
            // Attribute changes do not change the text.
        }
    };

    Editor(String title, Set<String> allowedFormats, boolean selectFormat, String syntaxStyle) {
        super(new BorderLayout());
        this.title = title;
        this.allowedFormats = ImmutableSet.copyOf(allowedFormats);
        this.formatSelector = selectFormat ? new JComboBox<>(allowedFormats.stream().sorted().toArray(String[]::new)) : null;
        for (String format : allowedFormats) {
            final String extension = format.startsWith(".") ? format.substring(1) : format;
            chooser.addChoosableFileFilter(new FileNameExtensionFilter("*" + format, extension));
        }

        editorPane.setSyntaxEditingStyle(syntaxStyle);
        editorPane.setCodeFoldingEnabled(true);
        editorPane.getAccessibleContext().setAccessibleName(title);
        editorPane.getDocument().addDocumentListener(documentListener);
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
        scrollPane.setBorder(BorderFactory.createEmptyBorder());
        if (formatSelector != null) {
            formatSelector.setToolTipText("Program format");
            formatSelector.getAccessibleContext().setAccessibleName("Program format");
            formatSelector.addActionListener(event -> notifyListeners());
        }

        add(newHeader(), BorderLayout.NORTH);
        add(scrollPane, BorderLayout.CENTER);
        applyTheme();
    }

    private JComponent newHeader() {
        final Box titles = Box.createHorizontalBox();
        titles.add(new Text(title, Text.Role.TITLE));
        titles.add(Box.createHorizontalStrut(10));
        titles.add(fileLabel);

        final Box actions = Box.createHorizontalBox();
        if (formatSelector != null) {
            formatSelector.setMaximumSize(formatSelector.getPreferredSize());
            actions.add(formatSelector);
            actions.add(Box.createHorizontalStrut(8));
        }
        final JButton openButton = Buttons.icon(Icons.open(), "Open " + title.toLowerCase() + " file");
        openButton.addActionListener(event -> doImportDialog());
        final JButton saveButton = Buttons.icon(Icons.save(), "Save " + title.toLowerCase() + " file");
        saveButton.addActionListener(event -> doExportDialog());
        actions.add(openButton);
        actions.add(saveButton);

        final Surface header = Surface.panel(new BorderLayout(12, 0)).lines(0, 0, 1, 0).padding(0, 16, 0, 8);
        header.setPreferredSize(new Dimension(0, HEADER_HEIGHT));
        header.add(titles, BorderLayout.WEST);
        header.add(actions, BorderLayout.EAST);
        return header;
    }

    @Override
    public void updateUI() {
        super.updateUI();
        if (editorPane != null) {
            // The text area resets its own fonts and colors when it is updated after this panel.
            SwingUtilities.invokeLater(this::applyTheme);
        }
    }

    private void applyTheme() {
        final Theme.Palette p = Theme.p();
        final Font font = Theme.mono(fontSize);
        editorPane.setFont(font);
        editorPane.setBackground(p.panel());
        editorPane.setForeground(p.ink());
        editorPane.setCaretColor(p.ink());
        editorPane.setCurrentLineHighlightColor(p.ground());
        editorPane.setSelectionColor(p.selection());
        editorPane.setMarginLineEnabled(false);

        final SyntaxScheme scheme = editorPane.getSyntaxScheme();
        for (int type = 0; type < scheme.getStyleCount(); type++) {
            final Style style = scheme.getStyle(type);
            if (style == null) {
                continue;
            }
            style.font = font;
            style.background = null;
            style.foreground = switch (type) {
                case Token.RESERVED_WORD, Token.RESERVED_WORD_2, Token.DATA_TYPE -> p.keyword();
                case Token.COMMENT_EOL, Token.COMMENT_MULTILINE, Token.COMMENT_DOCUMENTATION,
                     Token.COMMENT_KEYWORD, Token.COMMENT_MARKUP -> p.comment();
                case Token.LITERAL_STRING_DOUBLE_QUOTE, Token.LITERAL_CHAR, Token.LITERAL_BACKQUOTE,
                     Token.PREPROCESSOR -> p.string();
                case Token.LITERAL_NUMBER_DECIMAL_INT, Token.LITERAL_NUMBER_FLOAT,
                     Token.LITERAL_NUMBER_HEXADECIMAL, Token.LITERAL_BOOLEAN -> p.number();
                default -> p.ink();
            };
        }
        editorPane.setSyntaxScheme(scheme);

        scrollPane.getGutter().setBackground(p.panel());
        scrollPane.getGutter().setBorderColor(p.panel());
        scrollPane.getGutter().setLineNumberColor(p.muted());
        scrollPane.getGutter().setLineNumberFont(Theme.mono(Math.max(fontSize - 1, 8f)));
        editorPane.repaint();
    }

    private void changeFontSize(int change) {
        fontSize = Math.max(8f, fontSize + change);
        applyTheme();
    }

    // Listeners are notified whenever the text or its format changes.
    public void addChangeListener(Runnable listener) {
        changeListeners.add(listener);
    }

    public String getSelectedFormat() {
        return (String) formatSelector.getSelectedItem();
    }

    public JComboBox<String> getFormatSelector() {
        return formatSelector;
    }

    public String getLoadedDir() {
        return loadedFile == null ? "" : Objects.requireNonNullElse(loadedFile.getParent(), "");
    }

    public Optional<File> getLoadedFile() {
        return Optional.ofNullable(loadedFile);
    }

    // Sets the directory that the dialogs for opening and saving files show first.
    public void setInitialDirectory(File directory) {
        if (directory.isDirectory()) {
            chooser.setCurrentDirectory(directory);
        }
    }

    public RSyntaxTextArea getEditorPane() {
        return editorPane;
    }

    public Action getImportAction() {
        return new AbstractAction("Open " + title.toLowerCase() + "…") {
            @Override
            public void actionPerformed(ActionEvent event) {
                doImportDialog();
            }
        };
    }

    public Action getExportAction() {
        return new AbstractAction("Save " + title.toLowerCase() + "…") {
            @Override
            public void actionPerformed(ActionEvent event) {
                doExportDialog();
            }
        };
    }

    private void doImportDialog() {
        if (chooser.showOpenDialog(this) != APPROVE_OPTION) {
            return;
        }
        final File selectedFile = chooser.getSelectedFile();
        final var format = allowedFormats.stream()
                .filter(selectedFile.getName()::endsWith)
                .findFirst();
        if (format.isEmpty()) {
            showError("Please select a *" + String.join(", *", allowedFormats) + " file", "Invalid file format");
            return;
        }
        load(selectedFile);
    }

    // The file must have one of the formats that this editor allows.
    public void load(File selectedFile) {
        final String format = allowedFormats.stream()
                .filter(selectedFile.getName()::endsWith)
                .findFirst().orElseThrow();
        setLoadedFile(selectedFile);
        if (formatSelector != null) {
            formatSelector.setSelectedItem(format);
        }
        try (final var r = new FileReader(selectedFile)) {
            editorPane.read(r, null);
            // Reading replaces the document, so the listener of the old document does not fire.
            editorPane.getDocument().addDocumentListener(documentListener);
            editorPane.setCaretPosition(0);
        } catch (IOException e) {
            showError("Error reading input file", e.getMessage());
        }
        notifyListeners();
    }

    private void doExportDialog() {
        if (chooser.showSaveDialog(this) != APPROVE_OPTION) {
            return;
        }
        final File selectedFile = chooser.getSelectedFile();
        if (allowedFormats.stream().noneMatch(selectedFile.getName()::endsWith)) {
            showError("Please select a *" + String.join(", *", allowedFormats) + " file", "Invalid file format");
            return;
        }
        if (selectedFile.exists() && !selectedFile.equals(loadedFile) && JOptionPane.showConfirmDialog(this,
                selectedFile.getName() + " already exists. Replace it?", "Save " + title.toLowerCase(),
                JOptionPane.OK_CANCEL_OPTION) != JOptionPane.OK_OPTION) {
            return;
        }
        try (final var w = new FileWriter(selectedFile)) {
            editorPane.write(w);
            setLoadedFile(selectedFile);
        } catch (IOException e) {
            showError("Error writing program file", e.getMessage());
        }
        notifyListeners();
    }

    private void setLoadedFile(File file) {
        loadedFile = file;
        fileLabel.setText(file.getName());
        fileLabel.setToolTipText(file.getAbsolutePath());
    }

    private void notifyListeners() {
        changeListeners.forEach(Runnable::run);
    }
}
