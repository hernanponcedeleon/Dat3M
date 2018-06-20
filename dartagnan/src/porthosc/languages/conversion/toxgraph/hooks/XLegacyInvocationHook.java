package porthosc.languages.conversion.toxgraph.hooks;

import com.google.common.collect.ImmutableList;
import porthosc.languages.conversion.toxgraph.interpretation.XProgramInterpreter;
import porthosc.languages.syntax.xgraph.events.barrier.XBarrierEvent;
import porthosc.languages.syntax.xgraph.events.memory.XSharedMemoryEvent;
import porthosc.languages.syntax.xgraph.memories.*;
import porthosc.memorymodels.wmm.MemoryModel;
import porthosc.utils.exceptions.NotImplementedException;
import porthosc.utils.exceptions.xgraph.XMethodInvocationError;

import static porthosc.utils.StringUtils.wrap;


class XLegacyInvocationHook extends XInvocationHookBase implements XInvocationHook {


    // FOR DEBUG ONLY: THIS MUST BE A TYPE-CHECK! For now, the code is just a map from the old code.
    private final ImmutableList<String> valid_atomics = ImmutableList.of("_sc", "_rx", "memory_order_relaxed", "_na", "_rel" );

    XLegacyInvocationHook(XProgramInterpreter program) {
        super(program);
    }

