package com.dat3m.porthos;

import com.dat3m.dartagnan.Dartagnan;
import com.dat3m.dartagnan.wmm.utils.alias.Alias;
import com.dat3m.dartagnan.wmm.utils.Mode;
import com.microsoft.z3.*;
import com.microsoft.z3.enumerations.Z3_ast_print_mode;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.Graph;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.Arch;
import org.apache.commons.cli.*;

import java.io.File;
import java.io.IOException;
import java.util.Arrays;

import static com.dat3m.porthos.Encodings.encodeCommonExecutions;
import static com.dat3m.porthos.Encodings.encodeReachedState;

public class Porthos {

    public static void main(String[] args) throws IOException {

        Options options = new Options();

        Option inputOption = new Option("i", "input", true, "Path to the file with input program");
        inputOption.setRequired(true);
        options.addOption(inputOption);

        Option sourceCatOption = new Option("scat", true, "Path to the CAT file of the source memory model");
        sourceCatOption.setRequired(true);
        options.addOption(sourceCatOption);

        Option targetCatOption = new Option("tcat", true, "Path to the CAT file of the target memory model");
        targetCatOption.setRequired(true);
        options.addOption(targetCatOption);

        Option sourceOption = new Option("s", "source", true, "Source architecture {none|arm|arm8|power|tso}");
        sourceOption.setRequired(true);
        options.addOption(sourceOption);

        Option targetOption = new Option("t", "target", true, "Target architecture {none|arm|arm8|power|tso}");
        targetOption.setRequired(true);
        options.addOption(targetOption);

        Option modeOption = new Option("m", "mode", true, "Encoding mode {knastertarski|idl|kleene}");
        options.addOption(modeOption);

        Option aliasOption = new Option("a", "alias", true, "Type of alias analysis {none|andersen|cfs}");
        options.addOption(aliasOption);

        options.addOption(new Option("unroll", true, "Unrolling steps"));
        options.addOption(new Option("draw", true, "Path to save the execution graph if the state is reachable"));
        options.addOption(new Option("rels", true, "Relations to be drawn in the graph"));

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

        Arch source = Arch.get(cmd.getOptionValue("source"));
        Arch target = Arch.get(cmd.getOptionValue("target"));

        String inputFilePath = cmd.getOptionValue("input");
        if(!inputFilePath.endsWith("pts")) {
            System.out.println("Unrecognized program format");
            System.exit(0);
            return;
        }
        Wmm mcmS = new ParserCat().parse(new File(cmd.getOptionValue("scat")));
        Wmm mcmT = new ParserCat().parse(new File(cmd.getOptionValue("tcat")));

        if(cmd.hasOption("draw")) {
            mcmS.setDrawExecutionGraph();
            mcmT.setDrawExecutionGraph();
            mcmS.addDrawRelations(Graph.getDefaultRelations());
            mcmT.addDrawRelations(Graph.getDefaultRelations());
            if(cmd.hasOption("rels")) {
                mcmS.addDrawRelations(Arrays.asList(cmd.getOptionValue("rels").split(",")));
                mcmT.addDrawRelations(Arrays.asList(cmd.getOptionValue("rels").split(",")));
            }
        }

        int steps = 1;
        if(cmd.hasOption("unroll")) {
            steps = Integer.parseInt(cmd.getOptionValue("unroll"));
        }

        Mode mode = Mode.get(cmd.getOptionValue("mode"));
        Alias alias = Alias.get(cmd.getOptionValue("alias"));

        ProgramParser programParser = new ProgramParser();
        Program pSource = programParser.parse(new File(inputFilePath));
        Program pTarget = programParser.parse(new File(inputFilePath));

        Context ctx = new Context();
        Solver s1 = ctx.mkSolver(ctx.mkTactic(Dartagnan.TACTIC));
        Solver s2 = ctx.mkSolver(ctx.mkTactic(Dartagnan.TACTIC));

        PorthosResult result = testProgram(s1, s2, ctx, pSource, pTarget, source, target, mcmS, mcmT,
                steps, mode, alias);

        if(result.getIsPortable()){
            System.out.println("The program is state-portable");
            System.out.println("Iterations: " + result.getIterations());

        } else {
            System.out.println("The program is not state-portable");
            System.out.println("Iterations: " + result.getIterations());
            if(cmd.hasOption("draw")) {
                String outputPath = cmd.getOptionValue("draw");
                String[] relations = cmd.hasOption("rels") ? cmd.getOptionValue("rels").split(",") : new String[0];
                ctx.setPrintMode(Z3_ast_print_mode.Z3_PRINT_SMTLIB_FULL);
                Dartagnan.drawGraph(new Graph(s1.getModel(), ctx, pSource, pTarget, relations), outputPath);
                System.out.println("Execution graph is written to " + outputPath);
            }
        }

        ctx.close();
    }

    public static PorthosResult testProgram(Solver s1, Solver s2, Context ctx, Program pSource, Program pTarget, Arch source, Arch target,
                                     Wmm sourceWmm, Wmm targetWmm, int steps, Mode mode, Alias alias){

        pSource.unroll(steps, 0);
        pTarget.unroll(steps, 0);

        int nextId = pSource.compile(source, 0);
        pTarget.compile(target, nextId);

        BoolExpr sourceCF = pSource.encodeCF(ctx);
        BoolExpr sourceFV = pSource.encodeFinalRegisterValues(ctx);
        BoolExpr sourceMM = sourceWmm.encode(pSource, ctx, mode, alias);

        s1.add(pTarget.encodeCF(ctx));
        s1.add(pTarget.encodeFinalRegisterValues(ctx));
        s1.add(targetWmm.encode(pTarget, ctx, mode, alias));
        s1.add(targetWmm.consistent(pTarget, ctx));

        s1.add(sourceCF);
        s1.add(sourceFV);
        s1.add(sourceMM);
        s1.add(sourceWmm.inconsistent(pSource, ctx));

        s1.add(encodeCommonExecutions(pTarget, pSource, ctx));

        s2.add(sourceCF);
        s2.add(sourceFV);
        s2.add(sourceMM);
        s2.add(sourceWmm.consistent(pSource, ctx));

        boolean isPortable = true;
        int iterations = 1;

        Status lastCheck = s1.check();

        while(lastCheck == Status.SATISFIABLE) {
            Model model = s1.getModel();
            BoolExpr reachedState = encodeReachedState(pTarget, model, ctx);
            s2.push();
            s2.add(reachedState);
            if(s2.check() == Status.UNSATISFIABLE) {
                isPortable = false;
                break;
            }
            s2.pop();
            s1.add(ctx.mkNot(reachedState));
            iterations++;
            lastCheck = s1.check();
        }
        return new PorthosResult(isPortable, iterations, pSource, pTarget);
    }
}