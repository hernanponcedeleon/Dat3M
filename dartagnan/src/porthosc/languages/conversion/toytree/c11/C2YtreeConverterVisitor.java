package porthosc.languages.conversion.toytree.c11;

import com.google.common.collect.ImmutableList;
import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.tree.AbstractParseTreeVisitor;
import org.antlr.v4.runtime.tree.TerminalNode;
import porthosc.languages.common.citation.CitationService;
import porthosc.languages.common.citation.Origin;
import porthosc.languages.parsers.C11Parser;
import porthosc.languages.parsers.C11Visitor;
import porthosc.languages.syntax.ytree.YEntity;
import porthosc.languages.syntax.ytree.YSyntaxTree;
import porthosc.languages.syntax.ytree.expressions.YEmptyExpression;
import porthosc.languages.syntax.ytree.expressions.YExpression;
import porthosc.languages.syntax.ytree.expressions.accesses.YIndexerExpression;
import porthosc.languages.syntax.ytree.expressions.accesses.YInvocationExpression;
import porthosc.languages.syntax.ytree.expressions.accesses.YMemberAccessExpression;
import porthosc.languages.syntax.ytree.expressions.assignments.YAssignmentExpression;
import porthosc.languages.syntax.ytree.expressions.atomics.*;
import porthosc.languages.syntax.ytree.expressions.operations.YBinaryOperator;
import porthosc.languages.syntax.ytree.expressions.operations.YUnaryOperator;
import porthosc.languages.syntax.ytree.litmus.YPostludeDefinition;
import porthosc.languages.syntax.ytree.litmus.YPreludeDefinition;
import porthosc.languages.syntax.ytree.litmus.YProcessDefinition;
import porthosc.languages.syntax.ytree.statements.*;
import porthosc.languages.syntax.ytree.statements.jumps.YJumpLabel;
import porthosc.languages.syntax.ytree.statements.jumps.YJumpStatement;
import porthosc.languages.syntax.ytree.temporaries.*;
import porthosc.languages.syntax.ytree.types.YFunctionSignature;
import porthosc.languages.syntax.ytree.types.YMockType;
import porthosc.languages.syntax.ytree.types.YType;
import porthosc.utils.exceptions.NotImplementedException;
import porthosc.utils.exceptions.NotSupportedException;
import porthosc.utils.exceptions.ytree.YParserException;
import porthosc.utils.exceptions.ytree.YParserNotImplementedException;

import java.util.List;

import static porthosc.utils.StringUtils.wrap;


