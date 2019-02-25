package com.dat3m.ui;

import javax.swing.*;
import javax.swing.border.TitledBorder;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.utils.Alias;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.dat3m.dartagnan.wmm.utils.Mode;
import com.microsoft.z3.Context;

import com.dat3m.ui.editor.MMEditor;
import com.dat3m.ui.editor.ProgramEditor;

import static com.dat3m.dartagnan.Dartagnan.testProgram;
import static com.dat3m.dartagnan.program.utils.Alias.CFIS;
import static com.dat3m.dartagnan.program.utils.Alias.CFS;
import static com.dat3m.dartagnan.wmm.utils.Arch.ARM;
import static com.dat3m.dartagnan.wmm.utils.Arch.ARM8;
import static com.dat3m.dartagnan.wmm.utils.Arch.POWER;
import static com.dat3m.dartagnan.wmm.utils.Arch.TSO;
import static com.dat3m.dartagnan.wmm.utils.Mode.IDL;
import static com.dat3m.dartagnan.wmm.utils.Mode.KLEENE;
import static com.dat3m.dartagnan.wmm.utils.Mode.KNASTER;
import static com.dat3m.ui.Task.PORTABILITY;
import static com.dat3m.ui.Task.REACHABILITY;
import static com.dat3m.ui.editor.EditorUtils.parseMMEditor;
import static com.dat3m.ui.editor.EditorUtils.parseProgramEditor;
import static java.awt.FlowLayout.LEFT;
import static javax.swing.BorderFactory.createTitledBorder;
import static javax.swing.JOptionPane.showMessageDialog;
import static javax.swing.SwingUtilities.invokeLater;
import static javax.swing.border.TitledBorder.CENTER;

import java.awt.*;
import java.awt.event.*;

public class Dat3M extends JPanel implements ActionListener {

    public static final ImageIcon dat3mIcon = new ImageIcon(Dat3M.class.getResource("/dat3m.png"), "Dat3m") {
	    @Override
	    public void paintIcon( Component c, Graphics g, int x, int y ) {
	        g.drawImage(getImage(), x, y, c.getWidth(), c.getHeight(), c);
	    }
	    
	    @Override 
	    public int getIconHeight() {
			return 60;
	    }

	    @Override
	    public int getIconWidth() {
			return 60;
	    }
	};

    protected static final int widht = getMainScreenWidth();
    protected static final int height = getMainScreenHeight();
	protected static JMenuBar menuBar = new JMenuBar();
	protected static JMenu menu = new JMenu("Import");

    protected static final ImageIcon dartagnanIcon = new ImageIcon(Dat3M.class.getResource("/dartagnan.jpg"), "Dartagnan");
    protected static final ImageIcon porthosIcon = new ImageIcon(Dat3M.class.getResource("/porthos.jpg"), "Porthos");
    protected JLabel iconPane = new JLabel(dartagnanIcon, JLabel.CENTER);

    private ProgramEditor programEditor;
	private MMEditor mmEditor;
	private MMEditor smmEditor;
	private MMEditor tmmEditor;
	private JTextPane consolePane;
	private JTextField boundField;
	
	protected Task task = Task.REACHABILITY;
	protected Arch target = Arch.NONE;
	protected Mode mode = Mode.KNASTER;
	protected Alias alias = Alias.CFS;
	protected int bound = 1;

	private JSplitPane vSplitEditors;

