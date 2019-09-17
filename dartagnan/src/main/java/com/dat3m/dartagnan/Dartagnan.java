package com.dat3m.dartagnan;

import com.dat3m.dartagnan.utils.options.DartagnanOptions;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.microsoft.z3.Context;
import com.microsoft.z3.Solver;
import com.microsoft.z3.enumerations.Z3_ast_print_mode;
import com.dat3m.dartagnan.asserts.AbstractAssert;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.Graph;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.wmm.Wmm;
import org.apache.commons.cli.*;

import static com.dat3m.dartagnan.utils.Result.UNKNOWN;
import static com.dat3m.dartagnan.utils.Result.getResult;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

public class Dartagnan {

    public static void main(String[] args) throws IOException {

        DartagnanOptions options = new DartagnanOptions();
        try {
            options.parse(args);
        }
        catch (Exception e){
            if(e instanceof UnsupportedOperationException){
                System.out.println(e.getMessage());
            }
            new HelpFormatter().printHelp("DARTAGNAN", options);
            System.exit(1);
            return;
        }

        Wmm mcm = new ParserCat().parse(new File(options.getTargetModelFilePath()));
        File programFile = new File(options.getProgramFilePath());
		Program p = new ProgramParser().parse(programFile);

        Arch target = p.getArch();
        if(target == null){
            target = options.getTarget();
        }
        if(target == null) {
            System.out.println("Compilation target cannot be inferred");
            System.exit(0);
            return;
        }
        
        Context ctx = new Context();
        Solver s = ctx.mkSolver(ctx.mkTactic(Settings.TACTIC));
        Settings settings = options.getSettings();

        Result result = testProgram(s, ctx, p, mcm, target, settings);

        if(options.getProgramFilePath().endsWith(".litmus")) {
            System.out.println("Settings: " + options.getSettings());
            if(p.getAssFilter() != null){
                System.out.println("Filter " + (p.getAssFilter()));
            }
            System.out.println("Condition " + p.getAss().toStringWithType());
            System.out.println(result == Result.FAIL ? "Ok" : "No");        	
        } else {
        	System.out.println(result);
        }

        if(settings.getDrawGraph() && canDrawGraph(p.getAss(), result == Result.FAIL)) {
            ctx.setPrintMode(Z3_ast_print_mode.Z3_PRINT_SMTLIB_FULL);
            drawGraph(new Graph(s.getModel(), ctx, p, settings.getGraphRelations()), options.getGraphFilePath());
            System.out.println("Execution graph is written to " + options.getGraphFilePath());
        }

        ctx.close();
    }

    public static Result testProgram(Solver solver, Context ctx, Program program, Wmm wmm, Arch target, Settings settings){

        program.unroll(settings.getBound(), 0);
        program.compile(target, 0);
		program.addAssertions();
		
        solver.add(program.encodeCF(ctx));
        solver.add(program.encodeFinalRegisterValues(ctx));
        solver.add(wmm.encode(program, ctx, settings));
        solver.add(wmm.consistent(program, ctx));
        if(program.getAss() == null){
        	// The compiler might not add the body of inlined functions.
        	// Those functions might be the ones defining the assertion.
        	// This is a current hack to still process the benchmark and
        	// don't be penalized by a wrong result.
        	return UNKNOWN;
        }
        // Used for getting the UNKNOWN
        // pop() is inside getResult
        solver.push();
        solver.add(program.getAss().encode(ctx));
        if(program.getAssFilter() != null){
            solver.add(program.getAssFilter().encode(ctx));
        }

        return getResult(solver, program, ctx);
    }

    public static boolean canDrawGraph(AbstractAssert ass, boolean result){
        String type = ass.getType();
        if(type == null){
            return result;
        }

        if(result){
            return type.equals(AbstractAssert.ASSERT_TYPE_EXISTS) || type.equals(AbstractAssert.ASSERT_TYPE_FINAL);
        }
        return type.equals(AbstractAssert.ASSERT_TYPE_NOT_EXISTS) || type.equals(AbstractAssert.ASSERT_TYPE_FORALL);
    }

    public static void drawGraph(Graph graph, String path) throws IOException {
        File newTextFile = new File(path);
        FileWriter fw = new FileWriter(newTextFile);
        fw.write(graph.toString());
        fw.close();
    }
}