class C2YtreeConverterVisitor
        extends AbstractParseTreeVisitor<YEntity>
        implements C11Visitor<YEntity> {

    private final CitationService citationService;
    private final JumpsResolver jumpsResolver = new JumpsResolver();

    C2YtreeConverterVisitor(CitationService citationService) {
        this.citationService = citationService;
    }

    // TODO: after debugging, add more informative exception messages everywhere

    /**
     * main
     * :   compilationUnit
     * ;
     */
    public YSyntaxTree visitMain(C11Parser.MainContext ctx) {
        ImmutableList.Builder<YEntity> roots = new ImmutableList.Builder<>();
        C11Parser.CompilationUnitContext compilationUnitContext = ctx.compilationUnit();
        if (compilationUnitContext != null) {
            ImmutableList<YEntity> rootStatements = visitCompilationUnit(compilationUnitContext).buildValues();
            roots.addAll(rootStatements);
            return new YSyntaxTree(origin(ctx), jumpsResolver, roots.build());
        }
        throw new YParserException(ctx, "Missing compilation unit");
    }


    /**
     * primaryExpression
     * :   Identifier
     * |   LitmusSpecificLabelledVariable  // `DigitSequence ':' Identifier`
     * |   Constant
     * |   StringLiteral+
     * |   '(' expression ')'
     * |   genericSelection
     * ;
     */
    @Override
    public YExpression visitPrimaryExpression(C11Parser.PrimaryExpressionContext ctx) {
        TerminalNode identifier = ctx.Identifier();
        if (identifier != null) {
             // firstly, try parse as a keyword (e.g., true, false, ...)
            String identifierText = identifier.getText();
            YConstant constant = YConstant.tryParse(identifierText);
             if (constant != null) {
             return constant;
             }
             // if could not parse as a constant, consider as a variable (which also is an identifier)
             return new YVariableRef(origin(ctx), identifierText);
        }
        TerminalNode processIdentifierContext = ctx.LitmusSpecificLabelledVariable();
        if (processIdentifierContext != null) {
            String processLabelSeparator = ":";
            String labelledVariable = processIdentifierContext.getText();
            int separatorIndex = labelledVariable.indexOf(processLabelSeparator);
            if (separatorIndex <= 0) {
                throw new YParserException(ctx, "Illegal format of the process-labeled variable " +
                        "(expect it to have a semicolon separator): " + labelledVariable);
            }
            String processId = labelledVariable.substring(0, separatorIndex);
            // todo: log this label parsing result
            String variableName = labelledVariable.substring(separatorIndex + 1);
            return new YLabeledVariableRef(origin(ctx), processId, variableName);
        }
        TerminalNode constantNode = ctx.Constant();
        if (constantNode != null) {
            YConstant constant = YConstant.tryParse(constantNode.getText());
            if (constant == null) {
                throw new YParserException(ctx, "Could not parse constant: " + wrap(constantNode.getText()));
            }
            return constant;
        }
        if (ctx.expression() != null) {
            return visitExpression(ctx.expression());
        }
        throw new YParserNotImplementedException(ctx);
    }

    /**
     * genericSelection
     * :   '_Generic' '(' assignmentExpression ',' genericAssocList ')'
     * ;
     */
    @Override
    public YEntity visitGenericSelection(C11Parser.GenericSelectionContext ctx) {
        throw new YParserNotImplementedException(ctx);
    }

    /**
     * genericAssocList
     * :   genericAssociation
     * |   genericAssocList ',' genericAssociation
     * ;
     */
    @Override
    public YEntity visitGenericAssocList(C11Parser.GenericAssocListContext ctx) {
        throw new YParserNotImplementedException(ctx);
    }

    /**
     * genericAssociation
     * :   typeName ':' assignmentExpression
     * |   'default' ':' assignmentExpression
     * ;
     */
    @Override
    public YEntity visitGenericAssociation(C11Parser.GenericAssociationContext ctx) {
        throw new YParserNotImplementedException(ctx);
    }

    /**
     * postfixExpression
     * :   primaryExpression
     * |   postfixExpression '[' expression ']'
     * |   postfixExpression '(' argumentExpressionList? ')'
     * |   postfixExpression '.' Identifier
     * |   postfixExpression '->' Identifier
     * |   postfixExpression '++'
     * |   postfixExpression '--'
     * |   '(' typeName ')' '{' initializerList '}'
     * |   '(' typeName ')' '{' initializerList ',' '}'
     * ;
     */
    @Override
    public YExpression visitPostfixExpression(C11Parser.PostfixExpressionContext ctx) {
        C11Parser.PrimaryExpressionContext primaryExpressionContext = ctx.primaryExpression();
        if (primaryExpressionContext != null) {
            return visitPrimaryExpression(primaryExpressionContext);
        }
        C11Parser.PostfixExpressionContext postfixExpressionContext = ctx.postfixExpression();
        if (postfixExpressionContext != null) {
            YExpression baseExpression = visitPostfixExpression(postfixExpressionContext);
            // case (indexer expression):
            if (ctx.getTokens(C11Parser.LeftBracket).size() > 0 && ctx.getTokens(C11Parser.RightBracket).size() > 0) {
                C11Parser.ExpressionContext expressionContext = ctx.expression();
                if (expressionContext == null) {
                    throw new YParserException(ctx, "Missing indexer expression");
                }
                YExpression indexerExpression = visitExpression(expressionContext);
                if (!(baseExpression instanceof YAtom)) {
                    throw new YParserException(ctx, "expected " + wrap(YAtom.class.getSimpleName()) +
                            ", found: " + wrap(baseExpression) +
                            " of type: " + wrap(baseExpression.getClass().getSimpleName()));
                }
                return new YIndexerExpression(origin(ctx), (YAtom) baseExpression, indexerExpression);
            }
            // case (invocation expression):
            if (ctx.getTokens(C11Parser.LeftParen).size() > 0 && ctx.getTokens(C11Parser.RightParen).size() > 0) {
                C11Parser.ArgumentExpressionListContext argumentExpressionListContextList = ctx.argumentExpressionList();
                ImmutableList<YExpression> arguments = (argumentExpressionListContextList != null)
                        ? visitArgumentExpressionList(argumentExpressionListContextList).buildValues()
                        : ImmutableList.of();
                return new YInvocationExpression(origin(ctx), baseExpression, arguments);
            }
            // case (member access expression):
            boolean isArrowAccess = ctx.getTokens(C11Parser.Arrow).size() > 0;
            boolean isDotAccess = ctx.getTokens(C11Parser.Dot).size() > 0;
            if (isArrowAccess || isDotAccess) {
                TerminalNode identifierNode = ctx.Identifier();
                if (identifierNode == null) {
                    throw new YParserException(ctx, "Missing member name while parsing member access expression");
                }
                if (isArrowAccess) {
                    // TODO: if arrow access, then the baseExpression should be a pointer! => remember as a shared variable. Check whether C allows the baseExpression to be a non-variable pointer.
                }
                if (!(baseExpression instanceof YAtom)) {
                    throw new YParserException(ctx, "expected " + wrap(YAtom.class.getSimpleName()) +
                            ", found: " + wrap(baseExpression) +
                            " of type: " + wrap(baseExpression.getClass().getSimpleName()));
                }
                return new YMemberAccessExpression(origin(ctx), (YAtom) baseExpression, identifierNode.getText());
            }
            // case (increment):
            if (ctx.getTokens(C11Parser.PlusPlus).size() > 0) {
                return YUnaryOperator.PrefixIncrement.createExpression(origin(ctx), baseExpression);
            }
            // case (decrement):
            if (ctx.getTokens(C11Parser.MinusMinus).size() > 0) {
                return YUnaryOperator.PrefixDecrement.createExpression(origin(ctx), baseExpression);
            }
        }
        throw new YParserNotImplementedException(ctx);
    }

    /**
     * argumentExpressionList
     * :   assignmentExpression
     * |   argumentExpressionList ',' assignmentExpression
     * ;
     */
    @Override
    public YQueueTemp<YExpression> visitArgumentExpressionList(C11Parser.ArgumentExpressionListContext ctx) {
        YQueueTemp<YExpression> result = new YQueueFILOTemp<>();
        C11Parser.AssignmentExpressionContext assignmentExpressionContext = ctx.assignmentExpression();
        C11Parser.ArgumentExpressionListContext argumentExpressionListContext = ctx.argumentExpressionList();
        if (assignmentExpressionContext != null) {
            if (argumentExpressionListContext != null) {
                List<YExpression> recursive = visitArgumentExpressionList(argumentExpressionListContext).getValues();
                result.addAll(recursive);
            }
            YExpression element = visitAssignmentExpression(assignmentExpressionContext);
            result.add(element);
            return result;
        }
        throw new YParserException(ctx);
    }

    /**
     * unaryExpression
     * :   postfixExpression
     * |   '++' unaryExpression
     * |   '--' unaryExpression
     * |   unaryOperator castExpression
     * |   'sizeof' unaryExpression
     * |   'sizeof' '(' typeName ')'
     * |   '_Alignof' '(' typeName ')'
     * ;
     */
    @Override
    public YExpression visitUnaryExpression(C11Parser.UnaryExpressionContext ctx) {
        // postfixExpression:
        C11Parser.PostfixExpressionContext postfixExpressionContext = ctx.postfixExpression();
        if (postfixExpressionContext != null) {
            return visitPostfixExpression(postfixExpressionContext);
        }
        C11Parser.UnaryExpressionContext unaryExpressionContext = ctx.unaryExpression();
        if (unaryExpressionContext != null) {
            YExpression baseExpression = visitUnaryExpression(unaryExpressionContext);
            // '++' unaryExpression:
            if (C11ParserHelper.hasToken(ctx, C11Parser.PlusPlus)) {
                return YUnaryOperator.PrefixIncrement.createExpression(origin(ctx), baseExpression);
            }
            // '--' unaryExpression:
            if (C11ParserHelper.hasToken(ctx, C11Parser.MinusMinus)) {
                return YUnaryOperator.PrefixDecrement.createExpression(origin(ctx), baseExpression);
            }
            // 'sizeof' unaryExpression:
            if (C11ParserHelper.hasToken(ctx, C11Parser.Sizeof)) {
                throw new YParserNotImplementedException(ctx);
            }
        }
        C11Parser.UnaryOperatorContext unaryOperatorContext = ctx.unaryOperator();
        C11Parser.CastExpressionContext castExpressionContext = ctx.castExpression();
        if (unaryOperatorContext != null) {
            if (castExpressionContext == null) {
                throw new YParserException(ctx, "Missing unary operand");
            }
            YUnaryOperatorKindTemp operator = visitUnaryOperator(unaryOperatorContext);
            YExpression operand = visitCastExpression(castExpressionContext);
            switch (operator) {
                case Ampersand:
                    return operand.withPointerLevel(operand.getPointerLevel() - 1);
                case Asterisk:
                    return operand.withPointerLevel(operand.getPointerLevel() + 1);
                case Plus:
                    return operand; // '+1' is same as '1'
                case Minus:
                    return YUnaryOperator.IntegerNegation.createExpression(origin(ctx), operand);
                case Tilde:
                    return YUnaryOperator.BitwiseComplement.createExpression(origin(ctx), operand);
                case Exclamation:
                    return YUnaryOperator.Negation.createExpression(origin(ctx), operand);
                default:
                    throw new YParserNotImplementedException(ctx, "Unsupported unary operator: " + operator.name());
            }
        }
        throw new YParserNotImplementedException(ctx);
    }

    /**
     * unaryOperator
     * :   '&' | '*' | '+' | '-' | '~' | '!'
     * ;
     */
    @Override
    public YUnaryOperatorKindTemp visitUnaryOperator(C11Parser.UnaryOperatorContext ctx) {
        assert ctx.getChildCount() == 1 : ctx.getChildCount();
        String tokenText = ctx.getChild(0).getText();
        YUnaryOperatorKindTemp operator = YUnaryOperatorKindTemp.tryParse(tokenText);
        if (operator == null) {
            throw new YParserException(ctx, "Could not parse unary operator " + wrap(tokenText));
        }
        return operator;
    }

    /**
     * castExpression
     * :   unaryExpression
     * |   '(' typeName ')' castExpression
     * ;
     */
    @Override
    public YExpression visitCastExpression(C11Parser.CastExpressionContext ctx) {
        C11Parser.UnaryExpressionContext unaryExpressionContext = ctx.unaryExpression();
        if (unaryExpressionContext != null) {
            return visitUnaryExpression(unaryExpressionContext);
        }
        // TODO: type cast!
        C11Parser.TypeNameContext typeNameContext = ctx.typeName();
        C11Parser.CastExpressionContext castExpressionContext = ctx.castExpression();
        throw new YParserNotImplementedException(ctx, "Type cast is not implemented yet");
    }

    /**
     * multiplicativeExpression
     * :   castExpression
     * |   multiplicativeExpression '*' castExpression
     * |   multiplicativeExpression '/' castExpression
     * |   multiplicativeExpression '%' castExpression
     * ;
     */
    @Override
    public YExpression visitMultiplicativeExpression(C11Parser.MultiplicativeExpressionContext ctx) {
        C11Parser.CastExpressionContext castExpressionContext = ctx.castExpression();
        C11Parser.MultiplicativeExpressionContext multiplicativeExpressionContext = ctx.multiplicativeExpression();
        if (castExpressionContext != null) {
            YExpression right = visitCastExpression(castExpressionContext);
            if (multiplicativeExpressionContext != null) {
                YExpression left = visitMultiplicativeExpression(multiplicativeExpressionContext);
                YBinaryOperator operator;
                if (C11ParserHelper.hasToken(ctx, C11Parser.Star)) {
                    operator = YBinaryOperator.Multiply;
                }
                else if (C11ParserHelper.hasToken(ctx, C11Parser.Div)) {
                    operator = YBinaryOperator.Divide;
                }
                else if (C11ParserHelper.hasToken(ctx, C11Parser.Mod)) {
                    operator = YBinaryOperator.Modulo;
                }
                else {
                    throw new YParserException(ctx);
                }
                return operator.createExpression(origin(ctx), left, right);
            }
            return right;
        }
        throw new YParserException(ctx);
    }

    /**
     * additiveExpression
     * :   multiplicativeExpression
     * |   additiveExpression '+' multiplicativeExpression
     * |   additiveExpression '-' multiplicativeExpression
     * ;
     */
    @Override
    public YExpression visitAdditiveExpression(C11Parser.AdditiveExpressionContext ctx) {
        C11Parser.AdditiveExpressionContext additiveExpressionContext = ctx.additiveExpression();
        C11Parser.MultiplicativeExpressionContext multiplicativeExpressionContext = ctx.multiplicativeExpression();

        if (multiplicativeExpressionContext != null) {
            YExpression multiplicativeExpression = visitMultiplicativeExpression(multiplicativeExpressionContext);
            if (additiveExpressionContext == null) {
                return multiplicativeExpression;
            }
            YExpression additiveExpression = visitAdditiveExpression(additiveExpressionContext);
            YBinaryOperator operator;
            if (C11ParserHelper.hasToken(ctx, C11Parser.Plus)) {
                operator = YBinaryOperator.Plus;
            }
            else if (C11ParserHelper.hasToken(ctx, C11Parser.Minus)) {
                operator = YBinaryOperator.Minus;
            }
            else {
                throw new YParserException(ctx, "Could not parse binary additive operator");
            }

            return operator.createExpression(origin(ctx), additiveExpression, multiplicativeExpression);
        }
        throw new YParserException(ctx);
    }

    /**
     * shiftExpression
     * :   additiveExpression
     * |   shiftExpression '<<' additiveExpression
     * |   shiftExpression '>>' additiveExpression
     * ;
     */
    @Override
    public YExpression visitShiftExpression(C11Parser.ShiftExpressionContext ctx) {
        C11Parser.AdditiveExpressionContext additiveExpressionContext = ctx.additiveExpression();
        C11Parser.ShiftExpressionContext shiftExpressionContext = ctx.shiftExpression();
        if (additiveExpressionContext != null) {
            if (shiftExpressionContext != null) {
                throw new NotImplementedException();
            }
            return visitAdditiveExpression(additiveExpressionContext);
        }
        throw new YParserException(ctx);
    }

    /**
     * relationalExpression
     * :   shiftExpression
     * |   relationalExpression '<' shiftExpression
     * |   relationalExpression '>' shiftExpression
     * |   relationalExpression '<=' shiftExpression
     * |   relationalExpression '>=' shiftExpression
     * ;
     */
    @Override
    public YExpression visitRelationalExpression(C11Parser.RelationalExpressionContext ctx) {
        C11Parser.RelationalExpressionContext relationalExpressionContext = ctx.relationalExpression();
        C11Parser.ShiftExpressionContext shiftExpressionContext = ctx.shiftExpression();
        boolean isLess = C11ParserHelper.hasToken(ctx, C11Parser.Less);
        boolean isGreater = C11ParserHelper.hasToken(ctx, C11Parser.Greater);
        boolean isLessEqual = C11ParserHelper.hasToken(ctx, C11Parser.LessEqual);
        boolean isGreaterEqual = C11ParserHelper.hasToken(ctx, C11Parser.GreaterEqual);
        if (isLess || isLessEqual || isGreater || isGreaterEqual) {
            if (relationalExpressionContext == null) {
                throw new YParserException(ctx, "Missing left part of inequality");
            }
            if (shiftExpressionContext == null) {
                throw new YParserException(ctx, "Missing right part of inequality");
            }
            YExpression leftPart = visitRelationalExpression(relationalExpressionContext);
            YExpression rightPart = visitShiftExpression(shiftExpressionContext);
            YBinaryOperator operator =
                    isLess ? YBinaryOperator.Less :
                            (isLessEqual ? YBinaryOperator.LessOrEquals :
                                    (isGreater ? YBinaryOperator.Greater :
                                            YBinaryOperator.GreaterOrEquals));
            return operator.createExpression(origin(ctx), leftPart, rightPart);
        }
        if (shiftExpressionContext != null) {
            return visitShiftExpression(shiftExpressionContext);
        }
        throw new YParserException(ctx);
    }

    /**
     * equalityExpression
     * :   relationalExpression
     * |   equalityExpression '==' relationalExpression
     * |   equalityExpression '!=' relationalExpression
     * ;
     */
    @Override
    public YExpression visitEqualityExpression(C11Parser.EqualityExpressionContext ctx) {
        C11Parser.RelationalExpressionContext relationalExpressionContext = ctx.relationalExpression();
        C11Parser.EqualityExpressionContext equalityExpressionContext = ctx.equalityExpression();
        boolean isEquality = C11ParserHelper.hasToken(ctx, C11Parser.Equal);
        boolean isInequality = C11ParserHelper.hasToken(ctx, C11Parser.NotEqual);
        if (isEquality || isInequality) {
            if (equalityExpressionContext == null) {
                throw new YParserException(ctx, "Missing left part of equality");
            }
            if (relationalExpressionContext == null) {
                throw new YParserException(ctx, "Missing right part of equality");
            }
            YExpression left = visitEqualityExpression(equalityExpressionContext);
            YExpression right = visitRelationalExpression(relationalExpressionContext);
            YBinaryOperator operator = isEquality
                    ? YBinaryOperator.Equals
                    : YBinaryOperator.NotEquals;
            return operator.createExpression(origin(ctx), left, right);
        }
        if (relationalExpressionContext != null) {
            return visitRelationalExpression(relationalExpressionContext);
        }
        throw new YParserException(ctx);
    }

    /**
     * andExpression
     * :   equalityExpression
     * |   andExpression '&' equalityExpression
     * ;
     */
    @Override
    public YExpression visitAndExpression(C11Parser.AndExpressionContext ctx) {
        C11Parser.EqualityExpressionContext equalityExpressionContext = ctx.equalityExpression();
        C11Parser.AndExpressionContext andExpressionContext = ctx.andExpression();
        if (equalityExpressionContext != null) {
            if (andExpressionContext != null) {
                throw new NotImplementedException();
            }
            return visitEqualityExpression(equalityExpressionContext);
        }
        throw new YParserException(ctx);
    }

    /**
     * exclusiveOrExpression
     * :   andExpression
     * |   exclusiveOrExpression '^' andExpression
     * ;
     */
    @Override
    public YExpression visitExclusiveOrExpression(C11Parser.ExclusiveOrExpressionContext ctx) {
        C11Parser.AndExpressionContext andExpressionContext = ctx.andExpression();
        C11Parser.ExclusiveOrExpressionContext exclusiveOrExpressionContext = ctx.exclusiveOrExpression();
        if (andExpressionContext != null) {
            if (exclusiveOrExpressionContext != null) {
                throw new NotImplementedException();
            }
            return visitAndExpression(andExpressionContext);
        }
        throw new YParserException(ctx);
    }

    /**
     * inclusiveOrExpression
     * :   exclusiveOrExpression
     * |   inclusiveOrExpression '|' exclusiveOrExpression
     * ;
     */
    @Override
    public YExpression visitInclusiveOrExpression(C11Parser.InclusiveOrExpressionContext ctx) {
        C11Parser.ExclusiveOrExpressionContext exclusiveOrExpressionContext = ctx.exclusiveOrExpression();
        C11Parser.InclusiveOrExpressionContext inclusiveOrExpressionContext = ctx.inclusiveOrExpression();
        if (exclusiveOrExpressionContext != null) {
            if (inclusiveOrExpressionContext != null) {
                throw new NotImplementedException();
            }
            return visitExclusiveOrExpression(exclusiveOrExpressionContext);
        }
        throw new YParserException(ctx);
    }

    /**
     * logicalAndExpression
     * :   inclusiveOrExpression
     * |   logicalAndExpression '&&' inclusiveOrExpression
     * ;
     */
    @Override
    public YExpression visitLogicalAndExpression(C11Parser.LogicalAndExpressionContext ctx) {
        C11Parser.InclusiveOrExpressionContext inclusiveOrExpressionContext = ctx.inclusiveOrExpression();
        C11Parser.LogicalAndExpressionContext logicalAndExpressionContext = ctx.logicalAndExpression();
        if (inclusiveOrExpressionContext != null) {
            YExpression right = visitInclusiveOrExpression(inclusiveOrExpressionContext);
            if (logicalAndExpressionContext != null) {
                YExpression left = visitLogicalAndExpression(logicalAndExpressionContext);
                return YBinaryOperator.Conjunction.createExpression(origin(ctx), left, right);
            }
            return right;
        }
        throw new YParserException(ctx);
    }

    /**
     * logicalOrExpression
     * :   logicalAndExpression
     * |   logicalOrExpression '||' logicalAndExpression
     * ;
     */
    @Override
    public YExpression visitLogicalOrExpression(C11Parser.LogicalOrExpressionContext ctx) {
        //TODO: note that for integers, boolean operators have different meaning! (see http://retis.sssup.it/~lipari/courses/infbase2012/03.c_intro-handout.pdf slide 32/58)
        C11Parser.LogicalOrExpressionContext logicalOrExpressionContext = ctx.logicalOrExpression();
        C11Parser.LogicalAndExpressionContext logicalAndExpressionContext = ctx.logicalAndExpression();
        if (logicalAndExpressionContext != null) {
            YExpression right = visitLogicalAndExpression(logicalAndExpressionContext);
            if (logicalOrExpressionContext != null) {
                YExpression left = visitLogicalOrExpression(logicalOrExpressionContext);
                return YBinaryOperator.Disjunction.createExpression(origin(ctx), left, right);
            }
            return right;
        }
        throw new YParserException(ctx);
    }

    /**
     * conditionalExpression
     * :   logicalOrExpression ('?' expression ':' conditionalExpression)?
     * ;
     */
    @Override
    public YExpression visitConditionalExpression(C11Parser.ConditionalExpressionContext ctx) {
        C11Parser.LogicalOrExpressionContext logicalOrExpressionContext = ctx.logicalOrExpression();
        C11Parser.ExpressionContext expressionContext = ctx.expression();
        C11Parser.ConditionalExpressionContext conditionalExpressionContext = ctx.conditionalExpression();
        if (logicalOrExpressionContext != null) {
            boolean hasThen = expressionContext != null;
            boolean hasElse = conditionalExpressionContext != null;
            if (hasThen && hasElse) {
                throw new NotImplementedException();
            }
            if (hasThen || hasElse) {
                throw new YParserException(ctx);//missing either than or else
            }
            return visitLogicalOrExpression(logicalOrExpressionContext);
        }
        throw new YParserException(ctx);
    }

    /**
     * assignmentExpression
     * :   conditionalExpression
     * |   unaryExpression assignmentOperator assignmentExpression
     * ;
     */
    @Override
    public YExpression visitAssignmentExpression(C11Parser.AssignmentExpressionContext ctx) {
        C11Parser.ConditionalExpressionContext conditionalExpressionContext = ctx.conditionalExpression();
        C11Parser.UnaryExpressionContext unaryExpressionContext = ctx.unaryExpression();
        C11Parser.AssignmentOperatorContext assignmentOperatorContext = ctx.assignmentOperator();
        C11Parser.AssignmentExpressionContext assignmentExpressionContext = ctx.assignmentExpression();
        if (conditionalExpressionContext != null) {
            return visitConditionalExpression(conditionalExpressionContext);
        }
        if (assignmentOperatorContext != null) {
            // TODO: process non-trivial assignments
            YAssignmentOperatorTemp operator = visitAssignmentOperator(assignmentOperatorContext);
            switch (operator) {
                case StarAssign:
                case DivAssign:
                case ModAssign:
                case PlusAssign:
                case MinusAssign:
                case LeftShiftAssign:
                case RightShiftAssign:
                case AndAssign:
                case XorAssign:
                case OrAssign:
                    throw new YParserNotImplementedException(ctx, "Only simple assignment '=' is supported so far");
                    // Note: to support complex assignment, this method should return statement + all other visit-methods
                    // that invoke current method should be ready to get a statement (and throw an exception if necessary)
            }
            assert operator == YAssignmentOperatorTemp.Assign : operator;
            if (unaryExpressionContext == null) {
                throw new YParserException(ctx, "Missing assignee expression");
            }
            if (assignmentExpressionContext == null) {
                throw new YParserException(ctx, "Missing assigner expression");
            }
            YExpression assigneeEntity = visitUnaryExpression(unaryExpressionContext);
            if (!(assigneeEntity instanceof YVariableRef)) {
                throw new YParserException(ctx, "Invalid assignee " + wrap(assigneeEntity.toString())
                        + " of type " + assigneeEntity.getClass().getSimpleName());
            }
            YVariableRef assignee = (YVariableRef) assigneeEntity;
            YExpression recursive = visitAssignmentExpression(assignmentExpressionContext);
            return new YAssignmentExpression(origin(ctx), assignee, recursive);
        }
        throw new YParserException(ctx);
    }

    /**
     * assignmentOperator
     *  :   Assign
     *  |   StarAssign
     *  |   DivAssign
     *  |   ModAssign
     *  |   PlusAssign
     *  |   MinusAssign
     *  |   LeftShiftAssign
     *  |   RightShiftAssign
     *  |   AndAssign
     *  |   XorAssign
     *  |   OrAssign
     *  ;
     */
    @Override
    public YAssignmentOperatorTemp visitAssignmentOperator(C11Parser.AssignmentOperatorContext ctx) {
        if (ctx.Assign() != null) {
            return YAssignmentOperatorTemp.Assign;
        }
        if (ctx.StarAssign() != null) {
            return YAssignmentOperatorTemp.StarAssign;
        }
        if (ctx.DivAssign() != null) {
            return YAssignmentOperatorTemp.DivAssign;
        }
        if (ctx.ModAssign() != null) {
            return YAssignmentOperatorTemp.ModAssign;
        }
        if (ctx.PlusAssign() != null) {
            return YAssignmentOperatorTemp.PlusAssign;
        }
        if (ctx.MinusAssign() != null) {
            return YAssignmentOperatorTemp.MinusAssign;
        }
        if (ctx.LeftShiftAssign() != null) {
            return YAssignmentOperatorTemp.LeftShiftAssign;
        }
        if (ctx.RightShiftAssign() != null) {
            return YAssignmentOperatorTemp.RightShiftAssign;
        }
        if (ctx.AndAssign() != null) {
            return YAssignmentOperatorTemp.AndAssign;
        }
        if (ctx.XorAssign() != null) {
            return YAssignmentOperatorTemp.XorAssign;
        }
        if (ctx.OrAssign() != null) {
            return YAssignmentOperatorTemp.OrAssign;
        }
        throw new YParserException(ctx, "Unrecognised assignment operator");
    }

    /**
     * expression
     * :   assignmentExpression
     * |   expression ',' assignmentExpression
     * ;
     */
    @Override
    public YExpression visitExpression(C11Parser.ExpressionContext ctx) {
        C11Parser.ExpressionContext expressionContext = ctx.expression();
        if (expressionContext != null) {
            // evaluate, discard return value
            throw new YParserNotImplementedException(ctx, "Comma-operator is not supported yet");
        }
        C11Parser.AssignmentExpressionContext assignmentExpressionContext = ctx.assignmentExpression();
        if (assignmentExpressionContext != null) {
            return visitAssignmentExpression(assignmentExpressionContext);
        }
        throw new YParserException(ctx);
    }

    /**
     * constantExpression
     * :   conditionalExpression
     * ;
     */
    @Override
    public YEntity visitConstantExpression(C11Parser.ConstantExpressionContext ctx) {
        throw new YParserNotImplementedException(ctx);
    }

    /**
     * declaration
     * :   declarationSpecifiers initDeclaratorList ';'
     * |   staticAssertDeclaration
     * ;
     */
    @Override
    public YQueueTemp<YStatement> visitDeclaration(C11Parser.DeclarationContext ctx) {
        if (ctx.declarationSpecifiers() != null) {
            //A declaration other than a static_assert declaration shall declare at least a declarator
            //(other than the parameters of a function or the members of a structure or union), a tag, or
            //the members of an enumeration.
            YQueueTemp<YStatement> statements = new YQueueFILOTemp<>();

            YType type = new YMockType();
            C11Parser.InitDeclaratorListContext initDeclaratorListContext = ctx.initDeclaratorList();
            if (initDeclaratorListContext == null) {
                throw new YParserNotImplementedException(ctx, "Missing variable declarator");
            }
            ImmutableList<YExpression> declarationList = visitInitDeclaratorList(initDeclaratorListContext).buildValues();
            for (YExpression declarationExpression : declarationList) {
                if (declarationExpression instanceof YVariableRef) {
                    YVariableRef variable = (YVariableRef) declarationExpression;
                    statements.add(new YVariableDeclarationStatement(origin(ctx), type, variable));
                }
                else if (declarationExpression instanceof YAssignmentExpression) {
                    YAssignmentExpression assignment = (YAssignmentExpression) declarationExpression;
                    YExpression value = assignment.getExpression();
                    YAtom assignee = assignment.getAssignee();
                    if (assignee instanceof YVariableRef) {
                        YVariableRef variable = (YVariableRef) assignee;
                        Origin declarationLocation = origin(initDeclaratorListContext);
                        statements.add(new YVariableDeclarationStatement(declarationLocation, type, variable));
                        statements.add(new YLinearStatement(new YAssignmentExpression(assignment.origin(), variable, value)));
                    }
                    else {
                        throw new YParserException(ctx, "Declaration of non-variable instance: " + wrap(assignee) +
                                " of type: " + wrap(assignee.getClass().getSimpleName()));
                    }

                }
                else { //if (declarationExpression instanceof )
                    throw new YParserNotImplementedException(ctx, "Not supported variable declaration " +
                            wrap(declarationExpression.toString()) + " of type " +
                            declarationExpression.getClass().getSimpleName());
                }
            }
            return statements;
        }
        if (ctx.staticAssertDeclaration() != null) {
            throw new YParserNotImplementedException(ctx);
        }
        throw new YParserException(ctx);
    }

    /**
     * declarationSpecifiers
     * :   declarationSpecifier+
     * ;
     */
    @Override
    public YEntity visitDeclarationSpecifiers(C11Parser.DeclarationSpecifiersContext ctx) {
        throw new YParserNotImplementedException(ctx);
    }

    /**
     * declarationSpecifiers2
     * :   declarationSpecifier+
     * ;
     */
    @Override
    public YEntity visitDeclarationSpecifiers2(C11Parser.DeclarationSpecifiers2Context ctx) {
        throw new YParserNotImplementedException(ctx);
    }

    /**
     * declarationSpecifier
     * :   storageClassSpecifier
     * |   typeSpecifier
     * |   typeQualifier
     * |   functionSpecifier
     * |   alignmentSpecifier
     * ;
     */
    @Override
    public YEntity visitDeclarationSpecifier(C11Parser.DeclarationSpecifierContext ctx) {
        throw new YParserNotImplementedException(ctx);
    }

    /**
     * initDeclaratorList
     * :   initDeclarator
     * |   initDeclaratorList ',' initDeclarator
     * ;
     */
    @Override
    public YQueueTemp<YExpression> visitInitDeclaratorList(C11Parser.InitDeclaratorListContext ctx) {
        YQueueTemp<YExpression> result = new YQueueFILOTemp<>();
        C11Parser.InitDeclaratorListContext recursiveListContext = ctx.initDeclaratorList();
        if (recursiveListContext != null) {
            List<YExpression> recursive = visitInitDeclaratorList(recursiveListContext).getValues();
            result.addAll(recursive);
        }
        C11Parser.InitDeclaratorContext initDeclaratorContext = ctx.initDeclarator();
        if (initDeclaratorContext != null) {
            YExpression element = visitInitDeclarator(initDeclaratorContext);
            result.add(element);
        }
        return result;
    }

    /**
     * initDeclarator
     * :   declarator
     * |   declarator '=' initializer
     * ;
     */
    @Override
    public YExpression visitInitDeclarator(C11Parser.InitDeclaratorContext ctx) {
        C11Parser.DeclaratorContext declaratorContext = ctx.declarator();
        if (declaratorContext != null) {
            YEntity declaratorEntity = visitDeclarator(declaratorContext);
            if (!(declaratorEntity instanceof YExpression)) {
                throw new YParserException(ctx, "Initializer may be only an expression");
            }
            YExpression declarator = (YExpression) declaratorEntity;
            C11Parser.InitializerContext initializerContext = ctx.initializer();
            if (initializerContext == null) {
                return declarator;
            }
            YExpression initializer = visitInitializer(initializerContext);
            if (declarator instanceof YVariableRef) {
                return new YAssignmentExpression(origin(ctx), (YVariableRef) declarator, initializer);
            }
            //if (declarator instanceof ...)
            throw new YParserNotImplementedException(ctx);
        }
        throw new YParserNotImplementedException(ctx);
    }

    /**
     * storageClassSpecifier
     * :   'typedef'
     * |   'extern'
     * |   'static'
     * |   '_Thread_local'
     * |   'auto'
     * |   'register'
     * ;
     */
    @Override
    public YEntity visitStorageClassSpecifier(C11Parser.StorageClassSpecifierContext ctx) {
        throw new YParserNotImplementedException(ctx);
    }

    /**
     * typeSpecifier
     * :   ('void'
     * |   'char'
     * |   'short'
     * |   'int'
     * |   'long'
     * |   'float'
     * |   'double'
     * |   'signed'
     * |   'unsigned'
     * |   '_Bool'
     * |   '_Complex')
     * |   atomicTypeSpecifier
     * |   structOrUnionSpecifier
     * |   enumSpecifier
     * |   typedefName
     * ;
     */
    @Override
    public YEntity visitTypeSpecifier(C11Parser.TypeSpecifierContext ctx) {
        // atomicTypeSpecifier:
        C11Parser.AtomicTypeSpecifierContext atomicTypeSpecifierContext = ctx.atomicTypeSpecifier();
        if (atomicTypeSpecifierContext != null) {
            throw new YParserNotImplementedException(ctx);
        }
        // structOrUnionSpecifier:
        C11Parser.StructOrUnionSpecifierContext structOrUnionSpecifierContext = ctx.structOrUnionSpecifier();
        if (structOrUnionSpecifierContext != null) {
            throw new YParserNotImplementedException(ctx);
        }
        // enumSpecifier:
        C11Parser.EnumSpecifierContext enumSpecifierContext = ctx.enumSpecifier();
        if (enumSpecifierContext != null) {
            throw new YParserNotImplementedException(ctx);
        }
        // typedefName
        C11Parser.TypedefNameContext typedefNameContext = ctx.typedefName();
        if (typedefNameContext != null) {
            throw new YParserNotImplementedException(ctx);
        }
        // Token:
        //throw new YParserNotImplementedException(ctx);
        throw new YParserNotImplementedException(ctx);
    }

    /**
     * structOrUnionSpecifier
     * :   structOrUnion Identifier? '{' structDeclarationList '}'
     * |   structOrUnion Identifier
     * ;
     */
    @Override
    public YEntity visitStructOrUnionSpecifier(C11Parser.StructOrUnionSpecifierContext ctx) {
        throw new YParserNotImplementedException(ctx);
    }

    /**
     * structOrUnion
     * :   'struct'
     * |   'union'
     * ;
     */
    @Override
    public YEntity visitStructOrUnion(C11Parser.StructOrUnionContext ctx) {
        throw new YParserNotImplementedException(ctx);
    }

    /**
     * structDeclarationList
     * :   structDeclaration
     * |   structDeclarationList structDeclaration
     * ;
     */
    @Override
    public YEntity visitStructDeclarationList(C11Parser.StructDeclarationListContext ctx) {
        throw new YParserNotImplementedException(ctx);
    }

    /**
     * structDeclaration
     * :   specifierQualifierList structDeclaratorList? ';'
     * |   staticAssertDeclaration
     * ;
     */
    @Override
    public YEntity visitStructDeclaration(C11Parser.StructDeclarationContext ctx) {
        throw new YParserNotImplementedException(ctx);
    }

    /**
     * specifierQualifierList
     * :   typeSpecifier specifierQualifierList?
     * |   typeQualifier specifierQualifierList?
     * ;
     */
    @Override
    public YEntity visitSpecifierQualifierList(C11Parser.SpecifierQualifierListContext ctx) {
        throw new YParserNotImplementedException(ctx);
    }

    /**
     * structDeclaratorList
     * :   structDeclarator
     * |   structDeclaratorList ',' structDeclarator
     * ;
     */
    @Override
    public YEntity visitStructDeclaratorList(C11Parser.StructDeclaratorListContext ctx) {
        throw new YParserNotImplementedException(ctx);
    }

    /**
     * structDeclarator
     * :   declarator
     * |   declarator? ':' constantExpression
     * ;
     */
    @Override
    public YEntity visitStructDeclarator(C11Parser.StructDeclaratorContext ctx) {
        throw new YParserNotImplementedException(ctx);
    }

    /**
     * enumSpecifier
     * :   'enum' Identifier? '{' enumeratorList '}'
     * |   'enum' Identifier? '{' enumeratorList ',' '}'
     * |   'enum' Identifier
     * ;
     */
    @Override
    public YEntity visitEnumSpecifier(C11Parser.EnumSpecifierContext ctx) {
        throw new YParserNotImplementedException(ctx);
    }

    /**
     * enumeratorList
     * :   enumerator
     * |   enumeratorList ',' enumerator
     * ;
     */
    @Override
    public YEntity visitEnumeratorList(C11Parser.EnumeratorListContext ctx) {
        throw new YParserNotImplementedException(ctx);
    }

    /**
     * enumerator
     * :   enumerationConstant
     * |   enumerationConstant '=' constantExpression
     * ;
     */
    @Override
    public YEntity visitEnumerator(C11Parser.EnumeratorContext ctx) {
        throw new YParserNotImplementedException(ctx);
    }

    /**
     * enumerationConstant
     * :   Identifier
     * ;
     */
    @Override
    public YEntity visitEnumerationConstant(C11Parser.EnumerationConstantContext ctx) {
        throw new YParserNotImplementedException(ctx);
    }

    /**
     * atomicTypeSpecifier
     * :   '_Atomic' '(' typeName ')'
     * ;
     */
    @Override
    public YEntity visitAtomicTypeSpecifier(C11Parser.AtomicTypeSpecifierContext ctx) {
        throw new YParserNotImplementedException(ctx);
    }

    /**
     * typeQualifier
     * :   'const'
     * |   'restrict'
     * |   'volatile'
     * |   '_Atomic'
     * ;
     */
    @Override
    public YEntity visitTypeQualifier(C11Parser.TypeQualifierContext ctx) {
        throw new YParserNotImplementedException(ctx);
    }

    /**
     * functionSpecifier
     * :   'inline'
     * |   '_Noreturn'
     * ;
     */
    @Override
    public YEntity visitFunctionSpecifier(C11Parser.FunctionSpecifierContext ctx) {
        throw new YParserNotImplementedException(ctx);
    }

    /**
     * alignmentSpecifier
     * :   '_Alignas' '(' typeName ')'
     * |   '_Alignas' '(' constantExpression ')'
     * ;
     */
    @Override
    public YEntity visitAlignmentSpecifier(C11Parser.AlignmentSpecifierContext ctx) {
        throw new YParserNotImplementedException(ctx);
    }

    /**
     * declarator
     * :   pointer? directDeclarator
     * ;
     */
    @Override
    public YEntity visitDeclarator(C11Parser.DeclaratorContext ctx) {
        List<YUnaryOperatorKindTemp> pointerOperatorList = null;
        if (ctx.pointer() != null) {
            pointerOperatorList = visitPointer(ctx.pointer()).getValues();
        }

        C11Parser.DirectDeclaratorContext directDeclaratorContext = ctx.directDeclarator();
        if (directDeclaratorContext != null) {
            YEntity declarator = visitDirectDeclarator(directDeclaratorContext);
            if (declarator instanceof YFunctionSignature) {
                if (pointerOperatorList != null) {
                    throw new NotSupportedException("pointers to functions");
                }
                return (YFunctionSignature) declarator;
            }

            if (declarator instanceof YExpression) {
                YExpression expression = (YExpression) declarator;
                if (pointerOperatorList != null) {
                    // TODO:!!! check the order here !!!
                    for (YUnaryOperatorKindTemp operator : pointerOperatorList) {
                        int level = expression.getPointerLevel();
                        switch (operator) {
                            case Ampersand:
                                expression = expression.withPointerLevel(level - 1);
                                break;
                            case Asterisk:
                                expression = expression.withPointerLevel(level + 1);
                                break;
                            case Plus:
                            case Minus:
                            case Tilde:
                            case Exclamation:
                                throw new IllegalArgumentException(operator.name());
                        }
                    }
                }
                return expression;
            }

            throw new NotImplementedException("Yet unsupported declarator" +
                                                  ", found: " + wrap(declarator) +
                                                  " of type: " + wrap(declarator.getClass().getSimpleName()));
        }
        throw new YParserNotImplementedException(ctx);
    }

    /**
     * directDeclarator
     * :   Identifier
     * |   '(' declarator ')'
     * |   directDeclarator '[' typeQualifierList? assignmentExpression? ']'
     * |   directDeclarator '[' 'static' typeQualifierList? assignmentExpression ']'
     * |   directDeclarator '[' typeQualifierList 'static' assignmentExpression ']'
     * |   directDeclarator '[' typeQualifierList? '*' ']'
     * |   directDeclarator '(' parameterTypeList ')'
     * |   directDeclarator '(' identifierList? ')'
     * ;
     */
    @Override
    public YEntity visitDirectDeclarator(C11Parser.DirectDeclaratorContext ctx) {
        TerminalNode identifier;
        C11Parser.DeclaratorContext declaratorContext;
        C11Parser.DirectDeclaratorContext directDeclaratorContext;
        C11Parser.TypeQualifierListContext typeQualifierListContext;
        C11Parser.AssignmentExpressionContext assignmentExpressionContext;
        C11Parser.IdentifierListContext identifierListContext;

        if ((identifier = ctx.Identifier()) != null) {
            return new YVariableRef(origin(ctx), identifier.getText());
        }
        boolean hasParentheses = C11ParserHelper.hasParentheses(ctx);
        if (hasParentheses) {
            if ((declaratorContext = ctx.declarator()) != null) {
                return visitDeclarator(declaratorContext);
            }
        }
        if ((directDeclaratorContext = ctx.directDeclarator()) != null) {
            YEntity recursive = visitDirectDeclarator(directDeclaratorContext);
            // '['
            // ...
            if (hasParentheses) {
                C11Parser.ParameterTypeListContext parameterTypeListContext = ctx.parameterTypeList();
                ImmutableList<YParameter> parameters = (parameterTypeListContext != null)
                        ?   visitParameterTypeList(parameterTypeListContext).buildValues()
                        :   ImmutableList.of();
                if (recursive instanceof YVariableRef) {
                    YVariableRef methodVariable = (YVariableRef) recursive;
                    // todo: parse return type
                    return new YFunctionSignature(methodVariable.getName(), new YMockType(), parameters);
                }
                throw new YParserException(ctx, "For now, only simple name-based method definitions are supported");
            }
        }
        // todo: some others
        throw new YParserNotImplementedException(ctx);
    }

    /**
     * pointer
     * :   ('*' | '&') typeQualifierList?
     * |   ('*' | '&') typeQualifierList? pointer
     * ;
     */
    @Override
    public YQueueTemp<YUnaryOperatorKindTemp> visitPointer(C11Parser.PointerContext ctx) {
        YQueueTemp<YUnaryOperatorKindTemp> result = new YQueueFIFOTemp<>();
        C11Parser.TypeQualifierListContext typeQualifierListContext = ctx.typeQualifierList();
        C11Parser.PointerContext pointerContext = ctx.pointer();
        if (typeQualifierListContext != null) {
            throw new NotImplementedException();
        }
        if (pointerContext != null) {
            List<YUnaryOperatorKindTemp> recursive = visitPointer(pointerContext).getValues();
            result.addAll(recursive);
        }

        if (C11ParserHelper.hasToken(ctx, C11Parser.Star)) {
            result.add(YUnaryOperatorKindTemp.Asterisk);
        }
        else if (C11ParserHelper.hasToken(ctx, C11Parser.And)) {
            result.add(YUnaryOperatorKindTemp.Ampersand);
        }
        else {
            throw new YParserException(ctx);
        }

        return result;
    }

    /**
     * typeQualifierList
     * :   typeQualifier
     * |   typeQualifierList typeQualifier
     * ;
     */
    @Override
    public YEntity visitTypeQualifierList(C11Parser.TypeQualifierListContext ctx) {
        throw new YParserNotImplementedException(ctx);
    }

    /**
     * parameterTypeList
     * :   parameterList
     * |   parameterList ',' '...'
     * ;
     */
    @Override
    public YQueueTemp<YParameter> visitParameterTypeList(C11Parser.ParameterTypeListContext ctx) {
        C11Parser.ParameterListContext parameterListContext = ctx.parameterList();
        if (parameterListContext != null) {
            return visitParameterList(parameterListContext);
        }
        throw new YParserException(ctx);
    }

    /**
     * parameterList
     * :   parameterDeclaration
     * |   parameterList ',' parameterDeclaration
     * ;
     */
    @Override
    public YQueueTemp<YParameter> visitParameterList(C11Parser.ParameterListContext ctx) {
        C11Parser.ParameterDeclarationContext parameterDeclarationContext;
        C11Parser.ParameterListContext parameterListContext;
        YQueueTemp<YParameter> result = new YQueueFILOTemp<>();
        if ((parameterListContext = ctx.parameterList()) != null) {
            List<YParameter> recursive = visitParameterList(parameterListContext).getValues();
            result.addAll(recursive);
        }
        if ((parameterDeclarationContext = ctx.parameterDeclaration()) != null) {
            YParameter element = visitParameterDeclaration(parameterDeclarationContext);
            result.add(element);
        }
        return result;
    }

    /**
     * parameterDeclaration
     * :   declarationSpecifiers declarator
     * |   declarationSpecifiers2 abstractDeclarator?
     * ;
     */
    @Override
    public YParameter visitParameterDeclaration(C11Parser.ParameterDeclarationContext ctx) {
        C11Parser.DeclaratorContext declaratorContext;
        if ((declaratorContext = ctx.declarator()) != null) {
            if (ctx.declarationSpecifiers() != null) {
                // todo: parse type in specifiers
                YType type = new YMockType();
                YEntity declarator = visitDeclarator(declaratorContext);
                if (!(declarator instanceof YVariableRef)) {
                    throw new YParserException(ctx, "Only identifier is allowed as function parameter name" +
                            ", found: " + declarator.getClass().getSimpleName());
                }
                YVariableRef variable = (YVariableRef) declarator;
                return new YParameter(origin(ctx), type, variable);
            }
            throw new YParserException(ctx, "Could not find parameter type specifiers");
        }

        throw new YParserNotImplementedException(ctx);
    }

    /**
     * identifierList
     * :   Identifier
     * |   identifierList ',' Identifier
     * ;
     */
    @Override
    public YEntity visitIdentifierList(C11Parser.IdentifierListContext ctx) {
        throw new YParserNotImplementedException(ctx);
    }

    /**
     * typeName
     * :   specifierQualifierList abstractDeclarator?
     * ;
     */
    @Override
    public YEntity visitTypeName(C11Parser.TypeNameContext ctx) {
        throw new YParserNotImplementedException(ctx);
    }

    /**
     * abstractDeclarator
     * :   pointer
     * |   pointer? directAbstractDeclarator
     * ;
     */
    @Override
    public YEntity visitAbstractDeclarator(C11Parser.AbstractDeclaratorContext ctx) {
        throw new YParserNotImplementedException(ctx);
    }

    /**
     * directAbstractDeclarator
     * :   '(' abstractDeclarator ')'
     * |   '[' typeQualifierList? assignmentExpression? ']'
     * |   '[' 'static' typeQualifierList? assignmentExpression ']'
     * |   '[' typeQualifierList 'static' assignmentExpression ']'
     * |   '[' '*' ']'
     * |   '(' parameterTypeList? ')'
     * |   directAbstractDeclarator '[' typeQualifierList? assignmentExpression? ']'
     * |   directAbstractDeclarator '[' 'static' typeQualifierList? assignmentExpression ']'
     * |   directAbstractDeclarator '[' typeQualifierList 'static' assignmentExpression ']'
     * |   directAbstractDeclarator '[' '*' ']'
     * |   directAbstractDeclarator '(' parameterTypeList? ')'
     * ;
     */
    @Override
    public YEntity visitDirectAbstractDeclarator(C11Parser.DirectAbstractDeclaratorContext ctx) {
        throw new YParserNotImplementedException(ctx);
    }

    /**
     * typedefName
     * :   Identifier
     * ;
     */
    @Override
    public YEntity visitTypedefName(C11Parser.TypedefNameContext ctx) {
        throw new YParserNotImplementedException(ctx);
    }

    /**
     * initializer
     * :   assignmentExpression
     * |   '{' initializerList '}'
     * |   '{' initializerList ',' '}'
     * ;
     */
    @Override
    public YExpression visitInitializer(C11Parser.InitializerContext ctx) {
        C11Parser.AssignmentExpressionContext assignmentExpressionContext = ctx.assignmentExpression();
        if (assignmentExpressionContext != null) {
            return visitAssignmentExpression(assignmentExpressionContext);
        }
        C11Parser.InitializerListContext initializerListContext = ctx.initializerList();
        if (initializerListContext != null) {
            return visitInitializerList(initializerListContext);
        }
        throw new YParserException(ctx, "Could not find an initialiser");
    }

    /**
     * initializerList
     * :   designation? initializer
     * |   initializerList ',' designation? initializer
     * ;
     */
    @Override
    public YExpression visitInitializerList(C11Parser.InitializerListContext ctx) {
        throw new YParserNotImplementedException(ctx);
    }

    /**
     * designation
     * :   designatorList '='
     * ;
     */
    @Override
    public YEntity visitDesignation(C11Parser.DesignationContext ctx) {
        throw new YParserNotImplementedException(ctx);
    }

    /**
     * designatorList
     * :   designator
     * |   designatorList designator
     * ;
     */
    @Override
    public YEntity visitDesignatorList(C11Parser.DesignatorListContext ctx) {
        throw new YParserNotImplementedException(ctx);
    }

    /**
     * designator
     * :   '[' constantExpression ']'
     * |   '.' Identifier
     * ;
     */
    @Override
    public YEntity visitDesignator(C11Parser.DesignatorContext ctx) {
        throw new YParserNotImplementedException(ctx);
    }

    /**
     * staticAssertDeclaration
     * :   '_Static_assert' '(' constantExpression ',' StringLiteral+ ')' ';'
     * ;
     */
    @Override
    public YEntity visitStaticAssertDeclaration(C11Parser.StaticAssertDeclarationContext ctx) {
        throw new YParserNotImplementedException(ctx);
    }

    /**
     * statement
     * :   labeledStatement
     * |   compoundStatement
     * |   expressionStatement
     * |   selectionStatement
     * |   iterationStatement
     * |   jumpStatement
     * ;
     */
    @Override
    public YStatement visitStatement(C11Parser.StatementContext ctx) {
        // todo: switch context?
        C11Parser.LabeledStatementContext labeledStatementContext = ctx.labeledStatement();
        if (labeledStatementContext != null) {
            return visitLabeledStatement(labeledStatementContext);
        }
        C11Parser.CompoundStatementContext compoundStatementContext = ctx.compoundStatement();
        if (compoundStatementContext != null) {
            return visitCompoundStatement(compoundStatementContext);
        }
        C11Parser.ExpressionStatementContext expressionStatementContext = ctx.expressionStatement();
        if (expressionStatementContext != null) {
            return visitExpressionStatement(expressionStatementContext);
        }
        C11Parser.SelectionStatementContext selectionStatementContext = ctx.selectionStatement();
        if (selectionStatementContext != null) {
            return visitSelectionStatement(selectionStatementContext);
        }
        C11Parser.IterationStatementContext iterationStatementContext = ctx.iterationStatement();
        if (iterationStatementContext != null) {
            return visitIterationStatement(iterationStatementContext);
        }
        C11Parser.JumpStatementContext jumpStatementContext = ctx.jumpStatement();
        if (jumpStatementContext != null) {
            return visitJumpStatement(jumpStatementContext);
        }
        throw new YParserNotImplementedException(ctx);
    }

    /**
     * labeledStatement
     * :   Identifier ':' statement
     * |   'case' constantExpression ':' statement
     * |   'default' ':' statement
     * ;
     */
    @Override
    public YStatement visitLabeledStatement(C11Parser.LabeledStatementContext ctx) {
        TerminalNode identifierContext = ctx.Identifier();
        if (identifierContext != null) {
            YJumpLabel label = new YJumpLabel(identifierContext.getText());
            C11Parser.StatementContext statementContext = ctx.statement();
            if (statementContext == null) {
                throw new YParserException(ctx, "Missing the statement in labelled-statement statement");
            }
            YStatement statement = visitStatement(statementContext);
            jumpsResolver.registerStatement(label.getValue(), statement);
            return statement;
        }
        throw new YParserNotImplementedException(ctx);
    }

    /**
     * compoundStatement
     * :   '{' blockItemList? '}'
     * ;
     */
    @Override
    public YCompoundStatement visitCompoundStatement(C11Parser.CompoundStatementContext ctx) {
        C11Parser.BlockItemListContext blockItemListContext = ctx.blockItemList();
        if (blockItemListContext != null) {
            YBlockFILOTemp builder = visitBlockItemList(blockItemListContext);
            builder.markHasBraces();
            return builder.build();
        }
        return new YCompoundStatement(origin(ctx), true);
    }

    /**
     * blockItemList
     * :   blockItem
     * |   blockItemList blockItem
     * ;
     */
    @Override
    public YBlockFILOTemp visitBlockItemList(C11Parser.BlockItemListContext ctx) {
        YBlockFILOTemp builder = new YBlockFILOTemp(origin(ctx));
        C11Parser.BlockItemListContext blockItemListContext = ctx.blockItemList();
        if (blockItemListContext != null) {
            List<YStatement> recursive = visitBlockItemList(blockItemListContext).getValues();
            builder.addAll(recursive);
        }
        C11Parser.BlockItemContext blockItemContext = ctx.blockItem();
        if (blockItemContext != null) {
            YEntity element = visitBlockItem(blockItemContext);
            if (element instanceof YStatement) {
                builder.add((YStatement) element);
            }
            else if (element instanceof YQueueTemp<?>) {
                YQueueTemp<?> itemList = (YQueueTemp<?>) element;
                for (YEntity item : itemList.getValues()) {
                    if (item instanceof YStatement) {
                        builder.add((YStatement) item);
                    }
                    else {
                        throw new NotImplementedException("//something missing? check whether 'item'" +
                                                                  " can be sth else than YStatement: " + wrap(item));
                    }
                }
            }
            else {
                throw new YParserException(ctx, "//unexpected type: " + wrap(element) + " of type: " +
                        wrap(element.getClass().getSimpleName()));
            }
        }
        return builder;
    }

    /**
     * blockItem
     * :   declaration
     * |   statement
     * ;
     */
    @Override
    public YEntity visitBlockItem(C11Parser.BlockItemContext ctx) {
        C11Parser.DeclarationContext declarationContext = ctx.declaration();
        if (declarationContext != null) {
            //ImmutableList<YStatement> statements = visitDeclaration(declarationContext).buildValues();
            //return new YCompoundStatement(origin(ctx), true, statements);
            return visitDeclaration(declarationContext);
        }
        C11Parser.StatementContext statementContext = ctx.statement();
        if (statementContext != null) {
            return visitStatement(statementContext);
        }
        throw new YParserException(ctx);
    }

    /**
     * expressionStatement
     * :   expression? ';'
     * ;
     */
    @Override
    public YLinearStatement visitExpressionStatement(C11Parser.ExpressionStatementContext ctx) {
        C11Parser.ExpressionContext expressionContext = ctx.expression();
        return expressionContext != null
                ? new YLinearStatement(visitExpression(expressionContext))
                : new YLinearStatement(new YEmptyExpression(origin(ctx)));
    }

    /**
     * selectionStatement
     * :   'if' '(' expression ')' statement ('else' statement)?
     * |   'switch' '(' expression ')' statement
     * ;
     */
    @Override
    public YStatement visitSelectionStatement(C11Parser.SelectionStatementContext ctx) {
        C11Parser.ExpressionContext expressionContext = ctx.expression();
        C11Parser.StatementContext statement1Context = ctx.statement(0);
        C11Parser.StatementContext statement2Context = ctx.statement(1);

        // todo: rewrite linearly
        if (expressionContext != null) {
            YExpression expression = visitExpression(expressionContext);
            if (statement1Context != null) {
                YStatement statement1 = visitStatement(statement1Context);
                if (C11ParserHelper.hasToken(ctx, C11Parser.If)) {
                    YStatement statement2 = null;
                    if (C11ParserHelper.hasToken(ctx, C11Parser.Else)) {
                        if (statement2Context == null) {
                            throw new YParserException(ctx, "Empty 'else' statement");
                        }
                        statement2 = visitStatement(statement2Context);
                    }
                    return new YBranchingStatement(origin(ctx), expression, statement1, statement2);
                }
                if (C11ParserHelper.hasToken(ctx, C11Parser.Switch)) {
                    throw new YParserNotImplementedException(ctx, "Switch is not implemented yet");
                }
            }
        }
        throw new YParserException(ctx);
    }

    /**
     * iterationStatement
     * :   While '(' expression ')' statement
     * |   Do statement While '(' expression ')' ';'
     * |   For '(' forCondition ')' statement
     * ;
     */
    @Override
    public YStatement visitIterationStatement(C11Parser.IterationStatementContext ctx) {
        C11Parser.ExpressionContext expressionContext = ctx.expression();
        C11Parser.StatementContext statementContext = ctx.statement();
        C11Parser.ForConditionContext forConditionContext = ctx.forCondition();

        YStatement statement = statementContext != null
                ? visitStatement(statementContext)
                : new YLinearStatement(new YEmptyExpression(origin(ctx))); //todo: wrong origin here

        boolean isDoWhile = C11ParserHelper.hasToken(ctx, C11Parser.Do);
        boolean isWhile = !isDoWhile && C11ParserHelper.hasToken(ctx, C11Parser.While);
        boolean isFor = C11ParserHelper.hasToken(ctx, C11Parser.For);

        if (isDoWhile || isWhile) {
            if (expressionContext == null) {
                throw new YParserException(ctx, "Missing loop expression");
            }
            YExpression expression = visitExpression(expressionContext);
            YStatement loopStatement = new YLoopStatement(origin(ctx), expression, statement);
            if (isDoWhile) {
                YBlockFILOTemp builder = new YBlockFILOTemp(origin(ctx));
                builder.add(statement); //first iteration
                builder.add(loopStatement);
                return builder.build();
            }
            return loopStatement;
        }
        if (isFor) {
            throw new YParserNotImplementedException(ctx);
        }
        throw new YParserException(ctx);
    }

    /**
     * forCondition
     * :   forDeclaration ';' forExpression? ';' forExpression?
     * |   expression? ';' forExpression? ';' forExpression?
     * ;
     */
    @Override
    public YEntity visitForDeclaration(C11Parser.ForDeclarationContext ctx) {
        throw new YParserNotImplementedException(ctx);
    }

    /**
     * forDeclaration
     * :   declarationSpecifiers initDeclaratorList
     * | 	declarationSpecifiers
     * ;
     */
    @Override
    public YEntity visitForCondition(C11Parser.ForConditionContext ctx) {
        throw new YParserNotImplementedException(ctx);
        //throw new YParserNotImplementedException(ctx);
    }

    /**
     * forExpression
     * :   assignmentExpression
     * |   forExpression ',' assignmentExpression
     * ;
     */
    @Override
    public YEntity visitForExpression(C11Parser.ForExpressionContext ctx) {
        throw new YParserNotImplementedException(ctx);
    }

    /**
     * jumpStatement
     * :   'goto' Identifier ';'
     * |   'continue' ';'
     * |   'break' ';'
     * |   'return' expression? ';'
     * ;
     */
    @Override
    public YJumpStatement visitJumpStatement(C11Parser.JumpStatementContext ctx) {
        if (C11ParserHelper.hasToken(ctx, C11Parser.Goto)) {
            TerminalNode identifier = ctx.Identifier();
            if (identifier == null) {
                throw new YParserException(ctx, "Missing goto label in jump statement");
            }
            YJumpLabel gotoLabel = new YJumpLabel(identifier.getText());
            return YJumpStatement.Kind.Goto.createJumpStatement(origin(ctx), gotoLabel);
        }
        if (C11ParserHelper.hasToken(ctx, C11Parser.Continue)) {
            return YJumpStatement.Kind.Continue.createJumpStatement(origin(ctx));
        }
        if (C11ParserHelper.hasToken(ctx, C11Parser.Break)) {
            return YJumpStatement.Kind.Break.createJumpStatement(origin(ctx));
        }
        if (C11ParserHelper.hasToken(ctx, C11Parser.Return)) {
            C11Parser.ExpressionContext expressionContext = ctx.expression();
            if (expressionContext != null) {
                // TODO: process return value
                throw new NotImplementedException("For now, return values are not supported");
            }
            return YJumpStatement.Kind.Return.createJumpStatement(origin(ctx));
        }
        throw new YParserNotImplementedException(ctx);
    }

    /**
     * compilationUnit
     * :   translationUnit? EOF
     * ;
     */
    @Override
    public YQueueTemp<YEntity> visitCompilationUnit(C11Parser.CompilationUnitContext ctx) {
        C11Parser.TranslationUnitContext translationUnitContext = ctx.translationUnit();
        if (translationUnitContext == null) {
            throw new YParserException(ctx, "Empty input");
        }
        return visitTranslationUnit(translationUnitContext);
    }

    /**
     * translationUnit
     * :   externalDeclaration
     * |   translationUnit externalDeclaration
     * ;
     */
    @Override
    public YQueueTemp<YEntity> visitTranslationUnit(C11Parser.TranslationUnitContext ctx) {
        YQueueTemp<YEntity> result = new YQueueFILOTemp<>();
        C11Parser.TranslationUnitContext translationUnitContext = ctx.translationUnit();
        if (translationUnitContext != null) {
            List<YEntity> recursive = visitTranslationUnit(translationUnitContext).getValues();
            result.addAll(recursive);
        }
        C11Parser.ExternalDeclarationContext externalDeclarationContext = ctx.externalDeclaration();
        if (externalDeclarationContext != null) {
            YEntity element = visitExternalDeclaration(externalDeclarationContext);
            result.add(element);
        }
        return result;
    }

    /**
     * externalDeclaration
     *  :   litmusInitialisation
     *  |   litmusAssertion
     *  |   functionDefinition
     *  |   declaration
     *  ;
     */
    @Override
    public YEntity visitExternalDeclaration(C11Parser.ExternalDeclarationContext ctx) {
        return visitChildren(ctx);
        //C11Parser.LitmusInitialisationContext litmusInitialisationContext = ctx.litmusInitialisation();
        //if (litmusInitialisationContext != null) {
        //    return visitLitmusInitialisation(litmusInitialisationContext);
        //}
        //C11Parser.LitmusAssertionContext litmusAssertionContext = ctx.litmusAssertion();
        //if (litmusAssertionContext != null) {
        //    return visitLitmusAssertion(litmusAssertionContext);
        //}
        //C11Parser.FunctionDefinitionContext functionDefinitionContext = ctx.functionDefinition();
        //if (functionDefinitionContext != null) {
        //    return visitFunctionDefinition(functionDefinitionContext);
        //}
        //C11Parser.DeclarationContext declarationContext = ctx.declaration();
        //if (declarationContext != null) {
        //    return visitDeclaration(declarationContext);
        //}
        //throw new YParserException(ctx);
    }

    /**
     * functionDefinition
     * :   declarationSpecifiers? declarator declarationList? compoundStatement
     * ;
     */
    @Override
    public YProcessDefinition visitFunctionDefinition(C11Parser.FunctionDefinitionContext ctx) {
        // TODO: process declaration specifiers
        // TODO: process declarator
        // TODO: process declarationList
        C11Parser.DeclarationSpecifiersContext declarationSpecifiersContext = ctx.declarationSpecifiers();
        C11Parser.DeclaratorContext declaratorContext = ctx.declarator();
        C11Parser.DeclarationListContext declarationListContext = ctx.declarationList();
        C11Parser.CompoundStatementContext compoundStatementContext = ctx.compoundStatement();
        if (declaratorContext != null && compoundStatementContext != null) {
            // TODO: parse NAME! and set signature
            // TODO: for now, we interpret every defined method as a separate process. It is incorrect for kernel!
            YEntity declarator = visitDeclarator(declaratorContext);
            if (!(declarator instanceof YFunctionSignature)) {
                throw new YParserException(ctx, "Could not parse function signature" +
                        ", found: " + declarator +
                        " of type: " + declarator.getClass().getSimpleName());
            }
            YFunctionSignature signature = (YFunctionSignature) declarator;
            YCompoundStatement body = visitCompoundStatement(compoundStatementContext);
            return new YProcessDefinition(origin(ctx), signature, body);
        }
        throw new YParserException(ctx);
    }

    /**
     * declarationList
     * :   declaration
     * |   declarationList declaration
     * ;
     */
    @Override
    public YEntity visitDeclarationList(C11Parser.DeclarationListContext ctx) {
        throw new YParserNotImplementedException(ctx);
    }

    /**
     * litmusAssertion
     *  :   'exists' '(' logicalOrExpression ')'
     *  ;
     */
    @Override
    public YPostludeDefinition visitLitmusAssertion(C11Parser.LitmusAssertionContext ctx) {
        C11Parser.LogicalOrExpressionContext logicalOrExpressionContext = ctx.logicalOrExpression();
        if (logicalOrExpressionContext != null) {
            YExpression assertion = visitLogicalOrExpression(logicalOrExpressionContext);
            return new YPostludeDefinition(origin(ctx), assertion);
        }
        throw new YParserException(ctx);
    }

    /**
     * litmusInitialisation
     *  :   '{' declaration* '}'
     *  ;
     */
    @Override
    public YPreludeDefinition visitLitmusInitialisation(C11Parser.LitmusInitialisationContext ctx) {
        List<C11Parser.DeclarationContext> declarationContextList = ctx.declaration();
        if (declarationContextList != null && declarationContextList.size() > 0) {
            YQueueTemp<YStatement> statements = new YQueueFILOTemp<>();
            for (C11Parser.DeclarationContext declarationContext : declarationContextList) {
                List<YStatement> declarations = visitDeclaration(declarationContext).getValues();
                statements.addAll(declarations);
            }
            return new YPreludeDefinition(origin(ctx), statements.buildValues());
        }
        throw new YParserException(ctx);
    }


    private Origin origin(ParserRuleContext ctx) {
        return citationService.getLocation(ctx);
    }
}