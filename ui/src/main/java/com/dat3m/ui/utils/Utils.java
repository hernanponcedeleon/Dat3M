package com.dat3m.ui.utils;

import javax.swing.JOptionPane;

import com.dat3m.ui.icon.IconCode;
import com.dat3m.ui.icon.IconHelper;

public class Utils {
	
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
}
