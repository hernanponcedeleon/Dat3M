package com.dat3m.dartagnan.wmm.relation.basic;

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

abstract class BasicRegRelation extends BasicRelation {

    abstract Collection<Register> getRegisters(Event regReader);

    void mkMaxTupleSet(Collection<Event> regReaders){
        maxTupleSet = new TupleSet();
        ImmutableMap<Register, ImmutableList<Event>> regWriterMap = program.getCache().getRegWriterMap();
        for(Event regReader : regReaders){
            for(Register register : getRegisters(regReader)){
                for(Event regWriter : regWriterMap.get(register)){
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
                List<Event> writers = regWriterMap.get(register);
                if (writers.isEmpty() || writers.get(0).getCId() >= regReader.getCId()) {
                    throw new RuntimeException("Missing initial write to register in " + regReader.getCId() + ":" + regReader);
                }

                ListIterator<Event> writerIt = writers.listIterator();
                while (writerIt.hasNext()) {
                    Event regWriter = writerIt.next();
                    if (regWriter.getCId() >= regReader.getCId()) {
                        break;
                    }

                    // RegReader uses the value of RegWriter if it is executed ..
                    BoolExpr clause = regWriter.executes(ctx);
                    BoolExpr lastRegVal = Utils.bindRegVal(register, regWriter, regReader, ctx);
                    BoolExpr edge = Utils.edge(this.getName(), regWriter, regReader, ctx);

                    // .. and no other write to the same register is executed in between
                    ListIterator<Event> otherIt = writers.listIterator(writerIt.nextIndex());
                    while (otherIt.hasNext()) {
                        Event other = otherIt.next();
                        if (other.getCId() >= regReader.getCId()) {
                            break;
                        }
                        clause = ctx.mkAnd(clause, ctx.mkNot(other.executes(ctx)));
                    }

                    // RegReader receives value from this RegWriter
                    enc = ctx.mkAnd(enc, ctx.mkEq(lastRegVal, clause));

                    // Encode value binding (might be needed even if reader is not executed, e.g. in the address of LKW)
                    enc = ctx.mkAnd(enc, ctx.mkImplies(lastRegVal, ctx.mkEq(
                            ((RegWriter) regWriter).getResultRegisterExpr(),
                            register.toZ3Int(regReader, ctx)
                    )));

                    // Encode edge (exists only if both events are executed)
                    enc = ctx.mkAnd(enc, ctx.mkEq(edge, ctx.mkAnd(lastRegVal, regReader.executes(ctx))));
                }
            }
        }
        return enc;
    }
}
