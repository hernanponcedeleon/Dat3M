package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.utils.RegReader;
import com.dat3m.dartagnan.program.memory.Location;
import com.dat3m.dartagnan.program.memory.Memory;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.google.common.collect.Sets;

import java.util.HashSet;

public class RemoveUnusedMemory implements ProgramProcessor {

    private RemoveUnusedMemory() {}

    public static RemoveUnusedMemory newInstance() {
        return new RemoveUnusedMemory();
    }

    @Override
    public void run(Program program) {
        final Memory memory = program.getMemory();
        final MemoryObjectCollector collector = new MemoryObjectCollector();
        program.getThreadEvents(RegReader.class).forEach(r -> r.transformExpressions(collector));
        Sets.difference(memory.getObjects(), collector.memoryObjects).forEach(memory::deleteMemoryObject);
    }

    private static class MemoryObjectCollector implements ExpressionVisitor<Expression> {

        private final HashSet<MemoryObject> memoryObjects = new HashSet<>();

        @Override
        public Expression visit(Atom atom) {
            atom.getLHS().accept(this);
            atom.getRHS().accept(this);
            return atom;
        }

        @Override
        public Expression visit(BConst bConst) {
            return bConst;
        }

        @Override
        public Expression visit(BExprBin bBin) {
            bBin.getLHS().accept(this);
            bBin.getRHS().accept(this);
            return bBin;
        }

        @Override
        public Expression visit(BExprUn bUn) {
            bUn.getInner().accept(this);
            return bUn;
        }

        @Override
        public Expression visit(BNonDet bNonDet) {
            return bNonDet;
        }

        @Override
        public Expression visit(IValue iValue) {
            return iValue;
        }

        @Override
        public Expression visit(IExprBin iBin) {
            iBin.getLHS().accept(this);
            iBin.getRHS().accept(this);
            return iBin;
        }

        @Override
        public Expression visit(IExprUn iUn) {
            iUn.getInner().accept(this);
            return iUn;
        }

        @Override
        public Expression visit(IfExpr ifExpr) {
            ifExpr.getGuard().accept(this);
            ifExpr.getFalseBranch().accept(this);
            ifExpr.getTrueBranch().accept(this);
            return ifExpr;
        }

        @Override
        public Expression visit(INonDet iNonDet) {
            return iNonDet;
        }

        @Override
        public Expression visit(Register reg) {
            return reg;
        }

        @Override
        public Expression visit(MemoryObject address) {
            memoryObjects.add(address);
            return address;
        }

        @Override
        public Expression visit(Location location) {
            return location;
        }

        @Override
        public Expression visit(Function function) {
            return function;
        }

        @Override
        public Expression visit(Construction construction) {
            construction.getArguments().forEach(c -> c.accept(this));
            return construction;
        }

        @Override
        public Expression visit(Extraction extraction) {
            extraction.getObject().accept(this);
            return extraction;
        }

        @Override
        public Expression visit(GEPExpression getElementPointer) {
            getElementPointer.getBaseExpression().accept(this);
            return getElementPointer;
        }
    }
}
