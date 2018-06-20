package porthosc.languages.conversion.towmodel;


import org.antlr.v4.runtime.tree.AbstractParseTreeVisitor;
import porthosc.languages.common.citation.CitationService;
import porthosc.languages.parsers.CatParser;
import porthosc.languages.parsers.CatVisitor;
import porthosc.languages.syntax.wmodel.WEntity;
import porthosc.utils.exceptions.NotImplementedException;


public final class Cat2WmodelConverterVisitor
        extends AbstractParseTreeVisitor<WEntity>
        implements CatVisitor<WEntity> {

    private final CitationService citationService;

    public Cat2WmodelConverterVisitor(CitationService citationService) {
        this.citationService = citationService;
    }

    /** main
     *      :   identity option* topInstructionList EOF
     *      ;
     */
    @Override
    public WEntity visitMain(CatParser.MainContext ctx) {
        throw new NotImplementedException();
    }

    /** identity
     *      :   STRING
     *      |   NAME
     *      ;
     */
    @Override
    public WEntity visitIdentity(CatParser.IdentityContext ctx) {
        throw new NotImplementedException();
    }

    /** option
     *      :   (WITHCO | WITHOUTCO | WITHINIT | WITHOUTINIT | WITHSC | WITHOUTSC)
     *      ;
     */
    @Override
    public WEntity visitOption(CatParser.OptionContext ctx) {
        throw new NotImplementedException();
    }

    /** instructionList
     *      :   
     *      |   instruction instructionList
     *      ;
     */
    @Override
    public WEntity visitInstructionList(CatParser.InstructionListContext ctx) {
        throw new NotImplementedException();
    }

    /** instructionClause
     *      :    tagName ARROW instructionList
     *      ;
     */
    @Override
    public WEntity visitInstructionClause(CatParser.InstructionClauseContext ctx) {
        throw new NotImplementedException();
    }

    /** instructionClauseList
     *      :    instructionClause
     *      |    UNDERSCORE ARROW instructionList
     *      |    instructionClause ALT instructionClauseList
     *      ;
     */
    @Override
    public WEntity visitInstructionClauseList(CatParser.InstructionClauseListContext ctx) {
        throw new NotImplementedException();
    }

    /** topInstructionList
     *      :   topInstruction
     *      |   topInstruction topInstructionList
     *      ;
     */
    @Override
    public WEntity visitTopInstructionList(CatParser.TopInstructionListContext ctx) {
        throw new NotImplementedException();
    }

    /** topInstruction
     *      :    ENUM varName EQUAL ALT? altTags
     *      |    instruction
     *      ;
     */
    @Override
    public WEntity visitTopInstruction(CatParser.TopInstructionContext ctx) {
        throw new NotImplementedException();
    }

    /** instruction
     *      :   letInstruction
     *      |   matchInstruction
     *      |   constraintDefinition
     *      |   showInstruction
     *      |   unshowInstruction
     *      |   includeInstruction
     *      |   procedureInstruction
     *      |   callInstruction
     *      |   debugInstruction
     *      |   forallInstruction
     *      |   withFromInstruction
     *      |   INSTRUCTIONS varName LBRAC expressionList RBRAC
     *      |   DEFAULT varName LBRAC expressionList RBRAC
     *      ;
     */
    @Override
    public WEntity visitInstruction(CatParser.InstructionContext ctx) {
        throw new NotImplementedException();
    }

    /** matchInstruction
     *      :   MATCH expression WITH ALT? instructionClauseList END
     *      ;
     */
    @Override
    public WEntity visitMatchInstruction(CatParser.MatchInstructionContext ctx) {
        throw new NotImplementedException();
    }

    /** letInstruction
     *      :   LET REC? patternBindingList IN?
     *      |   LET REC patternBindingList WHEN constraint IN?
     *      ;
     */
    @Override
    public WEntity visitLetInstruction(CatParser.LetInstructionContext ctx) {
        throw new NotImplementedException();
    }

    /** showInstruction
     *      :   SHOW expression AS varName
     *      |   SHOW varNameList
     *      ;
     */
    @Override
    public WEntity visitShowInstruction(CatParser.ShowInstructionContext ctx) {
        throw new NotImplementedException();
    }

    /** unshowInstruction
     *      :   UNSHOW varNameList
     *      ;
     */
    @Override
    public WEntity visitUnshowInstruction(CatParser.UnshowInstructionContext ctx) {
        throw new NotImplementedException();
    }

    /** includeInstruction
     *      :   INCLUDE STRING
     *      ;
     */
    @Override
    public WEntity visitIncludeInstruction(CatParser.IncludeInstructionContext ctx) {
        throw new NotImplementedException();
    }

    /** procedureInstruction
     *      :   PROCEDURE REC? varName LPAR formals RPAR EQUAL instructionList END
     *      |   PROCEDURE REC? varName varName EQUAL instructionList END
     *      ;
     */
    @Override
    public WEntity visitProcedureInstruction(CatParser.ProcedureInstructionContext ctx) {
        throw new NotImplementedException();
    }

    /** callInstruction
     *      :   CALL varName simpleExpression asVarName?
     *      ;
     */
    @Override
    public WEntity visitCallInstruction(CatParser.CallInstructionContext ctx) {
        throw new NotImplementedException();
    }

    /** debugInstruction
     *      :   DEBUG expression
     *      ;
     */
    @Override
    public WEntity visitDebugInstruction(CatParser.DebugInstructionContext ctx) {
        throw new NotImplementedException();
    }

    /** forallInstruction
     *      :   FORALL varName IN expression DO instructionList END
     *      ;
     */
    @Override
    public WEntity visitForallInstruction(CatParser.ForallInstructionContext ctx) {
        throw new NotImplementedException();
    }

    /** withFromInstruction
     *      :   WITH varName FROM expression
     *      ;
     */
    @Override
    public WEntity visitWithFromInstruction(CatParser.WithFromInstructionContext ctx) {
        throw new NotImplementedException();
    }

    /** altTags
     *      :   tagName
     *      |   tagName ALT altTags
     *      ;
     */
    @Override
    public WEntity visitAltTags(CatParser.AltTagsContext ctx) {
        throw new NotImplementedException();
    }

    /** constraintDefinition
     *      :   checkType? constraint
     *      ;
     */
    @Override
    public WEntity visitConstraintDefinition(CatParser.ConstraintDefinitionContext ctx) {
        throw new NotImplementedException();
    }

    /** constraint
     *      :   constraintFullName expression asVarName?
     *      ;
     */
    @Override
    public WEntity visitConstraint(CatParser.ConstraintContext ctx) {
        throw new NotImplementedException();
    }

    /** checkType
     *      :   REQUIRES
     *      |   FLAG
     *      ;
     */
    @Override
    public WEntity visitCheckType(CatParser.CheckTypeContext ctx) {
        throw new NotImplementedException();
    }

    /** asVarName
     *      :   AS varName
     *      ;
     */
    @Override
    public WEntity visitAsVarName(CatParser.AsVarNameContext ctx) {
        throw new NotImplementedException();
    }

    /** assertionName
     *      :   ACYCLIC
     *      |   IRREFLEXIVE
     *      |   TESTEMPTY
     *      ;
     */
    @Override
    public WEntity visitAssertionName(CatParser.AssertionNameContext ctx) {
        throw new NotImplementedException();
    }

    /** constraintFullName
     *      :   NOT? assertionName
     *      ;
     */
    @Override
    public WEntity visitConstraintFullName(CatParser.ConstraintFullNameContext ctx) {
        throw new NotImplementedException();
    }

    /** varNameList
     *      :   varName
     *      |   varName COMMA varNameList
     *      ;
     */
    @Override
    public WEntity visitVarNameList(CatParser.VarNameListContext ctx) {
        throw new NotImplementedException();
    }

    /** binding
     *      :    varName EQUAL expression
     *      |    LPAR formals RPAR EQUAL expression
     *      ;
     */
    @Override
    public WEntity visitBinding(CatParser.BindingContext ctx) {
        throw new NotImplementedException();
    }

    /** patternBinding
     *      :    binding
     *      |    varName varName EQUAL expression
     *      |    varName LPAR formals RPAR EQUAL expression
     *      ;
     */
    @Override
    public WEntity visitPatternBinding(CatParser.PatternBindingContext ctx) {
        throw new NotImplementedException();
    }

    /** patternBindingList
     *      :    patternBinding
     *      |    patternBindingList AND patternBinding
     *      ;
     */
    @Override
    public WEntity visitPatternBindingList(CatParser.PatternBindingListContext ctx) {
        throw new NotImplementedException();
    }

    /** formals
     *      :   
     *      |   varName
     *      |   varName COMMA formals
     *      ;
     */
    @Override
    public WEntity visitFormals(CatParser.FormalsContext ctx) {
        throw new NotImplementedException();
    }

    /** expressionList
     *      :   
     *      |   expression
     *      |   expression COMMA expressionList
     *      ;
     */
    @Override
    public WEntity visitExpressionList(CatParser.ExpressionListContext ctx) {
        throw new NotImplementedException();
    }

    /** expression
     *      :   letExpression
     *      |   funExpression
     *      |   tryWithExpression
     *      |   ifThenElseExpression
     *      |   matchExpression
     *      |   baseExpression
     *      ;
     */
    @Override
    public WEntity visitExpression(CatParser.ExpressionContext ctx) {
        throw new NotImplementedException();
    }

    /** funExpression
     *      :   FUN varName ARROW expression
     *      |   FUN LPAR formals RPAR ARROW expression
     *      ;
     */
    @Override
    public WEntity visitFunExpression(CatParser.FunExpressionContext ctx) {
        throw new NotImplementedException();
    }

    /** tryWithExpression
     *      :   TRY expression WITH expression
     *      ;
     */
    @Override
    public WEntity visitTryWithExpression(CatParser.TryWithExpressionContext ctx) {
        throw new NotImplementedException();
    }

    /** ifThenElseExpression
     *      :   IF condition THEN expression ELSE expression
     *      ;
     */
    @Override
    public WEntity visitIfThenElseExpression(CatParser.IfThenElseExpressionContext ctx) {
        throw new NotImplementedException();
    }

    /** letExpression
     *      :   LET REC? patternBindingList IN expression
     *      ;
     */
    @Override
    public WEntity visitLetExpression(CatParser.LetExpressionContext ctx) {
        throw new NotImplementedException();
    }

    /** matchExpression
     *      :   MATCH expression WITH ALT? clauseList END
     *      |   MATCH expression WITH ALT? clauseSet END
     *      ;
     */
    @Override
    public WEntity visitMatchExpression(CatParser.MatchExpressionContext ctx) {
        throw new NotImplementedException();
    }

    /** condition
     *      :   expression EQUAL expression
     *      |   expression SUBSET expression
     *      ;
     */
    @Override
    public WEntity visitCondition(CatParser.ConditionContext ctx) {
        throw new NotImplementedException();
    }

    /** simpleExpression
     *      :   EMPTY
     *      |   tagName
     *      |   LACC args RACC
     *      |   UNDERSCORE
     *      |   LPAR RPAR
     *      |   LPAR tupleArgs RPAR
     *      |   LPAR expression RPAR
     *      |   BEGIN expression END
     *      |   LBRAC expression RBRAC
     *      ;
     */
    @Override
    public WEntity visitSimpleExpression(CatParser.SimpleExpressionContext ctx) {
        throw new NotImplementedException();
    }

    /** tupleArgs
     *      :   expression COMMA tupleEnd
     *      ;
     */
    @Override
    public WEntity visitTupleArgs(CatParser.TupleArgsContext ctx) {
        throw new NotImplementedException();
    }

    /** tupleEnd
     *      :   expression
     *      |   expression COMMA tupleEnd
     *      ;
     */
    @Override
    public WEntity visitTupleEnd(CatParser.TupleEndContext ctx) {
        throw new NotImplementedException();
    }

    /** baseExpression
     *      :   simpleExpression
     *      |   varNameExpression
     *      |   baseExpression STAR baseExpression  
     *      |   baseExpression STAR  
     *      |   baseExpression PLUS  
     *      |   baseExpression OPT  
     *      |   baseExpression HAT INV  
     *      |   <assoc=right> baseExpression SEMI baseExpression
     *      |   <assoc=right> baseExpression UNION baseExpression
     *      |   <assoc=right> baseExpression PLUSPLUS baseExpression
     *      |   <assoc=left>  baseExpression DIFF baseExpression
     *      |   <assoc=right> baseExpression INTER baseExpression
     *      |   NOT baseExpression  
     *      ;
     */
    @Override
    public WEntity visitBaseExpression(CatParser.BaseExpressionContext ctx) {
        throw new NotImplementedException();
    }

    /** clauseEmpty
     *      :   LACC RACC ARROW expression
     *      ;
     */
    @Override
    public WEntity visitClauseEmpty(CatParser.ClauseEmptyContext ctx) {
        throw new NotImplementedException();
    }

    /** clauseElement2
     *      :   varName PLUSPLUS varName ARROW expression
     *      ;
     */
    @Override
    public WEntity visitClauseElement2(CatParser.ClauseElement2Context ctx) {
        throw new NotImplementedException();
    }

    /** clauseElement3
     *      :   varName UNION varName PLUSPLUS varName ARROW expression
     *      ;
     */
    @Override
    public WEntity visitClauseElement3(CatParser.ClauseElement3Context ctx) {
        throw new NotImplementedException();
    }

    /** clauseElement
     *      :   clauseElement2
     *      |   clauseElement3
     *      ;
     */
    @Override
    public WEntity visitClauseElement(CatParser.ClauseElementContext ctx) {
        throw new NotImplementedException();
    }

    /** clauseSet
     *      :   clauseEmpty ALT clauseElement
     *      |   clauseElement ALT clauseEmpty
     *      ;
     */
    @Override
    public WEntity visitClauseSet(CatParser.ClauseSetContext ctx) {
        throw new NotImplementedException();
    }

    /** clause
     *      :   tagName ARROW expression
     *      ;
     */
    @Override
    public WEntity visitClause(CatParser.ClauseContext ctx) {
        throw new NotImplementedException();
    }

    /** clauseList
     *      :   clause
     *      |   UNDERSCORE ARROW expression
     *      |   clause ALT clauseList
     *      ;
     */
    @Override
    public WEntity visitClauseList(CatParser.ClauseListContext ctx) {
        throw new NotImplementedException();
    }

    /** varNameExpression
     *      :   varName
     *      |   <assoc=left> varNameExpression (varName | simpleExpression)
     *      ;
     */
    @Override
    public WEntity visitVarNameExpression(CatParser.VarNameExpressionContext ctx) {
        throw new NotImplementedException();
    }

    /** args
     *      :   
     *      |   expression
     *      |   expression COMMA args
     *      ;
     */
    @Override
    public WEntity visitArgs(CatParser.ArgsContext ctx) {
        throw new NotImplementedException();
    }

    /** varName
     *      :   NAME
     *      ;
     */
    @Override
    public WEntity visitVarName(CatParser.VarNameContext ctx) {
        throw new NotImplementedException();
    }

    /** tagName
     *      :   '\'' NAME
     *      ;
     */
    @Override
    public WEntity visitTagName(CatParser.TagNameContext ctx) {
        throw new NotImplementedException();
    }



}
