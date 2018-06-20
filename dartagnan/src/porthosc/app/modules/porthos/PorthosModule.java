package porthosc.app.modules.porthos;

import com.microsoft.z3.*;
import com.microsoft.z3.enumerations.Z3_ast_print_mode;
import porthosc.app.errors.AppError;
import porthosc.app.errors.IOError;
import porthosc.app.errors.UnrecognisedError;
import porthosc.app.modules.AppModule;
import porthosc.app.modules.AppVerdict;
import porthosc.languages.common.InputExtensions;
import porthosc.languages.common.InputLanguage;
import porthosc.languages.conversion.toxgraph.Y2XConverter;
import porthosc.languages.conversion.toxgraph.unrolling.XProgramTransformer;
import porthosc.languages.conversion.toytree.YtreeParser;
import porthosc.languages.conversion.tozformula.XProgram2ZformulaEncoder;
import porthosc.languages.syntax.xgraph.program.XCyclicProgram;
import porthosc.languages.syntax.xgraph.program.XProgram;
import porthosc.languages.syntax.ytree.YSyntaxTree;
import porthosc.memorymodels.Encodings;
import porthosc.memorymodels.wmm.MemoryModel;

import java.io.File;
import java.io.IOException;
import java.util.HashSet;
import java.util.Set;

//import porthosc.program.Init;


@SuppressWarnings("deprecation")
public class PorthosModule extends AppModule {

    private final PorthosOptions options;

    public PorthosModule(PorthosOptions options) {
        this.options = options;
    }

    @Override
    public PorthosVerdict run() {

        PorthosVerdict verdict = new PorthosVerdict(options);
        verdict.startAll();

        try {
            //todo: solving timeout!
            int unrollBound = options.unrollingBound;

            MemoryModel.Kind source = options.sourceModel;
            MemoryModel.Kind target = options.targetModel;

            File inputProgramFile = options.inputProgramFile;
            InputLanguage language = InputExtensions.parseProgramLanguage(inputProgramFile.getName());
            YtreeParser parser = new YtreeParser(inputProgramFile, language);
            YSyntaxTree yTree = parser.parseFile();

            Context ctx = new Context();

            verdict.onStart(AppVerdict.ProgramStage.Interpretation);
            XProgram pSource = compile(yTree, source, unrollBound, verdict);
            XProgram pTarget = compile(yTree, target, unrollBound, verdict);
            verdict.onFinish(AppVerdict.ProgramStage.Interpretation);

            XProgram2ZformulaEncoder sourceEncoder = new XProgram2ZformulaEncoder(ctx, pSource);
            XProgram2ZformulaEncoder targetEncoder = new XProgram2ZformulaEncoder(ctx, pTarget);


            ctx.setPrintMode(Z3_ast_print_mode.Z3_PRINT_SMTLIB_FULL);
            Solver s = ctx.mkSolver();
            Solver s2 = ctx.mkSolver();

            verdict.onStart(AppVerdict.ProgramStage.ProgramEncoding);
            BoolExpr sourceEnc = sourceEncoder.encodeProgram(pSource);
            s.add(targetEncoder.encodeProgram(pTarget));
            verdict.onFinish(AppVerdict.ProgramStage.ProgramEncoding);

            verdict.onStart(AppVerdict.ProgramStage.ProgramDomainEncoding);
            BoolExpr sourceDomain = sourceEncoder.Domain_encode(pSource);
            s.add(targetEncoder.Domain_encode(pTarget));
            s.add(Encodings.encodeCommonExecutions(pTarget, pSource, ctx));
            verdict.onFinish(AppVerdict.ProgramStage.ProgramDomainEncoding);

            verdict.onStart(AppVerdict.ProgramStage.MemoryModelEncoding);
            BoolExpr sourceMM = pSource.encodeMM(ctx, source);
            s.add(pTarget.encodeMM(ctx, target));
            s.add(pTarget.encodeConsistent(ctx, target));
            s.add(sourceEnc);
            s.add(sourceDomain);
            s.add(sourceMM);
            s.add(pSource.encodeInconsistent(ctx, source));
            s2.add(sourceEnc);
            s2.add(sourceDomain);
            s2.add(sourceMM);
            s2.add(pSource.encodeConsistent(ctx, source));
            verdict.onFinish(AppVerdict.ProgramStage.MemoryModelEncoding);

            verdict.onStart(AppVerdict.ProgramStage.Solving);

            if(options.mode == PorthosMode.ExecutionInslusion) {
                if(s.check() == Status.SATISFIABLE) {
                    verdict.result = PorthosVerdict.Status.NonExecutionPortable;
                    //if(outputGraphFile != null) {
                    //    String outputPath = outputGraphFile;
                    //    Utils.drawGraph(program, pSource, pTarget, ctx, s.getModel(), outputPath, rels);
                    //}
                }
                else {
                    verdict.result = PorthosVerdict.Status.ExecutionPortable;
                }
            }
            else {
                int iterations = 0;
                Status lastCheck;
                Set<Expr> visited = new HashSet<>();

                while (true) {

                    lastCheck = s.check();
                    if(lastCheck == Status.SATISFIABLE) {
                        iterations = iterations + 1;
                        Model model = s.getModel();
                        s2.push();
                        BoolExpr reachedState = Encodings.encodeReachedState(pTarget, model, ctx);
                        visited.add(reachedState);
                        assert(iterations == visited.size());
                        s2.add(reachedState);
                        if(s2.check() == Status.UNSATISFIABLE) {
                            //System.out.println("The program is not state-portable");
                            verdict.iterations = iterations;
                            verdict.result = PorthosVerdict.Status.NonStatePortable;
                            break;
                        }
                        else {
                            s2.pop();
                            s.add(ctx.mkNot(reachedState));
                        }
                    }
                    else {
                        verdict.iterations = iterations;
                        verdict.result = PorthosVerdict.Status.StatePortable;
                        break;
                    }
                }
            }
            verdict.onFinish(AppVerdict.ProgramStage.Solving);
            verdict.finishAll();
            return verdict;

        } catch (IOException e) {
            verdict.addError(new IOError(e));
        } catch (Exception e) {
            verdict.addError(new UnrecognisedError(AppError.Severity.Critical, e));
        }

        return verdict;
    }

    private XProgram compile(YSyntaxTree yTree, MemoryModel.Kind memoryModelKind, int unrollBound, PorthosVerdict verdict) {
        verdict.onStart(AppVerdict.ProgramStage.Unrolling);
        Y2XConverter yConverter = new Y2XConverter(memoryModelKind);
        XCyclicProgram program = yConverter.convert(yTree);
        XProgram result = XProgramTransformer.unroll(program, unrollBound);
        verdict.onFinish(AppVerdict.ProgramStage.Unrolling);
        return result;
    }
}
