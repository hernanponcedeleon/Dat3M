package com.dat3m.dartagnan.program.processing.libraries;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.integers.IntBinaryOp;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.type.FunctionType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.event.functions.FunctionCall;
import com.dat3m.dartagnan.program.processing.PosixErrorCode;
import com.dat3m.dartagnan.program.processing.ThreadCreation;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

import java.math.BigInteger;
import java.util.*;

import static com.dat3m.dartagnan.configuration.OptionNames.THREAD_CREATE_ALWAYS_SUCCEEDS;
import static com.dat3m.dartagnan.program.event.EventFactory.*;
import static com.dat3m.dartagnan.program.event.EventFactory.newStore;
import static com.dat3m.dartagnan.program.event.lang.dat3m.DynamicThreadJoin.Status.INVALID_TID;
import static com.dat3m.dartagnan.program.event.lang.dat3m.DynamicThreadJoin.Status.SUCCESS;
import static com.google.common.base.Preconditions.checkArgument;

//TODO: Deal with "late intrinsics".
@Options
public class PthreadLibrary extends AbstractLibrary<PthreadLibrary> {

    public enum SupportedFunctions {
        // --------------------------- pthread threading ---------------------------
        P_THREAD_CREATE("pthread_create", PthreadLibrary::inlinePthreadCreate),
        P_THREAD_EXIT("pthread_exit", PthreadLibrary::inlinePthreadExit),
        P_THREAD_JOIN(List.of("pthread_join", "_pthread_join", "__pthread_join"), PthreadLibrary::inlinePthreadJoin),
        P_THREAD_DETACH("pthread_detach", PthreadLibrary::inlinePthreadDetach),
        P_THREAD_BARRIER_WAIT("pthread_barrier_wait", PthreadLibrary::inlineAsZero),
        // TODO: These were late intrinsics which we cannot handle right now
       // P_THREAD_SELF(List.of("pthread_self", "__VERIFIER_tid"), PthreadLibrary::inlinePthreadSelf),
        //P_THREAD_EQUAL("pthread_equal", PthreadLibrary::inlinePthreadEqual),
        P_THREAD_ONCE("pthread_once", PthreadLibrary::inlinePthreadOnce),
        P_THREAD_ATTR_INIT("pthread_attr_init", PthreadLibrary::inlinePthreadAttr),
        P_THREAD_ATTR_DESTROY("pthread_attr_destroy", PthreadLibrary::inlinePthreadAttr),
        P_THREAD_ATTR_GET(P_THREAD_ATTR.stream().map(a -> "pthread_attr_get" + a).toList(),
                PthreadLibrary::inlinePthreadAttr),
        P_THREAD_ATTR_SET(P_THREAD_ATTR.stream().map(a -> "pthread_attr_set" + a).toList(),
                PthreadLibrary::inlinePthreadAttr),
        // --------------------------- pthread condition variable ---------------------------
        P_THREAD_COND_INIT(List.of("pthread_cond_init", "_pthread_cond_init"),
                PthreadLibrary::inlinePthreadCondInit),
        P_THREAD_COND_DESTROY("pthread_cond_destroy", PthreadLibrary::inlinePthreadCondDestroy),
        P_THREAD_COND_SIGNAL("pthread_cond_signal", PthreadLibrary::inlinePthreadCondSignal),
        P_THREAD_COND_BROADCAST("pthread_cond_broadcast", PthreadLibrary::inlinePthreadCondBroadcast),
        P_THREAD_COND_WAIT(List.of("pthread_cond_wait", "_pthread_cond_wait"),
                PthreadLibrary::inlinePthreadCondWait),
        P_THREAD_COND_TIMEDWAIT(List.of("pthread_cond_timedwait", "_pthread_cond_timedwait"),
                PthreadLibrary::inlinePthreadCondTimedwait),
        P_THREAD_CONDATTR_INIT("pthread_condattr_init", PthreadLibrary::inlinePthreadCondAttr),
        P_THREAD_CONDATTR_DESTROY("pthread_condattr_destroy", PthreadLibrary::inlinePthreadCondAttr),
        // --------------------------- pthread key ---------------------------
        P_THREAD_KEY_CREATE("pthread_key_create", PthreadLibrary::inlinePthreadKeyCreate),
        P_THREAD_KEY_DELETE("pthread_key_delete", PthreadLibrary::inlinePthreadKeyDelete),
        P_THREAD_GET_SPECIFIC("pthread_getspecific", PthreadLibrary::inlinePthreadGetSpecific),
        P_THREAD_SET_SPECIFIC("pthread_setspecific", PthreadLibrary::inlinePthreadSetSpecific),
        // --------------------------- pthread mutex ---------------------------
        P_THREAD_MUTEX_INIT("pthread_mutex_init", PthreadLibrary::inlinePthreadMutexInit),
        P_THREAD_MUTEX_DESTROY("pthread_mutex_destroy", PthreadLibrary::inlinePthreadMutexDestroy),
        P_THREAD_MUTEX_LOCK("pthread_mutex_lock", PthreadLibrary::inlinePthreadMutexLock),
        P_THREAD_MUTEX_TRYLOCK("pthread_mutex_trylock", PthreadLibrary::inlinePthreadMutexTryLock),
        P_THREAD_MUTEX_UNLOCK("pthread_mutex_unlock", PthreadLibrary::inlinePthreadMutexUnlock),
        P_THREAD_MUTEXATTR_INIT("pthread_mutexattr_init", PthreadLibrary::inlinePthreadMutexAttr),
        P_THREAD_MUTEXATTR_DESTROY(List.of("pthread_mutexattr_destroy", "_pthread_mutexattr_destroy"),
                PthreadLibrary::inlinePthreadMutexAttr),
        P_THREAD_MUTEXATTR_SET(P_THREAD_MUTEXATTR.stream().map(a -> "pthread_mutexattr_get" + a).toList(),
                PthreadLibrary::inlinePthreadMutexAttr),
        P_THREAD_MUTEXATTR_GET(P_THREAD_MUTEXATTR.stream().map(a -> "pthread_mutexattr_set" + a).toList(),
                PthreadLibrary::inlinePthreadMutexAttr),
        // --------------------------- pthread read/write lock ---------------------------
        P_THREAD_RWLOCK_INIT(List.of("pthread_rwlock_init", "_pthread_rwlock_init"),
                PthreadLibrary::inlinePthreadRwlockInit),
        P_THREAD_RWLOCK_DESTROY(List.of("pthread_rwlock_destroy", "_pthread_rwlock_destroy"),
                PthreadLibrary::inlinePthreadRwlockDestroy),
        P_THREAD_RWLOCK_WRLOCK(List.of("pthread_rwlock_wrlock", "_pthread_rwlock_wrlock"),
                PthreadLibrary::inlinePthreadRwlockWrlock),
        P_THREAD_RWLOCK_TRYWRLOCK(List.of("pthread_rwlock_trywrlock", "_pthread_rwlock_trywrlock"),
                PthreadLibrary::inlinePthreadRwlockTryWrlock),
        P_THREAD_RWLOCK_RDLOCK(List.of("pthread_rwlock_rdlock", "_pthread_rwlock_rdlock"),
                PthreadLibrary::inlinePthreadRwlockRdlock),
        P_THREAD_RWLOCK_TRYRDLOCK(List.of("pthread_rwlock_tryrdlock", "_pthread_rwlock_tryrdlock"),
                PthreadLibrary::inlinePthreadRwlockTryRdlock),
        P_THREAD_RWLOCK_UNLOCK(List.of("pthread_rwlock_unlock", "_pthread_rwlock_unlock"),
                PthreadLibrary::inlinePthreadRwlockUnlock),
        P_THREAD_RWLOCKATTR_INIT("pthread_rwlockattr_init", PthreadLibrary::inlinePthreadRwlockAttr),
        P_THREAD_RWLOCKATTR_DESTROY("pthread_rwlockattr_destroy", PthreadLibrary::inlinePthreadRwlockAttr),
        P_THREAD_RWLOCKATTR_SET("pthread_rwlockattr_setpshared", PthreadLibrary::inlinePthreadRwlockAttr),
        P_THREAD_RWLOCKATTR_GET("pthread_rwlockattr_getpshared", PthreadLibrary::inlinePthreadRwlockAttr),
        ;

