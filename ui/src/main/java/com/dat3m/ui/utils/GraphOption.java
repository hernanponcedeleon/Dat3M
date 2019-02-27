package com.dat3m.ui.utils;

import static guru.nidi.graphviz.engine.Format.PNG;
import static guru.nidi.graphviz.engine.Graphviz.fromGraph;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;

import javax.swing.ImageIcon;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JScrollPane;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.Graph;
import com.microsoft.z3.Context;
import com.microsoft.z3.Solver;

import guru.nidi.graphviz.model.MutableGraph;
import guru.nidi.graphviz.parse.Parser;

public class GraphOption {

	static final String TMPDOTPATH = "./.tmp/output.dot";
	static final String TMPPNGPATH = "./.tmp/output.png";
	
	public GraphOption() {
		
	}

	public void generate(Solver solver, Context ctx, Program p) {
		Graph graph = new Graph(solver.getModel(), ctx);
      	try {
			graph.build(p).draw(TMPDOTPATH);
			File initialFile = new File(TMPDOTPATH);
		    InputStream targetStream = new FileInputStream(initialFile);
			MutableGraph g = Parser.read(targetStream);
			fromGraph(g).render(PNG).toFile(new File(TMPPNGPATH));
		} catch (IOException e) {
			// This should never happen since the file is always created
		}
	}

	public void open() {
		JFrame frame = new JFrame();
		JLabel label = new JLabel();
		label.setIcon(new ImageIcon(TMPPNGPATH));
        JScrollPane scrool = new JScrollPane(label);
        scrool.setHorizontalScrollBarPolicy(JScrollPane.HORIZONTAL_SCROLLBAR_AS_NEEDED);
        scrool.setVerticalScrollBarPolicy(JScrollPane.VERTICAL_SCROLLBAR_AS_NEEDED);
		frame.add(scrool);
	    frame.pack();
		frame.setVisible(true);	
	}
}
