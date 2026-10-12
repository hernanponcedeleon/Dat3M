package com.dat3m.ui.result;

import com.dat3m.ui.components.Buttons;
import com.dat3m.ui.components.Chip;
import com.dat3m.ui.components.Icons;
import com.dat3m.ui.components.Surface;
import com.dat3m.ui.components.Text;
import com.dat3m.ui.log.LogPane;
import com.dat3m.ui.theme.Theme;

import javax.swing.*;
import java.awt.*;

// The panel below the editors: the outcome of the last verification and the log.
public class ResultPane extends JPanel {

    private static final String RESULT_CARD = "result";
    private static final String LOG_CARD = "log";
    private static final String IDLE_CARD = "idle";
    private static final String RUNNING_CARD = "running";
    private static final String OUTCOME_CARD = "outcome";
    private static final int PREFERRED_HEIGHT = 260;
    private static final int TAB_HEIGHT = 44;

    private final LogPane logPane = new LogPane();
    private final CardLayout tabCards = new CardLayout();
    private final JPanel tabContent = new JPanel(tabCards);
    private final CardLayout stateCards = new CardLayout();
    private final JPanel stateContent = new JPanel(stateCards);
    private final JToggleButton resultTab = new Tab("Result");
    private final JToggleButton logTab = new Tab("Log");

    private final Text elapsedText = new Text("", Text.Role.MUTED);
    private final Chip chip = new Chip("", Chip.Kind.NEUTRAL);
    private final Text headline = new Text("", Text.Role.HEADLINE);
    private final Text sideNote = new Text("", Text.Role.MUTED);
    private final Text condition = new Text("", Text.Role.MONO);
    private final JTextArea details = new JTextArea() {
        @Override
        public void updateUI() {
            super.updateUI();
            setFont(Theme.mono(12f));
            setBackground(Theme.p().ground());
            setForeground(Theme.p().ink());
        }
    };
    private final JButton witnessButton = Buttons.primary("Open witness graph", Icons.arrowRight());

    public ResultPane() {
        super(new BorderLayout());
        setPreferredSize(new Dimension(0, PREFERRED_HEIGHT));
        setMinimumSize(new Dimension(0, 120));

        add(newTabStrip(), BorderLayout.NORTH);
        stateContent.add(newIdleCard(), IDLE_CARD);
        stateContent.add(newRunningCard(), RUNNING_CARD);
        stateContent.add(newOutcomeCard(), OUTCOME_CARD);
        tabContent.add(stateContent, RESULT_CARD);
        tabContent.add(logPane, LOG_CARD);
        add(tabContent, BorderLayout.CENTER);
        selectTab(resultTab);
        showIdle();
    }

    public LogPane getLogPane() {
        return logPane;
    }

    public void setWitnessAction(Runnable action) {
        witnessButton.addActionListener(event -> action.run());
    }

    public void showIdle() {
        stateCards.show(stateContent, IDLE_CARD);
    }

    public void showRunning() {
        elapsedText.setText("");
        stateCards.show(stateContent, RUNNING_CARD);
        selectTab(resultTab);
    }

    public void setElapsedTime(String elapsedTime) {
        elapsedText.setText("Running for " + elapsedTime);
    }

    /*
        @param verdict The short verdict shown in the chip, e.g. PASS.
        @param title The outcome in one sentence.
        @param note Secondary information like the time it took.
        @param specification The checked condition, if there is one.
        @param text The full output of the verification.
     */
    public void showOutcome(Chip.Kind kind, String verdict, String title, String note, String specification,
                            String text, boolean hasWitness) {
        chip.setState(verdict, kind);
        headline.setText(title);
        sideNote.setText(note);
        condition.setText(specification);
        condition.setVisible(!specification.isEmpty());
        details.setText(text);
        details.setCaretPosition(0);
        witnessButton.setVisible(hasWitness);
        stateCards.show(stateContent, OUTCOME_CARD);
        selectTab(resultTab);
    }

    // ================================= Construction =================================

    private JComponent newTabStrip() {
        final ButtonGroup group = new ButtonGroup();
        group.add(resultTab);
        group.add(logTab);
        resultTab.addActionListener(event -> selectTab(resultTab));
        logTab.addActionListener(event -> selectTab(logTab));

        final JPanel tabs = new JPanel(new GridLayout(1, 2, 4, 0));
        tabs.setOpaque(false);
        tabs.add(resultTab);
        tabs.add(logTab);

        final Box logControls = Box.createHorizontalBox();
        final JComboBox<?> levelSelector = logPane.getLevelSelector();
        levelSelector.setMaximumSize(levelSelector.getPreferredSize());
        levelSelector.setVisible(false);
        logControls.add(levelSelector);

        final Surface strip = Surface.panel(new BorderLayout()).lines(1, 0, 1, 0).padding(0, 12, 0, 12);
        strip.setPreferredSize(new Dimension(0, TAB_HEIGHT));
        strip.add(tabs, BorderLayout.WEST);
        strip.add(logControls, BorderLayout.EAST);
        return strip;
    }

