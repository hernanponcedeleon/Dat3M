package com.dat3m.dartagnan.parsers.program.visitors;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.expression.type.*;
import com.dat3m.dartagnan.parsers.LLVMIRBaseVisitor;
import com.dat3m.dartagnan.parsers.LLVMIRParser.*;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.metadata.Metadata;
import com.dat3m.dartagnan.program.event.metadata.SourceLocation;
import com.dat3m.dartagnan.program.memory.Memory;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableSet;
import com.google.common.collect.Lists;
import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.tree.TerminalNode;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.math.BigInteger;
import java.util.*;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.program.event.EventFactory.*;
import static com.dat3m.dartagnan.program.event.EventFactory.Llvm.newCompareExchange;
import static com.google.common.base.Preconditions.checkState;
import static com.google.common.base.Verify.verify;

public class VisitorLlvm extends LLVMIRBaseVisitor<Expression> {

    private static final Logger logger = LogManager.getLogger(VisitorLlvm.class);

    // Global context
    private final Program program = new Program(new Memory(), Program.SourceLanguage.LLVM);
    private final TypeFactory types = TypeFactory.getInstance();
    private final ExpressionFactory expressions = ExpressionFactory.getInstance();
    private final Type pointerType = types.getPointerType();
    private final IntegerType integerType = types.getArchType();
    private final Map<String, Expression> constantMap = new HashMap<>();
    private final Map<String, TypeDefContext> typeDefinitionMap = new HashMap<>();
    private final Map<String, Type> typeMap = new HashMap<>();
    private final Map<String, MdNode> metadataSymbolTable = new LinkedHashMap<>();
    private int functionCounter;
    // Nonnull, if the visitor is inside a function body.
    private Function function;
    private final Map<String, Block> basicBlocks = new HashMap<>();
    private final Map<BlockPair, List<Event>> phiNodes = new HashMap<>();
    // Nonnull, if the visitor is inside a basic block.
    private Block block;
    // Nonnull, if the visitor is inside a value instruction.  Resolve overloading, like in literals.
    private Type expectedType;
    // Nonnull, if the visitor is inside a named instruction.
    private String currentRegisterName;
    // Nonnull, if a type has been parsed.
    private Type parsedType;

    public VisitorLlvm() {}

    public Program buildProgram() {
        ProgramBuilder.processAfterParsing(program);
        return program;
    }

