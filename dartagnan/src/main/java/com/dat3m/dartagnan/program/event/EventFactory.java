package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.booleans.BoolLiteral;
import com.dat3m.dartagnan.expression.integers.IntBinaryOp;
import com.dat3m.dartagnan.expression.integers.IntCmpOp;
import com.dat3m.dartagnan.expression.type.FunctionType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.arch.StoreExclusive;
import com.dat3m.dartagnan.program.event.arch.c11.C11Init;
import com.dat3m.dartagnan.program.event.arch.c11.OpenCLInit;
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
import com.dat3m.dartagnan.program.event.core.annotations.FunCallMarker;
import com.dat3m.dartagnan.program.event.core.annotations.FunReturnMarker;
import com.dat3m.dartagnan.program.event.core.annotations.StringAnnotation;
import com.dat3m.dartagnan.program.event.core.threading.ThreadArgument;
import com.dat3m.dartagnan.program.event.core.threading.ThreadCreate;
import com.dat3m.dartagnan.program.event.core.threading.ThreadStart;
import com.dat3m.dartagnan.program.event.functions.AbortIf;
import com.dat3m.dartagnan.program.event.functions.Return;
import com.dat3m.dartagnan.program.event.functions.ValueFunctionCall;
import com.dat3m.dartagnan.program.event.functions.VoidFunctionCall;
import com.dat3m.dartagnan.program.event.lang.catomic.*;
import com.dat3m.dartagnan.program.event.lang.linux.*;
import com.dat3m.dartagnan.program.event.lang.llvm.*;
import com.dat3m.dartagnan.program.event.lang.pthread.InitLock;
import com.dat3m.dartagnan.program.event.lang.pthread.Lock;
import com.dat3m.dartagnan.program.event.lang.pthread.Unlock;
import com.dat3m.dartagnan.program.event.lang.spirv.*;
import com.dat3m.dartagnan.program.event.lang.svcomp.*;
import com.dat3m.dartagnan.program.memory.MemoryObject;

import java.util.*;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.program.event.FenceNameRepository.*;

public class EventFactory {

    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();

    // Static class
    private EventFactory() {
    }

    // =============================================================================================
    // ========================================= Utility ===========================================
    // =============================================================================================

    public static List<Event> eventSequence(Event... events) {
        return eventSequence(Arrays.asList(events));
    }

    public static List<Event> eventSequence(Collection<? extends Event> events) {
        return events.stream().filter(Objects::nonNull).collect(Collectors.toList());
    }

    public static List<Event> eventSequence(Object... events) {
        List<Event> retVal = new ArrayList<>();
        for (Object obj : events) {
            if (obj == null) {
                continue;
            }
            if (obj instanceof Event) {
                retVal.add((Event) obj);
            } else if (obj instanceof Collection<?>) {
                retVal.addAll((Collection<? extends Event>) obj);
            } else {
                throw new IllegalArgumentException("Cannot parse " + obj.getClass() + " as event.");
            }
        }
        return retVal;
    }


    // =============================================================================================
    // ======================================= DAT3m events ========================================
    // =============================================================================================

    // ------------------------------------------ Memory events ------------------------------------------

    public static Alloc newAlloc(Register register, Type allocType, Expression arraySize,
                                 boolean isHeapAlloc, boolean doesZeroOutMemory) {
        return new Alloc(register, allocType, arraySize, isHeapAlloc, doesZeroOutMemory);
    }

    public static Load newLoad(Register register, Expression address) {
        return new Load(register, address);
    }

    public static Load newLoadWithMo(Register register, Expression address, String mo) {
        Load load = newLoad(register, address);
        load.setMemoryOrder(mo);
        return load;
    }

    public static Store newStore(Expression address, Expression value) {
        return new Store(address, value);
    }

    public static Store newStoreWithMo(Expression address, Expression value, String mo) {
        Store store = newStore(address, value);
        store.setMemoryOrder(mo);
        return store;
    }

    public static GenericVisibleEvent newFence(String name) {
        return new GenericVisibleEvent(name, name, Tag.FENCE);
    }

    public static GenericVisibleEvent newFenceOpt(String name, String opt) {
        GenericVisibleEvent fence = newFence(name + "." + opt);
        fence.addTags(name);
        return fence;
    }

    public static ControlBarrier newControlBarrier(String name, Expression fenceId) {
        return new ControlBarrier(name, fenceId);
    }

