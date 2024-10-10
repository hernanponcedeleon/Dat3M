package com.dat3m.ui.options;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Method;
import com.dat3m.dartagnan.configuration.OptionInfo;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.configuration.ProgressModel;
import com.dat3m.ui.button.ClearButton;
import com.dat3m.ui.button.TestButton;
import com.dat3m.ui.options.utils.ControlCode;
import com.dat3m.ui.utils.UiOptions;
import org.sosy_lab.java_smt.SolverContextFactory.Solvers;

import javax.swing.*;
import javax.swing.border.Border;
import javax.swing.border.TitledBorder;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.FocusAdapter;
import java.awt.event.FocusEvent;
import java.awt.event.ItemEvent;
import java.awt.event.WindowEvent;
import java.awt.event.WindowFocusListener;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.EnumSet;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.concurrent.ExecutionException;

import static com.dat3m.dartagnan.configuration.OptionNames.*;
import static com.dat3m.ui.options.utils.Helper.solversOrderedValues;
import static com.dat3m.ui.utils.Utils.showError;
import static java.awt.FlowLayout.LEFT;
import static javax.swing.BorderFactory.createTitledBorder;
import static javax.swing.border.TitledBorder.CENTER;

public class OptionsPane extends JPanel {

    public final static int OPTWIDTH = 300;

    private static final List<String> BASIC_OPTIONS = List.of(TARGET, METHOD, BOUND, SOLVER, TIMEOUT, WITNESS, PROPERTY, PROGRESSMODEL);

    private final JLabel iconPane = new JLabel();

    private final Selector<Method> methodPane;
    private final Selector<Solvers> solverPane;
    private final Selector<Property> propertyPane;
    private final Selector<ProgressModel> progressPane;

    private final Selector<Arch> targetPane;

    private final BoundField boundField;
    private final TimeoutField timeoutField;

    private final JTextField cflagsField;

    private final JTextField extraOptionsField;
    private final JDialog extraOptionsDialog;
    private final Map<String, String> extraOptionsMap = new LinkedHashMap<>();
    private final JFileChooser configurationFileChooser = new JFileChooser();

    private final JButton extraOptionsButton;
    private final JButton testButton;
    private final JButton clearButton;

    private final JRadioButton showViolationField;

    private final JTextPane consolePane;

    public OptionsPane() {
        super(new GridLayout(1, 0));

        methodPane = new Selector<>(Method.orderedValues(), ControlCode.METHOD);
        methodPane.setSelectedItem(Method.getDefault());

        solverPane = new Selector<>(solversOrderedValues(), ControlCode.SOLVER);
        solverPane.setSelectedItem(Solvers.Z3);

        propertyPane = new Selector<>(Property.orderedValues(), ControlCode.PROPERTY);
        solverPane.setSelectedItem(Property.PROGRAM_SPEC);

        targetPane = new Selector<>(Arch.orderedValues(), ControlCode.TARGET);
        targetPane.setSelectedItem(Arch.getDefault());

        progressPane = new Selector<>(ProgressModel.orderedValues(), ControlCode.PROGRESS);
        progressPane.setSelectedItem(ProgressModel.getDefault());

        boundField = new BoundField();
        timeoutField = new TimeoutField();
        showViolationField = new JRadioButton();

        cflagsField = new JTextField();
        cflagsField.setColumns(20);

        extraOptionsField = new JTextField();
        extraOptionsField.setColumns(20);
        extraOptionsButton = new JButton("...");
        setLayout(new BoxLayout(this, BoxLayout.X_AXIS));
        extraOptionsButton.setToolTipText("Manage extra options.");
        extraOptionsDialog = newDialog();

        testButton = new TestButton();
        clearButton = new ClearButton();

        consolePane = new JTextPane();
        consolePane.setEditable(false);

        bindListeners();
        mkGrid();
    }

    private void bindListeners() {
        // optionsPane needs to listen to options to clean the console
        // Alias and Mode do not change the result, and thus we don't listen to them
        targetPane.addActionListener(this::clearConsole);
        boundField.addActionListener(this::clearConsole);
        timeoutField.addActionListener(this::clearConsole);
        clearButton.addActionListener(this::clearConsole);
        propertyPane.addActionListener(this::clearConsole);
        progressPane.addActionListener(this::clearConsole);
        extraOptionsButton.addActionListener(this::handleExtraOptionsButton);
        extraOptionsField.addFocusListener(new FocusAdapter() {
            @Override
            public void focusGained(FocusEvent e) {
                toText();
            }
            @Override
            public void focusLost(FocusEvent e) {
                fromText();
            }
        });
    }

    public JButton getTestButton() {
        return testButton;
    }

    public JTextPane getConsolePane() {
        return consolePane;
    }

