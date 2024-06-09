package com.dat3m.dartagnan.program.analysis.simulation;

import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.encoding.ProgramEncoder;
import com.dat3m.dartagnan.encoding.WmmEncoder;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.processing.ExprTransformer;
import com.dat3m.dartagnan.expression.processing.ExpressionInspector;
import com.dat3m.dartagnan.expression.type.AggregateType;
import com.dat3m.dartagnan.expression.type.FunctionType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.*;
import com.dat3m.dartagnan.program.analysis.LoopAnalysis;
import com.dat3m.dartagnan.program.event.*;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.Local;
import com.dat3m.dartagnan.program.memory.Memory;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.program.misc.NonDetValue;
import com.dat3m.dartagnan.program.processing.IdReassignment;
import com.dat3m.dartagnan.program.processing.ProcessingManager;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.verification.solving.ModelChecker;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.RelationNameRepository;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.axiom.ForceEncodeAxiom;
import com.google.common.base.CharMatcher;
import com.google.common.collect.Lists;
import com.google.common.collect.Sets;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.java_smt.SolverContextFactory;
import org.sosy_lab.java_smt.api.*;
import org.sosy_lab.java_smt.api.visitors.DefaultFormulaVisitor;
import org.sosy_lab.java_smt.api.visitors.FormulaVisitor;
import org.sosy_lab.java_smt.api.visitors.TraversalProcess;

import java.util.*;

/*
    Checks if function f can simulate function g.
    Assumptions about the shape of f and g:
    - Both functions have the same arguments (modulo renaming)
    - Both functions have the same return type and use a single return statement.

          OutT f/g(InT1 in1, InT2 in2, ..., InTk ink) {
            // ... body ...
            return outputExpr; // Single return
          }

    - Program constants and memory objects referenced in f/g are implicitly treated as additional inputs.
    - Memory loads can also implicitly be understood as special inputs (with some special conditions).
    - Functions may use non-deterministic choice. Unlike inputs, when simulating, the functions may do

 */

public class SimulationChecker {

    public void test(Function f) {
        List<LoopAnalysis.LoopInfo> loops = LoopAnalysis.onFunction(f, false).getLoopsOfFunction(f);

        for (LoopAnalysis.LoopInfo loop : loops) {
            assert !loop.isUnrolled();
            final LoopAnalysis.LoopIterationInfo loopBody = loop.iterations().get(0);
            final OpenFunction func = OpenFunction.fromSnippet(loopBody.getIterationStart(), loopBody.getIterationEnd());

            final OpenFunction src = func.constructLoopBoundedCopy(6);
            final OpenFunction sim = func.constructLoopBoundedCopy(5);
            canSimulate(src.getFunction(), sim.getFunction());
        }
    }

    // Checks if "src <= sim": For every execution of src with input I, there is an execution of sim
    // on the same input I that (i) produces the same return values and (ii) is at least as consistent as src's execution.
    public boolean canSimulate(Function src, Function sim) {
        if (!src.getFunctionType().equals(sim.getFunctionType())) {
            return false;
        }

        final Program commonProg = constructCommonProgram(src, sim, Program.SourceLanguage.LLVM);
        final SimulationCheck check = generateThreads(commonProg);
        process(check);
        try {
            check(check);
        } catch (InvalidConfigurationException e) {
            throw new RuntimeException(e);
        }

        /*
            Plan:
            (1) We construct a program that contains f and g:
                - We make a copy of all the program constants and memory objects referenced by both functions
            (2) We generate two threads, one for f and one for g of the shape:
                    void thread_f/g() {
                        in_reg_1 = in_1 // in_i are free variables
                        ...
                        in_reg_k = in_k
                        result = call f/g(in_reg_1, ..., in_reg_k)
                        out_reg_1 = extract(result, 0)
                        ...
                        out_reg_m = extract(result, m-1)
                    }
             (3) We generate the encodings phi_f and phi_g for thread_f and thread_g without a memory model encoding
                 (also no rf-edges; loads can take arbitrary values). We only require tracking of po, idd, data/addr/ctrl.
             (4) We encode "forall vars(phi_f): (phi_f => exists unique_vars(phi_g): phi_g /\ matching)"
                 - We universally quantify over all variables of phi_f (some of which may be shared with phi_g)
                   and existentially quantify over those variables in phi_g that are not shared with phi_f.
                 - "matching" is an encoding that makes sure that the execution encoded by phi_g matches with the one
                    encoded by phi_f:
                    -- Whenever g performs a visible event then it must match with one performed by f.
                    -- Whenever two g-events are related by po/dep, then so must the matching events in f.
                    -- Whenever input/output regs in g are related by idd, then so must the input/output regs in f must be matched
         */

        return false;
    }

