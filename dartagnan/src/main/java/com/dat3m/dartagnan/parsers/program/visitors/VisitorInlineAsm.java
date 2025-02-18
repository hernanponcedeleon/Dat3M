package com.dat3m.dartagnan.parsers.program.visitors;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;

import org.antlr.v4.runtime.tree.ParseTree;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.integers.IntCmpOp;
import com.dat3m.dartagnan.expression.type.AggregateType;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.expression.type.VoidType;
import com.dat3m.dartagnan.parsers.InlineAsmBaseVisitor;
import com.dat3m.dartagnan.parsers.InlineAsmParser;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Label;
import static com.google.common.base.Preconditions.checkState;

// The trickiest part of handling inline assembly is matching input and output registers on the LLVM side with the registers in the assembly.
// The matching depends on what is specified in the clobbers.

// On the LLVM side, the 	inline assembly is called as follows
//      Register = Type call asm sideeffect 'asm code', 'clobbers' ('args')
// We call "asm registers" the ones appearing inside 'asm code'.
// We call "llvm registers" the ones passed in 'args' (i.e. the function parameters) plus Register.

// The clobbers tell us how to map asm registers to LLVM ones.
// Clobbers form a list where each entry can be one of the following:
// =r or =&r means we need to map an asm register to the return register. These are called Output Clobber / output constraints
// Q, *Q or r means we need to map an LLVM register from 'args' to an asm register. These are called Input Clobbers / input constraints
// =*m it means that the register is a memory location, and is not mapped to any register
// a constant X, it means that a register from 'args' is mapped to the Xth asm register which in turn is mapped to the return register.

// Here are some examples to understand what is happening.
// We are going to use ARMV7 names for readability "$0, $1, $2, ...", but other inline asm formats follow the same pattern 

// BASE CASE
// a)  
// asm: r10 = i32 call asm "ldr $0, $1"," =r, *Q"(ptr r9) 
// Code variables: asmRegisterNames := [$0, $1] ; argsRegisters := [r9] ; clobbers := [=r, *Q]
// Logic:
//     1. the first asm register maps to the output, i.e. r10 <- $0
//     2. the first args register maps to the next asm register, i.e. $1 <- r9

// RETURN REGISTER IS AGGREGATE TYPE
// b) 
// asm: r10 = { i32, i32, i32 } asm "ldr $0, $3 ; ldr $1, $3 ; ldr $2, $3","=r, =r, =r, *Q"(ptr r9)
// Code variables asmRegisterNames := [$0, $1, $2, $3] ; argsRegisters := [r9] ; clobbers := [=r, =r, =r, *Q]
// Logic:
//     1. the first 3 asm registers map to the output, i.e.
//         - r10[0] <- $0
//         - r10[1] <- $1
//         - r10[2] <- $2
//      2. the 1st args register maps to the next asm register, i.e. $3 <- r9

// MULTIPLE ARGS
// c) 
// asm: r10 = i32 call asm "ldr $0, $1 ; ldr $0, $2 "," =r, r, *Q"(i32 r8, ptr r9)
// Code variables: asmRegisterNames := [$0, $1, $2] ; argsRegisters := [r8, r9] ; clobbers := [=r, r, *Q]
//    1. the 1st asm register maps to the output, i.e. r10 <- $0
//    2. the two args registers map to the next two asm registers, i.e.
//       - $1 <- r8
//       - $2 <- r9

// THERE IS NO RETURN REGISTER
// d) 
// asm: call void asm "stlr $0, $1", "r,*Q"(ptr r5, ptr r7)
// Code variables: asmRegisterNames := [$0, $1] ; argsRegisters := [r5, r7] ; clobbers := [r, *Q]
//    1. nothing to be done regarding output, i.e. there no return register
//    2. the two args registers map to the next two asm registers, i.e.
//       - $0 <- r5
//       - $1 <- r7

// THERE IS A MEMORY LOCATION
// e) 
// asm: r10 = i32 call asm "ldr $0, $2 ; ldr $0, $3","=&r, =*m, r, r"(ptr r7, i32 r8)
// Code variables: asmRegisterNames := [$0, $2, $3] ; argsRegisters := [r7, r8] ; clobbers := [=&r, =*m, r, r]
//    1. r10 <- $0
//    1.5 we see that =*m is a reference to a memory location, so it would be $1 -> MEM and we do nothing
//    2. the two args registers map to the next two asm registers,
//       - $2 <- r7
//       - $3 <- r8

