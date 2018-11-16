package porthos;

import com.microsoft.z3.*;
import com.microsoft.z3.enumerations.Z3_ast_print_mode;
import dartagnan.Dartagnan;
import dartagnan.parsers.cat.ParserCat;
import dartagnan.program.Program;
import dartagnan.program.event.Event;
import dartagnan.program.utils.EventRepository;
import dartagnan.utils.Graph;
import dartagnan.wmm.Wmm;
import dartagnan.wmm.utils.Arch;
import org.apache.commons.cli.*;

import java.io.IOException;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;
import java.util.stream.Collectors;

import static dartagnan.utils.Encodings.encodeCommonExecutions;
import static dartagnan.utils.Encodings.encodeReachedState;

public class Porthos {

    public static void main(String[] args) throws IOException {

        Options options = new Options();

        Option sourceOption = new Option("s", "source", true, "Source architecture to compile the program");
        sourceOption.setRequired(true);
        options.addOption(sourceOption);

        Option targetOption = new Option("t", "target", true, "Target architecture to compile the program");
        targetOption.setRequired(true);
        options.addOption(targetOption);

        Option inputOption = new Option("i", "input", true, "Path to the file containing the input program");
        inputOption.setRequired(true);
        options.addOption(inputOption);

        Option sourceCatOption = new Option("scat", true, "Path to the CAT file of the source memory model");
        sourceCatOption.setRequired(true);
        options.addOption(sourceCatOption);

        Option targetCatOption = new Option("tcat", true, "Path to the CAT file of the target memory model");
        targetCatOption.setRequired(true);
        options.addOption(targetCatOption);

        options.addOption(new Option("unroll", true, "Unrolling steps"));
        options.addOption(new Option("idl", "Uses IDL encoding for transitive closure"));
        options.addOption(new Option("relax", "Uses relax encoding for recursive relations"));
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

        String source = cmd.getOptionValue("source").trim();
        if(!(Arch.targets.contains(source))){
            System.out.println("Unrecognized source");
            System.exit(0);
            return;
        }

        String target = cmd.getOptionValue("target").trim();
        if(!(Arch.targets.contains(target))){
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

        Program p = Dartagnan.parseProgram(inputFilePath);
        p.unroll(steps);

        Program pSource = p.clone();
        Program pTarget = p.clone();

        pSource.compile(source, false, true);
        int startEId = Collections.max(pSource.getEventRepository().getEvents(EventRepository.INIT).stream().map(Event::getEId).collect(Collectors.toSet())) + 1;
        pTarget.compile(target, false, true, startEId);

        Context ctx = new Context();
        ctx.setPrintMode(Z3_ast_print_mode.Z3_PRINT_SMTLIB_FULL);
        Solver s = ctx.mkSolver(ctx.mkTactic(Dartagnan.TACTIC));
        Solver s2 = ctx.mkSolver(ctx.mkTactic(Dartagnan.TACTIC));

        BoolExpr sourceDF = pSource.encodeDF(ctx);
        BoolExpr sourceCF = pSource.encodeCF(ctx);
        BoolExpr sourceDF_RF = pSource.encodeDF_RF(ctx);
        BoolExpr sourceFV = pSource.encodeFinalValues(ctx);
        BoolExpr sourceMM = mcmS.encode(pSource, ctx, cmd.hasOption("relax"), cmd.hasOption("idl"));

        s.add(pTarget.encodeDF(ctx));
        s.add(pTarget.encodeCF(ctx));
        s.add(pTarget.encodeDF_RF(ctx));
        s.add(pTarget.encodeFinalValues(ctx));
        s.add(mcmT.encode(pTarget, ctx, cmd.hasOption("relax"), cmd.hasOption("idl")));
        s.add(mcmT.consistent(pTarget, ctx));

        s.add(sourceDF);
        s.add(sourceCF);
        s.add(sourceDF_RF);
        s.add(sourceFV);
        s.add(sourceMM);
        s.add(mcmS.inconsistent(pSource, ctx));

        s.add(encodeCommonExecutions(pTarget, pSource, ctx));

        s2.add(sourceDF);
        s2.add(sourceCF);
        s2.add(sourceDF_RF);
        s2.add(sourceFV);
        s2.add(sourceMM);
        s2.add(mcmS.consistent(pSource, ctx));

        int iterations = 0;
        Status lastCheck = Status.SATISFIABLE;
        Set<Expr> visited = new HashSet<>();

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
                        Graph graph = new Graph(s.getModel(), ctx);
                        String outputPath = cmd.getOptionValue("draw");
                        ctx.setPrintMode(Z3_ast_print_mode.Z3_PRINT_SMTLIB_FULL);
                        if(cmd.hasOption("rels")) {
                            graph.addRelations(Arrays.asList(cmd.getOptionValue("rels").split(",")));
                        }
                        graph.build(pSource, pTarget).draw(outputPath);
                        System.out.println("Execution graph is written to " + outputPath);
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