    public Dat3M() {

        setLayout(new BorderLayout());

        programEditor = new ProgramEditor(menu);        
        mmEditor = new MMEditor(menu, new JEditorPane(), "Memory Model");
        smmEditor = new MMEditor(menu, new JEditorPane(), "Source Memory Model");
        tmmEditor = new MMEditor(menu, new JEditorPane(), "Target Memory Model");
        
        Task[] tasks = { REACHABILITY, PORTABILITY };
		JPanel taskPane = createSelector(tasks, "Task");

		Arch[] archs = { Arch.NONE, TSO, POWER, ARM, ARM8 };
		JPanel archPane = createSelector(archs, "Target");

        Mode[] modes = { KNASTER, IDL, KLEENE };
        JPanel modePane = createSelector(modes, "Mode");

        Alias[] aliases = { CFS, Alias.NONE, CFIS };
        JPanel aliasPane = createSelector(aliases, "Alias");

        // Bound editor
        boundField = new JTextField(3);
        boundField.setText("1");
        boundField.setActionCommand("Bound");
        boundField.addActionListener(this);
        boundField.addKeyListener(new BoundListener());
        JLabel uLabel = new JLabel("Unrolling Bound: ");
		JPanel boundPane = new JPanel(new FlowLayout(LEFT));
		boundPane.add(uLabel);
		boundPane.add(boundField);

        // Console.
        consolePane = new JTextPane();
        consolePane.setEditable(false);
        JScrollPane scrollConsole = new JScrollPane(consolePane);
        scrollConsole.setMinimumSize(new Dimension(0, 150));
        scrollConsole.setHorizontalScrollBarPolicy(JScrollPane.HORIZONTAL_SCROLLBAR_AS_NEEDED);

        // Test button.
        JButton testButton = new JButton("Test");
        testButton.setMaximumSize(new Dimension(widht, 50));
        testButton.addActionListener(this);

        // Clear button.
        JButton clearButton = new JButton("Clear");
        clearButton.setMaximumSize(new Dimension(widht, 50));
        clearButton.addActionListener(this);

        iconPane.setIcon(dartagnanIcon);

        //Put the options in a split pane.
        JSplitPane sp0 = new JSplitPane(JSplitPane.VERTICAL_SPLIT, iconPane, taskPane);
        JSplitPane sp1 = new JSplitPane(JSplitPane.VERTICAL_SPLIT, sp0, archPane);
        JSplitPane sp2 = new JSplitPane(JSplitPane.VERTICAL_SPLIT, sp1, modePane);
        JSplitPane sp3 = new JSplitPane(JSplitPane.VERTICAL_SPLIT, sp2, aliasPane);
        JSplitPane sp4 = new JSplitPane(JSplitPane.VERTICAL_SPLIT, sp3, boundPane);
        JSplitPane sp5 = new JSplitPane(JSplitPane.VERTICAL_SPLIT, sp4, testButton);
        JSplitPane sp6 = new JSplitPane(JSplitPane.VERTICAL_SPLIT, sp5, scrollConsole);
        JSplitPane sp7 = new JSplitPane(JSplitPane.VERTICAL_SPLIT, sp6, clearButton);
        JSplitPane sp8 = new JSplitPane(JSplitPane.VERTICAL_SPLIT, sp7, new JPanel());

        JPanel optionsPane = new JPanel(new GridLayout(1,0));
        optionsPane.add(sp8);

        TitledBorder titledBorder = createTitledBorder("Options");
        titledBorder.setTitleJustification(CENTER);
        optionsPane.setBorder(titledBorder);
        optionsPane.setMaximumSize(new Dimension(dartagnanIcon.getIconWidth(), 100));
        add(optionsPane);

        //Put the editors in a split pane.
        vSplitEditors = new JSplitPane(JSplitPane.VERTICAL_SPLIT);
        vSplitEditors.setOneTouchExpandable(true);
        vSplitEditors.setResizeWeight(0.5);
        vSplitEditors.setTopComponent(mmEditor);
        
        JSplitPane hSplitEditors = new JSplitPane(JSplitPane.HORIZONTAL_SPLIT, programEditor, vSplitEditors);
        hSplitEditors.setOneTouchExpandable(true);
        hSplitEditors.setResizeWeight(0.5);
        hSplitEditors.setPreferredSize(new Dimension(2 * widht / 3, 100));
        JPanel editorsPane = new JPanel(new GridLayout(1,0));
        editorsPane.add(hSplitEditors);
        add(editorsPane, BorderLayout.LINE_END);
    }

    private void updateTaskIcon() {
        switch(task){
        case REACHABILITY:
            iconPane.setIcon(dartagnanIcon);
            break;
        case PORTABILITY:
            iconPane.setIcon(porthosIcon);
            break;
        }
    }

    private void updateMMEditors() {
        switch(task){
        case REACHABILITY:
            vSplitEditors.removeAll();
            vSplitEditors.setTopComponent(mmEditor);
            break;
        case PORTABILITY:
        	vSplitEditors.removeAll();
            vSplitEditors.setTopComponent(smmEditor);
            vSplitEditors.setBottomComponent(tmmEditor);
            break;
        }
    }

	private JPanel createSelector(Object[] options, String label) {
		JComboBox<?> selector = new JComboBox<Object>(options);
    	selector.setActionCommand(label);
        selector.addActionListener(this);
        JLabel sLabel = new JLabel(label + ": ");
		JPanel pane = new JPanel(new FlowLayout(LEFT));
        pane.add(sLabel);
        pane.add(selector);
		return pane;
	}