        private final List<String> variants;
        private final Handler<PthreadLibrary> handler;

        SupportedFunctions(List<String> variants, CallResolver<PthreadLibrary> handler) {
            this.variants = variants;
            this.handler = handler;
        }

        SupportedFunctions(String name, CallResolver<PthreadLibrary> handler) {
            this(List.of(name), handler);
        }

        private boolean matches(String funcName) {
            return variants.contains(funcName);
        }
    }

    @Option(name = THREAD_CREATE_ALWAYS_SUCCEEDS,
            description = "Calling pthread_create is guaranteed to succeed (default true).",
            secure = true,
            toUppercase = true)
    private boolean pthreadCreateAlwaysSucceeds = true;

    public PthreadLibrary(Configuration config) throws InvalidConfigurationException {
        super(config);
        config.inject(this);
    }

    @Override
    protected PthreadLibrary getThis() {
        return this;
    }

    @Override
    protected Optional<Handler<PthreadLibrary>> getHandler(Function func) {
        final String funcName = func.getName();
        return Arrays.stream(SupportedFunctions.values())
                .filter(f -> f.matches(funcName))
                .map(f -> f.handler)
                .findFirst();
    }


    // ========================================================================================

    private final static FunctionType PTHREAD_THREAD_TYPE = types.getFunctionType(
            types.getPointerType(), List.of(types.getPointerType())
    );

    private List<Event> inlinePthreadCreate(FunctionCall call) {
        final List<Expression> arguments = call.getArguments();
        assert arguments.size() == 4;
        final Expression pidResultAddress = arguments.get(0);
        final Expression attributes = arguments.get(1);
        final Expression targetFunction = arguments.get(2);
        final Expression argument = arguments.get(3);

        final Register attributesRegister = call.getFunction().newUniqueRegister("__pthread_create_attr", getPthreadAttrType());
        final Register resultRegister = getResultRegister(call);
        assert resultRegister.getType() instanceof IntegerType;

        final Register tidReg = call.getFunction().newUniqueRegister("__tid", types.getArchType());
        final Event createEvent = newDynamicThreadCreate(tidReg, PTHREAD_THREAD_TYPE, targetFunction, List.of(argument));
        final Label skipAttrLabel = newLabel("__pthread_create_skip_attr");
        final Label skipDetachLabel = newLabel("__pthread_create_skip_detach");

        final Register failureRegister = call.getFunction().getOrNewRegister("__pthread_create_fail", types.getBooleanType());
        final Event decideFailure = pthreadCreateAlwaysSucceeds
                ? EventFactory.newLocal(failureRegister, expressions.makeFalse())
                : EventFactory.newNonDetChoice(failureRegister);
        final Label pthreadFailCase = newLabel("__pthread_create_fail");
        final CondJump checkIfFail = newJump(failureRegister, pthreadFailCase);
        final Label endOfPthreadCreate = newLabel("__pthread_create_end");

        return eventSequence(
                decideFailure,
                checkIfFail,
                // ----- SUCCESS -----
                createEvent,
                newJump(expressions.makeEQ(attributes, expressions.makeGeneralZero(attributes.getType())), skipAttrLabel),
                newLoad(attributesRegister, attributes),
                // If 'detach' attribute, detach the spawned thread immediately.
                // No need to check the status here, as detaching should always succeed.
                // resultRegister is reused here and will be overwritten later.
                newJumpUnless(testPthreadCreateDetached(attributesRegister), skipDetachLabel),
                newDynamicThreadDetach(resultRegister, tidReg),
                skipDetachLabel,
                // Finally, return the thread ID and the status.
                skipAttrLabel,
                newStore(pidResultAddress, tidReg),
                // TODO: Allow to return failure value (!= 0)
                newLocal(resultRegister, expressions.makeGeneralZero(resultRegister.getType())),
                newGoto(endOfPthreadCreate),
                // ----- FAIL -----
                pthreadFailCase,
                newLocal(resultRegister, expressions.makeValue(PosixErrorCode.EAGAIN.getValue(),
                        (IntegerType) resultRegister.getType())),
                endOfPthreadCreate
        );
    }

