package com.dat3m.dartagnan.parsers.program.visitors.spirv.extenstions;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.builders.ProgramBuilder;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;

public class VisitorExtensionDebugInfo extends VisitorExtension<Expression> {

    private final ProgramBuilder builder;
    private final Map<String, String> sourceFiles = new HashMap<>();

    public VisitorExtensionDebugInfo(ProgramBuilder builder) {
        this.builder = builder;
    }

    @Override
    public Expression visitOpExtInst(SpirvParser.OpExtInstContext ctx) {
        SpirvParser.DebugInfoContext debugInfo = ctx.instruction().literalExtInstInteger().debugInfo();
        String instruction = debugInfo.getStart().getText();
        if (instruction.equals("DebugSource")) {
            String file = builder.getDebugInfo(debugInfo.idRef(0).getText());
            sourceFiles.put(ctx.idResult().getText(), removeSurroundingQuotes(file));
        } else if (instruction.equals("DebugLine")) {
            String file = sourceFiles.get(debugInfo.idRef(0).getText());
            String lineId = debugInfo.idRef(1).getText();
            if (!(builder.getExpression(lineId) instanceof IntLiteral lineLiteral)) {
                throw new ParsingException("DebugLine operand '%s' is not an integer constant", lineId);
            }
            int line = lineLiteral.getValueAsInt();
            builder.getControlFlowBuilder().setCurrentLocation(file, line);
        } else if (instruction.equals("DebugNoLine")) {
            builder.getControlFlowBuilder().removeCurrentLocation();
        }
        return null;
    }

    private static String removeSurroundingQuotes(String stringLiteral) {
        return stringLiteral.substring(1, stringLiteral.length() - 1);
    }

    @Override
    public Set<String> getSupportedInstructions() {
        return Set.of(
                "DebugCompilationUnit", "DebugEntryPoint", "DebugExpression", "DebugFunction",
                "DebugFunctionDefinition", "DebugGlobalVariable", "DebugInfoNone", "DebugLine",
                "DebugLocalVariable", "DebugNoLine", "DebugNoScope", "DebugScope", "DebugSource",
                "DebugTypeArray", "DebugTypeBasic", "DebugTypeComposite", "DebugTypeFunction",
                "DebugTypeMember", "DebugTypeQualifier", "DebugTypeVector", "DebugValue"
        );
    }
}