    public UiOptions getOptions() {
        int bound = Integer.parseInt(boundField.getText());
        int timeout = Integer.parseInt(timeoutField.getText());
        boolean showViolationGraph = showViolationField.isSelected();
        String cflags = cflagsField.getText().strip();
        Arch target = (Arch) targetPane.getSelectedItem();
        Method method = (Method) methodPane.getSelectedItem();
        Solvers solver = (Solvers) solverPane.getSelectedItem();
        EnumSet<Property> properties = EnumSet.of((Property) propertyPane.getSelectedItem());
        ProgressModel progress = (ProgressModel) progressPane.getSelectedItem();
        return new UiOptions(target, method, bound, solver, timeout, showViolationGraph, cflags, extraOptionsMap, properties, progress);
    }

    private void mkGrid() {

        JScrollPane scrollConsole = new JScrollPane(consolePane);
        scrollConsole.setMaximumSize(new Dimension(OPTWIDTH, 120));
        scrollConsole.setHorizontalScrollBarPolicy(JScrollPane.HORIZONTAL_SCROLLBAR_AS_NEEDED);

        JSplitPane boundsPane = new JSplitPane(JSplitPane.HORIZONTAL_SPLIT);
        JPanel boundPane = new BoundPane();
        boundPane.add(boundField);
        JPanel timeoutPane = new TimeoutPane();
        timeoutPane.add(timeoutField);
        boundsPane.setLeftComponent(boundPane);
        boundsPane.setRightComponent(timeoutPane);
        boundsPane.setMaximumSize(new Dimension(OPTWIDTH, 50));
        boundsPane.setDividerSize(0);

        JPanel cflagsPane = new JPanel(new FlowLayout(LEFT));
        cflagsPane.add(new JLabel("CFLAGS: "));
        cflagsPane.add(cflagsField);

        JPanel configPane = new JPanel(new FlowLayout(LEFT));
        configPane.add(new JLabel("Extra options: "));
        configPane.add(extraOptionsField);
        configPane.add(extraOptionsButton);

        JPanel showViolationPane = new JPanel(new FlowLayout(LEFT));
        showViolationPane.add(new JLabel("Show witness graph"));
        showViolationPane.add(showViolationField);

        // Inner borders
        Border emptyBorder = BorderFactory.createEmptyBorder();

        JSplitPane graphPane = new JSplitPane(JSplitPane.HORIZONTAL_SPLIT);
        graphPane.setDividerSize(0);
        JComponent[] panes = { targetPane, methodPane, solverPane, propertyPane, progressPane, boundsPane, showViolationPane, configPane,
                cflagsPane, testButton, clearButton, graphPane, scrollConsole };
        Iterator<JComponent> it = Arrays.asList(panes).iterator();
        JComponent current = iconPane;
        current.setBorder(emptyBorder);
        while (it.hasNext()) {
            JComponent next = it.next();
            current = new JSplitPane(JSplitPane.VERTICAL_SPLIT, current, next);
            ((JSplitPane) current).setDividerSize(2);
            current.setBorder(emptyBorder);
            if (!(next instanceof JButton)) {
                next.setBorder(emptyBorder);
            }
        }
        add(current);

        // Outer border
        TitledBorder titledBorder = createTitledBorder("Options");
        titledBorder.setTitleJustification(CENTER);
        setBorder(titledBorder);
    }

    public void clearConsole(ActionEvent ignoreEvent) {
        // Any change in the (relevant) options clears the console
        getConsolePane().setText("");
    }

    private void fromText() {
        extraOptionsMap.clear();
        for (String c : extraOptionsField.getText().split(" ")) {
            int separator = c.indexOf('=');
            if (separator != -1 && c.startsWith("--")) {
                extraOptionsMap.put(c.substring(2, separator), c.substring(separator + 1));
            }
        }
    }

    private void toText() {
        final var text = new StringBuilder();
        boolean init = false;
        for (Map.Entry<String, String> entry : extraOptionsMap.entrySet()) {
            text.append(init ? " --" : "--").append(entry.getKey()).append('=').append(entry.getValue());
            init = true;
        }
        extraOptionsField.setText(text.toString());
    }

    private void handleExtraOptionsButton(ActionEvent e) {
        extraOptionsDialog.setVisible(true);
        extraOptionsDialog.setLocationRelativeTo(this);
        extraOptionsDialog.requestFocus();
    }

    private void doExport() {
        configurationFileChooser.showSaveDialog(this);
        final File file = configurationFileChooser.getSelectedFile();
        if (file == null) {
            return;
        }
        Properties properties = new Properties();
        properties.putAll(extraOptionsMap);
        try (FileWriter writer = new FileWriter(file)) {
            properties.store(writer, "Created with Dartagnan");
        } catch (IOException e) {
            showError(e.getMessage(), "Error while exporting configuration");
        }
    }

    private void doImport() {
        configurationFileChooser.showOpenDialog(this);
        final File file = configurationFileChooser.getSelectedFile();
        if (file == null) {
            return;
        }
        Properties properties = new Properties();
        try (FileReader reader = new FileReader(file)) {
            properties.load(reader);
        } catch (IOException e) {
            showError(e.getMessage(), "Error while importing configuration");
            return;
        }
        extraOptionsMap.clear();
        for (Map.Entry<Object, Object> entry : properties.entrySet()) {
            extraOptionsMap.put(entry.getKey().toString(), entry.getValue().toString());
        }
    }

