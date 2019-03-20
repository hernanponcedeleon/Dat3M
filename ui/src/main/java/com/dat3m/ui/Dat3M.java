package com.dat3m.ui;

import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.ui.editor.EditorsPane;
import com.dat3m.ui.editor.EditorCode;
import com.dat3m.ui.icon.IconCode;
import com.dat3m.ui.icon.IconHelper;
import com.dat3m.ui.graph.GraphOption;
import com.dat3m.ui.options.Options;
import com.dat3m.ui.options.OptionsPane;
import com.dat3m.ui.options.utils.ControlCode;
import com.dat3m.ui.result.Dat3mResult;
import com.dat3m.ui.result.PortabilityResult;
import com.dat3m.ui.result.ReachabilityResult;
import com.dat3m.ui.utils.Task;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import static com.dat3m.ui.utils.Utils.showError;
import static javax.swing.BorderFactory.createEmptyBorder;
import static javax.swing.UIManager.getDefaults;

public class Dat3M extends JFrame implements ActionListener {

	private final OptionsPane optionsPane = new OptionsPane();
	private final EditorsPane editorsPane = new EditorsPane();
	private final GraphOption graph = new GraphOption();

	private Dat3mResult testResult;

	private Dat3M() {
		getDefaults().put("SplitPane.border", createEmptyBorder());

		setTitle("Dat3M");
		setExtendedState(JFrame.MAXIMIZED_BOTH);
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setLayout(new BorderLayout());
		setIconImage(IconHelper.getIcon(IconCode.DAT3M).getImage());

		JMenuBar menuBar = new JMenuBar();
		menuBar.add(editorsPane.getMenu());
		setJMenuBar(menuBar);

		JSplitPane mainPane = new JSplitPane(JSplitPane.HORIZONTAL_SPLIT, optionsPane, editorsPane.getMainPane());
		mainPane.setDividerSize(2);
		add(mainPane);

		// EditorsPane needs to know if task is changed in order to show / hide source model editor
		optionsPane.getTaskPane().addActionListener(editorsPane);

		// ArchPane needs to know which program format has been loaded by editor in order to show / hide target
		editorsPane.getEditor(EditorCode.PROGRAM).addActionListener(optionsPane.getArchManager());

		// Start listening to button events
		optionsPane.getTestButton().addActionListener(this);
		optionsPane.getClearButton().addActionListener(this);
		optionsPane.getGraphButton().addActionListener(this);

		// optionsPane needs to listen to editor to clean the console
		editorsPane.getEditor(EditorCode.PROGRAM).addActionListener(optionsPane);
		editorsPane.getEditor(EditorCode.SOURCE_MM).addActionListener(optionsPane);
		editorsPane.getEditor(EditorCode.TARGET_MM).addActionListener(optionsPane);

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
                optionsPane.getGraphButton().setEnabled(testResult.getGraph() != null);
            }
        } else if(ControlCode.GRAPH.actionCommand().equals(command)){
            EventQueue.invokeLater(graph::open);
        }
	}

	private void runTest(){
		Options options = optionsPane.getOptions();
		if(options.validate()){
            testResult = null;
		    try {
                String programText = editorsPane.getEditor(EditorCode.PROGRAM).getText();
                String format = editorsPane.getEditor(EditorCode.PROGRAM).getLoadedFormat();
                Program program = new ProgramParser().parse(programText, format);
                try {
                    String targetModelRaw = editorsPane.getEditor(EditorCode.TARGET_MM).getText();
                    Wmm targetModel = new ParserCat().parse(targetModelRaw);
                    if(options.getTask() == Task.REACHABILITY){
                        testResult = new ReachabilityResult(program, targetModel, options);
                    } else {
                        try {
                        	if(!editorsPane.getEditor(EditorCode.PROGRAM).getLoadedFormat().equals("pts")) {
                        		showError("PORTHOS only supports *.pts files", "Loading error");
                        		return;
                        	}
                            Program sourceProgram = new ProgramParser().parse(programText, format);
                            String sourceModelRaw = editorsPane.getEditor(EditorCode.SOURCE_MM).getText();
                            Wmm sourceModel = new ParserCat().parse(sourceModelRaw);
                            testResult = new PortabilityResult(sourceProgram, program, sourceModel, targetModel, options);
                        } catch (Exception e){
                            showError("The source memory model was not imported or cannot be parsed", "Loading or parsing error");
                        }
                    }
                } catch (Exception e){
                    showError("The target memory model was not imported or cannot be parsed", "Loading or parsing error");
                }
            } catch (Exception e){
                showError("The program was not imported or cannot be parsed", "Loading or parsing error");
            }
		    if(testResult != null && testResult.isSat()) {
	            graph.generate(testResult);
		    }
		}
	}
}
