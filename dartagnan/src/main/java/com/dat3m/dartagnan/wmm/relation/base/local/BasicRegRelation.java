package com.dat3m.dartagnan.wmm.relation.base.local;

import com.dat3m.dartagnan.expression.IValue;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.wmm.relation.base.stat.StaticRelation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.FormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;

import java.math.BigInteger;
import java.util.Collection;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.expression.utils.Utils.generalEqual;

abstract class BasicRegRelation extends StaticRelation {

    abstract Collection<Register> getRegisters(Event regReader);

    void mkTupleSets(Collection<Event> regReaders) {
        maxTupleSet = new TupleSet();
        minTupleSet = new TupleSet();
        ExecutionAnalysis exec = analysisContext.requires(ExecutionAnalysis.class);
        ImmutableMap<Register, ImmutableList<Event>> regWriterMap = task.getProgram().getCache().getRegWriterMap();
        for(Event regReader : regReaders){
            for(Register register : getRegisters(regReader)){
                List<Event> writers = regWriterMap.getOrDefault(register, ImmutableList.of());
                // =============== Reduce set of writes ==================
                //TODO: We assume that any Register-Write is always executed
                // if it is contained in the program flow
                // This may fail for RMWReadCond?! It seems to work fine for the litmus tests though.

                // =========================
                List<Event> possibleWriters = writers.stream()
                        .filter(x -> x.getCId() < regReader.getCId() && !exec.areMutuallyExclusive(x, regReader))
                        .collect(Collectors.toList());

                List<Event> impliedWriters = possibleWriters
                        .stream().filter(x -> exec.isImplied(regReader, x))
                        .collect(Collectors.toList());
                if (!impliedWriters.isEmpty()) {
                    Event lastImplied = impliedWriters.get(impliedWriters.size() - 1);
                    possibleWriters.removeIf(x -> x.getCId() < lastImplied.getCId());
                }
                possibleWriters.removeIf(x -> possibleWriters.stream()
                        .anyMatch(y -> x.getCId() < y.getCId() && exec.isImplied(x ,y)));

                // --- Min sets ---
                if (possibleWriters.size() == 1) {
                    // there is only a single regWriter
                    minTupleSet.add(new Tuple(possibleWriters.stream().findAny().get(), regReader));
                } else {
                    // there are multiple regWriters, but some are exclusive to all others
                    for (Event writer : possibleWriters) {
                        if (possibleWriters.stream().allMatch(x -> x == writer || exec.areMutuallyExclusive(x, writer))) {
                            minTupleSet.add(new Tuple(writer, regReader));
                        }
                    }
                }
                // --- Max sets ---
                for(Event regWriter : possibleWriters){
                    maxTupleSet.add(new Tuple(regWriter, regReader));
                }
            }
        }
    }

    BooleanFormula doEncodeApprox(Collection<Event> regReaders, SolverContext ctx) {
    	FormulaManager fmgr = ctx.getFormulaManager();
		BooleanFormulaManager bmgr = fmgr.getBooleanFormulaManager();

    	BooleanFormula enc = bmgr.makeTrue();

        ImmutableMap<Register, ImmutableList<Event>> regWriterMap = task.getProgram().getCache().getRegWriterMap();

        for (Event regReader : regReaders) {
            Set<Tuple> writerReaders = maxTupleSet.getBySecond(regReader);
            for (Register register : getRegisters(regReader)) {
                List<Event> writers = regWriterMap.getOrDefault(register, ImmutableList.of());
                List<Event> possibleWriters = writers.stream()
                        .filter(x -> writerReaders.contains(new Tuple(x, regReader)))
                        .collect(Collectors.toList());

                if(writers.isEmpty() || writers.get(0).getCId() >= regReader.getCId()){
                	BooleanFormula equal = generalEqual(register.toIntFormula(regReader, ctx),
                										new IValue(BigInteger.ZERO, register.getPrecision()).toIntFormula(ctx), ctx);
                    enc = bmgr.and(enc, equal);
                } else {

                    for (int i = 0; i < possibleWriters.size(); i++) {
                        Event regWriter = possibleWriters.get(i);
                        // RegReader uses the value of RegWriter if it is executed ..
                        BooleanFormula clause = getExecPair(regWriter, regReader, ctx);
                        BooleanFormula edge = this.getSMTVar(regWriter, regReader, ctx);
                        // .. and no other write to the same register is executed in between
                        for (int j = i + 1; j < possibleWriters.size(); j++) {
                            clause = bmgr.and(clause, bmgr.not(possibleWriters.get(j).exec()));
                        }

                        // Encode edge and value binding
                        enc = bmgr.and(enc, bmgr.equivalence(edge, clause));
                        BooleanFormula equal = generalEqual(((RegWriter) regWriter).getResultRegisterExpr(),
                        									register.toIntFormula(regReader, ctx), ctx);
                        enc = bmgr.and(enc, bmgr.implication(edge, equal));
                    }
                }
            }
        }
        return enc;
    }
}