    private JDialog newDialog() {
        final var dialog = new JDialog();
        dialog.setTitle("Advanced Settings");
        final var dialogPane = dialog.getContentPane();
        final var optionPanel = new JScrollPane(newOptionPanel());
        optionPanel.setVerticalScrollBarPolicy(JScrollPane.VERTICAL_SCROLLBAR_ALWAYS);
        optionPanel.setPreferredSize(new Dimension(800, 450));
        dialogPane.add(optionPanel, BorderLayout.CENTER);
        dialogPane.add(newDialogButtons(), BorderLayout.SOUTH);
        dialog.pack();
        dialog.addWindowFocusListener(new WindowFocusListener() {
            @Override
            public void windowGainedFocus(WindowEvent e) {
            }
            @Override
            public void windowLostFocus(WindowEvent e) {
                toText();
            }
        });
        return dialog;
    }

    private JPanel newOptionPanel() {
        final var panel = new JPanel();
        final var layout = new SpringLayout();
        panel.setLayout(layout);
        new Worker(panel, layout).execute();
        return panel;
    }

    private JPanel newDialogButtons() {
        final var panel = new JPanel();
        panel.setLayout(new FlowLayout(FlowLayout.RIGHT));
        final var importButton = new JButton("Import");
        importButton.setToolTipText("Load a configuration from a file");
        importButton.addActionListener(e -> doImport());
        panel.add(importButton);
        final var exportButton = new JButton("Export");
        exportButton.setToolTipText("Save the current configuration to a file");
        exportButton.addActionListener(e -> doExport());
        panel.add(exportButton);
        final var okButton = new JButton("OK");
        okButton.addActionListener(event -> extraOptionsDialog.setVisible(false));
        panel.add(okButton);
        return panel;
    }

    private JComponent newField(OptionInfo info) {
        if (boolean.class.equals(info.getDomain())) {
            final var field = new JCheckBox();
            field.addItemListener(event -> {
                switch (event.getStateChange()) {
                    case ItemEvent.SELECTED -> setOption(info.getName(), "true");
                    case ItemEvent.DESELECTED -> setOption(info.getName(), "false");
                }
            });
            return field;
        }
        if (info.getDomain().isEnum()) {
            final var field = new JComboBox<String>();
            field.addItem("");
            for (Object value : info.getDomain().getEnumConstants()) {
                field.addItem(value.toString());
            }
            field.addItemListener(event -> setOption(info.getName(), (String) event.getItem()));
            return field;
        }
        final var field = new JTextField();
        field.addFocusListener(new FocusAdapter() {
            @Override
            public void focusLost(FocusEvent e) {
                setOption(info.getName(), field.getText());
            }
        });
        return field;
    }

    private void setOption(String key, String value) {
        //TODO sometimes, the empty string should be treated as a valid value
        if (value.isEmpty()) {
            extraOptionsMap.remove(key);
        } else {
            extraOptionsMap.put(key, value);
        }
    }

    private final class Worker extends SwingWorker<List<OptionInfo>, Void> {
        private static final int LINE_HEIGHT = 20;
        private final JPanel panel;
        private final SpringLayout layout;
        private int top = 0;
        private Worker(JPanel panel, SpringLayout layout) {
            this.panel = panel;
            this.layout = layout;
        }
        @Override
        protected void done() {
            List<OptionInfo> list;
            try {
                list = get();
            } catch (InterruptedException | ExecutionException e) {
                throw new RuntimeException("Future falsely marked as done", e);
            }
            List<JComponent> fields = new ArrayList<>();
            int labelWidth = 0;
            for (OptionInfo info : list) {
                if (BASIC_OPTIONS.contains(info.getName())) {
                    continue;
                }
                final var label = new JLabel(info.getName());
                final var field = newField(info);
                label.setToolTipText(info.getDescription());
                panel.add(label);
                labelWidth = Math.max(labelWidth, label.getMinimumSize().width);
                panel.add(field);
                fields.add(field);
                layout.putConstraint(SpringLayout.WEST, label, 0, SpringLayout.WEST, panel);
                layout.putConstraint(SpringLayout.NORTH, label, top, SpringLayout.NORTH, panel);
                layout.putConstraint(SpringLayout.EAST, field, 0, SpringLayout.EAST, panel);
                layout.putConstraint(SpringLayout.NORTH, field, top, SpringLayout.NORTH, panel);
                layout.putConstraint(SpringLayout.WEST, field, Spring.constant(0, 5, 400), SpringLayout.EAST, label);
                top += LINE_HEIGHT;
            }
            //Layout the second column.
            for (JComponent field : fields) {
                layout.putConstraint(SpringLayout.WEST, field, labelWidth, SpringLayout.WEST, panel);
            }
            panel.setPreferredSize(new Dimension(panel.getParent().getSize().width, top));
            panel.revalidate();
            panel.repaint();
            extraOptionsDialog.pack();
        }
        @Override
        protected List<OptionInfo> doInBackground() {
            return OptionInfo.stream().sorted().toList();
        }
    }
}