    private void selectTab(JToggleButton tab) {
        tab.setSelected(true);
        tabCards.show(tabContent, tab == logTab ? LOG_CARD : RESULT_CARD);
        logPane.getLevelSelector().setVisible(tab == logTab);
    }

    private JComponent newIdleCard() {
        final Surface card = Surface.panel(new GridBagLayout()).padding(24, 24, 24, 24);
        final GridBagConstraints constraints = newColumnConstraints();
        final Text title = new Text("No result yet", Text.Role.TITLE);
        title.setFont(Theme.ui(16f, Font.BOLD));
        card.add(title, constraints);
        constraints.insets = new Insets(4, 0, 0, 0);
        card.add(new Text("Press Verify to check the program against the memory model.", Text.Role.MUTED), constraints);
        constraints.weighty = 1;
        card.add(Box.createGlue(), constraints);
        return card;
    }

    private JComponent newRunningCard() {
        final Surface card = Surface.panel(new GridBagLayout()).padding(24, 24, 24, 24);
        final GridBagConstraints constraints = newColumnConstraints();
        final Text title = new Text("Verifying…", Text.Role.TITLE);
        title.setFont(Theme.ui(16f, Font.BOLD));
        card.add(title, constraints);

        final JProgressBar progress = new JProgressBar();
        progress.setIndeterminate(true);
        progress.setPreferredSize(new Dimension(480, 4));
        progress.getAccessibleContext().setAccessibleName("Verification in progress");
        constraints.insets = new Insets(12, 0, 0, 0);
        constraints.fill = GridBagConstraints.NONE;
        card.add(progress, constraints);
        card.add(elapsedText, constraints);
        constraints.weighty = 1;
        card.add(Box.createGlue(), constraints);
        return card;
    }

    private JComponent newOutcomeCard() {
        final JPanel verdictRow = new JPanel(new FlowLayout(FlowLayout.LEFT, 0, 0));
        verdictRow.setOpaque(false);
        verdictRow.add(chip);
        verdictRow.add(Box.createHorizontalStrut(10));
        verdictRow.add(sideNote);

        final JPanel summary = new JPanel(new GridBagLayout());
        summary.setOpaque(false);
        final GridBagConstraints constraints = newColumnConstraints();
        summary.add(verdictRow, constraints);
        constraints.insets = new Insets(10, 0, 0, 0);
        summary.add(headline, constraints);
        summary.add(condition, constraints);
        constraints.insets = new Insets(16, 0, 0, 0);
        constraints.fill = GridBagConstraints.NONE;
        summary.add(witnessButton, constraints);
        constraints.weighty = 1;
        summary.add(Box.createGlue(), constraints);

        details.setEditable(false);
        details.setBorder(BorderFactory.createEmptyBorder(10, 12, 10, 12));
        details.getAccessibleContext().setAccessibleName("Verification output");
        final JScrollPane detailsScroll = new JScrollPane(details);
        detailsScroll.setBorder(BorderFactory.createEmptyBorder());

        final JPanel columns = new JPanel(new GridLayout(1, 2, 32, 0));
        columns.setOpaque(false);
        columns.add(summary);
        columns.add(detailsScroll);
        final Surface card = Surface.panel(new BorderLayout()).padding(20, 24, 20, 24);
        card.add(columns, BorderLayout.CENTER);
        return card;
    }

    private static GridBagConstraints newColumnConstraints() {
        final GridBagConstraints constraints = new GridBagConstraints();
        constraints.gridx = 0;
        constraints.weightx = 1;
        constraints.fill = GridBagConstraints.HORIZONTAL;
        constraints.anchor = GridBagConstraints.NORTHWEST;
        return constraints;
    }

    private static final class Tab extends JToggleButton {

        private Tab(String text) {
            super(text);
            setContentAreaFilled(false);
            setBorderPainted(false);
            setBorder(BorderFactory.createEmptyBorder(0, 12, 0, 12));
        }

        @Override
        public void updateUI() {
            super.updateUI();
            setFont(Theme.ui(13f, Font.BOLD));
        }

        @Override
        protected void paintComponent(Graphics g) {
            setForeground(isSelected() ? Theme.p().ink() : Theme.p().muted());
            super.paintComponent(g);
            if (isSelected()) {
                g.setColor(Theme.p().accent());
                g.fillRect(0, getHeight() - 2, getWidth(), 2);
            }
        }
    }
}
