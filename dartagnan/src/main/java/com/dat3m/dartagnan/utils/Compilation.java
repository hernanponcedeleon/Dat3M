package com.dat3m.dartagnan.utils;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;

public class Compilation {
	
	public static void compile(File file, String flag, boolean bp) throws IOException {
		String path = file.getAbsolutePath();
		String name = path.contains("_tmp") ? path.substring(path.lastIndexOf('/'), path.lastIndexOf('_')) : path.substring(path.lastIndexOf('/'), path.lastIndexOf('.'));

    	ArrayList<String> cmd = new ArrayList<String>();
    	cmd.add("smack");
    	cmd.add("-q");
    	cmd.add("-t");
    	cmd.add("--no-memory-splitting");
    	if(bp) {
    		cmd.add("--integer-encoding");
    		cmd.add("bit-vector");
    	}
    	cmd.add("--clang-options=-DCUSTOM_VERIFIER_ASSERT -" + flag + " -fno-vectorize -fno-slp-vectorize -I./include/");
    	cmd.add("-bpl");
    	cmd.add("./output" + name + "-" + flag + ".bpl");
    	cmd.add(file.getAbsolutePath());
    	ProcessBuilder processBuilder = new ProcessBuilder(cmd); 
		try {
			processBuilder.start().waitFor();
		} catch(InterruptedException e) {
			System.out.println(e.getMessage());
			System.exit(0);
		}
	}	
}
