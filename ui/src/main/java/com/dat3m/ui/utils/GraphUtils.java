package com.dat3m.ui.utils;

import static guru.nidi.graphviz.engine.Format.SVG;
import static guru.nidi.graphviz.engine.Graphviz.fromGraph;

import java.awt.Image;
import java.awt.Toolkit;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import javax.swing.ImageIcon;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JScrollPane;

import com.dat3m.dartagnan.utils.Graph;
import guru.nidi.graphviz.model.MutableGraph;
import guru.nidi.graphviz.parse.Parser;

public class GraphUtils {

	public static void showGraph(Graph graph) {
		if(graph != null) {
			try {
				JLabel label = new JLabel();
				InputStream stream = new ByteArrayInputStream(graph.toString().getBytes());
				MutableGraph g = Parser.read(stream);
				BufferedImage image = fromGraph(g).render(SVG).toImage();
				int height = (int) Math.round(Toolkit.getDefaultToolkit().getScreenSize().getHeight());
		        int width = image.getWidth() * height / image.getHeight();
		        Image scaledImage = image.getScaledInstance(width, height, Image.SCALE_SMOOTH);
				label.setIcon(new ImageIcon(scaledImage));
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
