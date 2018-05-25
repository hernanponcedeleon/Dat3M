// Generated from Model.g4 by ANTLR 4.4

package dartagnan;
import dartagnan.wmm.*;

import org.antlr.v4.runtime.misc.NotNull;
import org.antlr.v4.runtime.tree.ParseTreeListener;

/**
 * This interface defines a complete listener for a parse tree produced by
 * {@link ModelParser}.
 */
public interface ModelListener extends ParseTreeListener {
	/**
	 * Enter a parse tree produced by {@link ModelParser#fancyrel}.
	 * @param ctx the parse tree
	 */
	void enterFancyrel(@NotNull ModelParser.FancyrelContext ctx);
	/**
	 * Exit a parse tree produced by {@link ModelParser#fancyrel}.
	 * @param ctx the parse tree
	 */
	void exitFancyrel(@NotNull ModelParser.FancyrelContext ctx);
	/**
	 * Enter a parse tree produced by {@link ModelParser#mcm}.
	 * @param ctx the parse tree
	 */
	void enterMcm(@NotNull ModelParser.McmContext ctx);
	/**
	 * Exit a parse tree produced by {@link ModelParser#mcm}.
	 * @param ctx the parse tree
	 */
	void exitMcm(@NotNull ModelParser.McmContext ctx);
	/**
	 * Enter a parse tree produced by {@link ModelParser#reldef}.
	 * @param ctx the parse tree
	 */
	void enterReldef(@NotNull ModelParser.ReldefContext ctx);
	/**
	 * Exit a parse tree produced by {@link ModelParser#reldef}.
	 * @param ctx the parse tree
	 */
	void exitReldef(@NotNull ModelParser.ReldefContext ctx);
	/**
	 * Enter a parse tree produced by {@link ModelParser#axiom}.
	 * @param ctx the parse tree
	 */
	void enterAxiom(@NotNull ModelParser.AxiomContext ctx);
	/**
	 * Exit a parse tree produced by {@link ModelParser#axiom}.
	 * @param ctx the parse tree
	 */
	void exitAxiom(@NotNull ModelParser.AxiomContext ctx);
	/**
	 * Enter a parse tree produced by {@link ModelParser#relation}.
	 * @param ctx the parse tree
	 */
	void enterRelation(@NotNull ModelParser.RelationContext ctx);
	/**
	 * Exit a parse tree produced by {@link ModelParser#relation}.
	 * @param ctx the parse tree
	 */
	void exitRelation(@NotNull ModelParser.RelationContext ctx);
	/**
	 * Enter a parse tree produced by {@link ModelParser#base}.
	 * @param ctx the parse tree
	 */
	void enterBase(@NotNull ModelParser.BaseContext ctx);
	/**
	 * Exit a parse tree produced by {@link ModelParser#base}.
	 * @param ctx the parse tree
	 */
	void exitBase(@NotNull ModelParser.BaseContext ctx);
}