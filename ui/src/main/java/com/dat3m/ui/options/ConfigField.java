package com.dat3m.ui.options;

import com.dat3m.dartagnan.configuration.OptionInfo;
import com.dat3m.ui.utils.UiOptions;

import javax.swing.*;
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
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.concurrent.ExecutionException;

import static com.dat3m.ui.utils.Utils.showError;

final class ConfigField extends JPanel {

    final JTextField textField;
    JDialog dialog;
    final Map<String, String> map = new LinkedHashMap<>();
    final JFileChooser fileChooser = new JFileChooser();

    public ConfigField() {
        setLayout(new BoxLayout(this, BoxLayout.X_AXIS));
        textField = new JTextField();
        add(textField);
        var button = new JButton("...");
        button.setToolTipText("Manage extra options.");
        add(button);
        button.addActionListener(this::handleShowButton);
        textField.addFocusListener(new FocusAdapter() {
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

    public Map<String, String> getConfiguration() {
        return Collections.unmodifiableMap(map);
    }

    private void fromText() {
        map.clear();
        for (String c : textField.getText().split(" ")) {
            int separator = c.indexOf('=');
            if (separator != -1 && c.startsWith("--")) {
                map.put(c.substring(2, separator), c.substring(separator + 1));
            }
        }
    }

    private void toText() {
        final var b = new StringBuilder();
        boolean init = false;
        for (Map.Entry<String, String> entry : map.entrySet()) {
            b.append(init ? " --" : "--").append(entry.getKey()).append('=').append(entry.getValue());
            init = true;
        }
        textField.setText(b.toString());
    }

    private void handleShowButton(ActionEvent e) {
        if (dialog == null) {
            dialog = newDialog();
        }
        dialog.setVisible(true);
        dialog.setLocationRelativeTo(this);
        dialog.requestFocus();
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
        importButton.addActionListener(this::handleImportButton);
        panel.add(importButton);
        final var exportButton = new JButton("Export");
        exportButton.setToolTipText("Save the current configuration to a file");
        exportButton.addActionListener(this::handleExportButton);
        panel.add(exportButton);
        final var okButton = new JButton("OK");
        okButton.addActionListener(event -> dialog.setVisible(false));
        panel.add(okButton);
        return panel;
    }

    private void handleExportButton(ActionEvent ignoreEvent) {
        fileChooser.showSaveDialog(this);
        final File file = fileChooser.getSelectedFile();
        if (file == null) {
            return;
        }
        Properties properties = new Properties();
        properties.putAll(map);
        try (FileWriter writer = new FileWriter(file)) {
            properties.store(writer, "Created with Dartagnan");
        } catch (IOException e) {
            showError(e.getMessage(), "Error while exporting configuration");
        }
    }

    private void handleImportButton(ActionEvent ignoreEvent) {
        fileChooser.showOpenDialog(this);
        final File file = fileChooser.getSelectedFile();
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
        map.clear();
        for (Map.Entry<Object, Object> entry : properties.entrySet()) {
            map.put(entry.getKey().toString(), entry.getValue().toString());
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
                if (UiOptions.BASIC_OPTIONS.contains(info.getName())) {
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
            dialog.pack();
            System.out.printf("%dx%d%n", panel.getSize().width, panel.getSize().height);
        }
        @Override
        protected List<OptionInfo> doInBackground() {
            return OptionInfo.stream().sorted().toList();
        }
    }

    private JComponent newField(OptionInfo info) {
        if (boolean.class.equals(info.getDomain())) {
            final var field = new JCheckBox();
            field.addItemListener(event -> {
                String value = switch (event.getStateChange()) {
                    case ItemEvent.SELECTED -> "true";
                    case ItemEvent.DESELECTED -> "false";
                    default -> "";
                };
                if (!value.isEmpty()) {
                    setOption(info.getName(), value);
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
            map.remove(key);
        } else {
            map.put(key, value);
        }
    }
}
