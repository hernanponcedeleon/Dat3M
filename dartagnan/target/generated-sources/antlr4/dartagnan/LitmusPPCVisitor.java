// Generated from LitmusPPC.g4 by ANTLR 4.7

package dartagnan;

import org.antlr.v4.runtime.tree.ParseTreeVisitor;

/**
 * This interface defines a complete generic visitor for a parse tree produced
 * by {@link LitmusPPCParser}.
 *
 * @param <T> The return type of the visit operation. Use {@link Void} for
 * operations with no return type.
 */
public interface LitmusPPCVisitor<T> extends ParseTreeVisitor<T> {
	/**
	 * Visit a parse tree produced by {@link LitmusPPCParser#main}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitMain(LitmusPPCParser.MainContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusPPCParser#header}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitHeader(LitmusPPCParser.HeaderContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusPPCParser#headerComment}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitHeaderComment(LitmusPPCParser.HeaderCommentContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusPPCParser#variableDeclaratorList}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitVariableDeclaratorList(LitmusPPCParser.VariableDeclaratorListContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusPPCParser#variableDeclarator}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitVariableDeclarator(LitmusPPCParser.VariableDeclaratorContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusPPCParser#variableDeclaratorLocation}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitVariableDeclaratorLocation(LitmusPPCParser.VariableDeclaratorLocationContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusPPCParser#variableDeclaratorRegister}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitVariableDeclaratorRegister(LitmusPPCParser.VariableDeclaratorRegisterContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusPPCParser#variableDeclaratorRegisterLocation}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitVariableDeclaratorRegisterLocation(LitmusPPCParser.VariableDeclaratorRegisterLocationContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusPPCParser#variableList}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitVariableList(LitmusPPCParser.VariableListContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusPPCParser#variable}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitVariable(LitmusPPCParser.VariableContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusPPCParser#threadDeclaratorList}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitThreadDeclaratorList(LitmusPPCParser.ThreadDeclaratorListContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusPPCParser#instructionList}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitInstructionList(LitmusPPCParser.InstructionListContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusPPCParser#instructionRow}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitInstructionRow(LitmusPPCParser.InstructionRowContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusPPCParser#instruction}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitInstruction(LitmusPPCParser.InstructionContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusPPCParser#none}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitNone(LitmusPPCParser.NoneContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusPPCParser#li}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLi(LitmusPPCParser.LiContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusPPCParser#lwz}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLwz(LitmusPPCParser.LwzContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusPPCParser#lwzx}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLwzx(LitmusPPCParser.LwzxContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusPPCParser#stw}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStw(LitmusPPCParser.StwContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusPPCParser#stwx}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStwx(LitmusPPCParser.StwxContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusPPCParser#mr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitMr(LitmusPPCParser.MrContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusPPCParser#addi}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAddi(LitmusPPCParser.AddiContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusPPCParser#xor}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitXor(LitmusPPCParser.XorContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusPPCParser#cmpw}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCmpw(LitmusPPCParser.CmpwContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusPPCParser#label}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLabel(LitmusPPCParser.LabelContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusPPCParser#beq}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitBeq(LitmusPPCParser.BeqContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusPPCParser#bne}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitBne(LitmusPPCParser.BneContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusPPCParser#blt}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitBlt(LitmusPPCParser.BltContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusPPCParser#bgt}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitBgt(LitmusPPCParser.BgtContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusPPCParser#ble}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitBle(LitmusPPCParser.BleContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusPPCParser#bge}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitBge(LitmusPPCParser.BgeContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusPPCParser#sync}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSync(LitmusPPCParser.SyncContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusPPCParser#lwsync}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLwsync(LitmusPPCParser.LwsyncContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusPPCParser#isync}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitIsync(LitmusPPCParser.IsyncContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusPPCParser#eieio}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEieio(LitmusPPCParser.EieioContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusPPCParser#thread}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitThread(LitmusPPCParser.ThreadContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusPPCParser#r1}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitR1(LitmusPPCParser.R1Context ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusPPCParser#r2}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitR2(LitmusPPCParser.R2Context ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusPPCParser#r3}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitR3(LitmusPPCParser.R3Context ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusPPCParser#location}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLocation(LitmusPPCParser.LocationContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusPPCParser#value}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitValue(LitmusPPCParser.ValueContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusPPCParser#offset}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitOffset(LitmusPPCParser.OffsetContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusPPCParser#assertionList}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAssertionList(LitmusPPCParser.AssertionListContext ctx);
	/**
	 * Visit a parse tree produced by the {@code assertionLocation}
	 * labeled alternative in {@link LitmusPPCParser#assertion}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAssertionLocation(LitmusPPCParser.AssertionLocationContext ctx);
	/**
	 * Visit a parse tree produced by the {@code assertionRegister}
	 * labeled alternative in {@link LitmusPPCParser#assertion}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAssertionRegister(LitmusPPCParser.AssertionRegisterContext ctx);
	/**
	 * Visit a parse tree produced by the {@code assertionAnd}
	 * labeled alternative in {@link LitmusPPCParser#assertion}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAssertionAnd(LitmusPPCParser.AssertionAndContext ctx);
	/**
	 * Visit a parse tree produced by the {@code assertionOr}
	 * labeled alternative in {@link LitmusPPCParser#assertion}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAssertionOr(LitmusPPCParser.AssertionOrContext ctx);
	/**
	 * Visit a parse tree produced by the {@code assertionParenthesis}
	 * labeled alternative in {@link LitmusPPCParser#assertion}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAssertionParenthesis(LitmusPPCParser.AssertionParenthesisContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusPPCParser#assertionListExpectationList}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAssertionListExpectationList(LitmusPPCParser.AssertionListExpectationListContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusPPCParser#assertionListExpectation}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAssertionListExpectation(LitmusPPCParser.AssertionListExpectationContext ctx);
	/**
	 * Visit a parse tree produced by {@link LitmusPPCParser#assertionListExpectationTest}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAssertionListExpectationTest(LitmusPPCParser.AssertionListExpectationTestContext ctx);
}