    private List<Event> inlinePthreadJoin(FunctionCall call) {
        final List<Expression> arguments = call.getArguments();
        assert arguments.size() == 2;
        final Expression tidExpr = arguments.get(0);
        final Expression returnAddr = arguments.get(1);
        final boolean hasReturnAddr = !(returnAddr instanceof IntLiteral lit && lit.isZero());

        final Register statusRegister = getResultRegister(call);
        final IntegerType statusType = (IntegerType) statusRegister.getType();

        final Type joinType = types.getAggregateType(List.of(types.getIntegerType(8), PTHREAD_THREAD_TYPE.getReturnType()));
        final Register joinReg = call.getFunction().newUniqueRegister("__joinReg", joinType);

        final Expression status = expressions.makeExtract(joinReg, 0);
        final Expression retVal = expressions.makeExtract(joinReg, 1);

        final Expression statusSuccess = expressions.makeValue(SUCCESS.getErrorCode(), (IntegerType) status.getType());
        final Expression statusInvalidTId = expressions.makeValue(INVALID_TID.getErrorCode(), (IntegerType) status.getType());

        final Label joinEnd = hasReturnAddr ? newLabel("__pthread_join_end") : null;
        final Store storeRetVal = hasReturnAddr ? newStore(returnAddr, retVal) : null;
        final CondJump jump = hasReturnAddr ? newJump(expressions.makeNEQ(status, statusSuccess), joinEnd) : null;

        return eventSequence(
                newDynamicThreadJoin(joinReg, tidExpr),
                // TODO: We use our internal error codes which do not match with pthread's error codes,
                //  except for the success case (error code == 0).
                newLocal(statusRegister, expressions.makeCast(status, statusType)),
                jump,
                storeRetVal,
                joinEnd,
                newAssert(expressions.makeNEQ(status, statusInvalidTId), "Invalid thread id in pthread_join.")
        );
    }

    private List<Event> inlinePthreadDetach(FunctionCall call) {
        final List<Expression> arguments = call.getArguments();
        assert arguments.size() == 1;
        final Expression tidExpr = arguments.get(0);

        final Register statusRegister = getResultRegister(call);
        final IntegerType statusType = (IntegerType) statusRegister.getType();

        final Expression statusInvalidTId = expressions.makeValue(INVALID_TID.getErrorCode(), statusType);

        return eventSequence(
                newDynamicThreadDetach(statusRegister, tidExpr),
                newAssert(expressions.makeNEQ(statusRegister, statusInvalidTId), "Invalid thread id in pthread_detach.")
        );
    }

    private List<Event> inlinePthreadExit(FunctionCall call) {
        final List<Expression> arguments = call.getArguments();
        assert arguments.size() == 1 && arguments.get(0).getType().equals(PTHREAD_THREAD_TYPE.getReturnType());

        return List.of(newThreadReturn(arguments.get(0)));
    }

    private List<Event> inlinePthreadSelf(FunctionCall call) {
        // This intrinsics is mainly defined by ThreadCreation.
        assert call.getArguments().isEmpty();
        final Register resultRegister = getResultRegister(call);
        final Expression tidExpr = call.getThread().getRegister(ThreadCreation.THREAD_SELF_REGISTER_NAME);
        assert tidExpr != null : "Non-POSIX thread %s".formatted(call.getThread());
        return List.of(newLocal(resultRegister, expressions.makeCast(tidExpr, resultRegister.getType())));
    }

    private List<Event> inlinePthreadEqual(FunctionCall call) {
        final Register resultRegister = getResultRegisterAndCheckArguments(2, call);
        final Expression leftId = call.getArguments().get(0);
        final Expression rightId = call.getArguments().get(1);
        final Expression equation = expressions.makeEQ(leftId, rightId);
        return List.of(
                EventFactory.newLocal(resultRegister, expressions.makeCast(equation, resultRegister.getType()))
        );
    }

    private static final List<String> P_THREAD_ATTR = List.of(
            "stack", // no field itself, but describes simultaneous getters and setters for stackaddr and stacksize
            "stackaddr",
            "stacksize",
            "guardsize",
            "detachstate", // either PTHREAD_CREATE_DETACHED, or defaults to PTHREAD_CREATE_JOINABLE
            "inheritsched", // either PTHREAD_EXPLICIT_SCHED, or defaults to PTHREAD_INHERIT_SCHED
            "schedparam", // struct sched_param
            "schedpolicy", // either SCHED_FIFO, SCHED_RR, or SCHED_OTHER
            "scope" // either PTHREAD_SCOPE_SYSTEM, or PTHREAD_SCOPE_PROCESS
    );

