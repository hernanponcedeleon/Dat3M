package com.dat3m.svcomp;

import com.dat3m.dartagnan.parsers.witness.ParserWitness;
import com.dat3m.dartagnan.utils.options.BaseOptions;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.witness.WitnessGraph;
import com.dat3m.svcomp.utils.BoogieSan;
import com.dat3m.svcomp.utils.SVCOMPSanitizer;
import com.google.common.collect.ImmutableSet;
import com.google.common.io.Files;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStreamReader;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.configuration.OptionInfo.collectOptions;
import static com.dat3m.dartagnan.configuration.OptionNames.*;
import static com.dat3m.dartagnan.parsers.program.utils.Compilation.*;
import static com.dat3m.dartagnan.witness.GraphAttributes.UNROLLBOUND;
import static java.lang.Integer.parseInt;

@Options
public class SVCOMPRunner extends BaseOptions {

	private Property property;

	@Option(
		name= PROPERTYPATH,
		required=true,
		description="The path to the property to be checked.")
	private void property(String p) {
		//TODO process the property file instead of assuming its contents based of its name
		if(p.contains("no-data-race")) {
			property = Property.RACES;
		} else if(p.contains("unreach-call")) {
			property = Property.REACHABILITY;
		} else {
			throw new IllegalArgumentException("Unrecognized property " + p);
		}
	}

	@Option(
		name=UMIN,
		description="Starting unrolling bound <integer>.")
	private int umin = 1;

	@Option(
		name=UMAX,
		description="Ending unrolling bound <integer>.")
	private int umax = Integer.MAX_VALUE;

	@Option(
		name=STEP,
		description="Step size for the increasing unrolling bound <integer>.")
	private int step = 1;

	@Option(
		name=SANITIZE,
		description="Generates (also) a sanitised boogie file saved as /output/boogiesan.bpl.")
	private boolean sanitize = false;

	@Option(
		name=VALIDATE,
		description="Run Dartagnan as a violation witness validator. Argument is the path to the witness file.")
	private String witnessPath;

	private static final Set<String> supportedFormats = 
    		ImmutableSet.copyOf(Arrays.asList(".c", ".i"));

    public static void main(String[] args) throws Exception {

        if(Arrays.asList(args).contains("--help")) {
            collectOptions();
            return;
        }

		if(Arrays.stream(args).noneMatch(a -> supportedFormats.stream().anyMatch(a::endsWith))) {
			throw new IllegalArgumentException("Input program not given or format not recognized");
		}
		if(Arrays.stream(args).noneMatch(a -> a.endsWith(".cat"))) {
			throw new IllegalArgumentException("CAT model not given or format not recognized");
		}
		File fileModel = new File(Arrays.stream(args).filter(a -> a.endsWith(".cat")).findFirst().get());
		String programPath = Arrays.stream(args).filter(a -> supportedFormats.stream().anyMatch(a::endsWith)).findFirst().get();
		File fileProgram = new File(programPath);

		String[] argKeyword = Arrays.stream(args)
		.filter(s->s.startsWith("-"))
		.toArray(String[]::new);
		Configuration config = Configuration.fromCmdLineArguments(argKeyword);
		SVCOMPRunner r = new SVCOMPRunner();
		config.recursiveInject(r);

        WitnessGraph witness = new WitnessGraph(); 
        if(r.witnessPath != null) {
        	witness = new ParserWitness().parse(new File(r.witnessPath));
			if(!fileProgram.getName().
					equals(Paths.get(witness.getProgram()).getFileName().toString())) {
				throw new RuntimeException("The witness was generated from a different program than " + fileProgram);
			}
        }

        int bound = witness.hasAttributed(UNROLLBOUND.toString()) ? parseInt(witness.getAttributed(UNROLLBOUND.toString())) : r.umin;
        File tmp = new SVCOMPSanitizer(fileProgram).run(bound);

        // First time we compiler with standard atomic header to catch compilation problems
		compileWithClang(tmp, "");

		String output = "UNKNOWN";
		while(output.equals("UNKNOWN")) {
			compileWithSmack(tmp, "");
	        // If not removed here, file is not removed when we reach the timeout
	        // File can be safely deleted since it was created by the SVCOMPSanitizer
	        // (it not the original C file) and we already created the Boogie file
	        tmp.delete();
	        
	        String boogieName = System.getenv().get("DAT3M_HOME") + "/output/" +
	        		Files.getNameWithoutExtension(programPath) + ".bpl";
	        
	        if(r.sanitize) {
	        	BoogieSan.write(boogieName);
	        }
	        
	    	ArrayList<String> cmd = new ArrayList<>();
	    	cmd.add("java");
	    	cmd.add("-Dlog4j.configurationFile=" + System.getenv().get("DAT3M_HOME") + "/dartagnan/src/main/resources/log4j2.xml");
	    	cmd.add("-DLOGNAME=" + Files.getNameWithoutExtension(programPath));
	    	cmd.addAll(Arrays.asList("-jar", System.getenv().get("DAT3M_HOME") + "/dartagnan/target/dartagnan-3.1.0.jar"));
			cmd.add(fileModel.toString());
			cmd.add(boogieName);
			cmd.add(String.format("--%s=%s", PROPERTY, r.property.asStringOption()));
			cmd.add(String.format("--%s=%s", BOUND, bound));
			cmd.add(String.format("--%s=%s", WITNESS_ORIGINAL_PROGRAM_PATH, programPath));
			cmd.addAll(filterOptions(config));

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
			if(bound > r.umax) {
				System.out.println("PASS");
				break;
			}
			// We always do iterations 1 and 2 and then use the step
			bound = bound == 1 ? 2 : bound + r.step;
	        tmp = new SVCOMPSanitizer(fileProgram).run(bound);
		}

        tmp.delete();
    }
    
    private static List<String> filterOptions(Configuration config) {
    	
    	// BOUND is computed based on umin and the information from the witness
    	List<String> skip = Arrays.asList(PROPERTYPATH, UMIN, UMAX, STEP, SANITIZE, BOUND);
    	
    	return Arrays.stream(config.asPropertiesString().split("\n")).
			filter(p -> skip.stream().noneMatch(s -> s.equals(p.split(" = ")[0]))).
			map(p -> "--" + p.split(" = ")[0] + "=" + p.split(" = ")[1]).
			collect(Collectors.toList());
    }
    
}