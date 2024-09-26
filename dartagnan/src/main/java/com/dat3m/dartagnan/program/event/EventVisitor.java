package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.program.event.arch.StoreExclusive;
import com.dat3m.dartagnan.program.event.arch.c11.OpenCLBarrier;
import com.dat3m.dartagnan.program.event.arch.ptx.PTXAtomCAS;
import com.dat3m.dartagnan.program.event.arch.ptx.PTXAtomExch;
import com.dat3m.dartagnan.program.event.arch.ptx.PTXAtomOp;
import com.dat3m.dartagnan.program.event.arch.ptx.PTXRedOp;
import com.dat3m.dartagnan.program.event.arch.tso.TSOXchg;
import com.dat3m.dartagnan.program.event.arch.vulkan.VulkanCmpXchg;
import com.dat3m.dartagnan.program.event.arch.vulkan.VulkanRMW;
import com.dat3m.dartagnan.program.event.arch.vulkan.VulkanRMWExtremum;
import com.dat3m.dartagnan.program.event.arch.vulkan.VulkanRMWOp;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.core.annotations.CodeAnnotation;
import com.dat3m.dartagnan.program.event.lang.catomic.*;
import com.dat3m.dartagnan.program.event.lang.linux.*;
import com.dat3m.dartagnan.program.event.lang.llvm.*;
import com.dat3m.dartagnan.program.event.lang.pthread.InitLock;
import com.dat3m.dartagnan.program.event.lang.pthread.Lock;
import com.dat3m.dartagnan.program.event.lang.pthread.Unlock;
import com.dat3m.dartagnan.program.event.lang.svcomp.BeginAtomic;
import com.dat3m.dartagnan.program.event.lang.svcomp.EndAtomic;
import com.dat3m.dartagnan.program.event.lang.spirv.*;

public interface EventVisitor<T> {

    // ============================== General events ==============================
    T visitEvent(Event e);
    default T visitMemEvent(MemoryEvent e) { return visitEvent(e); }

    // ============================== Core-level events ==============================
    default T visitAssume(Assume e) { return visitEvent(e); }
    default T visitAssert(Assert e) { return visitEvent(e); }
    default T visitCondJump(CondJump e) { return visitEvent(e); }
    default T visitExecutionStatus(ExecutionStatus e) { return visitEvent(e); }
    default T visitIfAsJump(IfAsJump e) { return visitCondJump(e); }
    default T visitLabel(Label e) { return visitEvent(e); }
    default T visitLocal(Local e) { return visitEvent(e); }
    default T visitSkip(Skip e) { return visitEvent(e); }

    default T visitGenericVisibleEvent(GenericVisibleEvent e) { return visitEvent(e); }
    default T visitMemCoreEvent(MemoryCoreEvent e) { return visitMemEvent(e); }
    default T visitLoad(Load e) { return visitMemCoreEvent(e); }
    default T visitStore(Store e) { return visitMemCoreEvent(e); }
    default T visitInit(Init e) { return visitStore(e); }
    default T visitAlloc(Alloc e) { return visitEvent(e); }
    // RMW core events
    default T visitRMWStore(RMWStore e) { return visitStore(e); }
    default T visitRMWStoreExclusive(RMWStoreExclusive e) { return visitStore(e); }
    // Annotations
    default T visitCodeAnnotation(CodeAnnotation e) { return visitEvent(e); }

    // ============================== Language-level events ==============================

    // ------------------ Pthread Events ------------------
    default T visitInitLock(InitLock e) { return visitMemEvent(e); }
    default T visitLock(Lock e) { return visitMemEvent(e); }
    default T visitUnlock(Unlock e) { return visitMemEvent(e); }

    // ------------------ AARCH64 Events ------------------
    default T visitStoreExclusive(StoreExclusive e) { return visitMemEvent(e); }

