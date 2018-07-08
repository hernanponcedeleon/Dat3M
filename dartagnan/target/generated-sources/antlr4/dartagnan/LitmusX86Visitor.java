// Generated from LitmusX86.g4 by ANTLR 4.7

package dartagnan;

import org.antlr.v4.runtime.tree.ParseTreeVisitor;

/**
 * This interface defines a complete generic visitor for a parse tree produced
 * by {@link LitmusX86Parser}.
 *
 * @param <T> The return type of the visit operation. Use {@link Void} for
 * operations with no return type.
 */
public interface LitmusX86Visitor<T> extends ParseTreeVisitor<T> {
	/**
	 * Visit a parse tree produced by {@link LitmusX86Parser#main}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitMain(LitmusX86Parser.MainContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusX86Parser#header}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitHeader(LitmusX86Parser.HeaderContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusX86Parser#headerComment}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitHeaderComment(LitmusX86Parser.HeaderCommentContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusX86Parser#variableDeclaratorList}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitVariableDeclaratorList(LitmusX86Parser.VariableDeclaratorListContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusX86Parser#variableDeclarator}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitVariableDeclarator(LitmusX86Parser.VariableDeclaratorContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusX86Parser#variableDeclaratorLocation}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitVariableDeclaratorLocation(LitmusX86Parser.VariableDeclaratorLocationContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusX86Parser#variableDeclaratorRegister}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitVariableDeclaratorRegister(LitmusX86Parser.VariableDeclaratorRegisterContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusX86Parser#variableDeclaratorRegisterLocation}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitVariableDeclaratorRegisterLocation(LitmusX86Parser.VariableDeclaratorRegisterLocationContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusX86Parser#variableList}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitVariableList(LitmusX86Parser.VariableListContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusX86Parser#variable}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitVariable(LitmusX86Parser.VariableContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusX86Parser#threadDeclaratorList}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitThreadDeclaratorList(LitmusX86Parser.ThreadDeclaratorListContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusX86Parser#instructionList}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitInstructionList(LitmusX86Parser.InstructionListContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusX86Parser#instructionRow}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitInstructionRow(LitmusX86Parser.InstructionRowContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusX86Parser#instruction}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitInstruction(LitmusX86Parser.InstructionContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusX86Parser#none}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitNone(LitmusX86Parser.NoneContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusX86Parser#loadValueToRegister}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLoadValueToRegister(LitmusX86Parser.LoadValueToRegisterContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusX86Parser#loadLocationToRegister}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLoadLocationToRegister(LitmusX86Parser.LoadLocationToRegisterContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusX86Parser#storeValueToLocation}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStoreValueToLocation(LitmusX86Parser.StoreValueToLocationContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusX86Parser#storeRegisterToLocation}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStoreRegisterToLocation(LitmusX86Parser.StoreRegisterToLocationContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusX86Parser#mfence}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitMfence(LitmusX86Parser.MfenceContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusX86Parser#lfence}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLfence(LitmusX86Parser.LfenceContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusX86Parser#sfence}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSfence(LitmusX86Parser.SfenceContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusX86Parser#exchangeRegisterLocation}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExchangeRegisterLocation(LitmusX86Parser.ExchangeRegisterLocationContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusX86Parser#incrementLocation}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitIncrementLocation(LitmusX86Parser.IncrementLocationContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusX86Parser#compareRegisterValue}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCompareRegisterValue(LitmusX86Parser.CompareRegisterValueContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusX86Parser#compareLocationValue}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCompareLocationValue(LitmusX86Parser.CompareLocationValueContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusX86Parser#addRegisterRegister}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAddRegisterRegister(LitmusX86Parser.AddRegisterRegisterContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusX86Parser#addRegisterValue}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAddRegisterValue(LitmusX86Parser.AddRegisterValueContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusX86Parser#thread}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitThread(LitmusX86Parser.ThreadContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusX86Parser#r1}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitR1(LitmusX86Parser.R1Context ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusX86Parser#r2}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitR2(LitmusX86Parser.R2Context ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusX86Parser#location}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLocation(LitmusX86Parser.LocationContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusX86Parser#value}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitValue(LitmusX86Parser.ValueContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusX86Parser#assertionList}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAssertionList(LitmusX86Parser.AssertionListContext ctx);
	/**
	 * Visit a parse tree produced by the {@code assertionLocation}
	 * labeled alternative in {@link LitmusX86Parser#assertion}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAssertionLocation(LitmusX86Parser.AssertionLocationContext ctx);
	/**
	 * Visit a parse tree produced by the {@code assertionRegister}
	 * labeled alternative in {@link LitmusX86Parser#assertion}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAssertionRegister(LitmusX86Parser.AssertionRegisterContext ctx);
	/**
	 * Visit a parse tree produced by the {@code assertionAnd}
	 * labeled alternative in {@link LitmusX86Parser#assertion}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAssertionAnd(LitmusX86Parser.AssertionAndContext ctx);
	/**
	 * Visit a parse tree produced by the {@code assertionOr}
	 * labeled alternative in {@link LitmusX86Parser#assertion}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAssertionOr(LitmusX86Parser.AssertionOrContext ctx);
	/**
	 * Visit a parse tree produced by the {@code assertionParenthesis}
	 * labeled alternative in {@link LitmusX86Parser#assertion}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAssertionParenthesis(LitmusX86Parser.AssertionParenthesisContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusX86Parser#assertionListExpectationList}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAssertionListExpectationList(LitmusX86Parser.AssertionListExpectationListContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusX86Parser#assertionListExpectation}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAssertionListExpectation(LitmusX86Parser.AssertionListExpectationContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusX86Parser#assertionListExpectationTest}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAssertionListExpectationTest(LitmusX86Parser.AssertionListExpectationTestContext ctx);
}