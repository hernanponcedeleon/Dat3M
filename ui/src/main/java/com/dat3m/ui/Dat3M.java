package com.dat3m.ui;

import com.dat3m.dartagnan.Dartagnan;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.utils.Alias;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.dat3m.dartagnan.wmm.utils.Mode;
import com.dat3m.porthos.Porthos;
import com.dat3m.porthos.PorthosResult;
import com.dat3m.ui.editor.Editor;
import com.dat3m.ui.editor.EditorCode;
import com.dat3m.ui.icon.IconCode;
import com.dat3m.ui.icon.IconHelper;
import com.dat3m.ui.option.GraphOption;
import com.dat3m.ui.option.Option;
import com.dat3m.ui.utils.*;
import com.microsoft.z3.Context;
import com.microsoft.z3.Solver;

import javax.swing.*;
import javax.swing.border.TitledBorder;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import static java.awt.FlowLayout.LEFT;
import static java.awt.FlowLayout.RIGHT;
import static javax.swing.BorderFactory.createEmptyBorder;
import static javax.swing.BorderFactory.createTitledBorder;
import static javax.swing.JOptionPane.INFORMATION_MESSAGE;
import static javax.swing.JOptionPane.showMessageDialog;
import static javax.swing.SwingUtilities.invokeLater;
import static javax.swing.UIManager.getDefaults;
import static javax.swing.border.TitledBorder.CENTER;

public class Dat3M extends JFrame implements ActionListener {

	// All these panes are fields since they need to be updated by the listener
	// TODO: Height must come from the pane with controls
	private JLabel iconPane = new JLabel(IconHelper.getIcon(IconCode.DARTAGNAN, 300), JLabel.CENTER);

	// Options pane
	private JTextPane consolePane;
	private JTextField boundField;
	private JPanel sArchPane;
	private JPanel tArchPane;
	private JButton graphButton;
	private Option opt = new Option(Task.REACHABILITY, Arch.NONE, Arch.NONE, Mode.KNASTER, Alias.CFS, 1);

	// Execution witness
	private GraphOption graph = new GraphOption();

	private Editor editor;

	private Dat3M() {
		// Necessary to avoid horrible layout on splitPane
		getDefaults().put("SplitPane.border", createEmptyBorder());

		setTitle("Dat3M");
		setExtendedState(JFrame.MAXIMIZED_BOTH);
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setLayout(new BorderLayout());
		setIconImage(IconHelper.getIcon(IconCode.DAT3M).getImage());

		editor = new Editor();
		setJMenuBar(editor.getMenuBar());

		int width = Utils.getMainScreenWidth();
		Task[] tasks = { Task.REACHABILITY, Task.PORTABILITY };
		JPanel taskPane = new Selector(tasks, "Task", this);

		Arch[] archs = { Arch.NONE, Arch.TSO, Arch.POWER, Arch.ARM, Arch.ARM8 };
		tArchPane = new Selector(archs, "Target", this);
		sArchPane = new Selector(archs, "Source", this);
		sArchPane.setLayout(new FlowLayout(RIGHT));
		JSplitPane archPane = new JSplitPane(JSplitPane.HORIZONTAL_SPLIT);
		archPane.setLeftComponent(tArchPane);
		archPane.setRightComponent(sArchPane);
		sArchPane.setEnabled(false);
		archPane.setPreferredSize(new Dimension(300, 0));
		archPane.setDividerSize(0);

		Mode[] modes = { Mode.KNASTER, Mode.IDL, Mode.KLEENE };
		JPanel modePane = new Selector(modes, "Mode", this);

		Alias[] aliases = { Alias.NONE, Alias.CFIS, Alias.CFS };
		JPanel aliasPane = new Selector(aliases, "Alias", this);

		// Console.
		consolePane = new JTextPane();
		consolePane.setEditable(false);
		JScrollPane scrollConsole = new JScrollPane(consolePane);
		scrollConsole.setMinimumSize(new Dimension(0, 120));
		scrollConsole.setHorizontalScrollBarPolicy(JScrollPane.HORIZONTAL_SCROLLBAR_AS_NEEDED);

		// Graph button.
		graphButton = new JButton("Execution Witness");
		graphButton.setMaximumSize(new Dimension(width, 50));
		graphButton.addActionListener(this);
		graphButton.setEnabled(false);


		// Bound editor
		boundField = new JTextField(3);
		boundField.setText("1");
		boundField.setActionCommand("Bound");
		boundField.addActionListener(this);
		boundField.addKeyListener(new BoundListener(consolePane, graphButton, boundField, opt));
		JLabel uLabel = new JLabel("Unrolling Bound: ");
		JPanel boundPane = new JPanel(new FlowLayout(LEFT));
		boundPane.add(uLabel);
		boundPane.add(boundField);

		// Test button.
		JButton testButton = new JButton("Test");
		testButton.setMaximumSize(new Dimension(width, 50));
		testButton.addActionListener(this);

		// Clear button.
		JButton clearButton = new JButton("Clear");
		clearButton.setMaximumSize(new Dimension(width, 50));
		clearButton.addActionListener(this);

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

		JPanel optionsPane = new JPanel(new GridLayout(1,0));
		TitledBorder titledBorder = createTitledBorder("Options");
		titledBorder.setTitleJustification(CENTER);
		optionsPane.add(sp8);
		optionsPane.setBorder(titledBorder);
		//optionsPane.setMaximumSize(new Dimension(dartagnanIcon.getIconWidth(), 100));

		//Put the editors in a split pane.
		JSplitPane mainPane = new JSplitPane(JSplitPane.HORIZONTAL_SPLIT, optionsPane, editor.getMainPane());
		mainPane.setDividerSize(2);
		add(mainPane);

		//Display the window.
		pack();
	}