    private List<Event> inlinePthreadAttr(FunctionCall call) {
        final String suffix = call.getCalledFunction().getName().substring("pthread_attr_".length());
        final int expectedArguments = switch (suffix) {
            case "init", "destroy" -> 1;
            case "getstack", "setstack" -> 3;
            default -> 2;
        };
        final Register errorRegister = getResultRegisterAndCheckArguments(expectedArguments, call);
        final Expression attrAddress = call.getArguments().get(0);
        final Expression value = expectedArguments < 2 ? null : call.getArguments().get(1);
        final boolean initial = suffix.equals("init");
        if (initial || suffix.equals("destroy")) {
            final Expression flag = expressions.makeValue(initial ? 1 : 0, getPthreadAttrType());
            return List.of(
                    newStore(attrAddress, flag),
                    assignSuccess(errorRegister)
            );
        }
        final boolean getter = suffix.startsWith("get");
        checkArgument((getter || suffix.startsWith("set")) && P_THREAD_ATTR.contains(suffix.substring(3)),
                "Unrecognized intrinsics \"%s\"", call);
        final Register oldValue = call.getFunction().newRegister(getPthreadAttrType());
        final Label end = EventFactory.newLabel("__pthread_return");
        final PthreadAttrImplementation impl = switch (suffix.substring(3)) {
            case "detachstate" -> inlinePthreadAttrDetachState(oldValue, getter ? null : value, end);
            default -> null;
        };
        final Expression zero = expressions.makeZero(types.getIntegerType(1));
        final Expression extractInitialized = expressions.makeIntExtract(oldValue, 0, 0);
        return eventSequence(
                assignPosixError(errorRegister, PosixErrorCode.EINVAL),
                newLoad(oldValue, attrAddress),
                newJump(expressions.makeEQ(extractInitialized, zero), end),
                impl == null ? null : impl.errorChecks,
                impl == null ? null : newStore(getter ? value : attrAddress, impl.out),
                assignSuccess(errorRegister),
                end
        );
    }

    private IntegerType getPthreadAttrType() {
        return types.getIntegerType(2);
    }

    private record PthreadAttrImplementation(Expression out, List<Event> errorChecks) {}

    private PthreadAttrImplementation inlinePthreadAttrDetachState(Expression oldValue, Expression detachstate,
                                                                              Label returnEINVAL) {
        // POSIX defines these two named constants of type int.
        // see https://pubs.opengroup.org/onlinepubs/9799919799/basedefs/pthread.h.html
        //TODO values may vary by platform
        final long PTHREAD_CREATE_DETACHED = 1;
        final long PTHREAD_CREATE_JOINABLE = 0;
        final int flagIndex = 1;
        final IntegerType attrType = (IntegerType) oldValue.getType();
        final IntegerType valueType = getNativeIntType();
        final Expression createDetached = expressions.makeValue(PTHREAD_CREATE_DETACHED, valueType);
        final Expression createJoinable = expressions.makeValue(PTHREAD_CREATE_JOINABLE, valueType);
        final List<Event> errorChecks = new ArrayList<>();
        final Expression newValue;
        if (detachstate == null) {
            final Expression zero = expressions.makeZero(types.getIntegerType(1));
            final Expression extractValue = expressions.makeIntExtract(oldValue, flagIndex, flagIndex);
            final Expression testValue = expressions.makeNEQ(extractValue, zero);
            newValue = expressions.makeITE(testValue, createDetached, createJoinable);
        } else {
            final long invertedMaskValue = (1L << attrType.getBitWidth()) - (1 << flagIndex) - 1;
            final Expression mask = expressions.makeValue(1 << flagIndex, attrType);
            final Expression invertedMask = expressions.makeValue(invertedMaskValue, attrType);
            final Expression setFlag = expressions.makeIntOr(oldValue, mask);
            final Expression resetFlag = expressions.makeIntAnd(oldValue, invertedMask);
            final Expression doDetach = expressions.makeEQ(detachstate, createDetached);
            final Expression doNotDetach = expressions.makeEQ(detachstate, createJoinable);
            final Expression validValue = expressions.makeOr(doDetach, doNotDetach);
            errorChecks.add(EventFactory.newJumpUnless(validValue, returnEINVAL));
            newValue = expressions.makeITE(doDetach, setFlag, resetFlag);
        }
        return new PthreadAttrImplementation(newValue, errorChecks);
    }

    private Expression testPthreadCreateDetached(Expression attr) {
        final int flagIndex = 1;
        final Expression zero = expressions.makeZero(types.getIntegerType(1));
        final Expression extractDetach = expressions.makeIntExtract(attr, flagIndex, flagIndex);
        return expressions.makeNEQ(extractDetach, zero);
    }

    private List<Event> inlinePthreadCondInit(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_cond_init
        final Register errorRegister = getResultRegisterAndCheckArguments(2, call);
        final Expression condAddress = call.getArguments().get(0);
        //final Expression attributes = call.getArguments().get(1);
        final Expression initializedState = expressions.makeTrue();
        return List.of(
                newStore(condAddress, initializedState),
                assignSuccess(errorRegister)
        );
    }

    private List<Event> inlinePthreadCondDestroy(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_cond_destroy
        final Register errorRegister = getResultRegisterAndCheckArguments(1, call);
        final Expression condAddress = call.getArguments().get(0);
        final Expression finalizedState = expressions.makeFalse();
        return List.of(
                newStore(condAddress, finalizedState),
                assignSuccess(errorRegister)
        );
    }

    private List<Event> inlinePthreadCondSignal(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_cond_signal
        return inlinePthreadCondBroadcast(call);
    }

