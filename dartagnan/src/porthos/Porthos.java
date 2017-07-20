package porthos;

import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import org.antlr.v4.runtime.ANTLRInputStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.apache.commons.io.FileUtils;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Model;
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
import dartagnan.program.Local;
import dartagnan.program.Location;
import dartagnan.program.MemEvent;
import dartagnan.program.Program;
import dartagnan.program.Register;
import dartagnan.wmm.Domain;

import org.apache.commons.cli.*;

@SuppressWarnings("deprecation")
public class Porthos {

	public static void main(String[] args) throws Z3Exception, IOException {		

		List<String> MCMs = Arrays.asList("sc", "tso", "pso", "rmo", "alpha", "power", "arm");
		
		Options options = new Options();

        Option sourceOpt = new Option("s", "source", true, "source MCM");
        sourceOpt.setRequired(true);
        options.addOption(sourceOpt);

        Option targetOpt = new Option("t", "target", true, "target MCM");
        targetOpt.setRequired(true);
        options.addOption(targetOpt);

		Option inputOpt = new Option("i", "input", true, "input file path");
        inputOpt.setRequired(true);
        options.addOption(inputOpt);

        options.addOption("state", false, "PORTHOS performs state portability");
        
        CommandLineParser parserCmd = new DefaultParser();
        HelpFormatter formatter = new HelpFormatter();
        CommandLine cmd;

        try {
        	cmd = parserCmd.parse(options, args);
        }
        catch (ParseException e) {
        	System.out.println(e.getMessage());
        	formatter.printHelp("PORTHOS", options);
        	System.exit(1);
        	return;
        }

		String source = cmd.getOptionValue("source");
		if(!MCMs.stream().anyMatch(mcms -> mcms.trim().equals(source))) {
			System.out.println("Unrecognized source");
			System.exit(0);
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
		
		boolean statePortability = cmd.hasOption("sp");

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
		p.compile(false, true);
		
		Context ctx = new Context();
		ctx.setPrintMode(Z3_ast_print_mode.Z3_PRINT_SMTLIB_FULL);
		Solver s = ctx.mkSolver();
		s.add(p.encodeDF(ctx));
		s.add(p.encodeCF(ctx));
		s.add(p.encodeDF_RF(ctx));
		s.add(Domain.encode(p, ctx));
		s.add(p.encodeConsistent(ctx, target));
		
		if(!statePortability) {
			s.add(p.encodeInconsistent(ctx, source));
			if(s.check() == Status.SATISFIABLE) {
				System.out.println("       0");
				return;
			}
			else {
				System.out.println("       1");
				return;
			}
		}
		
		Status lastCheck = Status.SATISFIABLE;

		while(lastCheck == Status.SATISFIABLE) {
			s.push();		
			s.add(p.encodeInconsistent(ctx, source));
			
			if(s.check() == Status.SATISFIABLE) {
				Model model = s.getModel();
				s.pop();
				s.push();
				s.add(p.encodeConsistent(ctx, source));

				Set<Location> locs = p.getEvents().stream().filter(e -> e instanceof MemEvent).map(e -> e.getLoc()).collect(Collectors.toSet());
				BoolExpr reachedState = ctx.mkTrue();
				
				for(Location loc : locs) {
					reachedState = ctx.mkAnd(reachedState, ctx.mkEq(ctx.mkIntConst(loc.getName() + "_final"), model.getConstInterp(ctx.mkIntConst(loc.getName() + "_final"))));
				}

				Set<Event> executedEvents = p.getEvents().stream().filter(e -> model.getConstInterp(e.executes(ctx)).isTrue()).collect(Collectors.toSet());
				Set<Register> regs = executedEvents.stream().filter(e -> e instanceof Local | e instanceof Load).map(e -> e.getReg()).collect(Collectors.toSet());

				for(Register reg : regs) {
					Set<Integer> ssaRegIndexes = new HashSet<Integer>();
					for(Event e : executedEvents) {
						if(!(e instanceof Load | e instanceof Local)) {continue;}
						if(e.getReg() != reg) {continue;}
						if(e instanceof Load) {
							ssaRegIndexes.add(((Load) e).ssaRegIndex);	
						}
						if(e instanceof Local) {
							ssaRegIndexes.add(((Local) e).ssaRegIndex);	
						}
					}
					Integer lastRegIndex = Collections.max(ssaRegIndexes);
					String regVarName = String.format("T%s_%s_%s", reg.getMainThread(), reg.getName(), lastRegIndex);
					reachedState = ctx.mkAnd(reachedState, ctx.mkEq(ctx.mkIntConst(regVarName), model.getConstInterp(ctx.mkIntConst(regVarName))));
				}
				
				s.add(reachedState);
				lastCheck = s.check();
				if(lastCheck == Status.UNSATISFIABLE) {
					System.out.println("       0");					
				}
				else {
					s.pop();
					s.add(ctx.mkNot(reachedState));
				}
			}
			else {
				lastCheck = s.check();
				System.out.println("       1");
			}
		}
	}	
	
}
