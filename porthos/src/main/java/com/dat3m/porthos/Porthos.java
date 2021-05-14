package com.dat3m.porthos;

import com.dat3m.dartagnan.Dartagnan;
import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.porthos.utils.options.PorthosOptions;
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

import static com.dat3m.porthos.Encodings.encodeCommonExecutions;
import static com.dat3m.porthos.Encodings.encodeReachedState;

public class Porthos {

    public static void main(String[] args) throws IOException {

        PorthosOptions options = new PorthosOptions();
        try {
            options.parse(args);
        }
        catch (Exception e){
            if(e instanceof UnsupportedOperationException){
                System.out.println(e.getMessage());
            }
            new HelpFormatter().printHelp("PORTHOS", options);
            System.exit(1);
            return;
        }

        Wmm mcmS = new ParserCat().parse(new File(options.getSourceModelFilePath()));
        Wmm mcmT = new ParserCat().parse(new File(options.getTargetModelFilePath()));

        ProgramParser programParser = new ProgramParser();
        Program pSource = programParser.parse(new File(options.getProgramFilePath()));
        Program pTarget = programParser.parse(new File(options.getProgramFilePath()));

        Context ctx = new Context();
        Solver s1 = ctx.mkSolver(ctx.mkTactic(Settings.TACTIC));
        Solver s2 = ctx.mkSolver(ctx.mkTactic(Settings.TACTIC));

        Arch source = options.getSource();
        Arch target = options.getTarget();
        Settings settings = options.getSettings();
        System.out.println("Settings: " + options.getSettings());

        PorthosResult result = testProgram(s1, s2, ctx, pSource, pTarget, source, target, mcmS, mcmT, settings);

        if(result.getIsPortable()){
            System.out.println("The program is state-portable");
            System.out.println("Iterations: " + result.getIterations());

        } else {
            System.out.println("The program is not state-portable");
            System.out.println("Iterations: " + result.getIterations());
        }

        ctx.close();
    }

    public static PorthosResult testProgram(Solver s1, Solver s2, Context ctx, Program pSource, Program pTarget, Arch source, Arch target,
                                     Wmm sourceWmm, Wmm targetWmm, Settings settings){
        VerificationTask taskSource = new VerificationTask(pSource, sourceWmm, source, settings);
        VerificationTask taskTarget = new VerificationTask(pTarget, targetWmm, target, settings);
    	pSource.unroll(settings.getBound(), 0);
        pTarget.unroll(settings.getBound(), 0);

        int nextId = pSource.compile(source, 0);
        pTarget.compile(target, nextId);

        taskSource.initialiseEncoding(ctx);
        taskTarget.initialiseEncoding(ctx);

		BoolExpr sourceCF = pSource.encodeCF(ctx);
        BoolExpr sourceFV = pSource.encodeFinalRegisterValues(ctx);
        BoolExpr sourceMM = sourceWmm.encode(ctx);

        s1.add(pTarget.encodeCF(ctx));
        s1.add(pTarget.encodeFinalRegisterValues(ctx));
        s1.add(targetWmm.encode(ctx));
        s1.add(targetWmm.consistent(ctx));

        s1.add(sourceCF);
        s1.add(sourceFV);
        s1.add(sourceMM);
        s1.add(sourceWmm.inconsistent(ctx));

        s1.add(encodeCommonExecutions(pTarget, pSource, ctx));

        s2.add(sourceCF);
        s2.add(sourceFV);
        s2.add(sourceMM);
        s2.add(sourceWmm.consistent(ctx));

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