    /*
        Construct a program that contains both f and g, including all their referenced memory objects and program constants
        NOTE: Currently does not copy over referenced functions (if f/g still have function class inside).
     */
    private Program constructCommonProgram(Function f, Function g, Program.SourceLanguage sourceLang) {
        final Set<MemoryObject> memObjs = new HashSet<>();
        final Set<NonDetValue> progConstants = new HashSet<>();

        final ExpressionInspector collector = new ExpressionInspector() {
            @Override
            public Expression visitMemoryObject(MemoryObject memObj) {
                memObjs.add(memObj);
                return memObj;
            }

            @Override
            public Expression visitNonDetValue(NonDetValue nonDet) {
                progConstants.add(nonDet);
                return nonDet;
            }
        };
        f.getEvents(RegReader.class).forEach(reader -> reader.transformExpressions(collector));
        g.getEvents(RegReader.class).forEach(reader -> reader.transformExpressions(collector));

        final Program program = new Program(new Memory(), sourceLang);

        final Map<MemoryObject, MemoryObject> memTranslator = new HashMap<>();
        for (MemoryObject memObj : memObjs) {
            assert memObj.isStaticallyAllocated();
            final MemoryObject copy = program.getMemory().allocate(memObj.size());
            copy.setName(memObj.getName());
            memTranslator.put(memObj, copy);
        }

        final Map<NonDetValue, NonDetValue> progConstTranslator = new HashMap<>();
        for (NonDetValue progConst : progConstants) {
            final NonDetValue copy = (NonDetValue) program.newConstant(progConst.getType());
            copy.setIsSigned(progConst.isSigned());
            progConstTranslator.put(progConst, copy);
        }

        program.addFunction(IRHelper.translateFunction(f, program, memTranslator, progConstTranslator));
        program.addFunction(IRHelper.translateFunction(g, program, memTranslator, progConstTranslator));

        IdReassignment.newInstance().run(program);

        return program;
    }

    private SimulationCheck generateThreads(Program program) {
        final Function src = program.getFunctions().get(0);
        final Function sim = program.getFunctions().get(1);

        final TypeFactory types = TypeFactory.getInstance();
        final ExpressionFactory exprs = ExpressionFactory.getInstance();
        final FunctionType threadType = types.getFunctionType(types.getVoidType(), List.of());

        final Thread srcThread = new Thread(src.getName() + "_src", threadType, List.of(),
                0, EventFactory.newThreadStart(null)
        );
        final Thread simThread = new Thread(sim.getName() + "_sim", threadType, List.of(),
                1, EventFactory.newThreadStart(null)
        );

        final List<NonDetValue> inputConstants = new ArrayList<>();
        final List<Register> srcInputRegs = new ArrayList<>();
        final List<Register> simInputRegs = new ArrayList<>();
        for (Type inputType : src.getFunctionType().getParameterTypes()) {
            final int id =  inputConstants.size();
            final Register srcInputReg = srcThread.newRegister("__input" + id, inputType);
            final Register simInputReg = simThread.newRegister("__input" + id, inputType);
            final NonDetValue inputConstant = (NonDetValue) program.newConstant(inputType);

            srcInputRegs.add(srcInputReg);
            final Event srcAssign = EventFactory.newLocal(srcInputReg, inputConstant);
            srcAssign.addTags(Tag.NOOPT);
            srcThread.append(srcAssign);

            simInputRegs.add(simInputReg);
            final Event simAssign = EventFactory.newLocal(simInputReg, inputConstant);
            simAssign.addTags(Tag.NOOPT);
            simThread.append(simAssign);

            inputConstants.add(inputConstant);
        }

        final Register srcCallResultReg = srcThread.newRegister("__callResult", src.getFunctionType().getReturnType());
        final Register simCallResultReg = simThread.newRegister("__callResult", sim.getFunctionType().getReturnType());
        srcThread.append(EventFactory.newValueFunctionCall(srcCallResultReg, src, Lists.transform(srcInputRegs, reg -> reg)));
        simThread.append(EventFactory.newValueFunctionCall(simCallResultReg, sim, Lists.transform(simInputRegs, reg -> reg)));

        //TODO: Extend to non-aggregate types
        final AggregateType resultType = (AggregateType) src.getFunctionType().getReturnType();
        int nextId = 0;
        for (Type outputType : resultType.getDirectFields()) {
            final int id = nextId++;
            final Register srcOutputReg = srcThread.newRegister("__output" + id, outputType);
            final Register simOutputReg = simThread.newRegister("__output" + id, outputType);

            final Event srcAssign = EventFactory.newLocal(srcOutputReg, exprs.makeExtract(id, srcCallResultReg));
            srcAssign.addTags(Tag.NOOPT);
            srcThread.append(srcAssign);

            final Event simAssign = EventFactory.newLocal(simOutputReg, exprs.makeExtract(id, simCallResultReg));
            simAssign.addTags(Tag.NOOPT);
            simThread.append(simAssign);
        }
        // TODO: Maybe add a dummy event that uses all output registers, so we do not have to mark them as NOOPT?

        // TODO: Check if really necessary
        srcThread.append(EventFactory.newLabel("END_OF_T"));
        simThread.append(EventFactory.newLabel("END_OF_T"));

        program.addThread(srcThread);
        program.addThread(simThread);

        final SimulationCheck check = new SimulationCheck(program, srcThread, simThread, inputConstants);
        return check;

    }