    public static Init newInit(MemoryObject base, int offset) {
        //TODO: We simplify here because virtual aliasing currently fails when pointer arithmetic is involved
        // meaning that <addr> and <addr + 0> are treated differently.
        final Expression address = offset == 0 ? base :
                expressions.makeAdd(base, expressions.makeValue(offset, (IntegerType) base.getType()));
        return new Init(base, offset, address);
    }

    public static ValueFunctionCall newValueFunctionCall(Register resultRegister, Function function, List<Expression> arguments) {
        return new ValueFunctionCall(resultRegister, function.getFunctionType(), function, arguments);
    }

    public static ValueFunctionCall newValueFunctionCall(Register resultRegister, FunctionType funcType,
                                                         Expression funcPtr, List<Expression> arguments) {
        return new ValueFunctionCall(resultRegister, funcType, funcPtr, arguments);
    }

    public static VoidFunctionCall newVoidFunctionCall(Function function, List<Expression> arguments) {
        return new VoidFunctionCall(function.getFunctionType(), function, arguments);
    }
    public static VoidFunctionCall newVoidFunctionCall(FunctionType funcType, Expression funcPtr, List<Expression> arguments) {
        return new VoidFunctionCall(funcType, funcPtr, arguments);
    }

    public static Return newFunctionReturn(Expression returnExpression) {
        return new Return(returnExpression);
    }

    public static AbortIf newAbortIf(Expression condition) {
        return new AbortIf(condition);
    }

    // ------------------------------------------ Local events ------------------------------------------

    public static Skip newSkip() {
        return new Skip();
    }

    public static FunCallMarker newFunctionCallMarker(String funName) {
        return new FunCallMarker(funName);
    }

    public static FunReturnMarker newFunctionReturnMarker(String funName) {
        return new FunReturnMarker(funName);
    }

    public static StringAnnotation newStringAnnotation(String annotation) {
        return new StringAnnotation(annotation);
    }

    public static Local newLocal(Register register, Expression expr) {
        return new Local(register, expr);
    }

    public static Label newLabel(String name) {
        return new Label(name);
    }

    public static CondJump newJump(Expression cond, Label target) {
        return new CondJump(cond, target);
    }

    public static CondJump newJumpUnless(Expression cond, Label target) {
        if (cond instanceof BoolLiteral constant && !constant.getValue()) {
            return newGoto(target);
        }
        return new CondJump(expressions.makeNot(cond), target);
    }

    public static IfAsJump newIfJump(Expression expr, Label label, Label end) {
        return new IfAsJump(expr, label, end);
    }

    public static IfAsJump newIfJumpUnless(Expression expr, Label label, Label end) {
        return newIfJump(expressions.makeNot(expr), label, end);
    }

    public static CondJump newGoto(Label target) {
        return newJump(expressions.makeTrue(), target);
    }

    public static CondJump newFakeCtrlDep(Register reg, Label target) {
        CondJump jump = newJump(expressions.makeEQ(reg, reg), target);
        jump.addTags(Tag.NOOPT);
        return jump;
    }

    public static Assume newAssume(Expression expr) {
        return new Assume(expr);
    }

    public static Assert newAssert(Expression expr, String errorMessage) {
        return new Assert(expr, errorMessage);
    }

    // ------------------------------------------ RMW events ------------------------------------------

    public static Load newRMWLoad(Register reg, Expression address) {
        Load load = newLoad(reg, address);
        load.addTags(Tag.RMW);
        return load;
    }

    public static Load newRMWLoadWithMo(Register reg, Expression address, String mo) {
        Load load = newLoadWithMo(reg, address, mo);
        load.addTags(Tag.RMW);
        return load;
    }

    public static RMWStore newRMWStore(Load loadEvent, Expression address, Expression value) {
        return new RMWStore(loadEvent, address, value);
    }

    public static RMWStore newRMWStoreWithMo(Load loadEvent, Expression address, Expression value, String mo) {
        RMWStore store = newRMWStore(loadEvent, address, value);
        store.setMemoryOrder(mo);
        return store;
    }

    public static Load newRMWLoadExclusive(Register reg, Expression address) {
        Load load = newLoad(reg, address);
        load.addTags(Tag.RMW, Tag.EXCL);
        return load;
    }

    public static Load newRMWLoadExclusiveWithMo(Register reg, Expression address, String mo) {
        Load load = newRMWLoadExclusive(reg, address);
        load.setMemoryOrder(mo);
        return load;
    }

