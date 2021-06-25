package com.dat3m.dartagnan.parsers.program.utils;

import static java.util.Arrays.asList;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStreamReader;
import java.util.ArrayList;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class Compilation {
	
	private static final Logger logger = LogManager.getLogger(Compilation.class);
	
	public static void compile(File file, boolean ownAtomics) {
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
    	try {
        	Process proc = processBuilder.start();
        	proc.waitFor();
        	int tries = 1 ;
        	while(proc.exitValue() != 0 && tries < 100) {
        		logger.info("Compiling with smack");
        		tries++;
            	proc = processBuilder.start();
            	proc.waitFor();
        	}
			if(proc.exitValue() == 1) {
				BufferedReader error = new BufferedReader(new InputStreamReader(proc.getErrorStream()));
				System.out.println("\nThere was a problem when compiling the file with smack\n");
				while(error.ready()) {
					System.out.println(error.readLine());
				}
			}
		} catch(Exception e) {
			System.out.println(e.getMessage());
			System.exit(0);
		}
	}	
}
