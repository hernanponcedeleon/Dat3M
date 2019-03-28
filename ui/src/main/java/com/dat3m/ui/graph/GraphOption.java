package com.dat3m.ui.graph;

import static com.dat3m.ui.editor.EditorCode.SOURCE_MM;
import static com.dat3m.ui.editor.EditorCode.TARGET_MM;
import static guru.nidi.graphviz.engine.Format.PNG;
import static guru.nidi.graphviz.engine.Graphviz.fromGraph;
import static java.awt.Toolkit.getDefaultToolkit;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Arrays;
import java.util.List;
import javax.swing.ImageIcon;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JMenu;
import javax.swing.JMenuItem;
import javax.swing.JScrollPane;

import com.dat3m.dartagnan.utils.Graph;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.ui.editor.EditorsPane;
import com.dat3m.ui.options.OptionsPane;
import com.dat3m.ui.result.Dat3mResult;
import com.dat3m.ui.utils.Task;

import guru.nidi.graphviz.model.MutableGraph;
import guru.nidi.graphviz.parse.Parser;

public class GraphOption implements ActionListener {

	private File dotFile = new File(".tmp/output.dot");
	private File pngFile = new File(".tmp/output.png");

	private final OptionsPane options;
	private final EditorsPane editor;
    private final JMenu menu;
    private final RelSelector selector;

    public GraphOption(OptionsPane options, EditorsPane editor) {
    	this.options = options;
    	this.editor = editor;
    	this.menu = new JMenu("Graph Options");
    	JMenuItem menuItem = new JMenuItem("Select Displayed Relations");
    	menuItem.setActionCommand("menu_graph_relations");
    	menuItem.addActionListener(this);
    	this.menu.add(menuItem);
    	this.selector = new RelSelector();
    }
 
    public JMenu getMenu(){
        return menu;
    }

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

	@Override
	public void actionPerformed(ActionEvent event) {
        if(event.getActionCommand().equals("menu_graph_relations")){
        	try {
				editor.getEditor(TARGET_MM).load();
	        	selector.setTMM((Wmm) editor.getEditor(TARGET_MM).getLoaded());
        	} catch (Exception e) {
				// Nothing to be done
			}
        	if(options.getOptions().getTask().equals(Task.PORTABILITY)) {
            	try {
					editor.getEditor(SOURCE_MM).load();
	            	selector.setSMM((Wmm) editor.getEditor(SOURCE_MM).getLoaded());        		
            	} catch (Exception e) {
					// Nothing to be done
				}
        	}
        	selector.open();
        }
	}
}
