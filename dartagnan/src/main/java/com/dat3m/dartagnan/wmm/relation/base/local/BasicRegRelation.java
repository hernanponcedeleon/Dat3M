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

import java.util.*;
import java.util.stream.Collectors;

abstract class BasicRegRelation extends StaticRelation {

    abstract Collection<Register> getRegisters(Event regReader);

    @Override
    public TupleSet getMinTupleSet(){
        if(minTupleSet == null){
            minTupleSet = new TupleSet();
            //Todo
        }
        return minTupleSet;
    }

    void mkMaxTupleSet(Collection<Event> regReaders){
        maxTupleSet = new TupleSet();
        ImmutableMap<Register, ImmutableList<Event>> regWriterMap = task.getProgram().getCache().getRegWriterMap();
        for(Event regReader : regReaders){
            for(Register register : getRegisters(regReader)){
                for(Event regWriter : regWriterMap.getOrDefault(register, ImmutableList.of())){
                    if(regWriter.getCId() >= regReader.getCId()){
                        break;
                    }
                    maxTupleSet.add(new Tuple(regWriter, regReader));
                }
            }
        }
        removeMutuallyExclusiveTuples(maxTupleSet);
    }

    BoolExpr doEncodeApprox(Collection<Event> regReaders, Context ctx) {
        BoolExpr enc = ctx.mkTrue();
        ImmutableMap<Register, ImmutableList<Event>> regWriterMap = task.getProgram().getCache().getRegWriterMap();
        BranchEquivalence eq = task.getBranchEquivalence();

        for (Event regReader : regReaders) {
            for (Register register : getRegisters(regReader)) {
                List<Event> writers = regWriterMap.getOrDefault(register, ImmutableList.of());
                if(writers.isEmpty() || writers.get(0).getCId() >= regReader.getCId()){
                    enc = ctx.mkAnd(enc, ctx.mkEq(register.toZ3Int(regReader, ctx), new IConst(0, register.getPrecision()).toZ3Int(ctx)));
                } else {

                    // =============== Reduce set of writes ==================
                    //TODO: We assume that any Register-Write is always executed
                    // if it is contained in the program flow
                    // This may fail for RMWReadCond?! It seems to work fine for the litmus tests though.
                    List<Event> possibleWriters = writers.stream().filter(x -> x.getCId() < regReader.getCId() && !eq.areMutuallyExclusive(x, regReader)).collect(Collectors.toList());

                    List<Event> impliedWriters = possibleWriters.stream().filter(x -> eq.isImplied(regReader, x)).collect(Collectors.toList());
                    if (!impliedWriters.isEmpty()) {
                        Event lastImplied = impliedWriters.get(impliedWriters.size() - 1);
                        possibleWriters.removeIf(x -> x.getCId() < lastImplied.getCId());
                    }
                    possibleWriters.removeIf(x -> possibleWriters.stream().anyMatch(y -> (x.getCId() < y.getCId()) && eq.isImplied(x ,y)));

                    // =========================
                    for (int i = 0; i < possibleWriters.size(); i++) {
                        Event regWriter = possibleWriters.get(i);
                        // RegReader uses the value of RegWriter if it is executed ..
                        BoolExpr clause = ctx.mkAnd(regWriter.exec(), regReader.exec());
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
