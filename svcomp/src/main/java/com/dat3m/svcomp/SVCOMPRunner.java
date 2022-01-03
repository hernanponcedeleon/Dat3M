package com.dat3m.svcomp;

import static com.dat3m.dartagnan.Dartagnan.VALIDATE;
import static com.dat3m.dartagnan.configuration.DAT3MOptions.*;
import static com.dat3m.dartagnan.witness.GraphAttributes.UNROLLBOUND;
import static java.lang.Integer.parseInt;
import static java.util.Arrays.asList;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import com.dat3m.dartagnan.Dartagnan;
import com.dat3m.dartagnan.analysis.Analysis;
import com.dat3m.dartagnan.utils.options.BaseOptions;
import com.dat3m.svcomp.utils.Compilation;

import com.dat3m.dartagnan.parsers.witness.ParserWitness;
import com.dat3m.dartagnan.witness.WitnessGraph;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.dat3m.svcomp.utils.BoogieSan;
import com.dat3m.svcomp.utils.SVCOMPSanitizer;
import com.google.common.collect.ImmutableSet;
import com.google.common.io.Files;

import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

@Options
public class SVCOMPRunner extends BaseOptions {

	private Analysis analysis;

	@Option(
		name="property",
		required=true,
		description="The path to the property to be checked.")
	private void property(String p) {
		//TODO process the property file instead of assuming its contents based of its name
		if(p.contains("no-data-race")) {
			analysis = Analysis.RACES;
		} else if(p.contains("unreach-call")) {
			analysis = Analysis.REACHABILITY;
		} else {
			throw new IllegalArgumentException("Unrecognized property " + p);
		}
	}

	@Option(
		name="umin",
		description="Starting unrolling bound <integer>.")
	private int umin = 1;

	@Option(
		name="umax",
		description="Ending unrolling bound <integer>.")
	private int umax = Integer.MAX_VALUE;

	@Option(
		name="step",
		description="Step size for the increasing unrolling bound <integer>.")
	private int step = 1;

	@Option(
		name="sanitize",
		description="Generates (also) a sanitised boogie file saved as /output/boogiesan.bpl.")
	private boolean sanitize = false;

	@Option(
		name=VALIDATE,
		description="Run Dartagnan as a violation witness validator. Argument is the path to the witness file.")
	private String witnessPath;

	@Option(
		name=TARGET,
		description = "The target architecture to which the program shall be compiled to.")
	private Arch target = Arch.NONE;

	private static final Set<String> supportedFormats = 
    		ImmutableSet.copyOf(Arrays.asList(".c", ".i"));

    public static void main(String[] args) throws IOException, InvalidConfigurationException {

		if(Arrays.stream(args).noneMatch(a -> supportedFormats.stream().anyMatch(f -> a.endsWith(f)))) {
			throw new IllegalArgumentException("Input program not given or format not recognized");
		}
		if(Arrays.stream(args).noneMatch(a -> a.endsWith(".cat"))) {
			throw new IllegalArgumentException("CAT model not given or format not recognized");
		}
		File fileModel = new File(Arrays.stream(args).filter(a -> a.endsWith(".cat")).findFirst().get());
		String programPath = Arrays.stream(args).filter(a -> supportedFormats.stream().anyMatch(f -> a.endsWith(f))).findFirst().get();
		File fileProgram = new File(programPath);

		String[] argKeyword = Arrays.stream(args)
		.filter(s->s.startsWith("-"))
		.toArray(String[]::new);
		Configuration config = Configuration.fromCmdLineArguments(argKeyword);
		SVCOMPRunner r = new SVCOMPRunner();
		config.recursiveInject(r);

		//TODO help text

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

		Compilation c = new Compilation();
		config.inject(c);

        // First time we compiler with standard atomic header to catch compilation problems
        c.compile(tmp,false);

		String output = "UNKNOWN";
		while(output.equals("UNKNOWN")) {
			c.compile(tmp,true);
	        // If not removed here, file is not removed when we reach the timeout
	        // File can be safely deleted since it was created by the SVCOMPSanitizer
	        // (it not the original C file) and we already created the Boogie file
	        tmp.delete();
	        
	        String boogieName = System.getenv().get("DAT3M_HOME") + "/output/" +
	        		Files.getNameWithoutExtension(programPath) +
					"-" + c.getOptimization() + ".bpl";
	        
	        if(r.sanitize) {
	        	BoogieSan.write(boogieName);
	        }
	        
	    	ArrayList<String> cmd = new ArrayList<>();
	    	cmd.add("java");
	    	cmd.add("-Dlog4j.configurationFile=" + System.getenv().get("DAT3M_HOME") + "/dartagnan/src/main/resources/log4j2.xml");
	    	cmd.add("-DLOGNAME=" + fileProgram.getName());
	    	cmd.addAll(asList("-jar", System.getenv().get("DAT3M_HOME") + "/dartagnan/target/dartagnan-3.0.0.jar"));
			cmd.add(fileModel.toString());
			cmd.add(boogieName);
			cmd.add(String.format("--%s=%s", Dartagnan.ANALYSIS, r.analysis.asStringOption()));
			cmd.add(String.format("--%s=%s", BOUND, bound));
			for(String option : propagateOptions(config)) {
				cmd.add(option);
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
			if(bound > r.umax) {
				System.out.println("PASS");
				break;
			}
			// We always do iterations 1 and 2 and then use the step
			bound = bound == 1 ? 2 : bound + r.step;
	        tmp = new SVCOMPSanitizer(fileProgram).run(bound);
		}

        tmp.delete();
        return;
    }
    
    private static List<String> propagateOptions(Configuration config) {
    	
    	List<String> skip = Arrays.asList("property", "umin", "umax", "step", "sanitize", BOUND);
    	
    	return Arrays.asList(config.asPropertiesString().split("\n")).stream().
		filter(p -> skip.stream().noneMatch(s -> s.equals(p.split(" = ")[0]))).
		map(p -> "--" + p.split(" = ")[0] + "=" + p.split(" = ")[1]).
		collect(Collectors.toList());
    }
    
}