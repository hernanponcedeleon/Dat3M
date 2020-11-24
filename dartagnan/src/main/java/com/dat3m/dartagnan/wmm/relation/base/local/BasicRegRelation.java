package com.dat3m.dartagnan.wmm.relation.base.local;

import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.wmm.relation.base.stat.StaticRelation;
import com.dat3m.dartagnan.wmm.utils.Utils;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;
import com.microsoft.z3.BoolExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.utils.RegWriter;

import java.util.*;

abstract class BasicRegRelation extends StaticRelation {

    abstract Collection<Register> getRegisters(Event regReader);

    void mkMaxTupleSet(Collection<Event> regReaders){
        maxTupleSet = new TupleSet();
        ImmutableMap<Register, ImmutableList<Event>> regWriterMap = program.getCache().getRegWriterMap();
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
    }

    BoolExpr doEncodeApprox(Collection<Event> regReaders) {
        BoolExpr enc = ctx.mkTrue();
        ImmutableMap<Register, ImmutableList<Event>> regWriterMap = program.getCache().getRegWriterMap();

        for (Event regReader : regReaders) {
            for (Register register : getRegisters(regReader)) {
                List<Event> writers = regWriterMap.getOrDefault(register, ImmutableList.of());
                if(writers.isEmpty() || writers.get(0).getCId() >= regReader.getCId()){
                    enc = ctx.mkAnd(enc, ctx.mkEq(register.toZ3Int(regReader, ctx), new IConst(0, register.getPrecision()).toZ3Int(ctx)));

                } else {
                    ListIterator<Event> writerIt = writers.listIterator();
                    while (writerIt.hasNext()) {
                        Event regWriter = writerIt.next();
                        if (regWriter.getCId() >= regReader.getCId()) {
                            break;
                        }

                        // RegReader uses the value of RegWriter if it is executed ..
                        BoolExpr clause = ctx.mkAnd(regWriter.exec(), regReader.exec());
                        BoolExpr edge = Utils.edge(this.getName(), regWriter, regReader, ctx);

                        // .. and no other write to the same register is executed in between
                        ListIterator<Event> otherIt = writers.listIterator(writerIt.nextIndex());
                        while (otherIt.hasNext()) {
                            Event other = otherIt.next();
                            if (other.getCId() >= regReader.getCId()) {
                                break;
                            }
                            clause = ctx.mkAnd(clause, ctx.mkNot(other.exec()));
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
