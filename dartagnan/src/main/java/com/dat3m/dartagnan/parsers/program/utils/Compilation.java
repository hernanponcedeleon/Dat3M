package com.dat3m.dartagnan.parsers.program.utils;

import com.google.common.base.Charsets;
import com.google.common.io.CharStreams;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.io.File;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import static java.util.Arrays.asList;

public class Compilation {
	
	private static final Logger logger = LogManager.getLogger(Compilation.class);
	
	public static File compileWithClang(File file, String cflags) throws Exception {
		String output = getOutputName(file, ".ll");		
		
		ArrayList<String> cmd = new ArrayList<String>();
		cmd.addAll(asList("clang", "-Xclang", "-disable-O0-optnone", "-S", 
			"-emit-llvm", "-g", "-gcolumn-info", "-o", output));
		// We use cflags when using the UI and fallback top CFLAGS otherwise
		cflags = cflags.equals("") ? System.getenv().getOrDefault("CFLAGS", "") : cflags;
		// Needed to handle more than one flag in CFLAGS
		for(String option : cflags.split(" ")) {
			cmd.add(option);
		}
		cmd.add(file.getAbsolutePath());
		
		return runCmd(cmd, output);
	}

	public static File applyLlvmPasses(File file) throws Exception {
		ArrayList<String> cmd = new ArrayList<String>();
		String output = getOutputName(file, "-opt.ll");		
		cmd.addAll(asList("atomic-replace", file.getAbsolutePath(), output));
		return runCmd(cmd, output);
	}

	public static File compileWithSmack(File file, String cflags) throws Exception {
		String output = getOutputName(file, ".bpl");

    	ArrayList<String> cmd = new ArrayList<String>();
    	cmd.add("smack");
    	// Needed to handle more than one flag in SMACK_FLAGS
    	for(String option : System.getenv().getOrDefault("SMACK_FLAGS", "").split(" ")) {
    		cmd.add(option);
    	}
		cmd.add("--clang-options=" + cflags);
    	cmd.addAll(asList("-bpl", output, file.getAbsolutePath()));
    	
		return runCmd(cmd, output);
	}	

	private static String getOutputName(File file, String postfix) {
		return System.getenv("DAT3M_OUTPUT") + "/" + 
			file.getName().substring(0, file.getName().lastIndexOf('.')) + postfix;
	}

	private static File runCmd(ArrayList<String> cmd, String outputFileName) throws Exception {
		ProcessBuilder processBuilder = new ProcessBuilder(cmd);
    	logger.debug(String.join(" ", cmd));
    	Process proc = processBuilder.start();
    	proc.waitFor();
    	if(proc.exitValue() == 1) {
    		String errorString = CharStreams.toString(new InputStreamReader(proc.getErrorStream(), Charsets.UTF_8));
			throw new Exception(errorString);
    	}
		return new File(outputFileName);	
	}
}
