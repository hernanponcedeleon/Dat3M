package com.dat3m.ui.utils;

import static java.lang.System.getProperty;
import static java.util.stream.Collectors.joining;
import static javax.swing.JFileChooser.APPROVE_OPTION;
import static javax.swing.JOptionPane.showMessageDialog;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.List;

import javax.swing.JEditorPane;
import javax.swing.JFileChooser;
import javax.swing.JMenuItem;
import javax.swing.JOptionPane;
import javax.swing.filechooser.FileNameExtensionFilter;

import com.dat3m.ui.Dat3M;

public class ImporterMenuItem extends JMenuItem {

	String loadedFormat = "";
	
	public ImporterMenuItem(String label, JFileChooser chooser, List<String> extensions, JEditorPane editor) {
		super(label);

		chooser.setCurrentDirectory(new File(getProperty("user.dir") + "/.."));
		for(String ext : extensions) {
			chooser.addChoosableFileFilter(new FileNameExtensionFilter("*." + ext, ext));			
		}
				
		addActionListener(new ActionListener(){
			public void actionPerformed(ActionEvent event){
				int r = chooser.showOpenDialog(null);
				if(r == APPROVE_OPTION){
					String path = chooser.getSelectedFile().getPath();
					loadedFormat = path.substring(path.lastIndexOf('.') + 1).trim();
					if(!extensions.contains(loadedFormat)) {
						showMessageDialog(null, "Please select a *." + extensions.stream().collect(joining(", *.")) + " file", "About", JOptionPane.INFORMATION_MESSAGE, Dat3M.dat3mIcon);	
						return;
					}
					try {
						editor.read(new InputStreamReader(new FileInputStream(path)), null);
					} catch (IOException e) {
						e.printStackTrace();
					}
				}
			}
		});

	}
	
	public String getLoadedFormat() {
		return loadedFormat;
	}
	
}
