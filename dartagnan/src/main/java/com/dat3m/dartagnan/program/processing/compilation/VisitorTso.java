package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.Tag.C11;
import com.dat3m.dartagnan.program.event.arch.tso.Xchg;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.core.rmw.RMWStore;
import com.dat3m.dartagnan.program.event.lang.catomic.*;
import com.dat3m.dartagnan.program.event.lang.llvm.*;
import com.dat3m.dartagnan.program.event.lang.pthread.*;

import java.util.List;

import static com.dat3m.dartagnan.expression.op.COpBin.EQ;
import static com.dat3m.dartagnan.expression.op.COpBin.NEQ;
import static com.dat3m.dartagnan.program.event.EventFactory.*;

class VisitorTso extends VisitorBase {


	protected VisitorTso(boolean forceStart) {
                super(forceStart);
        }

        @Override
        public List<Event> visitCreate(Create e) {
                Store store = newStore(e.getAddress(), e.getMemValue(), "");
                store.addFilters(C11.PTHREAD);

                return eventSequence(
                                store);
        }

        @Override
        public List<Event> visitEnd(End e) {
                return eventSequence(
                                newStore(e.getAddress(), IValue.ZERO, ""));
        }

        @Override
        public List<Event> visitJoin(Join e) {
                Register resultRegister = e.getResultRegister();
                Load load = newLoad(resultRegister, e.getAddress(), "");
                load.addFilters(C11.PTHREAD);

                return eventSequence(
                                load,
                                newJumpUnless(new Atom(resultRegister, EQ, IValue.ZERO), (Label) e.getThread().getExit()));
        }

        @Override
        public List<Event> visitStart(Start e) {
                Register resultRegister = e.getResultRegister();
                Load load = newLoad(resultRegister, e.getAddress(), "");
                load.addFilters(Tag.STARTLOAD);

                return eventSequence(
                                load,
                                super.visitStart(e),
                                newJumpUnless(new Atom(resultRegister, EQ, IValue.ONE), (Label) e.getThread().getExit()));
        }

	@Override
	public List<Event> visitXchg(Xchg e) {
        Register resultRegister = e.getResultRegister();
        IExpr address = e.getAddress();

        Register dummyReg = e.getThread().newRegister(resultRegister.getPrecision());
		Load load = newRMWLoad(dummyReg, address, "");
        load.addFilters(Tag.TSO.ATOM);

        RMWStore store = newRMWStore(load, address, resultRegister, "");
        store.addFilters(Tag.TSO.ATOM);

        return eventSequence(
                load,
                store,
                newLocal(resultRegister, dummyReg)
        );
	}

    // =============================================================================================
    // =========================================== LLVM ============================================
    // =============================================================================================

    @Override
    public List<Event> visitLlvmLoad(LlvmLoad e) {
            Load load = newLoad(e.getResultRegister(), e.getAddress(), "");

            return eventSequence(
                            load);
    }

    @Override
    public List<Event> visitLlvmStore(LlvmStore e) {
            Store store = newStore(e.getAddress(), e.getMemValue(), "");
            Fence optionalMFence = e.getMo().equals(Tag.C11.MO_SC) ? X86.newMemoryFence() : null;

            return eventSequence(
                            store,
                            optionalMFence);
    }

    @Override
    public List<Event> visitLlvmXchg(LlvmXchg e) {
            IExpr address = e.getAddress();
            Load load = newRMWLoad(e.getResultRegister(), address, "");

            return eventSequence(
                            load,
                            newRMWStore(load, address, e.getMemValue(), ""));
    }

    @Override
    public List<Event> visitLlvmRMW(LlvmRMW e) {
            Register resultRegister = e.getResultRegister();
            IExpr address = e.getAddress();

            Register dummyReg = e.getThread().newRegister(resultRegister.getPrecision());
            Load load = newRMWLoad(resultRegister, address, "");

            return eventSequence(
                            load,
                            newLocal(dummyReg, new IExprBin(resultRegister, e.getOp(), (IExpr) e.getMemValue())),
                            newRMWStore(load, address, dummyReg, ""));
    }

