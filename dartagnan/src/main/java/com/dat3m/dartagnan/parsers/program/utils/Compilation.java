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
	
	public static void compileWithSmack(File file, String cflags) throws Exception {
		String name = file.getName().contains("_tmp") ?
				file.getName().substring(0, file.getName().lastIndexOf('_')) :
				file.getName().substring(0, file.getName().lastIndexOf('.'));

    	ArrayList<String> cmd = new ArrayList<String>();
    	cmd.add("smack");
    	// Needed to handle more than one flag in SMACK_FLAGS
    	for(String option : System.getenv().getOrDefault("SMACK_FLAGS", "").split(" ")) {
    		cmd.add(option);
    	}
    	// Here there is not need to iterate over CFLAG values
    	cflags = cflags.equals("") ? System.getenv().getOrDefault("CFLAGS", "") : cflags; 
        cmd.add("--clang-options=-I" + System.getenv("DAT3M_HOME") + "/include/smack -I" + 
        								System.getenv("DAT3M_HOME") + "/include/clang " + cflags);
    	cmd.addAll(asList("-bpl", System.getenv("DAT3M_OUTPUT") + "/" + name + ".bpl"));
    	cmd.add(file.getAbsolutePath());
    	
		logger.info("Compiling with smack");
    	logger.debug("Running " + String.join(" ", cmd));

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

	public static void compileWithClang(File file, String cflags) throws Exception {
		ArrayList<String> cmd = new ArrayList<String>();
    	cmd.addAll(asList("clang", "-S", "-I" + System.getenv("DAT3M_HOME") + "/include/clang", 
    			"-o", System.getenv("DAT3M_OUTPUT") + "/test.s"));
    	// Needed to handle more than one flag in CFLAGS
    	cflags = cflags.equals("") ? System.getenv().getOrDefault("CFLAGS", "") : cflags;
    	for(String option : cflags.split(" ")) {
    		cmd.add(option);
    	}
    	cmd.add(file.getAbsolutePath());
    	ProcessBuilder processBuilder = new ProcessBuilder(cmd);
    	logger.info("Compiling with clang");
    	logger.debug("Running " + String.join(" ", cmd));
    	Process proc = processBuilder.start();
    	proc.waitFor();
    	if(proc.exitValue() == 1) {
    		String errorString = CharStreams.toString(new InputStreamReader(proc.getErrorStream(), Charsets.UTF_8));
			throw new Exception(errorString);
    	}
    	File testFile = new File(System.getenv("DAT3M_OUTPUT") + "/test.s");
    	testFile.delete();
	}	

}
