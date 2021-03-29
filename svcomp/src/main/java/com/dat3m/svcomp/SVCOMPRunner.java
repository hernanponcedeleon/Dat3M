package com.dat3m.svcomp;

import static com.dat3m.svcomp.utils.Compilation.compile;
import static java.util.Arrays.asList;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStreamReader;
import java.util.ArrayList;

import org.apache.commons.cli.HelpFormatter;

import com.dat3m.svcomp.options.SVCOMPOptions;
import com.dat3m.svcomp.utils.SVCOMPSanitizer;

public class SVCOMPRunner {

    public static void main(String[] args) {
    	SVCOMPOptions options = new SVCOMPOptions();
        try {
            options.parse(args);
        }
        catch (Exception e){
            if(e instanceof UnsupportedOperationException){
                System.out.println(e.getMessage());
            }
            new HelpFormatter().printHelp("SVCOMP Runner", options);
            System.exit(1);
            return;
        }

        File file = new File(options.getProgramFilePath());
        File tmp = new SVCOMPSanitizer(file).run(1);

        int bound = 1;
		String output = "UNKNOWN";
		while(output.equals("UNKNOWN")) {
			compile(tmp, options);
	        // If not removed here, file is not removed when we reach the timeout
	        // File can be safely deleted since it was created by the SVCOMPSanitizer
	        // (it not the original C file) and we already created the Boogie file
	        tmp.delete();

	    	ArrayList<String> cmd = new ArrayList<String>();
	    	cmd.addAll(asList("java", "-DLOG_DIR=./output/log", "-jar", "dartagnan/target/dartagnan-2.0.7-jar-with-dependencies.jar"));
	    	cmd.addAll(asList("-i", System.getenv().get("DAT3M_HOME") + "/output/" +
				file.getName().substring(0, file.getName().lastIndexOf('.')) +
				"-" + options.getOptimization() + ".bpl"));
	    	cmd.addAll(asList("-cat", options.getTargetModelFilePath()));
	    	cmd.addAll(asList("-t", "none"));
	    	cmd.addAll(asList("-unroll", String.valueOf(bound)));
	    	cmd.addAll(asList("-analysis", options.getAnalysis().toString()));
	    	if(options.useISolver()) {
	    		cmd.add("-incremental_solver");
	    	}
	    	if(options.createWitness()) {
	    		cmd.addAll(asList("-w", options.getProgramFilePath()));
	    	}

	    	ProcessBuilder processBuilder = new ProcessBuilder(cmd);
	        try {
	        	Process proc = processBuilder.start();
				BufferedReader read = new BufferedReader(new InputStreamReader(proc.getInputStream()));
				proc.waitFor();
				while(read.ready()) {
					output = read.readLine();
				}
				if(proc.exitValue() == 1) {
					BufferedReader error = new BufferedReader(new InputStreamReader(proc.getErrorStream()));
					while(error.ready()) {
						System.out.println(error.readLine());
					}
					System.exit(0);
				}
			} catch(Exception e) {
				System.out.println(e.getMessage());
				System.exit(0);
			}
			bound++;
	        tmp = new SVCOMPSanitizer(file).run(bound);
		}
		output = output.equals("PASS") ? "PASS" : "FAIL";
		System.out.println(output);

        tmp.delete();
        return;
    }
}
