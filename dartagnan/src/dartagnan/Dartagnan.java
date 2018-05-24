package dartagnan;

import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import org.antlr.v4.runtime.ANTLRInputStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.apache.commons.io.FileUtils;

import com.microsoft.z3.Context;
import com.microsoft.z3.Solver;
import com.microsoft.z3.Status;
import com.microsoft.z3.Z3Exception;
import com.microsoft.z3.enumerations.Z3_ast_print_mode;

import dartagnan.LitmusLexer;
import dartagnan.LitmusParser;
import dartagnan.PorthosLexer;
import dartagnan.PorthosParser;
import dartagnan.program.Program;
import dartagnan.utils.Utils;
import dartagnan.wmm.Domain;

import org.apache.commons.cli.*;

@SuppressWarnings("deprecation")
public class Dartagnan {

	public static void main(String[] args) throws Z3Exception, IOException {		

		List<String> MCMs = Arrays.asList("sc", "tso", "pso", "rmo", "alpha", "power", "arm");
		
		Options options = new Options();

        Option targetOpt = new Option("t", "target", true, "target MCM");
        targetOpt.setRequired(true);
        options.addOption(targetOpt);

		Option inputOpt = new Option("i", "input", true, "input file path");
        inputOpt.setRequired(true);
        options.addOption(inputOpt);

        options.addOption(Option.builder("unroll")
        		.hasArg()
        		.desc("Unrolling steps")
        		.build());

        options.addOption(Option.builder("approx")
        		.desc("Approximation optimization for recursive relations")
        		.build());

        options.addOption(Option.builder("draw")
        		.hasArg()
        		.desc("If a buf is found, it outputs a graph \\path_to_file.dot")
        		.build());
        
        options.addOption(Option.builder("rels")
        		.hasArgs()
        		.desc("Relations to be drawn in the graph")
        		.build());

        CommandLineParser parserCmd = new DefaultParser();
        HelpFormatter formatter = new HelpFormatter();
        CommandLine cmd;

        try {
        	cmd = parserCmd.parse(options, args);
        }
        catch (ParseException e) {
        	System.out.println(e.getMessage());
        	formatter.printHelp("DARTAGNAN", options);
        	System.exit(1);
        	return;
        }

		String target = cmd.getOptionValue("target");
		if(!MCMs.stream().anyMatch(mcms -> mcms.trim().equals(target))) {
			System.out.println("Unrecognized target");
			System.exit(0);
			return;
		}

		String inputFilePath = cmd.getOptionValue("input");
		if(!inputFilePath.endsWith("pts") && !inputFilePath.endsWith("litmus")) {
			System.out.println("Unrecognized program format");
			System.exit(0);
			return;
		}
		File file = new File(inputFilePath);

		String program = FileUtils.readFileToString(file, "UTF-8");		
		ANTLRInputStream input = new ANTLRInputStream(program); 		

		Program p = new Program(inputFilePath);
		
		if(inputFilePath.endsWith("litmus")) {
			LitmusLexer lexer = new LitmusLexer(input);	
			CommonTokenStream tokens = new CommonTokenStream(lexer);
			LitmusParser parser = new LitmusParser(tokens);    
			p = parser.program(inputFilePath).p; 
		}
		
		if(inputFilePath.endsWith("pts")) {
			PorthosLexer lexer = new PorthosLexer(input);
			CommonTokenStream tokens = new CommonTokenStream(lexer);
			PorthosParser parser = new PorthosParser(tokens);
			p = parser.program(inputFilePath).p;
		}
	
		String[] rels = new String[100];
		if(cmd.hasOption("rels")) {
			rels = cmd.getOptionValues("rels");	
		}

		int steps = 1;
        if(cmd.hasOption("unroll")) {
            steps = Integer.parseInt(cmd.getOptionValue("unroll"));        	
        }

		p.initialize(steps);
		p.compile(target, false, true);
		
		Context ctx = new Context();
		Solver s = ctx.mkSolver();
		
		s.add(p.encodeDF(ctx));
		s.add(p.getAss().encode(ctx));
		s.add(p.encodeCF(ctx));
		s.add(p.encodeDF_RF(ctx));
		s.add(Domain.encode(p, ctx));
		s.add(p.encodeMM(ctx, target, cmd.hasOption("approx")));
		s.add(p.encodeConsistent(ctx, target));

		ctx.setPrintMode(Z3_ast_print_mode.Z3_PRINT_SMTLIB_FULL);

		if(s.check() == Status.SATISFIABLE) {
			//System.out.println("The state is reachable");
			System.out.println("       0");
			if(cmd.hasOption("draw")) {
				String outputPath = cmd.getOptionValue("draw");
				Utils.drawGraph(p, ctx, s.getModel(), outputPath, rels);
			}
		}
		else {
			//System.out.println("The state is not reachable");
			System.out.println("       1");
		}
		return;
	}	
	
}