    @Override
    public Expression visitCompilationUnit(CompilationUnitContext ctx) {
        // Create the metadata mapping beforehand, so that instructions can get all attachments.
        // Also parse all type definitions.
        for (final TopLevelEntityContext entity : ctx.topLevelEntity()) {
            if (entity.metadataDef() != null) {
                entity.accept(this);
            }
            if (entity.typeDef() != null) {
                entity.accept(this);
            }
        }

        // Declare all globals (functions and variables).
        for (final TopLevelEntityContext entity : ctx.topLevelEntity()) {
            if (entity.funcDecl() != null) {
                visitFuncHeader(entity.funcDecl().funcHeader());
            }
            if (entity.funcDef() != null) {
                visitFuncHeader(entity.funcDef().funcHeader());
            }
            if (entity.globalDef() != null) {
                visitGlobalDeclaration(entity.globalDef());
            }
        }

        // Parse global definitions after declarations.
        for (final TopLevelEntityContext entity : ctx.topLevelEntity()) {
            if (entity.globalDef() != null) {
                visitGlobalDef(entity.globalDef());
            }
        }

        // Parse definitions
        for (final TopLevelEntityContext entity : ctx.topLevelEntity()) {
            if (entity.metadataDef() == null &&
                    entity.globalDef() == null &&
                    entity.typeDef() == null &&
                    entity.funcDecl() == null) {
                entity.accept(this);
            }
        }
        return null;
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Top Level Entities

    @Override
    public Expression visitTypeDef(TypeDefContext ctx) {
        final String name = localIdent(ctx.LocalIdent());
        typeDefinitionMap.put(name, ctx);
        return null;
    }

    @Override
    public Expression visitFuncHeader(FuncHeaderContext ctx) {
        final String name = globalIdent(ctx.GlobalIdent());
        final Type returnType = parseType(ctx.type());
        final List<Type> parameterTypes = new ArrayList<>();
        final List<String> parameterNames = new ArrayList<>();
        int unnamedParameters = 0;
        for (ParamContext parameter : ctx.params().param()) {
            if (parameter.type().getText().equals("metadata")) {
                //TODO also declare this.
                return null;
            }
            parameterTypes.add(parseType(parameter.type()));
            final String parameterName = parameter.LocalIdent() != null ?
                    localIdent(parameter.LocalIdent()) :
                    "dummy_" + (unnamedParameters++);
            parameterNames.add(adjustRegisterName(parameterName));
        }
        final boolean isVarArgs = ctx.params().ellipsis != null;
        final FunctionType functionType = types.getFunctionType(returnType, parameterTypes, isVarArgs);
        //TODO there are more attributes in ctx
        final var declaredFunction = new Function(name, functionType, parameterNames, functionCounter++, null);

        program.addFunction(declaredFunction);
        constantMap.put(name, declaredFunction);
        return null;
    }

    @Override
    public Expression visitFuncDecl(FuncDeclContext ctx) {
        // Do nothing, already declared from visitFuncHeader
        return null;
    }

    @Override
    public Expression visitFuncDef(FuncDefContext ctx) {
        // Assert the function was already declared from visitFuncHeader
        final String name = globalIdent(ctx.funcHeader().GlobalIdent());
        function = program.getFunctionByName(name).orElseThrow();
        // The grammar requires at least one block, thus an entry and an exit.
        for (final BasicBlockContext basicBlockContext : ctx.funcBody().basicBlock()) {
            block = getBlock(basicBlockContext.LabelIdent());
            final List<Metadata> blockHeaderMetadata;
            if (!basicBlockContext.instruction().isEmpty()) {
                blockHeaderMetadata = parseMetadataAttachment(basicBlockContext.instruction(0).metadataAttachment());
            } else {
                blockHeaderMetadata = parseMetadataAttachment(basicBlockContext.terminator().metadataAttachment());
            }
            blockHeaderMetadata.forEach(block.label::setMetadata);
            for (final InstructionContext instructionContext : basicBlockContext.instruction()) {
                parseBlockInstructionWithMetadata(instructionContext, instructionContext.metadataAttachment());
            }
            parseBlockInstructionWithMetadata(basicBlockContext.terminator(), basicBlockContext.terminator().metadataAttachment());
            // We copy the source information of the first block event to the block label.
            // This might give slightly wrong source information for labels.
            block.label.copyMetadataFrom(block.events.get(0), SourceLocation.class);
            block = null;
        }
        //TODO validate: all basic blocks have a terminator, there is one entry, at least one exit, etc.
        for (final BasicBlockContext basicBlockContext : ctx.funcBody().basicBlock()) {
            final Block block = getBlock(basicBlockContext.LabelIdent());
            function.append(block.label);
            for (final Event event : block.events) {
                function.append(event);
            }

            final Event terminator = block.events.get(block.events.size() - 1);
            for (final Map.Entry<BlockPair, List<Event>> phiNode : phiNodes.entrySet()) {
                final BlockPair blockPair = phiNode.getKey();
                if (blockPair.from == block) {
                    for (Event event : phiNode.getValue()) {
                        event.copyAllMetadataFrom(terminator);
                        function.append(event);
                    }
                    final Event gotoTargetBlock = newGoto(blockPair.to.label);
                    gotoTargetBlock.copyAllMetadataFrom(terminator);
                    function.append(gotoTargetBlock);
                }
            }
        }
        function.validate();
        function = null;
        basicBlocks.clear();
        phiNodes.clear();
        return null;
    }

    private void parseBlockInstructionWithMetadata(ParserRuleContext instructionCtx,
                                                   List<MetadataAttachmentContext> metadataContexts) {
        final List<Metadata> currentMetadata = parseMetadataAttachment(metadataContexts);
        final int prevBlockSize = block.events.size();
        instructionCtx.accept(this);
        block.events.subList(prevBlockSize, block.events.size()).forEach(
                e -> currentMetadata.forEach(e::setMetadata)
        );
    }

    private Block getBlock(TerminalNode node) {
        final String ident = node == null ? null : node.getText();
        assert ident == null || ident.endsWith(":");
        // In serialized form, only the entry block should be able to omit its label.
        // The label is named using a counter for temporaries, which resets for each function.
        // see https://llvm.org/docs/LangRef.html#functions
        // This code assumes that all function parameters are also using this counter.
        final String labelName = ident == null ?
                String.valueOf(function.getParameterRegisters().size()) :
                //FIXME this replacing avoids conflicts with LoopAnalysis
                ident.substring(0, ident.length() - 1).replace(".loop", ".\\loop");
        return getBlock(labelName);
    }

    public void visitGlobalDeclaration(GlobalDefContext ctx) {
        final String name = globalIdent(ctx.GlobalIdent());
        check(!constantMap.containsKey(name), "Redeclared constant in %s.", ctx);
        final int size = types.getMemorySizeInBytes(parseType(ctx.type()));
        final MemoryObject globalObject = program.getMemory().allocate(size, true);
        globalObject.setCVar(name);
        if (ctx.threadLocal() != null) {
            globalObject.setIsThreadLocal(true);
        }
        // TODO: mark the global as constant, if possible.
        constantMap.put(name, globalObject);
    }

    @Override
    public Expression visitGlobalDef(GlobalDefContext ctx) {
        final String name = globalIdent(ctx.GlobalIdent());
        final MemoryObject globalObject = (MemoryObject) constantMap.get(name);
        final Type type = parseType(ctx.type());
        final boolean isExternal = ctx.externalLinkage() != null;
        final boolean hasInitializer = ctx.constant() != null;

        check (!(isExternal && hasInitializer), "External global cannot have initializer: %s", ctx);
        check (isExternal || hasInitializer, "Global without initializer; %s", ctx);

        final Expression value = hasInitializer ? checkExpression(type, ctx.constant()) : makeNonDetOfType(type);
        setInitialMemoryFromConstant(globalObject, 0, value);
        return null;
    }

    private void setInitialMemoryFromConstant(MemoryObject memObj, int offset, Expression constant) {
        if (constant.getType() instanceof ArrayType arrayType) {
            assert constant instanceof Construction;
            final Construction constArray = (Construction) constant;
            final List<Expression> arrayElements = constArray.getArguments();
            final int stepSize = types.getMemorySizeInBytes(arrayType.getElementType());
            for (int i = 0; i < arrayElements.size(); i++) {
                setInitialMemoryFromConstant(memObj, offset + i * stepSize, arrayElements.get(i));
            }
        } else if (constant.getType() instanceof AggregateType) {
            assert constant instanceof Construction;
            final Construction constStruct = (Construction) constant;
            final List<Expression> structElements = constStruct.getArguments();
            int currentOffset = offset;
            for (Expression structElement : structElements) {
                setInitialMemoryFromConstant(memObj, currentOffset, structElement);
                currentOffset += types.getMemorySizeInBytes(structElement.getType());
            }
        } else if (constant.getType() instanceof IntegerType) {
            memObj.setInitialValue(offset, constant);
        } else {
            throw new UnsupportedOperationException("Unrecognized constant value: " + constant);
        }
    }

    private Block getBlock(String label) {
        return basicBlocks.computeIfAbsent(label,
                k -> {
                    final Label l = newLabel("l" + k);
                    l.setFunction(function);
                    return new Block(l);
                });
    }

    private List<Metadata> parseMetadataAttachment(List<MetadataAttachmentContext> metadataAttachmentContexts) {
        if (metadataAttachmentContexts.isEmpty()) {
            return List.of();
        }

        final List<Metadata> metadata = new ArrayList<>();
        //FIXME: This code only looks for DILocation metadata,
        // and it only extracts the information needed to construct SourceLocation metadata
        for (MetadataAttachmentContext metadataCtx:  metadataAttachmentContexts) {
            MdNode mdNode = (MdNode) metadataCtx.accept(this);
            assert mdNode instanceof MdReference;
            mdNode = metadataSymbolTable.get(((MdReference) mdNode).mdName());

            if (mdNode instanceof SpecialMdTupleNode diLocationNode && diLocationNode.nodeType() == SpecialMdTupleNode.Type.DILocation) {
                SpecialMdTupleNode scope = diLocationNode;
                while (scope.getField("scope").isPresent()) {
                    scope = (SpecialMdTupleNode) metadataSymbolTable.get(scope.<MdReference>getField("scope").orElseThrow().mdName());
                }
                assert scope.nodeType() == SpecialMdTupleNode.Type.DIFile;
                final String filename = scope.<MdGenericValue<String>>getField("filename").orElseThrow().value();
                final String directory = scope.<MdGenericValue<String>>getField("directory").orElseThrow().value();
                final int lineNumber = diLocationNode.<MdGenericValue<BigInteger>>getField("line").orElseThrow().value().intValue();
                metadata.add(new SourceLocation((directory + "/" + filename).intern(), lineNumber));
            }
        }

        return metadata;
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Terminators

    @Override
    public Expression visitBrTerm(BrTermContext ctx) {
        block.events.add(newGoto(getJumpLabel(ctx.label())));
        return null;
    }

    @Override
    public Expression visitCondBrTerm(CondBrTermContext ctx) {
        final Type type = parseIntType(ctx.IntType());
        final Expression guard = checkExpression(type, ctx.value());
        final Expression cast = expressions.makeBooleanCast(guard);
        block.events.add(newJump(cast, getJumpLabel(ctx.label(0))));
        block.events.add(newGoto(getJumpLabel(ctx.label(1))));
        return null;
    }

    @Override
    public Expression visitSwitchTerm(SwitchTermContext ctx) {
        final Expression switchValue = visitTypeValue(ctx.typeValue());
        final Label defaultTarget = getJumpLabel(ctx.label());
        for (LlvmcaseContext caseCtx : ctx.llvmcase()) {
            final Label jumpTarget = getJumpLabel(caseCtx.label());
            final Expression caseCheck = expressions.makeEQ(switchValue, visitTypeConst(caseCtx.typeConst()));
            block.events.add(newJump(caseCheck, jumpTarget));
        }
        block.events.add(newGoto(defaultTarget));

        return null;
    }

    @Override
    public Expression visitCallInst(CallInstContext ctx) {
        // see https://llvm.org/docs/LangRef.html#call-instruction
        final Type type = parseType(ctx.type());
        // Calls can either list the full function type or just the return type.
        final Type returnType = type instanceof FunctionType funcType ? funcType.getReturnType() : type;

        final var arguments = new ArrayList<Expression>();
        for (final ArgContext argument : ctx.args().arg()) {
            if (argument.value() == null) {
                //TODO metadata calls are ignored
                return null;
            }
            assert argument.concreteType() != null;
            final Type argumentType = parseType(argument.concreteType());
            arguments.add(checkExpression(argumentType, argument.value()));
        }

        final Register resultRegister = currentRegisterName == null ? null :
                getOrNewRegister(currentRegisterName, returnType);

        if (ctx.inlineAsm() != null) {
            // see https://llvm.org/docs/LangRef.html#inline-assembler-expressions
            //TODO add support form inline assembly
            //FIXME ignore side effects of inline assembly
            if (resultRegister != null) {
                block.events.add(newLocal(resultRegister, makeNonDetOfType(returnType)));
            }
            return resultRegister;
        }

        final Expression callTarget = checkPointerExpression(ctx.value());
        if (callTarget == null) {
            //FIXME ignores metadata functions, but also undeclared functions
            return null;
        }

        // Build FunctionType from return type and argument types
        final FunctionType funcType = type instanceof FunctionType t ? t :
                types.getFunctionType(returnType, Lists.transform(arguments, Expression::getType));

        final Event call = currentRegisterName == null ?
                newVoidFunctionCall(funcType, callTarget, arguments) :
                newValueFunctionCall(resultRegister, funcType, callTarget, arguments);
        block.events.add(call);
        return resultRegister;
    }

    @Override
    public Expression visitRetTerm(RetTermContext ctx) {
        final Expression value;
        if (ctx.concreteType() != null) {
            final Type type = parseType(ctx.concreteType());
            value = type instanceof VoidType ? null : checkExpression(type, ctx.value());
        } else {
            value = null;
        }
        block.events.add(newFunctionReturn(value));
        return null;
    }

    @Override
    public Expression visitUnreachableTerm(UnreachableTermContext ctx) {
        block.events.add(newAbortIf(expressions.makeTrue()));
        return null;
    }

    private Label getJumpLabel(LabelContext context) {
        final Block target = getBlock(localIdent(context.LocalIdent()));
        final Event label = getPhiNode(block, target).get(0);
        verify(label instanceof Label);
        return (Label) label;
    }

    private List<Event> getPhiNode(Block from, Block to) {
        final BlockPair pair = new BlockPair(from, to);
        final List<Event> find = phiNodes.get(pair);
        if (find != null) {
            return find;
        }
        final var newNode = new ArrayList<Event>();
        newNode.add(newLabel(from.label.getName() + "." + to.label.getName()));
        phiNodes.put(pair, newNode);
        return newNode;
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Instructions

    @Override
    public Expression visitLocalDefInst(LocalDefInstContext ctx) {
        // each visitor may treat the register differently
        // i.e. a loadInst generates a load event
        currentRegisterName = localIdent(ctx.LocalIdent());
        final Expression expression = ctx.valueInstruction().accept(this);
        currentRegisterName = null;

        if (!(expression instanceof Register)) {
            throw new UnsupportedOperationException(String.format("Parsing of instruction %s.", ctx.getText()));
        }
        return null;
    }

    private Register getOrNewCurrentRegister(Type type) {
        return getOrNewRegister(currentRegisterName, type);
    }

    private Register assignToRegister(Expression expression) {
        Register register = getOrNewCurrentRegister(expression.getType());
        block.events.add(newLocal(register, expression));
        return register;
    }

    @Override
    public Expression visitStoreInst(StoreInstContext ctx) {
        final var atomic = ctx.atomic != null;
        final Expression value = visitTypeValue(ctx.typeValue(0));
        final Expression address = visitTypeValue(ctx.typeValue(1));
        check(address.getType().equals(pointerType), "Non-pointer type in %s.", ctx);
        final String mo = atomic ? parseMemoryOrder(ctx.atomicOrdering()) : "";
        final Event store = atomic ? Llvm.newStore(address, value, mo) : newStore(address, value);
        block.events.add(store);
        return null;
    }

    @Override
    public Expression visitFenceInst(FenceInstContext ctx) {
        final String mo = parseMemoryOrder(ctx.atomicOrdering());
        block.events.add(Llvm.newFence(mo));
        return null;
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Instructions producing a value

    @Override
    public Expression visitAllocaInst(AllocaInstContext ctx) {
        // see https://llvm.org/docs/LangRef.html#alloca-instruction
        final Register register = getOrNewCurrentRegister(pointerType);
        //final var inalloca = ctx.inAllocaTok != null;
        //final var swifterror = ctx.swiftError != null;
        final Type elementType = parseType(ctx.type());
        final Expression sizeExpression;
        if (ctx.typeValue() == null) {
            sizeExpression = expressions.makeOne(integerType);
        } else {
            final Type sizeType = parseType(ctx.typeValue().firstClassType());
            sizeExpression = checkExpression(sizeType, ctx.typeValue().value());
        }
        //final int alignment = parseAlignment(ctx.align());
        //final int addressSpace = parseAddressSpace(ctx.addrSpace());
        block.events.add(EventFactory.newAlloc(register, elementType, sizeExpression, false));
        return register;
    }

    @Override
    public Expression visitLoadInst(LoadInstContext ctx) {
        final var atomic = ctx.atomic != null;
        final Register register = getOrNewCurrentRegister(parseType(ctx.type()));
        //final var isVolatile = ctx.llvmvolatile != null;
        //final SyncScopeContext syncScope = ctx.syncScope(); // == null || atomic
        //final AlignContext align = ctx.align(); // nullable
        final String mo = atomic ? parseMemoryOrder(ctx.atomicOrdering()) : "";
        checkPointerType(ctx.typeValue());
        final Expression address = checkPointerExpression(ctx.typeValue().value());
        final Event load = atomic ? Llvm.newLoad(register, address, mo) : newLoad(register, address);
        block.events.add(load);
        return register;
    }

    @Override
    public Expression visitPhiInst(PhiInstContext ctx) {
        final Type type = parseType(ctx.type());
        final Register register = getOrNewCurrentRegister(type);
        for (final IncContext inc : ctx.inc()) {
            final Block target = getBlock(localIdent(inc.LocalIdent()));
            final Expression expression = checkExpression(type, inc.value());
            getPhiNode(target, block).add(newLocal(register, expression));
        }
        return register;
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Calculations

    @Override
    public Expression visitICmpInst(ICmpInstContext ctx) {
        final Expression left = visitTypeValue(ctx.typeValue());
        final Expression right = checkExpression(left.getType(), ctx.value());
        final String operator = ctx.iPred().getText();
        final Expression compared = switch (operator) {
            case "eq" -> expressions.makeEQ(left, right);
            case "ne" -> expressions.makeNEQ(left, right);
            case "slt", "ult" -> expressions.makeLT(left, right, operator.startsWith("s"));
            case "sle", "ule" -> expressions.makeLTE(left, right, operator.startsWith("s"));
            case "sgt", "ugt" -> expressions.makeGT(left, right, operator.startsWith("s"));
            case "sge", "uge" -> expressions.makeGTE(left, right, operator.startsWith("s"));
            default -> throw new ParsingException(String.format("Unknown predicate in %s.", ctx.getText()));
        };
        // LLVM does not support a distinct boolean type.
        return assignToRegister(expressions.makeIntegerCast(compared, getIntegerType(1), false));
    }

    @Override
    public Expression visitAddInst(AddInstContext ctx) {
        final Expression left = visitTypeValue(ctx.typeValue());
        final Expression right = checkExpression(left.getType(), ctx.value());
        return assignToRegister(expressions.makeADD(left, right));
    }

    @Override
    public Expression visitSubInst(SubInstContext ctx) {
        final Expression left = visitTypeValue(ctx.typeValue());
        final Expression right = checkExpression(left.getType(), ctx.value());
        return assignToRegister(expressions.makeSUB(left, right));
    }

    @Override
    public Expression visitMulInst(MulInstContext ctx) {
        final Expression left = visitTypeValue(ctx.typeValue());
        final Expression right = checkExpression(left.getType(), ctx.value());
        return assignToRegister(expressions.makeMUL(left, right));
    }

    @Override
    public Expression visitShlInst(ShlInstContext ctx) {
        final Expression left = visitTypeValue(ctx.typeValue());
        final Expression right = checkExpression(left.getType(), ctx.value());
        return assignToRegister(expressions.makeLSH(left, right));
    }

    @Override
    public Expression visitLShrInst(LShrInstContext ctx) {
        final Expression left = visitTypeValue(ctx.typeValue());
        final Expression right = checkExpression(left.getType(), ctx.value());
        return assignToRegister(expressions.makeRSH(left, right, false));
    }

    @Override
    public Expression visitAShrInst(AShrInstContext ctx) {
        final Expression left = visitTypeValue(ctx.typeValue());
        final Expression right = checkExpression(left.getType(), ctx.value());
        return assignToRegister(expressions.makeRSH(left, right, true));
    }

    @Override
    public Expression visitAndInst(AndInstContext ctx) {
        final Expression left = visitTypeValue(ctx.typeValue());
        final Expression right = checkExpression(left.getType(), ctx.value());
        return assignToRegister(expressions.makeAND(left, right));
    }

    @Override
    public Expression visitOrInst(OrInstContext ctx) {
        final Expression left = visitTypeValue(ctx.typeValue());
        final Expression right = checkExpression(left.getType(), ctx.value());
        return assignToRegister(expressions.makeOR(left, right));
    }

    @Override
    public Expression visitXorInst(XorInstContext ctx) {
        final Expression left = visitTypeValue(ctx.typeValue());
        final Expression right = checkExpression(left.getType(), ctx.value());
        final Expression xorExpr;
        if ((right instanceof IValue iValue && iValue.getType().isMathematical()
            && (iValue.isZero() || iValue.isOne()))) {
            // NOTE: If we parse the program with mathematical integers, we try to eliminate "xor 1" expressions.
            // The reason is that "xor 1" is used to implement boolean negations, i.e., even if the C source program
            // has no bitwise operators, "xor 1" is frequently added by the compiler.
            // Not eliminating this operator frequently results in theory-mixing that the SMT-backend cannot handle.
            if (iValue.isZero()) {
                xorExpr = left;
            } else {
                //FIXME: This is only valid on "xor 1" applied to "i1" operators, but is unsound for any other bit-width.
                xorExpr = expressions.makeConditional(
                        expressions.makeEQ(left, expressions.makeGeneralZero(left.getType())),
                        expressions.makeOne((IntegerType) left.getType()),
                        expressions.makeZero((IntegerType) left.getType())
                );
            }
        } else {
            xorExpr = expressions.makeXOR(left, right);
        }
        return assignToRegister(xorExpr);
    }

    @Override
    public Expression visitSRemInst(SRemInstContext ctx) {
        final Expression left = visitTypeValue(ctx.typeValue());
        final Expression right = checkExpression(left.getType(), ctx.value());
        return assignToRegister(expressions.makeREM(left, right, true));
    }

    @Override
    public Expression visitURemInst(URemInstContext ctx) {
        final Expression left = visitTypeValue(ctx.typeValue());
        final Expression right = checkExpression(left.getType(), ctx.value());
        return assignToRegister(expressions.makeREM(left, right, false));
    }

    @Override
    public Expression visitUDivInst(UDivInstContext ctx) {
        final Expression left = visitTypeValue(ctx.typeValue());
        final Expression right = checkExpression(left.getType(), ctx.value());
        return assignToRegister(expressions.makeDIV(left, right, false));
    }

    @Override
    public Expression visitSDivInst(SDivInstContext ctx) {
        final Expression left = visitTypeValue(ctx.typeValue());
        final Expression right = checkExpression(left.getType(), ctx.value());
        return assignToRegister(expressions.makeDIV(left, right, true));
    }

    // Aggregate instructions

    @Override
    public Expression visitExtractValueInst(ExtractValueInstContext ctx) {
        final Type type = parseType(ctx.typeValue().firstClassType());
        check(type instanceof AggregateType, "Non-aggregate type in %s.", ctx);
        Expression expression = checkExpression(type, ctx.typeValue().value());
        for (final TerminalNode literalNode : ctx.IntLit()) {
            final int index = Integer.parseInt(literalNode.getText());
            expression = expressions.makeExtract(index, expression);
        }
        return assignToRegister(expression);
    }

    @Override
    public Expression visitGetElementPtrInst(GetElementPtrInstContext ctx) {
        final Type type = parseType(ctx.type());
        final var operands = new ArrayList<Expression>();
        for (final TypeValueContext typeValue : ctx.typeValue()) {
            operands.add(visitTypeValue(typeValue));
        }
        assert !operands.isEmpty();
        return assignToRegister(
                expressions.makeGetElementPointer(type, operands.get(0), operands.subList(1, operands.size())));
    }

    @Override
    public Expression visitSelectInst(SelectInstContext ctx) {
        assert ctx.typeValue().size() == 3;
        final Expression guard = visitTypeValue(ctx.typeValue(0));
        final Expression trueValue = visitTypeValue(ctx.typeValue(1));
        final Expression falseValue = visitTypeValue(ctx.typeValue(2));
        final Expression cast = expressions.makeBooleanCast(guard);
        return assignToRegister(expressions.makeConditional(cast, trueValue, falseValue));
    }

    @Override
    public Expression visitCmpXchgInst(CmpXchgInstContext ctx) {
        // see https://llvm.org/docs/LangRef.html#cmpxchg-instruction
        // TODO LLVM has no distinguished boolean type.
        final Expression address = visitTypeValue(ctx.typeValue(0));
        final Expression comparator = visitTypeValue(ctx.typeValue(1));
        final Expression substitute = visitTypeValue(ctx.typeValue(2));
        check(comparator.getType().equals(substitute.getType()), "Type mismatch for comparator and new in %s.", ctx);
        final Register value = function.newRegister(comparator.getType());
        final Register asExpected = function.newRegister(types.getBooleanType());
        final boolean weak = ctx.weak != null;
        final String mo = parseMemoryOrder(ctx.atomicOrdering(0));
        block.events.add(newCompareExchange(value, asExpected, address, comparator, substitute, mo, weak));
        final Register register = currentRegisterName == null ? null :
                getOrNewCurrentRegister(types.getAggregateType(List.of(comparator.getType(), getIntegerType(1))));
        if (register != null) {
            final Expression cast = expressions.makeIntegerCast(asExpected, getIntegerType(1), false);
            final Expression result = expressions.makeConstruct(List.of(value, cast));
            block.events.add(newLocal(register, result));
        }
        return register;
    }

    @Override
    public Expression visitAtomicRMWInst(AtomicRMWInstContext ctx) {
        final Expression address = visitTypeValue(ctx.typeValue(0));
        final Expression operand = visitTypeValue(ctx.typeValue(1));
        final Type valueType = operand.getType();
        final Register register = getOrNewCurrentRegister(valueType);
        final String operator = ctx.atomicOp().getText();
        final String mo = parseMemoryOrder(ctx.atomicOrdering());
        final Event event;
        if (operator.equals("xchg")) {
            event = Llvm.newExchange(register, address, operand, mo);
        } else {
            final IOpBin op = switch (operator) {
                case "add" -> IOpBin.ADD;
                case "sub" -> IOpBin.SUB;
                case "and" -> IOpBin.AND;
                case "or" -> IOpBin.OR;
                case "xor" -> IOpBin.XOR;
                //TODO nand, min, umin, max, umax, uinc_wrap, udec_wrap, fadd, fsub, fmax, fmin
                default -> throw new UnsupportedOperationException(String.format("Unknown atomic operand %s.", ctx.getText()));
            };
            event = Llvm.newRMW(register, address, operand, op, mo);
        }
        block.events.add(event);
        return register;
    }

    // Conversions

    @Override
    public Expression visitTruncInst(TruncInstContext ctx) {
        return conversionInstruction(ctx.typeValue(), ctx.type(), false);
    }

    @Override
    public Expression visitZExtInst(ZExtInstContext ctx) {
        return conversionInstruction(ctx.typeValue(), ctx.type(), false);
    }

    @Override
    public Expression visitSExtInst(SExtInstContext ctx) {
        return conversionInstruction(ctx.typeValue(), ctx.type(), true);
    }

    @Override
    public Expression visitPtrToIntInst(PtrToIntInstContext ctx) {
        return conversionInstruction(ctx.typeValue(), ctx.type(), true);
    }

    @Override
    public Expression visitIntToPtrInst(IntToPtrInstContext ctx) {
        return conversionInstruction(ctx.typeValue(), ctx.type(), true);
    }

    @Override
    public Expression visitBitCastInst(BitCastInstContext ctx) {
        return conversionInstruction(ctx.typeValue(), ctx.type(), true);
    }

    @Override
    public Expression visitAddrSpaceCastInst(AddrSpaceCastInstContext ctx) {
        return conversionInstruction(ctx.typeValue(), ctx.type(), true);
    }

    private Register conversionInstruction(TypeValueContext operand, TypeContext target, boolean signed) {
        final Expression operandExpression = visitTypeValue(operand);
        final Type targetType = parseType(target);
        checkSupport(targetType instanceof IntegerType, "Non-integer in %s.", target);
        final Expression result = expressions.makeIntegerCast(operandExpression, (IntegerType) targetType, signed);
        return assignToRegister(result);
    }

    // =================================================================================================================
    // Expressions

    @Override
    public Expression visitConstant(ConstantContext ctx) {
        if (ctx.GlobalIdent() == null) {
            return super.visitConstant(ctx);
        }
        final String name = globalIdent(ctx.GlobalIdent());
        //TODO check for null.  Currently, this ignores metadata functions.
        return constantMap.get(name);
    }

    @Override
    public Expression visitNullConst(NullConstContext ctx) {
        return expressions.makeZero((IntegerType) pointerType);
    }

    @Override
    public Expression visitBoolConst(BoolConstContext ctx) {
        BigInteger value = Boolean.parseBoolean(ctx.getText()) ? BigInteger.ONE : BigInteger.ZERO;
        return expressions.makeValue(value, getIntegerType(1));
    }

    @Override
    public Expression visitIntConst(IntConstContext ctx) {
        final BigInteger value = parseBigInteger(ctx.IntLit());
        checkState(expectedType instanceof IntegerType, "Expected non-integer type.");
        return expressions.makeValue(value, (IntegerType) expectedType);
    }

    @Override
    public Expression visitValue(ValueContext ctx) {
        if (ctx.constant() != null) {
            return visitConstant(ctx.constant());
        }
        assert expectedType != null : "No expected type.";
        final String id = localIdent(ctx.LocalIdent());
        return getOrNewRegister(id, expectedType);
    }

    @Override
    public Expression visitTypeValue(TypeValueContext ctx) {
        final Type type = parseType(ctx.firstClassType());
        return checkExpression(type, ctx.value());
    }

    @Override
    public Expression visitArrayConst(ArrayConstContext ctx) {
        assert expectedType instanceof ArrayType;
        final Type elementType = ((ArrayType)expectedType).getElementType();
        if (ctx.StringLit() != null) {
            //TODO handle strings
            return expressions.makeGeneralZero(expectedType); // We make a 0 for now.
        }
        final List<Expression> arrayValues = new ArrayList<>();
        for (TypeConstContext typeConst : ctx.typeConst()) {
            arrayValues.add(visitTypeConst(typeConst));
        }
        return expressions.makeArray(elementType, arrayValues, true);
    }

    @Override
    public Expression visitPoisonConst(PoisonConstContext ctx) {
        // It is correct to replace a poison value with an undef value or any value of the type.
        return makeNonDetOfType(expectedType);
    }

    @Override
    public Expression visitStructConst(StructConstContext ctx) {
        List<Expression> structMembers = new ArrayList<>();
        for (TypeConstContext typeCtx : ctx.typeConst()) {
            structMembers.add(visitTypeConst(typeCtx));
        }
        return expressions.makeConstruct(structMembers);
    }

    @Override
    public Expression visitZeroInitializerConst(ZeroInitializerConstContext ctx) {
        return expressions.makeGeneralZero(expectedType);
    }

    // Operations

    @Override
    public Expression visitTypeConst(TypeConstContext ctx) {
        final Type type = parseType(ctx.firstClassType());
        return checkExpression(type, ctx.constant());
    }

    @Override
    public Expression visitAddExpr(AddExprContext ctx) {
        assert ctx.typeConst().size() == 2;
        final Expression left = visitTypeConst(ctx.typeConst(0));
        final Expression right = visitTypeConst(ctx.typeConst(1));
        return expressions.makeADD(left, right);
    }

    @Override
    public Expression visitSubExpr(SubExprContext ctx) {
        assert ctx.typeConst().size() == 2;
        final Expression left = visitTypeConst(ctx.typeConst(0));
        final Expression right = visitTypeConst(ctx.typeConst(1));
        return expressions.makeSUB(left, right);
    }

    @Override
    public Expression visitMulExpr(MulExprContext ctx) {
        assert ctx.typeConst().size() == 2;
        final Expression left = visitTypeConst(ctx.typeConst(0));
        final Expression right = visitTypeConst(ctx.typeConst(1));
        return expressions.makeMUL(left, right);
    }

    @Override
    public Expression visitShlExpr(ShlExprContext ctx) {
        assert ctx.typeConst().size() == 2;
        final Expression left = visitTypeConst(ctx.typeConst(0));
        final Expression right = visitTypeConst(ctx.typeConst(1));
        return expressions.makeLSH(left, right);
    }

    @Override
    public Expression visitLShrExpr(LShrExprContext ctx) {
        assert ctx.typeConst().size() == 2;
        final Expression left = visitTypeConst(ctx.typeConst(0));
        final Expression right = visitTypeConst(ctx.typeConst(1));
        return expressions.makeRSH(left, right, false);
    }

    @Override
    public Expression visitAShrExpr(AShrExprContext ctx) {
        assert ctx.typeConst().size() == 2;
        final Expression left = visitTypeConst(ctx.typeConst(0));
        final Expression right = visitTypeConst(ctx.typeConst(1));
        return expressions.makeRSH(left, right, true);
    }

    @Override
    public Expression visitAndExpr(AndExprContext ctx) {
        assert ctx.typeConst().size() == 2;
        final Expression left = visitTypeConst(ctx.typeConst(0));
        final Expression right = visitTypeConst(ctx.typeConst(1));
        return expressions.makeAND(left, right);
    }

    @Override
    public Expression visitOrExpr(OrExprContext ctx) {
        assert ctx.typeConst().size() == 2;
        final Expression left = visitTypeConst(ctx.typeConst(0));
        final Expression right = visitTypeConst(ctx.typeConst(1));
        return expressions.makeOR(left, right);
    }

    @Override
    public Expression visitXorExpr(XorExprContext ctx) {
        assert ctx.typeConst().size() == 2;
        final Expression left = visitTypeConst(ctx.typeConst(0));
        final Expression right = visitTypeConst(ctx.typeConst(1));
        return expressions.makeXOR(left, right);
    }

    // Conversions

    @Override
    public Expression visitTruncExpr(TruncExprContext ctx) {
        return castExpression(ctx.typeConst(), ctx.type(), false);
    }

    @Override
    public Expression visitZExtExpr(ZExtExprContext ctx) {
        return castExpression(ctx.typeConst(), ctx.type(), false);
    }

    @Override
    public Expression visitSExtExpr(SExtExprContext ctx) {
        return castExpression(ctx.typeConst(), ctx.type(), true);
    }

    @Override
    public Expression visitPtrToIntExpr(PtrToIntExprContext ctx) {
        return castExpression(ctx.typeConst(), ctx.type(), true);
    }

    @Override
    public Expression visitIntToPtrExpr(IntToPtrExprContext ctx) {
        return castExpression(ctx.typeConst(), ctx.type(), true);
    }

    @Override
    public Expression visitBitCastExpr(BitCastExprContext ctx) {
        return castExpression(ctx.typeConst(), ctx.type(), true);
    }

    @Override
    public Expression visitAddrSpaceCastExpr(AddrSpaceCastExprContext ctx) {
        return castExpression(ctx.typeConst(), ctx.type(), true);
    }

    @Override
    public Expression visitGetElementPtrExpr(GetElementPtrExprContext ctx) {
        final Type indexingType = parseType(ctx.type());
        final Expression base = visitTypeConst(ctx.typeConst());
        final var offsets = new ArrayList<Expression>();
        for (final GepIndexContext index : ctx.gepIndex()) {
            offsets.add(visitTypeConst(index.typeConst()));
        }
        return expressions.makeGetElementPointer(indexingType, base, offsets);
    }

    @Override
    public Expression visitSelectExpr(SelectExprContext ctx) {
        assert ctx.typeConst().size() == 3;
        final Expression guard = visitTypeConst(ctx.typeConst(0));
        final Expression trueValue = visitTypeConst(ctx.typeConst(1));
        final Expression falseValue = visitTypeConst(ctx.typeConst(2));
        final Expression cast = expressions.makeBooleanCast(guard);
        return expressions.makeConditional(cast, trueValue, falseValue);
    }

    @Override
    public Expression visitUndefConst(UndefConstContext ctx) {
        logger.warn("Encountered undef constant of type {}. " +
                "Constant was replaced by zero.", expectedType);
        return expressions.makeGeneralZero(expectedType);
    }

    private Expression checkPointerExpression(ParserRuleContext context) {
        return checkExpression(pointerType, context);
    }

    private Expression checkExpression(Type type, ParserRuleContext context) {
        expectedType = type;
        Expression o = context.accept(this);
        expectedType = null;
        return o;
    }

    private Expression castExpression(TypeConstContext operand, TypeContext target, boolean signed) {
        final Expression operandExpression = visitTypeConst(operand);
        final Type targetType = parseType(target);
        checkSupport(targetType instanceof IntegerType, "Non-integer type %s.", target);
        return expressions.makeIntegerCast(operandExpression, (IntegerType) targetType, signed);
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Types

    @Override
    public Expression visitIntType(IntTypeContext ctx) {
        parsedType = parseIntType(ctx.IntType());
        return null;
    }

    @Override
    public Expression visitPointerType(PointerTypeContext ctx) {
        parsedType = pointerType;
        return null;
    }

    @Override
    public Expression visitStructType(StructTypeContext ctx) {
        final var fields = new ArrayList<Type>();
        for (final TypeContext typeContext : ctx.type()) {
            fields.add(parseType(typeContext));
        }
        parsedType = types.getAggregateType(fields);
        return null;
    }

    @Override
    public Expression visitArrayType(ArrayTypeContext ctx) {
        final Type elementType = parseType(ctx.type());
        if (ctx.IntLit() == null) {
            parsedType = types.getArrayType(elementType);
        } else {
            final int size = Integer.parseUnsignedInt(ctx.IntLit().getText());
            parsedType = types.getArrayType(elementType, size);
        }
        return null;
    }

    @Override
    public Expression visitType(TypeContext ctx) {
        // translate opaque pointer types
        if (ctx.type() != null && ctx.params() == null || ctx.opaquePointerType() != null) {
            parsedType = pointerType;
            return null;
        } else if (ctx.getText().equals("void")) {
            parsedType = types.getVoidType();
            return null;
        } else if (ctx.type() != null && ctx.params() != null) {
            //FIXME: this should parse a function type "retType (params)", but
            // for now we just return "retType"
            ctx.type().accept(this);
            final Type returnType = parsedType;
            final boolean isVarArgs = ctx.params().ellipsis != null;
            final List<Type> paramTypes = new ArrayList<>();
            for (ParamContext paramContext : ctx.params().param()) {
                paramContext.type().accept(this);
                paramTypes.add(parsedType);
            }
            parsedType = types.getFunctionType(returnType, paramTypes, isVarArgs);
            return null;
        } else {
            return super.visitType(ctx);
        }
    }

    @Override
    public Expression visitNamedType(NamedTypeContext ctx) {
        final String name = localIdent(ctx.LocalIdent());
        // define types on demand, as they might be used before their definition.
        final TypeDefContext definition = typeDefinitionMap.remove(name);
        if (definition != null) {
            final Type type = parseType(definition.type());
            final Type oldType = typeMap.putIfAbsent(name, type);
            check(oldType == null, "Type redefinition in %s.", definition);
        }
        parsedType = typeMap.get(name);
        check(parsedType != null, "Undefined named type %s.", ctx);
        return null;
    }

    private Type parseIntType(TerminalNode t) {
        assert t.getText().startsWith("i");
        return getIntegerType(Integer.parseUnsignedInt(t.getText().substring(1)));
    }

    private Type parseType(ParserRuleContext context) {
        Expression o = context.accept(this);
        assert o == null : "Unexpected return value, expected type.";
        checkSupport(parsedType != null, "Unsupported type in %s.", context);
        Type type = parsedType != null ? parsedType : types.getVoidType();
        parsedType = null;
        return type;
    }

    private IntegerType getIntegerType(int precision) {
        return types.getIntegerType(precision);
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Metadata

    @Override
    public Expression visitMetadataDef(MetadataDefContext ctx) {
        final String metadataId = ctx.MetadataId().getText();
        final MdNode metadata;
        if (ctx.mdTuple() != null) {
            metadata = (MdNode) visitMdTuple(ctx.mdTuple());
        } else if (ctx.specializedMDNode() != null) {
            metadata = (MdNode) visitSpecializedMDNode(ctx.specializedMDNode());
        } else {
            metadata = MD_NOT_PARSED;
        }
        metadataSymbolTable.put(metadataId, metadata);
        return null;
    }

    @Override
    public Expression visitMetadata(MetadataContext ctx) {
        if (ctx.typeValue() != null) {
            return new MdGenericValue<>(visitTypeValue(ctx.typeValue()));
        } else if (ctx.MetadataId() != null) {
            return new MdReference(parseID(ctx.MetadataId()));
        } else if (ctx.diArgList() != null) {
            // TODO: Handle diArgList (if needed)
            return MD_NOT_PARSED;
        }
        return super.visitMetadata(ctx);
    }

    @Override
    public Expression visitMdNode(MdNodeContext ctx) {
        if (ctx.MetadataId() != null) {
            return new MdReference(parseID(ctx.MetadataId()));
        }
        return super.visitMdNode(ctx);
    }

    @Override
    public Expression visitMdTuple(MdTupleContext ctx) {
        final MdTuple mdTuple = new MdTuple(new ArrayList<>(ctx.mdField().size()));
        for (MdFieldContext field : ctx.mdField()) {
            mdTuple.mdFields().add((MdNode) visitMdField(field));
        }
        return mdTuple;
    }

    @Override
    public Expression visitMdField(MdFieldContext ctx) {
        return ctx.metadata() == null ? MD_NULL : visitMetadata(ctx.metadata());
    }

    @Override
    public Expression visitMdString(MdStringContext ctx) {
        return new MdGenericValue<>(parseQuotedString(ctx.StringLit()));
    }


    @Override
    public Expression visitSpecializedMDNode(SpecializedMDNodeContext ctx) {
        final Expression mdNode = super.visitSpecializedMDNode(ctx);
        return mdNode == null ? MD_NOT_PARSED : mdNode;
    }

    @Override
    public Expression visitDiLocation(DiLocationContext ctx) {
        return parseSpecialMdNode(SpecialMdTupleNode.Type.DILocation, ctx.diLocationField());
    }

    @Override
    public Expression visitDiLexicalBlock(DiLexicalBlockContext ctx) {
        return parseSpecialMdNode(SpecialMdTupleNode.Type.DILexicalBlock, ctx.diLexicalBlockField());
    }

    @Override
    public Expression visitDiSubprogram(DiSubprogramContext ctx) {
        return parseSpecialMdNode(SpecialMdTupleNode.Type.DISubprogram, ctx.diSubprogramField());
    }

    @Override
    public Expression visitDiFile(DiFileContext ctx) {
        return parseSpecialMdNode(SpecialMdTupleNode.Type.DIFile, ctx.diFileField());
    }

    // Generic helper method to parse special metadata nodes with named fields.
    private Expression parseSpecialMdNode(SpecialMdTupleNode.Type type, List<? extends ParserRuleContext> namedFieldContexts) {
        final List<NamedMdNode> namedFields = new ArrayList<>(namedFieldContexts.size());
        for (ParserRuleContext field : namedFieldContexts) {
            final Object parseResult = field.accept(this);
            if (parseResult instanceof NamedMdNode namedField) {
                // We skip unsupported field entries
                namedFields.add(namedField);
            }
        }
        return new SpecialMdTupleNode(type, namedFields);
    }

    // ================ Special node fields ================

    @Override
    public Expression visitNameField(NameFieldContext ctx) {
        return new NamedMdNode("name", new MdGenericValue<>(parseQuotedString(ctx.StringLit())));
    }

    @Override
    public Expression visitLineField(LineFieldContext ctx) {
        return new NamedMdNode("line", new MdGenericValue<>(parseBigInteger(ctx.IntLit())));
    }

    @Override
    public Expression visitColumnField(ColumnFieldContext ctx) {
        return new NamedMdNode("column", new MdGenericValue<>(parseBigInteger(ctx.IntLit())));
    }

    @Override
    public Expression visitScopeField(ScopeFieldContext ctx) {
        return new NamedMdNode("scope", (MdNode)visitMdField(ctx.mdField()));
    }

    @Override
    public Expression visitFileField(FileFieldContext ctx) {
        return new NamedMdNode("file", (MdNode)visitMdField(ctx.mdField()));
    }

    @Override
    public Expression visitDirectoryField(DirectoryFieldContext ctx) {
        return new NamedMdNode("directory", new MdGenericValue<>(parseQuotedString(ctx.StringLit())));
    }

    @Override
    public Expression visitFilenameField(FilenameFieldContext ctx) {
        return new NamedMdNode("filename", new MdGenericValue<>(parseQuotedString(ctx.StringLit())));
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Helpers

    public Expression makeNonDetOfType(Type type) {
        if (type instanceof ArrayType arrayType) {
            final List<Expression> entries = new ArrayList<>(arrayType.getNumElements());
            for (int i = 0; i < arrayType.getNumElements(); i++) {
                entries.add(makeNonDetOfType(arrayType.getElementType()));
            }
            return expressions.makeArray(arrayType.getElementType(), entries, true);
        } else if (type instanceof AggregateType structType) {
            final List<Expression> elements = new ArrayList<>(structType.getDirectFields().size());
            for (Type fieldType : structType.getDirectFields()) {
                elements.add(makeNonDetOfType(fieldType));
            }
            return expressions.makeConstruct(elements);
        } else if (type instanceof IntegerType intType) {
            final INonDet value = new INonDet(program.getConstants().size(), intType, true);
            value.setMin(intType.getMinimumValue(true));
            value.setMax(intType.getMaximumValue(true));
            program.addConstant(value);
            return value;
        } else if (type instanceof BooleanType) {
            return new BNonDet(types.getBooleanType());
        } else {
            throw new UnsupportedOperationException("Cannot create non-deterministic value of type " + type);
        }
    }

    private void check(boolean condition, String message, ParserRuleContext context) {
        if (!condition) {
            throw new ParsingException(String.format(message, context.getText()));
        }
    }

    private void checkSupport(boolean condition, String message, ParserRuleContext context) {
        if (!condition) {
            throw new UnsupportedOperationException(String.format(message, context.getText()));
        }
    }

    private Type checkPointerType(TypeValueContext context) {
        final ConcreteTypeContext concreteTypeContext = context.firstClassType().concreteType();
        // NOTE this also accepts the legacy pointer types, but discards their element type information.
        if (concreteTypeContext == null || concreteTypeContext.pointerType() == null) {
            throw new ParsingException(
                    String.format("Expected pointer type, instead of %s.", context.firstClassType().getText()));
        }
        return pointerType;
    }

    private boolean parseBoolean(TerminalNode node) {
        return Boolean.parseBoolean(node.getText());
    }

    private BigInteger parseBigInteger(TerminalNode node) {
        return new BigInteger(node.getText());
    }

    private String parseQuotedString(TerminalNode node) {
        final String value = node.getText();
        return value.substring(1, value.length() - 1); // Remove surrounding quotes
    }

    private String parseID(TerminalNode node) {
        return node.getText();
    }

    private static String parseMemoryOrder(AtomicOrderingContext ctx) {
        return switch (ctx.getText()) {
            case "unordered" -> Tag.C11.NONATOMIC;
            case "monotonic" -> Tag.C11.MO_RELAXED;
            case "acquire" -> Tag.C11.MO_ACQUIRE;
            case "release" -> Tag.C11.MO_RELEASE;
            case "acq_rel" -> Tag.C11.MO_ACQUIRE_RELEASE;
            case "seq_cst" -> Tag.C11.MO_SC;
            default -> throw new ParsingException(String.format("Unknown ordering '%s'", ctx.getText()));
        };
    }

    private static String globalIdent(TerminalNode node) {
        //see https://llvm.org/docs/LangRef.html#identifiers
        // Names can be quoted, to allow escaping and other characters than .
        // This should not bother us after parsing: @fun and @"fun" should be identical.
        final String ident = node.getText();
        assert ident.startsWith("@");
        final String unescapedIdent = unescape(ident.substring(1));
        // LLVM prepends \01 to a global, if subsequent name mangling should be disabled.
        // Clang produces this flag, when a C declaration contains an explicit __asm alias.
        // We ignore this flag.
        final String trimmedIdent = unescapedIdent.startsWith("\1") ? unescapedIdent.substring(1) : unescapedIdent;
        return trimmedIdent.replace(".loop", ".\\loop");
    }

    private static String localIdent(TerminalNode node) {
        final String ident = node.getText();
        assert ident.startsWith("%");
        return unescape(ident.substring(1)).replace(".loop", ".\\loop");
    }

    private static String unescape(String original) {
        final boolean quoted = original.startsWith("\"");
        assert quoted == (original.endsWith("\""));
        final String unquoted = quoted ? original.substring(1, original.length() - 1) : original;
        int escape = unquoted.indexOf('\\');
        if (escape == -1) {
            return unquoted;
        }
        final StringBuilder sb = new StringBuilder(unquoted.length());
        int progress = 0;
        do {
            sb.append(unquoted, progress, escape);
            progress = escape + 3;
            sb.append((char) Integer.parseInt(unquoted.substring(escape + 1, progress), 16));
            escape = unquoted.indexOf('\\', progress);
        } while (escape != -1);
        return sb.append(unquoted, progress, unquoted.length()).toString();
    }

    private Register getOrNewRegister(String name, Type type) {
        return function.getOrNewRegister(adjustRegisterName(name), type);
    }

    private static String adjustRegisterName(String original) {
        return "r" + original;
    }

    private record BlockPair(Block from, Block to) {}

    private static final class Block {
        private final Label label;
        private final List<Event> events = new ArrayList<>();
        private Block(Label l) {
            label = l;
        }
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Metadata nodes that reflect LLVM's notion of metadata

    private interface MdNode extends Expression {

        Type TYPE = new Type() { };

        @Override
        default Type getType() { return TYPE; }
        @Override
        default ImmutableSet<Register> getRegs() { throw new UnsupportedOperationException();}
        @Override
        default <T> T accept(ExpressionVisitor<T> visitor) { return null;}
        @Override
        default IConst reduce() { throw new UnsupportedOperationException(); }
    }

    private static final MdNode MD_NULL = new MdNode() {
        @Override
        public String toString() { return "NULL"; }
    };

    private static final MdNode MD_NOT_PARSED = new MdNode() {
        @Override
        public String toString() { return "NOT PARSED"; }
    };

    private record MdReference(String mdName) implements MdNode {
        @Override
        public String toString() { return mdName; }
    }

    private record MdGenericValue<T>(T value) implements MdNode {
        MdGenericValue {
            // This node should only hold values external to the MdNode hierarchy.
            Preconditions.checkArgument(!(value instanceof MdNode));
        }
        @Override
        public String toString() { return value.toString(); }
    }

    private record MdTuple(List<MdNode> mdFields) implements MdNode {
        public String toString() { return mdFields.stream().map(Object::toString)
                .collect(Collectors.joining(", ", "!{", "}")); }
    }

    private record NamedMdNode(String name, MdNode node) implements MdNode {
        @Override
        public String toString() { return String.format("%s: %s", name, node); }
    }

    private record SpecialMdTupleNode(Type nodeType, List<NamedMdNode> namedMDFields) implements MdNode {

        public enum Type {
            DILocation,
            DIFile,
            DISubprogram,
            DILexicalBlock
        }

        @Override
        public String toString() {
            return String.format("!%s(%s)", nodeType,
                    namedMDFields.stream().map(Object::toString).collect(Collectors.joining(", ")));
        }

        public <T extends MdNode> Optional<T> getField(String fieldName) {
            for (NamedMdNode field : namedMDFields) {
                if (field.name().equals(fieldName)) {
                    return Optional.of((T)field.node());
                }
            }
            return Optional.empty();
        }
    }

}