    /**
     * Create the GUI and show it.  For thread safety,
     * this method should be invoked from the
     * event dispatch thread.
     */
	private static void createAndShowGUI() {
        //Create and set up the window.
        JFrame frame = new JFrame("Dat3M");
		frame.setExtendedState(JFrame.MAXIMIZED_BOTH);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

		menuBar.add(menu);
		frame.setJMenuBar(menuBar);
		frame.setIconImage(dat3mIcon.getImage());

        //Add content to the window.
        frame.add(new Dat3M());
        
        //Display the window.
        frame.pack();
        frame.setVisible(true);
    }

    public static void main(String[] args) {
		UIManager.getDefaults().put("SplitPane.border", BorderFactory.createEmptyBorder());
        invokeLater(new Runnable() {public void run() {createAndShowGUI();}});
    }

	@SuppressWarnings("unchecked")
	@Override
	public void actionPerformed(ActionEvent e) {
		
		if(boundField.getText().equals("")) {
			boundField.setText("1");
		}

		if(e.getActionCommand().equals("Task")) {
			Object source = e.getSource();
			if(source instanceof JComboBox<?>) {
				task = (Task) ((JComboBox<Task>)source).getSelectedItem();
				updateTaskIcon();
				updateMMEditors();
			}
		}

		if(e.getActionCommand().equals("Target")) {
			Object source = e.getSource();
			if(source instanceof JComboBox<?>) {
				target = (Arch) ((JComboBox<Arch>)source).getSelectedItem();
			}
		}

		if(e.getActionCommand().equals("Mode")) {
			Object source = e.getSource();
			if(source instanceof JComboBox<?>) {
				mode = (Mode) ((JComboBox<Mode>)source).getSelectedItem();
			}
		}

		if(e.getActionCommand().equals("Alias")) {
			Object source = e.getSource();
			if(source instanceof JComboBox<?>) {
				alias = (Alias) ((JComboBox<Alias>)source).getSelectedItem();
			}
		}

		if(e.getActionCommand().equals("Test")) {
			Program p = null;
			try {
				//TODO: fix loadedFormat
				p = parseProgramEditor(programEditor.getEditor(), "litmus");
			} catch (Exception exp) {
				showMessageDialog(null, "The program was not imported or cannot be parsed", "About", JOptionPane.INFORMATION_MESSAGE, dat3mIcon);
				return;
			}
			
			Wmm mm = null;
			try {				
				mm = parseMMEditor(mmEditor.getEditor(), target);
			} catch (Exception exp) {
				showMessageDialog(null, "The memory model was not imported or cannot be parsed", "About", JOptionPane.INFORMATION_MESSAGE, dat3mIcon);	
				return;
			}
			
			String result = "Condition " + p.getAss().toStringWithType() + "\n";
			Context ctx = new Context();
			result += testProgram(ctx.mkSolver(), ctx, p, mm, target, bound, mode, alias) ? "OK" : "No";
			consolePane.setText(result);
		}

		if(e.getActionCommand().equals("Clear")) {
			consolePane.setText("");
		}
	}
	
	class BoundListener implements KeyListener {
		@Override
		public void keyTyped(KeyEvent event) {
			try {
				bound = Integer.parseInt(boundField.getText());				
			} catch (Exception e) {
				// Nothing to do here
			}
		}

		@Override
		public void keyPressed(KeyEvent arg0) {
			// Nothing to do here
		}

		@Override
		public void keyReleased(KeyEvent arg0) {
			// Nothing to do here				
		}
	};
	
	public static int getMainScreenWidth() {
		GraphicsEnvironment ge = GraphicsEnvironment.getLocalGraphicsEnvironment();
	    GraphicsDevice[] gs = ge.getScreenDevices();
	    if (gs.length > 0) {
	        return (int) Math.round(gs[0].getDisplayMode().getWidth());
	    }
	    return 0;
	}
	
	public static int getMainScreenHeight() {
		GraphicsEnvironment ge = GraphicsEnvironment.getLocalGraphicsEnvironment();
	    GraphicsDevice[] gs = ge.getScreenDevices();
	    if (gs.length > 0) {
	        return (int) Math.round(gs[0].getDisplayMode().getHeight());
	    }
	    return 0;
	}
}
