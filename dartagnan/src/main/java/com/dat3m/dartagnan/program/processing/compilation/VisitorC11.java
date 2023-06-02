package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.Tag.C11;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.core.rmw.RMWStore;
import com.dat3m.dartagnan.program.event.lang.catomic.*;
import com.dat3m.dartagnan.program.event.lang.llvm.*;
import com.dat3m.dartagnan.program.event.lang.pthread.Create;
import com.dat3m.dartagnan.program.event.lang.pthread.End;
import com.dat3m.dartagnan.program.event.lang.pthread.Join;
import com.dat3m.dartagnan.program.event.lang.pthread.Start;

import java.util.List;

import static com.dat3m.dartagnan.expression.op.COpBin.EQ;
import static com.dat3m.dartagnan.expression.op.COpBin.NEQ;
import static com.dat3m.dartagnan.program.event.EventFactory.*;

public class VisitorC11 extends VisitorBase {

        protected VisitorC11(boolean forceStart) {
                super(forceStart);
        }

        @Override
        public List<AbstractEvent> visitCreate(Create e) {
                Store store = newStore(e.getAddress(), e.getMemValue(), Tag.C11.MO_RELEASE);
                store.addTags(C11.PTHREAD);

                return tagList(eventSequence(
                                store));
        }

        @Override
        public List<AbstractEvent> visitEnd(End e) {
                return tagList(eventSequence(
                        newStore(e.getAddress(), IValue.ZERO, Tag.C11.MO_RELEASE)));
        }

        @Override
        public List<AbstractEvent> visitJoin(Join e) {
                Register resultRegister = e.getResultRegister();
                Load load = newLoad(resultRegister, e.getAddress(), Tag.C11.MO_ACQUIRE);
                load.addTags(C11.PTHREAD);

                return tagList(eventSequence(
                                load,
                                newJumpUnless(new Atom(resultRegister, EQ, IValue.ZERO), (Label) e.getThread().getExit())));
        }

        @Override
        public List<AbstractEvent> visitStart(Start e) {
                Register resultRegister = e.getResultRegister();
                Load load = newLoad(resultRegister, e.getAddress(), Tag.C11.MO_ACQUIRE);
                load.addTags(Tag.STARTLOAD);

                return tagList(eventSequence(
                                load,
                                super.visitStart(e),
                                newJumpUnless(new Atom(resultRegister, EQ, IValue.ONE), (Label) e.getThread().getExit())));
        }

        @Override
        public List<AbstractEvent> visitLoad(Load e) {
                return tagList(eventSequence(
                        newLoad(e.getResultRegister(), e.getAddress(), e.getMo())));
        }

        @Override
        public List<AbstractEvent> visitStore(Store e) {
                return tagList(eventSequence(
                        newStore(e.getAddress(), e.getMemValue(), e.getMo())));
        }

        // =============================================================================================
        // =========================================== C11 =============================================
        // =============================================================================================

