package com.dat3m.ui.options;

import com.dat3m.dartagnan.program.utils.Alias;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.dat3m.dartagnan.wmm.utils.Mode;
import com.dat3m.ui.icon.IconCode;
import com.dat3m.ui.options.utils.ArchManager;
import com.dat3m.ui.options.utils.ControlCode;
import com.dat3m.ui.utils.Task;

import javax.swing.*;
import javax.swing.border.Border;
import javax.swing.border.TitledBorder;
import java.awt.*;
import java.util.EnumSet;

import static java.awt.FlowLayout.LEFT;
import static javax.swing.BorderFactory.createTitledBorder;
import static javax.swing.border.TitledBorder.CENTER;

public class OptionsPane extends JPanel {

    private final IconPane iconPane;

    private final Selector<Task> taskPane;
    private final Selector<Mode> modePane;
    private final Selector<Alias> aliasPane;

    private final Selector<Arch> sourcePane;
    private final Selector<Arch> targetPane;

    private final JTextField boundField;

    private final JButton testButton;
    private final JButton clearButton;
    private final JButton graphButton;

    private final JTextPane consolePane;

    private final ArchManager archManager;


    public OptionsPane(){
        super(new GridLayout(1,0));

        iconPane = new IconPane(IconCode.DARTAGNAN, getIconHeight(), JLabel.CENTER);

        taskPane = new Selector<Task>(EnumSet.allOf(Task.class).toArray(new Task[0]), ControlCode.TASK);
        modePane = new Selector<Mode>(EnumSet.allOf(Mode.class).toArray(new Mode[0]), ControlCode.MODE);
        aliasPane = new Selector<Alias>(EnumSet.allOf(Alias.class).toArray(new Alias[0]), ControlCode.ALIAS);

        Arch[] architectures = EnumSet.allOf(Arch.class).toArray(new Arch[0]);
        sourcePane = new Selector<Arch>(architectures, ControlCode.SOURCE);
        targetPane = new Selector<Arch>(architectures, ControlCode.TARGET);
        sourcePane.setEnabled(false);
        archManager = new ArchManager(sourcePane, targetPane);

        // TODO: New class with a field which forbids illegal values
        boundField = new JTextField("1", 3);
        boundField.setActionCommand(ControlCode.BOUND.actionCommand());

        testButton = new JButton("Test");
        testButton.setActionCommand(ControlCode.TEST.actionCommand());

        clearButton = new JButton("Clear");
        clearButton.setActionCommand(ControlCode.CLEAR.actionCommand());

        graphButton = new JButton("Execution Witness");
        graphButton.setActionCommand(ControlCode.GRAPH.actionCommand());
        graphButton.setEnabled(false);

        consolePane = new JTextPane();
        consolePane.setEditable(false);

        bindListeners();
        mkGrid();
    }

    private void bindListeners(){
        taskPane.addActionListener(archManager);
        taskPane.addActionListener(iconPane);
    }

    public Selector<Task> getTaskPane(){
        return taskPane;
    }

    public ArchManager getArchManager(){
        return archManager;
    }

    public JButton getTestButton(){
        return testButton;
    }

    public JButton getClearButton(){
        return clearButton;
    }

    public JButton getGraphButton(){
        return graphButton;
    }

    public JTextPane getConsolePane(){
        return consolePane;
    }

    public Options getOptions(){
        return new Options(
                (Task)taskPane.getSelectedItem(),
                (Arch)targetPane.getSelectedItem(),
                (Arch)sourcePane.getSelectedItem(),
                (Mode)modePane.getSelectedItem(),
                (Alias)aliasPane.getSelectedItem(),
                // TODO: Handle possible exceptions in the new boundField class
                Integer.parseInt(boundField.getText())
        );
    }

    // TODO: Implementation
    private int getIconHeight(){
        return 300;
    }

    // TODO: Refactoring
    private void mkGrid(){
        int width = 300;

        // Dimensions
        testButton.setMaximumSize(new Dimension(width, 50));
        clearButton.setMaximumSize(new Dimension(width, 50));
        graphButton.setMaximumSize(new Dimension(width, 50));

        JScrollPane scrollConsole = new JScrollPane(consolePane);
        scrollConsole.setMaximumSize(new Dimension(width, 120));
        scrollConsole.setHorizontalScrollBarPolicy(JScrollPane.HORIZONTAL_SCROLLBAR_AS_NEEDED);

        JLabel uLabel = new JLabel("Unrolling Bound: ");
        JPanel boundPane = new JPanel(new FlowLayout(LEFT));
        boundPane.add(uLabel);
        boundPane.add(boundField);

        JSplitPane archPane = new JSplitPane(JSplitPane.HORIZONTAL_SPLIT);
        archPane.setLeftComponent(sourcePane);
        archPane.setRightComponent(targetPane);
        archPane.setPreferredSize(new Dimension(300, 0));
        archPane.setDividerSize(0);

        //Put the options in a split pane.
        JSplitPane sp0 = new JSplitPane(JSplitPane.VERTICAL_SPLIT, iconPane, taskPane);
        sp0.setDividerSize(2);
        JSplitPane sp1 = new JSplitPane(JSplitPane.VERTICAL_SPLIT, sp0, archPane);
        sp1.setDividerSize(2);
        JSplitPane sp2 = new JSplitPane(JSplitPane.VERTICAL_SPLIT, sp1, modePane);
        sp2.setDividerSize(2);
        JSplitPane sp3 = new JSplitPane(JSplitPane.VERTICAL_SPLIT, sp2, aliasPane);
        sp3.setDividerSize(2);
        JSplitPane sp4 = new JSplitPane(JSplitPane.VERTICAL_SPLIT, sp3, boundPane);
        sp4.setDividerSize(2);
        JSplitPane sp5 = new JSplitPane(JSplitPane.VERTICAL_SPLIT, sp4, testButton);
        sp5.setDividerSize(2);
        JSplitPane sp6 = new JSplitPane(JSplitPane.VERTICAL_SPLIT, sp5, clearButton);
        sp6.setDividerSize(2);
        JSplitPane sp7 = new JSplitPane(JSplitPane.VERTICAL_SPLIT, sp6, graphButton);
        sp7.setDividerSize(2);
        JSplitPane sp8 = new JSplitPane(JSplitPane.VERTICAL_SPLIT, sp7, scrollConsole);
        sp8.setDividerSize(2);
        add(sp8);

        // Inner borders
        Border emptyBorder = BorderFactory.createEmptyBorder();

        iconPane.setBorder(emptyBorder);
        taskPane.setBorder(emptyBorder);
        modePane.setBorder(emptyBorder);
        aliasPane.setBorder(emptyBorder);
        archPane.setBorder(emptyBorder);
        sourcePane.setBorder(emptyBorder);
        taskPane.setBorder(emptyBorder);

        sp0.setBorder(emptyBorder);
        sp1.setBorder(emptyBorder);
        sp2.setBorder(emptyBorder);
        sp3.setBorder(emptyBorder);
        sp4.setBorder(emptyBorder);
        sp5.setBorder(emptyBorder);
        sp6.setBorder(emptyBorder);
        sp7.setBorder(emptyBorder);
        sp8.setBorder(emptyBorder);

        // Outer border
        TitledBorder titledBorder = createTitledBorder("Options");
        titledBorder.setTitleJustification(CENTER);
        setBorder(titledBorder);
    }
}
