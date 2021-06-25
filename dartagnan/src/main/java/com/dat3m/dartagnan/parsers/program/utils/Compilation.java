package com.dat3m.dartagnan.parsers.program.utils;

import static java.util.Arrays.asList;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStreamReader;
import java.util.ArrayList;

import com.dat3m.dartagnan.utils.options.DartagnanOptions;

public class Compilation {
	
	public static void compile(File file, DartagnanOptions opt, boolean ownAtomics) {
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
			if(proc.exitValue() == 1) {
				BufferedReader error = new BufferedReader(new InputStreamReader(proc.getErrorStream()));
				System.out.println("\nThere was a problem when compiling the file\n");
				while(error.ready()) {
					System.out.println(error.readLine());
				}
				System.exit(0);
			}
		} catch(Exception e) {
			System.out.println(e.getMessage());
			System.exit(0);
		}
	}	
}
