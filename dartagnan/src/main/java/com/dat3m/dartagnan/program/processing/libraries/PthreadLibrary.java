package com.dat3m.dartagnan.program.processing.libraries;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.integers.IntBinaryOp;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.type.FunctionType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.event.functions.FunctionCall;
import com.dat3m.dartagnan.program.processing.Intrinsics;
import com.dat3m.dartagnan.program.processing.ThreadCreation;
import com.dat3m.dartagnan.utils.OperatingSystem;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
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
import static com.dat3m.dartagnan.program.processing.libraries.CLibImplementation.*;
import static com.google.common.base.Preconditions.checkArgument;

@Options
public class PthreadLibrary extends AbstractLibrary<PthreadLibrary> {

    public enum SupportedFunctions {
        // --------------------------- pthread threading ---------------------------
        P_THREAD_CREATE("pthread_create", PthreadLibrary::inlinePthreadCreate),
        P_THREAD_EXIT("pthread_exit", PthreadLibrary::inlinePthreadExit),
        P_THREAD_JOIN(List.of("pthread_join", "_pthread_join", "__pthread_join"), PthreadLibrary::inlinePthreadJoin),
        P_THREAD_DETACH("pthread_detach", PthreadLibrary::inlinePthreadDetach),
        // TODO: This is a "late intrinsic" still handled by the Intrinsics pass for now
        // P_THREAD_SELF(List.of("pthread_self", "__VERIFIER_tid"), ...),
        P_THREAD_EQUAL("pthread_equal", PthreadLibrary::inlinePthreadEqual),
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
        // --------------------------- pthread barrier ---------------------------
        P_THREAD_BARRIER_INIT("pthread_barrier_init", PthreadLibrary::inlinePthreadBarrierInit),
        P_THREAD_BARRIER_DESTROY("pthread_barrier_destroy", PthreadLibrary::inlinePthreadBarrierDestroy),
        P_THREAD_BARRIER_WAIT("pthread_barrier_wait", PthreadLibrary::inlinePthreadBarrierWait),
        P_THREAD_BARRIERATTR(List.of("pthread_barrierattr_init", "pthread_barrierattr_destroy",
                "pthread_barrierattr_setpshared"), PthreadLibrary::inlinePthreadBarrierAttr),
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

    private static final Logger logger = LoggerFactory.getLogger(PthreadLibrary.class);

    @Option(name = THREAD_CREATE_ALWAYS_SUCCEEDS,
            description = "Calling pthread_create is guaranteed to succeed (default true).",
            secure = true,
            toUppercase = true)
    private boolean pthreadCreateAlwaysSucceeds = true;

    // TODO: Once we need this in other libraries (stdlib?), we need to move the clib code
    //  into a unifying location (maybe have a root CLibrary with sublibraries like pthread).
    private CLibImplementation clib = null;

    private IntegerType archType;
    private Type pointerType;
    private FunctionType threadType;
    private Function pthreadSelf;

    public PthreadLibrary(Configuration config) throws InvalidConfigurationException {
        super(config);
        config.inject(this);
    }

    @Override
    protected PthreadLibrary getThis() {
        return this;
    }

    @Override
    protected Optional<? extends Handler<PthreadLibrary>> getHandler(Function func) {
        final String funcName = func.getName();
        return Arrays.stream(SupportedFunctions.values())
                .filter(f -> f.matches(funcName))
                .map(f -> f.handler)
                .findFirst();
    }

    @Override
    public void link(Program program) {
        if (program.getFormat() != Program.SourceLanguage.LLVM) {
            // Only link against LLVM code
            return;
        }
        clib = deriveClibFromProgram(program);
        archType = program.getArchType();
        pointerType = program.getPointerType();
        threadType = types.getFunctionType(program.getPointerType(), List.of(program.getPointerType()));
        pthreadSelf = getOrDeclarePthreadSelf(program);
        logger.info("Linking pthread library matching {}", clib);
        super.link(program);
    }

    // pthread_self is resolved late (after thread creation), so we call it rather than inline it.
    private Function getOrDeclarePthreadSelf(Program program) {
        return program.getFunctionByName("pthread_self").orElseGet(() -> {
            final int id = program.getFunctions().stream().mapToInt(Function::getId).max().orElse(0) + 1;
            final Function function = new Function("pthread_self", types.getFunctionType(archType, List.of()),
                    List.of(), id, null);
            function.setIntrinsicInfo(Intrinsics.Info.P_THREAD_SELF);
            program.addFunction(function);
            return function;
        });
    }