    public static RMWStoreExclusive newRMWStoreExclusive(Expression address, Expression value, boolean isStrong) {
        return new RMWStoreExclusive(address, value, isStrong, false);
    }

    public static RMWStoreExclusive newRMWStoreExclusiveWithMo(Expression address, Expression value, boolean isStrong, String mo) {
        RMWStoreExclusive store = newRMWStoreExclusive(address, value, isStrong);
        store.setMemoryOrder(mo);
        return store;
    }

    public static ExecutionStatus newExecutionStatus(Register register, Event event) {
        return new ExecutionStatus(register, event, false);
    }

    public static ExecutionStatus newExecutionStatusWithDependencyTracking(Register register, Event event) {
        return new ExecutionStatus(register, event, true);
    }

    // ------------------------------------------ Threading events ------------------------------------------

    public static ThreadCreate newThreadCreate(List<Expression> arguments) {
        return new ThreadCreate(arguments);
    }

    public static ThreadArgument newThreadArgument(Register resultReg, ThreadCreate creator, int argIndex) {
        return new ThreadArgument(resultReg, creator, argIndex);
    }

    public static ThreadStart newThreadStart(ThreadCreate creator) {
        return new ThreadStart(creator);
    }

    // =============================================================================================
    // ========================================== Common ===========================================
    // =============================================================================================

    /*
        "Common" contains events that are shared between different architectures, yet are no core events.
     */
    public static class Common {
        private Common() {
        }

        public static StoreExclusive newExclusiveStore(Register register, Expression address, Expression value, String mo) {
            return new StoreExclusive(register, address, value, mo);
        }
    }

    // =============================================================================================
    // ========================================== Pthread ==========================================
    // =============================================================================================

    public static class Pthread {
        private Pthread() {
        }

        public static InitLock newInitLock(String name, Expression address, Expression ignoreAttributes) {
            //TODO store attributes inside mutex object
            return new InitLock(name, address, expressions.makeZero(TypeFactory.getInstance().getArchType()));
        }

        public static Lock newLock(String name, Expression address) {
            return new Lock(name, address);
        }

        public static Unlock newUnlock(String name, Expression address) {
            return new Unlock(name, address);
        }
    }

    // =============================================================================================
    // ========================================== Atomics ==========================================
    // =============================================================================================

    public static class Atomic {
        private Atomic() {
        }

        public static AtomicCmpXchg newCompareExchange(Register register, Expression address, Expression expectedAddr, Expression desiredValue, String mo, boolean isStrong) {
            return new AtomicCmpXchg(register, address, expectedAddr, desiredValue, mo, isStrong);
        }

        public static AtomicCmpXchg newCompareExchange(Register register, Expression address, Expression expectedAddr, Expression desiredValue, String mo) {
            return newCompareExchange(register, address, expectedAddr, desiredValue, mo, false);
        }

        public static AtomicFetchOp newFetchOp(Register register, Expression address, Expression value, IntBinaryOp op, String mo) {
            return new AtomicFetchOp(register, address, op, value, mo);
        }

        public static AtomicFetchOp newFADD(Register register, Expression address, Expression value, String mo) {
            return newFetchOp(register, address, value, IntBinaryOp.ADD, mo);
        }

        public static AtomicFetchOp newIncrement(Register register, Expression address, String mo) {
            if (!(register.getType() instanceof IntegerType integerType)) {
                throw new IllegalArgumentException(
                        String.format("Non-integer type %s for increment operation.", register.getType()));
            }
            return newFetchOp(register, address, expressions.makeOne(integerType), IntBinaryOp.ADD, mo);
        }

        public static AtomicLoad newLoad(Register register, Expression address, String mo) {
            return new AtomicLoad(register, address, mo);
        }

        public static AtomicStore newStore(Expression address, Expression value, String mo) {
            return new AtomicStore(address, value, mo);
        }

        public static AtomicThreadFence newFence(String mo) {
            return new AtomicThreadFence(mo);
        }

        public static AtomicXchg newExchange(Register register, Expression address, Expression value, String mo) {
            return new AtomicXchg(register, address, value, mo);
        }

        public static C11Init newC11Init(MemoryObject base, int offset) {
            final Expression address = offset == 0 ? base :
                    expressions.makeAdd(base, expressions.makeValue(offset, (IntegerType) base.getType()));
            return new C11Init(base, offset, address);
        }
    }
    // =============================================================================================
    // =========================================== LLVM ============================================
    // =============================================================================================

    public static class Llvm {
        private Llvm() {
        }

