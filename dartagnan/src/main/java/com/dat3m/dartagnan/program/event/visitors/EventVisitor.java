package com.dat3m.dartagnan.program.event.visitors;

import com.dat3m.dartagnan.program.event.arch.tso.*;
import com.dat3m.dartagnan.program.event.arch.aarch64.*;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.core.rmw.*;
import com.dat3m.dartagnan.program.event.lang.catomic.*;
import com.dat3m.dartagnan.program.event.lang.linux.*;
import com.dat3m.dartagnan.program.event.lang.linux.cond.*;
import com.dat3m.dartagnan.program.event.lang.pthread.*;
import com.dat3m.dartagnan.program.event.lang.svcomp.*;

public interface EventVisitor<T> {
    
	// Basic events
	default T visit(Assume e) { return visit((Event)e); };
	default T visit(Cmp e) { return visit((Skip)e); };
	default T visit(CondJump e) { return visit((Event)e); };
	default T visit(Event e) { return visit((Event)e); };
	default T visit(ExecutionStatus e) { return visit((Event)e); };
	default T visit(Fence e) { return visit((Event)e); };
	default T visit(FunCall e) { return visit((Event)e); };
	default T visit(FunRet e) { return visit((Event)e); };
	default T visit(IfAsJump e) { return visit((CondJump)e); };
	default T visit(Init e) { return visit((MemEvent)e); };
	default T visit(Label e) { return visit((Event)e); };
	default T visit(Load e) { return visit((MemEvent)e); };
	default T visit(Local e) { return visit((Event)e); };
	default T visit(MemEvent e) { return visit((Event)e); };
	default T visit(Skip e) { return visit((Event)e); };
	default T visit(Store e) { return visit((MemEvent)e); };

	// Pthread Events
	default T visit(Create e) { return visit((Store)e); };
	default T visit(End e) { return visit((Store)e); };
	default T visit(InitLock e) { return visit((Store)e); };
	default T visit(Join e) { return visit((Load)e); };
	default T visit(Lock e) { return visit((MemEvent)e); };
	default T visit(Start e) { return visit((Load)e); };
	default T visit(Unlock e) { return visit((MemEvent)e); };
	
	// AARCH64 Events
	default T visit(StoreExclusive e) { return visit((Store)e); };

	// Linux Events
	default T visit(RMWAbstract e) { return visit((MemEvent)e); };
	default T visit(RMWAddUnless e) { return visit((RMWAbstract)e); };
	default T visit(RMWCmpXchg e) { return visit((RMWAbstract)e); };
	default T visit(RMWFetchOp e) { return visit((RMWAbstract)e); };
	default T visit(RMWOp e) { return visit((RMWAbstract)e); };
	default T visit(RMWOpAndTest e) { return visit((RMWAbstract)e); };
	default T visit(RMWOpReturn e) { return visit((RMWAbstract)e); };
	default T visit(RMWXchg e) { return visit((RMWAbstract)e); };

	// Linux Cond Events
	default T visit(FenceCond e) { return visit((Fence)e); };
	default T visit(RMWReadCond e) { return visit((Load)e); };
	default T visit(RMWReadCondCmp e) { return visit((RMWReadCond)e); };
	default T visit(RMWReadCondUnless e) { return visit((RMWReadCond)e); };
	default T visit(RMWStoreCond e) { return visit((RMWStore)e); };

	// TSO Events
	default T visit(Xchg e) { return visit((MemEvent)e); };

	// Atomic Events
	default T visit(AtomicAbstract e) { return visit((MemEvent)e); };
	default T visit(AtomicCmpXchg e) { return visit((AtomicAbstract)e); };
	default T visit(AtomicFetchOp e) { return visit((AtomicAbstract)e); };
	default T visit(AtomicLoad e) { return visit((MemEvent)e); };
	default T visit(AtomicStore e) { return visit((MemEvent)e); };
	default T visit(AtomicThreadFence e) { return visit((Fence)e); };
	default T visit(AtomicXchg e) { return visit((AtomicAbstract)e); };
	default T visit(Dat3mCAS e) { return visit((AtomicAbstract)e); };

	// SVCOMP Events
	default T visit(BeginAtomic e) { return visit((Event)e); };
	default T visit(EndAtomic e) { return visit((Event)e); };
}