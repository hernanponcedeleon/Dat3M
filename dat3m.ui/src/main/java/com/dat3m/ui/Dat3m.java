package com.dat3m.ui;

import static com.dat3m.dartagnan.program.utils.Alias.CFIS;
import static com.dat3m.dartagnan.program.utils.Alias.CFS;
import static com.dat3m.dartagnan.wmm.utils.Arch.ARM;
import static com.dat3m.dartagnan.wmm.utils.Arch.ARM8;
import static com.dat3m.dartagnan.wmm.utils.Arch.POWER;
import static com.dat3m.dartagnan.wmm.utils.Arch.TSO;
import static com.dat3m.dartagnan.wmm.utils.Mode.IDL;
import static com.dat3m.dartagnan.wmm.utils.Mode.KNASTER;
import static com.dat3m.ui.Dat3m.Editable.MM;
import static com.dat3m.ui.Dat3m.Editable.PROGRAM;
import static com.dat3m.ui.Dat3m.Task.PORTABILITY;
import static com.dat3m.ui.Dat3m.Task.REACHABILITY;
import static java.awt.BorderLayout.CENTER;
import static java.awt.Color.BLACK;
import static java.awt.Color.WHITE;
import static java.awt.FlowLayout.LEFT;
import static java.awt.Font.ITALIC;
import static java.awt.Image.SCALE_DEFAULT;
import static java.lang.Integer.parseInt;
import static java.lang.System.getProperty;
import static java.util.stream.Collectors.joining;
import static javax.swing.JFileChooser.APPROVE_OPTION;
import static javax.swing.JFrame.EXIT_ON_CLOSE;
import static javax.swing.JOptionPane.INFORMATION_MESSAGE;
import static javax.swing.JOptionPane.showMessageDialog;
import static javax.swing.border.TitledBorder.TOP;

import java.awt.Dimension;
import java.awt.EventQueue;
import java.awt.FlowLayout;
import java.awt.Font;
import java.awt.GridLayout;
import java.awt.Image;
import java.awt.Toolkit;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.ItemEvent;
import java.awt.event.ItemListener;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.Writer;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;
import java.util.stream.Collectors;

import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JEditorPane;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextPane;
import javax.swing.border.TitledBorder;
import javax.swing.filechooser.FileNameExtensionFilter;

import com.microsoft.z3.Context;
import com.microsoft.z3.Solver;

import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.utils.Alias;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.dat3m.dartagnan.wmm.utils.Mode;

public class Dat3m {

	enum Editable { PROGRAM, MM; }
	enum Task { REACHABILITY, PORTABILITY; }
	   
	private static final String PROGRAMLABEL = "Program";
	private static final String MMLABEL = "Memory Model";

	private static final int OPTIONSWIDTH = 400;
	private static final int ICONWIDTH = 400;
	private static final int ICONHEIGHT = 550;
	
	private static final String TMPPROGPATH = "./.tmp/program";
	private static final String TMPMMPATH = "./.tmp/mm.cat";
	
	public static final String TACTIC = "qfufbv";

	private static String loadedFormat = ".pts";
	
	ImageIcon dat3mIcon = new ImageIcon(getProperty("user.dir") + "/../icon/dat3m.jpg");
	ImageIcon dartagnanIcon = new ImageIcon(getProperty("user.dir") + "/icon/dartagnan.jpg");
	ImageIcon porthosIcon = new ImageIcon(getProperty("user.dir") + "/../porthos/icon/porthos.jpg");
	
	private JFrame frame = new JFrame();	
	private JMenu importMenu = new JMenu("Import");
	
	private JEditorPane programEditor = new JTextPane();
    private JEditorPane mmEditor = new JTextPane();
    private JEditorPane console =  new JTextPane();
    private JEditorPane unrollingEditor =  new JTextPane();
    
    Task[] tasks = { REACHABILITY, PORTABILITY };
	private JComboBox<Task> taskSelector = new JComboBox<Task>(tasks);

