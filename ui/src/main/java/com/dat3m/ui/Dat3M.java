package com.dat3m.ui;

import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.verification.VerificationStatus;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.ui.components.Buttons;
import com.dat3m.ui.components.Chip;
import com.dat3m.ui.components.HeaderBar;
import com.dat3m.ui.components.Icons;
import com.dat3m.ui.components.Text;
import com.dat3m.ui.editor.Editor;
import com.dat3m.ui.editor.EditorsPane;
import com.dat3m.ui.options.OptionsPane;
import com.dat3m.ui.result.ReachabilityResult;
import com.dat3m.ui.result.ResultPane;
import com.dat3m.ui.theme.Theme;
import com.dat3m.ui.utils.UiOptions;
import com.dat3m.ui.witness.WitnessPane;
import org.antlr.v4.runtime.InputMismatchException;
import org.antlr.v4.runtime.Token;
import org.sosy_lab.common.ShutdownManager;

import javax.swing.*;
import java.awt.*;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Set;
import java.util.concurrent.ExecutionException;
import java.util.function.UnaryOperator;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.utils.EnvironmentInfo.initEnvironmentInfo;
import static com.dat3m.dartagnan.utils.EnvironmentInfo.logEnvironmentInfo;
import static com.dat3m.ui.utils.Utils.showError;

public class Dat3M extends JFrame {

    private static final String UI_SOURCE_NAME = "dat3mUI";
    private static final String TEMPORARY_SOURCE_PREFIX = "dat3m-ui-";
    private static final Pattern TEMPORARY_SOURCE = Pattern.compile(Pattern.quote(TEMPORARY_SOURCE_PREFIX) + "\\d+(\\.[A-Za-z]+)+");
    private static final String WORKBENCH_CARD = "workbench";
    private static final String WITNESS_CARD = "witness";

    private final OptionsPane optionsPane = new OptionsPane();
    private final ProgramParser programParser;
    private final EditorsPane editorsPane;
    private final ResultPane resultPane = new ResultPane();
    private final WitnessPane witnessPane = new WitnessPane(this::showWorkbench);
    private final CardLayout screens = new CardLayout();

    private final HeaderBar header;
    private final Text statusText = new Text("Not verified", Text.Role.MUTED);
    private final JButton verifyButton = Buttons.primary("Verify", Icons.play());
    private final JButton cancelButton = Buttons.plain("Cancel", Icons.stop());

    private SwingWorker<VerificationOutcome, Void> verificationWorker;
    private volatile ShutdownManager shutdownManager;
    private boolean cancellationRequested;
    private boolean timeoutElapsed;
    private final Timer verificationTimer;
    private Timer timeoutTimer;
    private long verificationStartTime;

    private Dat3M() throws IOException {
        initEnvironmentInfo();
        programParser = new ProgramParser();
        editorsPane = new EditorsPane(programParser.getSupportedExtensions().stream()
                .filter(extension -> !extension.equals(ProgramParser.EXTENSION_SPV_DIS))
                .collect(Collectors.toUnmodifiableSet()));
        verificationTimer = new Timer(1000, ignored -> updateVerificationTime());

        setTitle("Dat3M");
        setExtendedState(JFrame.MAXIMIZED_BOTH);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setMinimumSize(new Dimension(960, 600));
        setJMenuBar(newMenuBar());

        cancelButton.setVisible(false);
        verifyButton.addActionListener(event -> runTest());
        cancelButton.addActionListener(event -> cancelVerification());
        header = new HeaderBar(statusText, cancelButton, verifyButton);

        final JSplitPane editorsAndResult = new JSplitPane(JSplitPane.VERTICAL_SPLIT, editorsPane.getMainPane(), resultPane);
        editorsAndResult.setResizeWeight(1);
        editorsAndResult.setDividerSize(5);
        editorsAndResult.setBorder(BorderFactory.createEmptyBorder());

        final JPanel workbench = new JPanel(new BorderLayout());
        workbench.add(header, BorderLayout.NORTH);
        workbench.add(optionsPane, BorderLayout.WEST);
        workbench.add(editorsAndResult, BorderLayout.CENTER);

        getContentPane().setLayout(screens);
        getContentPane().add(workbench, WORKBENCH_CARD);
        getContentPane().add(witnessPane, WITNESS_CARD);

        resultPane.setWitnessAction(() -> screens.show(getContentPane(), WITNESS_CARD));

        // A result becomes stale as soon as its inputs change.
        final Editor programEditor = editorsPane.getProgramEditor();
        final Editor modelEditor = editorsPane.getModelEditor();
        optionsPane.addChangeListener(this::invalidateResult);
        programEditor.addChangeListener(this::onSourceChanged);
        modelEditor.addChangeListener(this::onSourceChanged);
        onSourceChanged();

        pack();
    }