	public static void main(String[] args) {
		EventQueue.invokeLater(() -> {
			Dat3M app = new Dat3M();
			app.setVisible(true);
		});
	}

	@SuppressWarnings("unchecked")
	@Override
	public void actionPerformed(ActionEvent e) {

		// The console and graph button are cleared after any change except opening the witness
		if(!e.getActionCommand().equals("Execution Witness")) {
			graphButton.setEnabled(false);
			consolePane.setText("");
		}

		// The bound field cannot be empty
		if(boundField.getText().equals("")) {
			boundField.setText("1");
		}

		if(e.getActionCommand().equals("Task")) {
			Object source = e.getSource();
			if(source instanceof JComboBox<?>) {
				opt.setTask((Task) ((JComboBox<Task>)source).getSelectedItem());
				switch(opt.getTask()){
					case REACHABILITY:
						// Update image
						// TODO: Height must come from the pane with controls
						iconPane.setIcon(IconHelper.getIcon(IconCode.DARTAGNAN, 300));
						// Remove smmEditor
						editor.setShowSourceMM(false);
						break;
					case PORTABILITY:
						// Update image
						// TODO: Height must come from the pane with controls
						iconPane.setIcon(IconHelper.getIcon(IconCode.PORTHOS, 300));
						// Add smmEditor
						editor.setShowSourceMM(true);
						break;
				}
			}
		}

		if(e.getActionCommand().equals("Target")) {
			Object source = e.getSource();
			if(source instanceof JComboBox<?>) {
				opt.setTarget((Arch) ((JComboBox<Arch>)source).getSelectedItem());
			}
		}

		if(e.getActionCommand().equals("Source")) {
			Object source = e.getSource();
			if(source instanceof JComboBox<?>) {
				opt.setSource((Arch) ((JComboBox<Arch>)source).getSelectedItem());
			}
		}

		if(e.getActionCommand().equals("Mode")) {
			Object source = e.getSource();
			if(source instanceof JComboBox<?>) {
				opt.setMode((Mode) ((JComboBox<Mode>)source).getSelectedItem());
			}
		}

		if(e.getActionCommand().equals("Alias")) {
			Object source = e.getSource();
			if(source instanceof JComboBox<?>) {
				opt.setAlias((Alias) ((JComboBox<Alias>)source).getSelectedItem());
			}
		}

		if(e.getActionCommand().equals("Test")) {
			Program pSource = null;
			Program pTarget = null;
			Wmm smm = null;
			Wmm tmm = null;
			try {
				pTarget = Utils.parseProgramEditor(editor.getEditor(EditorCode.PROGRAM), editor.getLoadedFormat(EditorCode.PROGRAM));
			} catch (Exception exp) {
				showMessageDialog(null, "The program was not imported or cannot be parsed", "About", INFORMATION_MESSAGE, IconHelper.getIcon(IconCode.DAT3M));
				return;
			}
			try {
				tmm = Utils.parseMMEditor(editor.getEditor(EditorCode.TARGET_MM), opt.getTarget());
			} catch (Exception exp) {
				String dummy =  opt.getTask() == Task.REACHABILITY ? " " : " target ";
				showMessageDialog(null, "The" +  dummy + "memory model was not imported or cannot be parsed", "About", INFORMATION_MESSAGE, IconHelper.getIcon(IconCode.DAT3M));
				return;
			}
			if(opt.getTask() == Task.PORTABILITY) {
				if(!editor.getLoadedFormat(EditorCode.PROGRAM).equals("pts")) {
					showMessageDialog(null, "Porthos only supports *.pts format", "About", INFORMATION_MESSAGE, IconHelper.getIcon(IconCode.DAT3M));
					return;
				}
				try {
					pSource = Utils.parseProgramEditor(editor.getEditor(EditorCode.PROGRAM), editor.getLoadedFormat(EditorCode.PROGRAM));
				} catch (Exception exp) {
					showMessageDialog(null, "The program was not imported or cannot be parsed", "About", INFORMATION_MESSAGE, IconHelper.getIcon(IconCode.DAT3M));
					return;
				}
				try {
					smm = Utils.parseMMEditor(editor.getEditor(EditorCode.SOURCE_MM), opt.getSource());
				} catch (Exception exp) {
					showMessageDialog(null, "The source memory model was not imported or cannot be parsed", "About", INFORMATION_MESSAGE, IconHelper.getIcon(IconCode.DAT3M));
					return;
				}
			}

			Context ctx = new Context();
			Solver solver = ctx.mkSolver();
			Solver solver2 = ctx.mkSolver();

			String result = "";

			switch(opt.getTask()){
				case REACHABILITY:
					result = "Condition " + pTarget.getAss().toStringWithType() + "\n";
					Arch target = pTarget.getArch() == null ? opt.getTarget() : pTarget.getArch();
					boolean isSat = Dartagnan.testProgram(solver, ctx, pTarget, tmm, target, opt.getBound(), opt.getMode(), opt.getAlias());
					result += isSat ? "OK" : "No";
					if(Dartagnan.canDrawGraph(pTarget.getAss(), isSat)) {
						graphButton.setEnabled(true);
						graph.generate(solver, ctx, pTarget);
					} else {
						graphButton.setEnabled(false);
					}
					break;
				case PORTABILITY:
					PorthosResult res = Porthos.testProgram(solver, solver2, ctx, pSource, pTarget, opt.getSource(), opt.getTarget(), smm, tmm, opt.getBound(), opt.getMode(), opt.getAlias());
					String dummy = res.getIsPortable()? " " : " not ";
					result = "The program is" + dummy + "state-portable \nIterations: " + res.getIterations();
					if(!res.getIsPortable()) {
						graphButton.setEnabled(true);
						graph.generate(solver, ctx, res);
					} else {
						graphButton.setEnabled(false);
					}
					break;
			}
			consolePane.setText(result);
			ctx.close();
		}

		if(e.getActionCommand().equals("Execution Witness")) {
			invokeLater(new Runnable() {public void run() {graph.open();}});
		}

		// We update the task selectors
		tArchPane.setEnabled(false);
		sArchPane.setEnabled(false);
		if(!editor.getLoadedFormat(EditorCode.PROGRAM).equals("litmus")) {
			tArchPane.setEnabled(true);
			if(opt.getTask().equals(Task.PORTABILITY)) {
				sArchPane.setEnabled(true);
			}
		}
	}
}