	Arch[] archs = { Arch.NONE, TSO, POWER, ARM, ARM8 };
    private JComboBox<Arch> archSelector = new JComboBox<Arch>(archs);

    Mode[] modes = { KNASTER, IDL, Mode.KLEENE };
    private JComboBox<Mode> modeSelector = new JComboBox<Mode>(modes);

    Alias[] aliases = { Alias.NONE, CFIS, CFS };
    private JComboBox<Alias> aliasSelector = new JComboBox<Alias>(aliases);

    private JLabel icon = new JLabel();

    private Task task;
    		
	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					Dat3m window = new Dat3m();
					window.frame.setVisible(true);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
	}

	/**
	 * Create the application.
	 */
	public Dat3m() {
		createFrame();
		createImportMenu();
		createProgramImporter();        
        createMMImporter();
        createUnrollingEditor();
		createConsole();
		
		JPanel panel = new JPanel(new GridLayout(1,2));
	    panel.add(createEditor(programEditor, PROGRAMLABEL));
	    panel.add(createEditor(mmEditor, MMLABEL));
	    panel.add(createOptionsPane());

	    frame.getContentPane().add(panel, CENTER);
	}

	private ImageIcon reSizeIcon(ImageIcon icon, int widht, int heigh) {
		Image image = icon.getImage().getScaledInstance(widht, heigh, SCALE_DEFAULT);
		return new ImageIcon(image);
	}

	/**
	 * Initialize the contents of the frame.
	 */
	private void createFrame() {
		Dimension DimMax = Toolkit.getDefaultToolkit().getScreenSize();
		frame.setMaximumSize(DimMax);
		frame.setExtendedState(JFrame.MAXIMIZED_BOTH);
		frame.setDefaultCloseOperation(EXIT_ON_CLOSE);
		Image image = dat3mIcon.getImage();
		frame.setIconImage(image);
	}

	/**
	 * Initialize the contents of the importer menu.
	 */
	private void createImportMenu() {
		JMenuBar menuBar = new JMenuBar();
		frame.setJMenuBar(menuBar); 
		menuBar.add(importMenu);
	}

	/**
	 * Initialize the program importer from the menu.
	 */
	private void createProgramImporter() {
		List<String> programExtensions = new ArrayList<String>();
        programExtensions.add("litmus");
        programExtensions.add("pts");
        createImporter(programEditor, programExtensions, PROGRAM);
	}

	/**
	 * Initialize the memory model importer from the menu.
	 */
	private void createMMImporter() {
		List<String> mmExtensions = new ArrayList<String>();
        mmExtensions.add("cat");
        createImporter(mmEditor, mmExtensions, MM);
	}

	/**
	 * Create the editor for the unrolling bound.
	 */
	private JPanel createUnrollingEditor() {
		unrollingEditor.setText("1");
		JPanel usPane = new JPanel(new FlowLayout(LEFT));
		usPane.setBackground(BLACK);
		JLabel usLabel = new JLabel("Unrolling Bound:");
		usLabel.setForeground(WHITE);
		usLabel.setFont(new Font("Serif", ITALIC, 20));
		usPane.add(usLabel);
		usPane.add(unrollingEditor);
		usPane.setPreferredSize(new Dimension(OPTIONSWIDTH, 30));
		return usPane;
	}

	/**
	 * Create the output console.
	 */
	private void createConsole() {
		TitledBorder consoleBorder = new TitledBorder("Console");
	    consoleBorder.setTitleJustification(TitledBorder.CENTER);
	    consoleBorder.setTitlePosition(TOP);
	    console.setEditable(false);
	    console.setBorder(consoleBorder);
	    console.setPreferredSize(new Dimension(OPTIONSWIDTH, 150));
	}

	/**
	 * Create a generic selector.
	 */
	private JPanel createSelector(JComboBox<?> cb, String label) {
		JPanel pane = new JPanel(new FlowLayout(LEFT));
		pane.setBackground(BLACK);
		JLabel plabel = new JLabel(label);
		plabel.setForeground(WHITE);
		plabel.setFont(new Font("Serif", ITALIC, 20));
		pane.add(plabel);
		pane.add(cb);
	    pane.setPreferredSize(new Dimension(OPTIONSWIDTH, 30));
		return pane;		
	}

	/**
	 * Create the option panel for tool parameters.
	 */
	private JPanel createOptionsPane() {
		taskSelector.addItemListener(new ItemListener() {
            @Override
            public void itemStateChanged(ItemEvent e) {
                Object item = taskSelector.getSelectedItem();
                if (REACHABILITY.equals(item)) {
                    task = REACHABILITY;
                } else if (PORTABILITY.equals(item)) {
                    task = PORTABILITY;
                }
                updateIcon();
            }
        });

		JPanel pane = new JPanel();
		pane.setBackground(BLACK);
		// Default image
		reSizeIcon(dartagnanIcon, ICONWIDTH, ICONHEIGHT);
        icon.setIcon(dartagnanIcon);
		pane.add(icon);
        task = (Task) taskSelector.getSelectedItem();
        
	    taskSelector.setPreferredSize(new Dimension(336, 30));
	    archSelector.setPreferredSize(new Dimension(194, 30));
	    modeSelector.setPreferredSize(new Dimension(326, 30));
	    aliasSelector.setPreferredSize(new Dimension(247, 30));

	    pane.add(createSelector(taskSelector, "Task:"));
        pane.add(createSelector(archSelector, "Compiler Mapping:"));
        pane.add(createSelector(modeSelector, "Mode:"));
        pane.add(createSelector(aliasSelector, "Alias Analysis:"));
        pane.add(createUnrollingEditor());
        pane.add(createTestButton());
        pane.add(console);
        pane.add(createClearButton());
        
        return pane;
	}

	private JButton createTestButton() {
		JButton testButton = new JButton("Test");
		testButton.setPreferredSize(new Dimension(OPTIONSWIDTH, 30));
        testButton.addActionListener(new ActionListener() { 
            public void actionPerformed(ActionEvent e) { 
                if(programEditor.getText().isEmpty()) {
                    showMessageDialog(frame, "No program has been imported.", "About", INFORMATION_MESSAGE, reSizeIcon(dat3mIcon, 60, 60));
					return;
                }
                if(mmEditor.getText().isEmpty()) {
                    showMessageDialog(frame, "No memory model has been imported.", "About", INFORMATION_MESSAGE, reSizeIcon(dat3mIcon, 60, 60));
                	return;
                }
                
                Arch target = (Arch) archSelector.getSelectedItem();
                Mode mode = (Mode) modeSelector.getSelectedItem();
                Alias alias = (Alias) aliasSelector.getSelectedItem();
                int bound = parseInt(unrollingEditor.getText());
                
                try {
                    Context ctx = new Context();
                    Solver s = ctx.mkSolver(ctx.mkTactic(TACTIC));
                    String result = testProgramFromEditors(s, ctx, programEditor, mmEditor, target, mode, alias, bound);
            		console.setText(result);
                } catch (Exception exp) {
                    showMessageDialog(frame, exp.getMessage(), "About", INFORMATION_MESSAGE, reSizeIcon(dat3mIcon, 60, 60));
					return;
				}
            } 
        });
		return testButton;
	}

	private JButton createClearButton() {
		JButton clearButton = new JButton("Clear Console");
        clearButton.setPreferredSize(new Dimension(OPTIONSWIDTH, 30));
        clearButton.addActionListener(new ActionListener() { 
            public void actionPerformed(ActionEvent e) { 
                console.setText("");
                }
            });
		return clearButton;
	}
	
	/**
	 * Update the displayed image. This method will be called when the task is selected.
	 */
	private void updateIcon() {
		ImageIcon imageIcon = null;
        switch (task) {
		case REACHABILITY:
			imageIcon = dartagnanIcon;		
			break;
		case PORTABILITY:
			imageIcon = porthosIcon;	
			break;
		default:
			break;
		}
        Image image = imageIcon.getImage().getScaledInstance(ICONWIDTH, ICONHEIGHT, java.awt.Image.SCALE_DEFAULT);
        imageIcon = new ImageIcon(image);
        icon.setIcon(imageIcon);
	}
	
	/**
	 * Create a generic importer.
	 */
	private void createImporter(JEditorPane editor, List<String> extensions, Editable type) {
		JFileChooser chooser = new JFileChooser();
		chooser.setCurrentDirectory(new File(getProperty("user.dir") + "/.."));
		String name = "";
		switch (type) {
			case PROGRAM:
				name = PROGRAMLABEL;
				chooser.addChoosableFileFilter(new FileNameExtensionFilter("*.pts", "pts"));
				chooser.addChoosableFileFilter(new FileNameExtensionFilter("*.litmus", "litmus"));						
				break;
			case MM:
				name = MMLABEL;
				chooser.addChoosableFileFilter(new FileNameExtensionFilter("*.cat", "cat"));
				break;
			default:
				break;
		}
		JMenuItem openItem = new JMenuItem(name);
		importMenu.add(openItem);
		openItem.addActionListener(new ActionListener(){
			public void actionPerformed(ActionEvent event){
				int r=chooser.showOpenDialog(null);
				if(r==APPROVE_OPTION){
					String path = chooser.getSelectedFile().getPath();
					String ext = path.substring(path.lastIndexOf('.') + 1).trim();
					if(type.equals(PROGRAM)) {
						loadedFormat = "." + ext;						
					}
					if(!extensions.contains(ext)) {
						showMessageDialog(frame, "Please select a *." + extensions.stream().collect(joining(", *.")) + " file!");
						return;
					}
					loadFileData(path, editor);
				}
			}
		});
	}

	/**
	 * Create a generic editor with border and title.
	 */
	private JScrollPane createEditor(JEditorPane editor, String title) {
	 
	    TitledBorder border = new TitledBorder(title);
		border.setTitleFont(new Font("Serif", ITALIC, 25));
	    border.setTitleJustification(TitledBorder.CENTER);
	    border.setTitlePosition(TOP);
	    editor.setBorder(border);
        return new JScrollPane(editor);
	}

	/**
	 * Load the data of a file into a given editor.
	 */
	public void loadFileData(String path, JEditorPane editor) {
		File file = new File(path);
		Scanner fileScanner = null;
		try {
			fileScanner = new Scanner(file);
			editor.setText("");
			
			while(fileScanner.hasNextLine()) {
				String line = fileScanner.nextLine();
				editor.setText(editor.getText() + line + "\n"); 
			}
			
		} catch(IOException fnfe) {
			System.err.println(fnfe.getMessage());
		}
	}
	
	public String testProgramFromEditors(Solver solver, Context ctx, JEditorPane pEditor, JEditorPane mmEditor, Arch target, Mode mode, Alias alias, int steps) {
		try {		
			
			File tmpProgramFile = new File(TMPPROGPATH + loadedFormat);
			if (!tmpProgramFile.getParentFile().exists()) {
				tmpProgramFile.getParentFile().mkdirs();
			}
			if (!tmpProgramFile.exists()) {
				tmpProgramFile.createNewFile();
			}
			Writer writer = new PrintWriter(tmpProgramFile);
			writer.write(pEditor.getText());
			writer.close();	
	        Program p = new ProgramParser().parse(TMPPROGPATH + loadedFormat);
			tmpProgramFile.delete();
			
			File tmpMMFile = new File(TMPMMPATH);
			if (!tmpMMFile.exists()) {
				tmpMMFile.createNewFile();
			}
			writer = new PrintWriter(tmpMMFile);
			writer.write(mmEditor.getText());
			writer.close();
			Wmm mm = new ParserCat().parse(TMPMMPATH, target);
			tmpMMFile.delete();

			String result = "Condition " + p.getAss().toStringWithType() + "\n";
			result += com.dat3m.dartagnan.Dartagnan.testProgram(solver, ctx, p, mm, target, steps, mode, alias) ? "OK" : "No";
			return result;			

		} catch (IOException e) {
			return e.getMessage();
		}	
	}
}