    public static void main(String[] args) {
        System.setProperty("apple.laf.useScreenMenuBar", "true");
        System.setProperty("apple.awt.application.name", "Dat3M");
        EventQueue.invokeLater(() -> {
            Theme.install(false);
            try {
                Dat3M app = new Dat3M();
                app.setVisible(true);
            } catch (IOException e) {
                showError(e.getMessage(), "Failed to load compilation pipeline");
            }
        });
    }

    private JMenuBar newMenuBar() {
        final JMenu fileMenu = new JMenu("File");
        fileMenu.add(editorsPane.getProgramEditor().getImportAction());
        fileMenu.add(editorsPane.getModelEditor().getImportAction());
        fileMenu.addSeparator();
        fileMenu.add(editorsPane.getProgramEditor().getExportAction());
        fileMenu.add(editorsPane.getModelEditor().getExportAction());

        final JMenu viewMenu = new JMenu("View");
        final JCheckBoxMenuItem darkThemeItem = new JCheckBoxMenuItem("Dark theme");
        darkThemeItem.addItemListener(event -> Theme.install(darkThemeItem.isSelected()));
        viewMenu.add(darkThemeItem);

        final JMenuBar menuBar = new JMenuBar();
        menuBar.add(fileMenu);
        menuBar.add(viewMenu);
        return menuBar;
    }

    private void showWorkbench() {
        screens.show(getContentPane(), WORKBENCH_CARD);
    }

    private void onSourceChanged() {
        final File programFile = editorsPane.getProgramEditor().getLoadedFile().orElse(null);
        final File modelFile = editorsPane.getModelEditor().getLoadedFile().orElse(null);
        optionsPane.setFiles(programFile == null ? null : programFile.getPath(), modelFile == null ? null : modelFile.getPath());
        if (programFile == null) {
            header.setLocation("", "untitled");
        } else {
            final File directory = programFile.getParentFile();
            header.setLocation(directory == null ? "" : directory.getName(), programFile.getName());
        }
        invalidateResult();
    }

    private void invalidateResult() {
        if (verificationWorker != null && !verificationWorker.isDone()) {
            return;
        }
        resultPane.showIdle();
        statusText.setText("Not verified");
    }

