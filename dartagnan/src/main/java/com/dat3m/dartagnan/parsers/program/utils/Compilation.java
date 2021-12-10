package com.dat3m.dartagnan.parsers.program.utils;

import com.google.common.base.Charsets;
import com.google.common.io.CharStreams;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.io.File;
import java.io.InputStreamReader;
import java.util.ArrayList;

import static java.util.Arrays.asList;

public class Compilation {
	
	private static final Logger logger = LogManager.getLogger(Compilation.class);
	
	public static void compileWithSmack(File file) throws Exception {
		String name = file.getName().substring(0, file.getName().lastIndexOf('.'));
		String clangFlags = System.getenv().get("CFLAGS") != null ? System.getenv().get("CFLAGS") : "";
		
    	ArrayList<String> cmd = new ArrayList<String>();
    	cmd.addAll(asList("smack", "-q", "-t", "--no-memory-splitting"));
        cmd.add("--clang-options=-I" + System.getenv().get("DAT3M_HOME") + "/include/ " + clangFlags);
    	cmd.addAll(asList("-bpl", System.getenv().get("DAT3M_HOME") + "/output/" + name + ".bpl"));
    	cmd.add(file.getAbsolutePath());
    	
    	ProcessBuilder processBuilder = new ProcessBuilder(cmd); 
    	Process proc = processBuilder.start();
    	proc.waitFor();
    	int tries = 1 ;
    	while(proc.exitValue() != 0 && tries < 100) {
    		try (InputStreamReader reader = new InputStreamReader(proc.getErrorStream(), Charsets.UTF_8)) {
				String errorString = CharStreams.toString(reader);
				if(errorString.contains("compile_to_bc")) {
					throw new Exception(errorString);
				}
			}
    		logger.info("Compiling with smack");
    		tries++;
        	proc = processBuilder.start();
        	proc.waitFor();
    	}
	}	

	public static void compileWithClang(File file) throws Exception {
		String clangFlags = System.getenv().get("CFLAGS") != null ? System.getenv().get("CFLAGS") : "";
		
    	ArrayList<String> cmd = new ArrayList<String>();
    	cmd.addAll(asList("clang", "-S", clangFlags, "-o"));
    	cmd.add(System.getenv().get("DAT3M_HOME") + "/output/test.s");
    	cmd.add(file.getAbsolutePath());
    	ProcessBuilder processBuilder = new ProcessBuilder(cmd);
    	logger.info("Compiling with clang");
    	Process proc = processBuilder.start();
    	proc.waitFor();
    	if(proc.exitValue() == 1) {
    		String errorString = CharStreams.toString(new InputStreamReader(proc.getErrorStream(), Charsets.UTF_8));
			throw new Exception(errorString);
    	}
    	File testFile = new File(System.getenv().get("DAT3M_HOME") + "/output/test.s");
    	testFile.delete();
	}	

}
