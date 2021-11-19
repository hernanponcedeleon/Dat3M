package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.asserts.AbstractAssert;
import com.dat3m.dartagnan.asserts.AssertCompositeOr;
import com.dat3m.dartagnan.asserts.AssertInline;
import com.dat3m.dartagnan.asserts.AssertTrue;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Local;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.google.common.base.Preconditions;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

import java.util.ArrayList;
import java.util.List;

@Options(prefix = "program.processing")
public class Compilation implements ProgramProcessor {

	public static final String TARGET = "program.processing.compilationTarget";

    private static final Logger logger = LogManager.getLogger(Compilation.class);

    // =========================== Configurables ===========================

    @Option(name = "compilationTarget",
            description = "The target architecture to which the program shall be compiled to.",
            secure = true,
            toUppercase = true)
    private Arch target = Arch.NONE;

    public Arch getTarget() { return target; }
    public void setTarget(Arch target) { this.target = target;}

    // =====================================================================

    private Compilation() { }

    private Compilation(Configuration config) throws InvalidConfigurationException {
        config.inject(this);
    }

    public static Compilation fromConfig(Configuration config) throws InvalidConfigurationException {
        return new Compilation(config);
    }

    public static Compilation newInstance() {
        return new Compilation();
    }


    @Override
    public void run(Program program) {
        if (program.isCompiled()) {
            logger.warn("Skipped compilation: Program is already compiled to {}", program.getArch());
            return;
        }
        Preconditions.checkArgument(program.isUnrolled(), "The program needs to be unrolled before compilation.");

        int nextId = 0;
        for(Thread thread : program.getThreads()){
            nextId = compileThread(thread, nextId);

            int fId = 0;
            for (Event e : thread.getEvents()) {
                e.setFId(fId++);
            }
        }

        program.setArch(target);
        program.clearCache(false);
        program.markAsCompiled();
        logger.info("Program compiled to {}", target);

        updateAssertions(program);
    }

    private int compileThread(Thread thread, int nextId) {
        Event pred = thread.getEntry();
        Event toBeCompiled = pred.getSuccessor();

        int fId = 0;
        pred.setFId(fId++);
        pred.setCId(nextId++);

        while (toBeCompiled != null) {
            List<Event> compiledEvents = toBeCompiled.compile(target);
            for (Event e : compiledEvents) {
                pred.setFId(fId++);
                e.setOId(toBeCompiled.getOId());
                e.setUId(toBeCompiled.getUId());
                e.setCId(nextId++);
                e.setThread(thread);
                pred.setSuccessor(e);
                pred = e;
            }

            toBeCompiled = toBeCompiled.getSuccessor();
        }

        thread.updateExit(thread.getEntry());
        thread.clearCache();
        return nextId;
    }

    private void updateAssertions(Program program) {
        if (program.getAss() != null) {
            //TODO: Check why exactly this is needed. Litmus tests seem to have the assertion already defined
            // but I was under the impression that assFilter was used for Litmus tests.
            return;
        }

        List<Event> assertions = new ArrayList<>();
        for(Thread t : program.getThreads()){
            assertions.addAll(t.getCache().getEvents(FilterBasic.get(EType.ASSERTION)));
        }
        AbstractAssert ass = new AssertTrue();
        if(!assertions.isEmpty()) {
            ass = new AssertInline((Local)assertions.get(0));
            for(int i = 1; i < assertions.size(); i++) {
                ass = new AssertCompositeOr(ass, new AssertInline((Local)assertions.get(i)));
            }
        }
        program.setAss(ass);

        //TODO: It probably makes more sense to move this code to LoopUnrolling
        logger.info("Updated assertions after compilation.");
    }

}
