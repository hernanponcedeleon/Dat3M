package com.dat3m.svcomp.utils;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.util.stream.IntStream;

public class SVCOMPSanitizer {

	String filePath;
	
	public SVCOMPSanitizer(String filePath) {
		this.filePath = filePath;
	}

	public File run(int bound) {
		File tmp = new File(filePath.substring(0, filePath.lastIndexOf('.')) + "_tmp.c");
		try {
			BufferedReader reader = new BufferedReader(new InputStreamReader(new FileInputStream(filePath)));
			PrintWriter writer = new PrintWriter(new OutputStreamWriter(new FileOutputStream(tmp)));
			for (String line; (line = reader.readLine()) != null;) {
				line = line.replace("void __VERIFIER_assert(int expression) { if (!expression) { ERROR: __VERIFIER_error(); }; return; }", "");
				line = line.replace("void __VERIFIER_assert(int expression) { if (!expression) { ERROR: __VERIFIER_error();}; return; }", "");
				// SMACK does not create procedure for inline functions
				if(!line.contains("__")) {
					line = line.replace("inline ", "");	
				}
				if(line.contains("while(1) { pthread_create(&t, 0, thr1, 0); }") || line.contains("while(1) pthread_create(&t, 0, thr1, 0);")) {
					line = line.replace("while(1) { pthread_create(&t, 0, thr1, 0); }", "");					
					line = line.replace("while(1) pthread_create(&t, 0, thr1, 0);", "");
					for(int i : IntStream.range(0, bound).toArray()) {
						writer.println("pthread_create(&t, 0, thr1, 0);");
					}
				}
			    writer.println(line);
			}
			reader.close();
			writer.close();
		} catch (IOException e) {
			System.out.println(e.getMessage());
            System.exit(0);
		}
		return tmp;
	}
}
