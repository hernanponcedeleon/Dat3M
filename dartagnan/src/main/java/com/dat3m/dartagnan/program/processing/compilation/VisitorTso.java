package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.Tag.C11;
import com.dat3m.dartagnan.program.event.arch.tso.Xchg;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.lang.catomic.*;
import com.dat3m.dartagnan.program.event.lang.llvm.*;
import com.dat3m.dartagnan.program.event.lang.pthread.*;

import java.util.List;

import static com.dat3m.dartagnan.program.event.EventFactory.*;

class VisitorTso extends VisitorBase {

        protected VisitorTso(boolean forceStart) {
                super(forceStart);
        }

        @Override
        public List<Event> visitXchg(Xchg e) {
                Register resultRegister = e.getResultRegister();
                ExprInterface address = e.getAddress();

                Register dummyReg = e.getThread().newRegister(resultRegister.getType());
                Load load = newRMWLoad(dummyReg, address, "");

                return tagList(eventSequence(
                                load,
                                newRMWStore(load, address, resultRegister, ""),
                                newLocal(resultRegister, dummyReg)));
        }

    // =============================================================================================
    // ========================================= PTHREAD ===========================================
    // =============================================================================================

    @Override
        public List<Event> visitCreate(Create e) {
                Store store = newStore(e.getAddress(), e.getMemValue(), "");
                store.addTags(C11.PTHREAD);

                return tagList(eventSequence(
                                store,
                                X86.newMemoryFence()));
        }

        @Override
        public List<Event> visitEnd(End e) {
                return tagList(eventSequence(
                                // Nothing comes after an End event thus no need for a fence
                                newStore(e.getAddress(), expressions.makeZero(types.getArchType()), "")));
        }

        @Override
        public List<Event> visitJoin(Join e) {
                Register resultRegister = e.getResultRegister();
                ExprInterface zero = expressions.makeZero(resultRegister.getType());
                Load load = newLoad(resultRegister, e.getAddress(), "");
                load.addTags(C11.PTHREAD);

                return tagList(eventSequence(
                                load,
                                newJump(expressions.makeNotEqual(resultRegister, zero),
                                                (Label) e.getThread().getExit())));
        }

        @Override
        public List<Event> visitStart(Start e) {
                Register resultRegister = e.getResultRegister();
                ExprInterface one = expressions.makeOne(resultRegister.getType());
                Load load = newLoad(resultRegister, e.getAddress(), "");
                load.addTags(Tag.STARTLOAD);

                return tagList(eventSequence(
                                load,
                                super.visitStart(e),
                                newJump(expressions.makeNotEqual(resultRegister, one),
                                                (Label) e.getThread().getExit())));
        }

        public List<Event> visitInitLock(InitLock e) {
            return eventSequence(
                    newStore(e.getAddress(), e.getMemValue(), ""),
                    X86.newMemoryFence());
        }

        @Override
        public List<Event> visitLock(Lock e) {
            IntegerType type = types.getArchType();
            Register dummy = e.getThread().newRegister(type);
            // We implement locks as spinlocks which are guaranteed to succeed, i.e. we can
            // use assumes. Nothing else is needed to guarantee acquire semantics in TSO.
            Load load = newRMWLoad(dummy, e.getAddress(), "");
            return eventSequence(
                    load,
                    newAssume(expressions.makeEqual(dummy, expressions.makeZero(type))),
                    newRMWStore(load, e.getAddress(), expressions.makeOne(type), ""));
        }

        @Override
        public List<Event> visitUnlock(Unlock e) {
            return eventSequence(
                    newStore(e.getAddress(), expressions.makeZero(types.getArchType()), ""),
                    X86.newMemoryFence());
        }
        
        // =============================================================================================
        // =========================================== LLVM ============================================
        // =============================================================================================

        @Override
        public List<Event> visitLlvmLoad(LlvmLoad e) {
                return eventSequence(
                                newLoad(e.getResultRegister(), e.getAddress(), ""));
        }

        @Override
        public List<Event> visitLlvmStore(LlvmStore e) {
                Fence optionalMFence = e.getMo().equals(Tag.C11.MO_SC) ? X86.newMemoryFence() : null;

                return eventSequence(
                                newStore(e.getAddress(), e.getMemValue(), ""),
                                optionalMFence);
        }

        @Override
        public List<Event> visitLlvmXchg(LlvmXchg e) {
                ExprInterface address = e.getAddress();
                Load load = newRMWLoad(e.getResultRegister(), address, "");

                return tagList(eventSequence(
                                load,
                                newRMWStore(load, address, e.getMemValue(), "")));
        }

        @Override
        public List<Event> visitLlvmRMW(LlvmRMW e) {
                Register resultRegister = e.getResultRegister();
                Register dummyReg = e.getThread().newRegister(resultRegister.getType());

                ExprInterface address = e.getAddress();
                Load load = newRMWLoad(resultRegister, address, "");

                return tagList(eventSequence(
                                load,
                                newLocal(dummyReg, expressions.makeBinary(resultRegister, e.getOp(), e.getMemValue())),
                                newRMWStore(load, address, dummyReg, "")));
        }

