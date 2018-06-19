package dartagnan.parsers.visitors;

import dartagnan.parsers.utils.Branch.BareIf;
import org.antlr.v4.runtime.tree.AbstractParseTreeVisitor;

import dartagnan.program.Thread;
import dartagnan.program.*;
import dartagnan.expression.*;
import dartagnan.LitmusPPCParser;
import dartagnan.program.Program;
import dartagnan.LitmusPPCVisitor;

import dartagnan.parsers.utils.Utils;

import java.util.*;
import java.util.Stack;


public class VisitorLitmusPPC
        extends AbstractParseTreeVisitor<Thread>
        implements LitmusPPCVisitor<Thread> {

    private Program program;
    private Map<String, Location> mapLocs = new HashMap<String, Location>();
    private Map<String, Map<String, Register>> mapRegs = new HashMap<String, Map<String, Register>>();
    private Map<String, List<Thread>> mapThreads = new HashMap<String, List<Thread>>();
    private Map<String, Map<String, Location>> mapRegLoc = new HashMap<String, Map<String, Location>>();
    private Map<String, Stack<String>> branchingStacks = new HashMap<String, Stack<String>>();
    private String mainThread;
    private String effectiveThread;

    @Override
    public Thread visitMain(LitmusPPCParser.MainContext ctx) {
        program = new Program("");
        program.setAss(new Assert());

        visitVariableDeclaratorList(ctx.variableDeclaratorList());
        visitThreadDeclaratorList(ctx.threadDeclaratorList());
        visitInstructionList(ctx.instructionList());
        visitAssertionList(ctx.assertionList());

        for(String i : mapThreads.keySet()) {
            program.add(Utils.listToThread(mapThreads.get(i)));
        }
        return program;
    }

    @Override
    public Thread visitHeader(LitmusPPCParser.HeaderContext ctx) {
        return null;
    }

    @Override
    public Thread visitHeaderComment(LitmusPPCParser.HeaderCommentContext ctx) {
        return null;
    }

    @Override
    public Thread visitVariableDeclaratorList(LitmusPPCParser.VariableDeclaratorListContext ctx) {
        return visitChildren(ctx);
    }

    @Override
    public Thread visitVariableDeclarator(LitmusPPCParser.VariableDeclaratorContext ctx) {
        return visitChildren(ctx);
    }

    @Override
    public Thread visitVariableDeclaratorLocation(LitmusPPCParser.VariableDeclaratorLocationContext ctx) {
        String name = ctx.location().getText();
        Integer value = Integer.parseInt(ctx.value().getText());

        if(mapLocs.containsKey(name)){
            error(String.format("Location %s is already initialised", name));
        }
        Location location = new Location(name);
        mapLocs.put(name, location);
        location.setIValue(value);
        return null;
    }

    @Override
    public Thread visitVariableDeclaratorRegister(LitmusPPCParser.VariableDeclaratorRegisterContext ctx) {
        String thread = threadId(ctx.thread().getText());
        String name = ctx.r1().getText();

        if(!mapThreads.keySet().contains(thread)) {
            mapThreads.put(thread, new ArrayList<Thread>());
        }

        if(!mapRegs.keySet().contains(thread)){
            mapRegs.put(thread, new HashMap<String, Register>());
        }

        Register register = new Register(name);
        mapRegs.get(thread).put(name, register);

        Integer iValue = Integer.parseInt(ctx.value().getText());
        mapThreads.get(thread).add(new Local(register, new AConst(iValue)));
        return null;
    }

    @Override
    public Thread visitVariableDeclaratorRegisterLocation(LitmusPPCParser.VariableDeclaratorRegisterLocationContext ctx) {
        String thread = threadId(ctx.thread().getText());
        String registerName = ctx.r1().getText();

        if(!mapThreads.keySet().contains(thread)) {
            mapThreads.put(thread, new ArrayList<Thread>());
        }

        if(!mapRegs.keySet().contains(thread)){
            mapRegs.put(thread, new HashMap<String, Register>());
        }

        Register register = new Register(registerName);
        mapRegs.get(thread).put(registerName, register);

        String locationName = ctx.location().getText();

        if(!mapLocs.containsKey(locationName)){
            Location location = new Location(locationName);
            mapLocs.put(locationName, location);
        }

        Location location = mapLocs.get(locationName);
        if(!mapRegLoc.containsKey(thread)){
            mapRegLoc.put(thread, new HashMap<String, Location>());
        }

        mapRegLoc.get(thread).put(registerName, location);
        return null;
    }

    @Override
    public Thread visitThreadDeclaratorList(LitmusPPCParser.ThreadDeclaratorListContext ctx) {
        for(LitmusPPCParser.ThreadContext threadCtx : ctx.thread()){
            String thread = threadId(threadCtx.ThreadDeclarator().getText());
            if(!mapRegs.keySet().contains(thread)) {
                mapRegs.put(thread, new HashMap<String, Register>());
            }

            if(!mapThreads.keySet().contains(thread)) {
                mapThreads.put(thread, new ArrayList<Thread>());
            }

            branchingStacks.put(thread, new Stack<String>());
            Stack stack = branchingStacks.get(thread);
            stack.push(thread);
        }
        return null;
    }

    @Override
    public Thread visitInstructionList(LitmusPPCParser.InstructionListContext ctx) {
        return visitChildren(ctx);
    }

    @Override
    public Thread visitInstructionRow(LitmusPPCParser.InstructionRowContext ctx) {
        Integer i = 0;
        for(LitmusPPCParser.InstructionContext instructionCtx : ctx.instruction()){
            mainThread = i.toString();
            effectiveThread = effectiveThread();
            Thread thread = visitInstruction(ctx.instruction(i));
            if(thread != null){
                mapThreads.get(effectiveThread()).add(thread);
            }
            i++;
        }
        return null;
    }

    @Override
    public Thread visitInstruction(LitmusPPCParser.InstructionContext ctx) {
        return visitChildren(ctx);
    }

    @Override
    public Thread visitNone(LitmusPPCParser.NoneContext ctx) {
        return null;
    }

    @Override
    public Thread visitLi(LitmusPPCParser.LiContext ctx) {
        Register r1 = new Register(ctx.r1().getText());
        Map<String, Register> mapThreadRegs = mapRegs.get(mainThread);
        if(!(mapThreadRegs.keySet().contains(r1.getName()))) {
            mapThreadRegs.put(r1.getName(), r1);
        }

        Integer value = Integer.parseInt(ctx.value().getText());
        Register pointerReg = mapThreadRegs.get(r1.getName());
        return new Local(pointerReg, new AConst(value));
    }

    @Override
    public Thread visitLwz(LitmusPPCParser.LwzContext ctx) {
        Register r1 = new Register(ctx.r1().getText());
        Map<String, Register> mapThreadRegs = mapRegs.get(mainThread);
        if(!(mapThreadRegs.keySet().contains(r1.getName()))) {
            mapThreadRegs.put(r1.getName(), r1);
        }

        Register r2 = new Register(ctx.r2().getText());
        if(!(mapRegLoc.get(mainThread).keySet().contains(r2.getName()))) {
            error(String.format("Register %s must be initialized to a location", r2.getName()));
        }
        Register pointerReg = mapThreadRegs.get(r1.getName());
        Location pointerLoc = mapRegLoc.get(mainThread).get(r2.getName());
        return new Load(pointerReg, pointerLoc);
    }

    @Override
    public Thread visitLwzx(LitmusPPCParser.LwzxContext ctx) {
        error(String.format("Instruction %s is not implemented", "lwzx"));
        return null;
    }

    @Override
    public Thread visitStw(LitmusPPCParser.StwContext ctx) {
        Register r2 = new Register(ctx.r2().getText());
        if(!(mapRegLoc.get(mainThread).keySet().contains(r2.getName()))) {
            error(String.format("Register %s must be initialized to a location", r2.getName()));
        }

        Register r1 = new Register(ctx.r1().getText());
        Map<String, Register> mapThreadRegs = mapRegs.get(mainThread);
        if(!(mapThreadRegs.keySet().contains(r1.getName()))) {
            error(String.format("Register %s must be initialized", r1.getName()));
        }
        Register pointerReg = mapThreadRegs.get(r1.getName());
        Location pointerLoc = mapRegLoc.get(mainThread).get(r2.getName());
        return new Store(pointerLoc, pointerReg);
    }

    @Override
    public Thread visitStwx(LitmusPPCParser.StwxContext ctx) {
        error(String.format("Instruction %s is not implemented", "stwx"));
        return null;
    }

    @Override
    public Thread visitMr(LitmusPPCParser.MrContext ctx) {
        Register r1 = new Register(ctx.r1().getText());
        Map<String, Register> mapThreadRegs = mapRegs.get(mainThread);
        if(!(mapThreadRegs.keySet().contains(r1.getName()))) {
            mapThreadRegs.put(r1.getName(), r1);
        }
        Register r2 = new Register(ctx.r2().getText());
        if(!(mapThreadRegs.keySet().contains(r2.getName()))) {
            mapThreadRegs.put(r2.getName(), r2);
        }
        Register pointerReg1 = mapThreadRegs.get(r1.getName());
        Register pointerReg2 = mapThreadRegs.get(r2.getName());
        return new Local(pointerReg1, pointerReg2);
    }

    @Override
    public Thread visitAddi(LitmusPPCParser.AddiContext ctx) {
        Register r1 = new Register(ctx.r1().getText());
        Map<String, Register> mapThreadRegs = mapRegs.get(mainThread);
        if(!(mapThreadRegs.keySet().contains(r1.getName()))) {
            mapThreadRegs.put(r1.getName(), r1);
        }

        Register r2 = new Register(ctx.r1().getText());
        if(!(mapThreadRegs.keySet().contains(r2.getName()))) {
            mapThreadRegs.put(r2.getName(), r2);
        }
        Register pointerReg1 = mapThreadRegs.get(r2.getName());
        Register pointerReg2 = mapThreadRegs.get(r2.getName());
        return new Local(pointerReg1, new AExpr(pointerReg2, "+", new AConst(Integer.parseInt(ctx.value().getText()))));
    }

    @Override
    public Thread visitXor(LitmusPPCParser.XorContext ctx) {
        Register r1 = new Register(ctx.r1().getText());
        Map<String, Register> mapThreadRegs = mapRegs.get(mainThread);
        if(!(mapThreadRegs.keySet().contains(r1.getName()))) {
            mapThreadRegs.put(r1.getName(), r1);
        }

        Register r2 = new Register(ctx.r2().getText());
        if(!(mapThreadRegs.keySet().contains(r2.getName()))) {
            mapThreadRegs.put(r2.getName(), r2);
        }

        Register r3 = new Register(ctx.r3().getText());
        if(!(mapThreadRegs.keySet().contains(r3.getName()))) {
            mapThreadRegs.put(r3.getName(), r3);
        }

        Register pointerReg1 = mapThreadRegs.get(r1.getName());
        Register pointerReg2 = mapThreadRegs.get(r2.getName());
        Register pointerReg3 = mapThreadRegs.get(r3.getName());
        return new Local(pointerReg1, new AExpr(pointerReg2, "xor", pointerReg3));
    }

    @Override
    public Thread visitCmpw(LitmusPPCParser.CmpwContext ctx) {
        Map<String, Register> mapThreadRegs = mapRegs.get(mainThread);

        Register r1 = new Register(ctx.r1().getText());
        if(!(mapThreadRegs.keySet().contains(r1.getName()))) {
            mapThreadRegs.put(r1.getName(), r1);
        }

        Register r2 = new Register(ctx.r2().getText());
        if(!(mapThreadRegs.keySet().contains(r2.getName()))) {
            mapThreadRegs.put(r2.getName(), r2);
        }

        r1 = mapThreadRegs.get(r1.getName());
        r2 = mapThreadRegs.get(r2.getName());

        return new BareIf(r1, r2);
    }

    @Override
    public Thread visitBeq(LitmusPPCParser.BeqContext ctx) {
        return visitBranchCondition("==", ctx.Label().getText());
    }

    @Override
    public Thread visitBne(LitmusPPCParser.BneContext ctx) {
        return visitBranchCondition("!=", ctx.Label().getText());
    }

    @Override
    public Thread visitBlt(LitmusPPCParser.BltContext ctx) {
        return visitBranchCondition("<", ctx.Label().getText());
    }

    @Override
    public Thread visitBgt(LitmusPPCParser.BgtContext ctx) {
        return visitBranchCondition(">", ctx.Label().getText());
    }

    @Override
    public Thread visitBle(LitmusPPCParser.BleContext ctx) {
        return visitBranchCondition("<=", ctx.Label().getText());
    }

    @Override
    public Thread visitBge(LitmusPPCParser.BgeContext ctx) {
        return visitBranchCondition(">=", ctx.Label().getText());
    }

    private Thread visitBranchCondition(String op, String label){
        List<Thread> mainThreadInstructions = mapThreads.get(mainThread);
        if(mainThreadInstructions.size() > 0){
            Thread lastInstruction = mainThreadInstructions.get(mainThreadInstructions.size() - 1);

            if(lastInstruction instanceof BareIf){
                BareIf branchInstruction = (BareIf) lastInstruction;
                branchInstruction.setOp(op);
                branchInstruction.setElseLabel(label);
                forkBranch();
                return null;
            }
        }

        error(String.format("Invalid instruction sequence in thread %s", mainThread));
        return null;
    }

    private void forkBranch(){
        String branchId = UUID.randomUUID().toString();
        branchingStacks.get(mainThread).push(branchId);
        mapThreads.put(branchId, new ArrayList<Thread>());
    }

    private Thread closeBranch(){
        List<Thread> branchingThreadInstructions = mapThreads.remove(effectiveThread);
        Thread branchingThread = Utils.listToThread(branchingThreadInstructions);
        branchingStacks.get(mainThread).pop();
        return branchingThread;
    }

    @Override
    public Thread visitLabel(LitmusPPCParser.LabelContext ctx) {
        String label = ctx.Label().getText();
        List<Thread> mainThreadInstructions = mapThreads.get(mainThread);
        if(mainThreadInstructions.size() > 0) {
            Thread lastInstruction = mainThreadInstructions.get(mainThreadInstructions.size() - 1);

            if(lastInstruction instanceof BareIf){
                if(((BareIf)lastInstruction).getEndLabel() != null
                        && ((BareIf)lastInstruction).getEndLabel().equals(label)){
                    ((BareIf) lastInstruction).setT1(closeBranch());
                    mainThreadInstructions.remove(mainThreadInstructions.size() - 1);
                    return ((BareIf) lastInstruction).toIf();
                }

                if(((BareIf)lastInstruction).getElseLabel() != null
                        && ((BareIf)lastInstruction).getElseLabel().equals(label)){
                    if(((BareIf)lastInstruction).getEndLabel() == null){
                        ((BareIf)lastInstruction).setT2(closeBranch());
                        mainThreadInstructions.remove(mainThreadInstructions.size() - 1);
                        return ((BareIf)lastInstruction).toIf();
                    } else {
                        forkBranch();
                        return null;
                    }
                }
            }
        }

        error(String.format("Invalid instruction sequence in thread %s", mainThread));
        return null;
    }

    @Override
    public Thread visitB(LitmusPPCParser.BContext ctx) {
        String label = ctx.Label().getText();
        List<Thread> mainThreadInstructions = mapThreads.get(mainThread);
        if(mainThreadInstructions.size() > 0) {
            Thread lastInstruction = mainThreadInstructions.get(mainThreadInstructions.size() - 1);
            if(lastInstruction instanceof BareIf){
                if(((BareIf) lastInstruction).getEndLabel() == null){
                    ((BareIf) lastInstruction).setEndLabel(label);
                    ((BareIf) lastInstruction).setT2(closeBranch());
                    return null;
                }
            }
        }

        error(String.format("Invalid instruction sequence in thread %s", mainThread));
        return null;
    }

    @Override
    public Thread visitSync(LitmusPPCParser.SyncContext ctx) {
        return new Sync();
    }

    @Override
    public Thread visitLwsync(LitmusPPCParser.LwsyncContext ctx) {
        return new Lwsync();
    }

    @Override
    public Thread visitIsync(LitmusPPCParser.IsyncContext ctx) {
        return new Isync();
    }

    @Override
    public Thread visitEieio(LitmusPPCParser.EieioContext ctx) {
        error(String.format("Instruction %s is not implemented", "eieio"));
        return null;
    }

    @Override
    public Thread visitAssertionComment(LitmusPPCParser.AssertionCommentContext ctx) {
        return null;
    }

    @Override
    public Thread visitAssertionList(LitmusPPCParser.AssertionListContext ctx) {
        return visitChildren(ctx);
    }

    @Override
    public Thread visitAssertion(LitmusPPCParser.AssertionContext ctx) {
        return visitChildren(ctx);
    }

    @Override
    public Thread visitVariableAssertionLocation(LitmusPPCParser.VariableAssertionLocationContext ctx) {
        Location loc = new Location(ctx.location().getText());
        program.getAss().addPair(loc, Integer.parseInt(ctx.value().getText()));
        return null;
    }

    @Override
    public Thread visitVariableAssertionRegister(LitmusPPCParser.VariableAssertionRegisterContext ctx) {
        Register reg = mapRegs.get(threadId(ctx.thread().getText())).get(ctx.r1().getText());
        program.getAss().addPair(reg, Integer.parseInt(ctx.value().getText()));
        return null;
    }

    @Override
    public Thread visitThread(LitmusPPCParser.ThreadContext ctx) {
        return null;
    }

    @Override
    public Thread visitR1(LitmusPPCParser.R1Context ctx) {
        return null;
    }

    @Override
    public Thread visitR2(LitmusPPCParser.R2Context ctx) {
        return null;
    }

    @Override
    public Thread visitR3(LitmusPPCParser.R3Context ctx) {
        return null;
    }

    @Override
    public Thread visitLocation(LitmusPPCParser.LocationContext ctx) {
        return null;
    }

    @Override
    public Thread visitValue(LitmusPPCParser.ValueContext ctx) {
        return null;
    }

    @Override
    public Thread visitOffset(LitmusPPCParser.OffsetContext ctx) {
        return null;
    }

    private String effectiveThread(){
        return branchingStacks.get(mainThread).peek();
    }

    private String threadId(String threadId){
        return threadId.replace("P", "");
    }

    private void error(String info){
        System.err.println(String.format("Parsing error : %s", info));
        program.addParsingError(info);
    }
}