    @Override
    public List<Event> visitLlvmCmpXchg(LlvmCmpXchg e) {
            Register oldValueRegister = e.getStructRegister(0);
            Register resultRegister = e.getStructRegister(1);

            ExprInterface value = e.getMemValue();
            IExpr address = e.getAddress();
            ExprInterface expectedValue = e.getExpectedValue();

            Local casCmpResult = newLocal(resultRegister, new Atom(oldValueRegister, EQ, expectedValue));
            Label casEnd = newLabel("CAS_end");
            CondJump branchOnCasCmpResult = newJump(new Atom(resultRegister, NEQ, IValue.ONE), casEnd);

            Load load = newRMWLoad(oldValueRegister, address, "");
            Store store = newRMWStore(load, address, value, "");

            return eventSequence(
                            // Indentation shows the branching structure
                            load,
                            casCmpResult,
                            branchOnCasCmpResult,
                                store,
                            casEnd);
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
		IExpr address = e.getAddress();
		ExprInterface value = e.getMemValue();
		String mo = e.getMo();
		IExpr expectedAddr = e.getExpectedAddr();
		int precision = resultRegister.getPrecision();

		Register regExpected = e.getThread().newRegister(precision);
        Load loadExpected = newLoad(regExpected, expectedAddr, "");
        Register regValue = e.getThread().newRegister(precision);
        Load loadValue = newRMWLoad(regValue, address, mo);
        Local casCmpResult = newLocal(resultRegister, new Atom(regValue, EQ, regExpected));
        Label casFail = newLabel("CAS_fail");
        CondJump branchOnCasCmpResult = newJump(new Atom(resultRegister, NEQ, IValue.ONE), casFail);
        Store storeValue = newRMWStore(loadValue, address, value, mo);
        Label casEnd = newLabel("CAS_end");
        CondJump gotoCasEnd = newGoto(casEnd);
        Store storeExpected = newStore(expectedAddr, regValue, "");

        return eventSequence(
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
        );
	}

	@Override
	public List<Event> visitAtomicFetchOp(AtomicFetchOp e) {
		Register resultRegister = e.getResultRegister();
		IExpr address = e.getAddress();
		String mo = e.getMo();
		
        Register dummyReg = e.getThread().newRegister(resultRegister.getPrecision());
        Load load = newRMWLoad(resultRegister, address, mo);
        
        return eventSequence(
                load,
                newLocal(dummyReg, new IExprBin(resultRegister, e.getOp(), (IExpr)e.getMemValue())),
                newRMWStore(load, address, dummyReg, mo)
        );
	}

	@Override
	public List<Event> visitAtomicLoad(AtomicLoad e) {
        return eventSequence(
        		newLoad(e.getResultRegister(), e.getAddress(), e.getMo())
        );
	}

	@Override
	public List<Event> visitAtomicStore(AtomicStore e) {
		String mo = e.getMo();

        Fence optionalMFence = mo.equals(Tag.C11.MO_SC) ? X86.newMemoryFence() : null;

        return eventSequence(
        		newStore(e.getAddress(), e.getMemValue(), mo),
                optionalMFence
        );
	}

	@Override
	public List<Event> visitAtomicThreadFence(AtomicThreadFence e) {
        Fence optionalFence = e.getMo().equals(Tag.C11.MO_SC) ? X86.newMemoryFence() : null;
        
        return eventSequence(
        		optionalFence
        );
	}

	@Override
	public List<Event> visitAtomicXchg(AtomicXchg e) {
		IExpr address = e.getAddress();
		String mo = e.getMo();

        Load load = newRMWLoad(e.getResultRegister(), address, mo);

        return eventSequence(
                load,
                newRMWStore(load, address, e.getMemValue(), mo)
        );
	}
}