// WE HAVE AN OVERLAP IN THE RETURN REGISTER AND THE ARGS
// f)
// asm: r11 = call { i32, i32, i32, i32 } asm "ldr $0, $4 ; add $1, $0, $3 ; add $2, $1, $4 ; ldr $2, $0", "=&r,=&r,=&r,=&r,*Q,3"(ptr r10, i32 r8)
// Code variables: asmRegisterNames := [$0, $1, $2, $3, $4] ; argsRegisters := [r10, r8] ; clobbers := [=&r, =&r, =&r, =&r, *Q, 3]
//    1. we have 4 output clobbers, so we have an aggregate type for the return register
//       - r11[0] <- $0
//       - r11[1] <- $1
//       - r11[2] <- $2
//       - r11[3] <- $3
//    2. map function parameter to next asm register, i.e. $4 <- r10
//    3. the 3rd asm register is related both to the return register (already above in r11[3] <- $3) and to an args register, i.e. $3 <- r8

public class VisitorInlineAsm extends InlineAsmBaseVisitor<Object> {

    private class CmpInstruction {

        private final Expression left;
        private final Expression right;

        public CmpInstruction(Expression left, Expression right) {
            this.left = left;
            this.right = right;
        }
    }

    private final List<Event> events = new ArrayList<>();
    private final Function llvmFunction;
    private final Register returnRegister;
    private final ExpressionFactory expressions = ExpressionFactory.getInstance();
    private final TypeFactory types = TypeFactory.getInstance();
    private CmpInstruction comparator;
    // keeps track of all the labels defined in the the asm code
    private final HashMap<String, Label> labelsDefined;
    // used to keep track of which asm register should map to the llvm return register if it is an aggregate type
    private final List<Expression> pendingRegisters;
    // holds the LLVM registers that are passed as (args) to the the asm -- asm"..." (args)
    private final List<Expression> argsRegisters;
    // holds the names of the asm registers which appear in inlineasm e.g. $0, $1...
    private final ArrayList<String> asmRegisterNames;
    // expected type of RHS of a comparison
    private Type expectedType;

    public VisitorInlineAsm(Function llvmFunction, Register returnRegister, Type returnType, List<Expression> llvmArguments) {
        this.llvmFunction = llvmFunction;
        this.returnRegister = returnRegister;
        this.labelsDefined = new HashMap<>();
        this.pendingRegisters = new LinkedList<>();
        this.asmRegisterNames = new ArrayList<>();
        this.argsRegisters = llvmArguments;
    }

    // helper function to determine if a string representing a register is an ARMv8 register
    private boolean isArmv8Name(String registerName) {
        return registerName.startsWith("${") && registerName.endsWith("}");
    }

    // given the asm register name it returns the size of the llvm register it is referencing
    // e.g. if $1 is referencing i32 r9, it is going to return i32
    public Type getArmVariableSize(String registerAsmName) {
        int number = extractNumberFromRegisterName(registerAsmName);
        // by 'isPart' we mean that the extracted number is LTE to the size of the return Register
        // e.g. if we have a returnRegister of type { i32, i32 } and we have registerAsmName = $1
        // it is part of the returnRegister, as from $1 we get 1, which is LTE returnRegisterType.size()
        if (isPartOfReturnRegister(registerAsmName)) {
            if (isReturnRegisterAggregate()) {
                Type returnRegisterProjectionType = expressions.makeExtract(number, returnRegister).getType();
                return returnRegisterProjectionType;
            }
            // in case returnRegister is not aggregateType, we just pick its type
            // e.g. r10 = call i32 asm "..." is going to have returnRegister r10 : i32. No extracting is needed.
            return this.returnRegister.getType();
        }
        // if it is not part of the return Register, it is part of the arguments
        // e.g. r10 { i32, i32 } is return Register, args contains (i64 r9)
        //  we want to get the type of $3, so we are going to return i64
        return this.argsRegisters.get(number - getSizeOfReturnRegister()).getType();
    }