        @Override
        public List<Event> visitLlvmCmpXchg(LlvmCmpXchg e) {
                Register oldValueRegister = e.getStructRegister(0);
                Register resultRegister = e.getStructRegister(1);
                ExprInterface one = expressions.makeOne(resultRegister.getType());

                ExprInterface value = e.getMemValue();
                ExprInterface address = e.getAddress();
                ExprInterface expectedValue = e.getExpectedValue();

                Local casCmpResult = newLocal(resultRegister, expressions.makeEqual(oldValueRegister, expectedValue));
                Label casEnd = newLabel("CAS_end");
                CondJump branchOnCasCmpResult = newJump(expressions.makeNotEqual(resultRegister, one), casEnd);

                Load load = newRMWLoad(oldValueRegister, address, "");
                Store store = newRMWStore(load, address, value, "");

                return tagList(eventSequence(
                                // Indentation shows the branching structure
                                load,
                                casCmpResult,
                                branchOnCasCmpResult,
                                        store,
                                casEnd));
        }

        @Override
        public List<Event> visitLlvmFence(LlvmFence e) {
                Fence optionalFence = e.getMo().equals(Tag.C11.MO_SC) ? X86.newMemoryFence() : null;

                return eventSequence(
                                optionalFence);
        }

        // =============================================================================================
        // ============================================ C11 ============================================
        // =============================================================================================

        @Override
        public List<Event> visitAtomicCmpXchg(AtomicCmpXchg e) {
                Register resultRegister = e.getResultRegister();
                ExprInterface address = e.getAddress();
                ExprInterface value = e.getMemValue();
                String mo = e.getMo();
                ExprInterface expectedAddr = e.getExpectedAddr();
                IntegerType type = resultRegister.getType();
                ExprInterface one = expressions.makeOne(type);

                Register regExpected = e.getThread().newRegister(type);
                Load loadExpected = newLoad(regExpected, expectedAddr, "");
                Register regValue = e.getThread().newRegister(type);
                Load loadValue = newRMWLoad(regValue, address, mo);
                Local casCmpResult = newLocal(resultRegister, expressions.makeEqual(regValue, regExpected));
                Label casFail = newLabel("CAS_fail");
                CondJump branchOnCasCmpResult = newJump(expressions.makeNotEqual(resultRegister, one), casFail);
                Store storeValue = newRMWStore(loadValue, address, value, mo);
                Label casEnd = newLabel("CAS_end");
                CondJump gotoCasEnd = newGoto(casEnd);
                Store storeExpected = newStore(expectedAddr, regValue, "");

                return tagList(eventSequence(
                        // Indentation shows the branching structure
                        loadExpected,
                        loadValue,
                        casCmpResult,
                        branchOnCasCmpResult,
                                storeValue,
                                gotoCasEnd,
                        casFail,
                                storeExpected,
                        casEnd));
        }

        @Override
        public List<Event> visitAtomicFetchOp(AtomicFetchOp e) {
                Register resultRegister = e.getResultRegister();
                Register dummyReg = e.getThread().newRegister(resultRegister.getType());

                ExprInterface address = e.getAddress();
                String mo = e.getMo();
                Load load = newRMWLoad(resultRegister, address, mo);

                return tagList(eventSequence(
                                load,
                                newLocal(dummyReg, expressions.makeBinary(resultRegister, e.getOp(), e.getMemValue())),
                                newRMWStore(load, address, dummyReg, mo)));
        }

        @Override
        public List<Event> visitAtomicLoad(AtomicLoad e) {
                return eventSequence(
                                newLoad(e.getResultRegister(), e.getAddress(), e.getMo()));
        }

        @Override
        public List<Event> visitAtomicStore(AtomicStore e) {
                String mo = e.getMo();
                Fence optionalMFence = mo.equals(Tag.C11.MO_SC) ? X86.newMemoryFence() : null;

                return eventSequence(
                        newStore(e.getAddress(), e.getMemValue(), mo),
                        optionalMFence);
        }

        @Override
        public List<Event> visitAtomicThreadFence(AtomicThreadFence e) {
                Fence optionalFence = e.getMo().equals(Tag.C11.MO_SC) ? X86.newMemoryFence() : null;

                return eventSequence(optionalFence);
        }

        @Override
        public List<Event> visitAtomicXchg(AtomicXchg e) {
            ExprInterface address = e.getAddress();
            String mo = e.getMo();
            Load load = newRMWLoad(e.getResultRegister(), address, mo);

            return tagList(eventSequence(
                    load,
                    newRMWStore(load, address, e.getMemValue(), mo)));
        }

        private List<Event> tagList(List<Event> in) {
            in.forEach(this::tagEvent);
            return in;
        }

        private void tagEvent(Event e) {
            if (e instanceof MemoryEvent) {
                e.addTags(Tag.TSO.ATOM);
            }
        }

}