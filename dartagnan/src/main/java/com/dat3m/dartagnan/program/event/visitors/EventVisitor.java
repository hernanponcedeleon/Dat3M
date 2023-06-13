package com.dat3m.dartagnan.program.event.visitors;

import com.dat3m.dartagnan.program.event.arch.StoreExclusive;
import com.dat3m.dartagnan.program.event.arch.lisa.RMW;
import com.dat3m.dartagnan.program.event.arch.tso.Xchg;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.core.annotations.CodeAnnotation;
import com.dat3m.dartagnan.program.event.core.rmw.RMWStore;
import com.dat3m.dartagnan.program.event.core.rmw.RMWStoreExclusive;
import com.dat3m.dartagnan.program.event.lang.catomic.*;
import com.dat3m.dartagnan.program.event.lang.linux.*;
import com.dat3m.dartagnan.program.event.lang.llvm.*;
import com.dat3m.dartagnan.program.event.lang.pthread.*;
import com.dat3m.dartagnan.program.event.lang.std.Malloc;
import com.dat3m.dartagnan.program.event.lang.svcomp.BeginAtomic;
import com.dat3m.dartagnan.program.event.lang.svcomp.EndAtomic;

public interface EventVisitor<T> {

	T visitEvent(Event e);

	// Basic events
	default T visitAssume(Assume e) { return visitEvent(e); }
	default T visitCondJump(CondJump e) { return visitEvent(e); }
	default T visitExecutionStatus(ExecutionStatus e) { return visitEvent(e); }
	default T visitFence(Fence e) { return visitEvent(e); }
	default T visitIfAsJump(IfAsJump e) { return visitCondJump(e); }
	default T visitInit(Init e) { return visitStore(e); }
	default T visitLabel(Label e) { return visitEvent(e); }
	default T visitLoad(Load e) { return visitMemCoreEvent(e); }
	default T visitLocal(Local e) { return visitEvent(e); }
	default T visitMemEvent(MemoryEvent e) { return visitEvent(e); }
	default T visitMemCoreEvent(MemoryCoreEvent e) { return visitMemEvent(e); }
	default T visitSkip(Skip e) { return visitEvent(e); }
	default T visitStore(Store e) { return visitMemCoreEvent(e); }

	// Annotations
	default T visitCodeAnnotation(CodeAnnotation e) { return visitEvent(e); }

	// Pthread Events
	default T visitCreate(Create e) { return visitMemEvent(e); }
	default T visitEnd(End e) { return visitMemEvent(e); }
	default T visitInitLock(InitLock e) { return visitMemEvent(e); }
	default T visitJoin(Join e) { return visitMemEvent(e); }
	default T visitLock(Lock e) { return visitMemEvent(e); }
	default T visitStart(Start e) { return visitMemEvent(e); }
	default T visitUnlock(Unlock e) { return visitMemEvent(e); }

	// RMW Events
	default T visitRMWStore(RMWStore e) { return visitStore(e); }
	default T visitRMWStoreExclusive(RMWStoreExclusive e) { return visitStore(e); }

	// AARCH64 Events
	default T visitStoreExclusive(StoreExclusive e) { return visitMemEvent(e); }

	// Linux Events
	default T visitRMWAbstract(RMWAbstract e) { return visitMemEvent(e); }
	default T visitRMWAddUnless(RMWAddUnless e) { return visitRMWAbstract(e); }
	default T visitRMWCmpXchg(RMWCmpXchg e) { return visitRMWAbstract(e); }
	default T visitRMWFetchOp(RMWFetchOp e) { return visitRMWAbstract(e); }
	default T visitRMWOp(RMWOp e) { return visitRMWAbstract(e); }
	default T visitRMWOpAndTest(RMWOpAndTest e) { return visitRMWAbstract(e); }
	default T visitRMWOpReturn(RMWOpReturn e) { return visitRMWAbstract(e); }
	default T visitRMWXchg(RMWXchg e) { return visitRMWAbstract(e); }
	default T visitLKMMFence(LKMMFence e) { return visitFence(e); }
	default T visitLKMMLoad(LKMMLoad e) { return visitLoad(e); }
	default T visitLKMMStore(LKMMStore e) { return visitStore(e); }

	// Linux Lock Events
	default T visitLKMMLock(LKMMLock e) { return visitMemEvent(e); }
	default T visitLKMMUnlock(LKMMUnlock e) { return visitStore(e); }

	// Linux SRCU Events
	default T visitSrcuSync(SrcuSync e) { return visitMemCoreEvent(e); }

	// TSO Events
	default T visitXchg(Xchg e) { return visitMemEvent(e); }

	// LISA Events
	default T visitRMW(RMW e) { return visitMemEvent(e); }

	// Atomic Events
	default T visitAtomicAbstract(AtomicAbstract e) { return visitMemEvent(e); }
	default T visitAtomicCmpXchg(AtomicCmpXchg e) { return visitAtomicAbstract(e); }
	default T visitAtomicFetchOp(AtomicFetchOp e) { return visitAtomicAbstract(e); }
	default T visitAtomicLoad(AtomicLoad e) { return visitMemEvent(e); }
	default T visitAtomicStore(AtomicStore e) { return visitMemEvent(e); }
	default T visitAtomicThreadFence(AtomicThreadFence e) { return visitFence(e); }
	default T visitAtomicXchg(AtomicXchg e) { return visitAtomicAbstract(e); }

	// LLVM Events
	default T visitLlvmAbstract(LlvmAbstractRMW e) { return visitMemEvent(e); }
	default T visitLlvmCmpXchg(LlvmCmpXchg e) { return visitLlvmAbstract(e); }
	default T visitLlvmRMW(LlvmRMW e) { return visitLlvmAbstract(e); }
	default T visitLlvmLoad(LlvmLoad e) { return visitMemEvent(e); }
	default T visitLlvmStore(LlvmStore e) { return visitMemEvent(e); }
	default T visitLlvmXchg(LlvmXchg e) { return visitLlvmAbstract(e); }
	default T visitLlvmFence(LlvmFence e) { return visitFence(e); }

	// SVCOMP Events
	default T visitBeginAtomic(BeginAtomic e) { return visitEvent(e); }
	default T visitEndAtomic(EndAtomic e) { return visitEvent(e); }

	// Std events
	default T visitMalloc(Malloc e) { return visitEvent(e); }
}