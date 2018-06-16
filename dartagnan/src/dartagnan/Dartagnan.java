package dartagnan;

import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import com.microsoft.z3.*;
import dartagnan.parsers.ParserLitmusPPC;
import org.antlr.v4.runtime.ANTLRInputStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.apache.commons.io.FileUtils;

import com.microsoft.z3.enumerations.Z3_ast_print_mode;

import dartagnan.program.Program;
import dartagnan.utils.Utils;
import dartagnan.wmm.Domain;
import dartagnan.wmm.Relation;
import dartagnan.wmm.Wmm;
import dartagnan.utils.ParserErrorListener;

import org.apache.commons.cli.*;

@SuppressWarnings("deprecation")
public class Dartagnan {

    static Executor getExecutor(String inputFilePath) throws Exception{
        return new Executor(inputFilePath);
    }

	public static void main(String[] args) throws Z3Exception, IOException {

		List<String> MCMs = Arrays.asList("sc", "tso", "pso", "rmo", "alpha", "power", "arm");
		
		Options options = new Options();

        Option targetOpt = new Option("t", "target", true, "Target architecture to compile the program");
        targetOpt.setRequired(true);
        options.addOption(targetOpt);

		Option inputOpt = new Option("i", "input", true, "Path to the file containing the input program");
        inputOpt.setRequired(true);
        options.addOption(inputOpt);

        options.addOption(Option.builder("unroll")
        		.hasArg()
        		.desc("Unrolling steps")
        		.build());

        options.addOption(Option.builder("idl")
        		.desc("Uses IDL encoding for transitive closure")
        		.build());

        options.addOption(Option.builder("cat")
        		.hasArg()
        		.desc("Path to the CAT file")
        		.build());

        options.addOption(Option.builder("relax")
        		.desc("Uses relax encoding for recursive relations")
        		.build());

        options.addOption(Option.builder("draw")
        		.hasArg()
        		.desc("Path to save the execution graph if the state is reachable")
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

        try{

		    Executor executor = getExecutor(inputFilePath);
            boolean result = executor.execute(
                    target,
                    cmd.hasOption("cat") ? cmd.getOptionValue("cat") : null,
                    cmd.hasOption("unroll") ? Integer.parseInt(cmd.getOptionValue("unroll")) : 1,
                    cmd.hasOption("relax") && Boolean.parseBoolean(cmd.getOptionValue("relax"))
            );

            if(result) {
                System.out.println("The state is reachable");

                if(cmd.hasOption("draw")) {
                    String[] rels = new String[100];
                    if(cmd.hasOption("rels")) {
                        rels = cmd.getOptionValues("rels");
                    }

                    Context ctx = executor.getContext();
                    ctx.setPrintMode(Z3_ast_print_mode.Z3_PRINT_SMTLIB_FULL);
                    String outputPath = cmd.getOptionValue("draw");
                    Utils.drawGraph(executor.getProgram(), ctx, executor.getSolver().getModel(), outputPath, rels);
                }

            }
            else {
                System.out.println("The state is not reachable");
            }

        } catch(Exception e){
            e.printStackTrace();
        }
	}	
}

class Executor{

    private Program p;
    private Solver s;
    private Context ctx;

    Executor(String inputFilePath) throws Exception{
        ctx = new Context();
        s = ctx.mkSolver();
        p = parseFromFile(inputFilePath);
    }

    public Program getProgram(){
        return p;
    }

    public Solver getSolver(){
        return s;
    }

    public Context getContext() {
        return ctx;
    }

    boolean execute(String target, String catFilePath, int steps, boolean relax) throws Exception{
        Wmm mcm = null;

        if(catFilePath != null){
            File modelfile = new File(catFilePath);
            String mcmtext = FileUtils.readFileToString(modelfile, "UTF-8");
            ANTLRInputStream mcminput = new ANTLRInputStream(mcmtext);
            ModelLexer lexer = new ModelLexer(mcminput);
            CommonTokenStream tokens = new CommonTokenStream(lexer);
            ModelParser parser = new ModelParser(tokens);
            mcm = parser.mcm().value;
        }

        if (relax || mcm != null) {
            Relation.Approx = true;
        }

        steps = steps > 0 ? steps : 1;
        p.initialize(steps);
        p.compile(target, false, true);

        s.add(p.encodeDF(ctx));
        s.add(p.getAss().encode(ctx));
        s.add(p.encodeCF(ctx));
        s.add(p.encodeDF_RF(ctx));
        s.add(Domain.encode(p, ctx));

        if (mcm != null) {
            s.add(mcm.encode(p, ctx));
            s.add(mcm.Consistent(p, ctx));
        } else {
    		s.add(p.encodeMM(ctx, target, cmd.hasOption("relax"), cmd.hasOption("idl")));
    		s.add(p.encodeConsistent(ctx, target));
        }

        return s.check() == Status.SATISFIABLE;
    }

    private Program parseFromFile(String inputFilePath) throws Exception{
        File file = new File(inputFilePath);
        String programRaw = FileUtils.readFileToString(file, "UTF-8");
        ANTLRInputStream input = new ANTLRInputStream(programRaw);
        Program program = new Program(inputFilePath);
        ParserErrorListener listener = new ParserErrorListener();

        if(inputFilePath.endsWith("litmus")) {
            LitmusLexer lexer = new LitmusLexer(input);
            CommonTokenStream tokens = new CommonTokenStream(lexer);
            LitmusParser parser = new LitmusParser(tokens);
            parser.addErrorListener(listener);
            //program = parser.program(inputFilePath).p;

            ParserLitmusPPC testParser = new ParserLitmusPPC();
            program = testParser.parse(inputFilePath);
            //System.out.println(program);
        }

        if(inputFilePath.endsWith("pts")) {
            PorthosLexer lexer = new PorthosLexer(input);
            CommonTokenStream tokens = new CommonTokenStream(lexer);
            PorthosParser parser = new PorthosParser(tokens);
            parser.addErrorListener(listener);
            program = parser.program(inputFilePath).p;
        }

        if(listener.hasError()){
            throw new IOException("Parsing error");
        }

        return program;
    }
}