package com.dat3m.ui.graph;

import static guru.nidi.graphviz.engine.Format.PNG;
import static guru.nidi.graphviz.engine.Graphviz.fromGraph;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import javax.swing.ImageIcon;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JScrollPane;

import com.dat3m.dartagnan.utils.Graph;
import com.dat3m.ui.utils.Utils;
import guru.nidi.graphviz.model.MutableGraph;
import guru.nidi.graphviz.parse.Parser;

public class GraphOption {

	public void open(Graph graph) {
		if(graph != null) {
			try {
				JLabel label = new JLabel();
				InputStream stream = new ByteArrayInputStream(graph.toString().getBytes());
				MutableGraph g = Parser.read(stream);
				label.setIcon(new ImageIcon(fromGraph(g).render(PNG).toImage()));
				JScrollPane scroll = new JScrollPane(label);
				scroll.setHorizontalScrollBarPolicy(JScrollPane.HORIZONTAL_SCROLLBAR_AS_NEEDED);
				scroll.setVerticalScrollBarPolicy(JScrollPane.VERTICAL_SCROLLBAR_AS_NEEDED);
				JFrame frame = new JFrame();
				frame.add(scroll);
				frame.pack();
				frame.setVisible(true);

			} catch (IOException e){
				Utils.showError("Failed to render a graph");
			}
		}
	}
}
