package com.dat3m.ui.options;

import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.wmm.utils.alias.Alias;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.dat3m.ui.button.ClearButton;
import com.dat3m.ui.button.TestButton;
import com.dat3m.ui.icon.IconCode;
import com.dat3m.ui.icon.IconHelper;
import com.dat3m.ui.options.utils.ControlCode;
import com.dat3m.ui.options.utils.Method;
import com.dat3m.ui.utils.UiOptions;

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
	
    private final JLabel iconPane;

    private final Selector<Alias> aliasPane;
    private final Selector<Method> methodPane;

    private final Selector<Arch> targetPane;

    private final BoundField boundField;
    private final TimeoutField timeoutField;

    private final JButton testButton;
    private final JButton clearButton;

    private final JTextPane consolePane;

    public OptionsPane(){
        super(new GridLayout(1,0));

        int height = Math.min(getIconHeight(), (int) Math.round(Toolkit.getDefaultToolkit().getScreenSize().getHeight()) * 7 / 18);
        iconPane = new JLabel(IconHelper.getIcon(IconCode.DARTAGNAN, height), JLabel.CENTER);

        aliasPane = new Selector<>(EnumSet.allOf(Alias.class).toArray(new Alias[0]), ControlCode.ALIAS);
        methodPane = new Selector<>(EnumSet.allOf(Method.class).toArray(new Method[0]), ControlCode.METHOD);

        Arch[] architectures = EnumSet.allOf(Arch.class).toArray(new Arch[0]);
        targetPane = new Selector<>(architectures, ControlCode.TARGET);

        boundField = new BoundField();
        timeoutField = new TimeoutField();

        testButton = new TestButton();
        clearButton = new ClearButton();

        consolePane = new JTextPane();
        consolePane.setEditable(false);

        bindListeners();
        mkGrid();
    }

    private void bindListeners(){
		// optionsPane needs to listen to options to clean the console
		// Alias and Mode do not change the result and thus we don't listen to them 
		targetPane.addActionListener(this);
		boundField.addActionListener(this);
		timeoutField.addActionListener(this);
		clearButton.addActionListener(this);
    }

    public JButton getTestButton(){
        return testButton;
    }

    public JTextPane getConsolePane(){
        return consolePane;
    }

    public UiOptions getOptions(){
        Settings settings = new Settings(
                (Alias)aliasPane.getSelectedItem(),
                Integer.parseInt(boundField.getText()),
                Integer.parseInt(timeoutField.getText())
        );

        Arch target = (Arch)targetPane.getSelectedItem();
        Method method = (Method)methodPane.getSelectedItem();
        return new UiOptions(target, method, settings);
    }

    private int getIconHeight(){
        return min(500, (int) round((Toolkit.getDefaultToolkit().getScreenSize().getHeight() / 2)));
    }

    private void mkGrid(){

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

        // Inner borders
        Border emptyBorder = BorderFactory.createEmptyBorder();

        JSplitPane graphPane = new JSplitPane(JSplitPane.HORIZONTAL_SPLIT);
        graphPane.setDividerSize(0);
        JComponent[] panes = { targetPane, aliasPane, methodPane, boundsPane, testButton, clearButton, graphPane, scrollConsole };
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
		// Any change in the (relevant) options clears the console
		getConsolePane().setText("");
	}
}