        public static LlvmLoad newLoad(Register register, Expression address, String mo) {
            return new LlvmLoad(register, address, mo);
        }

        public static LlvmStore newStore(Expression address, Expression value, String mo) {
            return new LlvmStore(address, value, mo);
        }

        public static LlvmXchg newExchange(Register register, Expression address, Expression value, String mo) {
            return new LlvmXchg(register, address, value, mo);
        }

        public static LlvmCmpXchg newCompareExchange(Register oldValueRegister, Register cmpRegister, Expression address, Expression expectedAddr, Expression desiredValue, String mo, boolean isStrong) {
            return new LlvmCmpXchg(oldValueRegister, cmpRegister, address, expectedAddr, desiredValue, mo, isStrong);
        }

        public static LlvmCmpXchg newCompareExchange(Register oldValueRegister, Register cmpRegister, Expression address, Expression expectedAddr, Expression desiredValue, String mo) {
            return newCompareExchange(oldValueRegister, cmpRegister, address, expectedAddr, desiredValue, mo, false);
        }

        public static LlvmRMW newRMW(Register register, Expression address, Expression value, IntBinaryOp op, String mo) {
            return new LlvmRMW(register, address, op, value, mo);
        }

        public static LlvmFence newFence(String mo) {
            return new LlvmFence(mo);
        }

    }

    // =============================================================================================
    // ========================================== Svcomp ===========================================
    // =============================================================================================

    public static class Svcomp {
        private Svcomp() {
        }

        public static BeginAtomic newBeginAtomic() {
            return new BeginAtomic();
        }

        public static EndAtomic newEndAtomic(BeginAtomic begin) {
            return new EndAtomic(begin);
        }

        public static LoopBegin newLoopBegin() {
            return new LoopBegin();
        }

        public static SpinStart newSpinStart() {
            return new SpinStart();
        }

        public static SpinEnd newSpinEnd() {
            return new SpinEnd();
        }

        public static LoopBound newLoopBound(Expression bound) {
            return new LoopBound(bound);
        }

        public static NonDetChoice newNonDetChoice(Register register) {
            return new NonDetChoice(register, false);
        }

        public static NonDetChoice newSignedNonDetChoice(Register register, boolean isSigned) {
            return new NonDetChoice(register, isSigned);
        }
    }

    // =============================================================================================
    // ============================================ ARM ============================================
    // =============================================================================================

    public static class AArch64 {
        private AArch64() {
        }

        public static class DMB {
            private DMB() {
            }

            public static GenericVisibleEvent newBarrier() {
                return newSYBarrier(); // Default barrier
            }

            public static GenericVisibleEvent newSYBarrier() {
                return newFence("DMB.SY");
            }

            public static GenericVisibleEvent newISHBarrier() {
                return newFence("DMB.ISH");
            }

            public static GenericVisibleEvent newISHLDBarrier() {
                return newFence("DMB.ISHLD");
            }

            public static GenericVisibleEvent newISHSTBarrier() {
                return newFence("DMB.ISHST");
            }
        }

        public static class DSB {
            private DSB() {
            }

            public static GenericVisibleEvent newBarrier() {
                return newSYBarrier(); // Default barrier
            }

            public static GenericVisibleEvent newSYBarrier() {
                return newFence("DSB.SY");
            }

            public static GenericVisibleEvent newISHBarrier() {
                return newFence("DSB.ISH");
            }

            public static GenericVisibleEvent newISHLDBarrier() {
                return newFence("DSB.ISHLD");
            }

            public static GenericVisibleEvent newISHSTBarrier() {
                return newFence("DSB.ISHST");
            }

        }

    }

    // =============================================================================================
    // =========================================== Linux ===========================================
    // =============================================================================================
    public static class Linux {
        private Linux() {
        }

        public static LKMMLoad newLKMMLoad(Register reg, Expression address, String mo) {
            return new LKMMLoad(reg, address, mo);
        }

        public static LKMMStore newLKMMStore(Expression address, Expression value, String mo) {
            return new LKMMStore(address, value, mo);
        }

        public static LKMMAddUnless newRMWAddUnless(Expression address, Register register, Expression cmp, Expression value) {
            return new LKMMAddUnless(register, address, value, cmp);
        }

        public static LKMMCmpXchg newRMWCompareExchange(Expression address, Register register, Expression cmp, Expression value, String mo) {
            return new LKMMCmpXchg(register, address, cmp, value, mo);
        }