    private void process(SimulationCheck check) {
        // TODO: TEST CODE
        final Program program = check.program;
        //check.source.getEntry().insertAfter(EventFactory.newAssume(program.getConstants().stream().findFirst().get()));
        try {
            IdReassignment.newInstance().run(program);
            ProcessingManager.fromConfig(Configuration.defaultConfiguration()).run(program);
        } catch (InvalidConfigurationException e) {
            throw new RuntimeException(e);
        }

        assert program.getThreads().size() == 2;
        // Undo copy-propagated assignments `__input#i <- nondetValue#i` to the input variables to generate
        // a normalized form
        for (Thread thread : program.getThreads()) {
            final Map<Expression, Expression> replacementMap = new HashMap<>();
            final Set<Event> inputLocals = new HashSet<>();
            for (Local local : thread.getEvents(Local.class)) {
                if (local.getResultRegister().getName().startsWith("__input") && check.inputConstants.contains(local.getExpr())) {
                    replacementMap.put(local.getExpr(), local.getResultRegister());
                    inputLocals.add(local);
                }
            }

            final ExprTransformer replacer = new ExprTransformer() {
                @Override
                public Expression visitNonDetValue(NonDetValue nonDet) {
                    return replacementMap.getOrDefault(nonDet, nonDet);
                }
            };

            thread.getEvents(RegReader.class)
                    .stream().filter(reader -> !inputLocals.contains(reader))
                    .forEach(reader -> reader.transformExpressions(replacer));
        }
    }

