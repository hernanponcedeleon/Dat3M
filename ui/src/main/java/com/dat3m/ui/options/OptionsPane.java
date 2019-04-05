package com.dat3m.ui.options;

import com.dat3m.dartagnan.wmm.utils.alias.Alias;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.dat3m.dartagnan.wmm.utils.Mode;
import com.dat3m.ui.button.ClearButton;
import com.dat3m.ui.button.GraphButton;
import com.dat3m.ui.button.TestButton;
import com.dat3m.ui.icon.IconCode;
import com.dat3m.ui.options.utils.ArchManager;
import com.dat3m.ui.options.utils.ControlCode;
import com.dat3m.ui.utils.Task;

import javax.swing.*;
import javax.swing.border.Border;
import javax.swing.border.TitledBorder;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.Arrays;
import java.util.EnumSet;
import java.util.Iterator;

import static java.lang.Math.min;
import static java.lang.Math.round;
import static javax.swing.BorderFactory.createTitledBorder;
import static javax.swing.border.TitledBorder.CENTER;

public class OptionsPane extends JPanel implements ActionListener {

	public final static int OPTWIDTH = 300;
	
    private final IconPane iconPane;

    private final Selector<Task> taskPane;
    private final Selector<Mode> modePane;
    private final Selector<Alias> aliasPane;

    private final ArchManager archManager;
    private final Selector<Arch> sourcePane;
    private final Selector<Arch> targetPane;

    private final BoundField boundField;

    private final JButton testButton;
    private final JButton clearButton;
    private final JButton graphButton;

    private final JTextPane consolePane;

    public OptionsPane(){
        super(new GridLayout(1,0));

        iconPane = new IconPane(IconCode.DARTAGNAN, getIconHeight(), JLabel.CENTER);

        taskPane = new Selector<Task>(EnumSet.allOf(Task.class).toArray(new Task[0]), ControlCode.TASK);
        modePane = new Selector<Mode>(EnumSet.allOf(Mode.class).toArray(new Mode[0]), ControlCode.MODE);
        aliasPane = new Selector<Alias>(EnumSet.allOf(Alias.class).toArray(new Alias[0]), ControlCode.ALIAS);

        Arch[] architectures = EnumSet.allOf(Arch.class).toArray(new Arch[0]);
        sourcePane = new Selector<Arch>(architectures, ControlCode.SOURCE);
        sourcePane.setEnabled(false);
        targetPane = new Selector<Arch>(architectures, ControlCode.TARGET);
        archManager = new ArchManager(sourcePane, targetPane);

        boundField = new BoundField();

        testButton = new TestButton();
        clearButton = new ClearButton();
        graphButton = new GraphButton();

        consolePane = new JTextPane();
        consolePane.setEditable(false);

        bindListeners();
        mkGrid();
    }

    private void bindListeners(){
        taskPane.addActionListener(archManager);
        taskPane.addActionListener(iconPane);
		// optionsPane needs to listen to options to clean the console
		// Alias and Mode do not change the result and thus we don't listen to them 
        taskPane.addActionListener(this);
		targetPane.addActionListener(this);
		sourcePane.addActionListener(this);
		boundField.addActionListener(this);
		clearButton.addActionListener(this);
    }

    public Selector<Task> getTaskPane(){
        return taskPane;
    }

    public Selector<Arch> getTargetPane(){
        return targetPane;
    }

    public Selector<Arch> getSourcePane(){
        return sourcePane;
    }

    public ArchManager getArchManager(){
        return archManager;
    }

    public BoundField getBoundPane(){
        return boundField;
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
                Integer.parseInt(boundField.getText())
        );
    }

    private int getIconHeight(){
        return min(500, (int) round((Toolkit.getDefaultToolkit().getScreenSize().getHeight() / 2)));
    }

    private void mkGrid(){

        JScrollPane scrollConsole = new JScrollPane(consolePane);
        scrollConsole.setMaximumSize(new Dimension(OPTWIDTH, 120));
        scrollConsole.setHorizontalScrollBarPolicy(JScrollPane.HORIZONTAL_SCROLLBAR_AS_NEEDED);

        JPanel boundPane = new BoundPane();
        boundPane.add(boundField);

        JSplitPane archPane = new JSplitPane(JSplitPane.HORIZONTAL_SPLIT);
        archPane.setLeftComponent(sourcePane);
        archPane.setRightComponent(targetPane);
        archPane.setPreferredSize(new Dimension(OPTWIDTH, 0));
        archPane.setDividerSize(0);

        // Inner borders
        Border emptyBorder = BorderFactory.createEmptyBorder();

        JComponent[] panes = { taskPane, archPane, modePane, aliasPane, boundPane, testButton, clearButton, graphButton, scrollConsole };
        Iterator<JComponent> it = Arrays.asList(panes).iterator();
        JComponent current = iconPane;
        current.setBorder(emptyBorder);
        while(it.hasNext()) {
        	JComponent next = it.next();
        	current = new JSplitPane(JSplitPane.VERTICAL_SPLIT, current, next);
        	((JSplitPane)current).setDividerSize(2);
        	current.setBorder(emptyBorder);
        	if(!(next instanceof JButton)) {
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
		// Any change in the (relevant) options clears the console and disable graph button
		getConsolePane().setText("");
		graphButton.setEnabled(false);
	}
}