    // we define a register to be part of the return register if its index
    // gotten from the name is LTE than the size of the return register
    private boolean isPartOfReturnRegister(String registerAsmName) {
        int number = extractNumberFromRegisterName(registerAsmName);
        return (number < getSizeOfReturnRegister());
    }

    // tells if the returnRegister is an AggregateType
    private boolean isReturnRegisterAggregate() {
        return getSizeOfReturnRegister() > 1;
    }

    // returns the size of the return register
    // null / void -> 0
    // i32 / bool -> 1
    // aggregateType -> the size of the aggregate
    private int getSizeOfReturnRegister() {
        if (this.returnRegister == null) {
            return 0;
        }
        Type returnType = this.returnRegister.getType();
        if (returnType instanceof IntegerType || returnType instanceof BooleanType) {
            return 1;
        } else if (returnType instanceof AggregateType at) {
            return at.getTypeOffsets().size();
        } else if (returnType instanceof VoidType) {
            return 0;
        } else {
            throw new ParsingException("Unknown inline asm return type " + returnType);
        }
    }

    // given a register name, it extracts the index contained in the name
    // ${3:w} -> 3 (armv8 name)
    // $4 -> 4 (armv7 name)
    int extractNumberFromRegisterName(String registerAsmName) {
        int number = -1;
        String innerString = registerAsmName;
        if (registerAsmName.startsWith("r")) {
            innerString = registerAsmName.substring(1);
        }
        if (isArmv8Name(innerString)) { // ${N:x}
            number = Integer.parseInt(Character.toString(innerString.charAt(2)));
        } else if (innerString.length() == 2) { // $n
            number = Integer.parseInt(Character.toString(innerString.charAt(1)));
        } else if (innerString.length() == 4) { // [$n]
            number = Integer.parseInt(Character.toString(innerString.charAt(2)));
        }
        return number;
    }

    // given a string of a label, it either creates a new label, or returns the existing one if it was already defined
    private Label getOrNewLabel(String labelName) {
        Label label;
        if (this.labelsDefined.containsKey(labelName)) {
            label = this.labelsDefined.get(labelName);
        } else {
            label = EventFactory.newLabel(labelName);
            this.labelsDefined.put(labelName, label);
        }
        return label;
    }

    // given a register name, it creates the corresponding register
    private Register getOrNewRegister(String nodeName) {
        Type type = getArmVariableSize(nodeName);
        String registerName = makeRegisterName(nodeName);
        Register newRegister = this.llvmFunction.getOrNewRegister(registerName, type);
        // if the register is part of the return register, it has to be added to "pendingRegisters"
        // this is done because we want to create a single assignment at the end of the "asm code" block. More on that on visitAsmMetadataEntries
        // we want this to be inserted only once at the end of the asm code block
        if (!this.pendingRegisters.contains(newRegister) && isPartOfReturnRegister(nodeName) && isReturnRegisterAggregate()) {
            this.pendingRegisters.add(newRegister);
        }
        return newRegister;
    }

    private String makeRegisterName(String nodeName) {
        return "r" + nodeName;
    }

    private String cleanLabel(String label) {
        return label.replaceAll("(\\d)[a-z]", "$1");
    }

    // creates a local event if the operation performed was referencing the returnRegister
    // if the index represented by the register if part of the returnRegister AND if it not an aggregate type
    // this is performed each time we modify the returnRegister as we could have some operations behind a branch
    private void updateReturnRegisterIfModified(Register register) {
        String registerName = register.getName();
        if (isPartOfReturnRegister(registerName) && !isReturnRegisterAggregate()) {
            events.add(EventFactory.newLocal(this.returnRegister, register));
        }
    }

