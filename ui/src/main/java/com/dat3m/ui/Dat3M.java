package com.dat3m.ui;

import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.ui.editor.EditorsPane;
import com.dat3m.ui.editor.EditorCode;
import com.dat3m.ui.icon.IconCode;
import com.dat3m.ui.icon.IconHelper;
import com.dat3m.ui.option.GraphOption;
import com.dat3m.ui.option.Option;
import com.dat3m.ui.options.OptionsPane;
import com.dat3m.ui.options.utils.ControlCode;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import static javax.swing.BorderFactory.createEmptyBorder;
import static javax.swing.UIManager.getDefaults;

public class Dat3M extends JFrame implements ActionListener {

	private final OptionsPane optionsPane = new OptionsPane();
	private final EditorsPane editorsPane = new EditorsPane();
	private final GraphOption graph = new GraphOption();

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

		// EditorsPane needs to know is task is changed in order to show / hide source model editor
		optionsPane.getTaskPane().addActionListener(editorsPane);

		// ArchPane needs to know which program format has been loaded by editor in order to show / hide target
		editorsPane.getEditor(EditorCode.PROGRAM).addActionListener(optionsPane.getArchManager());

		// Start listening to button events
		optionsPane.getTestButton().addActionListener(this);
		optionsPane.getClearButton().addActionListener(this);
		optionsPane.getGraphButton().addActionListener(this);

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
        } else if(ControlCode.CLEAR.actionCommand().equals(command)){
            System.out.println("I should clear. What should I clear?");
            // TODO: Implementation
        } else if(ControlCode.GRAPH.actionCommand().equals(command)){
            // TODO: Implementation
            EventQueue.invokeLater(graph::open);
        }
	}

	private void runTest(){
		Option option = optionsPane.getOption();
		if(option.validate()){
			// TODO: Implementation
			String programText = editorsPane.getEditor(EditorCode.PROGRAM).getText();
			String format = editorsPane.getEditor(EditorCode.PROGRAM).getLoadedFormat();
            Program program = new ProgramParser().parse(programText, format);


            String targetModelRaw = editorsPane.getEditor(EditorCode.TARGET_MM).getText();
            Wmm targetModel = new ParserCat().parse(targetModelRaw, option.getTarget());

		}
	}
}
