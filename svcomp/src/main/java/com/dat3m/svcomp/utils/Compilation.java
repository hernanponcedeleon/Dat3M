package com.dat3m.svcomp.utils;

import static java.util.Arrays.asList;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStreamReader;
import java.util.ArrayList;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

@Options
public class Compilation {
	
	private static final Logger logger = LogManager.getLogger(Compilation.class);

	@Option(
		description="Optimization flag for LLVM compiler",
		secure=true)
	private String optimization = "O0";

	@Option(
		description="bit-vector=use SMT bit-vector theory, " +
			"unbounded-integer=use SMT integer theory, " +
			"wrapped-integer=use SMT integer theory but model wrap-around behavior" +
			" [default: unbounded-integer]",
		secure=true,
		regexp="bit-vector|unbounded-integer|wrapped-integer")
	private String integerEncoding = "unbounded-integer";

	public String getOptimization() {
		return optimization;
	}

	public void compile(File file, boolean ownAtomics) {
		String name = file.getName().contains("_tmp") ?
				file.getName().substring(0, file.getName().lastIndexOf('_')) :
				file.getName().substring(0, file.getName().lastIndexOf('.'));

    	ArrayList<String> cmd = new ArrayList<String>();
    	cmd.addAll(asList("smack", "-q", "-t", "--no-memory-splitting"));
    	cmd.addAll(asList("--integer-encoding", integerEncoding));
    	if(ownAtomics) {
        	cmd.add("--clang-options=-DCUSTOM_VERIFIER_ASSERT -" + optimization +
        			" -fno-vectorize -fno-slp-vectorize -I" + System.getenv().get("DAT3M_HOME") + "/include/");    		    		
    	} else {
        	cmd.add("--clang-options=-DCUSTOM_VERIFIER_ASSERT -" + optimization +
        			" -fno-vectorize -fno-slp-vectorize");    		
    	}
    	cmd.addAll(asList("-bpl", System.getenv().get("DAT3M_HOME") + "/output/" + name + "-" + optimization + ".bpl"));
    	cmd.add(file.getAbsolutePath());
    	
    	ProcessBuilder processBuilder = new ProcessBuilder(cmd); 
    	try {
		String msg = ownAtomics ? "Compiling with smack" : "Compiling with clang";
    		logger.info(msg);
        	Process proc = processBuilder.start();
        	proc.waitFor();
        	int tries = 1 ;
        	while(proc.exitValue() != 0 && tries < 100) {
        		logger.info(msg);
        		tries++;
            	proc = processBuilder.start();
            	proc.waitFor();
        	}
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