    // in this function we are manually visiting the tree and not using the visitor pattern for a specific reason
    // in order to understand which asm register references which llvm register (argsRegisters), we have to read the clobbers.
    // In order to do this, we
    // 1) collect the names of the asm registers that are present in hte asm code
    // 2) collect the clobbers -- also done manually, as we cannot traverse the ANTLR tree from the VisitMetadata
    //      as it would execute the mapping to "pendingRegister mentioned above".
    // 3) Having registerNames AND clobbers, we can map using the rule explained in the first comment above.
    // NOTE : visitChildren would call the visitor code of the single instructions not knowing how to map the registers. 
    //            This is the main reason why we do it manually
    @Override
    public List<Event> visitAsm(InlineAsmParser.AsmContext ctx) {

        // extract registers from instructions
        // we force to pass the whole subtree because we still do not know how to map the registers
        // until we do not visit the RHS of the tree, which contains the clobbers
        List<InlineAsmParser.AsmInstrEntriesContext> instructions = ctx.asmInstrEntries();
        for (InlineAsmParser.AsmInstrEntriesContext instruction : instructions) {
            InlineAsmParser.ArmInstrContext instrCtx = instruction.armInstr();
            if (instrCtx != null) {
                collectRegisters(instrCtx);
            }
        }
        // the registers have to be sorted in order to map them to the clobber
        asmRegisterNames.sort((s1, s2) -> Integer.compare(extractNumberFromRegisterName(s1), extractNumberFromRegisterName(s2)));

        // here we manually visit the clobbers and we can't use the visitor pattern as we would be forced to execute the asmMetadataEntries,
        // and such visitor has the task of mapping the operations performed in an aggregateType return Register to the llvm. 
        // as before, in order to avoid executing the visitor code w.h. to manually traverse the tree
        ArrayList<InlineAsmParser.ClobberContext> clobbers = new ArrayList<>();
        InlineAsmParser.AsmMetadataEntriesContext metadataEntries = ctx.asmMetadataEntries();
        List<InlineAsmParser.MetaInstrContext> metaInstrs = metadataEntries.metaInstr();
        for (InlineAsmParser.MetaInstrContext metaInstr : metaInstrs) {
            if (metaInstr.clobber() != null) {
                clobbers.add(metaInstr.clobber());
            }
        }
        
        // now that w.h. both all of the registers which appeared in the inline asm and the clobbers, we can finally map them
        // following the rule at the start of the file
        if (!asmRegisterNames.isEmpty() && !this.argsRegisters.isEmpty()) {
            // this keeps track of where we are in the asmRegisterNames list
            int asmRegisterNameIndex = 0;
            for (InlineAsmParser.ClobberContext clobber : clobbers) {
                if (isClobberNumeric(clobber)) {
                    // we have found something like '3', so we have to overlap the returnRegister[3] with the current argument
                    processNumericClobber(clobber, asmRegisterNameIndex);
                    asmRegisterNameIndex++;
                } else if (isClobberMemoryLocation(clobber)) {
                    //if clobber is =*m it means that such pointer is a memory location, so we do not map to any register
                    // the if is still here to clarify the 
                } else {
                    // it can be either an Output clobber or an Input clobber, so we follow the aforementioned rules
                    processGeneralPurposeClobber(clobber, asmRegisterNameIndex);
                    asmRegisterNameIndex++;
                }
            }
        }
        visitChildren(ctx);
        return this.events;
    }

    // tells if clobber is a numberic clobber e.g. '3'
    private boolean isClobberNumeric(InlineAsmParser.ClobberContext clobber) {
        return clobber.OverlapInOutRegister() != null;
    }
    // tells us is the clobber is a memory location '=*m'
    private boolean isClobberMemoryLocation(InlineAsmParser.ClobberContext clobber) {
        return clobber.PointerToMemoryLocation() != null;
    }
    // tells us if the clobber is an output clobber e.g. '=r' or '=&r'
    private boolean isClobberOutputConstraint(InlineAsmParser.ClobberContext clobber) {
        return clobber.OutputOpAssign() != null;
    }
    // tells us if the clobber is an input clobber e.g. 'Q' or 'r' or '*Q'
    private boolean isClobberInputConstraint(InlineAsmParser.ClobberContext clobber) {
        return clobber.MemoryAddress() != null || clobber.InputOpGeneralReg() != null;
    }