    private List<Event> inlinePthreadCondBroadcast(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_cond_broadcast
        // Because of spurious wake-ups, there is no need to do anything here.
        final Register errorRegister = getResultRegisterAndCheckArguments(1, call);
        //final Expression condAddress = call.getArguments().get(0);
        return List.of(
                assignSuccess(errorRegister)
        );
    }

    private List<Event> inlinePthreadCondWait(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_cond_wait
        final Register errorRegister = getResultRegisterAndCheckArguments(2, call);
        //final Expression condAddress = call.getArguments().get(0);
        final Expression lockAddress = call.getArguments().get(1);
        final IntegerType mutexType = getPthreadMutexType();
        final Type oldValueAndSuccessType = types.getAggregateType(List.of(mutexType, types.getBooleanType()));
        final Register oldValueRegister = call.getFunction().newUniqueRegister("__pthread_cond_wait", mutexType);
        final Register oldValueAndSuccess = call.getFunction().newUniqueRegister("__pthread_cond_wait", oldValueAndSuccessType);
        return eventSequence(
                // Allow other threads to access the condition variable.
                newPthreadUnlock(oldValueRegister, lockAddress),
                // This thread would sleep here.  Explicit or spurious signals may wake it.
                // Re-lock.
                newPthreadLock(oldValueAndSuccess, lockAddress),
                assignSuccess(errorRegister)
        );
    }

    private List<Event> inlinePthreadCondTimedwait(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_cond_timedwait
        final Register errorRegister = getResultRegisterAndCheckArguments(3, call);
        //final Expression condAddress = call.getArguments().get(0);
        final Expression lockAddress = call.getArguments().get(1);
        //final Expression timespec = call.getArguments().get(2);
        final IntegerType mutexType = getPthreadMutexType();
        final Type oldValueAndSuccessType = types.getAggregateType(List.of(mutexType, types.getBooleanType()));
        final Register oldValueRegister = call.getFunction().newUniqueRegister("__pthread_cond_timedwait", mutexType);
        final Register oldValueAndSuccess = call.getFunction().newUniqueRegister("__pthread_cond_timedwait", oldValueAndSuccessType);
        return eventSequence(
                // Allow other threads to access the condition variable.
                newPthreadUnlock(oldValueRegister, lockAddress),
                // This thread would sleep here.  Explicit or spurious signals may wake it.
                // Re-lock.
                newPthreadLock(oldValueAndSuccess, lockAddress),
                assignPosixError(errorRegister, PosixErrorCode.ETIMEDOUT)
        );
    }

    private List<Event> inlinePthreadCondAttr(FunctionCall call) {
        final String suffix = call.getCalledFunction().getName().substring("pthread_condattr_".length());
        final boolean init = suffix.equals("init");
        final boolean destroy = suffix.equals("destroy");
        final Register errorRegister = getResultRegisterAndCheckArguments(init || destroy ? 1 : 2, call);
        final Expression attrAddress = call.getArguments().get(0);
        checkUnknownIntrinsic(init || destroy, call);
        return List.of(
                newStore(attrAddress, expressions.makeValue(init)),
                assignSuccess(errorRegister)
        );
    }

    private List<Event> inlinePthreadKeyCreate(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_key_create
        final Register errorRegister = getResultRegisterAndCheckArguments(2, call);
        final Expression keyAddress = call.getArguments().get(0);
        final Expression destructor = call.getArguments().get(1);
        final Register keyRegister = call.getFunction().newUniqueRegister("__pthread_key_create_key", getNativeIntType());
        return List.of(
                newDynamicThreadLocalCreate(keyRegister, destructor),
                newStore(keyAddress, keyRegister),
                assignSuccess(errorRegister)
        );
    }

    private List<Event> inlinePthreadKeyDelete(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_key_delete
        final Register errorRegister = getResultRegisterAndCheckArguments(1, call);
        final Expression key = call.getArguments().get(0);
        return List.of(
                newDynamicThreadLocalDelete(key),
                assignSuccess(errorRegister)
        );
    }

    private List<Event> inlinePthreadGetSpecific(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_getspecific
        final Register result = getResultRegisterAndCheckArguments(1, call);
        final Expression key = call.getArguments().get(0);
        return List.of(
                newDynamicThreadLocalGet(result, key)
        );
    }

    private List<Event> inlinePthreadSetSpecific(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_setspecific
        final Register errorRegister = getResultRegisterAndCheckArguments(2, call);
        final Expression key = call.getArguments().get(0);
        final Expression value = call.getArguments().get(1);
        return List.of(
                newDynamicThreadLocalSet(key, value),
                assignSuccess(errorRegister)
        );
    }

    private static final List<String> P_THREAD_MUTEXATTR = List.of(
            "prioceiling",
            "protocol",
            "type"
    );

    private List<Event> inlinePthreadMutexInit(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_mutex_init
        //TODO use attributes
        final Register errorRegister = getResultRegisterAndCheckArguments(2, call);
        final Expression lockAddress = call.getArguments().get(0);
        final IntegerType type = getPthreadMutexType();
        final Expression unlocked = expressions.makeZero(type);
        return List.of(
                EventFactory.Llvm.newStore(lockAddress, unlocked, Tag.C11.MO_RELEASE),
                assignSuccess(errorRegister)
        );
    }

    private List<Event> inlinePthreadMutexDestroy(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_mutex_destroy
        final Register errorRegister = getResultRegisterAndCheckArguments(1, call);
        //TODO store a value such that later uses of the lock fail
        return List.of(
                assignSuccess(errorRegister)
        );
    }

