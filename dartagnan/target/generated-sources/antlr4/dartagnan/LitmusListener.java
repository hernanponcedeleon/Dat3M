// Generated from Litmus.g4 by ANTLR 4.7

package dartagnan;
import dartagnan.program.*;
import dartagnan.expression.*;
import dartagnan.program.Thread;
import java.util.HashMap;
import java.util.Map;
import java.util.ArrayList;
import java.util.List;

import org.antlr.v4.runtime.tree.ParseTreeListener;

/**
 * This interface defines a complete listener for a parse tree produced by
 * {@link LitmusParser}.
 */
public interface LitmusListener extends ParseTreeListener {
	/**
	 * Enter a parse tree produced by {@link LitmusParser#program}.
	 * @param ctx the parse tree
	 */
	void enterProgram(LitmusParser.ProgramContext ctx);
	/**
	 * Exit a parse tree produced by {@link LitmusParser#program}.
	 * @param ctx the parse tree
	 */
	void exitProgram(LitmusParser.ProgramContext ctx);
	/**
	 * Enter a parse tree produced by {@link LitmusParser#inits}.
	 * @param ctx the parse tree
	 */
	void enterInits(LitmusParser.InitsContext ctx);
	/**
	 * Exit a parse tree produced by {@link LitmusParser#inits}.
	 * @param ctx the parse tree
	 */
	void exitInits(LitmusParser.InitsContext ctx);
	/**
	 * Enter a parse tree produced by {@link LitmusParser#initLocation}.
	 * @param ctx the parse tree
	 */
	void enterInitLocation(LitmusParser.InitLocationContext ctx);
	/**
	 * Exit a parse tree produced by {@link LitmusParser#initLocation}.
	 * @param ctx the parse tree
	 */
	void exitInitLocation(LitmusParser.InitLocationContext ctx);
	/**
	 * Enter a parse tree produced by {@link LitmusParser#initRegister}.
	 * @param ctx the parse tree
	 */
	void enterInitRegister(LitmusParser.InitRegisterContext ctx);
	/**
	 * Exit a parse tree produced by {@link LitmusParser#initRegister}.
	 * @param ctx the parse tree
	 */
	void exitInitRegister(LitmusParser.InitRegisterContext ctx);
	/**
	 * Enter a parse tree produced by {@link LitmusParser#initRegisterLocation}.
	 * @param ctx the parse tree
	 */
	void enterInitRegisterLocation(LitmusParser.InitRegisterLocationContext ctx);
	/**
	 * Exit a parse tree produced by {@link LitmusParser#initRegisterLocation}.
	 * @param ctx the parse tree
	 */
	void exitInitRegisterLocation(LitmusParser.InitRegisterLocationContext ctx);
	/**
	 * Enter a parse tree produced by {@link LitmusParser#assertion}.
	 * @param ctx the parse tree
	 */
	void enterAssertion(LitmusParser.AssertionContext ctx);
	/**
	 * Exit a parse tree produced by {@link LitmusParser#assertion}.
	 * @param ctx the parse tree
	 */
	void exitAssertion(LitmusParser.AssertionContext ctx);
	/**
	 * Enter a parse tree produced by {@link LitmusParser#bop}.
	 * @param ctx the parse tree
	 */
	void enterBop(LitmusParser.BopContext ctx);
	/**
	 * Exit a parse tree produced by {@link LitmusParser#bop}.
	 * @param ctx the parse tree
	 */
	void exitBop(LitmusParser.BopContext ctx);
	/**
	 * Enter a parse tree produced by {@link LitmusParser#headerComments}.
	 * @param ctx the parse tree
	 */
	void enterHeaderComments(LitmusParser.HeaderCommentsContext ctx);
	/**
	 * Exit a parse tree produced by {@link LitmusParser#headerComments}.
	 * @param ctx the parse tree
	 */
	void exitHeaderComments(LitmusParser.HeaderCommentsContext ctx);
	/**
	 * Enter a parse tree produced by {@link LitmusParser#bottomComments}.
	 * @param ctx the parse tree
	 */
	void enterBottomComments(LitmusParser.BottomCommentsContext ctx);
	/**
	 * Exit a parse tree produced by {@link LitmusParser#bottomComments}.
	 * @param ctx the parse tree
	 */
	void exitBottomComments(LitmusParser.BottomCommentsContext ctx);
	/**
	 * Enter a parse tree produced by {@link LitmusParser#word}.
	 * @param ctx the parse tree
	 */
	void enterWord(LitmusParser.WordContext ctx);
	/**
	 * Exit a parse tree produced by {@link LitmusParser#word}.
	 * @param ctx the parse tree
	 */
	void exitWord(LitmusParser.WordContext ctx);
	/**
	 * Enter a parse tree produced by {@link LitmusParser#location}.
	 * @param ctx the parse tree
	 */
	void enterLocation(LitmusParser.LocationContext ctx);
	/**
	 * Exit a parse tree produced by {@link LitmusParser#location}.
	 * @param ctx the parse tree
	 */
	void exitLocation(LitmusParser.LocationContext ctx);
	/**
	 * Enter a parse tree produced by {@link LitmusParser#locationX86}.
	 * @param ctx the parse tree
	 */
	void enterLocationX86(LitmusParser.LocationX86Context ctx);
	/**
	 * Exit a parse tree produced by {@link LitmusParser#locationX86}.
	 * @param ctx the parse tree
	 */
	void exitLocationX86(LitmusParser.LocationX86Context ctx);
	/**
	 * Enter a parse tree produced by {@link LitmusParser#registerPower}.
	 * @param ctx the parse tree
	 */
	void enterRegisterPower(LitmusParser.RegisterPowerContext ctx);
	/**
	 * Exit a parse tree produced by {@link LitmusParser#registerPower}.
	 * @param ctx the parse tree
	 */
	void exitRegisterPower(LitmusParser.RegisterPowerContext ctx);
	/**
	 * Enter a parse tree produced by {@link LitmusParser#registerX86}.
	 * @param ctx the parse tree
	 */
	void enterRegisterX86(LitmusParser.RegisterX86Context ctx);
	/**
	 * Exit a parse tree produced by {@link LitmusParser#registerX86}.
	 * @param ctx the parse tree
	 */
	void exitRegisterX86(LitmusParser.RegisterX86Context ctx);
	/**
	 * Enter a parse tree produced by {@link LitmusParser#threads}.
	 * @param ctx the parse tree
	 */
	void enterThreads(LitmusParser.ThreadsContext ctx);
	/**
	 * Exit a parse tree produced by {@link LitmusParser#threads}.
	 * @param ctx the parse tree
	 */
	void exitThreads(LitmusParser.ThreadsContext ctx);
	/**
	 * Enter a parse tree produced by {@link LitmusParser#inst}.
	 * @param ctx the parse tree
	 */
	void enterInst(LitmusParser.InstContext ctx);
	/**
	 * Exit a parse tree produced by {@link LitmusParser#inst}.
	 * @param ctx the parse tree
	 */
	void exitInst(LitmusParser.InstContext ctx);
	/**
	 * Enter a parse tree produced by {@link LitmusParser#localX86}.
	 * @param ctx the parse tree
	 */
	void enterLocalX86(LitmusParser.LocalX86Context ctx);
	/**
	 * Exit a parse tree produced by {@link LitmusParser#localX86}.
	 * @param ctx the parse tree
	 */
	void exitLocalX86(LitmusParser.LocalX86Context ctx);
	/**
	 * Enter a parse tree produced by {@link LitmusParser#localPower}.
	 * @param ctx the parse tree
	 */
	void enterLocalPower(LitmusParser.LocalPowerContext ctx);
	/**
	 * Exit a parse tree produced by {@link LitmusParser#localPower}.
	 * @param ctx the parse tree
	 */
	void exitLocalPower(LitmusParser.LocalPowerContext ctx);
	/**
	 * Enter a parse tree produced by {@link LitmusParser#xor}.
	 * @param ctx the parse tree
	 */
	void enterXor(LitmusParser.XorContext ctx);
	/**
	 * Exit a parse tree produced by {@link LitmusParser#xor}.
	 * @param ctx the parse tree
	 */
	void exitXor(LitmusParser.XorContext ctx);
	/**
	 * Enter a parse tree produced by {@link LitmusParser#addi}.
	 * @param ctx the parse tree
	 */
	void enterAddi(LitmusParser.AddiContext ctx);
	/**
	 * Exit a parse tree produced by {@link LitmusParser#addi}.
	 * @param ctx the parse tree
	 */
	void exitAddi(LitmusParser.AddiContext ctx);
	/**
	 * Enter a parse tree produced by {@link LitmusParser#mr}.
	 * @param ctx the parse tree
	 */
	void enterMr(LitmusParser.MrContext ctx);
	/**
	 * Exit a parse tree produced by {@link LitmusParser#mr}.
	 * @param ctx the parse tree
	 */
	void exitMr(LitmusParser.MrContext ctx);
	/**
	 * Enter a parse tree produced by {@link LitmusParser#loadX86}.
	 * @param ctx the parse tree
	 */
	void enterLoadX86(LitmusParser.LoadX86Context ctx);
	/**
	 * Exit a parse tree produced by {@link LitmusParser#loadX86}.
	 * @param ctx the parse tree
	 */
	void exitLoadX86(LitmusParser.LoadX86Context ctx);
	/**
	 * Enter a parse tree produced by {@link LitmusParser#loadPower}.
	 * @param ctx the parse tree
	 */
	void enterLoadPower(LitmusParser.LoadPowerContext ctx);
	/**
	 * Exit a parse tree produced by {@link LitmusParser#loadPower}.
	 * @param ctx the parse tree
	 */
	void exitLoadPower(LitmusParser.LoadPowerContext ctx);
	/**
	 * Enter a parse tree produced by {@link LitmusParser#storeX86reg}.
	 * @param ctx the parse tree
	 */
	void enterStoreX86reg(LitmusParser.StoreX86regContext ctx);
	/**
	 * Exit a parse tree produced by {@link LitmusParser#storeX86reg}.
	 * @param ctx the parse tree
	 */
	void exitStoreX86reg(LitmusParser.StoreX86regContext ctx);
	/**
	 * Enter a parse tree produced by {@link LitmusParser#storeX86val}.
	 * @param ctx the parse tree
	 */
	void enterStoreX86val(LitmusParser.StoreX86valContext ctx);
	/**
	 * Exit a parse tree produced by {@link LitmusParser#storeX86val}.
	 * @param ctx the parse tree
	 */
	void exitStoreX86val(LitmusParser.StoreX86valContext ctx);
	/**
	 * Enter a parse tree produced by {@link LitmusParser#storePower}.
	 * @param ctx the parse tree
	 */
	void enterStorePower(LitmusParser.StorePowerContext ctx);
	/**
	 * Exit a parse tree produced by {@link LitmusParser#storePower}.
	 * @param ctx the parse tree
	 */
	void exitStorePower(LitmusParser.StorePowerContext ctx);
	/**
	 * Enter a parse tree produced by {@link LitmusParser#mfence}.
	 * @param ctx the parse tree
	 */
	void enterMfence(LitmusParser.MfenceContext ctx);
	/**
	 * Exit a parse tree produced by {@link LitmusParser#mfence}.
	 * @param ctx the parse tree
	 */
	void exitMfence(LitmusParser.MfenceContext ctx);
	/**
	 * Enter a parse tree produced by {@link LitmusParser#lwsync}.
	 * @param ctx the parse tree
	 */
	void enterLwsync(LitmusParser.LwsyncContext ctx);
	/**
	 * Exit a parse tree produced by {@link LitmusParser#lwsync}.
	 * @param ctx the parse tree
	 */
	void exitLwsync(LitmusParser.LwsyncContext ctx);
	/**
	 * Enter a parse tree produced by {@link LitmusParser#sync}.
	 * @param ctx the parse tree
	 */
	void enterSync(LitmusParser.SyncContext ctx);
	/**
	 * Exit a parse tree produced by {@link LitmusParser#sync}.
	 * @param ctx the parse tree
	 */
	void exitSync(LitmusParser.SyncContext ctx);
	/**
	 * Enter a parse tree produced by {@link LitmusParser#isync}.
	 * @param ctx the parse tree
	 */
	void enterIsync(LitmusParser.IsyncContext ctx);
	/**
	 * Exit a parse tree produced by {@link LitmusParser#isync}.
	 * @param ctx the parse tree
	 */
	void exitIsync(LitmusParser.IsyncContext ctx);
}