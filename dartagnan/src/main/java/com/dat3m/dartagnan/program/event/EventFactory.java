package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.expression.BConst;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.expression.type.FunctionType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.Type;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.arch.StoreExclusive;
import com.dat3m.dartagnan.program.event.arch.lisa.LISARMW;
import com.dat3m.dartagnan.program.event.arch.ptx.PTXAtomCAS;
import com.dat3m.dartagnan.program.event.arch.ptx.PTXAtomExch;
import com.dat3m.dartagnan.program.event.arch.ptx.PTXAtomOp;
import com.dat3m.dartagnan.program.event.arch.ptx.PTXRedOp;
import com.dat3m.dartagnan.program.event.arch.tso.TSOXchg;
import com.dat3m.dartagnan.program.event.arch.vulkan.VulkanRMW;
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
import com.dat3m.dartagnan.program.event.lang.Alloc;
import com.dat3m.dartagnan.program.event.lang.catomic.*;
import com.dat3m.dartagnan.program.event.lang.linux.*;
import com.dat3m.dartagnan.program.event.lang.llvm.*;
import com.dat3m.dartagnan.program.event.lang.pthread.InitLock;
import com.dat3m.dartagnan.program.event.lang.pthread.Lock;
import com.dat3m.dartagnan.program.event.lang.pthread.Unlock;
import com.dat3m.dartagnan.program.event.lang.svcomp.*;
import com.dat3m.dartagnan.program.memory.MemoryObject;

import java.util.*;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.wmm.RelationNameRepository.*;

public class EventFactory {

    protected final ExpressionFactory expressions;

    protected EventFactory(ExpressionFactory e) {
        expressions = e;
    }

    protected EventFactory(EventFactory parent) {
        expressions = parent.expressions;
    }

    /**
     * Creates a new root factory.
     * @param expressionFactory
     * Builds expressions contained by events of the factory.
     * @return
     * A newly created instance.
     */
    public static EventFactory newInstance(ExpressionFactory expressionFactory) {
        return new EventFactory(expressionFactory);
    }

