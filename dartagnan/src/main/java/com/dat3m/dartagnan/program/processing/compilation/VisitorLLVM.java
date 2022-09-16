package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.Tag.C11;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.core.rmw.RMWStore;
import com.dat3m.dartagnan.program.event.lang.llvm.*;
import com.dat3m.dartagnan.program.event.lang.pthread.Create;
import com.dat3m.dartagnan.program.event.lang.pthread.End;
import com.dat3m.dartagnan.program.event.lang.pthread.Join;
import com.dat3m.dartagnan.program.event.lang.pthread.Start;

import java.util.List;

import static com.dat3m.dartagnan.expression.op.COpBin.EQ;
import static com.dat3m.dartagnan.expression.op.COpBin.NEQ;
import static com.dat3m.dartagnan.program.event.EventFactory.*;

public class VisitorLLVM extends VisitorBase {

	protected VisitorLLVM() {}
	
	@Override
	public List<Event> visitCreate(Create e) {

        Store store = newStore(e.getAddress(), e.getMemValue(), Tag.C11.MO_RELEASE);
        store.addFilters(C11.PTHREAD);

        return eventSequence(
                store
        );
	}

	@Override
	public List<Event> visitEnd(End e) {
        return eventSequence(
                newStore(e.getAddress(), IValue.ZERO, Tag.C11.MO_RELEASE)
        );
	}

	@Override
	public List<Event> visitJoin(Join e) {
        Register resultRegister = e.getResultRegister();
		Load load = newLoad(resultRegister, e.getAddress(), Tag.C11.MO_ACQUIRE);
        load.addFilters(C11.PTHREAD);
        
        return eventSequence(
        		load,
        		newJumpUnless(new Atom(resultRegister, EQ, IValue.ZERO), (Label) e.getThread().getExit())
        );
	}

	@Override
	public List<Event> visitStart(Start e) {
        Register resultRegister = e.getResultRegister();

        return eventSequence(
        		newLoad(resultRegister, e.getAddress(), Tag.C11.MO_ACQUIRE),
        		newJumpUnless(new Atom(resultRegister, EQ, IValue.ONE), (Label) e.getThread().getExit())
        );
	}

	@Override
	public List<Event> visitLlvmCmpXchg(LlvmCmpXchg e) {
		Register resultRegister = e.getResultRegister();
		IExpr address = e.getAddress();
		String mo = e.getMo();
		IExpr expectedAddr = e.getExpectedAddr();
		int precision = resultRegister.getPrecision();

		Register regExpected = e.getThread().newRegister(precision);
        Register regValue = e.getThread().newRegister(precision);
        Load loadExpected = newLoad(regExpected, expectedAddr, null);
        Store storeExpected = newStore(expectedAddr, regValue, null);
        Label casFail = newLabel("CAS_fail");
        Label casEnd = newLabel("CAS_end");
        Local casCmpResult = newLocal(resultRegister, new Atom(regValue, EQ, regExpected));
        CondJump branchOnCasCmpResult = newJump(new Atom(resultRegister, NEQ, IValue.ONE), casFail);
        CondJump gotoCasEnd = newGoto(casEnd);
        Load loadValue = newRMWLoad(regValue, address, mo);
        loadValue.addFilters(C11.ATOMIC);
        Store storeValue = newRMWStore(loadValue, address, e.getMemValue(), mo);
        storeValue.addFilters(C11.ATOMIC);

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
	public List<Event> visitLlvmRMW(LlvmRMW e) {
		Register resultRegister = e.getResultRegister();
		IOpBin op = e.getOp();
		IExpr address = e.getAddress();
		String mo = e.getMo();
		
        Register dummyReg = e.getThread().newRegister(resultRegister.getPrecision());
        Load load = newRMWLoad(resultRegister, address, Tag.C11.extractLoadMo(mo));
        RMWStore store = newRMWStore(load, address, dummyReg, Tag.C11.extractStoreMo(mo));
        
		return eventSequence(
                load,
                newLocal(dummyReg, new IExprBin(resultRegister, op, (IExpr) e.getMemValue())),
                store
        );
	}

	@Override
	public List<Event> visitLlvmLoad(LlvmLoad e) {
        Load load = newLoad(e.getResultRegister(), e.getAddress(), Tag.C11.extractLoadMo(e.getMo()));
        
		return eventSequence(
        		load
        );
	}

	@Override
	public List<Event> visitLlvmStore(LlvmStore e) {
        Store store = newStore(e.getAddress(), e.getMemValue(), Tag.C11.extractStoreMo(e.getMo()));
        
		return eventSequence(
        		store
        );
	}

	@Override
	public List<Event> visitLlvmXchg(LlvmXchg e) {
		IExpr address = e.getAddress();
		String mo = e.getMo();

        Load load = newRMWLoad(e.getResultRegister(), address, Tag.C11.extractLoadMo(mo));
        RMWStore store = newRMWStore(load, address, e.getMemValue(), Tag.C11.extractStoreMo(mo));
        
		return eventSequence(
                load,
                store
        );
	}
}