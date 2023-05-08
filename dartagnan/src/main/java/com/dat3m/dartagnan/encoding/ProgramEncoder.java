package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.BranchEquivalence;
import com.dat3m.dartagnan.program.analysis.Dependency;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.memory.Memory;
import com.google.common.base.Preconditions;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;
import org.sosy_lab.java_smt.api.*;
import org.sosy_lab.java_smt.api.NumeralFormula.IntegerFormula;

import java.util.*;

import static com.dat3m.dartagnan.GlobalSettings.*;
import static com.dat3m.dartagnan.configuration.OptionNames.INITIALIZE_REGISTERS;
import static com.google.common.collect.Lists.reverse;

@Options
public class ProgramEncoder implements Encoder {

    private static final Logger logger = LogManager.getLogger(ProgramEncoder.class);

    // =========================== Configurables ===========================

    @Option(name = INITIALIZE_REGISTERS,
            description = "Assume thread-local variables start off containing zero.",
            secure = true)
    private boolean initializeRegisters = false;

    // =====================================================================

    private final EncodingContext context;
    private final ExecutionAnalysis exec;
    private final Dependency dep;

    private ProgramEncoder(EncodingContext c) {
        Preconditions.checkArgument(c.getTask().getProgram().isCompiled(), "The program must be compiled before encoding.");
        context = c;
        c.getAnalysisContext().requires(BranchEquivalence.class);
        this.exec = c.getAnalysisContext().requires(ExecutionAnalysis.class);
        this.dep = c.getAnalysisContext().requires(Dependency.class);
    }

    public static ProgramEncoder withContext(EncodingContext context) throws InvalidConfigurationException {
        ProgramEncoder encoder = new ProgramEncoder(context);
        context.getTask().getConfig().inject(encoder);
        logger.info("{}: {}", INITIALIZE_REGISTERS, encoder.initializeRegisters);
        return encoder;
    }

    // ============================== Encoding ==============================

    public BooleanFormula encodeFullProgram() {
        return context.getBooleanFormulaManager().and(
                encodeMemory(),
                encodeControlFlow(),
                encodeFinalRegisterValues(),
                encodeFilter(),
                encodeDependencies());
    }

    public BooleanFormula encodeControlFlow() {
        logger.info("Encoding program control flow");

        BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        List<BooleanFormula> enc = new ArrayList<>();
        for(Thread t : context.getTask().getProgram().getThreads()){
            enc.add(encodeThreadCF(t));
        }
        return bmgr.and(enc);
    }

    private BooleanFormula encodeThreadCF(Thread thread) {
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();

        Map<Label, Set<CondJump>> labelJumpMap = new HashMap<>();
        Event pred = null;
        final List<BooleanFormula> enc = new ArrayList<>();
        for(Event e : thread.getEntry().getSuccessors()) {
            // Immediate control flow
            BooleanFormula cfCond = pred == null ? bmgr.makeTrue() : context.controlFlow(pred);
            if (pred instanceof CondJump) {
                CondJump jump = (CondJump) pred;
                cfCond = bmgr.and(cfCond, bmgr.not(context.jumpCondition(jump)));
                // NOTE: we need to register the actual jumps here, because the
                // listener sets of labels is too large (it contains old copies)
                labelJumpMap.computeIfAbsent(jump.getLabel(), key -> new HashSet<>()).add(jump);
            }

            // Control flow via jumps
            if (e instanceof Label) {
                for (CondJump jump : labelJumpMap.getOrDefault(e, Collections.emptySet())) {
                    cfCond = bmgr.or(cfCond, bmgr.and(context.controlFlow(jump), context.jumpCondition(jump)));
                }
            }
            enc.add(bmgr.equivalence(context.controlFlow(e), cfCond));
            enc.add(e.encodeExec(context));
            pred = e;
        }
        return bmgr.and(enc);
    }

    // Assigns each Address a fixed memory address.
    public BooleanFormula encodeMemory() {
        logger.info("Encoding fixed memory");
        final Memory memory = context.getTask().getProgram().getMemory();
        final FormulaManager fmgr = context.getFormulaManager();
        
        BooleanFormula[] addrExprs;
        if(getArchPrecision() > -1) {
        	final BitvectorFormulaManager bvmgr = fmgr.getBitvectorFormulaManager();
            addrExprs = memory.getObjects().stream()
                    .map(addr -> bvmgr.equal((BitvectorFormula)addr.toIntFormula(fmgr),
                    		bvmgr.makeBitvector(getArchPrecision(), addr.getValue().intValue())))
                    .toArray(BooleanFormula[]::new);        	
        } else {
            final IntegerFormulaManager imgr = fmgr.getIntegerFormulaManager();
            addrExprs = memory.getObjects().stream()
                    .map(addr -> imgr.equal((IntegerFormula)addr.toIntFormula(fmgr),
                    		imgr.makeNumber(addr.getValue().intValue())))
                    .toArray(BooleanFormula[]::new);        	
        }
        return fmgr.getBooleanFormulaManager().and(addrExprs);
    }

