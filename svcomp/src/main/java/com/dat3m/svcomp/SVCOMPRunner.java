package com.dat3m.svcomp;

import static com.dat3m.dartagnan.utils.options.BaseOptions.*;
import static com.dat3m.dartagnan.utils.options.DartagnanOptions.*;
import static com.dat3m.dartagnan.witness.GraphAttributes.UNROLLBOUND;
import static com.dat3m.svcomp.utils.Compilation.compile;
import static java.lang.Integer.parseInt;
import static java.util.Arrays.asList;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.file.Paths;
import java.util.ArrayList;

import org.apache.commons.cli.ParseException;

import com.dat3m.dartagnan.parsers.witness.ParserWitness;
import com.dat3m.dartagnan.witness.WitnessGraph;
import com.dat3m.svcomp.options.SVCOMPOptions;
import com.dat3m.svcomp.utils.BoogieSan;
import com.dat3m.svcomp.utils.SVCOMPSanitizer;
import com.google.common.base.Preconditions;

public class SVCOMPRunner {

    public static void main(String[] args) throws IOException {
    	
		try {
			SVCOMPOptions options = SVCOMPOptions.fromArgs(args);
	        
			WitnessGraph witness = new WitnessGraph();
	        if(options.getWitnessPath() != null) {
	        	Preconditions.checkArgument(Paths.get(options.getProgramFilePath()).getFileName().toString().
						equals(Paths.get(witness.getProgram()).getFileName().toString()), 
						"The witness was generated from a different program than " + options.getProgramFilePath());
	        	witness = new ParserWitness().parse(new File(options.getWitnessPath()));
	        }
	        
	        File file = new File(options.getProgramFilePath());
	        int bound = witness.hasAttributed(UNROLLBOUND.toString()) ?  parseInt(witness.getAttributed(UNROLLBOUND.toString())) : options.getUMin();
	        File tmp = new SVCOMPSanitizer(file).run(bound);
	        // First time we compiler with standard atomic header to catch compilation problems
	        compile(tmp, options, false);

			String output = "UNKNOWN";
			while(output.equals("UNKNOWN")) {
				compile(tmp, options, true);
		        // If not removed here, file is not removed when we reach the timeout
		        // File can be safely deleted since it was created by the SVCOMPSanitizer
		        // (it not the original C file) and we already created the Boogie file
		        tmp.delete();

		        String boogieName = System.getenv("DAT3M_HOME") + "/output/" +
						file.getName().substring(0, file.getName().lastIndexOf('.')) +
						"-" + options.getOptimization() + ".bpl";
		        
		        if(options.getBoogieSan()) {
		        	BoogieSan.write(boogieName);
		        }
		        
		    	ArrayList<String> cmd = new ArrayList<String>();
		    	cmd.add("java");
		    	cmd.add("-Dlog4j.configurationFile=" + System.getenv("DAT3M_HOME") + "/dartagnan/src/main/resources/log4j2.xml");
		    	cmd.add("-DLOGNAME=" + file.getName());
		    	cmd.addAll(asList("-jar", System.getenv("DAT3M_HOME") + "/dartagnan/target/dartagnan-3.0.0.jar"));
		    	cmd.addAll(asList("-" + INPUT_OPTION, boogieName));
		    	cmd.addAll(asList("-" + CAT_OPTION, options.getTargetModelFilePath()));
		    	cmd.addAll(asList("-" + TARGET_OPTION, options.getTarget().asStringOption()));
		    	cmd.addAll(asList("-" + UNROLL_OPTION, String.valueOf(bound)));
		    	cmd.addAll(asList("-" + ANALYSIS_OPTION, options.getAnalysis().asStringOption()));
		    	cmd.addAll(asList("-" + METHOD_OPTION, options.getMethod().asStringOption()));
		    	cmd.addAll(asList("-" + SMTSOLVER_OPTION, options.getSMTSolver().toString().toLowerCase()));
		    	if(options.getWitnessPath() != null) {
		    		// In validation mode we do not create witnesses.
		    		cmd.addAll(asList("-" + WITNESS_PATH_OPTION, options.getWitnessPath()));
		    	} else {
		    		// In verification mode we always create a witness.
		    		cmd.addAll(asList("-" + WITNESS_OPTION, options.getProgramFilePath()));	
		    	}

		    	ProcessBuilder processBuilder = new ProcessBuilder(cmd);
		        try {
		        	Process proc = processBuilder.start();
					BufferedReader read = new BufferedReader(new InputStreamReader(proc.getInputStream()));
					proc.waitFor();
					while(read.ready()) {
						output = read.readLine();
						System.out.println(output);
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
				if(bound > options.getUMax()) {
					System.out.println("PASS");
					break;
				}
				// We always do iterations 1 and 2 and then use the step
				bound = bound == 1 ? 2 : bound + options.getStep();
		        tmp = new SVCOMPSanitizer(file).run(bound);
			}

	        tmp.delete();
	        return;

		} catch (ParseException e) {
			// SVCOMPOptions will print the options help
			System.exit(0);
		}        
    }
}
