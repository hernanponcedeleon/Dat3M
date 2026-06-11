package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.booleans.BoolLiteral;
import com.dat3m.dartagnan.expression.integers.IntBinaryOp;
import com.dat3m.dartagnan.expression.integers.IntUnaryExpr;
import com.dat3m.dartagnan.expression.type.FunctionType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.arch.*;
import com.dat3m.dartagnan.program.event.arch.ptx.*;
import com.dat3m.dartagnan.program.event.arch.tso.*;
import com.dat3m.dartagnan.program.event.arch.vulkan.*;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.core.annotations.*;
import com.dat3m.dartagnan.program.event.core.special.*;
import com.dat3m.dartagnan.program.event.core.threading.*;
import com.dat3m.dartagnan.program.event.functions.*;
import com.dat3m.dartagnan.program.event.lang.catomic.*;
import com.dat3m.dartagnan.program.event.lang.dat3m.*;
import com.dat3m.dartagnan.program.event.lang.linux.*;
import com.dat3m.dartagnan.program.event.lang.llvm.*;
import com.dat3m.dartagnan.program.event.lang.spirv.*;
import com.dat3m.dartagnan.program.event.lang.svcomp.*;
import com.dat3m.dartagnan.program.event.metadata.CustomPrinting;
import com.dat3m.dartagnan.program.memory.MemoryObject;

import java.util.*;
import java.util.stream.Collectors;

import static com.google.common.base.Preconditions.checkArgument;

