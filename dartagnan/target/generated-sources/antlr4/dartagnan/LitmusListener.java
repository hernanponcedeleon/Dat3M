// Generated from Litmus.g4 by ANTLR 4.4

package dartagnan;
import dartagnan.program.*;
import dartagnan.expression.*;
import dartagnan.program.Thread;
import java.util.HashMap;
import java.util.Map;
import java.util.ArrayList;
import java.util.List;

import org.antlr.v4.runtime.misc.NotNull;
import org.antlr.v4.runtime.tree.ParseTreeListener;

/**
 * This interface defines a complete listener for a parse tree produced by
 * {@link LitmusParser}.
 */
public interface LitmusListener extends ParseTreeListener {
	/**
	 * Enter a parse tree produced by {@link LitmusParser#localX86}.
	 * @param ctx the parse tree
	 */
	void enterLocalX86(@NotNull LitmusParser.LocalX86Context ctx);
	/**
	 * Exit a parse tree produced by {@link LitmusParser#localX86}.
	 * @param ctx the parse tree
	 */
	void exitLocalX86(@NotNull LitmusParser.LocalX86Context ctx);
	/**
	 * Enter a parse tree produced by {@link LitmusParser#loadX86}.
	 * @param ctx the parse tree
	 */
	void enterLoadX86(@NotNull LitmusParser.LoadX86Context ctx);
	/**
	 * Exit a parse tree produced by {@link LitmusParser#loadX86}.
	 * @param ctx the parse tree
	 */
	void exitLoadX86(@NotNull LitmusParser.LoadX86Context ctx);
	/**
	 * Enter a parse tree produced by {@link LitmusParser#bop}.
	 * @param ctx the parse tree
	 */
	void enterBop(@NotNull LitmusParser.BopContext ctx);
	/**
	 * Exit a parse tree produced by {@link LitmusParser#bop}.
	 * @param ctx the parse tree
	 */
	void exitBop(@NotNull LitmusParser.BopContext ctx);
	/**
	 * Enter a parse tree produced by {@link LitmusParser#loadPower}.
	 * @param ctx the parse tree
	 */
	void enterLoadPower(@NotNull LitmusParser.LoadPowerContext ctx);
	/**
	 * Exit a parse tree produced by {@link LitmusParser#loadPower}.
	 * @param ctx the parse tree
	 */
	void exitLoadPower(@NotNull LitmusParser.LoadPowerContext ctx);
	/**
	 * Enter a parse tree produced by {@link LitmusParser#localPower}.
	 * @param ctx the parse tree
	 */
	void enterLocalPower(@NotNull LitmusParser.LocalPowerContext ctx);
	/**
	 * Exit a parse tree produced by {@link LitmusParser#localPower}.
	 * @param ctx the parse tree
	 */
	void exitLocalPower(@NotNull LitmusParser.LocalPowerContext ctx);
	/**
	 * Enter a parse tree produced by {@link LitmusParser#addi}.
	 * @param ctx the parse tree
	 */
	void enterAddi(@NotNull LitmusParser.AddiContext ctx);
	/**
	 * Exit a parse tree produced by {@link LitmusParser#addi}.
	 * @param ctx the parse tree
	 */
	void exitAddi(@NotNull LitmusParser.AddiContext ctx);
	/**
	 * Enter a parse tree produced by {@link LitmusParser#mr}.
	 * @param ctx the parse tree
	 */
	void enterMr(@NotNull LitmusParser.MrContext ctx);
	/**
	 * Exit a parse tree produced by {@link LitmusParser#mr}.
	 * @param ctx the parse tree
	 */
	void exitMr(@NotNull LitmusParser.MrContext ctx);
	/**
	 * Enter a parse tree produced by {@link LitmusParser#lwsync}.
	 * @param ctx the parse tree
	 */
	void enterLwsync(@NotNull LitmusParser.LwsyncContext ctx);
	/**
	 * Exit a parse tree produced by {@link LitmusParser#lwsync}.
	 * @param ctx the parse tree
	 */
	void exitLwsync(@NotNull LitmusParser.LwsyncContext ctx);
	/**
	 * Enter a parse tree produced by {@link LitmusParser#threads}.
	 * @param ctx the parse tree
	 */
	void enterThreads(@NotNull LitmusParser.ThreadsContext ctx);
	/**
	 * Exit a parse tree produced by {@link LitmusParser#threads}.
	 * @param ctx the parse tree
	 */
	void exitThreads(@NotNull LitmusParser.ThreadsContext ctx);
	/**
	 * Enter a parse tree produced by {@link LitmusParser#mfence}.
	 * @param ctx the parse tree
	 */
	void enterMfence(@NotNull LitmusParser.MfenceContext ctx);
	/**
	 * Exit a parse tree produced by {@link LitmusParser#mfence}.
	 * @param ctx the parse tree
	 */
	void exitMfence(@NotNull LitmusParser.MfenceContext ctx);
	/**
	 * Enter a parse tree produced by {@link LitmusParser#locationX86}.
	 * @param ctx the parse tree
	 */
	void enterLocationX86(@NotNull LitmusParser.LocationX86Context ctx);
	/**
	 * Exit a parse tree produced by {@link LitmusParser#locationX86}.
	 * @param ctx the parse tree
	 */
	void exitLocationX86(@NotNull LitmusParser.LocationX86Context ctx);
	/**
	 * Enter a parse tree produced by {@link LitmusParser#program}.
	 * @param ctx the parse tree
	 */
	void enterProgram(@NotNull LitmusParser.ProgramContext ctx);
	/**
	 * Exit a parse tree produced by {@link LitmusParser#program}.
	 * @param ctx the parse tree
	 */
	void exitProgram(@NotNull LitmusParser.ProgramContext ctx);
	/**
	 * Enter a parse tree produced by {@link LitmusParser#registerX86}.
	 * @param ctx the parse tree
	 */
	void enterRegisterX86(@NotNull LitmusParser.RegisterX86Context ctx);
	/**
	 * Exit a parse tree produced by {@link LitmusParser#registerX86}.
	 * @param ctx the parse tree
	 */
	void exitRegisterX86(@NotNull LitmusParser.RegisterX86Context ctx);
	/**
	 * Enter a parse tree produced by {@link LitmusParser#storeX86}.
	 * @param ctx the parse tree
	 */
	void enterStoreX86(@NotNull LitmusParser.StoreX86Context ctx);
	/**
	 * Exit a parse tree produced by {@link LitmusParser#storeX86}.
	 * @param ctx the parse tree
	 */
	void exitStoreX86(@NotNull LitmusParser.StoreX86Context ctx);
	/**
	 * Enter a parse tree produced by {@link LitmusParser#sync}.
	 * @param ctx the parse tree
	 */
	void enterSync(@NotNull LitmusParser.SyncContext ctx);
	/**
	 * Exit a parse tree produced by {@link LitmusParser#sync}.
	 * @param ctx the parse tree
	 */
	void exitSync(@NotNull LitmusParser.SyncContext ctx);
	/**
	 * Enter a parse tree produced by {@link LitmusParser#registerPower}.
	 * @param ctx the parse tree
	 */
	void enterRegisterPower(@NotNull LitmusParser.RegisterPowerContext ctx);
	/**
	 * Exit a parse tree produced by {@link LitmusParser#registerPower}.
	 * @param ctx the parse tree
	 */
	void exitRegisterPower(@NotNull LitmusParser.RegisterPowerContext ctx);
	/**
	 * Enter a parse tree produced by {@link LitmusParser#inst}.
	 * @param ctx the parse tree
	 */
	void enterInst(@NotNull LitmusParser.InstContext ctx);
	/**
	 * Exit a parse tree produced by {@link LitmusParser#inst}.
	 * @param ctx the parse tree
	 */
	void exitInst(@NotNull LitmusParser.InstContext ctx);
	/**
	 * Enter a parse tree produced by {@link LitmusParser#isync}.
	 * @param ctx the parse tree
	 */
	void enterIsync(@NotNull LitmusParser.IsyncContext ctx);
	/**
	 * Exit a parse tree produced by {@link LitmusParser#isync}.
	 * @param ctx the parse tree
	 */
	void exitIsync(@NotNull LitmusParser.IsyncContext ctx);
	/**
	 * Enter a parse tree produced by {@link LitmusParser#location}.
	 * @param ctx the parse tree
	 */
	void enterLocation(@NotNull LitmusParser.LocationContext ctx);
	/**
	 * Exit a parse tree produced by {@link LitmusParser#location}.
	 * @param ctx the parse tree
	 */
	void exitLocation(@NotNull LitmusParser.LocationContext ctx);
	/**
	 * Enter a parse tree produced by {@link LitmusParser#xor}.
	 * @param ctx the parse tree
	 */
	void enterXor(@NotNull LitmusParser.XorContext ctx);
	/**
	 * Exit a parse tree produced by {@link LitmusParser#xor}.
	 * @param ctx the parse tree
	 */
	void exitXor(@NotNull LitmusParser.XorContext ctx);
	/**
	 * Enter a parse tree produced by {@link LitmusParser#storePower}.
	 * @param ctx the parse tree
	 */
	void enterStorePower(@NotNull LitmusParser.StorePowerContext ctx);
	/**
	 * Exit a parse tree produced by {@link LitmusParser#storePower}.
	 * @param ctx the parse tree
	 */
	void exitStorePower(@NotNull LitmusParser.StorePowerContext ctx);
	/**
	 * Enter a parse tree produced by {@link LitmusParser#text}.
	 * @param ctx the parse tree
	 */
	void enterText(@NotNull LitmusParser.TextContext ctx);
	/**
	 * Exit a parse tree produced by {@link LitmusParser#text}.
	 * @param ctx the parse tree
	 */
	void exitText(@NotNull LitmusParser.TextContext ctx);
	/**
	 * Enter a parse tree produced by {@link LitmusParser#word}.
	 * @param ctx the parse tree
	 */
	void enterWord(@NotNull LitmusParser.WordContext ctx);
	/**
	 * Exit a parse tree produced by {@link LitmusParser#word}.
	 * @param ctx the parse tree
	 */
	void exitWord(@NotNull LitmusParser.WordContext ctx);
	/**
	 * Enter a parse tree produced by {@link LitmusParser#cmpw}.
	 * @param ctx the parse tree
	 */
	void enterCmpw(@NotNull LitmusParser.CmpwContext ctx);
	/**
	 * Exit a parse tree produced by {@link LitmusParser#cmpw}.
	 * @param ctx the parse tree
	 */
	void exitCmpw(@NotNull LitmusParser.CmpwContext ctx);
}