    private boolean check(SimulationCheck check) throws InvalidConfigurationException {
        // ----------------- Construct bare-bones Wmm and verification task -----------------
        final List<String> importantRelations = List.of(
                RelationNameRepository.DATA,
                RelationNameRepository.CTRL,
                RelationNameRepository.ADDR,
                RelationNameRepository.IDDTRANS,
                RelationNameRepository.PO
        );
        final Wmm wmm = new Wmm();
        wmm.removeDefinition(wmm.getRelation(RelationNameRepository.RF));
        wmm.deleteRelation(wmm.getRelation(RelationNameRepository.RF));
        wmm.removeDefinition(wmm.getRelation(RelationNameRepository.CO));
        wmm.deleteRelation(wmm.getRelation(RelationNameRepository.CO));
        for (String importantRel : importantRelations) {
            final Relation rel = wmm.getOrCreatePredefinedRelation(importantRel);
            wmm.addConstraint(new ForceEncodeAxiom(rel));
        }
        final VerificationTask task = VerificationTask.builder()
                .build(check.program, wmm, EnumSet.noneOf(Property.class));

        // ----------------- Perform analyses -----------------
        final Configuration config = Configuration.defaultConfiguration();
        final Context analysisContext = Context.create();
        ModelChecker.performStaticProgramAnalyses(task, analysisContext, config);
        ModelChecker.performStaticWmmAnalyses(task, analysisContext, config);

        // ----------------- Generate encoding -----------------
        try (SolverContext solverContext = SolverContextFactory.createSolverContext(SolverContextFactory.Solvers.Z3);
                ProverEnvironment prover = solverContext.newProverEnvironment(SolverContext.ProverOptions.GENERATE_MODELS)) {

            final EncodingContext ctx = EncodingContext.of(task, analysisContext, solverContext.getFormulaManager());
            final BooleanFormulaManager bmgr = ctx.getBooleanFormulaManager();
            final WmmEncoder wmmEncoder = WmmEncoder.withContext(ctx);


            // --------------------------- Program encodings ------------------------------------
            final ProgramEncoder programEncoder = ProgramEncoder.withContext(ctx);
            final BooleanFormula srcProgEnc = bmgr.and(
                    programEncoder.encodeThreadCF(check.source),
                    programEncoder.encodeThreadDataFlow(check.source)
            );
            final BooleanFormula simProgEnc = bmgr.and(
                    programEncoder.encodeThreadCF(check.simulator),
                    programEncoder.encodeThreadDataFlow(check.simulator)
            );
            final BooleanFormula commonProgEnc = bmgr.and(programEncoder.encodeConstants(), programEncoder.encodeMemory());

            // -------------------------- Wmm encodings ------------------------------------------
            final BooleanFormula wmmEnc = ctx.getFormulaManager().simplify(wmmEncoder.encodeRelations());
            final List<BooleanFormula> srcWmmEnc = new ArrayList<>();
            final List<BooleanFormula> simWmmEnc = new ArrayList<>();
            separateWmmConstraints(check, ctx, wmmEnc, srcWmmEnc, simWmmEnc);

            final BooleanFormula sourceEnc = bmgr.and(srcProgEnc, bmgr.and(srcWmmEnc));
            final BooleanFormula simulatorEnc = bmgr.and(simProgEnc, bmgr.and(simWmmEnc));

            // We add the common variables to the src
            final Set<Formula> srcVars = extractVariables(sourceEnc, ctx.getFormulaManager());
            srcVars.addAll(extractVariables(commonProgEnc, ctx.getFormulaManager()));
            check.source.getEvents(Load.class).forEach(m -> {
                    srcVars.add(ctx.value(m));
            });

            final Set<Formula> simVars = new HashSet<>(Sets.difference(
                    extractVariables(simulatorEnc, ctx.getFormulaManager()),
                    srcVars
            ));
            check.simulator.getEvents(Load.class).forEach(m -> {
                simVars.add(ctx.value(m));
            });

            final Set<NonDetValue> srcConsts = IRHelper.collectProgramConstants(check.source.getEvents());
            for (NonDetValue progConst : check.program.getConstants()) {
                final Formula exprForm = ctx.encodeFinalExpression(progConst);
                if (srcConsts.contains(progConst)) {
                    srcVars.add(exprForm);
                    simVars.remove(exprForm);
                } else {
                    simVars.add(exprForm);
                }
            }


            // --------------------------- Generate encoding ------------------------------------
            final QuantifiedFormulaManager qfm = ctx.getFormulaManager().getQuantifiedFormulaManager();
            final BooleanFormula matchingEnc = constructMatchingEncoding(check, ctx);
            final Set<Formula> matchingVars = extractVariables(matchingEnc, ctx.getFormulaManager());
            final Set<Formula> matchSrc = new HashSet<>();
            final Set<Formula> matchSim = new HashSet<>();
            for (Formula formula : matchingVars) {
                if (srcVars.contains(formula)) {
                    matchSrc.add(formula);
                } else {
                    assert simVars.contains(formula);
                    matchSim.add(formula);
                }
            }
            // Check:
            // Exists commonVars, srcVars: IsSrcExec(commonVars, srcVars)
            //   /\ (forall simVars: !(IsSimExec(commonVars, simVars) /\ match(srcVars, simVars))
            final BooleanFormula enc = bmgr.and(
                    bmgr.and(commonProgEnc, sourceEnc),
                    qfm.forall(new ArrayList<>(simVars), bmgr.not(bmgr.and(simulatorEnc, matchingEnc)))
            );


            prover.addConstraint(enc);
            boolean canSimulate = prover.isUnsat();

            // TODO: Test code
            /*final List<Event> srcBody = check.source.getEvents();
            final List<Event> simBody = check.simulator.getEvents();
            Model model = !canSimulate ? prover.getModel() : null;*/

            return canSimulate;
        } catch (InterruptedException | SolverException e) {
            throw new RuntimeException(e);
        }
    }

