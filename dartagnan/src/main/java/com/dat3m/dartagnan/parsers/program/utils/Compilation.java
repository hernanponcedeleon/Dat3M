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
	
	public static void compileWithClang(File file, String cflags) throws Exception {
		String name = file.getName().substring(0, file.getName().lastIndexOf('.'));		
		ArrayList<String> cmd = new ArrayList<String>();
    	cmd.addAll(asList("clang", "-S", "-I" + System.getenv("DAT3M_HOME") + "/include/clang", 
    			"-emit-llvm", "-o", System.getenv("DAT3M_OUTPUT") + "/" + name + ".ll"));
		// We use cflags when using the UI and fallback top CFLAGS otherwise
		cflags = cflags.equals("") ? System.getenv().getOrDefault("CFLAGS", "") : cflags;
    	// Needed to handle more than one flag in CFLAGS
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
	}	

	public static void applyAtomicReplacePass(File file) throws Exception {
		String name = file.getName().substring(0, file.getName().lastIndexOf('.'));		
		ArrayList<String> cmd = new ArrayList<String>();
    	cmd.addAll(asList("opt", "-enable-new-pm=0", "-load=" + System.getenv("DAT3M_PASSES_HOME") + 
			"/atomic-replace.so", "-atomic-replace", System.getenv("DAT3M_OUTPUT") + "/" + name + ".ll", 
			"-S", "-o", System.getenv("DAT3M_OUTPUT") + "/" + name + "-opt.ll"));
    	ProcessBuilder processBuilder = new ProcessBuilder(cmd);
    	logger.info("Running LLVM passes");
    	logger.debug("Running " + String.join(" ", cmd));
    	Process proc = processBuilder.start();
    	proc.waitFor();
    	if(proc.exitValue() == 1) {
    		String errorString = CharStreams.toString(new InputStreamReader(proc.getErrorStream(), Charsets.UTF_8));
			throw new Exception(errorString);
    	}
	}

	public static void compileWithSmack(File file, String cflags) throws Exception {
		String name = file.getName().substring(0, file.getName().lastIndexOf('.'));
    	ArrayList<String> cmd = new ArrayList<String>();
    	cmd.add("smack");
    	// Needed to handle more than one flag in SMACK_FLAGS
    	for(String option : System.getenv().getOrDefault("SMACK_FLAGS", "").split(" ")) {
    		cmd.add(option);
    	}
    	cmd.addAll(asList("-bpl", System.getenv("DAT3M_OUTPUT") + "/" + name + ".bpl", 
			System.getenv("DAT3M_OUTPUT") + "/" + name + "-opt.ll"));
    	
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
}
