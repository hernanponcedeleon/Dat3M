package com.dat3m.ui.utils;

import javax.swing.*;
import java.awt.*;

public class Utils {

    public static void showError(String msg, String title) {
        JTextArea textArea = new JTextArea(msg);
        JScrollPane scrollPane = new JScrollPane(textArea);
        Dimension size = new Dimension(Math.min(textArea.getPreferredSize().width + 1, 1000),
                Math.min(textArea.getPreferredSize().height + 1, 500));
        scrollPane.setPreferredSize(size);
        JOptionPane.showMessageDialog(null, scrollPane, title,
                JOptionPane.ERROR_MESSAGE);
    }

    public static void showError(String msg) {
        showError(msg, "Error");
    }
}
