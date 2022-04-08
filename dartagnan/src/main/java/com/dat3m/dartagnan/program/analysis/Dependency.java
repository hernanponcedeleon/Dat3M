package com.dat3m.dartagnan.program.analysis;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.MemEvent;
import com.dat3m.dartagnan.program.event.core.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.filter.FilterBasic;
import com.dat3m.dartagnan.program.filter.FilterUnion;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.Formula;
import org.sosy_lab.java_smt.api.SolverContext;

import java.util.*;

import static com.dat3m.dartagnan.expression.utils.Utils.generalEqual;
import static com.dat3m.dartagnan.expression.utils.Utils.generalZero;
import static com.dat3m.dartagnan.program.event.Tag.*;
import static com.google.common.base.Preconditions.checkArgument;
import static com.google.common.collect.Lists.reverse;
import static java.util.stream.Collectors.toList;
import static java.util.stream.IntStream.range;

/**
 * Computes direct providers for register values, based on when a register is used.
 */
public final class Dependency {

    private final HashMap<Event,Map<Register,List<Event>>> mayMap = new HashMap<>();
    private final HashMap<Event,Map<Register,List<Event>>> mustMap = new HashMap<>();
    private final ExecutionAnalysis executionAnalysis;

    /**
     * @param program
     * Instruction lists to be analyzed.
     * @param exec
     * Summarizes branching behavior.
     */
    public Dependency(Program program, ExecutionAnalysis exec) {
        executionAnalysis = exec;
        for(Thread t: program.getThreads()) {
            process(t);
        }
    }

    /**
     * Over-approximates the collection of providers for a variable, given a certain state of the program.
     * @param reader
     * Event containing some computation over values of the register space.
     * @return
     * Complete, but unsound, list of direct providers for some register used by {@code dependent}.
     */
    public List<Event> may(Event reader, Register register) {
        return mayMap.getOrDefault(reader, Map.of()).getOrDefault(register, List.of());
    }

    /**
     * Filters the list of dependencies for those that automatically imply the dependency relationship,
     * as soon as the dependency and the dependent are executed.
     * @param reader
     * Event containing some computation over values of the register space.
     * @return
     * Sound, but incomplete, list of direct providers with no overwriting event in between.
     */
    public List<Event> must(Event reader, Register register) {
        return mustMap.getOrDefault(reader, Map.of()).getOrDefault(register, List.of());
    }

    /**
     * @param writer
     * Overwrites some register.
     * @param reader
     * Happens on the same thread as {@code writer} and could use its value,
     * meaning that {@code writer} appears in {@code may(reader,R)} for some register {@code R}.
     * @param ctx
     * Builder of expressions and formulas.
     * @return
     * Proposition that {@code reader} directly uses the value from {@code writer}, if both are executed.
     * Contextualized with the result of {@link #encode(SolverContext) encode}.
     */
    public BooleanFormula getSMTVar(Event writer, Event reader, SolverContext ctx) {
        checkArgument(writer instanceof RegWriter);
        Register register = ((RegWriter) writer).getResultRegister();
        checkArgument(mayMap.getOrDefault(reader, Map.of()).getOrDefault(register, List.of()).contains(writer));
        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
        return mustMap.getOrDefault(reader, Map.of()).getOrDefault(register, List.of()).contains(writer)
        ? bmgr.and(writer.exec(), reader.cf())
        : bmgr.makeVariable("__dep " + writer.getCId() + " " + reader.getCId());
    }

    /**
     * @param ctx
     * Builder of expressions and formulas.
     * @return
     * Describes that for each pair of events, if the reader uses the result of the writer,
     * then the value the reader gets from the register is exactly the value that the writer computed.
     * Also, the reader may only use the value of the latest writer that is executed.
     * Also, if no fitting writer is executed, the reader uses 0.
     */
    public BooleanFormula encode(SolverContext ctx) {
        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
        BooleanFormula enc = bmgr.makeTrue();
        for(Map.Entry<Event,Map<Register,List<Event>>> e : mayMap.entrySet()) {
            Event reader = e.getKey();
            for(Map.Entry<Register,List<Event>> r : e.getValue().entrySet()) {
                Register register = r.getKey();
                Formula value = register.toIntFormula(reader, ctx);
                List<Event> list = r.getValue();
                BooleanFormula overwrite = bmgr.makeFalse();
                for(Event writer : reverse(list)) {
                    assert writer instanceof RegWriter;
                    BooleanFormula edge = getSMTVar(writer, reader, ctx);
                    enc = bmgr.and(enc,
                            bmgr.equivalence(edge, bmgr.and(writer.exec(), reader.cf(), bmgr.not(overwrite))),
                            bmgr.implication(edge, generalEqual(value, ((RegWriter) writer).getResultRegisterExpr(), ctx)));
                    overwrite = bmgr.or(overwrite, writer.exec());
                }
                if(list.isEmpty() || !executionAnalysis.isImplied(reader,list.get(0))) {
                    enc = bmgr.and(enc, bmgr.or(overwrite, bmgr.not(reader.cf()), generalZero(value, ctx)));
                }
            }
        }
        return enc;
    }

    private void process(Thread thread) {
        Map<Register,List<Event>> map = new HashMap<>();
        for(Event writer : thread.getCache().getEvents(FilterBasic.get(REG_WRITER))) {
            if(writer instanceof RegWriter) {
                map.computeIfAbsent(((RegWriter) writer).getResultRegister(), k->new ArrayList<>()).add(writer);
            }
        }
        for(Event reader : thread.getCache().getEvents(FilterUnion.get(FilterBasic.get(REG_READER), FilterBasic.get(MEMORY)))) {
            List<Register> registers = new ArrayList<>();
            if(reader instanceof RegReaderData) {
                registers.addAll(((RegReaderData) reader).getDataRegs());
            }
            if(reader instanceof MemEvent) {
                registers.addAll(((MemEvent) reader).getAddress().getRegs());
            }
            if(registers.isEmpty()) {
                continue;
            }
            HashMap<Register,List<Event>> may = new HashMap<>();
            HashMap<Register,List<Event>> must = new HashMap<>();
            for(Register register : registers) {
                List<Event> mays = may(reader, map.getOrDefault(register, List.of()), executionAnalysis);
                may.put(register, mays);
                must.put(register, must(mays, executionAnalysis));
            }
            mayMap.put(reader, may);
            mustMap.put(reader, must);
        }
    }

    private static List<Event> may(Event reader, List<Event> list, ExecutionAnalysis exec) {
        int end = range(0, list.size())
        .filter(i -> reader.getCId() <= list.get(i).getCId())
        .findFirst()
        .orElse(list.size());
        int begin = range(0, end)
        .map(i -> end - i - 1)
        .filter(i -> exec.isImplied(reader, list.get(i)))
        .findFirst()
        .orElse(0);
        return range(begin,end)
        .filter(i -> list.subList(i + 1, end).stream().noneMatch(j -> exec.isImplied(list.get(i), j)))
        .mapToObj(list::get)
        .filter(i -> !exec.areMutuallyExclusive(i, reader))
        .collect(toList());
    }

    private static List<Event> must(List<Event> mays, ExecutionAnalysis exec) {
        int end = mays.size();
        return range(0, end)
        .filter(i -> mays.subList(i + 1, end).stream().allMatch(j -> exec.areMutuallyExclusive(mays.get(i), j)))
        .mapToObj(mays::get)
        .collect(toList());
    }
}
