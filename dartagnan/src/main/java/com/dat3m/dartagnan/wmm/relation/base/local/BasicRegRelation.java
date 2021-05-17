package com.dat3m.dartagnan.wmm.relation.base.local;

import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.utils.equivalence.BranchEquivalence;
import com.dat3m.dartagnan.wmm.relation.base.stat.StaticRelation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;
import com.microsoft.z3.BoolExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.utils.RegWriter;
import com.microsoft.z3.Context;

import java.math.BigInteger;
import java.util.*;
import java.util.stream.Collectors;

abstract class BasicRegRelation extends StaticRelation {

    abstract Collection<Register> getRegisters(Event regReader);

    @Override
    public TupleSet getMinTupleSet(){
        if(minTupleSet == null){
            minTupleSet = new TupleSet();
            //TODO
        }
        return minTupleSet;
    }

    void mkTupleSets(Collection<Event> regReaders) {
        maxTupleSet = new TupleSet();
        minTupleSet = new TupleSet();
        BranchEquivalence eq = task.getBranchEquivalence();
        ImmutableMap<Register, ImmutableList<Event>> regWriterMap = task.getProgram().getCache().getRegWriterMap();
        for(Event regReader : regReaders){
            for(Register register : getRegisters(regReader)){
                List<Event> writers = regWriterMap.getOrDefault(register, ImmutableList.of());
                // =============== Reduce set of writes ==================
                //TODO: We assume that any Register-Write is always executed
                // if it is contained in the program flow
                // This may fail for RMWReadCond?! It seems to work fine for the litmus tests though.

                // =========================
                List<Event> possibleWriters = writers.stream().filter(x -> x.getCId() < regReader.getCId() && !eq.areMutuallyExclusive(x, regReader)).collect(Collectors.toList());

                List<Event> impliedWriters = possibleWriters.stream().filter(x -> eq.isImplied(regReader, x) && x.cfImpliesExec()).collect(Collectors.toList());
                if (!impliedWriters.isEmpty()) {
                    Event lastImplied = impliedWriters.get(impliedWriters.size() - 1);
                    possibleWriters.removeIf(x -> x.getCId() < lastImplied.getCId());
                }
                possibleWriters.removeIf(x -> possibleWriters.stream().anyMatch(y -> (x.getCId() < y.getCId()) && eq.isImplied(x ,y)));

                if (possibleWriters.size() == 1) {
                    minTupleSet.add(new Tuple(possibleWriters.stream().findAny().get(), regReader));
                }
                for(Event regWriter : possibleWriters){
                    maxTupleSet.add(new Tuple(regWriter, regReader));
                }
            }
        }
    }

    BoolExpr doEncodeApprox(Collection<Event> regReaders, Context ctx) {
        BoolExpr enc = ctx.mkTrue();
        ImmutableMap<Register, ImmutableList<Event>> regWriterMap = task.getProgram().getCache().getRegWriterMap();

        for (Event regReader : regReaders) {
            Set<Tuple> writerReaders = maxTupleSet.getBySecond(regReader);
            for (Register register : getRegisters(regReader)) {
                List<Event> writers = regWriterMap.getOrDefault(register, ImmutableList.of());
                List<Event> possibleWriters = writers.stream().filter(x -> writerReaders.contains(new Tuple(x, regReader))).collect(Collectors.toList());

                if(writers.isEmpty() || writers.get(0).getCId() >= regReader.getCId()){
                    enc = ctx.mkAnd(enc, ctx.mkEq(register.toZ3Int(regReader, ctx), new IConst(BigInteger.ZERO, register.getPrecision()).toZ3Int(ctx)));
                } else {

                    for (int i = 0; i < possibleWriters.size(); i++) {
                        Event regWriter = possibleWriters.get(i);
                        // RegReader uses the value of RegWriter if it is executed ..
                        BoolExpr clause = getExecPair(regWriter, regReader, ctx);
                        BoolExpr edge = this.getSMTVar(regWriter, regReader, ctx);
                        // .. and no other write to the same register is executed in between
                        for (int j = i + 1; j < possibleWriters.size(); j++) {
                            clause = ctx.mkAnd(clause, ctx.mkNot(possibleWriters.get(j).exec()));
                        }

                        // Encode edge and value binding
                        enc = ctx.mkAnd(enc, ctx.mkEq(edge, clause));
                        enc = ctx.mkAnd(enc, ctx.mkImplies(edge, ctx.mkEq(
                                ((RegWriter) regWriter).getResultRegisterExpr(),
                                register.toZ3Int(regReader, ctx)
                        )));
                    }
                }
            }
        }
        return enc;
    }
}