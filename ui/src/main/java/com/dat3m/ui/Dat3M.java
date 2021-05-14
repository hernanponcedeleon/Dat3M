package com.dat3m.ui;

import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.ui.editor.EditorsPane;
import com.dat3m.ui.editor.Editor;
import com.dat3m.ui.editor.EditorCode;
import com.dat3m.ui.icon.IconCode;
import com.dat3m.ui.icon.IconHelper;
import com.dat3m.ui.listener.EditorListener;
import com.dat3m.ui.utils.UiOptions;
import com.dat3m.ui.options.OptionsPane;
import com.dat3m.ui.options.utils.ControlCode;
import com.dat3m.ui.result.ReachabilityResult;
import javax.swing.*;

import org.antlr.v4.runtime.InputMismatchException;
import org.antlr.v4.runtime.Token;

import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import static com.dat3m.ui.utils.Utils.showError;
import static javax.swing.BorderFactory.createEmptyBorder;
import static javax.swing.UIManager.getDefaults;

public class Dat3M extends JFrame implements ActionListener {

	private final OptionsPane optionsPane = new OptionsPane();
	private final EditorsPane editorsPane = new EditorsPane();
	
	private ReachabilityResult testResult;

	private Dat3M() {
		getDefaults().put("SplitPane.border", createEmptyBorder());

		setTitle("Dat3M");
		setExtendedState(JFrame.MAXIMIZED_BOTH);
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setLayout(new BorderLayout());
		setIconImage(IconHelper.getIcon(IconCode.DAT3M).getImage());

		JMenuBar menuBar = new JMenuBar();
		JMenu fileMenu = new JMenu("File");
		fileMenu.add(editorsPane.getMenuImporter());
		fileMenu.add(editorsPane.getMenuExporter());
		menuBar.add(fileMenu);
		setJMenuBar(menuBar);

		JSplitPane mainPane = new JSplitPane(JSplitPane.HORIZONTAL_SPLIT, optionsPane, editorsPane.getMainPane());
		mainPane.setDividerSize(2);
		add(mainPane);

		// Start listening to button events
		optionsPane.getTestButton().addActionListener(this);

		// optionsPane needs to listen to editor to clean the console
		editorsPane.getEditor(EditorCode.PROGRAM).addActionListener(optionsPane);
		editorsPane.getEditor(EditorCode.TARGET_MM).addActionListener(optionsPane);

		// The console shall be cleaned every time the program or MM is modified from the editor
    	EditorListener listener = new EditorListener(optionsPane.getConsolePane());
    	editorsPane.getEditor(EditorCode.PROGRAM).getEditorPane().addKeyListener(listener);
    	editorsPane.getEditor(EditorCode.TARGET_MM).getEditorPane().addKeyListener(listener);

		pack();
	}

	public static void main(String[] args) {
		EventQueue.invokeLater(() -> {
			Dat3M app = new Dat3M();
			app.setVisible(true);
		});
	}

	@Override
	public void actionPerformed(ActionEvent event) {
	    String command = event.getActionCommand();
	    if(ControlCode.TEST.actionCommand().equals(command)){
            runTest();
            if(testResult != null){
                optionsPane.getConsolePane().setText(testResult.getVerdict());
            }
        }
	}

	private void runTest(){
		UiOptions options = optionsPane.getOptions();
		testResult = null;
		try {
			Editor programEditor = editorsPane.getEditor(EditorCode.PROGRAM);
			Program program = new ProgramParser().parse(programEditor.getEditorPane().getText(), programEditor.getLoadedFormat());
			try {
				Wmm targetModel = new ParserCat().parse(editorsPane.getEditor(EditorCode.TARGET_MM).getEditorPane().getText());
				testResult = new ReachabilityResult(program, targetModel, options);
			} catch (Exception e){
				String msg = e.getMessage() == null? "Memory model cannot be parsed" : e.getMessage();
				showError(msg, "Target memory model error");
			}
		} catch (Exception e){
			String msg = e.getMessage() == null? "Program cannot be parsed" : e.getMessage();
			Throwable cause = e.getCause();
			if(cause instanceof InputMismatchException) {
				Token token = ((InputMismatchException)cause).getOffendingToken();
				msg = "Problem with \"" + token.getText() + "\" at line " + token.getLine();
			}
			showError(msg, "Program error");
		}
	}
}