    // this recursive function is used to visit all children of the given node and appending all of the registers that we find
    // e.g. "ldr $0, $1 ; str $1, $2" has to append $0, $1, $2
    // we are forced to visit the tree "by hand" as we do not want the visitor code of such instructions to be executed
    // as it would ask to create registers, but at this point we still do not know how to map from asm to llvm ones
    private void collectRegisters(ParseTree node) {
        if (node == null) {
            return;
        } else if (node instanceof InlineAsmParser.RegisterContext) {
            String asmRegisterName = node.getText();
            if (asmRegisterName != null && !asmRegisterNames.contains(asmRegisterName)) {
                asmRegisterNames.add(asmRegisterName);
            }
        }
        for (int i = 0; i < node.getChildCount(); i++) {
            collectRegisters(node.getChild(i));
        }
    }

    private void processNumericClobber(InlineAsmParser.ClobberContext clobber, int asmRegisterNameIndex) {
        // https://llvm.org/docs/LangRef.html#input-constraints
        // For example, a constraint string of “=r,1” says to assign a register for output, and use that register as an input as well (it being the 1st constraint).
        // so we have to get the i-th return Value and map it to argsRegisters
        int number = Integer.parseInt(clobber.getText());
        if (number < 0 || number > getSizeOfReturnRegister()) {
            throw new ParsingException("The number provided in the clobber is not a valid index for any return value");
        }
        String name = asmRegisterNames.get(number);
        Register toBeChanged = getOrNewRegister(name);
        // since we increment the asmRegisterNameIndex each time we traversed the clobbers, we have to shift it by the number of return values
        // r11 = call { i32, i32, i32, i32 } asm "...", "=&r,=&r,=&r,=&r,*Q,3"(ptr r10, i32 r8)
        // we know from the number contained in the clobber that $3 has to be mapped to an argsRegisters. 
        // Since the value of asmRegisterNameIndex in this case is 5, we shift it by 4 (the number of return values) and we get 1
        // we can therefore access argsRegisters[1], which gives us the correct index for the arg Register.
        events.add(EventFactory.newLocal(toBeChanged, this.argsRegisters.get(asmRegisterNameIndex - getSizeOfReturnRegister())));
    }

    private void processGeneralPurposeClobber(InlineAsmParser.ClobberContext clobber, int asmRegisterNameIndex) {
        // via asmRegisterNameIndex we get the right register that we need to map
        String registerName = asmRegisterNames.get(asmRegisterNameIndex);
        Register newRegister = getOrNewRegister(registerName);
        // after having created the register, we have to see if we have to map it to any llvm register
        if (isClobberOutputConstraint(clobber)) {
            // Clobber maps to the returnRegister, we just skip it as we are assigning them later in the visitMetadataEntries
        } else if (isClobberInputConstraint(clobber)) {
            int number = extractNumberFromRegisterName(registerName);
            // now we have to shift the value contained inside the register name to the right index.
            // e.g. r13 = call { i32, i32 } asm "...", "=&r,=&r,r,r,*Q"(i32 r9, i32 r10, ptr r12)
            // we "skipped" the first 2 as they are to be mapped to the returnRegister. 
            // (Skipped here means we incremented asmRegisterNameIndex without mapping to anything)
            // let's say we are at $3. In order to access the correct "arg" in argsRegisters, we have to shift by the size of return registers
            // so we would get 3 (from $3) - 2 (from size of return registers) = 1, which is the correct index for the argsRegisters
            events.add(EventFactory.newLocal(newRegister, this.argsRegisters.get(number - getSizeOfReturnRegister())));
        } else {
            throw new ParsingException("Unknown clobber type " + clobber);
        }
    }

    @Override
    public Object visitLoad(InlineAsmParser.LoadContext ctx) {
        Register register = (Register) ctx.register(0).accept(this);
        Register address = (Register) ctx.register(1).accept(this);
        events.add(EventFactory.newLoad(register, address));
        updateReturnRegisterIfModified(register);
        return null;
    }

    @Override
    public Object visitLoadAcquire(InlineAsmParser.LoadAcquireContext ctx) {
        Register register = (Register) ctx.register(0).accept(this);
        Register address = (Register) ctx.register(1).accept(this);
        events.add(EventFactory.newLoadWithMo(register, address, Tag.ARMv8.MO_ACQ));
        updateReturnRegisterIfModified(register);
        return null;
    }