    private void runTest() {
        final UiOptions options = optionsPane.getOptions();
        final Editor programEditor = editorsPane.getProgramEditor();
        final String sourceCode = programEditor.getEditorPane().getText();
        final String format = programEditor.getSelectedFormat();
        final String wmmCode = editorsPane.getModelEditor().getEditorPane().getText();
        final String programName = programEditor.getLoadedFile().map(File::getName).orElse("untitled");

        cancellationRequested = false;
        timeoutElapsed = false;
        resultPane.getLogPane().clear();
        final ShutdownManager manager = ShutdownManager.create();
        shutdownManager = manager;

        verifyButton.setEnabled(false);
        cancelButton.setEnabled(true);
        cancelButton.setVisible(true);
        resultPane.showRunning();
        verificationStartTime = System.nanoTime();
        verificationTimer.start();
        updateVerificationTime();
        if (options.timeout() > 0) {
            timeoutTimer = new Timer(options.timeout() * 1000, ignored -> {
                timeoutElapsed = true;
                manager.requestShutdown("Timeout elapsed");
            });
            timeoutTimer.setRepeats(false);
            timeoutTimer.start();
        }
        verificationWorker = new SwingWorker<>() {
            @Override
            protected VerificationOutcome doInBackground() {
                logEnvironmentInfo(Set.of());
                final Program program;
                try {
                    program = parseSource(sourceCode, format, programEditor.getLoadedDir());
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
                final String elapsedTime = getElapsedTime();
                verificationTimer.stop();
                if (timeoutTimer != null) {
                    timeoutTimer.stop();
                    timeoutTimer = null;
                }
                verifyButton.setEnabled(true);
                cancelButton.setVisible(false);
                shutdownManager = null;
                try {
                    showOutcome(get(), options, programName, elapsedTime);
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                    showFailure("Verification error", "The verification was interrupted.");
                } catch (ExecutionException e) {
                    showFailure("Verification error", String.valueOf(e.getCause()));
                }
            }
        };
        verificationWorker.execute();
    }

    private void showOutcome(VerificationOutcome outcome, UiOptions options, String programName, String elapsedTime) {
        if (cancellationRequested) {
            statusText.setText("Cancelled");
            resultPane.showOutcome(Chip.Kind.NEUTRAL, "Cancelled", "Verification cancelled",
                    "after " + elapsedTime, "", "", false);
            return;
        }
        if (timeoutElapsed) {
            statusText.setText("Timeout");
            resultPane.showOutcome(Chip.Kind.NEUTRAL, "Timeout", "Verification timed out",
                    "after %d s".formatted(options.timeout()), "", "", false);
            return;
        }
        if (outcome.errorMessage() != null) {
            showFailure(outcome.errorTitle(), outcome.errorMessage());
            return;
        }
        final ReachabilityResult result = outcome.result();
        if (result.isError() || result.getStatus().isEmpty()) {
            showFailure(result.isInterrupted() ? "Verification interrupted" : "Verification error", result.getVerdict());
            return;
        }

        final VerificationStatus status = result.getStatus().orElseThrow();
        final Chip.Kind kind = switch (status) {
            case PASS -> Chip.Kind.PASS;
            case FAIL -> Chip.Kind.FAIL;
            case UNKNOWN -> Chip.Kind.NEUTRAL;
        };
        // The program is parsed from a temporary file, whose name is meaningless to the user.
        final UnaryOperator<String> sourceNamer = text -> TEMPORARY_SOURCE.matcher(text).replaceAll(Matcher.quoteReplacement(programName));
        final String summary = sourceNamer.apply(result.getVerdict());
        final String reason = getSummaryEntry(summary, "Reason: ");
        final String title = !reason.isEmpty() ? reason : switch (status) {
            case PASS -> "Verification passed";
            case FAIL -> "Verification failed";
            case UNKNOWN -> "No conclusive result";
        };
        final String specification = getSummaryEntry(summary, "Condition: ");
        statusText.setText("Finished in " + elapsedTime);
        resultPane.showOutcome(kind, status.toString(), title, "in " + elapsedTime, specification, summary, result.hasWitness());
        if (result.hasWitness()) {
            witnessPane.showWitness(result.getWitness().mapSourceTexts(sourceNamer), programName, status.toString(), kind,
                    specification.isEmpty() ? title : specification);
        }
    }

    private void showFailure(String title, String message) {
        statusText.setText("Error");
        resultPane.showOutcome(Chip.Kind.FAIL, "Error", title, "", "", message == null ? "" : message, false);
    }

    // The summary of a verification consists of lines of the form "Key: value".
    private static String getSummaryEntry(String summary, String key) {
        return summary.lines()
                .filter(line -> line.startsWith(key))
                .map(line -> line.substring(key.length()).strip())
                .findFirst().orElse("");
    }

    private String getElapsedTime() {
        final long elapsedSeconds = (System.nanoTime() - verificationStartTime) / 1_000_000_000;
        final long hours = elapsedSeconds / 3600;
        final long minutes = (elapsedSeconds % 3600) / 60;
        final long seconds = elapsedSeconds % 60;
        return hours > 0
                ? "%d:%02d:%02d".formatted(hours, minutes, seconds)
                : "%d:%02d".formatted(minutes, seconds);
    }

    private void updateVerificationTime() {
        if (cancellationRequested) {
            return;
        }
        final String elapsedTime = getElapsedTime();
        statusText.setText("Verifying… " + elapsedTime);
        resultPane.setElapsedTime(elapsedTime);
    }

    private void cancelVerification() {
        if (verificationWorker == null || verificationWorker.isDone()) {
            return;
        }
        cancellationRequested = true;
        cancelButton.setEnabled(false);
        statusText.setText("Cancelling…");
        final ShutdownManager manager = shutdownManager;
        if (manager != null) {
            manager.requestShutdown("Cancelled by user");
        }
    }

    private Program parseSource(String sourceCode, String format, String sourceDirectory) throws Exception {
        final Path sourceFile = createTemporarySourceFile(sourceDirectory, format);
        try {
            Files.writeString(sourceFile, sourceCode);
            final Program program = programParser.parseTemporary(sourceFile);
            program.setName(UI_SOURCE_NAME);
            return program;
        } finally {
            Files.deleteIfExists(sourceFile);
        }
    }

    private static Path createTemporarySourceFile(String sourceDirectory, String format) throws IOException {
        if (!sourceDirectory.isEmpty()) {
            try {
                return Files.createTempFile(Path.of(sourceDirectory), TEMPORARY_SOURCE_PREFIX, format);
            } catch (IOException exception) {
                throw new IOException(
                        "Cannot create a temporary source file in %s. Save the source to a writable directory first."
                                .formatted(sourceDirectory),
                        exception
                );
            }
        }
        return Files.createTempFile(TEMPORARY_SOURCE_PREFIX, format);
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
            return new VerificationOutcome(null, "Memory model error", message);
        }
    }
}
