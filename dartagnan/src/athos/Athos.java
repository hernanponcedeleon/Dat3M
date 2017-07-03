package athos;

import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.Set;
import java.util.stream.Collector;
import java.util.stream.Collectors;

import org.antlr.v4.runtime.ANTLRInputStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.CommandLineParser;
import org.apache.commons.cli.DefaultParser;
import org.apache.commons.cli.HelpFormatter;
import org.apache.commons.cli.Option;
import org.apache.commons.cli.Options;
import org.apache.commons.cli.ParseException;
import org.apache.commons.io.FileUtils;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Solver;
import com.microsoft.z3.Status;
import com.microsoft.z3.Z3Exception;
import com.microsoft.z3.enumerations.Z3_ast_print_mode;

import dartagnan.LitmusLexer;
import dartagnan.LitmusParser;
import dartagnan.PorthosLexer;
import dartagnan.PorthosParser;
import dartagnan.program.Event;
import dartagnan.program.Load;
import dartagnan.program.Init;
import dartagnan.program.Local;
import dartagnan.program.MemEvent;
import dartagnan.program.Store;
import dartagnan.program.Program;
import dartagnan.utils.Utils;
import dartagnan.wmm.Domain;
import dartagnan.wmm.Domain2;

@SuppressWarnings("deprecation")
public class Athos {

	public static void main(String[] args) throws Z3Exception, IOException {		

		List<String> MCMs = Arrays.asList("sc", "tso", "pso", "rmo", "alpha", "power", "none");
		
		Options options = new Options();

        Option targetOpt = new Option("t", "target", true, "target MCM");
        targetOpt.setRequired(true);
        options.addOption(targetOpt);

		Option inputOpt = new Option("i", "input", true, "input file path");
        inputOpt.setRequired(true);
        options.addOption(inputOpt);

        CommandLineParser parserCmd = new DefaultParser();
        HelpFormatter formatter = new HelpFormatter();
        CommandLine cmd;

        try {
        	cmd = parserCmd.parse(options, args);
        }
        catch (ParseException e) {
        	System.out.println(e.getMessage());
        	formatter.printHelp("ATHOS", options);
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
	
		p.initialize();
		Program p2 = p.clone();
		p.compile();
		Integer startEId = 1;
		p2.optCompile(startEId);
		
		System.out.println(p);
		System.out.println(p2);
		
		Context ctx = new Context();
		Solver s = ctx.mkSolver();
//		s.add(p2.encodeDF(ctx, false));
//		s.add(p2.encodeCF(ctx));
//		s.add(p2.encodeDF_RF(ctx));
//		s.add(Domain2.encode(p2, ctx));
		s.add(p.encodeConsistent(ctx, target));
		s.add(p.encodeDF(ctx, false));
		s.add(p.encodeCF(ctx));
		s.add(p.encodeDF_RF(ctx));
		s.add(Domain2.encode(p, ctx));
		s.add(p2.encodeInconsistent(ctx, target));
//		s.add(p.encodeCommonExecutions(p2, ctx));

		ctx.setPrintMode(Z3_ast_print_mode.Z3_PRINT_SMTLIB_FULL);

		if(s.check() == Status.SATISFIABLE) {
			//System.out.println(String.format("The program is not portable from %s to %s", source, target));
			System.out.println("       0");
//			for(Event e1 : p.getEvents().stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet())) {
//				for(Event e2 : p.getEvents().stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet())) {
//					if(s.getModel().getConstInterp(Utils.cycleEdge("(poloc+com)", e1, e2, ctx)).isTrue()) {
//						System.out.println(Utils.cycleEdge("(poloc+com)", e1, e2, ctx).toString());	
//					}
//					if(s.getModel().getConstInterp(Utils.edge("fr", e1, e2, ctx)).isTrue()) {
//						System.out.println(Utils.edge("fr", e1, e2, ctx).toString());	
//					}
//				}
//			}
//			for(Event e1 : p2.getEvents().stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet())) {
//				for(Event e2 : p2.getEvents().stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet())) {
//					if(s.getModel().getConstInterp(Utils.edge("fr", e1, e2, ctx)).isTrue()) {
//						System.out.println(Utils.edge("fr", e1, e2, ctx).toString());	
//					}
//				}
//			}
//			
//			for(Event r : p.getEvents().stream().filter(e -> e instanceof Load).collect(Collectors.toSet())) {
//				for(Event w : p.getEvents().stream().filter(e -> e instanceof Store || e instanceof Init).collect(Collectors.toSet())) {
//					if(s.getModel().getConstInterp(Utils.edge("rf", w, r, ctx)).isTrue()) {
//						System.out.println("rf(" + w.repr() + "," + r.repr());	
//					}
//				}
//			}
//			for(Event r : p2.getEvents().stream().filter(e -> e instanceof Load).collect(Collectors.toSet())) {
//				for(Event w : p2.getEvents().stream().filter(e -> e instanceof Store || e instanceof Init).collect(Collectors.toSet())) {
//					if(s.getModel().getConstInterp(Utils.edge("rf", w, r, ctx)).isTrue()) {
//						System.out.println("rf(" + w.repr() + "," + r.repr());	
//					}
//				}
//			}
//			
//			for(Event r : p.getEvents().stream().filter(e -> e instanceof Store || e instanceof Init).collect(Collectors.toSet())) {
//				for(Event w : p.getEvents().stream().filter(e -> e instanceof Store || e instanceof Init).collect(Collectors.toSet())) {
//					if(s.getModel().getConstInterp(Utils.edge("co", w, r, ctx)).isTrue()) {
//						System.out.println("co(" + w.repr() + "," + r.repr());	
//					}
//				}
//			}
//			for(Event r : p2.getEvents().stream().filter(e -> e instanceof Store || e instanceof Init).collect(Collectors.toSet())) {
//				for(Event w : p2.getEvents().stream().filter(e -> e instanceof Store || e instanceof Init).collect(Collectors.toSet())) {
//					if(s.getModel().getConstInterp(Utils.edge("co", w, r, ctx)).isTrue()) {
//						System.out.println("co(" + w.repr() + "," + r.repr());	
//					}
//				}
//			}
		}
		else {
			//System.out.println(String.format("The program is portable from %s to %s", source, target));
			System.out.println("       1");
		}
	}
}