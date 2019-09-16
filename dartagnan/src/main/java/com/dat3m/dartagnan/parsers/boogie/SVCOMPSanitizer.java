package com.dat3m.dartagnan.parsers.boogie;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;

public class SVCOMPSanitizer {

	String filePath;
	
	public SVCOMPSanitizer(String filePath) {
		this.filePath = filePath;
	}

	public File run() {
		File file = new File(filePath);
		try {
			String path = file.getAbsolutePath();
			File tmp = new File(path.substring(0, path.lastIndexOf('.')) + "_tmp.c");
			tmp.createNewFile();
			BufferedReader reader = new BufferedReader(new InputStreamReader(new FileInputStream(file)));
			PrintWriter writer = new PrintWriter(new OutputStreamWriter(new FileOutputStream(tmp)));
			for (String line; (line = reader.readLine()) != null;) {
			    line = line.replace("void __VERIFIER_assert(int expression) { if (!expression) { ERROR: __VERIFIER_error(); }; return; }", "");					
			    line = line.replace("NULL", "0");
			    writer.println(line);
			}
			reader.close();
			writer.close();
			return tmp;
		} catch (IOException e) {
			System.out.println(e.getMessage());
		}
		return file;
	}
}