    @Override
    public XInvocationHookAction tryInterceptInvocation(String methodName) {
        switch (methodName) {

            case "store": {
            // syntax: `location.store(_rx, register)'
                return new XInvocationHookAction((receiver, arguments) -> {
                    XSharedLvalueMemoryUnit receiverShared = tryCastReceiver(receiver, methodName);
                    if (arguments.length != 2) {
                        return null;
                    }

                    XMemoryUnit atomicUnit = arguments[0];
                    if (!(atomicUnit instanceof XLvalueMemoryUnit)) {
                        throw new XMethodInvocationError(methodName, "1st argument: expected to be a variable, received: " + wrap(atomicUnit));
                    }
                    // TODO: it's better to check the type of atomic as well (not only name)
                    String atomic = ((XLvalueMemoryUnit) atomicUnit).getName();
                    if (!valid_atomics.contains(atomic)) {
                        return null;
                    }

                    XMemoryUnit argument = arguments[1];
                    XLocalMemoryUnit argumentLocal = program.tryConvertToLocalOrNull(argument);
                    if (argumentLocal == null) {
                        throw new XMethodInvocationError(methodName, "2st argument: could not convert to local memory unit: " + wrap(argument));
                    }

                    if (!program.memoryModel.is(MemoryModel.Kind.Power) && !program.memoryModel.is(MemoryModel.Kind.ARM)) {
                        if (atomic.equals("_sc")) {
                            //return new Seq(st, mfence);
                            emitStore(receiverShared, argumentLocal);
                            return emitBarrier(XBarrierEvent.Kind.Mfence);
                        }
                        else {
                            return emitStore(receiverShared, argumentLocal);
                        }
                    }

                    // TODO: in the old code, the 'leading' parameter is always true. Cleanup this logic.
                    boolean leading = true;
                    if (program.memoryModel.is(MemoryModel.Kind.Power)) {
                        if(atomic.equals("_sc")) {
                            if (leading) {
                                //return new Seq(sync, st);
                                emitBarrier(XBarrierEvent.Kind.Sync);
                                return emitStore(receiverShared, argumentLocal);
                            }
                            else {
                                //return new Seq(lwsync, new Seq(st, sync));
                                emitBarrier(XBarrierEvent.Kind.Lwsync);
                                return emitStore(receiverShared, argumentLocal);
                            }
                        }
                        if(atomic.equals("_rx") || atomic.equals("memory_order_relaxed")
                                || atomic.equals("_na")) {
                            return emitStore(receiverShared, argumentLocal);
                        }
                        if(atomic.equals("_rel")) {
                            //return new Seq(lwsync, st);
                            emitBarrier(XBarrierEvent.Kind.Lwsync);
                            return emitStore(receiverShared, argumentLocal);
                        }
                    }

                    if(program.memoryModel.is(MemoryModel.Kind.ARM)) {
                        if(atomic.equals("_sc")) {
                            //return new Seq(ish1, new Seq(st, ish2));
                            emitBarrier(XBarrierEvent.Kind.Ish);
                            emitStore(receiverShared, argumentLocal);
                            return emitBarrier(XBarrierEvent.Kind.Ish);
                        }
                        if(atomic.equals("_rx") || atomic.equals("memory_order_relaxed")
                                || atomic.equals("_na")) {
                            //return st;
                            return emitStore(receiverShared, argumentLocal);
                        }
                        if(atomic.equals("_rel")) {
                            //return new Seq(ish1, st);
                            emitBarrier(XBarrierEvent.Kind.Ish);
                            emitStore(receiverShared, argumentLocal);
                        }
                    }

                    // TODO: complete this method!
                    throw new NotImplementedException("Not defined in old logic. TODO: complete this method!");
                });
            }

            case "load": {
            // syntax: `register <- location.load(_rx)'
                return new XInvocationHookAction((receiver, arguments) -> {
                    XSharedLvalueMemoryUnit receiverShared = tryCastReceiver(receiver, methodName);
                    if (arguments.length != 1) {
                        return null;
                    }

                    XMemoryUnit atomicUnit = arguments[0];
                    if (!(atomicUnit instanceof XLvalueMemoryUnit)) {
                        throw new XMethodInvocationError(methodName, "1st argument: expected to be a variable, received: " + wrap(atomicUnit));
                    }
                    // TODO: it's better to check the type of atomic as well (not only name)
                    String atomic = ((XLvalueMemoryUnit) atomicUnit).getName();

                    if(!program.memoryModel.is(MemoryModel.Kind.Power) && !program.memoryModel.is(MemoryModel.Kind.ARM)) {
                        return emitLoad(receiverShared);
                    }
                    if(atomic.equals("_rx") || atomic.equals("memory_order_relaxed") || atomic.equals("_na")) {
                        return emitLoad(receiverShared);
                    }

                    // TODO: in the old code, the 'leading' parameter is always true. Cleanup this logic.
                    boolean leading = true;
                    if(program.memoryModel.is(MemoryModel.Kind.Power)) {
                        if(atomic.equals("_sc")) {
                            if(leading) {
                                //return new Seq(sync, new Seq(ld, lwsync));
                                emitBarrier(XBarrierEvent.Kind.Sync);
                                emitLoad(receiverShared);
                                return emitBarrier(XBarrierEvent.Kind.Lwsync);
                            }
                            else {
                                //return new Seq(ld, lwsync);
                                emitLoad(receiverShared);
                                return emitBarrier(XBarrierEvent.Kind.Lwsync);
                            }
                        }
                        if(atomic.equals("_con") || atomic.equals("_acq")) {
                            //return new Seq(ld, lwsync);
                            emitLoad(receiverShared);
                            return emitBarrier(XBarrierEvent.Kind.Lwsync);
                        }
                    }
                    if(program.memoryModel.is(MemoryModel.Kind.ARM)) {
                        if(atomic.equals("_con") || atomic.equals("_acq") || atomic.equals("_sc")) {
                            //return new Seq(ld, ish);
                            emitLoad(receiverShared);
                            return emitBarrier(XBarrierEvent.Kind.Ish);
                        }
                    }

                    // TODO: complete this method!
                    throw new NotImplementedException("Not defined in old logic. TODO: complete this method!");
                });
            }

            default:
                // TODO: do not return null, but the empty hook action
                return null;
        }
    }

    private XSharedLvalueMemoryUnit tryCastReceiver(XMemoryUnit receiver, String methodName) {
        if (!(receiver instanceof XSharedLvalueMemoryUnit)) {
            throw new XMethodInvocationError(methodName, "receiver: expected to be a "
                    + XSharedLvalueMemoryUnit.class.getSimpleName() +
                    ", found: " + wrap(receiver) +
                    " of type: " + wrap(receiver.getClass().getSimpleName()));
        }
        return  (XSharedLvalueMemoryUnit) receiver;
    }

    private XLocalLvalueMemoryUnit emitLoad(XSharedMemoryUnit receiverShared) {
        XLocalLvalueMemoryUnit resultRegister = program.getMemoryManager().declareTempRegister(receiverShared.getType());
        program.emitMemoryEvent(resultRegister, receiverShared);
        return resultRegister;
    }

    private XSharedMemoryEvent emitStore(XSharedLvalueMemoryUnit receiverShared, XLocalMemoryUnit argumentLocal) {
        return program.emitMemoryEvent(receiverShared, argumentLocal);
    }

    private XBarrierEvent emitBarrier(XBarrierEvent.Kind kind) {
        return program.emitBarrierEvent(kind);
    }
}
