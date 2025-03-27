package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.LoopAnalysis;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.metadata.SourceLocation;
import com.google.common.base.Preconditions;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.util.List;

import static com.dat3m.dartagnan.configuration.OptionNames.NONTERMINATION_INSTRUMENTATION;

/*
    This pass instruments not-fully-unrolled loops to enable the detection of side-effect-ful non-termination.
    It has three modes:
       (i)   Only spin loops: Detects only side-effect-free non-termination (spinning)
       (ii)  Simple:          Detects simple forms of symmetric non-termination where all involved loops repeat the same
                              number of times (incomplete)
       (iii) Full:            Detects all forms of loop non-termination even where different loops run different
                              number of times. See below for detail.

    Instrumentation for mode "Full":
    This pass instruments not-fully-unrolled loops to be able to non-deterministically stop before performing all iterations.
    More precisely, a K-times unrolled loop can non-deterministically stop after < K iterations.
    This is necessary to enable the detection of asymmetric non-termination situations where a loop L1
    runs X times while another loop L2 runs, e.g., 2*X times.
    Without this instrumentation, we would be unable to find such executions if we use a uniform unrolling bound.
 */
@Options
public class NonterminationDetection implements ProgramProcessor {
    
    private static final Logger logger = LogManager.getLogger(NonterminationDetection.class);

    public enum Mode {
        ONLY_SPINLOOPS,
        SIMPLE,
        FULL
    }

    @Option(name = NONTERMINATION_INSTRUMENTATION,
            description = "Sets the precision of non-termination instrumentation: only_spinloops, simple, full (default).",
            secure = true)
    private Mode mode = Mode.FULL;

    private NonterminationDetection() { }

    public static NonterminationDetection newInstance() {
        return new NonterminationDetection();
    }

    public static NonterminationDetection fromConfig(Configuration config) throws InvalidConfigurationException {
        final NonterminationDetection pass = new NonterminationDetection();
        config.inject(pass);
        return pass;
    }

    @Override
    public void run(Program program) {
        logger.info("Non-termination detection mode {}", mode);
        if (mode == Mode.ONLY_SPINLOOPS) {
            // Done by DynamicSpinLoopDetection
            return;
        }
        Preconditions.checkArgument(program.isUnrolled());
        for (Thread thread : program.getThreads()) {
            final LoopAnalysis loopAnalysis = LoopAnalysis.onFunction(thread);
            loopAnalysis.getLoopsOfFunction(thread).stream()
                    .filter(this::isPossiblyNonterminating)
                    .forEach(this::instrumentLoop);
        }

        IdReassignment.newInstance().run(program);

    }

    private void instrumentLoop(LoopAnalysis.LoopInfo loop) {
        Preconditions.checkArgument(loop.isUnrolled());
        Preconditions.checkArgument(loop.function() instanceof Thread);

        final List<LoopAnalysis.LoopIterationInfo> iters;
        if (mode == Mode.FULL) {
            iters = loop.iterations();
        } else if (mode == Mode.SIMPLE) {
            final int last = loop.iterations().size() - 1;
            iters = List.of(loop.iterations().get(last));
        } else {
            throw new IllegalStateException("Unexpected mode: " + mode);
        }
        final Program program = loop.function().getProgram();
        final BooleanType boolType = TypeFactory.getInstance().getBooleanType();
        final Label endOfT = (Label) loop.function().getExit();
        final Event loopHeader = loop.iterations().get(0).getIterationStart();

        for (LoopAnalysis.LoopIterationInfo iter : iters) {
            final Expression guess = program.newConstant(boolType);
            final Event nonterm = EventFactory.newJump(guess, endOfT);
            nonterm.addTags(Tag.NONTERMINATION);
            nonterm.copyMetadataFrom(loopHeader, SourceLocation.class);

            iter.getIterationEnd().insertAfter(nonterm);
        }

    }

    private boolean isPossiblyNonterminating(LoopAnalysis.LoopInfo loop) {
        final LoopAnalysis.LoopIterationInfo lastIter = loop.iterations().get(loop.iterations().size() - 1);
        final Event lastEvent = lastIter.getIterationEnd();

        // TODO: This is a naive check: we assume the bound event is two events after the last loop event.
        //  If it is not, we assume the loop is unrolled and do not instrument it.
        //  This, however, only results in incompleteness of non-termination detection but causes no soundness issues.
        final Event bound = lastEvent.getSuccessor().getSuccessor();
        if (bound instanceof CondJump && bound.hasTag(Tag.BOUND)) {
            // Loop is not fully unrolled and thus might be non-terminating
            return true;
        }
        return false;
    }


}