        public static LKMMFetchOp newRMWFetchOp(Expression address, Register register, Expression value, IntBinaryOp op, String mo) {
            return new LKMMFetchOp(register, address, op, value, mo);
        }

        public static LKMMOpNoReturn newRMWOp(Expression address, Expression value, IntBinaryOp op) {
            return new LKMMOpNoReturn(address, op, value);
        }

        public static LKMMOpAndTest newRMWOpAndTest(Expression address, Register register, Expression value, IntBinaryOp op) {
            return new LKMMOpAndTest(register, address, op, value);
        }

        public static LKMMOpReturn newRMWOpReturn(Expression address, Register register, Expression value, IntBinaryOp op, String mo) {
            return new LKMMOpReturn(register, address, op, value, mo);
        }

        public static LKMMXchg newRMWExchange(Expression address, Register register, Expression value, String mo) {
            return new LKMMXchg(register, address, value, mo);
        }

        public static LKMMFence newMemoryBarrier() {
            return new LKMMFence(Tag.Linux.MO_MB);
        }

        public static LKMMFence newLKMMFence(String name) {
            return new LKMMFence(name);
        }

        public static LKMMLock newLock(Expression address) {
            return new LKMMLock(address);
        }

        public static LKMMUnlock newUnlock(Expression address) {
            return new LKMMUnlock(address);
        }

        public static GenericMemoryEvent newSrcuSync(Expression address) {
            GenericMemoryEvent srcuSync = new GenericMemoryEvent(address, "synchronize_srcu");
            srcuSync.addTags(Tag.Linux.SRCU_SYNC);
            return srcuSync;
        }

    }


    // =============================================================================================
    // ============================================ X86 ============================================
    // =============================================================================================
    public static class X86 {
        private X86() {
        }

        public static TSOXchg newExchange(MemoryObject address, Register register) {
            return new TSOXchg(address, register);
        }

        public static GenericVisibleEvent newMemoryFence() {
            return newFence(MFENCE);
        }
    }


    // =============================================================================================
    // =========================================== RISCV ===========================================
    // =============================================================================================
    public static class RISCV {
        private RISCV() {
        }

        public static RMWStoreExclusive newRMWStoreConditional(Expression address, Expression value, String mo, boolean isStrong) {
            RMWStoreExclusive store = new RMWStoreExclusive(address, value, isStrong, true);
            store.addTags(Tag.RISCV.STCOND);
            store.setMemoryOrder(mo);
            return store;
        }

        public static RMWStoreExclusive newRMWStoreConditional(Expression address, Expression value, String mo) {
            return RISCV.newRMWStoreConditional(address, value, mo, false);
        }

        public static GenericVisibleEvent newRRFence() {
            return newFence("Fence.r.r");
        }

        public static GenericVisibleEvent newRWFence() {
            return newFence("Fence.r.w");
        }

        public static GenericVisibleEvent newRRWFence() {
            return newFence("Fence.r.rw");
        }

        public static GenericVisibleEvent newWRFence() {
            return newFence("Fence.w.r");
        }

        public static GenericVisibleEvent newWWFence() {
            return newFence("Fence.w.w");
        }

        public static GenericVisibleEvent newWRWFence() {
            return newFence("Fence.w.rw");
        }

        public static GenericVisibleEvent newRWRFence() {
            return newFence("Fence.rw.r");
        }

        public static GenericVisibleEvent newRWWFence() {
            return newFence("Fence.rw.w");
        }

        public static GenericVisibleEvent newRWRWFence() {
            return newFence("Fence.rw.rw");
        }

        public static GenericVisibleEvent newTsoFence() {
            return newFence("Fence.tso");
        }

        public static GenericVisibleEvent newSynchronizeFence() {
            return newFence("Fence.i");
        }
    }

    // =============================================================================================
    // =========================================== Power ===========================================
    // =============================================================================================
    public static class Power {
        private Power() {
        }

        public static RMWStoreExclusive newRMWStoreConditional(Expression address, Expression value, boolean isStrong) {
            return new RMWStoreExclusive(address, value, isStrong, true);
        }

        public static GenericVisibleEvent newISyncBarrier() {
            return newFence(ISYNC);
        }

        public static GenericVisibleEvent newSyncBarrier() {
            return newFence(SYNC);
        }

        public static GenericVisibleEvent newLwSyncBarrier() {
            return newFence(LWSYNC);
        }
    }

    // =============================================================================================
    // ============================================ PTX ============================================
    // =============================================================================================
    public static class PTX {
        private PTX() {}

