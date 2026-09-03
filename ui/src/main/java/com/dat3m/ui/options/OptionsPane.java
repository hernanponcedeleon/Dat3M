package com.dat3m.ui.options;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Method;
import com.dat3m.dartagnan.configuration.OptionInfo;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.configuration.ProgressModel;
import com.dat3m.ui.button.ClearButton;
import com.dat3m.ui.button.CancelButton;
import com.dat3m.ui.button.TestButton;
import com.dat3m.ui.options.utils.ControlCode;
import com.dat3m.ui.utils.UiOptions;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.java_smt.SolverContextFactory.Solvers;

import javax.swing.*;
import javax.swing.border.TitledBorder;
import javax.swing.event.ChangeEvent;
import javax.swing.filechooser.FileNameExtensionFilter;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.FocusAdapter;
import java.awt.event.FocusEvent;
import java.awt.event.ItemEvent;
import java.awt.event.WindowEvent;
import java.awt.event.WindowFocusListener;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Date;
import java.util.EnumMap;
import java.util.EnumSet;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ExecutionException;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.configuration.OptionNames.*;
import static com.dat3m.ui.options.utils.Helper.solversOrderedValues;
import static com.dat3m.ui.utils.Utils.showError;
import static java.awt.FlowLayout.LEFT;
import static javax.swing.BorderFactory.createTitledBorder;
import static javax.swing.border.TitledBorder.CENTER;

public class OptionsPane extends JPanel {

    public final static int OPTWIDTH = 300;

    private static final List<String> BASIC_OPTIONS = List.of(TARGET, METHOD, BOUND, SOLVER, TIMEOUT, PROPERTY, PROGRESSMODEL);

    private final JLabel iconPane = new JLabel();

    private final Selector<Method> methodPane;
    private final Selector<Solvers> solverPane;
    private final JPanel propertiesPane = new JPanel();
    private final Map<Property, JCheckBox> propertyFields = new EnumMap<>(Property.class);
    private final Selector<ProgressModel> progressPane;

    private final Selector<Arch> targetPane;

    private final SpinnerNumberModel boundModel;
    private final JSpinner boundSpinner;

    private final JTextField cflagsField;

    private final JDialog extraOptionsDialog;
    private final Map<String, JComponent> extraOptionsComponents = new HashMap<>();
    private final Map<String, String> extraOptionsMap = new LinkedHashMap<>();
    private final JFileChooser configurationFileChooser = new JFileChooser();

    private final JButton extraOptionsButton;
    private final JButton testButton;
    private final JButton cancelButton;
    private final JButton clearButton;

    private final JCheckBox showViolationField;

    private final JTextPane consolePane;

    public OptionsPane() {
        super(new GridBagLayout());

        methodPane = new Selector<>(Method.class, Method.orderedValues(), ControlCode.METHOD);
        methodPane.setSelectedItem(Method.getDefault());

        solverPane = new Selector<>(Solvers.class, solversOrderedValues(), ControlCode.SOLVER);
        solverPane.setSelectedItem(Solvers.Z3);

        propertiesPane.setLayout(new BoxLayout(propertiesPane, BoxLayout.Y_AXIS));
        final JLabel propertiesLabel = new JLabel("Properties: ");
        propertiesLabel.setAlignmentX(Component.LEFT_ALIGNMENT);
        propertiesPane.add(propertiesLabel);
        for (Property property : Property.orderedValues()) {
            final JCheckBox propertyField = new JCheckBox(property.toString());
            propertyField.setSelected(Property.getDefault().contains(property));
            propertyField.setAlignmentX(Component.LEFT_ALIGNMENT);
            propertyFields.put(property, propertyField);
            propertiesPane.add(propertyField);
        }

        targetPane = new Selector<>(Arch.class, Arch.orderedValues(), ControlCode.TARGET);
        targetPane.setSelectedItem(Arch.getDefault());

        progressPane = new Selector<>(ProgressModel.class, ProgressModel.orderedValues(), ControlCode.PROGRESS);
        progressPane.setSelectedItem(ProgressModel.getDefault());

        boundModel = new SpinnerNumberModel(1, 1, Integer.MAX_VALUE, 1);
        boundSpinner = new JSpinner(boundModel);
        showViolationField = new JCheckBox();

        cflagsField = new JTextField();
        cflagsField.setColumns(20);

        extraOptionsButton = new JButton("...");
        extraOptionsButton.setToolTipText("Manage extra options.");
        extraOptionsDialog = newDialog();
        configurationFileChooser.addChoosableFileFilter(new FileNameExtensionFilter("*.properties", "properties"));

        testButton = new TestButton();
        cancelButton = new CancelButton();
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
        boundSpinner.addChangeListener(this::clearConsole);
        clearButton.addActionListener(this::clearConsole);
        propertyFields.values().forEach(propertyField -> propertyField.addActionListener(this::clearConsole));
        progressPane.addActionListener(this::clearConsole);
        extraOptionsButton.addActionListener(this::handleExtraOptionsButton);
    }

