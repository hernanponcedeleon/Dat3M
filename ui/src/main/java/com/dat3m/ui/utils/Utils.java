package com.dat3m.ui.utils;

import static java.lang.Math.round;

import java.awt.GraphicsDevice;
import java.awt.GraphicsEnvironment;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.Writer;
import java.net.URL;

import javax.swing.JEditorPane;
import javax.swing.JOptionPane;

import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.dat3m.ui.Dat3M;
import com.dat3m.ui.icon.IconCode;
import com.dat3m.ui.icon.IconHelper;

public class Utils {

	private static final String TMPPROGPATH = "./.tmp/program.";
	private static final String TMPMMPATH = "./.tmp/mm.cat";

	public static Program parseProgramEditor(JEditorPane editor, String loadedFormat) throws IOException {
		String path = TMPPROGPATH + loadedFormat;
		File tmpProgramFile = createTmpFile(editor, path);	
	    Program p = new ProgramParser().parse(path);
		tmpProgramFile.delete();
		return p;
	}

	public static Wmm parseMMEditor(JEditorPane editor, Arch target) throws IOException {
		File tmpMMFile = createTmpFile(editor, TMPMMPATH);
		Wmm mm = new ParserCat().parse(TMPMMPATH);
		tmpMMFile.delete();
		return mm;
	}
	
	private static File createTmpFile(JEditorPane editor, String path) throws IOException {
		File tmpProgramFile = new File(path);
		if (!tmpProgramFile.getParentFile().exists()) {
			tmpProgramFile.getParentFile().mkdirs();
		}
		if (!tmpProgramFile.exists()) {
			tmpProgramFile.createNewFile();
		}
		Writer writer = new PrintWriter(tmpProgramFile);
		writer.write(editor.getText());
		writer.close();
		return tmpProgramFile;
	}
	
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