    private List<Event> inlinePthreadMutexLock(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_mutex_lock
        final Register errorRegister = getResultRegisterAndCheckArguments(1, call);
        checkArgument(errorRegister.getType() instanceof IntegerType, "Wrong return type for \"%s\"", call);
        final IntegerType mutexType = getPthreadMutexType();
        final Type oldValueAndSuccessType = types.getAggregateType(List.of(mutexType, types.getBooleanType()));
        final Register oldValueAndSuccess = call.getFunction().newUniqueRegister("__pthread_mutex_lock", oldValueAndSuccessType);
        final Expression lockAddress = call.getArguments().get(0);
        return eventSequence(
                newPthreadLock(oldValueAndSuccess, lockAddress),
                assignSuccess(errorRegister)
        );
    }

    private List<Event> inlinePthreadMutexTryLock(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_mutex_trylock
        final Register errorRegister = getResultRegisterAndCheckArguments(1, call);
        checkArgument(errorRegister.getType() instanceof IntegerType, "Wrong return type for \"%s\"", call);
        final Type oldValueAndSuccessType = types.getAggregateType(List.of(getPthreadMutexType(), types.getBooleanType()));
        final Register oldValueAndSuccess = call.getFunction().newUniqueRegister("__pthread_mutex_try_lock", oldValueAndSuccessType);
        final Expression lockAddress = call.getArguments().get(0);
        final Expression fail = expressions.makeNot(expressions.makeExtract(oldValueAndSuccess, 1));
        return List.of(
                newPthreadTryLock(oldValueAndSuccess, lockAddress),
                EventFactory.newLocal(errorRegister, expressions.makeCast(fail, errorRegister.getType()))
        );
    }

    private List<Event> inlinePthreadMutexUnlock(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_mutex_unlock
        final Register errorRegister = getResultRegisterAndCheckArguments(1, call);
        final IntegerType type = getPthreadMutexType();
        final Register oldValueRegister = call.getFunction().newUniqueRegister("__pthread_mutex_unlock", type);
        final Expression lockAddress = call.getArguments().get(0);
        return eventSequence(
                newPthreadUnlock(oldValueRegister, lockAddress),
                assignSuccess(errorRegister)
        );
    }

    private List<Event> inlinePthreadMutexAttr(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_mutexattr_init
        final String functionName = call.getCalledFunction().getName();
        // MacOS systems prepend 'pthread_mutexattr_destroy' with _.
        final int prefixLength = functionName.startsWith("_") ? 1 : 0;
        final String suffix = functionName.substring(prefixLength + "pthread_mutexattr_".length());
        final boolean init = suffix.equals("init");
        final boolean destroy = suffix.equals("destroy");
        final Register errorRegister = getResultRegisterAndCheckArguments(init || destroy ? 1 : 2, call);
        final Expression attrAddress = call.getArguments().get(0);
        if (init || destroy) {
            return List.of(
                    newStore(attrAddress, expressions.makeValue(init)),
                    assignSuccess(errorRegister)
            );
        }
        final boolean get = suffix.startsWith("get");
        checkUnknownIntrinsic(get || suffix.startsWith("set"), call);
        checkUnknownIntrinsic(P_THREAD_MUTEXATTR.contains(suffix.substring(3)), call);
        return List.of(
                assignSuccess(errorRegister)
        );
    }

    private List<Event> newPthreadUnlock(Register oldValueRegister, Expression address) {
        final Expression unlocked = expressions.makeGeneralZero(oldValueRegister.getType());
        final boolean skipCheck = notToInline.contains(AssertionType.USER);
        final Event load = skipCheck ? null : EventFactory.Llvm.newLoad(oldValueRegister, address, Tag.C11.MO_RELAXED);
        final Expression isLocked = skipCheck ? null : expressions.makeNEQ(oldValueRegister, unlocked);
        final Event check = skipCheck ? null : EventFactory.newAssert(isLocked, "Unlocking an already unlocked mutex");
        final Event store = EventFactory.Llvm.newStore(address, unlocked, Tag.C11.MO_RELEASE);
        return Arrays.asList(load, check, store);
    }

    private Event newPthreadTryLock(Register oldValueAndSuccess, Expression lockAddress) {
        final Expression unlocked = expressions.makeZero(getPthreadMutexType());
        final Expression locked = expressions.makeOne(getPthreadMutexType());
        return Llvm.newCompareExchange(oldValueAndSuccess, lockAddress, unlocked, locked, Tag.C11.MO_ACQUIRE, true);
    }

    private List<Event> newPthreadLock(Register oldValueSuccessRegister, Expression address) {
        // We implement this as a CAS-spinlock
        final Label spinLoopHead = EventFactory.newLabel("__spinloop_head");
        final Label spinLoopEnd = EventFactory.newLabel("__spinloop_end");
        return List.of(
                newLoopBound(expressions.makeValue(1, types.getArchType())),
                spinLoopHead,
                newPthreadTryLock(oldValueSuccessRegister, address),
                EventFactory.newJump(expressions.makeExtract(oldValueSuccessRegister, 1), spinLoopEnd),
                EventFactory.newGoto(spinLoopHead),
                spinLoopEnd
        );
    }

    private IntegerType getPthreadMutexType() {
        return types.getIntegerType(1);
    }

    private static final List<String> P_THREAD_RWLOCK_ATTR = List.of(
            "pshared"
    );

    private List<Event> inlinePthreadRwlockInit(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_rwlock_init
        final Register errorRegister = getResultRegisterAndCheckArguments(2, call);
        final Expression lockAddress = call.getArguments().get(0);
        //final Expression attributes = call.getArguments().get(1);
        return List.of(
                newStore(lockAddress, getRwlockUnlockedValue()),
                assignSuccess(errorRegister)
        );
    }

    private List<Event> inlinePthreadRwlockDestroy(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_rwlock_destroy
        final Register errorRegister = getResultRegisterAndCheckArguments(1, call);
        //TODO store a value such that later uses of the lock fail
        //final Expression lock = call.getArguments().get(0);
        //final Expression finalizedValue = expressions.makeZero(types.getArchType());
        return List.of(
                //EventFactory.newStore(lock, finalizedValue)
                assignSuccess(errorRegister)
        );
    }