    public ExpressionFactory getExpressionFactory() {
        return expressions;
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

    public Alloc newAlloc(Register register, Type allocType, Expression arraySize, boolean isHeapAlloc) {
        return new Alloc(register, allocType, arraySize, isHeapAlloc);
    }

    public Load newLoad(Register register, Expression address) {
        return new Load(register, address);
    }

    public Load newLoadWithMo(Register register, Expression address, String mo) {
        Load load = newLoad(register, address);
        load.setMemoryOrder(mo);
        return load;
    }

    public Store newStore(Expression address, Expression value) {
        return new Store(address, value);
    }

    public Store newStoreWithMo(Expression address, Expression value, String mo) {
        Store store = newStore(address, value);
        store.setMemoryOrder(mo);
        return store;
    }

    public GenericVisibleEvent newFence(String name) {
        return new GenericVisibleEvent(name, name, Tag.FENCE);
    }

    public GenericVisibleEvent newFenceOpt(String name, String opt) {
        GenericVisibleEvent fence = newFence(name + "." + opt);
        fence.addTags(name);
        return fence;
    }

    public FenceWithId newFenceWithId(String name, Expression fenceId) {
        return new FenceWithId(name, fenceId);
    }

    public Init newInit(MemoryObject base, int offset) {
        //TODO: We simplify here because virtual aliasing currently fails when pointer arithmetic is involved
        // meaning that <addr> and <addr + 0> are treated differently.
        final Expression address = offset == 0 ? base :
                expressions.makeADD(base, expressions.makeValue(offset, base.getType()));
        return new Init(base, offset, address, expressions);
    }

    public ValueFunctionCall newValueFunctionCall(Register resultRegister, Function function, List<Expression> arguments) {
        return new ValueFunctionCall(resultRegister, function.getFunctionType(), function, arguments);
    }

    public ValueFunctionCall newValueFunctionCall(Register resultRegister, FunctionType funcType,
                                                         Expression funcPtr, List<Expression> arguments) {
        return new ValueFunctionCall(resultRegister, funcType, funcPtr, arguments);
    }

    public VoidFunctionCall newVoidFunctionCall(Function function, List<Expression> arguments) {
        return new VoidFunctionCall(function.getFunctionType(), function, arguments);
    }

    public VoidFunctionCall newVoidFunctionCall(FunctionType funcType, Expression funcPtr, List<Expression> arguments) {
        return new VoidFunctionCall(funcType, funcPtr, arguments);
    }

    public Return newFunctionReturn(Expression returnExpression) {
        return new Return(returnExpression);
    }

    public AbortIf newAbortIf(Expression condition) {
        return new AbortIf(condition);
    }

    // ------------------------------------------ Local events ------------------------------------------

    public Skip newSkip() {
        return new Skip();
    }

    public FunCallMarker newFunctionCallMarker(String funName) {
        return new FunCallMarker(funName);
    }

    public FunReturnMarker newFunctionReturnMarker(String funName) {
        return new FunReturnMarker(funName);
    }

    public StringAnnotation newStringAnnotation(String annotation) {
        return new StringAnnotation(annotation);
    }

    public Local newLocal(Register register, Expression expr) {
        return new Local(register, expr);
    }

    public Label newLabel(String name) {
        return new Label(name);
    }

    public CondJump newJump(Expression cond, Label target) {
        return new CondJump(cond, target);
    }

    public CondJump newJumpUnless(Expression cond, Label target) {
        if (cond instanceof BConst constant && !constant.getValue()) {
            return newGoto(target);
        }
        return new CondJump(expressions.makeNot(cond), target);
    }

    public IfAsJump newIfJump(Expression expr, Label label, Label end) {
        return new IfAsJump(expr, label, end);
    }

    public IfAsJump newIfJumpUnless(Expression expr, Label label, Label end) {
        return newIfJump(expressions.makeNot(expr), label, end);
    }

    public CondJump newGoto(Label target) {
        return newJump(expressions.makeTrue(), target);
    }

    public CondJump newFakeCtrlDep(Register reg, Label target) {
        CondJump jump = newJump(expressions.makeEQ(reg, reg), target);
        jump.addTags(Tag.NOOPT);
        return jump;
    }

    public Assume newAssume(Expression expr) {
        return new Assume(expr);
    }

    public Assert newAssert(Expression expr, String errorMessage) {
        return new Assert(expr, errorMessage);
    }

    // ------------------------------------------ RMW events ------------------------------------------

    public Load newRMWLoad(Register reg, Expression address) {
        Load load = newLoad(reg, address);
        load.addTags(Tag.RMW);
        return load;
    }

    public Load newRMWLoadWithMo(Register reg, Expression address, String mo) {
        Load load = newLoadWithMo(reg, address, mo);
        load.addTags(Tag.RMW);
        return load;
    }

    public RMWStore newRMWStore(Load loadEvent, Expression address, Expression value) {
        return new RMWStore(loadEvent, address, value);
    }

    public RMWStore newRMWStoreWithMo(Load loadEvent, Expression address, Expression value, String mo) {
        RMWStore store = newRMWStore(loadEvent, address, value);
        store.setMemoryOrder(mo);
        return store;
    }

    public Load newRMWLoadExclusive(Register reg, Expression address) {
        Load load = newLoad(reg, address);
        load.addTags(Tag.RMW, Tag.EXCL);
        return load;
    }

    public Load newRMWLoadExclusiveWithMo(Register reg, Expression address, String mo) {
        Load load = newRMWLoadExclusive(reg, address);
        load.setMemoryOrder(mo);
        return load;
    }

    public RMWStoreExclusive newRMWStoreExclusive(Expression address, Expression value, boolean isStrong) {
        return new RMWStoreExclusive(address, value, isStrong, false);
    }

    public RMWStoreExclusive newRMWStoreExclusiveWithMo(Expression address, Expression value, boolean isStrong, String mo) {
        RMWStoreExclusive store = newRMWStoreExclusive(address, value, isStrong);
        store.setMemoryOrder(mo);
        return store;
    }

    public ExecutionStatus newExecutionStatus(Register register, Event event) {
        return new ExecutionStatus(register, event, false);
    }

    public ExecutionStatus newExecutionStatusWithDependencyTracking(Register register, Event event) {
        return new ExecutionStatus(register, event, true);
    }

    // ------------------------------------------ Threading events ------------------------------------------

    public ThreadCreate newThreadCreate(List<Expression> arguments) {
        return new ThreadCreate(arguments);
    }

    public ThreadArgument newThreadArgument(Register resultReg, ThreadCreate creator, int argIndex) {
        return new ThreadArgument(resultReg, creator, argIndex);
    }

    public ThreadStart newThreadStart(ThreadCreate creator) {
        return new ThreadStart(creator);
    }

    // =============================================================================================
    // ========================================== Common ===========================================
    // =============================================================================================

    public Common withCommon() {
        return new Common(this);
    }

    /*
        "Common" contains events that are shared between different architectures, yet are no core events.
     */
    public static final class Common extends EventFactory {

        private Common(EventFactory original) { super(original); }

        public StoreExclusive newExclusiveStore(Register register, Expression address, Expression value, String mo) {
            return new StoreExclusive(register, address, value, mo);
        }
    }

    // =============================================================================================
    // ========================================== Pthread ==========================================
    // =============================================================================================

    public Pthread withPthread() {
        return new Pthread(this);
    }

    public static final class Pthread extends EventFactory {

        private Pthread(EventFactory original) { super(original); }

        public InitLock newInitLock(String name, Expression address, Expression ignoreAttributes) {
            //TODO store attributes inside mutex object
            return new InitLock(name, address, expressions.makeZero(TypeFactory.getInstance().getArchType()));
        }

        public Lock newLock(String name, Expression address) {
            return new Lock(name, address, expressions.makeOne(TypeFactory.getInstance().getArchType()));
        }

        public Unlock newUnlock(String name, Expression address) {
            return new Unlock(name, address, expressions.makeZero(TypeFactory.getInstance().getArchType()));
        }
    }

    // =============================================================================================
    // ========================================== Atomics ==========================================
    // =============================================================================================

    public Atomic withAtomic() {
        return new Atomic(this);
    }

    public static final class Atomic extends EventFactory {

        private Atomic(EventFactory original) { super(original); }

        public AtomicCmpXchg newCompareExchange(Register register, Expression address, Expression expectedAddr,
                Expression desiredValue, String mo, boolean isStrong) {
            return new AtomicCmpXchg(register, address, expectedAddr, desiredValue, mo, isStrong);
        }

        public AtomicCmpXchg newCompareExchange(Register register, Expression address, Expression expectedAddr,
                Expression desiredValue, String mo) {
            return newCompareExchange(register, address, expectedAddr, desiredValue, mo, false);
        }

        public AtomicFetchOp newFetchOp(Register register, Expression address, Expression value, IOpBin op, String mo) {
            return new AtomicFetchOp(register, address, op, value, mo);
        }

        public AtomicFetchOp newFADD(Register register, Expression address, Expression value, String mo) {
            return newFetchOp(register, address, value, IOpBin.ADD, mo);
        }

        public AtomicFetchOp newIncrement(Register register, Expression address, String mo) {
            if (!(register.getType() instanceof IntegerType integerType)) {
                throw new IllegalArgumentException(String.format("Non-integer type %s for increment operation.",
                        register.getType()));
            }
            return newFetchOp(register, address, expressions.makeOne(integerType), IOpBin.ADD, mo);
        }

        public AtomicLoad newLoad(Register register, Expression address, String mo) {
            return new AtomicLoad(register, address, mo);
        }

        public AtomicStore newStore(Expression address, Expression value, String mo) {
            return new AtomicStore(address, value, mo);
        }

        public AtomicThreadFence newAtomicFence(String mo) {
            return new AtomicThreadFence(mo);
        }

        public AtomicXchg newExchange(Register register, Expression address, Expression value, String mo) {
            return new AtomicXchg(register, address, value, mo);
        }
    }

    // =============================================================================================
    // =========================================== LLVM ============================================
    // =============================================================================================

    public Llvm withLlvm() {
        return new Llvm(this);
    }

    public static final class Llvm extends EventFactory {

        private Llvm(EventFactory original) { super(original); }

        public LlvmLoad newLoad(Register register, Expression address, String mo) {
            return new LlvmLoad(register, address, mo);
        }

        public LlvmStore newStore(Expression address, Expression value, String mo) {
            return new LlvmStore(address, value, mo);
        }

        public LlvmXchg newExchange(Register register, Expression address, Expression value, String mo) {
            return new LlvmXchg(register, address, value, mo);
        }

        public LlvmCmpXchg newCompareExchange(Register oldValueRegister, Register cmpRegister, Expression address,
                Expression expectedAddr, Expression desiredValue, String mo, boolean isStrong) {
            return new LlvmCmpXchg(oldValueRegister, cmpRegister, address, expectedAddr, desiredValue, mo, isStrong);
        }

        public LlvmCmpXchg newCompareExchange(Register oldValueRegister, Register cmpRegister, Expression address,
                Expression expectedAddr, Expression desiredValue, String mo) {
            return newCompareExchange(oldValueRegister, cmpRegister, address, expectedAddr, desiredValue, mo, false);
        }

        public LlvmRMW newRMW(Register register, Expression address, Expression value, IOpBin op, String mo) {
            return new LlvmRMW(register, address, op, value, mo);
        }

        public LlvmFence newLlvmFence(String mo) {
            return new LlvmFence(mo);
        }

    }

    // =============================================================================================
    // ========================================== Svcomp ===========================================
    // =============================================================================================

    public Svcomp getSvcomp() {
        return new Svcomp(this);
    }

    public static final class Svcomp extends EventFactory {

        private Svcomp(EventFactory original) { super(original); }

        public BeginAtomic newBeginAtomic() {
            return new BeginAtomic();
        }

        public EndAtomic newEndAtomic(BeginAtomic begin) {
            return new EndAtomic(begin);
        }

        public LoopBegin newLoopBegin() {
            return new LoopBegin();
        }

        public SpinStart newSpinStart() {
            return new SpinStart();
        }

        public SpinEnd newSpinEnd() {
            return new SpinEnd();
        }

        public LoopBound newLoopBound(Expression bound) {
            return new LoopBound(bound);
        }
    }

    // =============================================================================================
    // ============================================ ARM ============================================
    // =============================================================================================

    public AArch64 withAArch64() {
        return new AArch64(this);
    }

    public static final class AArch64 extends EventFactory {

        private AArch64(EventFactory original) { super(original); }

        public enum Option {
            //System domain
            SY, LD, ST, //Outer shareable domain
            OSH, OSHLD, OSHST, //Inner shareable domain
            ISH, ISHLD, ISHST, //Non-shareable domain
            NSH, NSHLD, NSHST,
        }

        public GenericVisibleEvent newDataMemoryBarrier(Option option) {
            return newFence("DMB." + option);
        }

        public GenericVisibleEvent newDataSynchronizationBarrier(Option option) {
            return newFence("DSB." + option);
        }

    }

    // =============================================================================================
    // =========================================== Linux ===========================================
    // =============================================================================================

    public Linux withLinux() {
        return new Linux(this);
    }

    public static final class Linux extends EventFactory {

        private Linux(EventFactory original) { super(original); }

        public LKMMLoad newLKMMLoad(Register reg, Expression address, String mo) {
            return new LKMMLoad(reg, address, mo);
        }

        public LKMMStore newLKMMStore(Expression address, Expression value, String mo) {
            return new LKMMStore(address, value, mo);
        }

        public LKMMAddUnless newRMWAddUnless(Expression address, Register register, Expression cmp, Expression value) {
            return new LKMMAddUnless(register, address, value, cmp);
        }

        public LKMMCmpXchg newRMWCompareExchange(Expression address, Register register, Expression cmp, Expression value, String mo) {
            return new LKMMCmpXchg(register, address, cmp, value, mo);
        }

        public LKMMFetchOp newRMWFetchOp(Expression address, Register register, Expression value, IOpBin op, String mo) {
            return new LKMMFetchOp(register, address, op, value, mo);
        }

        public LKMMOpNoReturn newRMWOp(Expression address, Expression value, IOpBin op) {
            return new LKMMOpNoReturn(address, op, value);
        }

        public LKMMOpAndTest newRMWOpAndTest(Expression address, Register register, Expression value, IOpBin op) {
            return new LKMMOpAndTest(register, address, op, value);
        }

        public LKMMOpReturn newRMWOpReturn(Expression address, Register register, Expression value, IOpBin op, String mo) {
            return new LKMMOpReturn(register, address, op, value, mo);
        }

        public LKMMXchg newRMWExchange(Expression address, Register register, Expression value, String mo) {
            return new LKMMXchg(register, address, value, mo);
        }

        public LKMMFence newMemoryBarrier() {
            return new LKMMFence(Tag.Linux.MO_MB);
        }

        public LKMMFence newLKMMFence(String name) {
            return new LKMMFence(name);
        }

        public LKMMLock newLock(Expression address) {
            return new LKMMLock(address);
        }

        public LKMMUnlock newUnlock(Expression address) {
            return new LKMMUnlock(address, expressions.makeZero(TypeFactory.getInstance().getIntegerType(32)));
        }

        public GenericMemoryEvent newSrcuSync(Expression address) {
            //TODO maybe a void type would be fine here
            GenericMemoryEvent srcuSync = new GenericMemoryEvent(address, "synchronize_srcu");
            srcuSync.addTags(Tag.Linux.SRCU_SYNC);
            return srcuSync;
        }

    }

    // =============================================================================================
    // ============================================ X86 ============================================
    // =============================================================================================

    public X86 withX86() {
        return new X86(this);
    }

    public static final class X86 extends EventFactory {

        private X86(EventFactory original) { super(original); }

        public TSOXchg newExchange(MemoryObject address, Register register) {
            return new TSOXchg(address, register);
        }

        public GenericVisibleEvent newMemoryFence() {
            return newFence(MFENCE);
        }
    }

    // =============================================================================================
    // =========================================== RISCV ===========================================
    // =============================================================================================

    public RISCV withRISCV() {
        return new RISCV(this);
    }

    public static final class RISCV extends EventFactory {

        private RISCV(EventFactory original) { super(original); }

        public RMWStoreExclusive newRMWStoreConditional(Expression address, Expression value, String mo, boolean isStrong) {
            RMWStoreExclusive store = new RMWStoreExclusive(address, value, isStrong, true);
            store.addTags(Tag.RISCV.STCOND);
            store.setMemoryOrder(mo);
            return store;
        }

        public RMWStoreExclusive newRMWStoreConditional(Expression address, Expression value, String mo) {
            return newRMWStoreConditional(address, value, mo, false);
        }

        public GenericVisibleEvent newRRFence() {
            return newFence("Fence.r.r");
        }

        public GenericVisibleEvent newRWFence() {
            return newFence("Fence.r.w");
        }

        public GenericVisibleEvent newRRWFence() {
            return newFence("Fence.r.rw");
        }

        public GenericVisibleEvent newWRFence() {
            return newFence("Fence.w.r");
        }

        public GenericVisibleEvent newWWFence() {
            return newFence("Fence.w.w");
        }

        public GenericVisibleEvent newWRWFence() {
            return newFence("Fence.w.rw");
        }

        public GenericVisibleEvent newRWRFence() {
            return newFence("Fence.rw.r");
        }

        public GenericVisibleEvent newRWWFence() {
            return newFence("Fence.rw.w");
        }

        public GenericVisibleEvent newRWRWFence() {
            return newFence("Fence.rw.rw");
        }

        public GenericVisibleEvent newTsoFence() {
            return newFence("Fence.tso");
        }

        public GenericVisibleEvent newSynchronizeFence() {
            return newFence("Fence.i");
        }
    }

    // =============================================================================================
    // =========================================== LISA ============================================
    // =============================================================================================
    public LISA withLISA() {
        return new LISA(this);
    }

    public static final class LISA extends EventFactory {

        private LISA(EventFactory original) { super(original); }

        public LISARMW newRMW(Expression address, Register register, Expression value, String mo) {
            return new LISARMW(register, address, value, mo);
        }
    }


    // =============================================================================================
    // =========================================== Power ===========================================
    // =============================================================================================

    public Power withPower() {
        return new Power(this);
    }

    public static final class Power extends EventFactory {

        private Power(EventFactory original) { super(original); }

        public RMWStoreExclusive newRMWStoreConditional(Expression address, Expression value, boolean isStrong) {
            return new RMWStoreExclusive(address, value, isStrong, true);
        }

        public GenericVisibleEvent newISyncBarrier() {
            return newFence(ISYNC);
        }

        public GenericVisibleEvent newSyncBarrier() {
            return newFence(SYNC);
        }

        public GenericVisibleEvent newLwSyncBarrier() {
            return newFence(LWSYNC);
        }
    }

    // =============================================================================================
    // ============================================ PTX ============================================
    // =============================================================================================

    public PTX withPTX() {
        return new PTX(this);
    }

    public static final class PTX extends EventFactory {

        private PTX(EventFactory original) { super(original); }

        public PTXAtomOp newAtomOp(Expression address, Register register, Expression value, IOpBin op, String mo,
                String scope) {
            // PTX (currently) only generates memory orders ACQ_REL and RLX for atom.
            PTXAtomOp atom = new PTXAtomOp(register, address, op, value, mo);
            atom.addTags(scope);
            return atom;
        }

        public PTXAtomCAS newAtomCAS(Expression address, Register register, Expression expected,
                Expression value, String mo, String scope) {
            PTXAtomCAS atom = new PTXAtomCAS(register, address, expected, value, mo);
            atom.addTags(scope);
            return atom;
        }

        public PTXAtomExch newAtomExch(Expression address, Register register, Expression value, String mo,
                String scope) {
            PTXAtomExch atom = new PTXAtomExch(register, address, value, mo);
            atom.addTags(scope);
            return atom;
        }

        public PTXRedOp newRedOp(Expression address, Expression value, IOpBin op, String mo, String scope) {
            // PTX (currently) only generates memory orders ACQ_REL and RLX for red.
            PTXRedOp red = new PTXRedOp(address, value, op, mo);
            red.addTags(scope);
            return red;
        }

        public GenericVisibleEvent newAvDevice() {
            return new GenericVisibleEvent("avdevice", Tag.Vulkan.AVDEVICE);
        }

        public GenericVisibleEvent newVisDevice() {
            return new GenericVisibleEvent("visdevice", Tag.Vulkan.VISDEVICE);
        }

    }

    // =============================================================================================
    // =========================================== Vulkan ==========================================
    // =============================================================================================

    public Vulkan withVulkan() {
        return new Vulkan(this);
    }

    public static final class Vulkan extends EventFactory {

        private Vulkan(EventFactory original) { super(original); }

        public VulkanRMW newRMW(Expression address, Register register, Expression value, String mo, String scope) {
            return new VulkanRMW(register, address, value, mo, scope);
        }

        public VulkanRMWOp newRMWOp(Expression address, Register register, Expression value, IOpBin op, String mo,
                String scope) {
            return new VulkanRMWOp(register, address, op, value, mo, scope);
        }

        public GenericVisibleEvent newAvDevice() {
            return new GenericVisibleEvent("avdevice", Tag.Vulkan.AVDEVICE);
        }

        public GenericVisibleEvent newVisDevice() {
            return new GenericVisibleEvent("visdevice", Tag.Vulkan.VISDEVICE);
        }
    }

}