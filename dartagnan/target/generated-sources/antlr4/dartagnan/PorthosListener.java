// Generated from Porthos.g4 by ANTLR 4.4

package dartagnan;
import dartagnan.program.*;
import dartagnan.expression.*;
import dartagnan.program.Thread;
import java.util.HashMap;
import java.util.Map;

import org.antlr.v4.runtime.misc.NotNull;
import org.antlr.v4.runtime.tree.ParseTreeListener;

/**
 * This interface defines a complete listener for a parse tree produced by
 * {@link PorthosParser}.
 */
public interface PorthosListener extends ParseTreeListener {
	/**
	 * Enter a parse tree produced by {@link PorthosParser#read}.
	 * @param ctx the parse tree
	 */
	void enterRead(@NotNull PorthosParser.ReadContext ctx);
	/**
	 * Exit a parse tree produced by {@link PorthosParser#read}.
	 * @param ctx the parse tree
	 */
	void exitRead(@NotNull PorthosParser.ReadContext ctx);
	/**
	 * Enter a parse tree produced by {@link PorthosParser#lwsync}.
	 * @param ctx the parse tree
	 */
	void enterLwsync(@NotNull PorthosParser.LwsyncContext ctx);
	/**
	 * Exit a parse tree produced by {@link PorthosParser#lwsync}.
	 * @param ctx the parse tree
	 */
	void exitLwsync(@NotNull PorthosParser.LwsyncContext ctx);
	/**
	 * Enter a parse tree produced by {@link PorthosParser#mfence}.
	 * @param ctx the parse tree
	 */
	void enterMfence(@NotNull PorthosParser.MfenceContext ctx);
	/**
	 * Exit a parse tree produced by {@link PorthosParser#mfence}.
	 * @param ctx the parse tree
	 */
	void exitMfence(@NotNull PorthosParser.MfenceContext ctx);
	/**
	 * Enter a parse tree produced by {@link PorthosParser#store}.
	 * @param ctx the parse tree
	 */
	void enterStore(@NotNull PorthosParser.StoreContext ctx);
	/**
	 * Exit a parse tree produced by {@link PorthosParser#store}.
	 * @param ctx the parse tree
	 */
	void exitStore(@NotNull PorthosParser.StoreContext ctx);
	/**
	 * Enter a parse tree produced by {@link PorthosParser#program}.
	 * @param ctx the parse tree
	 */
	void enterProgram(@NotNull PorthosParser.ProgramContext ctx);
	/**
	 * Exit a parse tree produced by {@link PorthosParser#program}.
	 * @param ctx the parse tree
	 */
	void exitProgram(@NotNull PorthosParser.ProgramContext ctx);
	/**
	 * Enter a parse tree produced by {@link PorthosParser#sync}.
	 * @param ctx the parse tree
	 */
	void enterSync(@NotNull PorthosParser.SyncContext ctx);
	/**
	 * Exit a parse tree produced by {@link PorthosParser#sync}.
	 * @param ctx the parse tree
	 */
	void exitSync(@NotNull PorthosParser.SyncContext ctx);
	/**
	 * Enter a parse tree produced by {@link PorthosParser#local}.
	 * @param ctx the parse tree
	 */
	void enterLocal(@NotNull PorthosParser.LocalContext ctx);
	/**
	 * Exit a parse tree produced by {@link PorthosParser#local}.
	 * @param ctx the parse tree
	 */
	void exitLocal(@NotNull PorthosParser.LocalContext ctx);
	/**
	 * Enter a parse tree produced by {@link PorthosParser#bool_expr}.
	 * @param ctx the parse tree
	 */
	void enterBool_expr(@NotNull PorthosParser.Bool_exprContext ctx);
	/**
	 * Exit a parse tree produced by {@link PorthosParser#bool_expr}.
	 * @param ctx the parse tree
	 */
	void exitBool_expr(@NotNull PorthosParser.Bool_exprContext ctx);
	/**
	 * Enter a parse tree produced by {@link PorthosParser#load}.
	 * @param ctx the parse tree
	 */
	void enterLoad(@NotNull PorthosParser.LoadContext ctx);
	/**
	 * Exit a parse tree produced by {@link PorthosParser#load}.
	 * @param ctx the parse tree
	 */
	void exitLoad(@NotNull PorthosParser.LoadContext ctx);
	/**
	 * Enter a parse tree produced by {@link PorthosParser#if2}.
	 * @param ctx the parse tree
	 */
	void enterIf2(@NotNull PorthosParser.If2Context ctx);
	/**
	 * Exit a parse tree produced by {@link PorthosParser#if2}.
	 * @param ctx the parse tree
	 */
	void exitIf2(@NotNull PorthosParser.If2Context ctx);
	/**
	 * Enter a parse tree produced by {@link PorthosParser#arith_expr}.
	 * @param ctx the parse tree
	 */
	void enterArith_expr(@NotNull PorthosParser.Arith_exprContext ctx);
	/**
	 * Exit a parse tree produced by {@link PorthosParser#arith_expr}.
	 * @param ctx the parse tree
	 */
	void exitArith_expr(@NotNull PorthosParser.Arith_exprContext ctx);
	/**
	 * Enter a parse tree produced by {@link PorthosParser#if1}.
	 * @param ctx the parse tree
	 */
	void enterIf1(@NotNull PorthosParser.If1Context ctx);
	/**
	 * Exit a parse tree produced by {@link PorthosParser#if1}.
	 * @param ctx the parse tree
	 */
	void exitIf1(@NotNull PorthosParser.If1Context ctx);
	/**
	 * Enter a parse tree produced by {@link PorthosParser#while_}.
	 * @param ctx the parse tree
	 */
	void enterWhile_(@NotNull PorthosParser.While_Context ctx);
	/**
	 * Exit a parse tree produced by {@link PorthosParser#while_}.
	 * @param ctx the parse tree
	 */
	void exitWhile_(@NotNull PorthosParser.While_Context ctx);
	/**
	 * Enter a parse tree produced by {@link PorthosParser#inst}.
	 * @param ctx the parse tree
	 */
	void enterInst(@NotNull PorthosParser.InstContext ctx);
	/**
	 * Exit a parse tree produced by {@link PorthosParser#inst}.
	 * @param ctx the parse tree
	 */
	void exitInst(@NotNull PorthosParser.InstContext ctx);
	/**
	 * Enter a parse tree produced by {@link PorthosParser#arith_atom}.
	 * @param ctx the parse tree
	 */
	void enterArith_atom(@NotNull PorthosParser.Arith_atomContext ctx);
	/**
	 * Exit a parse tree produced by {@link PorthosParser#arith_atom}.
	 * @param ctx the parse tree
	 */
	void exitArith_atom(@NotNull PorthosParser.Arith_atomContext ctx);
	/**
	 * Enter a parse tree produced by {@link PorthosParser#isync}.
	 * @param ctx the parse tree
	 */
	void enterIsync(@NotNull PorthosParser.IsyncContext ctx);
	/**
	 * Exit a parse tree produced by {@link PorthosParser#isync}.
	 * @param ctx the parse tree
	 */
	void exitIsync(@NotNull PorthosParser.IsyncContext ctx);
	/**
	 * Enter a parse tree produced by {@link PorthosParser#bool_atom}.
	 * @param ctx the parse tree
	 */
	void enterBool_atom(@NotNull PorthosParser.Bool_atomContext ctx);
	/**
	 * Exit a parse tree produced by {@link PorthosParser#bool_atom}.
	 * @param ctx the parse tree
	 */
	void exitBool_atom(@NotNull PorthosParser.Bool_atomContext ctx);
	/**
	 * Enter a parse tree produced by {@link PorthosParser#location}.
	 * @param ctx the parse tree
	 */
	void enterLocation(@NotNull PorthosParser.LocationContext ctx);
	/**
	 * Exit a parse tree produced by {@link PorthosParser#location}.
	 * @param ctx the parse tree
	 */
	void exitLocation(@NotNull PorthosParser.LocationContext ctx);
	/**
	 * Enter a parse tree produced by {@link PorthosParser#atom}.
	 * @param ctx the parse tree
	 */
	void enterAtom(@NotNull PorthosParser.AtomContext ctx);
	/**
	 * Exit a parse tree produced by {@link PorthosParser#atom}.
	 * @param ctx the parse tree
	 */
	void exitAtom(@NotNull PorthosParser.AtomContext ctx);
	/**
	 * Enter a parse tree produced by {@link PorthosParser#write}.
	 * @param ctx the parse tree
	 */
	void enterWrite(@NotNull PorthosParser.WriteContext ctx);
	/**
	 * Exit a parse tree produced by {@link PorthosParser#write}.
	 * @param ctx the parse tree
	 */
	void exitWrite(@NotNull PorthosParser.WriteContext ctx);
	/**
	 * Enter a parse tree produced by {@link PorthosParser#fence}.
	 * @param ctx the parse tree
	 */
	void enterFence(@NotNull PorthosParser.FenceContext ctx);
	/**
	 * Exit a parse tree produced by {@link PorthosParser#fence}.
	 * @param ctx the parse tree
	 */
	void exitFence(@NotNull PorthosParser.FenceContext ctx);
	/**
	 * Enter a parse tree produced by {@link PorthosParser#arith_comp}.
	 * @param ctx the parse tree
	 */
	void enterArith_comp(@NotNull PorthosParser.Arith_compContext ctx);
	/**
	 * Exit a parse tree produced by {@link PorthosParser#arith_comp}.
	 * @param ctx the parse tree
	 */
	void exitArith_comp(@NotNull PorthosParser.Arith_compContext ctx);
	/**
	 * Enter a parse tree produced by {@link PorthosParser#seq}.
	 * @param ctx the parse tree
	 */
	void enterSeq(@NotNull PorthosParser.SeqContext ctx);
	/**
	 * Exit a parse tree produced by {@link PorthosParser#seq}.
	 * @param ctx the parse tree
	 */
	void exitSeq(@NotNull PorthosParser.SeqContext ctx);
	/**
	 * Enter a parse tree produced by {@link PorthosParser#register}.
	 * @param ctx the parse tree
	 */
	void enterRegister(@NotNull PorthosParser.RegisterContext ctx);
	/**
	 * Exit a parse tree produced by {@link PorthosParser#register}.
	 * @param ctx the parse tree
	 */
	void exitRegister(@NotNull PorthosParser.RegisterContext ctx);
}