    public JButton getTestButton() {
        return testButton;
    }

    public JButton getCancelButton() {
        return cancelButton;
    }

    public JButton getClearButton() {
        return clearButton;
    }

    public JTextPane getConsolePane() {
        return consolePane;
    }

    public UiOptions getOptions() {
        int bound = boundModel.getNumber().intValue();
        boolean showViolationGraph = showViolationField.isSelected();
        String cflags = cflagsField.getText().strip();
        Arch target = targetPane.getSelectedItem();
        Method method = methodPane.getSelectedItem();
        Solvers solver = solverPane.getSelectedItem();
        EnumSet<Property> properties = getSelectedProperties();
        ProgressModel progress = progressPane.getSelectedItem();
        return new UiOptions(target, method, bound, solver, showViolationGraph, cflags, extraOptionsMap, properties, progress);
    }

    private void mkGrid() {

        JScrollPane scrollConsole = new JScrollPane(consolePane);
        scrollConsole.setPreferredSize(new Dimension(OPTWIDTH, 120));
        scrollConsole.setHorizontalScrollBarPolicy(JScrollPane.HORIZONTAL_SCROLLBAR_AS_NEEDED);

        JPanel boundPane = new JPanel(new FlowLayout(LEFT));
        boundPane.add(new JLabel("Unrolling: "));
        boundPane.add(boundSpinner);

        JPanel cflagsPane = new JPanel(new FlowLayout(LEFT));
        cflagsPane.add(new JLabel("CFLAGS: "));
        cflagsPane.add(cflagsField);

        JPanel configPane = new JPanel(new FlowLayout(LEFT));
        configPane.add(new JLabel("Extra options: "));
        configPane.add(extraOptionsButton);

        JPanel showViolationPane = new JPanel(new FlowLayout(LEFT));
        showViolationPane.add(new JLabel("Show witness graph"));
        showViolationPane.add(showViolationField);

        final List<JComponent> optionRows = List.of(
                iconPane, targetPane, methodPane, solverPane, propertiesPane, progressPane,
                boundPane, showViolationPane, configPane, cflagsPane, testButton, clearButton, cancelButton
        );
        final GridBagConstraints constraints = new GridBagConstraints();
        constraints.gridx = 0;
        constraints.weightx = 1;
        constraints.fill = GridBagConstraints.HORIZONTAL;
        constraints.anchor = GridBagConstraints.LINE_START;
        for (int row = 0; row < optionRows.size(); row++) {
            constraints.gridy = row;
            constraints.weighty = 0;
            add(optionRows.get(row), constraints);
        }

        constraints.gridy = optionRows.size();
        constraints.weighty = 1;
        constraints.fill = GridBagConstraints.BOTH;
        add(scrollConsole, constraints);

        // Outer border
        TitledBorder titledBorder = createTitledBorder("Options");
        titledBorder.setTitleJustification(CENTER);
        setBorder(titledBorder);
    }

    public void clearConsole(ActionEvent ignored) {
        clearConsole();
    }

    private void clearConsole(ChangeEvent ignored) {
        clearConsole();
    }

    private void clearConsole() {
        // Any change in the relevant options clears the console.
        consolePane.setText("");
    }

    private void handleExtraOptionsButton(ActionEvent e) {
        updateExtraOptionsFields();
        extraOptionsDialog.setVisible(true);
        extraOptionsDialog.setLocationRelativeTo(this);
        extraOptionsDialog.requestFocus();
    }

    private void doExport() {
        if (extraOptionsDialog.isVisible()) {
            extraOptionsDialog.setVisible(false);
        }
        configurationFileChooser.showSaveDialog(this);
        final var selectedFile = configurationFileChooser.getSelectedFile();
        if (selectedFile == null) {
            return;
        }
        final Path file = selectedFile.toPath();
        try {
            final Configuration properties = Configuration.builder()
                    .setOptions(extraOptionsMap)
                    .setOption(METHOD, methodPane.getSelectedItem().name())
                    .setOption(SOLVER, solverPane.getSelectedItem().name())
                    .setOption(PROPERTY, getSelectedProperties().stream()
                            .map(Property::asStringOption)
                            .collect(Collectors.joining(",")))
                    .setOption(TARGET, targetPane.getSelectedItem().name())
                    .setOption(PROGRESSMODEL, progressPane.getSelectedItem().name())
                    .setOption(BOUND, boundSpinner.getValue().toString())
                    .build();
            //NOTE the properties file format almost fits the format accepted by Configuration.loadCharSource.
            //But comments missing a whitespace after '#' are treated as directives.
            try (var writer = Files.newBufferedWriter(file)) {
                writer.append("# Created with Dartagnan\n# ")
                        .append(new Date().toString())
                        .append('\n')
                        .append(properties.asPropertiesString());
            }
        } catch (IOException | InvalidConfigurationException e) {
            showError(e.getMessage(), "Error while exporting configuration");
        }
    }

