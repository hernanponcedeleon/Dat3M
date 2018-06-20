package porthosc.languages.conversion.toxgraph.interpretation;

//import com.sun.istack.internal.NotNull;
import porthosc.languages.syntax.xgraph.XEntity;
import porthosc.languages.syntax.xgraph.events.barrier.XBarrierEvent;
import porthosc.languages.syntax.xgraph.events.computation.*;
import porthosc.languages.syntax.xgraph.events.controlflow.XJumpEvent;
import porthosc.languages.syntax.xgraph.events.fake.XEntryEvent;
import porthosc.languages.syntax.xgraph.events.fake.XExitEvent;
import porthosc.languages.syntax.xgraph.events.fake.XNopEvent;
import porthosc.languages.syntax.xgraph.events.memory.XLocalMemoryEvent;
import porthosc.languages.syntax.xgraph.events.memory.XSharedMemoryEvent;
import porthosc.languages.syntax.xgraph.memories.*;
import porthosc.languages.syntax.xgraph.process.XCyclicProcess;
import porthosc.languages.syntax.xgraph.process.XProcessId;

//import javax.annotation.Nullable;


public interface XInterpreter {

    enum BlockKind {
        Sequential,
        Branching,
        Loop,;
    }

    enum BranchKind {
        Then,
        Else,;
    }

    enum JumpKind {
        Break,
        Continue,
        ;
    }

    //@NotNull
    XMemoryManager getMemoryManager();

    XCyclicProcess getResult();

    XProcessId getProcessId();

    void finishInterpretation();

    //XMemoryUnit tryConvertToMemoryUnitOrNull(XEntity expression);
    XLocalMemoryUnit tryConvertToLocalOrNull(XEntity expression);

    //XLvalueMemoryUnit tryConvertToLvalueOrNull(XEntity expression);
    XComputationEvent tryEvaluateComputation(XEntity entity);

    XRegister copyToLocalMemory(XSharedMemoryUnit shared);

    XEntryEvent emitEntryEvent();

    XExitEvent emitExitEvent();

    XBarrierEvent emitBarrierEvent(XBarrierEvent.Kind kind);

    XJumpEvent emitJumpEvent();

    XJumpEvent emitJumpEvent(String label);

    void markNextEventLabel(String label);

    XNopEvent emitNopEvent();

    XLocalMemoryEvent emitMemoryEvent(XLocalLvalueMemoryUnit destination, XLocalMemoryUnit source);

    XSharedMemoryEvent emitMemoryEvent(XLocalLvalueMemoryUnit destination, XSharedMemoryUnit source);

    XSharedMemoryEvent emitMemoryEvent(XSharedLvalueMemoryUnit destination, XLocalMemoryUnit source);

    // -- computations:

    //XComputationEvent emitSimpleComputationEvent(XUnaryOperator operator, XLocalMemoryUnit operand);
    //XComputationEvent emitSimpleComputationEvent(XBinaryOperator operator, XLocalMemoryUnit firstOperand, XLocalMemoryUnit secondOperand);

    XComputationEvent createComputationEvent(XUnaryOperator operator, XLocalMemoryUnit operand);

    XComputationEvent createComputationEvent(XBinaryOperator operator, XLocalMemoryUnit firstOperand, XLocalMemoryUnit secondOperand);

    //void rememberPostfixOperation(XLocalLvalueMemoryUnit memoryUnit, boolean isIncrement);

    XAssertionEvent emitAssertionEvent(XBinaryComputationEvent assertion);

    // --

    void startBlockDefinition(BlockKind blockKind);

    void startBlockConditionDefinition();

    void finishBlockConditionDefinition(XComputationEvent conditionEvent);

    void startBlockBranchDefinition(BranchKind branchKind);

    void finishBlockBranchDefinition();

    void finishNonlinearBlockDefinition();

    void processJumpStatement(JumpKind kind);

    // TODO: signature instead of just name
    // TODO: arguments: write all shared to registers and set up control-flow binding
    XEntity processMethodCall(String methodName, XMemoryUnit receiver, XMemoryUnit... arguments);
}
