package com.dat3m.ui;

import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.ui.editor.Editor;
import com.dat3m.ui.editor.EditorCode;
import com.dat3m.ui.editor.EditorsPane;
import com.dat3m.ui.listener.EditorListener;
import com.dat3m.ui.options.OptionsPane;
import com.dat3m.ui.options.utils.ControlCode;
import com.dat3m.ui.result.ReachabilityResult;
import com.dat3m.ui.utils.ImageLabel;
import com.dat3m.ui.utils.UiOptions;
import org.antlr.v4.runtime.InputMismatchException;
import org.antlr.v4.runtime.Token;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;

import static com.dat3m.ui.utils.Utils.showError;
import static javax.swing.BorderFactory.createEmptyBorder;
import static javax.swing.UIManager.getDefaults;

public class Dat3M extends JFrame implements ActionListener {

    private final OptionsPane optionsPane = new OptionsPane();
    private final EditorsPane editorsPane = new EditorsPane();

    private ReachabilityResult testResult;

    private Dat3M() {
        getDefaults().put("SplitPane.border", createEmptyBorder());

        setTitle("Dat3M");
        setExtendedState(JFrame.MAXIMIZED_BOTH);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLayout(new BorderLayout());
//      setIconImage(IconHelper.getIcon(IconCode.DAT3M).getImage());

        JMenuBar menuBar = new JMenuBar();
        JMenu fileMenu = new JMenu("File");
        fileMenu.add(editorsPane.getMenuImporter());
        fileMenu.add(editorsPane.getMenuExporter());
        menuBar.add(fileMenu);
        setJMenuBar(menuBar);

        JSplitPane mainPane = new JSplitPane(JSplitPane.HORIZONTAL_SPLIT, optionsPane, editorsPane.getMainPane());
        mainPane.setDividerSize(2);
        add(mainPane);

        // Start listening to button events
        optionsPane.getTestButton().addActionListener(this);

        // optionsPane needs to listen to editor to clean the console
        editorsPane.getEditor(EditorCode.PROGRAM).addActionListener(optionsPane);
        editorsPane.getEditor(EditorCode.TARGET_MM).addActionListener(optionsPane);

        // The console shall be cleaned every time the program or MM is modified from the editor
        EditorListener listener = new EditorListener(optionsPane.getConsolePane());
        editorsPane.getEditor(EditorCode.PROGRAM).getEditorPane().addKeyListener(listener);
        editorsPane.getEditor(EditorCode.TARGET_MM).getEditorPane().addKeyListener(listener);

        pack();
    }

    public static void main(String[] args) {
        EventQueue.invokeLater(() -> {
            Dat3M app = new Dat3M();
            app.setVisible(true);
        });
    }

    @Override
    public void actionPerformed(ActionEvent event) {
        String command = event.getActionCommand();
        if (ControlCode.TEST.actionCommand().equals(command)) {
            runTest();
            if (testResult != null) {
                optionsPane.getConsolePane().setText(testResult.getVerdict());
                if (optionsPane.getOptions().showWitness() && testResult.hasWitness()) {
                    showViolation(testResult);
                }
            }
        }
    }

    private void showViolation(ReachabilityResult testResult) {
        final String filePath = testResult.getWitnessFile().getAbsolutePath();

        // Generate scroll pane with image of violation
        final ImageIcon imageIcon = new ImageIcon(filePath);
        imageIcon.getImage().flush(); // Flush the caches for otherwise we might show a previously loaded file!!!

        final ImageLabel imgLabel = new ImageLabel(imageIcon);
        final JScrollPane scrollPane = new JScrollPane(imgLabel);

        scrollPane.setHorizontalScrollBarPolicy(JScrollPane.HORIZONTAL_SCROLLBAR_AS_NEEDED);
        scrollPane.setVerticalScrollBarPolicy(JScrollPane.VERTICAL_SCROLLBAR_AS_NEEDED);

        // Generate window frame at center of screen that embeds the scrollable image
        final JFrame imageFrame = new JFrame();
        final Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
        final int x = (screenSize.width - imageFrame.getSize().width) / 2;
        final int y = (screenSize.height - imageFrame.getSize().height) / 2;
        final int extraFrameSize = 100;

        // Add zoomability to the witness
        imageFrame.addKeyListener(new KeyAdapter() {
            @Override
            public void keyPressed(KeyEvent e) {
                if (e.getKeyChar() == '+') {
                    imgLabel.zoom(1.05);
                } else if (e.getKeyChar() == '-') {
                    imgLabel.zoom(0.95);
                }
            }
        });

        imageFrame.setSize(imageIcon.getIconWidth() + extraFrameSize, imageIcon.getIconHeight() + extraFrameSize);
        imageFrame.getContentPane().add(scrollPane);
        imageFrame.setLocation(x, y);
        imageFrame.setVisible(true);

        optionsPane.getConsolePane().setText(
                optionsPane.getConsolePane().getText() + "\n" + "Witness file: " + filePath
        );
    }

    private void runTest() {
        UiOptions options = optionsPane.getOptions();
        testResult = null;
        try {
            final Editor programEditor = editorsPane.getEditor(EditorCode.PROGRAM);
            // We default to "c" code, if we do not know
            final String format = programEditor.getLoadedFormat().isEmpty() ? "c" : programEditor.getLoadedFormat();
            final Program program = new ProgramParser().parse(programEditor.getEditorPane().getText(),
                    programEditor.getLoadedPath(),
                    format,
                    options.cflags());
            program.setName("dat3mUI");
            try {
                final Wmm targetModel = new ParserCat().parse(editorsPane.getEditor(EditorCode.TARGET_MM).getEditorPane().getText());
                testResult = new ReachabilityResult(program, targetModel, options);
            } catch (Exception e) {
                final String msg = e.getMessage() == null ? "Memory model cannot be parsed" : e.getMessage();
                showError(msg, "Target memory model error");
            }
        } catch (Exception e) {
            final Throwable cause = e.getCause();
            String msg = e.getMessage() == null ? "Program cannot be parsed" : e.getMessage();
            if (cause instanceof InputMismatchException exception) {
                Token token = exception.getOffendingToken();
                msg = "Problem with \"" + token.getText() + "\" at line " + token.getLine();
            }
            showError(msg, "Program error");
        }
    }
}