    private void doImport() {
        if (extraOptionsDialog.isVisible()) {
            extraOptionsDialog.setVisible(false);
        }
        configurationFileChooser.showOpenDialog(this);
        final var selectedFile = configurationFileChooser.getSelectedFile();
        if (selectedFile == null) {
            return;
        }
        final Path file = selectedFile.toPath();
        final var properties = new HashMap<String, String>();
        try {
            final Configuration config = Configuration.builder().loadFromFile(file).build();
            for (String key : List.copyOf(config.getUnusedProperties())) {
                properties.put(key, config.getProperty(key));
            }
        } catch (IOException | InvalidConfigurationException e) {
            showError(e.getMessage(), "Error while importing configuration");
            return;
        }
        setMethod(properties.remove(METHOD));
        setSolver(properties.remove(SOLVER));
        setProperties(properties.remove(PROPERTY));
        setTargetArch(properties.remove(TARGET));
        setProgressModel(properties.remove(PROGRESSMODEL));
        setBound(properties.remove(BOUND));
        properties.remove(TIMEOUT);
        extraOptionsMap.clear();
        extraOptionsMap.putAll(properties);
    }

    private void setMethod(String value) {
        if (value == null) {
            return;
        }
        try {
            methodPane.setSelectedItem(Method.valueOf(value.toUpperCase()));
        } catch (IllegalArgumentException ignore) {
        }
    }

    private void setSolver(String value) {
        if (value == null) {
            return;
        }
        try {
            solverPane.setSelectedItem(Solvers.valueOf(value.toUpperCase()));
        } catch (IllegalArgumentException ignore) {
        }
    }

    private EnumSet<Property> getSelectedProperties() {
        final EnumSet<Property> properties = EnumSet.noneOf(Property.class);
        for (Map.Entry<Property, JCheckBox> entry : propertyFields.entrySet()) {
            if (entry.getValue().isSelected()) {
                properties.add(entry.getKey());
            }
        }
        return properties;
    }

    private void setProperties(String value) {
        if (value == null) {
            return;
        }
        final EnumSet<Property> properties = EnumSet.noneOf(Property.class);
        for (String property : value.split(",")) {
            try {
                properties.add(Property.valueOf(property.strip().toUpperCase()));
            } catch (IllegalArgumentException ignore) {
            }
        }
        for (Map.Entry<Property, JCheckBox> entry : propertyFields.entrySet()) {
            entry.getValue().setSelected(properties.contains(entry.getKey()));
        }
    }

    private void setTargetArch(String value) {
        if (value == null) {
            return;
        }
        try {
            targetPane.setSelectedItem(Arch.valueOf(value.toUpperCase()));
        } catch (IllegalArgumentException ignore) {
        }
    }

    private void setProgressModel(String value) {
        if (value == null) {
            return;
        }
        try {
            progressPane.setSelectedItem(ProgressModel.valueOf(value.toUpperCase()));
        } catch (IllegalArgumentException ignore) {
        }
    }

    private void setBound(String value) {
        setSpinnerValue(boundSpinner, value);
    }

    private static void setSpinnerValue(JSpinner spinner, String value) {
        if (value == null) {
            return;
        }
        try {
            spinner.setValue(Integer.parseInt(value));
        } catch (IllegalArgumentException ignore) {
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

    private void updateExtraOptionsFields() {
        for (Map.Entry<String, JComponent> entry : extraOptionsComponents.entrySet()) {
            String value = extraOptionsMap.get(entry.getKey());
            if (entry.getValue() instanceof JCheckBox field) {
                field.setSelected("true".equalsIgnoreCase(value));
            } else if (entry.getValue() instanceof JComboBox<?> field) {
                field.setSelectedItem("");
                field.setSelectedItem(value == null ? "" : value.toUpperCase());
            } else if (entry.getValue() instanceof JTextField field) {
                field.setText(value == null ? "" : value);
            }
        }
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
                extraOptionsComponents.put(info.getName(), field);
                layout.putConstraint(SpringLayout.WEST, label, 0, SpringLayout.WEST, panel);
                layout.putConstraint(SpringLayout.NORTH, label, top, SpringLayout.NORTH, panel);
                layout.putConstraint(SpringLayout.EAST, field, 0, SpringLayout.EAST, panel);
                layout.putConstraint(SpringLayout.NORTH, field, top, SpringLayout.NORTH, panel);
                layout.putConstraint(SpringLayout.WEST, field, Spring.constant(0, 5, 400), SpringLayout.EAST, label);
                top += LINE_HEIGHT;
            }
            //Layout the second column.
            for (JComponent field : extraOptionsComponents.values()) {
                layout.putConstraint(SpringLayout.WEST, field, labelWidth, SpringLayout.WEST, panel);
            }
            panel.setPreferredSize(new Dimension(labelWidth + 20, top));
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