    private static void separateWmmConstraints(SimulationCheck check, EncodingContext ctx, BooleanFormula wmmEnc,
                                               List<BooleanFormula> srcWmmEnc, List<BooleanFormula> simWmmEnc) {
        ctx.getFormulaManager().visitRecursively(wmmEnc, new DefaultFormulaVisitor<TraversalProcess>() {
            @Override
            protected TraversalProcess visitDefault(Formula formula) {
                return null;
            }

            @Override
            public TraversalProcess visitFunction(Formula f, List<Formula> args, FunctionDeclaration<?> functionDeclaration) {
                if (functionDeclaration.getKind() != FunctionDeclarationKind.AND) {
                    return TraversalProcess.SKIP;
                }

                for (Formula arg : args) {
                    final List<Boolean> belongsToSimulator = new ArrayList<>();
                    final FormulaVisitor<TraversalProcess> scanner = new DefaultFormulaVisitor<TraversalProcess>() {
                        @Override
                        protected TraversalProcess visitDefault(Formula formula) {
                            return TraversalProcess.CONTINUE;
                        }

                        final CharMatcher matcher = CharMatcher.inRange('0', '9').or(CharMatcher.is(','))
                                .precomputed();

                        @Override
                        public TraversalProcess visitFreeVariable(Formula f, String name) {
                            final String numString = matcher.retainFrom(name);
                            if (numString.isEmpty()) {
                                return TraversalProcess.CONTINUE;
                            }

                            final String[] evRefs = numString.split(",");
                            final List<Integer> events = Arrays.stream(evRefs).map(Integer::parseInt).toList();
                            if (events.stream().noneMatch(e -> e <= check.source.getExit().getGlobalId())) {
                                belongsToSimulator.add(true);
                                return TraversalProcess.ABORT;
                            } else {
                                return TraversalProcess.CONTINUE;
                            }
                        }
                    };
                    ctx.getFormulaManager().visitRecursively(arg, scanner);
                    if (belongsToSimulator.isEmpty()) {
                        srcWmmEnc.add((BooleanFormula) arg);
                    } else {
                        simWmmEnc.add((BooleanFormula) arg);
                    }
                }
                return TraversalProcess.ABORT;
            }
        });
    }

    private BooleanFormula constructMatchingEncoding(SimulationCheck check, EncodingContext ctx) {

        final BooleanFormulaManager bmgr = ctx.getBooleanFormulaManager();
        final List<BooleanFormula> enc = new ArrayList<>();

        // ----- Match loads -----
        for (Load load : check.simulator.getEvents(Load.class)) {
            final List<BooleanFormula> matchings = new ArrayList<>();
            final Formula loadVal = ctx.value(load);
            for (Load srcLoad : check.source.getEvents(Load.class)) {
                matchings.add(bmgr.and(
                        ctx.execution(srcLoad),
                        ctx.sameAddress(load, srcLoad),
                        ctx.equal(loadVal, ctx.value(srcLoad))
                ));
            }
            enc.add(bmgr.implication(ctx.execution(load), bmgr.or(matchings)));
        }
        // ----- Match output -----
        for (RegWriter writer : check.source.getEvents(RegWriter.class)) {
            if (!writer.getResultRegister().getName().contains("__output")) {
                continue;
            }

            final RegWriter simulatingWriter = check.simulator.getEvents(RegWriter.class).stream().filter(w ->
                    w.getResultRegister().getName().equals(writer.getResultRegister().getName()
            )).findFirst().orElseThrow();

            enc.add(ctx.equal(ctx.result(writer), ctx.result(simulatingWriter)));
        }

        return bmgr.and(enc);
    }


    private Set<Formula> extractVariables(Formula formula, FormulaManager fmgr) {
        final Set<Formula> vars = new HashSet<>();
        fmgr.visitRecursively(formula, new DefaultFormulaVisitor<TraversalProcess>() {
            @Override
            protected TraversalProcess visitDefault(Formula formula) {
                return TraversalProcess.CONTINUE;
            }

            @Override
            public TraversalProcess visitFreeVariable(Formula f, String name) {
                vars.add(f);
                return TraversalProcess.CONTINUE;
            }
        });
        return vars;
    }

    private class SimulationCheck {

        private final Program program;
        private final Thread source;
        private final Thread simulator;

        private final List<NonDetValue> inputConstants;

        private SimulationCheck(Program program, Thread source, Thread simulator, List<NonDetValue> inputConstants) {
            this.program = program;
            this.source = source;
            this.simulator = simulator;
            this.inputConstants = inputConstants;
        }

    }

}