    private static CLibImplementation deriveClibFromProgram(Program program) {
        final Program.TargetSystem targetSystem = program.getMetadata(Program.TargetSystem.class);
        final OperatingSystem os = targetSystem != null ? targetSystem.operatingSystem() : OperatingSystem.OTHER;

        return switch (os) {
            case LINUX -> GLIBC;
            case MACOS -> DARWIN_LIBC;
            case WINDOWS -> MINGW;
            case OTHER -> {
                logger.warn("Could not derive the Clib the program was compiled against; defaulting to {}. ", GLIBC);
                yield GLIBC;
            }
        };
    }

    // ========================================================================================

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

        final Register tidReg = call.getFunction().newUniqueRegister("__tid", archType);
        final Event createEvent = newDynamicThreadCreate(tidReg, pidResultAddress, threadType, targetFunction,
                List.of(argument));
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
                // Finally, return the status.
                // NOTE: The thread id is stored by the create event itself, before the thread is spawned (as in glibc),
                // so that threads synchronizing with the spawned thread observe it.
                skipAttrLabel,
                // TODO: Allow to return failure value (!= 0)
                newLocal(resultRegister, expressions.makeGeneralZero(resultRegister.getType())),
                newGoto(endOfPthreadCreate),
                // ----- FAIL -----
                pthreadFailCase,
                assignPosixError(resultRegister, PosixErrorCode.EAGAIN),
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

        final Type joinType = types.getAggregateType(List.of(types.getByteType(), threadType.getReturnType()));
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
                newLocal(statusRegister, internalThreadErrorToPosixErrorCode(status, statusType)),
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
        final Register internalStatus = call.getFunction().newUniqueRegister("__pthread_detach_status", statusType);

        final Expression statusInvalidTId = expressions.makeValue(INVALID_TID.getErrorCode(), statusType);

        return eventSequence(
                newDynamicThreadDetach(internalStatus, tidExpr),
                newAssert(expressions.makeNEQ(internalStatus, statusInvalidTId), "Invalid thread id in pthread_detach."),
                newLocal(statusRegister, internalThreadErrorToPosixErrorCode(internalStatus, statusType))
        );
    }

    // Translates the internal status of DynamicThreadJoin/DynamicThreadDetach into a POSIX error code.
    private Expression internalThreadErrorToPosixErrorCode(Expression internalStatus, IntegerType resultType) {
        final IntegerType internalType = (IntegerType) internalStatus.getType();
        final Expression isSuccess = expressions.makeEQ(internalStatus, expressions.makeValue(SUCCESS.getErrorCode(), internalType));
        final Expression isInvalidTid = expressions.makeEQ(internalStatus, expressions.makeValue(INVALID_TID.getErrorCode(), internalType));
        // INVALID_RETURN_TYPE and DETACHED_THREAD both map to EINVAL ("thread is not joinable" / no better match).
        return expressions.makeITE(isSuccess, expressions.makeGeneralZero(resultType),
                expressions.makeITE(isInvalidTid, makePosixError(PosixErrorCode.ESRCH, resultType),
                        makePosixError(PosixErrorCode.EINVAL, resultType)));
    }

