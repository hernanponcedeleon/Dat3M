package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.Tag.IMM;
import com.dat3m.dartagnan.program.event.Tag.C11;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.lang.catomic.*;
import com.dat3m.dartagnan.program.event.lang.llvm.*;
import com.dat3m.dartagnan.program.event.lang.pthread.*;
import com.dat3m.dartagnan.program.expression.Expression;
import com.dat3m.dartagnan.program.expression.type.Type;

import java.util.Collections;
import java.util.List;

import static com.dat3m.dartagnan.GlobalSettings.getArchPrecision;
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
		String mo = e.getMo();
        return eventSequence(
				newLoad(e.getResultRegister(), e.getAddress(), mo.isEmpty() || mo.equals(C11.NONATOMIC) ? C11.MO_RELAXED : mo)
        );
	}

	@Override
	public List<Event> visitStore(Store e) {
		String mo = e.getMo();
        return eventSequence(
				newStore(e.getAddress(), e.getMemValue(), mo.isEmpty() || mo.equals(C11.NONATOMIC) ? C11.MO_RELAXED : mo)
        );
	}

	@Override
	public List<Event> visitCreate(Create e) {
        Store store = newStore(e.getAddress(), e.getMemValue(), C11.MO_RELEASE);
        store.addFilters(C11.PTHREAD);
        
        return eventSequence(
                store
        );
	}

	@Override
	public List<Event> visitEnd(End e) {
		//TODO boolean
        return eventSequence(
				newStore(e.getAddress(), expressions.makeZero(archType), C11.MO_RELEASE)
        );
	}

	@Override
	public List<Event> visitJoin(Join e) {
        Register resultRegister = e.getResultRegister();
		IValue zero = expressions.makeZero(resultRegister.getType());
		Load load = newLoad(resultRegister, e.getAddress(), C11.MO_ACQUIRE);
        load.addFilters(C11.PTHREAD);
        
        return eventSequence(
				load,
				newJump(expressions.makeBinary(resultRegister, NEQ, zero), (Label) e.getThread().getExit())
        );
	}

	@Override
	public List<Event> visitStart(Start e) {
        Register resultRegister = e.getResultRegister();
		IValue one = expressions.makeOne(resultRegister.getType());
        Load load = newLoad(resultRegister, e.getAddress(), C11.MO_ACQUIRE);
        load.addFilters(Tag.STARTLOAD);

        return eventSequence(
				load,
				super.visitStart(e),
				newJump(expressions.makeBinary(resultRegister, NEQ, one), (Label) e.getThread().getExit())
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
		Type type = resultRegister.getType();
		IValue one = expressions.makeOne(type);

		Register regExpected = e.getThread().newRegister(type);
        Register regValue = e.getThread().newRegister(type);
        Load loadExpected = newLoad(regExpected, expectedAddr, "");
        loadExpected.addFilters(Tag.IMM.CASDEPORIGIN);
        Store storeExpected = newStore(expectedAddr, regValue, "");
        Label casFail = newLabel("CAS_fail");
        Label casEnd = newLabel("CAS_end");
        Local casCmpResult = newLocal(resultRegister, expressions.makeBinary(regValue, EQ, regExpected));
        CondJump branchOnCasCmpResult = newJump(expressions.makeBinary(resultRegister, NEQ, one), casFail);
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

		Register dummyReg = e.getThread().newRegister(resultRegister.getType());
        Load load = newRMWLoad(resultRegister, address, extractLoadMo(mo));

        return eventSequence(
				optionalFenceBefore,
                load,
                newLocal(dummyReg, expressions.makeBinary(resultRegister, op, (IExpr) e.getMemValue())),
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
		Expression value = e.getMemValue();
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

		Register dummyReg = e.getThread().newRegister(resultRegister.getType());
		Local localOp = newLocal(dummyReg, expressions.makeBinary(resultRegister, op, value));

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
		IValue one = expressions.makeOne(resultRegister.getType());

		Expression value = e.getMemValue();
		IExpr address = e.getAddress();
		String mo = e.getMo();
		Expression expectedValue = e.getExpectedValue();

		Local casCmpResult = newLocal(resultRegister, expressions.makeBinary(oldValueRegister, EQ, expectedValue));
		Label casEnd = newLabel("CAS_end");
		CondJump branchOnCasCmpResult = newJump(expressions.makeBinary(resultRegister, NEQ, one), casEnd);

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