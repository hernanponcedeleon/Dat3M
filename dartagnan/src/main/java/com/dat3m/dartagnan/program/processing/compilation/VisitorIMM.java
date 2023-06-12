package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.Tag.C11;
import com.dat3m.dartagnan.program.event.Tag.IMM;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.lang.catomic.*;
import com.dat3m.dartagnan.program.event.lang.llvm.*;
import com.dat3m.dartagnan.program.event.lang.pthread.Create;
import com.dat3m.dartagnan.program.event.lang.pthread.End;
import com.dat3m.dartagnan.program.event.lang.pthread.Join;
import com.dat3m.dartagnan.program.event.lang.pthread.Start;
import com.dat3m.dartagnan.program.event.metadata.MemoryOrder;

import java.util.Collections;
import java.util.List;

import static com.dat3m.dartagnan.expression.op.COpBin.EQ;
import static com.dat3m.dartagnan.expression.op.COpBin.NEQ;
import static com.dat3m.dartagnan.program.event.EventFactory.*;
import static com.dat3m.dartagnan.program.event.Tag.IMM.extractLoadMo;
import static com.dat3m.dartagnan.program.event.Tag.IMM.extractStoreMo;

class VisitorIMM extends VisitorBase {

	protected VisitorIMM(boolean forceStart) {
		super(forceStart);
	}

	@Override
	public List<Event> visitLoad(Load e) {
		// FIXME: It is weird to compile a core-level load by transforming its tagging.
		final MemoryOrder mo = e.getMetadata(MemoryOrder.class);
		final boolean isNonAtomic = (mo == null || mo.value().equals(C11.NONATOMIC));
        return eventSequence(
        		newLoad(e.getResultRegister(), e.getAddress(), isNonAtomic ? C11.MO_RELAXED : mo.value())
        );
	}

	@Override
	public List<Event> visitStore(Store e) {
		// FIXME: It is weird to compile a core-level load by transforming its tagging.
		final MemoryOrder mo = e.getMetadata(MemoryOrder.class);
		final boolean isNonAtomic = (mo == null || mo.value().equals(C11.NONATOMIC));
        return eventSequence(
        		newStore(e.getAddress(), e.getMemValue(), isNonAtomic ? C11.MO_RELAXED : mo.value())
        );
	}
	
	@Override
	public List<Event> visitCreate(Create e) {
        Store store = newStore(e.getAddress(), e.getMemValue(), C11.MO_RELEASE);
        store.addTags(C11.PTHREAD);
        
        return eventSequence(
                store
        );
	}

	@Override
	public List<Event> visitEnd(End e) {
        return eventSequence(
        		newStore(e.getAddress(), IValue.ZERO, C11.MO_RELEASE)
        );
	}

	@Override
	public List<Event> visitJoin(Join e) {
        Register resultRegister = e.getResultRegister();
		Load load = newLoad(resultRegister, e.getAddress(), C11.MO_ACQUIRE);
        load.addTags(C11.PTHREAD);
        
        return eventSequence(
        		load,
        		newJumpUnless(new Atom(resultRegister, EQ, IValue.ZERO), (Label) e.getThread().getExit())
        );
	}

	@Override
	public List<Event> visitStart(Start e) {
        Register resultRegister = e.getResultRegister();
        Load load = newLoad(resultRegister, e.getAddress(), C11.MO_ACQUIRE);
        load.addTags(Tag.STARTLOAD);

        return eventSequence(
        		load,
				super.visitStart(e),
        		newJumpUnless(new Atom(resultRegister, EQ, IValue.ONE), (Label) e.getThread().getExit())
        );
	}

	// =============================================================================================
    // =========================================== C11 =============================================
    // =============================================================================================