    @Override
    public Object visitLoadExclusive(InlineAsmParser.LoadExclusiveContext ctx) {
        Register register = (Register) ctx.register(0).accept(this);
        Register address = (Register) ctx.register(1).accept(this);
        events.add(EventFactory.newRMWLoadExclusive(register, address));
        updateReturnRegisterIfModified(register);
        return null;
    }

    @Override
    public Object visitLoadAcquireExclusive(InlineAsmParser.LoadAcquireExclusiveContext ctx) {
        Register register = (Register) ctx.register(0).accept(this);
        Register address = (Register) ctx.register(1).accept(this);
        events.add(EventFactory.newRMWLoadExclusiveWithMo(register, address, Tag.ARMv8.MO_ACQ));
        updateReturnRegisterIfModified(register);
        return null;
    }

    @Override
    public Object visitAdd(InlineAsmParser.AddContext ctx) {
        Register resultRegister = (Register) ctx.register(0).accept(this);
        Register leftRegister = (Register) ctx.register(1).accept(this);
        Register rightRegister = (Register) ctx.register(2).accept(this);
        Expression exp = expressions.makeAdd(leftRegister, rightRegister);
        events.add(EventFactory.newLocal(resultRegister, exp));
        updateReturnRegisterIfModified(resultRegister);
        return null;
    }

    @Override
    public Object visitSub(InlineAsmParser.SubContext ctx) {
        Register resultRegister = (Register) ctx.register(0).accept(this);
        Register leftRegister = (Register) ctx.register(1).accept(this);
        Register rightRegister = (Register) ctx.register(2).accept(this);
        Expression exp = expressions.makeSub(leftRegister, rightRegister);
        events.add(EventFactory.newLocal(resultRegister, exp));
        updateReturnRegisterIfModified(resultRegister);
        return null;
    }

    @Override
    public Object visitOr(InlineAsmParser.OrContext ctx) {
        Register resultRegister = (Register) ctx.register(0).accept(this);
        Register leftRegister = (Register) ctx.register(1).accept(this);
        Register rightRegister = (Register) ctx.register(2).accept(this);
        Expression exp = expressions.makeIntOr(leftRegister, rightRegister);
        events.add(EventFactory.newLocal(resultRegister, exp));
        updateReturnRegisterIfModified(resultRegister);
        return null;
    }

    @Override
    public Object visitAnd(InlineAsmParser.AndContext ctx) {
        Register resultRegister = (Register) ctx.register(0).accept(this);
        Register leftRegister = (Register) ctx.register(1).accept(this);
        Register rightRegister = (Register) ctx.register(2).accept(this);
        Expression exp = expressions.makeIntAnd(leftRegister, rightRegister);
        events.add(EventFactory.newLocal(resultRegister, exp));
        updateReturnRegisterIfModified(resultRegister);
        return null;
    }

    @Override
    public Object visitStore(InlineAsmParser.StoreContext ctx) {
        Register value = (Register) ctx.register(0).accept(this);
        Register address = (Register) ctx.register(1).accept(this);
        events.add(EventFactory.newStore(address, value));
        return null;
    }

    @Override
    public Object visitStoreRelease(InlineAsmParser.StoreReleaseContext ctx) {
        Register value = (Register) ctx.register(0).accept(this);
        Register address = (Register) ctx.register(1).accept(this);
        events.add(EventFactory.newStoreWithMo(address, value, Tag.ARMv8.MO_REL));
        return null;
    }

    @Override
    public Object visitStoreExclusive(InlineAsmParser.StoreExclusiveContext ctx) {
        Register freshResultRegister = (Register) ctx.register(0).accept(this);
        Register value = (Register) ctx.register(1).accept(this);
        Register address = (Register) ctx.register(2).accept(this);
        events.add(EventFactory.Common.newExclusiveStore(freshResultRegister, address, value, Tag.ARMv8.MO_RX));
        return null;
    }

    @Override
    public Object visitStoreReleaseExclusive(InlineAsmParser.StoreReleaseExclusiveContext ctx) {
        Register freshResultRegister = (Register) ctx.register(0).accept(this);
        Register value = (Register) ctx.register(1).accept(this);
        Register address = (Register) ctx.register(2).accept(this);
        events.add(EventFactory.Common.newExclusiveStore(freshResultRegister, address, value, Tag.ARMv8.MO_REL));
        return null;
    }

