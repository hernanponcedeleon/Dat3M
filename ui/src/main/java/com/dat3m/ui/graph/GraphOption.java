package com.dat3m.ui.graph;

import static guru.nidi.graphviz.engine.Format.PNG;
import static guru.nidi.graphviz.engine.Graphviz.fromGraph;
import static java.awt.Toolkit.getDefaultToolkit;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Arrays;
import java.util.List;
import javax.swing.ImageIcon;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JScrollPane;

import com.dat3m.dartagnan.utils.Graph;
import com.dat3m.ui.result.Dat3mResult;
import guru.nidi.graphviz.model.MutableGraph;
import guru.nidi.graphviz.parse.Parser;

public class GraphOption {

	private File dotFile = new File(".tmp/output.dot");
	private File pngFile = new File(".tmp/output.png");

    //private final JMenu menu;
    private final RelSelector selector = new RelSelector();

    public RelSelector getSelector(){
        return selector;
    }

	public void generate(Dat3mResult res) {
		try {
			if(res.isSat()) {
		        List<File> files = Arrays.asList(dotFile, pngFile);
		        // Create the file and parent directory if they do not exist
		        for(File f : files) {
					if (f.getParentFile() != null) {
						f.getParentFile().mkdirs();
					}
					f.createNewFile();		        	
		        }
				Graph graph = res.getGraph();
				File dot2File = graph.draw(dotFile.getAbsolutePath());
				// The previous png file needs to be deleted
				pngFile.delete();
				InputStream targetStream = new FileInputStream(dot2File);
				MutableGraph g = Parser.read(targetStream);
				fromGraph(g).render(PNG).toFile(pngFile);
			}
      	} catch (IOException e) {
			// This should never happen since the file is always created
		}
	}

	public void open() {
		JLabel label = new JLabel();
		// An image need to be created at every call since the image changes
		label.setIcon(new ImageIcon(getDefaultToolkit().createImage(pngFile.getAbsolutePath())));
        JScrollPane scroll = new JScrollPane(label);
        scroll.setHorizontalScrollBarPolicy(JScrollPane.HORIZONTAL_SCROLLBAR_AS_NEEDED);
        scroll.setVerticalScrollBarPolicy(JScrollPane.VERTICAL_SCROLLBAR_AS_NEEDED);
        JFrame frame = new JFrame();
        frame.add(scroll);
	    frame.pack();
		frame.setVisible(true);	
	}
}