    private List<Event> inlinePthreadRwlockWrlock(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_rwlock_wrlock
        final Register errorRegister = getResultRegisterAndCheckArguments(1, call);
        final Expression lockAddress = call.getArguments().get(0);
        final Type oldValueAndSuccessType = types.getAggregateType(List.of(getRwlockDatatype(), types.getBooleanType()));
        final Register oldValueAndSuccess = call.getFunction().newRegister(oldValueAndSuccessType);
        final Expression successResult = expressions.makeExtract(oldValueAndSuccess, 1);
        return List.of(
                // Write-lock only if unlocked.
                newRwlockTryWrlock(oldValueAndSuccess, lockAddress),
                // Deadlock if a violation occurred in another thread.
                EventFactory.newAbortIf(expressions.makeNot(successResult)),
                assignSuccess(errorRegister)
        );
    }

    private List<Event> inlinePthreadRwlockTryWrlock(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_rwlock_trywrlock
        final Register errorRegister = getResultRegisterAndCheckArguments(1, call);
        final Expression lockAddress = call.getArguments().get(0);
        final Type oldValueAndSuccessType = types.getAggregateType(List.of(getRwlockDatatype(), types.getBooleanType()));
        final Register oldValueAndSuccess = call.getFunction().newRegister(oldValueAndSuccessType);
        final Expression success = expressions.makeGeneralZero(errorRegister.getType());
        final Expression successResult = expressions.makeExtract(oldValueAndSuccess, 1);
        return List.of(
                // Write-lock only if unlocked.
                newRwlockTryWrlock(oldValueAndSuccess, lockAddress),
                // Indicate success by returning zero.
                EventFactory.newNonDetChoice(errorRegister),
                EventFactory.newAssume(expressions.makeEQ(successResult, expressions.makeEQ(errorRegister, success)))
        );
    }

    private Event newRwlockTryWrlock(Register oldValueAndSuccess, Expression lockAddress) {
        final Expression unlocked = getRwlockUnlockedValue();
        final Expression locked = getRwlockWriteLockedValue();
        return Llvm.newCompareExchange(oldValueAndSuccess, lockAddress, unlocked, locked, Tag.C11.MO_ACQUIRE, true);
    }

    private List<Event> inlinePthreadRwlockRdlock(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_rwlock_rdlock
        final Register errorRegister = getResultRegisterAndCheckArguments(1, call);
        final Type oldValueAndSuccessType = types.getAggregateType(List.of(getRwlockDatatype(), types.getBooleanType()));
        final Register oldValueAndSuccess = call.getFunction().newUniqueRegister("__pthread_rwlock_rdlock", oldValueAndSuccessType);
        final Register expectedRegister = call.getFunction().newRegister(getRwlockDatatype());
        final Expression lockAddress = call.getArguments().get(0);
        final Expression oldValueResult = expressions.makeExtract(oldValueAndSuccess, 0);
        final Expression successResult = expressions.makeExtract(oldValueAndSuccess, 1);
        final Expression wasWriteLocked = expressions.makeEQ(oldValueResult, getRwlockWriteLockedValue());
        return List.of(
                // Expect any other value than write-locked.
                EventFactory.newNonDetChoice(expectedRegister),
                EventFactory.newAssume(expressions.makeNEQ(expectedRegister, getRwlockWriteLockedValue())),
                // Increment shared counter only if not locked by writer.
                newRwlockTryRdlock(oldValueAndSuccess, lockAddress, expectedRegister),
                // Fail only if write-locked.
                EventFactory.newAssume(expressions.makeOr(successResult, wasWriteLocked)),
                // Deadlock if a violation occurred in another thread.
                EventFactory.newAbortIf(expressions.makeNot(successResult)),
                assignSuccess(errorRegister)
        );
    }

    private List<Event> inlinePthreadRwlockTryRdlock(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_rwlock_tryrdlock
        final Register errorRegister = getResultRegisterAndCheckArguments(1, call);
        final Type oldValueAndSuccessType = types.getAggregateType(List.of(getRwlockDatatype(), types.getBooleanType()));
        final Register oldValueAndSuccess = call.getFunction().newUniqueRegister("__pthread_rwlock_try_rdlock", oldValueAndSuccessType);
        final Register expectedRegister = call.getFunction().newRegister(getRwlockDatatype());
        final Expression lockAddress = call.getArguments().get(0);
        final Expression success = expressions.makeGeneralZero(errorRegister.getType());
        final Expression actualResult = expressions.makeExtract(oldValueAndSuccess, 0);
        final Expression successResult = expressions.makeExtract(oldValueAndSuccess, 1);
        final Expression wasWriteLocked = expressions.makeEQ(actualResult, getRwlockWriteLockedValue());
        return List.of(
                // Expect any other value than write-locked.
                EventFactory.newNonDetChoice(expectedRegister),
                EventFactory.newAssume(expressions.makeNEQ(expectedRegister, getRwlockWriteLockedValue())),
                // Increment shared counter only if not locked by writer.
                newRwlockTryRdlock(oldValueAndSuccess, lockAddress, expectedRegister),
                // Fail only if write-locked.
                EventFactory.newAssume(expressions.makeOr(successResult, wasWriteLocked)),
                // Indicate success with zero.
                EventFactory.newNonDetChoice(errorRegister),
                EventFactory.newAssume(expressions.makeEQ(successResult, expressions.makeEQ(errorRegister, success)))
        );
    }

