package com.dat3m.ui.utils;

import static java.lang.Math.round;

import java.awt.GraphicsDevice;
import java.awt.GraphicsEnvironment;
import java.net.URL;

import javax.swing.JOptionPane;

import com.dat3m.ui.Dat3M;
import com.dat3m.ui.icon.IconCode;
import com.dat3m.ui.icon.IconHelper;

public class Utils {

	public static int getMainScreenWidth() {
		GraphicsEnvironment ge = GraphicsEnvironment.getLocalGraphicsEnvironment();
	    GraphicsDevice[] gs = ge.getScreenDevices();
	    if (gs.length > 0) {
	        return round(gs[0].getDisplayMode().getWidth());
	    }
	    return 0;
	}
	
	public static int getMainScreenHeight() {
		GraphicsEnvironment ge = GraphicsEnvironment.getLocalGraphicsEnvironment();
	    GraphicsDevice[] gs = ge.getScreenDevices();
	    if (gs.length > 0) {
	        return round(gs[0].getDisplayMode().getHeight());
	    }
	    return 0;
	}
	
	public static void showError(String msg, String title){
        JOptionPane.showMessageDialog(
                null,
                msg,
                title,
                JOptionPane.ERROR_MESSAGE,
                IconHelper.getIcon(IconCode.DAT3M, 60));
    }

	public static void showError(String msg){
		showError(msg, "Error");
    }
	
    public static URL getResource(String filename){
        return Dat3M.class.getResource(filename);
    }
}
