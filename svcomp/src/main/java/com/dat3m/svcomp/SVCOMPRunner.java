package com.dat3m.svcomp;

import static com.dat3m.dartagnan.utils.options.BaseOptions.SMTSOLVER_OPTION;
import static com.dat3m.dartagnan.utils.options.DartagnanOptions.ANALYSIS_OPTION;
import static com.dat3m.dartagnan.utils.options.DartagnanOptions.METHOD_OPTION;
import static com.dat3m.dartagnan.utils.options.DartagnanOptions.WITNESS_OPTION;
import static com.dat3m.dartagnan.utils.options.DartagnanOptions.WITNESS_PATH_OPTION;
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

import org.apache.commons.cli.HelpFormatter;

import com.dat3m.dartagnan.parsers.witness.ParserWitness;
import com.dat3m.dartagnan.witness.WitnessGraph;
import com.dat3m.svcomp.options.SVCOMPOptions;
import com.dat3m.svcomp.utils.BoogieSan;
import com.dat3m.svcomp.utils.SVCOMPSanitizer;

public class SVCOMPRunner {

    public static void main(String[] args) throws IOException {
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
        
        WitnessGraph witness = new WitnessGraph(); 
        if(options.getWitnessPath() != null) {
        	witness = new ParserWitness().parse(new File(options.getWitnessPath()));
			if(!Paths.get(options.getProgramFilePath()).getFileName().toString().
					equals(Paths.get(witness.getProgram()).getFileName().toString())) {
				throw new RuntimeException("The witness was generated from a different program than " + options.getProgramFilePath());
			}
        }
        
        File file = new File(options.getProgramFilePath());
        int bound = witness.hasAttributed(UNROLLBOUND.toString()) ?  parseInt(witness.getAttributed(UNROLLBOUND.toString())) : options.getUMin();
        File tmp = new SVCOMPSanitizer(file).run(bound);
        // First time we compiler with standard atomic header to catch compilation problems
        compile(tmp, options, false);

		String output = "UNKNOWN";
		while(output.equals("UNKNOWN")) {
			if(bound == options.getUMax()+1) {
				System.out.println("PASS");
				break;
			}
			compile(tmp, options, true);
	        // If not removed here, file is not removed when we reach the timeout
	        // File can be safely deleted since it was created by the SVCOMPSanitizer
	        // (it not the original C file) and we already created the Boogie file
	        tmp.delete();

	        String boogieName = System.getenv().get("DAT3M_HOME") + "/output/" +
					file.getName().substring(0, file.getName().lastIndexOf('.')) +
					"-" + options.getOptimization() + ".bpl";
	        
	        if(options.getBoogieSan()) {
	        	BoogieSan.write(boogieName);
	        }
	        
	    	ArrayList<String> cmd = new ArrayList<String>();
	    	cmd.add("java");
	    	cmd.add("-Dlog4j.configurationFile=" + System.getenv().get("DAT3M_HOME") + "/dartagnan/src/main/resources/log4j2.xml");
	    	cmd.add("-DLOGNAME=" + file.getName());
	    	cmd.addAll(asList("-jar", System.getenv().get("DAT3M_HOME") + "/dartagnan/target/dartagnan-2.0.7.jar"));
	    	cmd.addAll(asList("-i", boogieName));
	    	cmd.addAll(asList("-cat", options.getTargetModelFilePath()));
	    	cmd.addAll(asList("-t", options.getTarget().asStringOption()));
	    	cmd.addAll(asList("-alias", options.getSettings().getAlias().asStringOption()));
	    	cmd.addAll(asList("-unroll", String.valueOf(bound)));
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
			bound = bound + options.getStep();
	        tmp = new SVCOMPSanitizer(file).run(bound);
		}

        tmp.delete();
        return;
    }
}
