package com.dat3m.ui.utils;

import java.awt.Dimension;

import javax.swing.JOptionPane;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;

public class Utils {
	
	public static void showError(String msg, String title){
		JTextArea textArea = new JTextArea(msg);
		JScrollPane scrollPane = new JScrollPane(textArea);  
		scrollPane.setPreferredSize( new Dimension( 1000 , 500 ) );
		JOptionPane.showMessageDialog(null, scrollPane, title,  
				JOptionPane.ERROR_MESSAGE);
    }

	public static void showError(String msg){
		showError(msg, "Error");
    }
}