    private List<Event> inlinePthreadExit(FunctionCall call) {
        final List<Expression> arguments = call.getArguments();
        assert arguments.size() == 1 && arguments.get(0).getType().equals(threadType.getReturnType());

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

    private enum PthreadDetachStateValue {
        JOINABLE(0, 1, 0),
        DETACHED(1, 2, 4);

        final int valGlibc;
        final int valDarwinLibc;
        final int valMingw;
        PthreadDetachStateValue(int valGlibc, int valDarwinLibc, int valMingw) {
            this.valGlibc = valGlibc;
            this.valDarwinLibc = valDarwinLibc;
            this.valMingw = valMingw;
        }

        int value(CLibImplementation clib) {
            return switch (clib) {
                case GLIBC -> valGlibc;
                case DARWIN_LIBC -> valDarwinLibc;
                case MINGW -> valMingw;
            };
        }
    }

    private PthreadAttrImplementation inlinePthreadAttrDetachState(Expression oldValue, Expression detachstate,
                                                                              Label returnEINVAL) {
        // POSIX defines these two named constants of type int, but their values are platform-specific.
        // see https://pubs.opengroup.org/onlinepubs/9799919799/basedefs/pthread.h.html
        final int PTHREAD_CREATE_DETACHED = PthreadDetachStateValue.DETACHED.value(clib);
        final int PTHREAD_CREATE_JOINABLE = PthreadDetachStateValue.JOINABLE.value(clib);
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
        return newCondWait(call, call.getArguments().get(1), errorRegister, null);
    }

    private List<Event> inlinePthreadCondTimedwait(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_cond_timedwait
        final Register errorRegister = getResultRegisterAndCheckArguments(3, call);
        //final Expression condAddress = call.getArguments().get(0);
        //final Expression timespec = call.getArguments().get(2);
        return newCondWait(call, call.getArguments().get(1), errorRegister, PosixErrorCode.ETIMEDOUT);
    }

    // Unlocks the mutex, waits, and locks it again. Since signals are not modeled, waking up is always possible.
    // Fails with EPERM if the caller may not unlock the mutex.
    private List<Event> newCondWait(FunctionCall call, Expression mutex, Register errorRegister, PosixErrorCode wakeUp) {
        final Register permitted = call.getFunction().newUniqueRegister("__pthread_cond_permitted", types.getBooleanType());
        final Label error = newLabel("__pthread_cond_wait_error");
        final Label end = newLabel("__pthread_cond_wait_end");
        return eventSequence(
                newMutexUnlock(call, mutex, permitted),
                newJumpUnless(permitted, error),
                newMutexLock(call, mutex, null),
                wakeUp == null ? assignSuccess(errorRegister) : assignPosixError(errorRegister, wakeUp),
                newGoto(end),
                error,
                assignPosixError(errorRegister, PosixErrorCode.EPERM),
                end
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
        final Register success = call.getFunction().newUniqueRegister("__pthread_setspecific_success", types.getBooleanType());
        return List.of(
                newDynamicThreadLocalSet(success, key, value),
                assignSuccessOrPosixError(errorRegister, success, PosixErrorCode.EINVAL)
        );
    }

    // ----- Mutexes -----
    // The lock word holds the owner (thread id + 1, 0 means unlocked) and a recursive mutex counts the additional
    // locks of its owner. Fields are kept where the C library keeps them, so that static initializers work:
    // - glibc: lock word, count, and type at the offsets of __lock (0), __count (4), and __kind (16, or 12 on 32-bit).
    // - Darwin: the type is given by __sig (0), the lock word and count are at offsets 8 and 12.
    // - MinGW: pthread_mutex_t is a single word, so it only holds the lock word and cannot be recursive.

    private static final List<String> P_THREAD_MUTEXATTR = List.of(
            "prioceiling",
            "protocol",
            "type"
    );

    private enum PthreadMutexTypeValue {
        NORMAL(0, 0, 0),
        RECURSIVE(1, 2, 2),
        ERRORCHECK(2, 1, 1);

        final int valGlibc;
        final int valDarwinLibc;
        final int valMingw;
        PthreadMutexTypeValue(int valGlibc, int valDarwinLibc, int valMingw) {
            this.valGlibc = valGlibc;
            this.valDarwinLibc = valDarwinLibc;
            this.valMingw = valMingw;
        }

        int value(CLibImplementation clib) {
            return switch (clib) {
                case GLIBC -> valGlibc;
                case DARWIN_LIBC -> valDarwinLibc;
                case MINGW -> valMingw;
            };
        }
    }

    // Values of Darwin's __sig set by the static initializers.
    private static final long DARWIN_MUTEX_SIG = 0x32AAABA7L;
    private static final long DARWIN_ERRORCHECK_MUTEX_SIG = 0x32AAABA1L;
    private static final long DARWIN_RECURSIVE_MUTEX_SIG = 0x32AAABA2L;

    private List<Event> inlinePthreadMutexInit(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_mutex_init
        final Register errorRegister = getResultRegisterAndCheckArguments(2, call);
        final Expression mutex = call.getArguments().get(0);
        final Expression attributes = call.getArguments().get(1);
        final Register type = call.getFunction().newUniqueRegister("__pthread_mutex_type", getMutexWordType());
        final Label noAttributes = newLabel("__pthread_mutex_init_no_attr");
        return eventSequence(
                newLocal(type, getMutexTypeValue(PthreadMutexTypeValue.NORMAL)),
                newJump(expressions.makeEQ(attributes, expressions.makeGeneralZero(attributes.getType())), noAttributes),
                newLoad(type, attributes),
                noAttributes,
                newStoreMutexType(mutex, type),
                Llvm.newStore(getMutexLockWord(mutex), expressions.makeZero(getMutexWordType()), Tag.C11.MO_RELEASE),
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
        return eventSequence(
                newMutexLock(call, call.getArguments().get(0), null),
                assignSuccess(errorRegister)
        );
    }

    private List<Event> inlinePthreadMutexTryLock(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_mutex_trylock
        final Register errorRegister = getResultRegisterAndCheckArguments(1, call);
        final Register acquired = call.getFunction().newUniqueRegister("__pthread_mutex_acquired", types.getBooleanType());
        return eventSequence(
                newMutexLock(call, call.getArguments().get(0), acquired),
                assignSuccessOrPosixError(errorRegister, acquired, PosixErrorCode.EBUSY)
        );
    }

    private List<Event> inlinePthreadMutexUnlock(FunctionCall call) {
        //see https://linux.die.net/man/3/pthread_mutex_unlock
        final Register errorRegister = getResultRegisterAndCheckArguments(1, call);
        final Register permitted = call.getFunction().newUniqueRegister("__pthread_mutex_permitted", types.getBooleanType());
        return eventSequence(
                newMutexUnlock(call, call.getArguments().get(0), permitted),
                assignSuccessOrPosixError(errorRegister, permitted, PosixErrorCode.EPERM)
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
        checkUnknownIntrinsic(init || destroy || (suffix.startsWith("get") || suffix.startsWith("set"))
                && P_THREAD_MUTEXATTR.contains(suffix.substring(3)), call);
        // The attributes only hold the mutex type.
        final Expression attributes = call.getArguments().get(0);
        final Register type = call.getFunction().newUniqueRegister("__pthread_mutexattr_type", getMutexWordType());
        return eventSequence(
                switch (suffix) {
                    case "init" -> newStore(attributes, getMutexTypeValue(PthreadMutexTypeValue.NORMAL));
                    case "settype" -> newStore(attributes,
                            expressions.makeIntegerCast(call.getArguments().get(1), getMutexWordType(), true));
                    case "gettype" -> List.of(newLoad(type, attributes), newStore(call.getArguments().get(1), type));
                    default -> null;
                },
                assignSuccess(errorRegister)
        );
    }

    private IntegerType getMutexWordType() {
        return getNativeIntType();
    }

    private Expression getMutexTypeValue(PthreadMutexTypeValue type) {
        return expressions.makeValue(type.value(clib), getMutexWordType());
    }

    private Expression getMutexField(Expression mutex, int offset) {
        return expressions.makeGetElementPointer(types.getByteType(), mutex,
                List.of(expressions.makeValue(offset, archType)));
    }

    private Expression getMutexLockWord(Expression mutex) {
        return clib == DARWIN_LIBC ? getMutexField(mutex, 8) : mutex;
    }

    private Expression getMutexCount(Expression mutex) {
        return getMutexField(mutex, clib == DARWIN_LIBC ? 12 : 4);
    }

    private Expression getGlibcMutexKind(Expression mutex) {
        return getMutexField(mutex, archType.getBitWidth() == 64 ? 16 : 12);
    }

    // Stores the type of a mutex and resets its count.
    private List<Event> newStoreMutexType(Expression mutex, Expression type) {
        final Expression zero = expressions.makeZero(getMutexWordType());
        final Expression isRecursive = expressions.makeEQ(type, getMutexTypeValue(PthreadMutexTypeValue.RECURSIVE));
        return switch (clib) {
            case GLIBC -> List.of(newStore(getMutexCount(mutex), zero), newStore(getGlibcMutexKind(mutex), type));
            case DARWIN_LIBC -> List.of(newStore(getMutexCount(mutex), zero), newStore(mutex, expressions.makeITE(
                    isRecursive,
                    expressions.makeValue(DARWIN_RECURSIVE_MUTEX_SIG, archType),
                    expressions.makeITE(
                            expressions.makeEQ(type, getMutexTypeValue(PthreadMutexTypeValue.ERRORCHECK)),
                            expressions.makeValue(DARWIN_ERRORCHECK_MUTEX_SIG, archType),
                            expressions.makeValue(DARWIN_MUTEX_SIG, archType)))));
            // FIXME: We add the "unknown function" suffix only to satisfy Svcomp/BenchExec
            case MINGW -> inlineAssert(expressions.makeNot(isRecursive), true, AssertionType.UNKNOWN_FUNCTION,
                    "Recursive mutexes are unsupported. #unknown function");
        };
    }

    private Expression newLoadIsRecursive(FunctionCall call, Expression mutex, List<Event> events) {
        return switch (clib) {
            case GLIBC -> {
                final Register kind = call.getFunction().newUniqueRegister("__pthread_mutex_kind", getMutexWordType());
                events.add(newLoad(kind, getGlibcMutexKind(mutex)));
                yield expressions.makeEQ(kind, getMutexTypeValue(PthreadMutexTypeValue.RECURSIVE));
            }
            case DARWIN_LIBC -> {
                final Register signature = call.getFunction().newUniqueRegister("__pthread_mutex_sig", archType);
                events.add(newLoad(signature, mutex));
                yield expressions.makeEQ(signature, expressions.makeValue(DARWIN_RECURSIVE_MUTEX_SIG, archType));
            }
            case MINGW -> expressions.makeFalse();
        };
    }

    // The lock word of a mutex owned by the caller.
    private Expression newLoadSelf(FunctionCall call, List<Event> events) {
        final IntegerType type = getMutexWordType();
        final Register tid = call.getFunction().newUniqueRegister("__pthread_mutex_self", archType);
        events.add(newValueFunctionCall(tid, pthreadSelf, List.of()));
        return expressions.makeAdd(expressions.makeIntegerCast(tid, type, false), expressions.makeOne(type));
    }

    // Locks the mutex (pthread_mutex_lock) or, if 'acquired' is given, tries to (pthread_mutex_trylock).
    // The owner of a recursive mutex locks it again.
    private List<Event> newMutexLock(FunctionCall call, Expression mutex, Register acquired) {
        final Function caller = call.getFunction();
        final IntegerType type = getMutexWordType();
        final Register owner = caller.newUniqueRegister("__pthread_mutex_owner", type);
        final Register count = caller.newUniqueRegister("__pthread_mutex_count", type);
        final Register oldValueAndSuccess = caller.newUniqueRegister("__pthread_mutex_lock",
                types.getAggregateType(List.of(type, types.getBooleanType())));
        final Expression lockWord = getMutexLockWord(mutex);
        final List<Event> events = new ArrayList<>();
        final Expression self = newLoadSelf(call, events);
        final Expression isRecursive = newLoadIsRecursive(call, mutex, events);
        final Expression success = expressions.makeExtract(oldValueAndSuccess, 1);
        final Label acquire = newLabel("__pthread_mutex_acquire");
        final Label end = newLabel("__pthread_mutex_lock_end");
        // A lock is a CAS-spinlock, a trylock a single CAS.
        final boolean blocking = acquired == null;
        final Label spin = blocking ? newLabel("__spinloop_head") : null;
        return eventSequence(
                events,
                newJump(expressions.makeNot(isRecursive), acquire),
                Llvm.newLoad(owner, lockWord, Tag.C11.MO_RELAXED),
                newJump(expressions.makeNEQ(owner, self), acquire),
                newLoad(count, getMutexCount(mutex)),
                newStore(getMutexCount(mutex), expressions.makeAdd(count, expressions.makeOne(type))),
                blocking ? null : newLocal(acquired, expressions.makeTrue()),
                newGoto(end),
                acquire,
                blocking ? newLoopBound(expressions.makeOne(types.getIntegerType(32))) : null,
                spin,
                Llvm.newCompareExchange(oldValueAndSuccess, lockWord, expressions.makeZero(type), self,
                        Tag.C11.MO_ACQUIRE, true),
                blocking ? newJumpUnless(success, spin) : newLocal(acquired, success),
                end
        );
    }

    // Unlocks the mutex and sets 'permitted' to whether the caller may unlock it
    // (only the owner can unlock a recursive mutex, which is released by its last unlock).
    private List<Event> newMutexUnlock(FunctionCall call, Expression mutex, Register permitted) {
        final Function caller = call.getFunction();
        final IntegerType type = getMutexWordType();
        final Register owner = caller.newUniqueRegister("__pthread_mutex_owner", type);
        final Register count = caller.newUniqueRegister("__pthread_mutex_count", type);
        final Expression lockWord = getMutexLockWord(mutex);
        final Expression unlocked = expressions.makeZero(type);
        final boolean checkLocked = !notToInline.contains(AssertionType.USER);
        final List<Event> events = new ArrayList<>();
        final Expression self = newLoadSelf(call, events);
        final Expression isRecursive = newLoadIsRecursive(call, mutex, events);
        final Label release = newLabel("__pthread_mutex_release");
        final Label notOwner = newLabel("__pthread_mutex_not_owner");
        final Label end = newLabel("__pthread_mutex_unlock_end");
        return eventSequence(
                events,
                Llvm.newLoad(owner, lockWord, Tag.C11.MO_RELAXED),
                newJump(expressions.makeNot(isRecursive), release),
                newJump(expressions.makeNEQ(owner, self), notOwner),
                newLoad(count, getMutexCount(mutex)),
                newJump(expressions.makeEQ(count, expressions.makeZero(type)), release),
                newStore(getMutexCount(mutex), expressions.makeSub(count, expressions.makeOne(type))),
                newLocal(permitted, expressions.makeTrue()),
                newGoto(end),
                notOwner,
                // Like for other mutexes, unlocking a recursive mutex that the caller does not own is a bug.
                checkLocked ? newAssert(expressions.makeNEQ(owner, unlocked), ALREADY_UNLOCKED) : null,
                checkLocked ? newAssert(expressions.makeEQ(owner, unlocked), "Unlocking a mutex owned by another thread") : null,
                newLocal(permitted, expressions.makeFalse()),
                newGoto(end),
                release,
                checkLocked ? newAssert(expressions.makeNEQ(owner, unlocked), ALREADY_UNLOCKED) : null,
                Llvm.newStore(lockWord, unlocked, Tag.C11.MO_RELEASE),
                newLocal(permitted, expressions.makeTrue()),
                end
        );
    }

    private static final String ALREADY_UNLOCKED = "Unlocking an already unlocked mutex";

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
        final Expression successResult = expressions.makeExtract(oldValueAndSuccess, 1);
        return List.of(
                // Write-lock only if unlocked.
                newRwlockTryWrlock(oldValueAndSuccess, lockAddress),
                // Indicate success by returning zero, and failure by returning EBUSY.
                assignSuccessOrPosixError(errorRegister, successResult, PosixErrorCode.EBUSY)
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
                // Indicate success with zero, and failure with EBUSY.
                assignSuccessOrPosixError(errorRegister, successResult, PosixErrorCode.EBUSY)
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
        return archType;
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

    // see _PTHREAD_ONCE_SIG_init in Darwin's sys/_pthread/_pthread_types.h
    private static final long DARWIN_PTHREAD_ONCE_SIG_INIT = 0x30B1BCBAL;

    private List<Event> inlinePthreadOnce(FunctionCall call) {
        final Register resultRegister = getResultRegisterAndCheckArguments(2, call);
        final Expression controlAddress = call.getArguments().get(0);
        final Expression initRoutine = call.getArguments().get(1);

        // PTHREAD_ONCE_INIT is platform-specific:
        //  - glibc and MinGW (winpthreads): pthread_once_t is an int (long on MinGW, which is 32-bit), initialized to 0.
        //  - Darwin libc: pthread_once_t is a struct { long __sig; char __opaque[8]; },
        //    initialized to { _PTHREAD_ONCE_SIG_init, {0} }.
        // The states 'running' and 'complete' are internal to our model and only have to differ from 'uninitialized'.
        final IntegerType stateType = switch (clib) {
            case GLIBC, MINGW -> getNativeIntType();
            case DARWIN_LIBC -> types.getIntegerType(64);
        };
        final Expression uninitialized = switch (clib) {
            case GLIBC, MINGW -> expressions.makeZero(stateType);
            case DARWIN_LIBC -> expressions.makeValue(DARWIN_PTHREAD_ONCE_SIG_INIT, stateType);
        };
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
    // Barriers
    // ====================================================================

    // The barrier state consists of three 32-bit counters: the number of arrivals (tickets), the number of
    // completed phases, and the number of threads required per phase. Ticket t belongs to phase t / required.
    // The thread taking the last ticket of a phase completes it; the others spin until the phase is completed.
    // Since nothing is reset, callers of the next phase cannot pass with the current one.
    // glibc keeps the state in pthread_barrier_t, MinGW only has a pointer to it (allocated by init).
    private static final int BARRIER_TICKETS_OFFSET = 0;
    private static final int BARRIER_COMPLETED_OFFSET = 4;
    private static final int BARRIER_REQUIRED_OFFSET = 8;
    private static final int BARRIER_STATE_SIZE = 12;

    private boolean isBarrierStateInPlace() {
        return clib == GLIBC;
    }

    private int getPthreadBarrierSerialThread() {
        return switch (clib) {
            case GLIBC, DARWIN_LIBC -> -1;
            case MINGW -> 1;
        };
    }

    private Expression getBarrierField(Expression state, int offset) {
        final Expression byteOffset = expressions.makeValue(offset, archType);
        return expressions.makeGetElementPointer(types.getByteType(), state, List.of(byteOffset));
    }

    // Returns the address of the barrier state, which may need to be loaded from the barrier.
    private Expression newLoadBarrierState(FunctionCall call, Expression barrierAddress, List<Event> events) {
        if (isBarrierStateInPlace()) {
            return barrierAddress;
        }
        final Register state = call.getFunction().newUniqueRegister("__pthread_barrier_state", pointerType);
        events.add(newLoad(state, barrierAddress));
        return state;
    }

    private List<Event> inlinePthreadBarrierInit(FunctionCall call) {
        //see https://man7.org/linux/man-pages/man3/pthread_barrier_init.3p.html
        final Register errorRegister = getResultRegisterAndCheckArguments(3, call);
        final Expression barrierAddress = call.getArguments().get(0);
        // The attributes (argument 1) only control process-sharing, which we do not model.
        final IntegerType counterType = getNativeIntType();
        final Expression required = expressions.makeIntegerCast(call.getArguments().get(2), counterType, false);
        final Expression zero = expressions.makeZero(counterType);
        // glibc also rejects counts that do not fit into an int.
        final Expression fitsInt = expressions.makeLTE(required,
                expressions.makeValue(Integer.MAX_VALUE, counterType), false);
        final Expression isValid = expressions.makeAnd(expressions.makeNEQ(required, zero),
                clib == GLIBC ? fitsInt : expressions.makeTrue());
        final Label invalid = newLabel("__pthread_barrier_init_invalid");
        final Label end = newLabel("__pthread_barrier_init_end");
        Expression state = barrierAddress;
        Register allocatedState = null;
        if (!isBarrierStateInPlace()) {
            allocatedState = call.getFunction().newUniqueRegister("__pthread_barrier_state", pointerType);
            state = allocatedState;
        }
        return eventSequence(
                newJumpUnless(isValid, invalid),
                allocatedState == null ? null : List.of(
                        newAlloc(allocatedState, types.getByteType(),
                                expressions.makeValue(BARRIER_STATE_SIZE, archType), true, false),
                        newStore(barrierAddress, allocatedState)),
                newStore(getBarrierField(state, BARRIER_TICKETS_OFFSET), zero),
                newStore(getBarrierField(state, BARRIER_COMPLETED_OFFSET), zero),
                newStore(getBarrierField(state, BARRIER_REQUIRED_OFFSET), required),
                assignSuccess(errorRegister),
                newGoto(end),
                invalid,
                assignPosixError(errorRegister, PosixErrorCode.EINVAL),
                end
        );
    }

    private List<Event> inlinePthreadBarrierDestroy(FunctionCall call) {
        //see https://man7.org/linux/man-pages/man3/pthread_barrier_destroy.3p.html
        final Register errorRegister = getResultRegisterAndCheckArguments(1, call);
        if (isBarrierStateInPlace()) {
            return List.of(assignSuccess(errorRegister));
        }
        final List<Event> events = new ArrayList<>();
        events.add(newDealloc(newLoadBarrierState(call, call.getArguments().get(0), events)));
        events.add(assignSuccess(errorRegister));
        return events;
    }

    private List<Event> inlinePthreadBarrierWait(FunctionCall call) {
        //see https://man7.org/linux/man-pages/man3/pthread_barrier_wait.3p.html
        final Register resultRegister = getResultRegisterAndCheckArguments(1, call);
        checkArgument(resultRegister.getType() instanceof IntegerType, "Wrong return type for \"%s\"", call);
        final IntegerType resultType = (IntegerType) resultRegister.getType();
        final IntegerType counterType = getNativeIntType();
        final Function caller = call.getFunction();
        final Register required = caller.newUniqueRegister("__pthread_barrier_required", counterType);
        final Register ticket = caller.newUniqueRegister("__pthread_barrier_ticket", counterType);
        final Register completed = caller.newUniqueRegister("__pthread_barrier_completed", counterType);
        final Register ignored = caller.newUniqueRegister("__pthread_barrier_ignored", counterType);

        final List<Event> events = new ArrayList<>();
        final Expression state = newLoadBarrierState(call, call.getArguments().get(0), events);
        final Expression completedAddress = getBarrierField(state, BARRIER_COMPLETED_OFFSET);
        final Expression one = expressions.makeOne(counterType);
        final Expression phase = expressions.makeDiv(ticket, required, false);
        final Expression isLast = expressions.makeEQ(expressions.makeRem(ticket, required, false),
                expressions.makeSub(required, one));
        final Expression isPhaseCompleted = expressions.makeGT(completed, phase, false);

        final Label wait = newLabel("__pthread_barrier_wait");
        final Label last = newLabel("__pthread_barrier_last");
        final Label end = newLabel("__pthread_barrier_end");
        events.addAll(eventSequence(
                newLoad(required, getBarrierField(state, BARRIER_REQUIRED_OFFSET)),
                Llvm.newRMW(ticket, getBarrierField(state, BARRIER_TICKETS_OFFSET), one, IntBinaryOp.ADD,
                        Tag.C11.MO_ACQUIRE_RELEASE),
                newJump(isLast, last),
                wait,
                Llvm.newLoad(completed, completedAddress, Tag.C11.MO_ACQUIRE),
                newJump(expressions.makeNot(isPhaseCompleted), wait),
                newLocal(resultRegister, expressions.makeZero(resultType)),
                newGoto(end),
                last,
                Llvm.newRMW(ignored, completedAddress, one, IntBinaryOp.ADD, Tag.C11.MO_RELEASE),
                newLocal(resultRegister, expressions.makeValue(getPthreadBarrierSerialThread(), resultType)),
                end
        ));
        return events;
    }

    private List<Event> inlinePthreadBarrierAttr(FunctionCall call) {
        //see https://man7.org/linux/man-pages/man3/pthread_barrierattr_init.3p.html
        // Process-sharing is not modeled, so the attributes have no effect.
        final String suffix = call.getCalledFunction().getName().substring("pthread_barrierattr_".length());
        final Register errorRegister = getResultRegisterAndCheckArguments(suffix.equals("setpshared") ? 2 : 1, call);
        return List.of(assignSuccess(errorRegister));
    }

    // ====================================================================
    private IntegerType getNativeIntType() {
        return types.getIntegerType(32);
    }

    private Expression makePosixError(PosixErrorCode code, IntegerType type) {
        return expressions.makeValue(code.getValue(clib), type);
    }

    private Event assignPosixError(Register errorRegister, PosixErrorCode code) {
        return EventFactory.newLocal(errorRegister, makePosixError(code, (IntegerType) errorRegister.getType()));
    }

    private Event assignSuccessOrPosixError(Register errorRegister, Expression success, PosixErrorCode code) {
        final IntegerType type = (IntegerType) errorRegister.getType();
        final Expression value = expressions.makeITE(success, expressions.makeGeneralZero(type), makePosixError(code, type));
        return EventFactory.newLocal(errorRegister, value);
    }

    private Event assignSuccess(Register errorRegister) {
        return EventFactory.newLocal(errorRegister, expressions.makeGeneralZero(errorRegister.getType()));
    }

    private void checkUnknownIntrinsic(boolean condition, FunctionCall call) {
        checkArgument(condition, "Unknown intrinsic \"%s\"", call);
    }

}
