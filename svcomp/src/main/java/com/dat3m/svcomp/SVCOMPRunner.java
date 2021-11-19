package com.dat3m.svcomp;

import static com.dat3m.dartagnan.program.processing.Compilation.TARGET;
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

import com.dat3m.dartagnan.Dartagnan;
import com.dat3m.dartagnan.analysis.Analysis;
import com.dat3m.dartagnan.program.processing.LoopUnrolling;
import com.dat3m.dartagnan.utils.options.BaseOptions;
import com.dat3m.dartagnan.witness.WitnessBuilder;
import com.dat3m.dartagnan.wmm.utils.alias.AliasAnalysis;
import com.dat3m.svcomp.utils.Compilation;

import com.dat3m.dartagnan.parsers.witness.ParserWitness;
import com.dat3m.dartagnan.witness.WitnessGraph;
import com.dat3m.svcomp.utils.BoogieSan;
import com.dat3m.svcomp.utils.SVCOMPSanitizer;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

@Options
public class SVCOMPRunner extends BaseOptions {

	private Analysis analysis;

	@Option(
		description="The path to the property to be checked")
	private void property(String p) {
		//TODO process the property file instead of assuming its contents based of its name
		if(p.contains("no-data-race")) {
			analysis = Analysis.RACES;
		} else if(p.contains("unreach-call")) {
			analysis = Analysis.REACHABILITY;
		} else {
			throw new IllegalArgumentException("unrecognized property " + p);
		}
	}

	@Option(
		description="Starting unrolling bound <integer>")
	private int umin = 1;

	@Option(
		description="Ending unrolling bound <integer>")
	private int umax = Integer.MAX_VALUE;

	@Option(
		description="Step size for the increasing unrolling bound <integer>")
	private int step = 1;

	@Option(
		description="Generates (also) a sanitised boogie file saved as /output/boogiesan.bpl")
	private boolean sanitize = false;

	@Option(
		description="Run Dartagnan as a violation witness validator. Argument is the path to the witness file")
	private File witness;

	@Option(
		name=AliasAnalysis.ALIAS,
		description="Alias analysis to be performed on the unrolled program",
		regexp="none|andersen|cfs")
	private String alias = "andersen";

	@Option(
		name=TARGET,
		description="Target architecture to which the program shall be compiled to.")
	private String target = "none";

    public static void main(String[] args) throws IOException, InvalidConfigurationException {

		String[] argPositional = Arrays.stream(args)
			.filter(s->!s.startsWith("-"))
			.toArray(String[]::new);
		File fileModel = new File(argPositional[0]);
		File file = new File(argPositional[1]);
		if(!file.getName().endsWith(".c") && !file.getName().endsWith(".i")) {
			throw new IllegalArgumentException("unrecognized program format");
		}

		String[] argKeyword = Arrays.stream(args)
		.filter(s->s.startsWith("-"))
		.toArray(String[]::new);
		Configuration config = Configuration.fromCmdLineArguments(argKeyword);
		SVCOMPRunner r = new SVCOMPRunner();
		config.recursiveInject(r);

		//TODO help text

        WitnessGraph witness = new WitnessGraph(); 
        if(r.witness != null) {
        	witness = new ParserWitness().parse(r.witness);
			if(!file.getName().
					equals(Paths.get(witness.getProgram()).getFileName().toString())) {
				throw new RuntimeException("The witness was generated from a different program than " + file);
			}
        }

        int bound = witness.hasAttributed(UNROLLBOUND.toString()) ?  parseInt(witness.getAttributed(UNROLLBOUND.toString())) : r.umin;
        File tmp = new SVCOMPSanitizer(file).run(bound);

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
					file.getName().substring(0, file.getName().lastIndexOf('.')) +
					"-" + c.getOptimization() + ".bpl";
	        
	        if(r.sanitize) {
	        	BoogieSan.write(boogieName);
	        }
	        
	    	ArrayList<String> cmd = new ArrayList<>();
	    	cmd.add("java");
	    	cmd.add("-Dlog4j.configurationFile=" + System.getenv().get("DAT3M_HOME") + "/dartagnan/src/main/resources/log4j2.xml");
	    	cmd.add("-DLOGNAME=" + file.getName());
	    	cmd.addAll(asList("-jar", System.getenv().get("DAT3M_HOME") + "/dartagnan/target/dartagnan-3.0.0.jar"));
			cmd.add(fileModel.toString());
			cmd.add(boogieName);
			cmd.add(String.format("--%s=%s",TARGET,r.target));
			cmd.add(String.format("--%s=%s",AliasAnalysis.ALIAS,r.alias));
			cmd.add(String.format("--%s=%d",LoopUnrolling.BOUND,bound));
			cmd.add(String.format("--%s=%s",Dartagnan.ANALYSIS,r.analysis.asStringOption()));
			cmd.add(String.format("--%s=%s",BaseOptions.METHOD,r.method.asStringOption()));
			cmd.add(String.format("--%s=%s",BaseOptions.SOLVER,r.solver.toString().toLowerCase()));
	    	if(r.witness != null) {
	    		// In validation mode we do not create witnesses.
				cmd.add(String.format("--%s=%s",Dartagnan.WITNESS,r.witness));
	    	} else {
	    		// In verification mode we always create a witness.
				cmd.add(String.format("--%s=%s", WitnessBuilder.PATH,file));
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
	        tmp = new SVCOMPSanitizer(file).run(bound);
		}

        tmp.delete();
        return;
    }
}
