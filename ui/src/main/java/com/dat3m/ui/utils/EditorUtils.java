package com.dat3m.ui.utils;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.Writer;

import javax.swing.JEditorPane;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.Arch;

public class EditorUtils {

	static final String TMPPROGPATH = "./.tmp/program";
	static final String TMPMMPATH = "./.tmp/mm.cat";

	public static Program parseProgramEditor(JEditorPane editor, String loadedFormat) throws IOException {
		File tmpProgramFile = new File(TMPPROGPATH + loadedFormat);
		if (!tmpProgramFile.getParentFile().exists()) {
			tmpProgramFile.getParentFile().mkdirs();
		}
		if (!tmpProgramFile.exists()) {
			tmpProgramFile.createNewFile();
		}
		Writer writer = new PrintWriter(tmpProgramFile);
		writer.write(editor.getText());
		writer.close();	
	    Program p = new ProgramParser().parse(TMPPROGPATH + loadedFormat);
		tmpProgramFile.delete();
		return p;
	}

	public static Wmm parseMMEditor(JEditorPane editor, Arch target) throws IOException {
		File tmpMMFile = new File(TMPMMPATH);
		if (!tmpMMFile.exists()) {
			tmpMMFile.createNewFile();
		}
		PrintWriter writer = new PrintWriter(tmpMMFile);
		writer.write(editor.getText());
		writer.close();
		Wmm mm = new ParserCat().parse(TMPMMPATH, target);
		tmpMMFile.delete();
		return mm;
	}
}
