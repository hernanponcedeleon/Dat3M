package porthosc.languages.syntax.ytree.visitors;

import porthosc.languages.syntax.ytree.YSyntaxTree;
import porthosc.languages.syntax.ytree.definitions.YFunctionDefinition;
import porthosc.languages.syntax.ytree.expressions.YEmptyExpression;
import porthosc.languages.syntax.ytree.expressions.accesses.YIndexerExpression;
import porthosc.languages.syntax.ytree.expressions.accesses.YInvocationExpression;
import porthosc.languages.syntax.ytree.expressions.accesses.YMemberAccessExpression;
import porthosc.languages.syntax.ytree.expressions.assignments.YAssignmentExpression;
import porthosc.languages.syntax.ytree.expressions.atomics.YConstant;
import porthosc.languages.syntax.ytree.expressions.atomics.YLabeledVariableRef;
import porthosc.languages.syntax.ytree.expressions.atomics.YParameter;
import porthosc.languages.syntax.ytree.expressions.atomics.YVariableRef;
import porthosc.languages.syntax.ytree.expressions.operations.YBinaryExpression;
import porthosc.languages.syntax.ytree.expressions.operations.YBinaryOperator;
import porthosc.languages.syntax.ytree.expressions.operations.YUnaryExpression;
import porthosc.languages.syntax.ytree.expressions.operations.YUnaryOperator;
import porthosc.languages.syntax.ytree.expressions.ternary.YTernaryExpression;
import porthosc.languages.syntax.ytree.litmus.YPostludeDefinition;
import porthosc.languages.syntax.ytree.litmus.YPreludeDefinition;
import porthosc.languages.syntax.ytree.litmus.YProcessDefinition;
import porthosc.languages.syntax.ytree.statements.*;
import porthosc.languages.syntax.ytree.statements.jumps.YJumpStatement;
import porthosc.languages.syntax.ytree.types.YFunctionSignature;
import porthosc.languages.syntax.ytree.types.YType;


public interface YtreeVisitor<T> {
    T visit(YSyntaxTree node);

    // -- Litmus-litmus elements: ------------------------------------------------------------------------------------

    T visit(YPreludeDefinition node);
    T visit(YProcessDefinition node);
    T visit(YPostludeDefinition node);

    // -- END OF Litmus-litmus elements ------------------------------------------------------------------------------

    T visit(YConstant node);

    // accesses:
    T visit(YIndexerExpression node);
    T visit(YMemberAccessExpression node);
    T visit(YInvocationExpression node);

    T visit(YFunctionDefinition node);

    T visit(YEmptyExpression node);
    T visit(YUnaryExpression node);
    T visit(YUnaryOperator node);

    T visit(YBinaryExpression node);
    T visit(YBinaryOperator node);

    T visit(YTernaryExpression node);

    T visit(YVariableRef node);
    T visit(YLabeledVariableRef node);
    T visit(YType node);
    T visit(YAssignmentExpression node);

    T visit(YBranchingStatement node);
    T visit(YCompoundStatement node);
    T visit(YLinearStatement node);
    T visit(YLoopStatement node);
    T visit(YVariableDeclarationStatement node);
    T visit(YJumpStatement node);

    T visit(YFunctionSignature node);
    T visit(YParameter node);
}