    private Event newRwlockTryRdlock(Register oldValueAndSuccess, Expression lockAddress, Expression expected) {
        final Expression wasUnlocked = expressions.makeEQ(expected, getRwlockUnlockedValue());
        final Expression lockedOnce = expressions.makeValue(BigInteger.TWO, getRwlockDatatype());
        final Expression lockedMore = expressions.makeAdd(expected, expressions.makeOne(getRwlockDatatype()));
        final Expression locked = expressions.makeITE(wasUnlocked, lockedOnce, lockedMore);
        return Llvm.newCompareExchange(oldValueAndSuccess, lockAddress, expected, locked, Tag.C11.MO_ACQUIRE, true);
    }

    private List<Event> inlinePthreadRwlockUnlock(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_rwlock_unlock
        final Register errorRegister = getResultRegisterAndCheckArguments(1, call);
        final Register oldValueRegister = call.getFunction().newRegister(getRwlockDatatype());
        final Register decrementRegister = call.getFunction().newRegister(getRwlockDatatype());
        final Expression lockAddress = call.getArguments().get(0);
        final Expression one = expressions.makeOne(getRwlockDatatype());
        final Expression two = expressions.makeValue(BigInteger.TWO, getRwlockDatatype());
        final Expression lastReader = expressions.makeEQ(oldValueRegister, two);
        final Expression properDecrement = expressions.makeITE(lastReader, two, one);
        //TODO does not recognize whether the calling thread is allowed to unlock
        return List.of(
                // decreases the lock value by 1, if not the last reader, or else 2.
                EventFactory.newNonDetChoice(decrementRegister),
                EventFactory.Llvm.newRMW(oldValueRegister, lockAddress, decrementRegister, IntBinaryOp.SUB, Tag.C11.MO_RELEASE),
                EventFactory.newAssume(expressions.makeEQ(decrementRegister, properDecrement)),
                assignSuccess(errorRegister)
        );
    }

    private IntegerType getRwlockDatatype() {
        return types.getArchType();
    }

    private IntLiteral getRwlockUnlockedValue() {
        //FIXME this assumes that the lock is initialized with pthread_rwlock_init,
        // but some programs may explicitly initialize it with other platform-dependent values.
        return expressions.makeZero(getRwlockDatatype());
    }

    private IntLiteral getRwlockWriteLockedValue() {
        return expressions.makeOne(getRwlockDatatype());
    }

    private List<Event> inlinePthreadRwlockAttr(FunctionCall call) {
        final String suffix = call.getCalledFunction().getName().substring("pthread_rwlockattr_".length());
        final boolean init = suffix.equals("init");
        final boolean destroy = suffix.equals("destroy");
        final Register errorRegister = getResultRegisterAndCheckArguments(init || destroy ? 1 : 2, call);
        final Expression attrAddress = call.getArguments().get(0);
        if (init || destroy) {
            return List.of(
                    newStore(attrAddress, expressions.makeValue(init)),
                    assignSuccess(errorRegister)
            );
        }
        final boolean get = suffix.startsWith("get");
        checkUnknownIntrinsic(get || suffix.startsWith("set"), call);
        checkUnknownIntrinsic(P_THREAD_RWLOCK_ATTR.contains(suffix.substring(3)), call);
        return List.of(
                assignSuccess(errorRegister)
        );
    }

    private List<Event> inlinePthreadOnce(FunctionCall call) {
        final Register resultRegister = getResultRegisterAndCheckArguments(2, call);
        final Expression controlAddress = call.getArguments().get(0);
        final Expression initRoutine = call.getArguments().get(1);

        final IntegerType stateType = getNativeIntType();
        final Expression uninitialized = expressions.makeZero(stateType);
        final Expression running = expressions.makeOne(stateType);
        final Expression complete = expressions.makeValue(2, stateType);
        final Type stateAndSuccessType = types.getAggregateType(List.of(stateType, types.getBooleanType()));
        final Register stateAndSuccess = call.getFunction().newUniqueRegister("__pthread_once", stateAndSuccessType);
        final Register state = call.getFunction().newUniqueRegister("__pthread_once_state", stateType);

        final Label wait = newLabel("__pthread_once_wait");
        final Label runRoutine = newLabel("__pthread_once_run_routine");
        final Label end = newLabel("__pthread_once_end");
        final FunctionType initRoutineType = types.getFunctionType(types.getVoidType(), List.of());

        return eventSequence(
                Llvm.newCompareExchange(stateAndSuccess, controlAddress, uninitialized, running,
                        Tag.C11.MO_ACQUIRE, true),
                newJump(expressions.makeExtract(stateAndSuccess, 1), runRoutine),
                wait,
                Llvm.newLoad(state, controlAddress, Tag.C11.MO_ACQUIRE),
                newJump(expressions.makeEQ(state, complete), end),
                newGoto(wait),
                runRoutine,
                newVoidFunctionCall(initRoutineType, initRoutine, List.of()),
                Llvm.newStore(controlAddress, complete, Tag.C11.MO_RELEASE),
                end,
                assignSuccess(resultRegister)
        );
    }


    // ====================================================================
    private IntegerType getNativeIntType() {
        return types.getIntegerType(32);
    }

    private Event assignPosixError(Register errorRegister, PosixErrorCode code) {
        final Expression value = expressions.makeValue(code.getValue(), (IntegerType) errorRegister.getType());
        return EventFactory.newLocal(errorRegister, value);
    }

    private Event assignSuccess(Register errorRegister) {
        return EventFactory.newLocal(errorRegister, expressions.makeGeneralZero(errorRegister.getType()));
    }

    private void checkUnknownIntrinsic(boolean condition, FunctionCall call) {
        checkArgument(condition, "Unknown intrinsic \"%s\"", call);
    }

}