    @Override
    public Object visitCompare(InlineAsmParser.CompareContext ctx) {
        Register firstRegister = (Register) ctx.register().accept(this);
        expectedType = firstRegister.getType();
        Expression secondRegister = (Expression) ctx.expr().accept(this);
        this.comparator = new CmpInstruction(firstRegister, secondRegister);
        return null;
    }

    @Override
    public Object visitCompareBranchNonZero(InlineAsmParser.CompareBranchNonZeroContext ctx) {
        String cleanedLabelName = cleanLabel(ctx.LabelReference().getText());
        Label label = getOrNewLabel(cleanedLabelName);
        Register firstRegister = (Register) ctx.register().accept(this);
        Expression zero = expressions.makeZero((IntegerType) firstRegister.getType());
        Expression expr = expressions.makeIntCmp(firstRegister, IntCmpOp.NEQ, zero);
        events.add(EventFactory.newJump(expr, label));
        return null;
    }

    @Override
    public Object visitMove(InlineAsmParser.MoveContext ctx) {
        Register toRegister = (Register) ctx.register(0).accept(this);
        Register fromRegister = (Register) ctx.register(1).accept(this);
        events.add(EventFactory.newLocal(toRegister, fromRegister));
        updateReturnRegisterIfModified(toRegister);
        return null;
    }

    @Override
    public Object visitBranchEqual(InlineAsmParser.BranchEqualContext ctx) {
        String cleanedLabelName = cleanLabel(ctx.LabelReference().getText());
        Label label = getOrNewLabel(cleanedLabelName);
        Expression expr = expressions.makeIntCmp(comparator.left, IntCmpOp.EQ, comparator.right);
        events.add(EventFactory.newJump(expr, label));
        return null;
    }

    @Override
    public Object visitBranchNotEqual(InlineAsmParser.BranchNotEqualContext ctx) {
        String cleanedLabelName = cleanLabel(ctx.LabelReference().getText());
        Label label = getOrNewLabel(cleanedLabelName);
        Expression expr = expressions.makeIntCmp(comparator.left, IntCmpOp.NEQ, comparator.right);
        events.add(EventFactory.newJump(expr, label));
        return null;
    }

    @Override
    public Object visitLabelDefinition(InlineAsmParser.LabelDefinitionContext ctx) {
        String labelDefinitionNoColon = ctx.LabelDefinition().getText().replace(":", "");
        Label label = getOrNewLabel(labelDefinitionNoColon);
        events.add(label);
        return null;
    }

    // when we modified any register which was referencing the returnRegister, and if it was a aggregate register, we appended into pendingRegisters
    // now we create the aggregate Type based on those registers, and we create the event which links the inline asm registers to the return Register
    // e.g. 
    //    r$0 = load(r$3)
    //    r$1 = load(r$4)
    //    ...
    //    {0 : bv32, 1 : bv32 } r10 <- { bv32 r$0, bv32 r$1 }
    // it is put at the start of asmMetadataEntries rule, because we have to be sure that this event is created only after all the instructions have executed.
    // Moreover, we force the creation of this event here, as it needs to have the latest data AND we want to be inserted into Dat3MIR only once.
    @Override
    public Object visitAsmMetadataEntries(InlineAsmParser.AsmMetadataEntriesContext ctx) {
        if (getSizeOfReturnRegister() > 1) {
            List<Type> typesList = new LinkedList<>();
            for (Expression r : this.pendingRegisters) {
                typesList.add(((Register) r).getType());
            }
            Type aggregateType = types.getAggregateType(typesList);
            Expression finalAssignExpression = expressions.makeConstruct(aggregateType, this.pendingRegisters);
            events.add(EventFactory.newLocal(this.returnRegister, finalAssignExpression));
        }
        return null;
    }

    @Override
    public Object visitExpr(InlineAsmParser.ExprContext ctx) {
        return ctx.getChild(0).accept(this);
    }

    @Override
    public Object visitRegister(InlineAsmParser.RegisterContext ctx) {
        return getOrNewRegister(ctx.Register().getText());
    }

