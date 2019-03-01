package com.dat3m.ui.utils;

import static guru.nidi.graphviz.engine.Format.PNG;
import static guru.nidi.graphviz.engine.Graphviz.fromGraph;
import static java.awt.Toolkit.getDefaultToolkit;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

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

	private String TMPDOTPATH = "./.tmp/output.dot";
	private String TMPPNGPATH = "./.tmp/output.png";
	
	public void generate(Solver solver, Context ctx, Program p) {
		Graph graph = new Graph(solver.getModel(), ctx);
      	try {
			graph.build(p).draw(TMPDOTPATH);
			File dotFile = new File(TMPDOTPATH);
			// The previous png file needs to be deleted
			Path fileToDeletePath = Paths.get(TMPPNGPATH);
			Files.delete(fileToDeletePath);
			InputStream targetStream = new FileInputStream(dotFile);
			MutableGraph g = Parser.read(targetStream);
			fromGraph(g).render(PNG).toFile(new File(TMPPNGPATH));
			dotFile.delete();
		} catch (IOException e) {
			// This should never happen since the file is always created
		}
	}

	public void open() {
		JLabel label = new JLabel();
		// An image need to be created at every call since thet image changes
		label.setIcon(new ImageIcon(getDefaultToolkit().createImage(TMPPNGPATH)));
        JScrollPane scroll = new JScrollPane(label);
        scroll.setHorizontalScrollBarPolicy(JScrollPane.HORIZONTAL_SCROLLBAR_AS_NEEDED);
        scroll.setVerticalScrollBarPolicy(JScrollPane.VERTICAL_SCROLLBAR_AS_NEEDED);
        JFrame frame = new JFrame();
        frame.add(scroll);
	    frame.pack();
		frame.setVisible(true);	
	}
}
