package com.dat3m.porthos;

import com.dat3m.dartagnan.Dartagnan;
import com.dat3m.dartagnan.program.utils.Alias;
import com.dat3m.dartagnan.wmm.utils.Mode;
import com.microsoft.z3.*;
import com.microsoft.z3.enumerations.Z3_ast_print_mode;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.utils.EventRepository;
import com.dat3m.dartagnan.utils.Graph;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.Arch;
import org.apache.commons.cli.*;

import java.io.IOException;
import java.util.Arrays;
import java.util.Collections;
import java.util.stream.Collectors;

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
        if(!inputFilePath.endsWith("pts") && !inputFilePath.endsWith("litmus")) {
            System.out.println("Unrecognized program format");
            System.exit(0);
            return;
        }
        Wmm mcmS = new ParserCat().parse(cmd.getOptionValue("scat"), source);
        Wmm mcmT = new ParserCat().parse(cmd.getOptionValue("tcat"), target);

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

        Context ctx = new Context();
        Program pSource = Dartagnan.parseProgram(inputFilePath);
        Program pTarget = Dartagnan.parseProgram(inputFilePath);
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
                ctx.setPrintMode(Z3_ast_print_mode.Z3_PRINT_SMTLIB_FULL);
                Graph graph = new Graph(s1.getModel(), ctx);
                String outputPath = cmd.getOptionValue("draw");
                if(cmd.hasOption("rels")) {
                    graph.addRelations(Arrays.asList(cmd.getOptionValue("rels").split(",")));
                }
                graph.build(result.getSourceProgram(), result.getTargetProgram()).draw(outputPath);
                System.out.println("Execution graph is written to " + outputPath);
            }
        }
    }

    static PorthosResult testProgram(Solver s1, Solver s2, Context ctx, Program pSource, Program pTarget, Arch source, Arch target,
                                     Wmm sourceWmm, Wmm targetWmm, int steps, Mode mode, Alias alias){

        pSource.unroll(steps);
        pTarget.unroll(steps);

        pSource.compile(source, alias);
        int startEId = Collections.max(pSource.getEventRepository().getEvents(EventRepository.INIT).stream().map(Event::getEId).collect(Collectors.toSet())) + 1;
        pTarget.compile(target, alias, startEId);

        BoolExpr sourceCF = pSource.encodeCF(ctx);
        BoolExpr sourceFV = pSource.encodeFinalValues(ctx);
        BoolExpr sourceMM = sourceWmm.encode(pSource, ctx, mode);

        s1.add(pTarget.encodeCF(ctx));
        s1.add(pTarget.encodeFinalValues(ctx));
        s1.add(targetWmm.encode(pTarget, ctx, mode));
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