public class EventFactory {

    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();
    private static final TypeFactory types = TypeFactory.getInstance();

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
        eventSequenceInternal(Arrays.asList(events), retVal);
        return retVal;
    }

    private static void eventSequenceInternal(Iterable<?> iterable, List<Event> collector) {
        for (Object obj : iterable) {
            if (obj == null) {
                continue;
            }
            if (obj instanceof Event) {
                collector.add((Event) obj);
            } else if (obj instanceof Iterable<?> iter) {
                eventSequenceInternal(iter, collector);
            } else {
                throw new IllegalArgumentException("Cannot parse " + obj.getClass() + " as event.");
            }
        }
    }

    public static Event newTerminator(Function function, Expression guard, String... tags) {
        final Event terminator = function instanceof Thread thread ?
                EventFactory.newJump(guard, (Label) thread.getExit()) :
                EventFactory.newAbortIf(guard);
        terminator.addTags(tags);
        return terminator;
    }

    public static Event newTerminator(Function function, String... tags) {
        return newTerminator(function, ExpressionFactory.getInstance().makeTrue(), tags);
    }


    // =============================================================================================
    // ======================================= DAT3m events ========================================
    // =============================================================================================

    // ------------------------------------------ Memory events ------------------------------------------

    public static Alloc newAlloc(Register register, Type allocType, Expression arraySize,
                                 boolean isHeapAlloc, boolean doesZeroOutMemory) {
        final Expression defaultAlignment = expressions.makeValue(8, types.getArchType());
        return newAlignedAlloc(register, allocType, arraySize, defaultAlignment, isHeapAlloc, doesZeroOutMemory);
    }

    public static Alloc newAlignedAlloc(Register register, Type allocType, Expression arraySize, Expression alignment,
                                 boolean isHeapAlloc, boolean doesZeroOutMemory) {
        arraySize = expressions.makeCast(arraySize, types.getArchType(), false);
        alignment = expressions.makeCast(alignment, types.getArchType(), false);
        return new Alloc(register, allocType, arraySize, alignment, isHeapAlloc, doesZeroOutMemory);
    }

    public static Dealloc newDealloc(Expression address) {
        // Accesses zero bytes to avoid Tearing.
        return new Dealloc(address, types.getUnitType());
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

    public static ControlBarrier newControlBarrier(String name, String instanceId, String execScope) {
        return new ControlBarrier(name, instanceId, execScope);
    }

    public static NamedBarrier newNamedBarrier(String name, String instanceId, String execScope, Expression id, Expression quorum) {
        return new NamedBarrier(name, instanceId, execScope, id, quorum);
    }

    public static Init newInit(MemoryObject base, int offset) {
        //TODO: We simplify here because virtual aliasing currently fails when pointer arithmetic is involved
        // meaning that <addr> and <addr + 0> are treated differently.
        final Expression address = offset == 0 ? base :
                expressions.makeAdd(base, expressions.makeValue(offset, (IntegerType) base.getType()));
        final Init init = new Init(base, offset, address);
        init.addTags(base.getFeatureTags());
        return init;
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

    public static GenericVisibleEvent newUnreachable() {
        return new GenericVisibleEvent("Unreachable", Tag.UB);
    }

    // ------------------------------------------ Local events ------------------------------------------

    // TODO: Unused, but "new Skip()" calls are used in several unit tests
    //  Generally, this event is pointless and could be deleted entirely
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

    public static InstructionBoundary newInstructionBegin() {
        return new InstructionBoundary(null, null);
    }

    public static InstructionBoundary newInstructionEnd(InstructionBoundary begin) {
        return new InstructionBoundary(null, begin);
    }

    public static Local newLocal(Register register, Expression expr) {
        return new Local(register, expr);
    }

    public static NonDetChoice newNonDetChoice(Register register) {
        return new NonDetChoice(register, false);
    }

    public static NonDetChoice newSignedNonDetChoice(Register register, boolean isSigned) {
        return new NonDetChoice(register, isSigned);
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

    public static List<Event> newFakeCtrlDep(Register reg) {
        final Label label = newLabel("FakeDep");
        CondJump jump = newJump(expressions.makeEQ(reg, reg), label);
        jump.addTags(Tag.NOOPT);
        return List.of(jump, label);
    }

    public static Assume newAssume(Expression expr) {
        return new Assume(expr);
    }

    public static Assert newAssert(Expression expr, String errorMessage) {
        return new Assert(expr, errorMessage);
    }

    public static LoopBound newLoopBound(Expression bound) {
        return new LoopBound(bound);
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

    public static RMWStoreExclusive newRMWStoreExclusive(Expression address, Expression value, boolean isStrong,
            boolean requiresMatchingAddresses) {
        return new RMWStoreExclusive(address, value, isStrong, requiresMatchingAddresses);
    }

    public static RMWStoreExclusive newRMWStoreExclusiveWithMo(Expression address, Expression value, boolean isStrong,
            boolean requiresMatchingAddresses, String mo) {
        final RMWStoreExclusive store = newRMWStoreExclusive(address, value, isStrong, requiresMatchingAddresses);
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

    public static DynamicThreadCreate newDynamicThreadCreate(Register tidRegister, FunctionType funcType, Expression functionPtr, List<Expression> arguments) {
        return new DynamicThreadCreate(tidRegister, funcType, functionPtr, arguments);
    }

    public static DynamicThreadJoin newDynamicThreadJoin(Register resultRegister, Expression tidExpr) {
        return new DynamicThreadJoin(resultRegister, tidExpr);
    }

    public static DynamicThreadDetach newDynamicThreadDetach(Register statusReg, Expression tidExpr) {
        return new DynamicThreadDetach(statusReg, tidExpr);
    }

    public static DynamicThreadLocalCreate newDynamicThreadLocalCreate(Register key, Expression destructor) {
        return new DynamicThreadLocalCreate(key, destructor);
    }

    public static DynamicThreadLocalDelete newDynamicThreadLocalDelete(Expression key) {
        return new DynamicThreadLocalDelete(key);
    }

    public static DynamicThreadLocalGet newDynamicThreadLocalGet(Register value, Expression key) {
        return new DynamicThreadLocalGet(value, key);
    }

    public static DynamicThreadLocalSet newDynamicThreadLocalSet(Expression key, Expression value) {
        return new DynamicThreadLocalSet(key, value);
    }

    public static ThreadCreate newThreadCreate(List<Expression> arguments) {
        return new ThreadCreate(arguments);
    }

    public static ThreadJoin newThreadJoin(Register resultRegister, Thread thread) {
        return new ThreadJoin(resultRegister, thread);
    }

    public static ThreadArgument newThreadArgument(Register resultReg, ThreadCreate creator, int argIndex) {
        return new ThreadArgument(resultReg, creator, argIndex);
    }

    public static ThreadStart newThreadStart(ThreadCreate creator) {
        return new ThreadStart(creator);
    }

    public static ThreadReturn newThreadReturn(Expression value) {
        return new ThreadReturn(value);
    }

    public static class Special {
        private Special() {
        }


        public static StateSnapshot newStateSnapshot(List<? extends Expression> expressions) {
            return new StateSnapshot(expressions);
        }
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

        public static Xchg newXchg(Register register, Expression address, Expression storeValue) {
            return new Xchg(register, address, storeValue);
        }

        public static CAS newCAS(Register srcReg, Expression address, Expression cmpVal, Expression storeValue) {
            return new CAS(srcReg, address, cmpVal, storeValue);
        }

        public static RMWFetchOp newRmwFetchOp(Register resultReg, Expression address, IntBinaryOp op, Expression operand) {
            return new RMWFetchOp(resultReg, address, op, operand);
        }

        public static RMWOp newRmwOp(Expression address, IntBinaryOp op, Expression operand) {
            return new RMWOp(address, op, operand);
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

        public static AtomicOp newRMWOp(Expression address, Expression value, IntBinaryOp op, String mo) {
            return new AtomicOp(address, op, value, mo);
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

        public static LlvmCmpXchg newCompareExchange(Register oldValueAndSuccess, Expression address,
                Expression expected, Expression newValue, String mo, boolean strong) {
            return new LlvmCmpXchg(oldValueAndSuccess, address, expected, newValue, mo, strong);
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
    }

    // =============================================================================================
    // ============================================ ARM ============================================
    // =============================================================================================

    public static class AArch64 {
        private AArch64() {
        }

        public enum MemoryOrder {
            PLAIN, ACQUIRE, RELEASE, ACQ_REL
        }

        public static Event newLoad(Register value, Expression address, MemoryOrder mo) {
            return EventFactory.newLoadWithMo(value, address, toAcqTag(mo));
        }

        public static Event newStore(Expression address, Expression value, MemoryOrder mo) {
            return EventFactory.newStoreWithMo(address, value, toRelTag(mo));
        }

        public static Event newLoadExclusive(Register value, Expression address, MemoryOrder mo) {
            return EventFactory.newRMWLoadExclusiveWithMo(value, address, toAcqTag(mo));
        }

        public static Event newStoreExclusive(Register status, Expression address, Expression value, MemoryOrder mo) {
            return EventFactory.Common.newExclusiveStore(status, address, value, toRelTag(mo));
        }

        public static Event newLoadOp(Register register, Expression address, IntBinaryOp operator, Expression operand,
                MemoryOrder mo) {
            final Event ld = EventFactory.Common.newRmwFetchOp(register, address, operator, operand);
            ld.addTags(toAcqTag(mo), toRelTag(mo));
            ld.setMetadata(LDOP_PRINTING);
            return ld;
        }

        public static Event newStoreOp(Expression address, IntBinaryOp operator, Expression operand, MemoryOrder mo) {
            checkArgument(mo.equals(MemoryOrder.PLAIN) || mo.equals(MemoryOrder.RELEASE),
                    "Invalid memory order '%s' for newStoreOp", mo);
            final Event st = EventFactory.Common.newRmwOp(address, operator, operand);
            st.addTags(toRelTag(mo));
            st.setMetadata(STOP_PRINTING);
            return st;
        }

        public static Event newSwap(Register register, Expression address, Expression value, MemoryOrder mo) {
            final Event swp = EventFactory.Common.newXchg(register, address, value);
            swp.addTags(toAcqTag(mo), toRelTag(mo));
            swp.setMetadata(SWP_PRINTING);
            return swp;
        }

        public static Event newCas(Register register, Expression address, Expression expected, Expression desired,
                MemoryOrder mo) {
            final Event cas = EventFactory.Common.newCAS(register, address, expected, desired);
            cas.addTags(toAcqTag(mo), toRelTag(mo));
            cas.setMetadata(CAS_PRINTING);
            return cas;
        }

        public static GenericVisibleEvent newBarrier(String type, String option) {
            final String typeUpper = type.toUpperCase();
            final String optionUpper = option.toUpperCase();
            checkArgument(BARRIER_TYPE.contains(typeUpper), "Unknown barrier type '%s'.", type);
            checkArgument(BARRIER_OPT.contains(optionUpper), "Unknown barrier option '%s'.", option);
            final String name = "%s.%s".formatted(typeUpper, optionUpper);
            return new GenericVisibleEvent(name, name, Tag.FENCE, typeUpper);
        }

        private static final Set<String> BARRIER_TYPE = Set.of("DMB", "DSB", "ISB");

        private static final Set<String> BARRIER_OPT = Set.of(
                "SY", "LD", "ST", "ISH", "ISHLD", "ISHST", "OSH", "OSHLD", "OSHST", "NSH", "NSHLD", "NSHST"
        );

        private static String toAcqTag(MemoryOrder mo) {
            return switch (mo) {
                case ACQUIRE, ACQ_REL -> Tag.ARMv8.MO_ACQ;
                default -> "";
            };
        }

        private static String toRelTag(MemoryOrder mo) {
            return switch (mo) {
                case RELEASE, ACQ_REL -> Tag.ARMv8.MO_REL;
                default -> "";
            };
        }

        private static final CustomPrinting LDOP_PRINTING = e -> {
            if (!(e instanceof RMWFetchOp ldop)) {
                return Optional.empty();
            }
            final String acq = ldop.hasTag(Tag.ARMv8.MO_ACQ) ? "A" : "";
            final String rel = ldop.hasTag(Tag.ARMv8.MO_REL) ? "L" : "";
            final String op = opToArmOpCode(ldop.getOperator());
            final String size = getArmSizeSuffix(ldop.getAccessType());
            final Expression operand = ldop.getOperand() instanceof IntUnaryExpr x ? x.getOperand() : ldop.getOperand();
            final Register loadReg = ldop.getResultRegister();
            final Expression address = ldop.getAddress();
            return Optional.of("LD%s%s%s%s %s, %s, [%s]".formatted(op, acq, rel, size, loadReg, operand, address));
        };

        private static final CustomPrinting STOP_PRINTING = e -> {
            if (!(e instanceof RMWOp stop)) {
                return Optional.empty();
            }
            final String rel = stop.hasTag(Tag.ARMv8.MO_REL) ? "L" : "";
            final String op = opToArmOpCode(stop.getOperator());
            final String size = getArmSizeSuffix(stop.getAccessType());
            final Expression operand = stop.getOperand() instanceof IntUnaryExpr x ? x.getOperand() : stop.getOperand();
            final Expression address = stop.getAddress();
            return Optional.of("ST%s%s%s %s, [%s]".formatted(op, rel, size, operand, address));
        };

        private static final CustomPrinting SWP_PRINTING = e -> {
            if (!(e instanceof Xchg xchg)) {
                return Optional.empty();
            }
            final String acq = xchg.hasTag(Tag.ARMv8.MO_ACQ) ? "A" : "";
            final String rel = xchg.hasTag(Tag.ARMv8.MO_REL) ? "L" : "";
            final String size = getArmSizeSuffix(xchg.getAccessType());
            final Expression value = xchg.getValue();
            final Register loadReg = xchg.getResultRegister();
            final Expression address = xchg.getAddress();
            return Optional.of("SWP%s%s%s %s, %s, [%s]".formatted(acq, rel, size, value, loadReg, address));
        };

        private static final CustomPrinting CAS_PRINTING = e -> {
            if (!(e instanceof CAS cas)) {
                return Optional.empty();
            }
            final String acq = cas.hasTag(Tag.ARMv8.MO_ACQ) ? "A" : "";
            final String rel = cas.hasTag(Tag.ARMv8.MO_REL) ? "L" : "";
            final String size = getArmSizeSuffix(cas.getAccessType());
            final Expression value = cas.getStoreValue();
            final Register loadReg = cas.getResultRegister();
            final Expression address = cas.getAddress();
            return Optional.of("CAS%s%s%s %s, %s, [%s]".formatted(acq, rel, size, loadReg, value, address));
        };

        private static String opToArmOpCode(IntBinaryOp op) {
            return switch (op) {
                case ADD -> "ADD";
                case XOR -> "EOR";
                case OR -> "SET";
                case AND -> "CLR";
                case SMIN -> "SMIN";
                case SMAX -> "SMAX";
                case UMIN -> "UMIN";
                case UMAX -> "UMAX";
                default -> throw new RuntimeException("Invalid op: " + op);
            };
        }

        private static String getArmSizeSuffix(Type type) {
            return switch (((IntegerType) type).getBitWidth()) {
                case 16 -> "H";
                case 8 -> "B";
                default -> "";
            };
        }
    }

    // =============================================================================================
    // =========================================== Linux ===========================================
    // =============================================================================================
    public static class Linux {
        private Linux() {
        }

        public static LKMMLoad newLoad(Register reg, Expression address, String mo) {
            return new LKMMLoad(reg, address, mo);
        }

        public static LKMMStore newStore(Expression address, Expression value, String mo) {
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

        public static LKMMFence newBarrier(String name) {
            return new LKMMFence(name);
        }

        public static LKMMLock newLock(Expression address) {
            return new LKMMLock(address);
        }

        public static LKMMUnlock newUnlock(Expression address) {
            return new LKMMUnlock(address);
        }

        public static GenericMemoryEvent newSrcuSync(Expression address) {
            // Accesses zero bytes to avoid tearing.
            GenericMemoryEvent srcuSync = new GenericMemoryEvent(address, types.getUnitType(), "synchronize_srcu");
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

        public static Event newMemoryFence(String type) {
            final String name = switch (type) {
                case "mfence" -> type;
                case "lfence", "sfence" -> throw new UnsupportedOperationException("X86 fence '%s'.".formatted(type));
                default -> throw new IllegalArgumentException("Invalid X86 fence '%s'".formatted(type));
            };
            return newFence(name);
        }
    }


    // =============================================================================================
    // =========================================== RISCV ===========================================
    // =============================================================================================
    public static class RISCV {
        private RISCV() {
        }

        public enum MemoryOrder {
            PLAIN, ACQUIRE, RELEASE, ACQ_REL
        }

        public static Event newLoad(Register value, Expression address, MemoryOrder mo) {
            return EventFactory.newLoadWithMo(value, address, toTag(mo));
        }

        public static Event newStore(Expression address, Expression value, MemoryOrder mo) {
            return EventFactory.newStoreWithMo(address, value, toTag(mo));
        }

        public static Event newLoadReserve(Register value, Expression address, MemoryOrder mo) {
            return EventFactory.newRMWLoadExclusiveWithMo(value, address, toTag(mo));
        }

        public static Event newStoreConditional(Register status, Expression address, Expression value, MemoryOrder mo) {
            return Common.newExclusiveStore(status, address, value, toTag(mo));
        }

        public static Event newFence(String mode) {
            checkArgument(FENCE_MODE.contains(mode), "Invalid fence mode '%s'.", mode);
            return EventFactory.newFence("Fence."+mode);
        }

        private static String toTag(MemoryOrder mo) {
            return switch(mo) {
                case PLAIN -> "";
                case ACQUIRE -> Tag.RISCV.MO_ACQ;
                case RELEASE -> Tag.RISCV.MO_REL;
                case ACQ_REL -> Tag.RISCV.MO_ACQ_REL;
            };
        }

        private static final Set<String> FENCE_MODE = Set.of(
                "r.r", "r.w", "r.rw", "w.r", "w.w", "w.rw", "rw.r", "rw.w", "rw.rw", "tso", "i"
        );
    }

    // =============================================================================================
    // =========================================== Power ===========================================
    // =============================================================================================
    public static class Power {
        private Power() {
        }

        public static Event newLoad(Register value, Expression address) {
            return EventFactory.newLoad(value, address);
        }

        public static Event newLoadReserve(Register value, Expression address) {
            return EventFactory.newRMWLoadExclusive(value, address);
        }

        public static Event newStore(Expression address, Expression value) {
            return EventFactory.newStore(address, value);
        }

        public static Event newStoreConditional(Register status, Expression address, Expression value) {
            return EventFactory.Common.newExclusiveStore(status, address, value, "");
        }

        public static GenericVisibleEvent newBarrier(String type) {
            checkArgument(BARRIER_TYPE.contains(type), "Invalid barrier '%s'.", type);
            return newFence(type);
        }

        private static final Set<String> BARRIER_TYPE = Set.of("isync", "sync", "lwsync");
    }

    // =============================================================================================
    // ============================================ PTX ============================================
    // =============================================================================================
    public static class PTX {
        private PTX() {}

        public static Event newLoad(Register value, Expression address, String mo) {
            return newLoadWithMo(value, address, mo);
        }

        public static Event newStore(Expression address, Expression value, String mo) {
            return newStoreWithMo(address, value, mo);
        }

        public static Event newAtomOp(Expression address, Register register, Expression value,
                IntBinaryOp op, String mo, String scope) {
            // PTX (currently) only generates memory orders ACQ_REL and RLX for atom.
            PTXAtomOp atom = new PTXAtomOp(register, address, op, value, mo);
            atom.addTags(scope);
            return atom;
        }

        public static Event newAtomCAS(Expression address, Register register, Expression expected,
                Expression value, String mo, String scope) {
            PTXAtomCAS atom = new PTXAtomCAS(register, address, expected, value, mo);
            atom.addTags(scope);
            return atom;
        }

        public static Event newAtomExch(Expression address, Register register,
                Expression value, String mo, String scope) {
            PTXAtomExch atom = new PTXAtomExch(register, address, value, mo);
            atom.addTags(scope);
            return atom;
        }

        public static Event newRedOp(Expression address, Expression value,
                IntBinaryOp op, String mo, String scope) {
            // PTX (currently) only generates memory orders ACQ_REL and RLX for red.
            PTXRedOp red = new PTXRedOp(address, value, op, mo);
            red.addTags(scope);
            return red;
        }

        public static Event newFence(String name) {
            return EventFactory.newFence(name);
        }
    }

    // =============================================================================================
    // =========================================== Vulkan ==========================================
    // =============================================================================================
    public static class Vulkan {
        private Vulkan() {}

        public static Event newLoad(Register value, Expression address, String mo) {
            return newLoadWithMo(value, address, mo);
        }

        public static Event newStore(Expression address, Expression value, String mo) {
            return newStoreWithMo(address, value, mo);
        }

        public static VulkanRMW newRMW(Expression address, Register register, Expression value,
                                          String mo, String scope) {
            return new VulkanRMW(register, address, value, mo, scope);
        }

        public static VulkanRMWOp newRMWOp(Expression address, Register register, Expression value,
                                           IntBinaryOp op, String mo, String scope) {
            return new VulkanRMWOp(register, address, op, value, mo, scope);
        }

        public static VulkanCmpXchg newVulkanCmpXchg(Expression address, Register register, Expression expected,
                                                     Expression value, String mo, String scope) {
            return new VulkanCmpXchg(register, address, expected, value, mo, scope);
        }

        public static Event newMemoryBarrier(String mo, String scope, List<String> semantics, boolean av,
                boolean vis) {
            checkArgument(BARRIER_MEMORY_ORDER.contains(mo), "Unknown barrier memory order '%s'.", mo);
            final GenericVisibleEvent barrier = new GenericVisibleEvent("membar", Tag.FENCE);
            barrier.addTags(semantics);
            barrier.addTags(mo, scope, av ? Tag.Vulkan.SEM_AVAILABLE : "", vis ? Tag.Vulkan.SEM_VISIBLE : "");
            return barrier;
        }

        public static GenericVisibleEvent newAvDevice() {
            return new GenericVisibleEvent("avdevice", Tag.Vulkan.AVDEVICE);
        }

        public static GenericVisibleEvent newVisDevice() {
            return new GenericVisibleEvent("visdevice", Tag.Vulkan.VISDEVICE);
        }

        private static final Set<String> BARRIER_MEMORY_ORDER = Set.of(
                Tag.Vulkan.ACQUIRE, Tag.Vulkan.RELEASE, Tag.Vulkan.ACQ_REL
        );
    }

    // =============================================================================================
    // =========================================== Spir-V ==========================================
    // =============================================================================================

    public static class Spirv {
        private Spirv() {}

        public static Event newLoad(Register register, Expression address, String scope, Set<String> tags) {
            return new SpirvLoad(register, address, scope, tags);
        }

        public static Event newStore(Expression address, Expression value, String scope, Set<String> tags) {
            return new SpirvStore(address, value, scope, tags);
        }

        public static Event newXchg(Register register, Expression address, Expression value, String scope,
                Set<String> tags) {
            return new SpirvXchg(register, address, value, scope, tags);
        }

        public static Event newRmw(Register register, Expression address, IntBinaryOp op, Expression value,
                String scope, Set<String> tags) {
            return new SpirvRmw(register, address, op, value, scope, tags);
        }

        public static Event newCmpXchg(Register register, Expression address, Expression cmp, Expression value,
                String scope, Set<String> eqTags, Set<String> neqTags) {
            return new SpirvCmpXchg(register, address, cmp, value, scope, eqTags, neqTags);
        }
    }
}