    // ------------------ Linux Events ------------------
    default T visitLKMMAddUnless(LKMMAddUnless e) { return visitMemEvent(e); }
    default T visitLKMMCmpXchg(LKMMCmpXchg e) { return visitMemEvent(e); }
    default T visitLKMMFetchOp(LKMMFetchOp e) { return visitMemEvent(e); }
    default T visitLKMMOpNoReturn(LKMMOpNoReturn e) { return visitMemEvent(e); }
    default T visitLKMMOpAndTest(LKMMOpAndTest e) { return visitMemEvent(e); }
    default T visitLKMMOpReturn(LKMMOpReturn e) { return visitMemEvent(e); }
    default T visitLKMMXchg(LKMMXchg e) { return visitMemEvent(e); }
    default T visitLKMMFence(LKMMFence e) { return visitEvent(e); }
    default T visitLKMMLoad(LKMMLoad e) { return visitMemEvent(e); }
    default T visitLKMMStore(LKMMStore e) { return visitMemEvent(e); }

    // Linux Lock Events
    default T visitLKMMLock(LKMMLock e) { return visitMemEvent(e); }
    default T visitLKMMUnlock(LKMMUnlock e) { return visitMemEvent(e); }

    // ------------------ TSO Events ------------------
    default T visitTSOXchg(TSOXchg e) { return visitMemEvent(e); }

    // ------------------ C-Atomic Events ------------------
    default T visitAtomicCmpXchg(AtomicCmpXchg e) { return visitMemEvent(e); }
    default T visitAtomicFetchOp(AtomicFetchOp e) { return visitMemEvent(e); }
    default T visitAtomicLoad(AtomicLoad e) { return visitMemEvent(e); }
    default T visitAtomicStore(AtomicStore e) { return visitMemEvent(e); }
    default T visitAtomicThreadFence(AtomicThreadFence e) { return visitEvent(e); }
    default T visitAtomicXchg(AtomicXchg e) { return visitMemEvent(e); }

    // ------------------ LLVM Events ------------------
    default T visitLlvmCmpXchg(LlvmCmpXchg e) { return visitMemEvent(e); }
    default T visitLlvmRMW(LlvmRMW e) { return visitMemEvent(e); }
    default T visitLlvmLoad(LlvmLoad e) { return visitMemEvent(e); }
    default T visitLlvmStore(LlvmStore e) { return visitMemEvent(e); }
    default T visitLlvmXchg(LlvmXchg e) { return visitMemEvent(e); }
    default T visitLlvmFence(LlvmFence e) { return visitEvent(e); }

    // ------------------ SVCOMP Events ------------------
    default T visitBeginAtomic(BeginAtomic e) { return visitEvent(e); }
    default T visitEndAtomic(EndAtomic e) { return visitEvent(e); }

    // ------------------ GPU Events ------------------
    default T visitControlBarrier(ControlBarrier e) { return visitEvent(e); }
    default T visitOpenCLBarrier(OpenCLBarrier e) { return visitEvent(e); }
    default T visitPtxRedOp(PTXRedOp e) { return visitMemEvent(e); }
    default T visitPtxAtomOp(PTXAtomOp e) { return visitMemEvent(e); }
    default T visitPtxAtomCAS(PTXAtomCAS e) { return visitMemEvent(e); }
    default T visitPtxAtomExch(PTXAtomExch e) { return visitMemEvent(e); }
    default T visitVulkanRMW(VulkanRMW e) { return visitMemEvent(e); }
    default T visitVulkanRMWExtremum(VulkanRMWExtremum e) { return visitMemEvent(e); }
    default T visitVulkanRMWOp(VulkanRMWOp e) { return visitMemEvent(e); }
    default T visitVulkanCmpXchg(VulkanCmpXchg e) { return visitMemEvent(e); }

    // ------------------ Spir-V Events ------------------
    default T visitSpirvLoad(SpirvLoad e) { return visitMemEvent(e); }
    default T visitSpirvStore(SpirvStore e) { return visitMemEvent(e); }
    default T visitSpirvRMW(SpirvRmw e) { return visitMemEvent(e); }
    default T visitSpirvXchg(SpirvXchg e) { return visitMemEvent(e); }
    default T visitSpirvCmpXchg(SpirvCmpXchg e) { return visitMemEvent(e); }
    default T visitSpirvRmwExtremum(SpirvRmwExtremum e) { return visitMemEvent(e); }
}