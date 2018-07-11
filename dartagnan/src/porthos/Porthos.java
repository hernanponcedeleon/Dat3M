package porthos;

import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import dartagnan.*;
import org.antlr.v4.runtime.ANTLRInputStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.apache.commons.io.FileUtils;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.microsoft.z3.Model;
import com.microsoft.z3.Solver;
import com.microsoft.z3.Status;
import com.microsoft.z3.Z3Exception;
import com.microsoft.z3.enumerations.Z3_ast_print_mode;

import dartagnan.program.Init;
import dartagnan.program.Program;
import dartagnan.utils.Utils;
import dartagnan.wmm.Domain;
import dartagnan.wmm.Relation;
import dartagnan.wmm.Wmm;
import static dartagnan.utils.Encodings.encodeReachedState;
import static dartagnan.utils.Encodings.encodeCommonExecutions;

import org.apache.commons.cli.*;

@SuppressWarnings("deprecation")
public class Porthos {

    public static void main(String[] args) throws Z3Exception, IOException {
        Wmm mcmS = null;
        Wmm mcmT = null;

        List<String> MCMs = Arrays.asList("sc", "tso", "pso", "rmo", "alpha", "power", "arm");

        Options options = new Options();

        Option sourceOpt = new Option("s", "source", true, "Source architecture to compile the program");
        sourceOpt.setRequired(true);
        options.addOption(sourceOpt);

        Option targetOpt = new Option("t", "target", true, "Target architecture to compile the program");
        targetOpt.setRequired(true);
        options.addOption(targetOpt);

		Option inputOpt = new Option("i", "input", true, "Path to the file containing the input program");
        inputOpt.setRequired(true);
        options.addOption(inputOpt);

        options.addOption(Option.builder("relax")
        		.desc("Uses relax encoding for transitive closure")
        		.build());

        options.addOption(Option.builder("draw")
                .hasArg()
        		.desc("Path to save the execution graphs if a porting bug is found")
                .build());

        options.addOption(Option.builder("rels")
                .hasArgs()
                .desc("Relations to be drawn in the graph")
                .build());

        options.addOption(Option.builder("unroll")
                .hasArg()
                .desc("Unrolling steps")
                .build());

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

        options.addOption(Option.builder("scat")
        		.hasArg()
        		.desc("Path to the CAT file of the source memory model")
        		.build());

        options.addOption(Option.builder("tcat")
        		.hasArg()
        		.desc("Path to the CAT file of the target memory model")
        		.build());

        String[] rels = new String[100];
        if(cmd.hasOption("rels")) {
            rels = cmd.getOptionValues("rels");
        }

        if (cmd.hasOption("scat")) {
            File sourceFile = new File(cmd.getOptionValue("scat"));
            String mcmStext = FileUtils.readFileToString(sourceFile, "UTF-8");
            ANTLRInputStream mcmSinput = new ANTLRInputStream(mcmStext);
            ModelLexer lexerS = new ModelLexer(mcmSinput);
            CommonTokenStream tokensS = new CommonTokenStream(lexerS);
            ModelParser parserS = new ModelParser(tokensS);
            mcmS = parserS.mcm().value;
        }

        if (cmd.hasOption("tcat")) {
            File targetFile = new File(cmd.getOptionValue("tcat"));
            String mcmTtext = FileUtils.readFileToString(targetFile, "UTF-8");
            ANTLRInputStream mcmTinput = new ANTLRInputStream(mcmTtext);
            ModelLexer lexerT = new ModelLexer(mcmTinput);
            CommonTokenStream tokensT = new CommonTokenStream(lexerT);
            ModelParser parserT = new ModelParser(tokensT);
            mcmT = parserT.mcm().value;
        }

        if (cmd.hasOption("relax") || mcmS != null|| mcmT != null) {
            Relation.Approx = true;
        }

        int steps = 1;
        if(cmd.hasOption("unroll")) {
            steps = Integer.parseInt(cmd.getOptionValue("unroll"));
        }

        Program p = Dartagnan.parseProgram(inputFilePath);
        p.initialize(steps);

        Program pSource = p.clone();
        Program pTarget = p.clone();

        pSource.compile(source, false, true);
        Integer startEId = Collections.max(pSource.getEvents().stream().filter(e -> e instanceof Init).map(e -> e.getEId()).collect(Collectors.toSet())) + 1;
        pTarget.compile(target, false, true, startEId);

        Context ctx = new Context();
        ctx.setPrintMode(Z3_ast_print_mode.Z3_PRINT_SMTLIB_FULL);
        Solver s = ctx.mkSolver();
        Solver s2 = ctx.mkSolver();

        BoolExpr sourceDF = pSource.encodeDF(ctx);
        BoolExpr sourceCF = pSource.encodeCF(ctx);
        BoolExpr sourceDF_RF = pSource.encodeDF_RF(ctx);
        BoolExpr sourceDomain = Domain.encode(pSource, ctx);
        BoolExpr sourceMM = null;
        if (mcmS != null) {
            sourceMM = mcmS.encode(p, ctx);

        } else {
            sourceMM = pSource.encodeMM(ctx, source, false, cmd.hasOption("idl"));
        }

        s.add(pTarget.encodeDF(ctx));
        s.add(pTarget.encodeCF(ctx));
        s.add(pTarget.encodeDF_RF(ctx));
        s.add(Domain.encode(pTarget, ctx));
        if (mcmT != null) {
            s.add(mcmT.encode(p, ctx));
            s.add(mcmT.Consistent(p, ctx));
        } else {
            s.add(pTarget.encodeMM(ctx, target, false, cmd.hasOption("idl")));
            s.add(pTarget.encodeConsistent(ctx, target));
        }
        s.add(sourceDF);
        s.add(sourceCF);
        s.add(sourceDF_RF);
        s.add(sourceDomain);
        s.add(sourceMM);
        if (mcmS != null) {
            s.add(mcmS.Inconsistent(p, ctx));
        } else {
            s.add(pSource.encodeInconsistent(ctx, source));
        }
        s.add(encodeCommonExecutions(pTarget, pSource, ctx));

        s2.add(sourceDF);
        s2.add(sourceCF);
        s2.add(sourceDF_RF);
        s2.add(sourceDomain);
        s2.add(sourceMM);
        if (mcmS != null) {
            s.add(mcmS.Consistent(p, ctx));
        } else {
            s2.add(pSource.encodeConsistent(ctx, source));
        }

//        if(!statePortability) {
//            if(s.check() == Status.SATISFIABLE) {
//                //System.out.println("The program is not portable");
//                System.out.println("       0");
//                if(cmd.hasOption("draw")) {
//                    String outputPath = cmd.getOptionValue("draw");
//                    Utils.drawGraph(p, pSource, pTarget, ctx, s.getModel(), outputPath, rels);
//                }
//                return;
//            }
//            else {
//                //System.out.println("The program is portable");
//                System.out.println("       1");
//                return;
//            }
//        }

        int iterations = 0;
        Status lastCheck = Status.SATISFIABLE;
        Set<Expr> visited = new HashSet<Expr>();

        while(lastCheck == Status.SATISFIABLE) {

            lastCheck = s.check();
            if(lastCheck == Status.SATISFIABLE) {
                iterations = iterations + 1;
                Model model = s.getModel();
                s2.push();
                BoolExpr reachedState = encodeReachedState(pTarget, model, ctx);
                visited.add(reachedState);
                assert(iterations == visited.size());
                s2.add(reachedState);
                if(s2.check() == Status.UNSATISFIABLE) {
                    System.out.println("The program is not state-portable");
                    System.out.println("Iterations: " + iterations);
                    if(cmd.hasOption("draw")) {
                  	  String outputPath = cmd.getOptionValue("draw");
                  	  Utils.drawGraph(p, pSource, pTarget, ctx, s.getModel(), outputPath, rels);
                      }
                    return;
                }
                else {
                    s2.pop();
                    s.add(ctx.mkNot(reachedState));
                }
            }
            else {
                System.out.println("The program is state-portable");
                System.out.println("Iterations: " + iterations);
                return;
            }
        }
    }
}