    @Override
    public Object visitValue(InlineAsmParser.ValueContext ctx) {
        String valueString = ctx.ConstantValue().getText().substring(1);
        BigInteger value = new BigInteger(valueString, 10);
        checkState(expectedType instanceof IntegerType, "Expected type is not an integer type");
        return expressions.makeValue(value, (IntegerType) expectedType);
    }

    @Override
    public Object visitArmFence(InlineAsmParser.ArmFenceContext ctx) {
        // check which type of fence it is : DataMemoryBarrier or DataSynchronizationBarrier
        String type = ctx.DataMemoryBarrier() == null ? ctx.DataSynchronizationBarrier().getText() : ctx.DataMemoryBarrier().getText();
        String option = ctx.FenceArmOpt().getText();
        String barrier = type + " " + option;
        switch (barrier) {
            case "dmb ish" ->
                events.add(EventFactory.AArch64.DMB.newISHBarrier());
            case "dmb ishld" ->
                events.add(EventFactory.AArch64.DMB.newISHLDBarrier());
            case "dmb sy" ->
                events.add(EventFactory.AArch64.DMB.newSYBarrier());
            case "dmb st" ->
                events.add(EventFactory.AArch64.DMB.newSTBarrier());
            case "dmb ishst" ->
                events.add(EventFactory.AArch64.DMB.newISHSTBarrier());
            case "dsb ish" ->
                events.add(EventFactory.AArch64.DSB.newISHBarrier());
            case "dsb ishld" ->
                events.add(EventFactory.AArch64.DSB.newISHLDBarrier());
            case "dsb sy" ->
                events.add(EventFactory.AArch64.DSB.newSYBarrier());
            case "dsb ishst" ->
                events.add(EventFactory.AArch64.DSB.newISHSTBarrier());
            default ->
                throw new ParsingException("Barrier not implemented");
        }
        return null;
    }

    @Override
    public Object visitRiscvFence(InlineAsmParser.RiscvFenceContext ctx) {
        String type = ctx.RISCVFence().getText();
        String firstOption = ctx.FenceRISCVOpt(0).getText();
        String secondOption = ctx.FenceRISCVOpt(1) == null ? "" : ctx.FenceRISCVOpt(1).getText();
        String barrier = type + " " + firstOption + " " + secondOption;
        switch (barrier) {
            case "fence r r" ->
                events.add(EventFactory.RISCV.newRRFence());
            case "fence r w" ->
                events.add(EventFactory.RISCV.newRWFence());
            case "fence r rw" ->
                events.add(EventFactory.RISCV.newRRWFence());
            case "fence w r" ->
                events.add(EventFactory.RISCV.newWRFence());
            case "fence w w" ->
                events.add(EventFactory.RISCV.newWWFence());
            case "fence w rw" ->
                events.add(EventFactory.RISCV.newWRWFence());
            case "fence rw r" ->
                events.add(EventFactory.RISCV.newRWRFence());
            case "fence rw w" ->
                events.add(EventFactory.RISCV.newRWWFence());
            case "fence rw rw" ->
                events.add(EventFactory.RISCV.newRWRWFence());
            case "fence tso" ->
                events.add(EventFactory.RISCV.newTsoFence());
            case "fence i" ->
                events.add(EventFactory.RISCV.newSynchronizeFence());
            default ->
                throw new ParsingException("Barrier not implemented");
        }
        return visitChildren(ctx);
    }

    @Override
    public Object visitX86Fence(InlineAsmParser.X86FenceContext ctx) {
        String barrier = ctx.X86Fence().getText();
        switch (barrier) {
            case "mfence" ->
                events.add(EventFactory.X86.newMemoryFence());
            default ->
                throw new ParsingException("Barrier not implemented");
        }
        return visitChildren(ctx);
    }

    @Override
    public Object visitPpcFence(InlineAsmParser.PpcFenceContext ctx) {
        String barrier = ctx.PPCFence().getText();
        switch (barrier) {
            case "sync" ->
                events.add(EventFactory.Power.newSyncBarrier());
            case "isync" ->
                events.add(EventFactory.Power.newISyncBarrier());
            case "lwsync" ->
                events.add(EventFactory.Power.newLwSyncBarrier());
            default ->
                throw new ParsingException("Barrier not implemented");
        }
        return visitChildren(ctx);
    }
}
