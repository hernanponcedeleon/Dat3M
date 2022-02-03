package com.dat3m.ui.options;

import com.dat3m.dartagnan.configuration.Method;
import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.OptionInfo;
import com.dat3m.ui.button.ClearButton;
import com.dat3m.ui.button.TestButton;
import com.dat3m.ui.options.utils.ControlCode;
import com.dat3m.ui.utils.UiOptions;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.ConfigurationBuilder;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.java_smt.SolverContextFactory.Solvers;

import javax.swing.*;
import javax.swing.border.Border;
import javax.swing.border.TitledBorder;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.ItemEvent;
import java.util.HashMap;
import java.util.Vector;

import static com.dat3m.dartagnan.configuration.OptionNames.*;
import static com.dat3m.ui.options.utils.Helper.solversOrderedValues;
import static java.lang.Math.min;
import static java.lang.Math.round;
import static javax.swing.BorderFactory.createTitledBorder;
import static javax.swing.border.TitledBorder.CENTER;

public class OptionsPane extends JPanel implements ActionListener {

	public final static int OPTWIDTH = 300;
	
    private final JLabel iconPane;

    private final Selector<Method> methodPane;
    private final Selector<Solvers> solverPane;
    
    private final Selector<Arch> targetPane;

    private final BoundField boundField;
    private final TimeoutField timeoutField;

    private final JButton testButton;
    private final JButton clearButton;

    private final JTextPane consolePane;

    private final Box genericPane = new Box(BoxLayout.PAGE_AXIS);
    private final HashMap<String,String[]> genericMap = new HashMap<>();

    public OptionsPane(){
        super(new GridLayout(1,0));

        iconPane = new JLabel();

        methodPane = new Selector<>(Method.orderedValues(), ControlCode.METHOD);
        methodPane.setSelectedItem(Method.getDefault());
        
        solverPane = new Selector<>(solversOrderedValues(), ControlCode.SOLVER);
        solverPane.setSelectedItem(Solvers.Z3);

        targetPane = new Selector<>(Arch.orderedValues(), ControlCode.TARGET);
        targetPane.setSelectedItem(Arch.getDefault());
        
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

    public UiOptions getOptions() throws InvalidConfigurationException {
        int bound = Integer.parseInt(boundField.getText());
        int timeout = Integer.parseInt(timeoutField.getText());
        Arch target = (Arch)targetPane.getSelectedItem();
        Method method = (Method)methodPane.getSelectedItem();
        Solvers solver = (Solvers)solverPane.getSelectedItem();
        ConfigurationBuilder config = Configuration.builder();
        genericMap.forEach((k,v)->config.setOption(k,v[0]));
        return new UiOptions(target, method, bound, solver, timeout, config.build());
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

        OptionInfo.stream().forEach(this::addGenericOption);

        JSplitPane graphPane = new JSplitPane(JSplitPane.HORIZONTAL_SPLIT);
        graphPane.setDividerSize(0);
        JScrollPane genericScrollPane = new JScrollPane(genericPane,
            ScrollPaneConstants.VERTICAL_SCROLLBAR_ALWAYS,
            ScrollPaneConstants.HORIZONTAL_SCROLLBAR_AS_NEEDED);
        genericScrollPane.setPreferredSize(new Dimension(0,200));
        JComponent[] panes = { genericScrollPane, targetPane, methodPane, solverPane, boundsPane, testButton, clearButton, graphPane, scrollConsole };
        JComponent current = iconPane;
        current.setBorder(emptyBorder);
        for(JComponent next : panes) {
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

    private void addGenericOption(OptionInfo info) {

        //non-generic options should not be treated as generic
        if(info.getName().equals(BOUND)
            || info.getName().equals(TIMEOUT)
            || info.getName().equals(TARGET)
            || info.getName().equals(METHOD)
            || info.getName().equals(SOLVER)) {
            return;
        }

        String name = info.getName();
        String[] value = new String[1];
        Class<?> domain = info.getDomain();
        JComponent component;
        if(domain.equals(boolean.class) || domain.equals(Boolean.class)) {
            JCheckBox check = new JCheckBox();
            check.addItemListener(e->value[0] = Boolean.toString(e.getStateChange()==ItemEvent.SELECTED));
            value[0] = Boolean.toString(false);
            component = check;
        } else {
            Vector<ClassName> vector = new Vector<>();
            info.getAvailableValues().map(ClassName::new).forEach(vector::add);
            if(vector.isEmpty()) {
                JTextField text = new JTextField();
                text.addActionListener(e->value[0] = text.getText());
                value[0] = "";
                component = text;
            } else {
                JComboBox<ClassName> combo = new JComboBox<>(vector);
                combo.addItemListener(e->value[0] = ((ClassName)e.getItem()).name);
                value[0] = vector.get(0).name;
                component = combo;
            }
        }
        component.setEnabled(false);

        Box pane = new Box(BoxLayout.LINE_AXIS);

        String[] split = name.split("\\.");
        JLabel label = new JLabel(split[split.length-1]);

        JCheckBox active = new JCheckBox();
        active.addItemListener(e->{
            boolean enable = e.getStateChange()==ItemEvent.SELECTED;
            component.setEnabled(enable);
            if(enable) {
                genericMap.put(name,value);
            } else {
                genericMap.remove(name);
            }
        });

        pane.add(active);
        pane.add(label);
        pane.add(Box.createHorizontalGlue());
        pane.add(component);
        genericPane.add(pane);
    }

    private static final class ClassName {
        final String name;
        ClassName(String n) {
            name = n;
        }
        @Override
        public String toString() {
            String[] split = name.split("\\.");
            return split[split.length-1];
        }
    }
}