	@Override
	public List<Event> visitAtomicCmpXchg(AtomicCmpXchg e) {
		Register resultRegister = e.getResultRegister();
		IExpr address = e.getAddress();
		String mo = e.getMo();
		Fence optionalFenceLoad = mo.equals(Tag.C11.MO_SC) ? newFence(Tag.C11.MO_SC) : null;
		Fence optionalFenceStore = mo.equals(Tag.C11.MO_SC) ? newFence(Tag.C11.MO_SC) : null;
		IExpr expectedAddr = e.getExpectedAddr();
		int precision = resultRegister.getPrecision();

		Register regExpected = e.getThread().newRegister(precision);
        Register regValue = e.getThread().newRegister(precision);
        Load loadExpected = newLoad(regExpected, expectedAddr, "");
        loadExpected.addTags(Tag.IMM.CASDEPORIGIN);
        Store storeExpected = newStore(expectedAddr, regValue, "");
        Label casFail = newLabel("CAS_fail");
        Label casEnd = newLabel("CAS_end");
        Local casCmpResult = newLocal(resultRegister, new Atom(regValue, EQ, regExpected));
        CondJump branchOnCasCmpResult = newJump(new Atom(resultRegister, NEQ, IValue.ONE), casFail);
        CondJump gotoCasEnd = newGoto(casEnd);
        Load loadValue = newRMWLoad(regValue, address, extractLoadMo(mo));
        Store storeValue = newRMWStore(loadValue, address, e.getMemValue(), extractStoreMo(mo));

        return eventSequence(
                // Indentation shows the branching structure
                loadExpected,
                optionalFenceLoad,
                loadValue,
                casCmpResult,
                branchOnCasCmpResult,
                	optionalFenceStore,
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
		IOpBin op = e.getOp();
		IExpr address = e.getAddress();
		String mo = e.getMo();
		Fence optionalFenceBefore = mo.equals(Tag.C11.MO_SC) ? newFence(Tag.C11.MO_SC) : null;
		Fence optionalFenceAfter = mo.equals(Tag.C11.MO_SC) ? newFence(Tag.C11.MO_SC) : null;
		
        Register dummyReg = e.getThread().newRegister(resultRegister.getPrecision());
        Load load = newRMWLoad(resultRegister, address, extractLoadMo(mo));

        return eventSequence(
        		optionalFenceBefore,
                load,
                newLocal(dummyReg, new IExprBin(resultRegister, op, (IExpr) e.getMemValue())),
        		optionalFenceAfter,
                newRMWStore(load, address, dummyReg, extractStoreMo(mo))
        );
	}

	@Override
	public List<Event> visitAtomicLoad(AtomicLoad e) {
		String mo = e.getMo();
		Fence optionalFence = mo.equals(Tag.C11.MO_SC) ? newFence(Tag.C11.MO_SC) : null;
        return eventSequence(
        		optionalFence,
        		newLoad(e.getResultRegister(), e.getAddress(), extractLoadMo(mo))
        );
	}

	@Override
	public List<Event> visitAtomicStore(AtomicStore e) {
		String mo = e.getMo();
		Fence optionalFence = mo.equals(Tag.C11.MO_SC) ? newFence(Tag.C11.MO_SC) : null;
        return eventSequence(
        		optionalFence,
        		newStore(e.getAddress(), e.getMemValue(), extractStoreMo(mo))
        );
	}

	@Override
	public List<Event> visitAtomicThreadFence(AtomicThreadFence e) {
		return Collections.singletonList(newFence(e.getMo()));
	}

	@Override
	public List<Event> visitAtomicXchg(AtomicXchg e) {
		IExpr address = e.getAddress();
		String mo = e.getMo();
		Fence optionalFenceLoad = mo.equals(Tag.C11.MO_SC) ? newFence(Tag.C11.MO_SC) : null;
		Fence optionalFenceStore = mo.equals(Tag.C11.MO_SC) ? newFence(Tag.C11.MO_SC) : null;
		
        Load load = newRMWLoad(e.getResultRegister(), address, mo);
        
        return eventSequence(
        		optionalFenceLoad,
                load,
                optionalFenceStore,
                newRMWStore(load, address, e.getMemValue(), extractStoreMo(mo))
        );
	}

    // =============================================================================================
    // =========================================== LLVM ============================================
    // =============================================================================================

	@Override
	public List<Event> visitLlvmLoad(LlvmLoad e) {
		return eventSequence(
				newLoad(e.getResultRegister(), e.getAddress(), IMM.extractLoadMo(e.getMo())));
	}

	@Override
	public List<Event> visitLlvmStore(LlvmStore e) {
		return eventSequence(
				newStore(e.getAddress(), e.getMemValue(), IMM.extractStoreMo(e.getMo())));
	}

	@Override
	public List<Event> visitLlvmXchg(LlvmXchg e) {
		Register resultRegister = e.getResultRegister();
		ExprInterface value = e.getMemValue();
		IExpr address = e.getAddress();
		String mo = e.getMo();

		Load load = newRMWLoadExclusive(resultRegister, address, IMM.extractLoadMo(mo));
		Store store = newRMWStoreExclusive(address, value, IMM.extractStoreMo(mo), true);
		Label label = newLabel("FakeDep");
		Event fakeCtrlDep = newFakeCtrlDep(resultRegister, label);

		return eventSequence(
				load,
				fakeCtrlDep,
				label,
				store);
	}

	@Override
	public List<Event> visitLlvmRMW(LlvmRMW e) {
		Register resultRegister = e.getResultRegister();
		IOpBin op = e.getOp();
		IExpr value = (IExpr) e.getMemValue();
		IExpr address = e.getAddress();
		String mo = e.getMo();

		Register dummyReg = e.getThread().newRegister(resultRegister.getPrecision());
		Local localOp = newLocal(dummyReg, new IExprBin(resultRegister, op, value));

		Load load = newRMWLoadExclusive(resultRegister, address, IMM.extractLoadMo(mo));
		Store store = newRMWStoreExclusive(address, dummyReg, IMM.extractStoreMo(mo), true);
		Label label = newLabel("FakeDep");
		Event fakeCtrlDep = newFakeCtrlDep(resultRegister, label);

		return eventSequence(
				load,
				fakeCtrlDep,
				label,
				localOp,
				store);
	}

	@Override
	public List<Event> visitLlvmCmpXchg(LlvmCmpXchg e) {
		Register oldValueRegister = e.getStructRegister(0);
		Register resultRegister = e.getStructRegister(1);

		ExprInterface value = e.getMemValue();
		IExpr address = e.getAddress();
		String mo = e.getMo();
		ExprInterface expectedValue = e.getExpectedValue();

		Local casCmpResult = newLocal(resultRegister, new Atom(oldValueRegister, EQ, expectedValue));
		Label casEnd = newLabel("CAS_end");
		CondJump branchOnCasCmpResult = newJump(new Atom(resultRegister, NEQ, IValue.ONE), casEnd);

		Load load = newRMWLoadExclusive(oldValueRegister, address, IMM.extractLoadMo(mo));
		Store store = newRMWStoreExclusive(address, value, IMM.extractStoreMo(mo), true);

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
		return eventSequence(
				newFence(e.getMo()));
	}

}