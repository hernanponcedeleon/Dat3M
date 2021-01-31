package com.dat3m.svcomp.utils;

import static java.util.Arrays.asList;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStreamReader;
import java.util.ArrayList;

import com.dat3m.svcomp.options.SVCOMPOptions;

public class Compilation {
	
	public static void compile(File file, SVCOMPOptions opt) {
		String name = file.getName().contains("_tmp") ?
				file.getName().substring(0, file.getName().lastIndexOf('_')) :
				file.getName().substring(0, file.getName().lastIndexOf('.'));

    	ArrayList<String> cmd = new ArrayList<String>();
    	cmd.addAll(asList("smack", "-q", "-t", "--no-memory-splitting"));
    	cmd.addAll(asList("--integer-encoding", opt.getEncoding()));
    	cmd.add("--clang-options=-DCUSTOM_VERIFIER_ASSERT -" + opt.getOptimization() + 
    			" -fno-vectorize -fno-slp-vectorize -I" + System.getenv().get("DAT3M_HOME") + "/include/");
    	cmd.addAll(asList("-bpl", System.getenv().get("DAT3M_HOME") + "/output/" + name + "-" + opt.getOptimization() + ".bpl"));
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