    /**
     * @return
     * Describes that for each pair of events, if the reader uses the result of the writer,
     * then the value the reader gets from the register is exactly the value that the writer computed.
     * Also, the reader may only use the value of the latest writer that is executed.
     * Also, if no fitting writer is executed, the reader uses 0.
     */
    public BooleanFormula encodeDependencies() {
        logger.info("Encoding dependencies");
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        List<BooleanFormula> enc = new ArrayList<>();
        for(Map.Entry<Event,Map<Register, Dependency.State>> e : dep.getAll()) {
            final Event reader = e.getKey();
            for(Map.Entry<Register, Dependency.State> r : e.getValue().entrySet()) {
                final Formula value = context.encodeIntegerExpressionAt(r.getKey(), reader);
                final Dependency.State state = r.getValue();
                List<BooleanFormula> overwrite = new ArrayList<>();
                for(Event writer : reverse(state.may)) {
                    assert writer instanceof RegWriter;
                    BooleanFormula edge;
                    if(state.must.contains(writer)) {
                        if (exec.isImplied(reader, writer) && reader.cfImpliesExec()) {
                            // This special case is important. Usually, we encode "dep => regValue = regWriterResult"
                            // By getting rid of the guard "dep" in this special case, we end up with an unconditional
                            // "regValue = regWriterResult", which allows the solver to eliminate one of the variables
                            // in preprocessing.
                            assert state.may.size() == 1;
                            edge = bmgr.makeTrue();
                        } else {
                            edge = bmgr.and(context.execution(writer), context.controlFlow(reader));
                        }
                    } else {
                        edge = context.dependency(writer, reader);
                        enc.add(bmgr.equivalence(edge, bmgr.and(context.execution(writer), context.controlFlow(reader), bmgr.not(bmgr.or(overwrite)))));
                    }
                    enc.add(bmgr.implication(edge, context.equal(value, context.result((RegWriter) writer))));
                    overwrite.add(context.execution(writer));
                }
                if(initializeRegisters && !state.initialized) {
                    overwrite.add(bmgr.not(context.controlFlow(reader)));
                    overwrite.add(context.equalZero(value));
                    enc.add(bmgr.or(overwrite));
                }
            }
        }
        return bmgr.and(enc);
    }

    public BooleanFormula encodeFilter() {
    	return context.getTask().getProgram().getFilterSpecification() != null ?
                context.getTask().getProgram().getFilterSpecification().encode(context) :
    			context.getBooleanFormulaManager().makeTrue();
    }
    
    public BooleanFormula encodeFinalRegisterValues() {
        final FormulaManager fmgr = context.getFormulaManager();
        final BooleanFormulaManager bmgr = fmgr.getBooleanFormulaManager();
        if (context.getTask().getProgram().getFormat() == Program.SourceLanguage.BOOGIE) {
            // Boogie does not have assertions over final register values, so we do not need to encode them.
            logger.info("Skipping encoding of final register values: C-Code has no assertions over those values.");
            return bmgr.makeTrue();
        }

        logger.info("Encoding final register values");
        List<BooleanFormula> enc = new ArrayList<>();
        for(Map.Entry<Register,Dependency.State> e : dep.finalWriters().entrySet()) {
            final Formula value = e.getKey().getLastValueExpr(fmgr);
            final Dependency.State state = e.getValue();
            final List<Event> writers = state.may;
            if(initializeRegisters && !state.initialized) {
                List<BooleanFormula> clause = new ArrayList<>();
                clause.add(context.equalZero(value));
                for(Event w : writers) {
                    clause.add(context.execution(w));
                }
                enc.add(bmgr.or(clause));
            }
            for(int i = 0; i < writers.size(); i++) {
                final Event writer = writers.get(i);
                List<BooleanFormula> clause = new ArrayList<>();
                clause.add(context.equal(value, context.result((RegWriter) writer)));
                clause.add(bmgr.not(context.execution(writer)));
                for(Event w : writers.subList(i + 1, writers.size())) {
                    if(!exec.areMutuallyExclusive(writer, w)) {
                        clause.add(context.execution(w));
                    }
                }
                enc.add(bmgr.or(clause));
            }
        }
        return bmgr.and(enc);
    }
}
