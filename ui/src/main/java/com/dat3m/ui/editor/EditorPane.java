package com.dat3m.ui.editor;

import com.dat3m.ui.icon.IconCode;
import com.dat3m.ui.icon.IconHelper;
import com.google.common.collect.ImmutableSet;

import javax.swing.*;
import javax.swing.border.TitledBorder;
import javax.swing.filechooser.FileNameExtensionFilter;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Arrays;

import static java.lang.System.getProperty;
import static javax.swing.BorderFactory.createTitledBorder;
import static javax.swing.JFileChooser.APPROVE_OPTION;

public class EditorPane extends JScrollPane implements ActionListener {

    private final JEditorPane editorPane;
    private final JMenuItem menuItem;
    private final JFileChooser chooser;
    private final ImmutableSet<String> allowedFormats;

    private String loadedFormat = "";

    EditorPane(EditorCode code, JEditorPane editorPane, String... formats){
        super(editorPane);
        this.editorPane = editorPane;
        this.menuItem = new JMenuItem(code.toString());
        menuItem.addActionListener(this);

        this.allowedFormats = ImmutableSet.copyOf(Arrays.asList(formats));
        this.chooser = new JFileChooser();
        for(String format : allowedFormats) {
            chooser.addChoosableFileFilter(new FileNameExtensionFilter("*." + format, format));
        }

        setVerticalScrollBarPolicy(JScrollPane.VERTICAL_SCROLLBAR_AS_NEEDED);
        setHorizontalScrollBarPolicy(JScrollPane.HORIZONTAL_SCROLLBAR_AS_NEEDED);

        TitledBorder border = createTitledBorder(code.toString());
        border.setTitleJustification(TitledBorder.CENTER);
        setBorder(border);
    }

    JEditorPane getEditor(){
        return editorPane;
    }

    JMenuItem getMenuItem(){
        return menuItem;
    }

    String getLoadedFormat(){
        return loadedFormat;
    }

    @Override
    public void actionPerformed(ActionEvent event) {
        Object source = event.getSource();
        if(source instanceof JMenuItem){
            chooser.setCurrentDirectory(new File(getProperty("user.dir") + "/.."));
            int result = chooser.showOpenDialog(null);
            if(result == APPROVE_OPTION){
                String path = chooser.getSelectedFile().getPath();
                loadedFormat = path.substring(path.lastIndexOf('.') + 1).trim();

                if(allowedFormats.contains(loadedFormat)){
                    try {
                        editorPane.read(new InputStreamReader(new FileInputStream(path)), null);
                    } catch (IOException e) {
                        e.printStackTrace();
                        JOptionPane.showMessageDialog(
                                null,
                                "Error reading input file",
                                "Error",
                                JOptionPane.ERROR_MESSAGE,
                                IconHelper.getIcon(IconCode.DAT3M));
                    }
                } else {
                    JOptionPane.showMessageDialog(
                            null,
                            "Please select a *." + String.join(", *.", allowedFormats) + " file",
                            "Invalid file format",
                            JOptionPane.INFORMATION_MESSAGE,
                            IconHelper.getIcon(IconCode.DAT3M));
                }
            }
        }
    }
}
