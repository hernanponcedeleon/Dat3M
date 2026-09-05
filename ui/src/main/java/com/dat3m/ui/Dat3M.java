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
import org.sosy_lab.common.ShutdownManager;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.concurrent.ExecutionException;
import java.util.stream.Collectors;

import static com.dat3m.ui.utils.Utils.showError;
import static javax.swing.BorderFactory.createEmptyBorder;
import static javax.swing.UIManager.getDefaults;

public class Dat3M extends JFrame implements ActionListener {

    private final OptionsPane optionsPane = new OptionsPane();
    private final ProgramParser programParser;
    private final EditorsPane editorsPane;

    private ReachabilityResult testResult;
    private SwingWorker<VerificationOutcome, Void> verificationWorker;
    private volatile ShutdownManager shutdownManager;
    private boolean cancellationRequested;
    private final Timer verificationTimer;
    private long verificationStartTime;

    private Dat3M() throws IOException {
        programParser = new ProgramParser();
        editorsPane = new EditorsPane(programParser.getSupportedExtensions().stream()
                .filter(extension -> !extension.equals(ProgramParser.EXTENSION_SPV_DIS))
                .collect(Collectors.toUnmodifiableSet()));
        verificationTimer = new Timer(1000, ignored -> updateVerificationTime());
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
        optionsPane.getCancelButton().addActionListener(this);

        // optionsPane needs to listen to editor to clean the console
        editorsPane.getEditor(EditorCode.PROGRAM).addActionListener(optionsPane::clearConsole);
        editorsPane.getEditor(EditorCode.TARGET_MM).addActionListener(optionsPane::clearConsole);

        // The console shall be cleaned every time the program or MM is modified from the editor
        EditorListener listener = new EditorListener(optionsPane.getConsolePane());
        editorsPane.getEditor(EditorCode.PROGRAM).getEditorPane().addKeyListener(listener);
        editorsPane.getEditor(EditorCode.TARGET_MM).getEditorPane().addKeyListener(listener);

        pack();
    }

    public static void main(String[] args) {
        EventQueue.invokeLater(() -> {
            try {
                Dat3M app = new Dat3M();
                app.setVisible(true);
            } catch (IOException e) {
                showError(e.getMessage(), "Failed to load compilation pipeline");
            }
        });
    }

    @Override
    public void actionPerformed(ActionEvent event) {
        String command = event.getActionCommand();
        if (ControlCode.TEST.actionCommand().equals(command)) {
            runTest();
        } else if (ControlCode.CANCEL.actionCommand().equals(command)) {
            cancelVerification();
        }
    }

    private void showViolation(ReachabilityResult testResult) {
        final String filePath = testResult.getWitnessFile().toAbsolutePath().toString();

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
    }

    private void runTest() {
        final UiOptions options = optionsPane.getOptions();
        final Editor programEditor = editorsPane.getEditor(EditorCode.PROGRAM);
        final String sourceCode = programEditor.getEditorPane().getText();
        final String format = programEditor.getSelectedFormat();
        final String wmmCode = editorsPane.getEditor(EditorCode.TARGET_MM).getEditorPane().getText();

        testResult = null;
        cancellationRequested = false;
        final ShutdownManager manager = ShutdownManager.create();
        shutdownManager = manager;

        optionsPane.getTestButton().setEnabled(false);
        optionsPane.getClearButton().setEnabled(false);
        optionsPane.getCancelButton().setEnabled(true);
        verificationStartTime = System.nanoTime();
        verificationTimer.start();
        updateVerificationTime();
        verificationWorker = new SwingWorker<>() {
            @Override
            protected VerificationOutcome doInBackground() {
                final Program program;
                try {
                    program = parseSource(sourceCode, format, programEditor.getLoadedDir());
                    program.setName("dat3mUI");
                } catch (Exception e) {
                    return VerificationOutcome.programError(e);
                }

                final Wmm targetModel;
                try {
                    targetModel = new ParserCat().parse(wmmCode);
                } catch (Exception e) {
                    return VerificationOutcome.memoryModelError(e);
                }

                return VerificationOutcome.success(new ReachabilityResult(program, targetModel, options, manager));
            }

            @Override
            protected void done() {
                verificationTimer.stop();
                optionsPane.getTestButton().setEnabled(true);
                optionsPane.getClearButton().setEnabled(true);
                optionsPane.getCancelButton().setEnabled(false);
                shutdownManager = null;
                try {
                    if (cancellationRequested) {
                        optionsPane.getConsolePane().setText("CANCELLED");
                        return;
                    }
                    final VerificationOutcome outcome = get();
                    if (outcome.errorMessage() != null) {
                        optionsPane.getConsolePane().setText("");
                        showError(outcome.errorMessage(), outcome.errorTitle());
                        return;
                    }

                    testResult = outcome.result();
                    optionsPane.getConsolePane().setText(testResult.getVerdict());
                    if (options.showWitness() && testResult.hasWitness()) {
                        showViolation(testResult);
                    }
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                    optionsPane.getConsolePane().setText("");
                    showError("Verification was interrupted", "Verification error");
                } catch (ExecutionException e) {
                    optionsPane.getConsolePane().setText("");
                    showError(e.getCause().getMessage(), "Verification error");
                }
            }
        };
        verificationWorker.execute();
    }

