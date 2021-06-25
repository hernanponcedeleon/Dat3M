package com.dat3m.dartagnan.parsers.program.utils;

import static java.util.Arrays.asList;

import java.io.File;
import java.io.InputStreamReader;
import java.util.ArrayList;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.google.common.base.Charsets;
import com.google.common.io.CharStreams;

public class Compilation {
	
	private static final Logger logger = LogManager.getLogger(Compilation.class);
	
	public static void compile(File file, boolean ownAtomics) throws Exception {
		String name = file.getName().substring(0, file.getName().lastIndexOf('.'));

    	ArrayList<String> cmd = new ArrayList<String>();
    	cmd.addAll(asList("smack", "-q", "-t", "--no-memory-splitting"));
    	if(ownAtomics) {
        	cmd.add("--clang-options=-DCUSTOM_VERIFIER_ASSERT -fno-vectorize -fno-slp-vectorize -I" + System.getenv().get("DAT3M_HOME") + "/include/");    		    		
    	} else {
        	cmd.add("--clang-options=-DCUSTOM_VERIFIER_ASSERT -fno-vectorize -fno-slp-vectorize");    		
    	}
    	cmd.addAll(asList("-bpl", System.getenv().get("DAT3M_HOME") + "/output/" + name + ".bpl"));
    	cmd.add(file.getAbsolutePath());
    	
    	ProcessBuilder processBuilder = new ProcessBuilder(cmd); 
    	Process proc = processBuilder.start();
    	proc.waitFor();
    	int tries = 1 ;
    	while(proc.exitValue() != 0 && tries < 100) {
    		String errorString = CharStreams.toString(new InputStreamReader(proc.getErrorStream(), Charsets.UTF_8));
			if(errorString.contains("compile_to_bc")) {
				throw new Exception(errorString);
    		}
    		logger.info("Compiling with smack");
    		tries++;
        	proc = processBuilder.start();
        	proc.waitFor();
    	}
	}	
}
