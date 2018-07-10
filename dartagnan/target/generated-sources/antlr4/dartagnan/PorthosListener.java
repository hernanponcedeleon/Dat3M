// Generated from Porthos.g4 by ANTLR 4.7

package dartagnan;
import dartagnan.asserts.*;
import dartagnan.program.*;
import dartagnan.expression.*;
import dartagnan.program.Thread;
import java.util.HashMap;
import java.util.Map;

import org.antlr.v4.runtime.tree.ParseTreeListener;

/**
 * This interface defines a complete listener for a parse tree produced by
 * {@link PorthosParser}.
 */
public interface PorthosListener extends ParseTreeListener {
	/**
	 * Enter a parse tree produced by {@link PorthosParser#arith_expr}.
	 * @param ctx the parse tree
	 */
	void enterArith_expr(PorthosParser.Arith_exprContext ctx);
	/**
	 * Exit a parse tree produced by {@link PorthosParser#arith_expr}.
	 * @param ctx the parse tree
	 */
	void exitArith_expr(PorthosParser.Arith_exprContext ctx);
	/**
	 * Enter a parse tree produced by {@link PorthosParser#arith_atom}.
	 * @param ctx the parse tree
	 */
	void enterArith_atom(PorthosParser.Arith_atomContext ctx);
	/**
	 * Exit a parse tree produced by {@link PorthosParser#arith_atom}.
	 * @param ctx the parse tree
	 */
	void exitArith_atom(PorthosParser.Arith_atomContext ctx);
	/**
	 * Enter a parse tree produced by {@link PorthosParser#arith_comp}.
	 * @param ctx the parse tree
	 */
	void enterArith_comp(PorthosParser.Arith_compContext ctx);
	/**
	 * Exit a parse tree produced by {@link PorthosParser#arith_comp}.
	 * @param ctx the parse tree
	 */
	void exitArith_comp(PorthosParser.Arith_compContext ctx);
	/**
	 * Enter a parse tree produced by {@link PorthosParser#bool_expr}.
	 * @param ctx the parse tree
	 */
	void enterBool_expr(PorthosParser.Bool_exprContext ctx);
	/**
	 * Exit a parse tree produced by {@link PorthosParser#bool_expr}.
	 * @param ctx the parse tree
	 */
	void exitBool_expr(PorthosParser.Bool_exprContext ctx);
	/**
	 * Enter a parse tree produced by {@link PorthosParser#bool_atom}.
	 * @param ctx the parse tree
	 */
	void enterBool_atom(PorthosParser.Bool_atomContext ctx);
	/**
	 * Exit a parse tree produced by {@link PorthosParser#bool_atom}.
	 * @param ctx the parse tree
	 */
	void exitBool_atom(PorthosParser.Bool_atomContext ctx);
	/**
	 * Enter a parse tree produced by {@link PorthosParser#location}.
	 * @param ctx the parse tree
	 */
	void enterLocation(PorthosParser.LocationContext ctx);
	/**
	 * Exit a parse tree produced by {@link PorthosParser#location}.
	 * @param ctx the parse tree
	 */
	void exitLocation(PorthosParser.LocationContext ctx);
	/**
	 * Enter a parse tree produced by {@link PorthosParser#register}.
	 * @param ctx the parse tree
	 */
	void enterRegister(PorthosParser.RegisterContext ctx);
	/**
	 * Exit a parse tree produced by {@link PorthosParser#register}.
	 * @param ctx the parse tree
	 */
	void exitRegister(PorthosParser.RegisterContext ctx);
	/**
	 * Enter a parse tree produced by {@link PorthosParser#local}.
	 * @param ctx the parse tree
	 */
	void enterLocal(PorthosParser.LocalContext ctx);
	/**
	 * Exit a parse tree produced by {@link PorthosParser#local}.
	 * @param ctx the parse tree
	 */
	void exitLocal(PorthosParser.LocalContext ctx);
	/**
	 * Enter a parse tree produced by {@link PorthosParser#load}.
	 * @param ctx the parse tree
	 */
	void enterLoad(PorthosParser.LoadContext ctx);
	/**
	 * Exit a parse tree produced by {@link PorthosParser#load}.
	 * @param ctx the parse tree
	 */
	void exitLoad(PorthosParser.LoadContext ctx);
	/**
	 * Enter a parse tree produced by {@link PorthosParser#store}.
	 * @param ctx the parse tree
	 */
	void enterStore(PorthosParser.StoreContext ctx);
	/**
	 * Exit a parse tree produced by {@link PorthosParser#store}.
	 * @param ctx the parse tree
	 */
	void exitStore(PorthosParser.StoreContext ctx);
	/**
	 * Enter a parse tree produced by {@link PorthosParser#read}.
	 * @param ctx the parse tree
	 */
	void enterRead(PorthosParser.ReadContext ctx);
	/**
	 * Exit a parse tree produced by {@link PorthosParser#read}.
	 * @param ctx the parse tree
	 */
	void exitRead(PorthosParser.ReadContext ctx);
	/**
	 * Enter a parse tree produced by {@link PorthosParser#write}.
	 * @param ctx the parse tree
	 */
	void enterWrite(PorthosParser.WriteContext ctx);
	/**
	 * Exit a parse tree produced by {@link PorthosParser#write}.
	 * @param ctx the parse tree
	 */
	void exitWrite(PorthosParser.WriteContext ctx);
	/**
	 * Enter a parse tree produced by {@link PorthosParser#fence}.
	 * @param ctx the parse tree
	 */
	void enterFence(PorthosParser.FenceContext ctx);
	/**
	 * Exit a parse tree produced by {@link PorthosParser#fence}.
	 * @param ctx the parse tree
	 */
	void exitFence(PorthosParser.FenceContext ctx);
	/**
	 * Enter a parse tree produced by {@link PorthosParser#mfence}.
	 * @param ctx the parse tree
	 */
	void enterMfence(PorthosParser.MfenceContext ctx);
	/**
	 * Exit a parse tree produced by {@link PorthosParser#mfence}.
	 * @param ctx the parse tree
	 */
	void exitMfence(PorthosParser.MfenceContext ctx);
	/**
	 * Enter a parse tree produced by {@link PorthosParser#sync}.
	 * @param ctx the parse tree
	 */
	void enterSync(PorthosParser.SyncContext ctx);
	/**
	 * Exit a parse tree produced by {@link PorthosParser#sync}.
	 * @param ctx the parse tree
	 */
	void exitSync(PorthosParser.SyncContext ctx);
	/**
	 * Enter a parse tree produced by {@link PorthosParser#lwsync}.
	 * @param ctx the parse tree
	 */
	void enterLwsync(PorthosParser.LwsyncContext ctx);
	/**
	 * Exit a parse tree produced by {@link PorthosParser#lwsync}.
	 * @param ctx the parse tree
	 */
	void exitLwsync(PorthosParser.LwsyncContext ctx);
	/**
	 * Enter a parse tree produced by {@link PorthosParser#isync}.
	 * @param ctx the parse tree
	 */
	void enterIsync(PorthosParser.IsyncContext ctx);
	/**
	 * Exit a parse tree produced by {@link PorthosParser#isync}.
	 * @param ctx the parse tree
	 */
	void exitIsync(PorthosParser.IsyncContext ctx);
	/**
	 * Enter a parse tree produced by {@link PorthosParser#skip}.
	 * @param ctx the parse tree
	 */
	void enterSkip(PorthosParser.SkipContext ctx);
	/**
	 * Exit a parse tree produced by {@link PorthosParser#skip}.
	 * @param ctx the parse tree
	 */
	void exitSkip(PorthosParser.SkipContext ctx);
	/**
	 * Enter a parse tree produced by {@link PorthosParser#inst}.
	 * @param ctx the parse tree
	 */
	void enterInst(PorthosParser.InstContext ctx);
	/**
	 * Exit a parse tree produced by {@link PorthosParser#inst}.
	 * @param ctx the parse tree
	 */
	void exitInst(PorthosParser.InstContext ctx);
	/**
	 * Enter a parse tree produced by {@link PorthosParser#atom}.
	 * @param ctx the parse tree
	 */
	void enterAtom(PorthosParser.AtomContext ctx);
	/**
	 * Exit a parse tree produced by {@link PorthosParser#atom}.
	 * @param ctx the parse tree
	 */
	void exitAtom(PorthosParser.AtomContext ctx);
	/**
	 * Enter a parse tree produced by {@link PorthosParser#seq}.
	 * @param ctx the parse tree
	 */
	void enterSeq(PorthosParser.SeqContext ctx);
	/**
	 * Exit a parse tree produced by {@link PorthosParser#seq}.
	 * @param ctx the parse tree
	 */
	void exitSeq(PorthosParser.SeqContext ctx);
	/**
	 * Enter a parse tree produced by {@link PorthosParser#if1}.
	 * @param ctx the parse tree
	 */
	void enterIf1(PorthosParser.If1Context ctx);
	/**
	 * Exit a parse tree produced by {@link PorthosParser#if1}.
	 * @param ctx the parse tree
	 */
	void exitIf1(PorthosParser.If1Context ctx);
	/**
	 * Enter a parse tree produced by {@link PorthosParser#if2}.
	 * @param ctx the parse tree
	 */
	void enterIf2(PorthosParser.If2Context ctx);
	/**
	 * Exit a parse tree produced by {@link PorthosParser#if2}.
	 * @param ctx the parse tree
	 */
	void exitIf2(PorthosParser.If2Context ctx);
	/**
	 * Enter a parse tree produced by {@link PorthosParser#while_}.
	 * @param ctx the parse tree
	 */
	void enterWhile_(PorthosParser.While_Context ctx);
	/**
	 * Exit a parse tree produced by {@link PorthosParser#while_}.
	 * @param ctx the parse tree
	 */
	void exitWhile_(PorthosParser.While_Context ctx);
	/**
	 * Enter a parse tree produced by {@link PorthosParser#assertionList}.
	 * @param ctx the parse tree
	 */
	void enterAssertionList(PorthosParser.AssertionListContext ctx);
	/**
	 * Exit a parse tree produced by {@link PorthosParser#assertionList}.
	 * @param ctx the parse tree
	 */
	void exitAssertionList(PorthosParser.AssertionListContext ctx);
	/**
	 * Enter a parse tree produced by {@link PorthosParser#assertionType}.
	 * @param ctx the parse tree
	 */
	void enterAssertionType(PorthosParser.AssertionTypeContext ctx);
	/**
	 * Exit a parse tree produced by {@link PorthosParser#assertionType}.
	 * @param ctx the parse tree
	 */
	void exitAssertionType(PorthosParser.AssertionTypeContext ctx);
	/**
	 * Enter a parse tree produced by {@link PorthosParser#assertion}.
	 * @param ctx the parse tree
	 */
	void enterAssertion(PorthosParser.AssertionContext ctx);
	/**
	 * Exit a parse tree produced by {@link PorthosParser#assertion}.
	 * @param ctx the parse tree
	 */
	void exitAssertion(PorthosParser.AssertionContext ctx);
	/**
	 * Enter a parse tree produced by {@link PorthosParser#program}.
	 * @param ctx the parse tree
	 */
	void enterProgram(PorthosParser.ProgramContext ctx);
	/**
	 * Exit a parse tree produced by {@link PorthosParser#program}.
	 * @param ctx the parse tree
	 */
	void exitProgram(PorthosParser.ProgramContext ctx);
}