    private void updateVerificationTime() {
        if (cancellationRequested) {
            return;
        }
        final long elapsedSeconds = (System.nanoTime() - verificationStartTime) / 1_000_000_000;
        final long hours = elapsedSeconds / 3600;
        final long minutes = (elapsedSeconds % 3600) / 60;
        final long seconds = elapsedSeconds % 60;
        final String elapsedTime = hours > 0
                ? "%d:%02d:%02d".formatted(hours, minutes, seconds)
                : "%d:%02d".formatted(minutes, seconds);
        optionsPane.getConsolePane().setText("Running... " + elapsedTime);
    }

    private void cancelVerification() {
        if (verificationWorker == null || verificationWorker.isDone()) {
            return;
        }
        cancellationRequested = true;
        optionsPane.getCancelButton().setEnabled(false);
        optionsPane.getConsolePane().setText("Cancelling...");
        final ShutdownManager manager = shutdownManager;
        if (manager != null) {
            manager.requestShutdown("Cancelled by user");
        }
    }

    private Program parseSource(String sourceCode, String format, String sourceDirectory) throws Exception {
        final Path sourceFile = createTemporarySourceFile(sourceDirectory, format);
        try {
            Files.writeString(sourceFile, sourceCode);
            return programParser.parseTemporary(sourceFile);
        } finally {
            Files.deleteIfExists(sourceFile);
        }
    }

    private static Path createTemporarySourceFile(String sourceDirectory, String format) throws IOException {
        if (!sourceDirectory.isEmpty()) {
            try {
                return Files.createTempFile(Path.of(sourceDirectory), "dat3m-ui-", format);
            } catch (IOException exception) {
                throw new IOException(
                        "Cannot create a temporary source file in %s. Save the source to a writable directory first."
                                .formatted(sourceDirectory),
                        exception
                );
            }
        }
        return Files.createTempFile("dat3m-ui-", format);
    }

    private record VerificationOutcome(ReachabilityResult result, String errorTitle, String errorMessage) {

        private static VerificationOutcome success(ReachabilityResult result) {
            return new VerificationOutcome(result, null, null);
        }

        private static VerificationOutcome programError(Exception exception) {
            final Throwable cause = exception.getCause();
            String message = exception.getMessage() == null ? "Program cannot be parsed" : exception.getMessage();
            if (cause instanceof InputMismatchException inputMismatchException) {
                final Token token = inputMismatchException.getOffendingToken();
                message = "Problem with \"" + token.getText() + "\" at line " + token.getLine();
            }
            return new VerificationOutcome(null, "Program error", message);
        }

        private static VerificationOutcome memoryModelError(Exception exception) {
            final String message = exception.getMessage() == null ? "Memory model cannot be parsed" : exception.getMessage();
            return new VerificationOutcome(null, "Target memory model error", message);
        }
    }
}
