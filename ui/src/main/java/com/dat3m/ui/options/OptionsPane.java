package com.dat3m.ui.options;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Method;
import com.dat3m.dartagnan.configuration.Property;
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
import java.awt.event.ActionListener;
import java.util.Arrays;
import java.util.EnumSet;
import java.util.Iterator;

import static com.dat3m.ui.options.utils.Helper.solversOrderedValues;
import static java.awt.FlowLayout.LEFT;
import static javax.swing.BorderFactory.createTitledBorder;
import static javax.swing.border.TitledBorder.CENTER;

public class OptionsPane extends JPanel implements ActionListener {

    public final static int OPTWIDTH = 300;

    private final JLabel iconPane;

    private final Selector<Method> methodPane;
    private final Selector<Solvers> solverPane;
    private final Selector<Property> propertyPane;

    private final Selector<Arch> targetPane;

    private final BoundField boundField;
    private final TimeoutField timeoutField;

    private final JTextField cflagsField;
    private final JTextField configField;

    private final JButton testButton;
    private final JButton clearButton;

    private final JRadioButton showViolationField;

    private final JTextPane consolePane;

    public OptionsPane() {
        super(new GridLayout(1, 0));

        iconPane = new JLabel();

        methodPane = new Selector<>(Method.orderedValues(), ControlCode.METHOD);
        methodPane.setSelectedItem(Method.getDefault());

        solverPane = new Selector<>(solversOrderedValues(), ControlCode.SOLVER);
        solverPane.setSelectedItem(Solvers.Z3);

        propertyPane = new Selector<>(Property.orderedValues(), ControlCode.PROPERTY);
        solverPane.setSelectedItem(Property.PROGRAM_SPEC);

        targetPane = new Selector<>(Arch.orderedValues(), ControlCode.TARGET);
        targetPane.setSelectedItem(Arch.getDefault());

        boundField = new BoundField();
        timeoutField = new TimeoutField();
        showViolationField = new JRadioButton();

        cflagsField = new JTextField();
        cflagsField.setColumns(20);

        configField = new JTextField();
        configField.setColumns(20);

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
        targetPane.addActionListener(this);
        boundField.addActionListener(this);
        timeoutField.addActionListener(this);
        clearButton.addActionListener(this);
        propertyPane.addActionListener(this);
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
        String config = configField.getText().strip();
        Arch target = (Arch) targetPane.getSelectedItem();
        Method method = (Method) methodPane.getSelectedItem();
        Solvers solver = (Solvers) solverPane.getSelectedItem();
        EnumSet<Property> properties = EnumSet.of((Property) propertyPane.getSelectedItem());
        return new UiOptions(target, method, bound, solver, timeout, showViolationGraph, cflags, config, properties);
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
        configPane.add(configField);

        JPanel showViolationPane = new JPanel(new FlowLayout(LEFT));
        showViolationPane.add(new JLabel("Show witness graph"));
        showViolationPane.add(showViolationField);

        // Inner borders
        Border emptyBorder = BorderFactory.createEmptyBorder();

        JSplitPane graphPane = new JSplitPane(JSplitPane.HORIZONTAL_SPLIT);
        graphPane.setDividerSize(0);
        JComponent[] panes = { targetPane, methodPane, solverPane, propertyPane, boundsPane, showViolationPane, configPane,
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

    @Override
    public void actionPerformed(ActionEvent e) {
        // Any change in the (relevant) options clears the console
        getConsolePane().setText("");
    }
}