        public static PTXAtomOp newAtomOp(Expression address, Register register, Expression value,
                                          IntBinaryOp op, String mo, String scope) {
            // PTX (currently) only generates memory orders ACQ_REL and RLX for atom.
            PTXAtomOp atom = new PTXAtomOp(register, address, op, value, mo);
            atom.addTags(scope);
            return atom;
        }

        public static PTXAtomCAS newAtomCAS(Expression address, Register register, Expression expected,
                Expression value, String mo, String scope) {
            PTXAtomCAS atom = new PTXAtomCAS(register, address, expected, value, mo);
            atom.addTags(scope);
            return atom;
        }

        public static PTXAtomExch newAtomExch(Expression address, Register register,
                                            Expression value, String mo, String scope) {
            PTXAtomExch atom = new PTXAtomExch(register, address, value, mo);
            atom.addTags(scope);
            return atom;
        }

        public static PTXRedOp newRedOp(Expression address, Expression value,
                                        IntBinaryOp op, String mo, String scope) {
            // PTX (currently) only generates memory orders ACQ_REL and RLX for red.
            PTXRedOp red = new PTXRedOp(address, value, op, mo);
            red.addTags(scope);
            return red;
        }

        public static GenericVisibleEvent newAvDevice() {
            return new GenericVisibleEvent("avdevice", Tag.Vulkan.AVDEVICE);
        }
    
        public static GenericVisibleEvent newVisDevice() {
            return new GenericVisibleEvent("visdevice", Tag.Vulkan.VISDEVICE);
        }
    
    }

    // =============================================================================================
    // =========================================== Vulkan ==========================================
    // =============================================================================================
    public static class Vulkan {
        private Vulkan() {}

        public static VulkanRMW newRMW(Expression address, Register register, Expression value,
                                          String mo, String scope) {
            return new VulkanRMW(register, address, value, mo, scope);
        }

        public static VulkanRMWOp newRMWOp(Expression address, Register register, Expression value,
                                           IntBinaryOp op, String mo, String scope) {
            return new VulkanRMWOp(register, address, op, value, mo, scope);
        }

        public static VulkanRMWExtremum newRMWExtremum(Expression address, Register register, IntCmpOp op,
                                                       Expression value, String mo, String scope) {
            return new VulkanRMWExtremum(register, address, op, value, mo, scope);
        }

        public static VulkanCmpXchg newVulkanCmpXchg(Expression address, Register register, Expression expected,
                                                     Expression value, String mo, String scope) {
            return new VulkanCmpXchg(register, address, expected, value, mo, scope);
        }
    }

    // =============================================================================================
    // =========================================== Spir-V ==========================================
    // =============================================================================================

    public static class Spirv {
        private Spirv() {}

        public static SpirvLoad newSpirvLoad(Register register, Expression address, String scope,
                                             Set<String> tags) {
            return new SpirvLoad(register, address, scope, tags);
        }

        public static SpirvStore newSpirvStore(Expression address, Expression value, String scope,
                                               Set<String> tags) {
            return new SpirvStore(address, value, scope, tags);
        }

        public static SpirvXchg newSpirvXchg(Register register, Expression address, Expression value,
                                             String scope, Set<String> tags) {
            return new SpirvXchg(register, address, value, scope, tags);
        }

        public static SpirvRmw newSpirvRmw(Register register, Expression address, IntBinaryOp op, Expression value,
                                            String scope, Set<String> tags) {
            return new SpirvRmw(register, address, op, value, scope, tags);
        }

        public static SpirvCmpXchg newSpirvCmpXchg(Register register, Expression address, Expression cmp, Expression value,
                                                   String scope, Set<String> eqTags, Set<String> neqTags) {
            return new SpirvCmpXchg(register, address, cmp, value, scope, eqTags, neqTags);
        }

        public static SpirvRmwExtremum newSpirvRmwExtremum(Register register, Expression address, IntCmpOp op, Expression value,
                                                           String scope, Set<String> tags) {
            return new SpirvRmwExtremum(register, address, op, value, scope, tags);
        }
    }

    // =============================================================================================
    // =========================================== OpenCL ==========================================
    // =============================================================================================
    public static class OpenCL {
        private OpenCL() {}

        public static OpenCLInit newOpenCLInit(MemoryObject base, int offset) {
            final Expression address = offset == 0 ? base :
                    expressions.makeAdd(base, expressions.makeValue(offset, (IntegerType) base.getType()));
            return new OpenCLInit(base, offset, address);
        }

    }

}