        @Override
	public List<AbstractEvent> visitAtomicCmpXchg(AtomicCmpXchg e) {
		Register resultRegister = e.getResultRegister();
		IExpr address = e.getAddress();
		String mo = e.getMo();
		IExpr expectedAddr = e.getExpectedAddr();
		int precision = resultRegister.getPrecision();

		Register regExpected = e.getThread().newRegister(precision);
        Register regValue = e.getThread().newRegister(precision);
        Load loadExpected = newLoad(regExpected, expectedAddr, "");
        Store storeExpected = newStore(expectedAddr, regValue, "");
        Label casFail = newLabel("CAS_fail");
        Label casEnd = newLabel("CAS_end");
        Local casCmpResult = newLocal(resultRegister, new Atom(regValue, EQ, regExpected));
        CondJump branchOnCasCmpResult = newJump(new Atom(resultRegister, NEQ, IValue.ONE), casFail);
        CondJump gotoCasEnd = newGoto(casEnd);
        Load loadValue = newRMWLoad(regValue, address, mo);
        Store storeValue = newRMWStore(loadValue, address, e.getMemValue(), mo);

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
                casEnd
        ));
	}

	@Override
	public List<AbstractEvent> visitAtomicFetchOp(AtomicFetchOp e) {
		Register resultRegister = e.getResultRegister();
		IOpBin op = e.getOp();
		IExpr address = e.getAddress();
		String mo = e.getMo();
		
        Register dummyReg = e.getThread().newRegister(resultRegister.getPrecision());
        Load load = newRMWLoad(resultRegister, address, mo);
        RMWStore store = newRMWStore(load, address, dummyReg, mo);
        
		return tagList(eventSequence(
                load,
                newLocal(dummyReg, new IExprBin(resultRegister, op, (IExpr) e.getMemValue())),
                store
        ));
	}

	@Override
	public List<AbstractEvent> visitAtomicLoad(AtomicLoad e) {
		return tagList(eventSequence(
        		newLoad(e.getResultRegister(), e.getAddress(), e.getMo())
        ));
	}

	@Override
	public List<AbstractEvent> visitAtomicStore(AtomicStore e) {
		return tagList(eventSequence(
        		newStore(e.getAddress(), e.getMemValue(), e.getMo())
        ));
	}

	@Override
	public List<AbstractEvent> visitAtomicThreadFence(AtomicThreadFence e) {
                return tagList(eventSequence(
                        newFence(e.getMo())));
	}

	@Override
	public List<AbstractEvent> visitAtomicXchg(AtomicXchg e) {
		IExpr address = e.getAddress();
		String mo = e.getMo();

        Load load = newRMWLoad(e.getResultRegister(), address, mo);
        RMWStore store = newRMWStore(load, address, e.getMemValue(), mo);
        
		return tagList(eventSequence(
                load,
                store
        ));
	}

    // =============================================================================================
    // =========================================== LLVM ============================================
    // =============================================================================================

    @Override
    public List<AbstractEvent> visitLlvmLoad(LlvmLoad e) {
            return tagList(eventSequence(
                newLoad(e.getResultRegister(), e.getAddress(), e.getMo())));
    }

    @Override
    public List<AbstractEvent> visitLlvmStore(LlvmStore e) {
           return tagList(eventSequence(
                newStore(e.getAddress(), e.getMemValue(), e.getMo())));
    }

    @Override
    public List<AbstractEvent> visitLlvmXchg(LlvmXchg e) {
            Register resultRegister = e.getResultRegister();
            ExprInterface value = e.getMemValue();
            IExpr address = e.getAddress();
            String mo = e.getMo();

            Load load = newRMWLoadExclusive(resultRegister, address, mo);
            Store store = newRMWStoreExclusive(address, value, mo, true);

            return tagList(eventSequence(
                            load,
                            store));
    }

    @Override
    public List<AbstractEvent> visitLlvmRMW(LlvmRMW e) {
            Register resultRegister = e.getResultRegister();
            IOpBin op = e.getOp();
            IExpr value = (IExpr) e.getMemValue();
            IExpr address = e.getAddress();
            String mo = e.getMo();

            Register dummyReg = e.getThread().newRegister(resultRegister.getPrecision());
            Local localOp = newLocal(dummyReg, new IExprBin(resultRegister, op, value));

            Load load = newRMWLoadExclusive(resultRegister, address, mo);
            Store store = newRMWStoreExclusive(address, dummyReg, mo, true);

            return tagList(eventSequence(
                            load,
                            localOp,
                            store));
    }

    @Override
    public List<AbstractEvent> visitLlvmCmpXchg(LlvmCmpXchg e) {
            Register oldValueRegister = e.getStructRegister(0);
            Register resultRegister = e.getStructRegister(1);

            ExprInterface value = e.getMemValue();
            IExpr address = e.getAddress();
            String mo = e.getMo();
            ExprInterface expectedValue = e.getExpectedValue();

            Local casCmpResult = newLocal(resultRegister, new Atom(oldValueRegister, EQ, expectedValue));
            Label casEnd = newLabel("CAS_end");
            CondJump branchOnCasCmpResult = newJump(new Atom(resultRegister, NEQ, IValue.ONE), casEnd);

            Load load = newRMWLoadExclusive(oldValueRegister, address, mo);
            Store store = newRMWStoreExclusive(address, value, mo, true);

            return tagList(eventSequence(
                            // Indentation shows the branching structure
                            load,
                            casCmpResult,
                            branchOnCasCmpResult,
                                store,
                            casEnd));
    }

    @Override
    public List<AbstractEvent> visitLlvmFence(LlvmFence e) {
            return tagList(eventSequence(
                            newFence(e.getMo())));
    }

    private List<AbstractEvent> tagList(List<AbstractEvent> in) {
        in.forEach(this::tagEvent);
        return in;
    }

    private void tagEvent(AbstractEvent e) {
        if(e instanceof MemEvent) {
                e.addTags(((MemEvent)e).canRace() ? C11.NONATOMIC : C11.ATOMIC);
        }
    }

}
