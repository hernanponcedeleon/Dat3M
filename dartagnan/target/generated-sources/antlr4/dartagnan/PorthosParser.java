// Generated from Porthos.g4 by ANTLR 4.7

package dartagnan;
import dartagnan.program.*;
import dartagnan.expression.*;
import dartagnan.program.Thread;
import java.util.HashMap;
import java.util.Map;

import org.antlr.v4.runtime.atn.*;
import org.antlr.v4.runtime.dfa.DFA;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.misc.*;
import org.antlr.v4.runtime.tree.*;
import java.util.List;
import java.util.Iterator;
import java.util.ArrayList;

@SuppressWarnings({"all", "warnings", "unchecked", "unused", "cast"})
public class PorthosParser extends Parser {
	static { RuntimeMetaData.checkVersion("4.7", RuntimeMetaData.VERSION); }

	protected static final DFA[] _decisionToDFA;
	protected static final PredictionContextCache _sharedContextCache =
		new PredictionContextCache();
	public static final int
		T__0=1, T__1=2, T__2=3, T__3=4, T__4=5, T__5=6, T__6=7, T__7=8, T__8=9, 
		T__9=10, T__10=11, T__11=12, T__12=13, T__13=14, T__14=15, T__15=16, T__16=17, 
		T__17=18, T__18=19, T__19=20, T__20=21, T__21=22, T__22=23, T__23=24, 
		T__24=25, COMP_OP=26, ARITH_OP=27, BOOL_OP=28, DIGIT=29, WORD=30, LETTER=31, 
		WS=32, LPAR=33, RPAR=34, LCBRA=35, RCBRA=36, COMMA=37, POINT=38, EQ=39, 
		NEQ=40, LEQ=41, LT=42, GEQ=43, GT=44, ADD=45, SUB=46, MULT=47, DIV=48, 
		MOD=49, AND=50, OR=51, ATOMIC=52;
	public static final int
		RULE_arith_expr = 0, RULE_arith_atom = 1, RULE_arith_comp = 2, RULE_bool_expr = 3, 
		RULE_bool_atom = 4, RULE_location = 5, RULE_register = 6, RULE_local = 7, 
		RULE_load = 8, RULE_store = 9, RULE_read = 10, RULE_write = 11, RULE_fence = 12, 
		RULE_mfence = 13, RULE_sync = 14, RULE_lwsync = 15, RULE_isync = 16, RULE_inst = 17, 
		RULE_atom = 18, RULE_seq = 19, RULE_if1 = 20, RULE_if2 = 21, RULE_while_ = 22, 
		RULE_program = 23;
	public static final String[] ruleNames = {
		"arith_expr", "arith_atom", "arith_comp", "bool_expr", "bool_atom", "location", 
		"register", "local", "load", "store", "read", "write", "fence", "mfence", 
		"sync", "lwsync", "isync", "inst", "atom", "seq", "if1", "if2", "while_", 
		"program"
	};

	private static final String[] _LITERAL_NAMES = {
		null, "'True'", "'true'", "'False'", "'false'", "'H:'", "'<-'", "'<:-'", 
		"':='", "'='", "'load'", "'store'", "'mfence'", "'sync'", "'lwsync'", 
		"'isync'", "';'", "'if'", "'then'", "'else'", "'while'", "'['", "']'", 
		"'thread t'", "'exists'", "':'", null, null, null, null, null, null, null, 
		"'('", "')'", "'{'", "'}'", "','", "'.'", "'=='", "'!='", "'<='", "'<'", 
		"'>='", "'>'", "'+'", "'-'", "'*'", "'/'", "'%'", "'and'", "'or'"
	};
	private static final String[] _SYMBOLIC_NAMES = {
		null, null, null, null, null, null, null, null, null, null, null, null, 
		null, null, null, null, null, null, null, null, null, null, null, null, 
		null, null, "COMP_OP", "ARITH_OP", "BOOL_OP", "DIGIT", "WORD", "LETTER", 
		"WS", "LPAR", "RPAR", "LCBRA", "RCBRA", "COMMA", "POINT", "EQ", "NEQ", 
		"LEQ", "LT", "GEQ", "GT", "ADD", "SUB", "MULT", "DIV", "MOD", "AND", "OR", 
		"ATOMIC"
	};
	public static final Vocabulary VOCABULARY = new VocabularyImpl(_LITERAL_NAMES, _SYMBOLIC_NAMES);

	/**
	 * @deprecated Use {@link #VOCABULARY} instead.
	 */
	@Deprecated
	public static final String[] tokenNames;
	static {
		tokenNames = new String[_SYMBOLIC_NAMES.length];
		for (int i = 0; i < tokenNames.length; i++) {
			tokenNames[i] = VOCABULARY.getLiteralName(i);
			if (tokenNames[i] == null) {
				tokenNames[i] = VOCABULARY.getSymbolicName(i);
			}

			if (tokenNames[i] == null) {
				tokenNames[i] = "<INVALID>";
			}
		}
	}

	@Override
	@Deprecated
	public String[] getTokenNames() {
		return tokenNames;
	}

	@Override

	public Vocabulary getVocabulary() {
		return VOCABULARY;
	}

	@Override
	public String getGrammarFileName() { return "Porthos.g4"; }

	@Override
	public String[] getRuleNames() { return ruleNames; }

	@Override
	public String getSerializedATN() { return _serializedATN; }

	@Override
	public ATN getATN() { return _ATN; }


	private Map<String, Location> mapLocs = new HashMap<String, Location>();
	private Map<String, Map<String, Register>> mapRegs = new HashMap<String, Map<String, Register>>();	

	public PorthosParser(TokenStream input) {
		super(input);
		_interp = new ParserATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
	}
	public static class Arith_exprContext extends ParserRuleContext {
		public String mainThread;
		public AExpr expr;
		public Arith_atomContext e1;
		public Token op;
		public Arith_atomContext e2;
		public Arith_atomContext e;
		public List<Arith_atomContext> arith_atom() {
			return getRuleContexts(Arith_atomContext.class);
		}
		public Arith_atomContext arith_atom(int i) {
			return getRuleContext(Arith_atomContext.class,i);
		}
		public TerminalNode ARITH_OP() { return getToken(PorthosParser.ARITH_OP, 0); }
		public Arith_exprContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public Arith_exprContext(ParserRuleContext parent, int invokingState, String mainThread) {
			super(parent, invokingState);
			this.mainThread = mainThread;
		}
		@Override public int getRuleIndex() { return RULE_arith_expr; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof PorthosListener ) ((PorthosListener)listener).enterArith_expr(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof PorthosListener ) ((PorthosListener)listener).exitArith_expr(this);
		}
	}

	public final Arith_exprContext arith_expr(String mainThread) throws RecognitionException {
		Arith_exprContext _localctx = new Arith_exprContext(_ctx, getState(), mainThread);
		enterRule(_localctx, 0, RULE_arith_expr);
		try {
			setState(57);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,0,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				}
				break;
			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(49);
				((Arith_exprContext)_localctx).e1 = arith_atom(mainThread);
				setState(50);
				((Arith_exprContext)_localctx).op = match(ARITH_OP);
				setState(51);
				((Arith_exprContext)_localctx).e2 = arith_atom(mainThread);

						((Arith_exprContext)_localctx).expr =  new AExpr(((Arith_exprContext)_localctx).e1.expr, ((Arith_exprContext)_localctx).op.getText(), ((Arith_exprContext)_localctx).e2.expr);
					
				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(54);
				((Arith_exprContext)_localctx).e = arith_atom(mainThread);

						((Arith_exprContext)_localctx).expr =  ((Arith_exprContext)_localctx).e.expr;
					
				}
				break;
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class Arith_atomContext extends ParserRuleContext {
		public String mainThread;
		public AExpr expr;
		public Token num;
		public RegisterContext r;
		public Arith_exprContext e;
		public TerminalNode DIGIT() { return getToken(PorthosParser.DIGIT, 0); }
		public RegisterContext register() {
			return getRuleContext(RegisterContext.class,0);
		}
		public TerminalNode LPAR() { return getToken(PorthosParser.LPAR, 0); }
		public TerminalNode RPAR() { return getToken(PorthosParser.RPAR, 0); }
		public Arith_exprContext arith_expr() {
			return getRuleContext(Arith_exprContext.class,0);
		}
		public Arith_atomContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public Arith_atomContext(ParserRuleContext parent, int invokingState, String mainThread) {
			super(parent, invokingState);
			this.mainThread = mainThread;
		}
		@Override public int getRuleIndex() { return RULE_arith_atom; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof PorthosListener ) ((PorthosListener)listener).enterArith_atom(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof PorthosListener ) ((PorthosListener)listener).exitArith_atom(this);
		}
	}

	public final Arith_atomContext arith_atom(String mainThread) throws RecognitionException {
		Arith_atomContext _localctx = new Arith_atomContext(_ctx, getState(), mainThread);
		enterRule(_localctx, 2, RULE_arith_atom);
		try {
			setState(70);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case T__15:
			case COMP_OP:
			case ARITH_OP:
			case RPAR:
			case RCBRA:
				enterOuterAlt(_localctx, 1);
				{
				}
				break;
			case DIGIT:
				enterOuterAlt(_localctx, 2);
				{
				setState(60);
				((Arith_atomContext)_localctx).num = match(DIGIT);
				((Arith_atomContext)_localctx).expr =  new AConst(Integer.parseInt(((Arith_atomContext)_localctx).num.getText()));
				}
				break;
			case WORD:
				enterOuterAlt(_localctx, 3);
				{
				setState(62);
				((Arith_atomContext)_localctx).r = register();

						Map<String, Register> mapThreadRegs = mapRegs.get(mainThread);
						((Arith_atomContext)_localctx).expr =  mapThreadRegs.get(((Arith_atomContext)_localctx).r.reg.getName());
					
				}
				break;
			case LPAR:
				enterOuterAlt(_localctx, 4);
				{
				setState(65);
				match(LPAR);
				setState(66);
				((Arith_atomContext)_localctx).e = arith_expr(mainThread);
				setState(67);
				match(RPAR);

						((Arith_atomContext)_localctx).expr =  ((Arith_atomContext)_localctx).e.expr;
					
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class Arith_compContext extends ParserRuleContext {
		public String mainThread;
		public BExpr expr;
		public Arith_exprContext a1;
		public Token op;
		public Arith_exprContext a2;
		public TerminalNode LPAR() { return getToken(PorthosParser.LPAR, 0); }
		public TerminalNode RPAR() { return getToken(PorthosParser.RPAR, 0); }
		public List<Arith_exprContext> arith_expr() {
			return getRuleContexts(Arith_exprContext.class);
		}
		public Arith_exprContext arith_expr(int i) {
			return getRuleContext(Arith_exprContext.class,i);
		}
		public TerminalNode COMP_OP() { return getToken(PorthosParser.COMP_OP, 0); }
		public Arith_compContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public Arith_compContext(ParserRuleContext parent, int invokingState, String mainThread) {
			super(parent, invokingState);
			this.mainThread = mainThread;
		}
		@Override public int getRuleIndex() { return RULE_arith_comp; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof PorthosListener ) ((PorthosListener)listener).enterArith_comp(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof PorthosListener ) ((PorthosListener)listener).exitArith_comp(this);
		}
	}

	public final Arith_compContext arith_comp(String mainThread) throws RecognitionException {
		Arith_compContext _localctx = new Arith_compContext(_ctx, getState(), mainThread);
		enterRule(_localctx, 4, RULE_arith_comp);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(72);
			match(LPAR);
			setState(73);
			((Arith_compContext)_localctx).a1 = arith_expr(mainThread);
			setState(74);
			((Arith_compContext)_localctx).op = match(COMP_OP);
			setState(75);
			((Arith_compContext)_localctx).a2 = arith_expr(mainThread);
			setState(76);
			match(RPAR);

					((Arith_compContext)_localctx).expr =  new Atom(((Arith_compContext)_localctx).a1.expr, ((Arith_compContext)_localctx).op.getText(), ((Arith_compContext)_localctx).a2.expr);
				
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class Bool_exprContext extends ParserRuleContext {
		public String mainThread;
		public BExpr expr;
		public Bool_atomContext b;
		public Bool_atomContext b1;
		public Token op;
		public Bool_atomContext b2;
		public List<Bool_atomContext> bool_atom() {
			return getRuleContexts(Bool_atomContext.class);
		}
		public Bool_atomContext bool_atom(int i) {
			return getRuleContext(Bool_atomContext.class,i);
		}
		public TerminalNode BOOL_OP() { return getToken(PorthosParser.BOOL_OP, 0); }
		public Bool_exprContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public Bool_exprContext(ParserRuleContext parent, int invokingState, String mainThread) {
			super(parent, invokingState);
			this.mainThread = mainThread;
		}
		@Override public int getRuleIndex() { return RULE_bool_expr; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof PorthosListener ) ((PorthosListener)listener).enterBool_expr(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof PorthosListener ) ((PorthosListener)listener).exitBool_expr(this);
		}
	}

	public final Bool_exprContext bool_expr(String mainThread) throws RecognitionException {
		Bool_exprContext _localctx = new Bool_exprContext(_ctx, getState(), mainThread);
		enterRule(_localctx, 6, RULE_bool_expr);
		try {
			setState(88);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,2,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				}
				break;
			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(80);
				((Bool_exprContext)_localctx).b = bool_atom(mainThread);
				((Bool_exprContext)_localctx).expr =  ((Bool_exprContext)_localctx).b.expr;
				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(83);
				((Bool_exprContext)_localctx).b1 = bool_atom(mainThread);
				setState(84);
				((Bool_exprContext)_localctx).op = match(BOOL_OP);
				setState(85);
				((Bool_exprContext)_localctx).b2 = bool_atom(mainThread);

						((Bool_exprContext)_localctx).expr =  new BExpr(((Bool_exprContext)_localctx).b1.expr, ((Bool_exprContext)_localctx).op.getText(), ((Bool_exprContext)_localctx).b2.expr);
					
				}
				break;
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class Bool_atomContext extends ParserRuleContext {
		public String mainThread;
		public BExpr expr;
		public Arith_compContext ae;
		public Bool_exprContext be;
		public Arith_compContext arith_comp() {
			return getRuleContext(Arith_compContext.class,0);
		}
		public TerminalNode LPAR() { return getToken(PorthosParser.LPAR, 0); }
		public TerminalNode RPAR() { return getToken(PorthosParser.RPAR, 0); }
		public Bool_exprContext bool_expr() {
			return getRuleContext(Bool_exprContext.class,0);
		}
		public Bool_atomContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public Bool_atomContext(ParserRuleContext parent, int invokingState, String mainThread) {
			super(parent, invokingState);
			this.mainThread = mainThread;
		}
		@Override public int getRuleIndex() { return RULE_bool_atom; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof PorthosListener ) ((PorthosListener)listener).enterBool_atom(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof PorthosListener ) ((PorthosListener)listener).exitBool_atom(this);
		}
	}

	public final Bool_atomContext bool_atom(String mainThread) throws RecognitionException {
		Bool_atomContext _localctx = new Bool_atomContext(_ctx, getState(), mainThread);
		enterRule(_localctx, 8, RULE_bool_atom);
		int _la;
		try {
			setState(103);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,3,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				}
				break;
			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(91);
				_la = _input.LA(1);
				if ( !(_la==T__0 || _la==T__1) ) {
				_errHandler.recoverInline(this);
				}
				else {
					if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
					_errHandler.reportMatch(this);
					consume();
				}
				((Bool_atomContext)_localctx).expr =  new BConst(true);
				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(93);
				_la = _input.LA(1);
				if ( !(_la==T__2 || _la==T__3) ) {
				_errHandler.recoverInline(this);
				}
				else {
					if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
					_errHandler.reportMatch(this);
					consume();
				}
				((Bool_atomContext)_localctx).expr =  new BConst(false);
				}
				break;
			case 4:
				enterOuterAlt(_localctx, 4);
				{
				setState(95);
				((Bool_atomContext)_localctx).ae = arith_comp(mainThread);
				((Bool_atomContext)_localctx).expr =  ((Bool_atomContext)_localctx).ae.expr;
				}
				break;
			case 5:
				enterOuterAlt(_localctx, 5);
				{
				setState(98);
				match(LPAR);
				setState(99);
				((Bool_atomContext)_localctx).be = bool_expr(mainThread);
				setState(100);
				match(RPAR);
				((Bool_atomContext)_localctx).expr =  ((Bool_atomContext)_localctx).be.expr;
				}
				break;
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class LocationContext extends ParserRuleContext {
		public Location loc;
		public Token hl;
		public Token l;
		public TerminalNode WORD() { return getToken(PorthosParser.WORD, 0); }
		public LocationContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_location; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof PorthosListener ) ((PorthosListener)listener).enterLocation(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof PorthosListener ) ((PorthosListener)listener).exitLocation(this);
		}
	}

	public final LocationContext location() throws RecognitionException {
		LocationContext _localctx = new LocationContext(_ctx, getState());
		enterRule(_localctx, 10, RULE_location);
		try {
			setState(111);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case T__7:
			case T__8:
			case T__15:
			case RCBRA:
			case COMMA:
			case POINT:
				enterOuterAlt(_localctx, 1);
				{
				}
				break;
			case T__4:
				enterOuterAlt(_localctx, 2);
				{
				setState(106);
				match(T__4);
				setState(107);
				((LocationContext)_localctx).hl = match(WORD);
				((LocationContext)_localctx).loc =  new HighLocation(((LocationContext)_localctx).hl.getText());
				}
				break;
			case WORD:
				enterOuterAlt(_localctx, 3);
				{
				setState(109);
				((LocationContext)_localctx).l = match(WORD);
				((LocationContext)_localctx).loc =  new Location(((LocationContext)_localctx).l.getText());
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class RegisterContext extends ParserRuleContext {
		public Register reg;
		public Token r;
		public TerminalNode WORD() { return getToken(PorthosParser.WORD, 0); }
		public RegisterContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_register; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof PorthosListener ) ((PorthosListener)listener).enterRegister(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof PorthosListener ) ((PorthosListener)listener).exitRegister(this);
		}
	}

	public final RegisterContext register() throws RecognitionException {
		RegisterContext _localctx = new RegisterContext(_ctx, getState());
		enterRule(_localctx, 12, RULE_register);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(113);
			((RegisterContext)_localctx).r = match(WORD);

					if(mapLocs.keySet().contains(((RegisterContext)_localctx).r.getText())) {
						System.out.println("WARNING: " + ((RegisterContext)_localctx).r.getText() + " is both a global and local variable");
					};
					((RegisterContext)_localctx).reg =  new Register(((RegisterContext)_localctx).r.getText());
				
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class LocalContext extends ParserRuleContext {
		public String mainThread;
		public Thread t;
		public RegisterContext r;
		public Arith_exprContext e;
		public RegisterContext register() {
			return getRuleContext(RegisterContext.class,0);
		}
		public Arith_exprContext arith_expr() {
			return getRuleContext(Arith_exprContext.class,0);
		}
		public LocalContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public LocalContext(ParserRuleContext parent, int invokingState, String mainThread) {
			super(parent, invokingState);
			this.mainThread = mainThread;
		}
		@Override public int getRuleIndex() { return RULE_local; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof PorthosListener ) ((PorthosListener)listener).enterLocal(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof PorthosListener ) ((PorthosListener)listener).exitLocal(this);
		}
	}

	public final LocalContext local(String mainThread) throws RecognitionException {
		LocalContext _localctx = new LocalContext(_ctx, getState(), mainThread);
		enterRule(_localctx, 14, RULE_local);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(116);
			((LocalContext)_localctx).r = register();
			setState(117);
			match(T__5);
			setState(118);
			((LocalContext)_localctx).e = arith_expr(mainThread);

					Map<String, Register> mapThreadRegs = mapRegs.get(mainThread);
					if(!(mapThreadRegs.keySet().contains(((LocalContext)_localctx).r.reg.getName()))) {
						mapThreadRegs.put(((LocalContext)_localctx).r.reg.getName(), ((LocalContext)_localctx).r.reg);
					}
					Register pointerReg = mapThreadRegs.get(((LocalContext)_localctx).r.reg.getName());
					((LocalContext)_localctx).t =  new Local(pointerReg, ((LocalContext)_localctx).e.expr);
				
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class LoadContext extends ParserRuleContext {
		public String mainThread;
		public Thread t;
		public RegisterContext r;
		public LocationContext l;
		public RegisterContext register() {
			return getRuleContext(RegisterContext.class,0);
		}
		public LocationContext location() {
			return getRuleContext(LocationContext.class,0);
		}
		public LoadContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public LoadContext(ParserRuleContext parent, int invokingState, String mainThread) {
			super(parent, invokingState);
			this.mainThread = mainThread;
		}
		@Override public int getRuleIndex() { return RULE_load; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof PorthosListener ) ((PorthosListener)listener).enterLoad(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof PorthosListener ) ((PorthosListener)listener).exitLoad(this);
		}
	}

	public final LoadContext load(String mainThread) throws RecognitionException {
		LoadContext _localctx = new LoadContext(_ctx, getState(), mainThread);
		enterRule(_localctx, 16, RULE_load);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(121);
			((LoadContext)_localctx).r = register();
			setState(122);
			match(T__6);
			setState(123);
			((LoadContext)_localctx).l = location();

					Map<String, Register> mapThreadRegs = mapRegs.get(mainThread);
					if(!(mapThreadRegs.keySet().contains(((LoadContext)_localctx).r.reg.getName()))) {
						mapThreadRegs.put(((LoadContext)_localctx).r.reg.getName(), ((LoadContext)_localctx).r.reg);
					}
					if(!(mapLocs.keySet().contains(((LoadContext)_localctx).l.loc.getName()))) {
						System.out.println(String.format("Location %s must be initialized", ((LoadContext)_localctx).l.loc.getName()));
					}
					Register pointerReg = mapThreadRegs.get(((LoadContext)_localctx).r.reg.getName());
					Location pointerLoc = mapLocs.get(((LoadContext)_localctx).l.loc.getName());
					((LoadContext)_localctx).t =  new Load(pointerReg, pointerLoc);
				
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class StoreContext extends ParserRuleContext {
		public String mainThread;
		public Thread t;
		public LocationContext l;
		public RegisterContext r;
		public LocationContext location() {
			return getRuleContext(LocationContext.class,0);
		}
		public RegisterContext register() {
			return getRuleContext(RegisterContext.class,0);
		}
		public StoreContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public StoreContext(ParserRuleContext parent, int invokingState, String mainThread) {
			super(parent, invokingState);
			this.mainThread = mainThread;
		}
		@Override public int getRuleIndex() { return RULE_store; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof PorthosListener ) ((PorthosListener)listener).enterStore(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof PorthosListener ) ((PorthosListener)listener).exitStore(this);
		}
	}

	public final StoreContext store(String mainThread) throws RecognitionException {
		StoreContext _localctx = new StoreContext(_ctx, getState(), mainThread);
		enterRule(_localctx, 18, RULE_store);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(126);
			((StoreContext)_localctx).l = location();
			setState(127);
			match(T__7);
			setState(128);
			((StoreContext)_localctx).r = register();

					if(!(mapLocs.keySet().contains(((StoreContext)_localctx).l.loc.getName()))) {
						System.out.println(String.format("Location %s must be initialized", ((StoreContext)_localctx).l.loc.getName()));
					}
					Map<String, Register> mapThreadRegs = mapRegs.get(mainThread);
					if(!(mapThreadRegs.keySet().contains(((StoreContext)_localctx).r.reg.getName()))) {
						System.out.println(String.format("Register %s must be initialized", ((StoreContext)_localctx).r.reg.getName()));
					}
					Register pointerReg = mapThreadRegs.get(((StoreContext)_localctx).r.reg.getName());
					Location pointerLoc = mapLocs.get(((StoreContext)_localctx).l.loc.getName());
					((StoreContext)_localctx).t =  new Store(pointerLoc, pointerReg);
				
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ReadContext extends ParserRuleContext {
		public String mainThread;
		public Thread t;
		public RegisterContext r;
		public LocationContext l;
		public Token at;
		public TerminalNode POINT() { return getToken(PorthosParser.POINT, 0); }
		public TerminalNode LPAR() { return getToken(PorthosParser.LPAR, 0); }
		public TerminalNode RPAR() { return getToken(PorthosParser.RPAR, 0); }
		public RegisterContext register() {
			return getRuleContext(RegisterContext.class,0);
		}
		public LocationContext location() {
			return getRuleContext(LocationContext.class,0);
		}
		public TerminalNode ATOMIC() { return getToken(PorthosParser.ATOMIC, 0); }
		public ReadContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public ReadContext(ParserRuleContext parent, int invokingState, String mainThread) {
			super(parent, invokingState);
			this.mainThread = mainThread;
		}
		@Override public int getRuleIndex() { return RULE_read; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof PorthosListener ) ((PorthosListener)listener).enterRead(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof PorthosListener ) ((PorthosListener)listener).exitRead(this);
		}
	}

	public final ReadContext read(String mainThread) throws RecognitionException {
		ReadContext _localctx = new ReadContext(_ctx, getState(), mainThread);
		enterRule(_localctx, 20, RULE_read);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(131);
			((ReadContext)_localctx).r = register();
			setState(132);
			match(T__8);
			setState(133);
			((ReadContext)_localctx).l = location();
			setState(134);
			match(POINT);
			setState(135);
			match(T__9);
			setState(136);
			match(LPAR);
			setState(137);
			((ReadContext)_localctx).at = match(ATOMIC);
			setState(138);
			match(RPAR);

					Map<String, Register> mapThreadRegs = mapRegs.get(mainThread);
					if(!(mapThreadRegs.keySet().contains(((ReadContext)_localctx).r.reg.getName()))) {
						mapThreadRegs.put(((ReadContext)_localctx).r.reg.getName(), ((ReadContext)_localctx).r.reg);
					}
					if(!(mapLocs.keySet().contains(((ReadContext)_localctx).l.loc.getName()))) {
						System.out.println(String.format("Location %s must be initialized", ((ReadContext)_localctx).l.loc.getName()));
					}
					Register pointerReg = mapThreadRegs.get(((ReadContext)_localctx).r.reg.getName());
					Location pointerLoc = mapLocs.get(((ReadContext)_localctx).l.loc.getName());
					((ReadContext)_localctx).t =  new Read(pointerReg, pointerLoc, ((ReadContext)_localctx).at.getText());
				
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class WriteContext extends ParserRuleContext {
		public String mainThread;
		public Thread t;
		public LocationContext l;
		public Token at;
		public RegisterContext r;
		public TerminalNode POINT() { return getToken(PorthosParser.POINT, 0); }
		public TerminalNode LPAR() { return getToken(PorthosParser.LPAR, 0); }
		public TerminalNode COMMA() { return getToken(PorthosParser.COMMA, 0); }
		public TerminalNode RPAR() { return getToken(PorthosParser.RPAR, 0); }
		public LocationContext location() {
			return getRuleContext(LocationContext.class,0);
		}
		public TerminalNode ATOMIC() { return getToken(PorthosParser.ATOMIC, 0); }
		public RegisterContext register() {
			return getRuleContext(RegisterContext.class,0);
		}
		public WriteContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public WriteContext(ParserRuleContext parent, int invokingState, String mainThread) {
			super(parent, invokingState);
			this.mainThread = mainThread;
		}
		@Override public int getRuleIndex() { return RULE_write; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof PorthosListener ) ((PorthosListener)listener).enterWrite(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof PorthosListener ) ((PorthosListener)listener).exitWrite(this);
		}
	}

	public final WriteContext write(String mainThread) throws RecognitionException {
		WriteContext _localctx = new WriteContext(_ctx, getState(), mainThread);
		enterRule(_localctx, 22, RULE_write);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(141);
			((WriteContext)_localctx).l = location();
			setState(142);
			match(POINT);
			setState(143);
			match(T__10);
			setState(144);
			match(LPAR);
			setState(145);
			((WriteContext)_localctx).at = match(ATOMIC);
			setState(146);
			match(COMMA);
			setState(147);
			((WriteContext)_localctx).r = register();
			setState(148);
			match(RPAR);

					if(!(mapLocs.keySet().contains(((WriteContext)_localctx).l.loc.getName()))) {
						System.out.println(String.format("Location %s must be initialized", ((WriteContext)_localctx).l.loc.getName()));
					}
					Map<String, Register> mapThreadRegs = mapRegs.get(mainThread);
					if(!(mapThreadRegs.keySet().contains(((WriteContext)_localctx).r.reg.getName()))) {
						System.out.println(String.format("Register %s must be initialized", ((WriteContext)_localctx).r.reg.getName()));
					}
					Register pointerReg = mapThreadRegs.get(((WriteContext)_localctx).r.reg.getName());
					Location pointerLoc = mapLocs.get(((WriteContext)_localctx).l.loc.getName());
					((WriteContext)_localctx).t =  new Write(pointerLoc, pointerReg, ((WriteContext)_localctx).at.getText());
				
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class FenceContext extends ParserRuleContext {
		public Thread t;
		public MfenceContext mfence() {
			return getRuleContext(MfenceContext.class,0);
		}
		public SyncContext sync() {
			return getRuleContext(SyncContext.class,0);
		}
		public LwsyncContext lwsync() {
			return getRuleContext(LwsyncContext.class,0);
		}
		public IsyncContext isync() {
			return getRuleContext(IsyncContext.class,0);
		}
		public FenceContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_fence; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof PorthosListener ) ((PorthosListener)listener).enterFence(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof PorthosListener ) ((PorthosListener)listener).exitFence(this);
		}
	}

	public final FenceContext fence() throws RecognitionException {
		FenceContext _localctx = new FenceContext(_ctx, getState());
		enterRule(_localctx, 24, RULE_fence);
		try {
			setState(164);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case T__15:
			case RCBRA:
				enterOuterAlt(_localctx, 1);
				{
				}
				break;
			case T__11:
				enterOuterAlt(_localctx, 2);
				{
				setState(152);
				mfence();
				((FenceContext)_localctx).t =  new Mfence();
				}
				break;
			case T__12:
				enterOuterAlt(_localctx, 3);
				{
				setState(155);
				sync();
				((FenceContext)_localctx).t =  new Sync();
				}
				break;
			case T__13:
				enterOuterAlt(_localctx, 4);
				{
				setState(158);
				lwsync();
				((FenceContext)_localctx).t =  new Lwsync();
				}
				break;
			case T__14:
				enterOuterAlt(_localctx, 5);
				{
				setState(161);
				isync();
				((FenceContext)_localctx).t =  new Isync();
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class MfenceContext extends ParserRuleContext {
		public MfenceContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_mfence; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof PorthosListener ) ((PorthosListener)listener).enterMfence(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof PorthosListener ) ((PorthosListener)listener).exitMfence(this);
		}
	}

	public final MfenceContext mfence() throws RecognitionException {
		MfenceContext _localctx = new MfenceContext(_ctx, getState());
		enterRule(_localctx, 26, RULE_mfence);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(166);
			match(T__11);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class SyncContext extends ParserRuleContext {
		public SyncContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_sync; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof PorthosListener ) ((PorthosListener)listener).enterSync(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof PorthosListener ) ((PorthosListener)listener).exitSync(this);
		}
	}

	public final SyncContext sync() throws RecognitionException {
		SyncContext _localctx = new SyncContext(_ctx, getState());
		enterRule(_localctx, 28, RULE_sync);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(168);
			match(T__12);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class LwsyncContext extends ParserRuleContext {
		public LwsyncContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_lwsync; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof PorthosListener ) ((PorthosListener)listener).enterLwsync(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof PorthosListener ) ((PorthosListener)listener).exitLwsync(this);
		}
	}

	public final LwsyncContext lwsync() throws RecognitionException {
		LwsyncContext _localctx = new LwsyncContext(_ctx, getState());
		enterRule(_localctx, 30, RULE_lwsync);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(170);
			match(T__13);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class IsyncContext extends ParserRuleContext {
		public IsyncContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_isync; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof PorthosListener ) ((PorthosListener)listener).enterIsync(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof PorthosListener ) ((PorthosListener)listener).exitIsync(this);
		}
	}

	public final IsyncContext isync() throws RecognitionException {
		IsyncContext _localctx = new IsyncContext(_ctx, getState());
		enterRule(_localctx, 32, RULE_isync);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(172);
			match(T__14);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class InstContext extends ParserRuleContext {
		public String mainThread;
		public Thread t;
		public AtomContext t1;
		public SeqContext t2;
		public While_Context t3;
		public If1Context t4;
		public If2Context t5;
		public AtomContext atom() {
			return getRuleContext(AtomContext.class,0);
		}
		public SeqContext seq() {
			return getRuleContext(SeqContext.class,0);
		}
		public While_Context while_() {
			return getRuleContext(While_Context.class,0);
		}
		public If1Context if1() {
			return getRuleContext(If1Context.class,0);
		}
		public If2Context if2() {
			return getRuleContext(If2Context.class,0);
		}
		public InstContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public InstContext(ParserRuleContext parent, int invokingState, String mainThread) {
			super(parent, invokingState);
			this.mainThread = mainThread;
		}
		@Override public int getRuleIndex() { return RULE_inst; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof PorthosListener ) ((PorthosListener)listener).enterInst(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof PorthosListener ) ((PorthosListener)listener).exitInst(this);
		}
	}

	public final InstContext inst(String mainThread) throws RecognitionException {
		InstContext _localctx = new InstContext(_ctx, getState(), mainThread);
		enterRule(_localctx, 34, RULE_inst);
		try {
			setState(190);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,6,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				}
				break;
			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(175);
				((InstContext)_localctx).t1 = atom(mainThread);
				((InstContext)_localctx).t =  ((InstContext)_localctx).t1.t;
				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(178);
				((InstContext)_localctx).t2 = seq(mainThread);
				((InstContext)_localctx).t =  ((InstContext)_localctx).t2.t;
				}
				break;
			case 4:
				enterOuterAlt(_localctx, 4);
				{
				setState(181);
				((InstContext)_localctx).t3 = while_(mainThread);
				((InstContext)_localctx).t =  ((InstContext)_localctx).t3.t;
				}
				break;
			case 5:
				enterOuterAlt(_localctx, 5);
				{
				setState(184);
				((InstContext)_localctx).t4 = if1(mainThread);
				((InstContext)_localctx).t =  ((InstContext)_localctx).t4.t;
				}
				break;
			case 6:
				enterOuterAlt(_localctx, 6);
				{
				setState(187);
				((InstContext)_localctx).t5 = if2(mainThread);
				((InstContext)_localctx).t =  ((InstContext)_localctx).t5.t;
				}
				break;
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class AtomContext extends ParserRuleContext {
		public String mainThread;
		public Thread t;
		public LocalContext t1;
		public LoadContext t2;
		public StoreContext t3;
		public FenceContext t4;
		public ReadContext t5;
		public WriteContext t6;
		public LocalContext local() {
			return getRuleContext(LocalContext.class,0);
		}
		public LoadContext load() {
			return getRuleContext(LoadContext.class,0);
		}
		public StoreContext store() {
			return getRuleContext(StoreContext.class,0);
		}
		public FenceContext fence() {
			return getRuleContext(FenceContext.class,0);
		}
		public ReadContext read() {
			return getRuleContext(ReadContext.class,0);
		}
		public WriteContext write() {
			return getRuleContext(WriteContext.class,0);
		}
		public AtomContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public AtomContext(ParserRuleContext parent, int invokingState, String mainThread) {
			super(parent, invokingState);
			this.mainThread = mainThread;
		}
		@Override public int getRuleIndex() { return RULE_atom; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof PorthosListener ) ((PorthosListener)listener).enterAtom(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof PorthosListener ) ((PorthosListener)listener).exitAtom(this);
		}
	}

	public final AtomContext atom(String mainThread) throws RecognitionException {
		AtomContext _localctx = new AtomContext(_ctx, getState(), mainThread);
		enterRule(_localctx, 36, RULE_atom);
		try {
			setState(211);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,7,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				}
				break;
			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(193);
				((AtomContext)_localctx).t1 = local(mainThread);
				((AtomContext)_localctx).t =  ((AtomContext)_localctx).t1.t;
				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(196);
				((AtomContext)_localctx).t2 = load(mainThread);
				((AtomContext)_localctx).t =  ((AtomContext)_localctx).t2.t;
				}
				break;
			case 4:
				enterOuterAlt(_localctx, 4);
				{
				setState(199);
				((AtomContext)_localctx).t3 = store(mainThread);
				((AtomContext)_localctx).t =  ((AtomContext)_localctx).t3.t;
				}
				break;
			case 5:
				enterOuterAlt(_localctx, 5);
				{
				setState(202);
				((AtomContext)_localctx).t4 = fence();
				((AtomContext)_localctx).t =  ((AtomContext)_localctx).t4.t;
				}
				break;
			case 6:
				enterOuterAlt(_localctx, 6);
				{
				setState(205);
				((AtomContext)_localctx).t5 = read(mainThread);
				((AtomContext)_localctx).t =  ((AtomContext)_localctx).t5.t;
				}
				break;
			case 7:
				enterOuterAlt(_localctx, 7);
				{
				setState(208);
				((AtomContext)_localctx).t6 = write(mainThread);
				((AtomContext)_localctx).t =  ((AtomContext)_localctx).t6.t;
				}
				break;
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class SeqContext extends ParserRuleContext {
		public String mainThread;
		public Thread t;
		public AtomContext t1;
		public InstContext t2;
		public While_Context t3;
		public InstContext t4;
		public If1Context t5;
		public InstContext t6;
		public If2Context t7;
		public InstContext t8;
		public AtomContext atom() {
			return getRuleContext(AtomContext.class,0);
		}
		public InstContext inst() {
			return getRuleContext(InstContext.class,0);
		}
		public While_Context while_() {
			return getRuleContext(While_Context.class,0);
		}
		public If1Context if1() {
			return getRuleContext(If1Context.class,0);
		}
		public If2Context if2() {
			return getRuleContext(If2Context.class,0);
		}
		public SeqContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public SeqContext(ParserRuleContext parent, int invokingState, String mainThread) {
			super(parent, invokingState);
			this.mainThread = mainThread;
		}
		@Override public int getRuleIndex() { return RULE_seq; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof PorthosListener ) ((PorthosListener)listener).enterSeq(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof PorthosListener ) ((PorthosListener)listener).exitSeq(this);
		}
	}

	public final SeqContext seq(String mainThread) throws RecognitionException {
		SeqContext _localctx = new SeqContext(_ctx, getState(), mainThread);
		enterRule(_localctx, 38, RULE_seq);
		try {
			setState(234);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,8,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				}
				break;
			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(214);
				((SeqContext)_localctx).t1 = atom(mainThread);
				setState(215);
				match(T__15);
				setState(216);
				((SeqContext)_localctx).t2 = inst(mainThread);
				((SeqContext)_localctx).t =  new Seq(((SeqContext)_localctx).t1.t, ((SeqContext)_localctx).t2.t);
				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(219);
				((SeqContext)_localctx).t3 = while_(mainThread);
				setState(220);
				match(T__15);
				setState(221);
				((SeqContext)_localctx).t4 = inst(mainThread);
				((SeqContext)_localctx).t =  new Seq(((SeqContext)_localctx).t3.t, ((SeqContext)_localctx).t4.t);
				}
				break;
			case 4:
				enterOuterAlt(_localctx, 4);
				{
				setState(224);
				((SeqContext)_localctx).t5 = if1(mainThread);
				setState(225);
				match(T__15);
				setState(226);
				((SeqContext)_localctx).t6 = inst(mainThread);
				((SeqContext)_localctx).t =  new Seq(((SeqContext)_localctx).t5.t, ((SeqContext)_localctx).t6.t);
				}
				break;
			case 5:
				enterOuterAlt(_localctx, 5);
				{
				setState(229);
				((SeqContext)_localctx).t7 = if2(mainThread);
				setState(230);
				match(T__15);
				setState(231);
				((SeqContext)_localctx).t8 = inst(mainThread);
				((SeqContext)_localctx).t =  new Seq(((SeqContext)_localctx).t7.t, ((SeqContext)_localctx).t8.t);
				}
				break;
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class If1Context extends ParserRuleContext {
		public String mainThread;
		public Thread t;
		public Bool_exprContext b;
		public InstContext t1;
		public InstContext t2;
		public List<TerminalNode> LCBRA() { return getTokens(PorthosParser.LCBRA); }
		public TerminalNode LCBRA(int i) {
			return getToken(PorthosParser.LCBRA, i);
		}
		public List<TerminalNode> RCBRA() { return getTokens(PorthosParser.RCBRA); }
		public TerminalNode RCBRA(int i) {
			return getToken(PorthosParser.RCBRA, i);
		}
		public Bool_exprContext bool_expr() {
			return getRuleContext(Bool_exprContext.class,0);
		}
		public List<InstContext> inst() {
			return getRuleContexts(InstContext.class);
		}
		public InstContext inst(int i) {
			return getRuleContext(InstContext.class,i);
		}
		public If1Context(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public If1Context(ParserRuleContext parent, int invokingState, String mainThread) {
			super(parent, invokingState);
			this.mainThread = mainThread;
		}
		@Override public int getRuleIndex() { return RULE_if1; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof PorthosListener ) ((PorthosListener)listener).enterIf1(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof PorthosListener ) ((PorthosListener)listener).exitIf1(this);
		}
	}

	public final If1Context if1(String mainThread) throws RecognitionException {
		If1Context _localctx = new If1Context(_ctx, getState(), mainThread);
		enterRule(_localctx, 40, RULE_if1);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(236);
			match(T__16);
			setState(237);
			((If1Context)_localctx).b = bool_expr(mainThread);
			setState(241);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==T__17) {
				{
				{
				setState(238);
				match(T__17);
				}
				}
				setState(243);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(244);
			match(LCBRA);
			setState(245);
			((If1Context)_localctx).t1 = inst(mainThread);
			setState(246);
			match(RCBRA);
			setState(247);
			match(T__18);
			setState(248);
			match(LCBRA);
			setState(249);
			((If1Context)_localctx).t2 = inst(mainThread);
			setState(250);
			match(RCBRA);

					((If1Context)_localctx).t =  new If(((If1Context)_localctx).b.expr, ((If1Context)_localctx).t1.t, ((If1Context)_localctx).t2.t);
				
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class If2Context extends ParserRuleContext {
		public String mainThread;
		public Thread t;
		public Bool_exprContext b;
		public InstContext t1;
		public TerminalNode LCBRA() { return getToken(PorthosParser.LCBRA, 0); }
		public TerminalNode RCBRA() { return getToken(PorthosParser.RCBRA, 0); }
		public Bool_exprContext bool_expr() {
			return getRuleContext(Bool_exprContext.class,0);
		}
		public InstContext inst() {
			return getRuleContext(InstContext.class,0);
		}
		public If2Context(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public If2Context(ParserRuleContext parent, int invokingState, String mainThread) {
			super(parent, invokingState);
			this.mainThread = mainThread;
		}
		@Override public int getRuleIndex() { return RULE_if2; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof PorthosListener ) ((PorthosListener)listener).enterIf2(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof PorthosListener ) ((PorthosListener)listener).exitIf2(this);
		}
	}

	public final If2Context if2(String mainThread) throws RecognitionException {
		If2Context _localctx = new If2Context(_ctx, getState(), mainThread);
		enterRule(_localctx, 42, RULE_if2);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(253);
			match(T__16);
			setState(254);
			((If2Context)_localctx).b = bool_expr(mainThread);
			setState(258);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==T__17) {
				{
				{
				setState(255);
				match(T__17);
				}
				}
				setState(260);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(261);
			match(LCBRA);
			setState(262);
			((If2Context)_localctx).t1 = inst(mainThread);
			setState(263);
			match(RCBRA);

					((If2Context)_localctx).t =  new If(((If2Context)_localctx).b.expr, ((If2Context)_localctx).t1.t, new Skip());
				
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class While_Context extends ParserRuleContext {
		public String mainThread;
		public Thread t;
		public Bool_exprContext b;
		public InstContext t1;
		public TerminalNode LCBRA() { return getToken(PorthosParser.LCBRA, 0); }
		public TerminalNode RCBRA() { return getToken(PorthosParser.RCBRA, 0); }
		public Bool_exprContext bool_expr() {
			return getRuleContext(Bool_exprContext.class,0);
		}
		public InstContext inst() {
			return getRuleContext(InstContext.class,0);
		}
		public While_Context(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public While_Context(ParserRuleContext parent, int invokingState, String mainThread) {
			super(parent, invokingState);
			this.mainThread = mainThread;
		}
		@Override public int getRuleIndex() { return RULE_while_; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof PorthosListener ) ((PorthosListener)listener).enterWhile_(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof PorthosListener ) ((PorthosListener)listener).exitWhile_(this);
		}
	}

	public final While_Context while_(String mainThread) throws RecognitionException {
		While_Context _localctx = new While_Context(_ctx, getState(), mainThread);
		enterRule(_localctx, 44, RULE_while_);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(266);
			match(T__19);
			setState(267);
			((While_Context)_localctx).b = bool_expr(mainThread);
			setState(268);
			match(LCBRA);
			setState(269);
			((While_Context)_localctx).t1 = inst(mainThread);
			setState(270);
			match(RCBRA);

					((While_Context)_localctx).t =  new While(((While_Context)_localctx).b.expr, ((While_Context)_localctx).t1.t);
				
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ProgramContext extends ParserRuleContext {
		public String name;
		public Program p;
		public LocationContext l;
		public Token min;
		public Token max;
		public Token iValue;
		public Token mainThread;
		public InstContext t1;
		public Token value;
		public Token thrd;
		public RegisterContext r;
		public List<TerminalNode> LCBRA() { return getTokens(PorthosParser.LCBRA); }
		public TerminalNode LCBRA(int i) {
			return getToken(PorthosParser.LCBRA, i);
		}
		public List<TerminalNode> RCBRA() { return getTokens(PorthosParser.RCBRA); }
		public TerminalNode RCBRA(int i) {
			return getToken(PorthosParser.RCBRA, i);
		}
		public List<LocationContext> location() {
			return getRuleContexts(LocationContext.class);
		}
		public LocationContext location(int i) {
			return getRuleContext(LocationContext.class,i);
		}
		public List<TerminalNode> COMMA() { return getTokens(PorthosParser.COMMA); }
		public TerminalNode COMMA(int i) {
			return getToken(PorthosParser.COMMA, i);
		}
		public List<TerminalNode> DIGIT() { return getTokens(PorthosParser.DIGIT); }
		public TerminalNode DIGIT(int i) {
			return getToken(PorthosParser.DIGIT, i);
		}
		public List<InstContext> inst() {
			return getRuleContexts(InstContext.class);
		}
		public InstContext inst(int i) {
			return getRuleContext(InstContext.class,i);
		}
		public List<RegisterContext> register() {
			return getRuleContexts(RegisterContext.class);
		}
		public RegisterContext register(int i) {
			return getRuleContext(RegisterContext.class,i);
		}
		public ProgramContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public ProgramContext(ParserRuleContext parent, int invokingState, String name) {
			super(parent, invokingState);
			this.name = name;
		}
		@Override public int getRuleIndex() { return RULE_program; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof PorthosListener ) ((PorthosListener)listener).enterProgram(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof PorthosListener ) ((PorthosListener)listener).exitProgram(this);
		}
	}

	public final ProgramContext program(String name) throws RecognitionException {
		ProgramContext _localctx = new ProgramContext(_ctx, getState(), name);
		enterRule(_localctx, 46, RULE_program);
		int _la;
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{

					Program p = new Program(name);
					p.setAss(new Assert());
				
			setState(274);
			match(LCBRA);
			setState(275);
			((ProgramContext)_localctx).l = location();
			setState(286);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,11,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					{
					{
					setState(276);
					match(T__8);
					setState(277);
					match(T__20);
					setState(278);
					((ProgramContext)_localctx).min = match(DIGIT);
					((ProgramContext)_localctx).l.loc.setMin(Integer.parseInt(((ProgramContext)_localctx).min.getText()));
					setState(280);
					match(COMMA);
					setState(281);
					((ProgramContext)_localctx).max = match(DIGIT);
					((ProgramContext)_localctx).l.loc.setMax(Integer.parseInt(((ProgramContext)_localctx).max.getText()));
					setState(283);
					match(T__21);
					}
					} 
				}
				setState(288);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,11,_ctx);
			}
			setState(294);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==T__8) {
				{
				{
				setState(289);
				match(T__8);
				setState(290);
				((ProgramContext)_localctx).iValue = match(DIGIT);
				((ProgramContext)_localctx).l.loc.setIValue(Integer.parseInt(((ProgramContext)_localctx).iValue.getText()));
				}
				}
				setState(296);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			mapLocs.put(((ProgramContext)_localctx).l.loc.getName(), ((ProgramContext)_localctx).l.loc);
			setState(325);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==COMMA) {
				{
				{
				setState(298);
				match(COMMA);
				setState(299);
				((ProgramContext)_localctx).l = location();
				setState(310);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,13,_ctx);
				while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
					if ( _alt==1 ) {
						{
						{
						setState(300);
						match(T__8);
						setState(301);
						match(T__20);
						setState(302);
						((ProgramContext)_localctx).min = match(DIGIT);
						((ProgramContext)_localctx).l.loc.setMin(Integer.parseInt(((ProgramContext)_localctx).min.getText()));
						setState(304);
						match(COMMA);
						setState(305);
						((ProgramContext)_localctx).max = match(DIGIT);
						((ProgramContext)_localctx).l.loc.setMax(Integer.parseInt(((ProgramContext)_localctx).max.getText()));
						setState(307);
						match(T__21);
						}
						} 
					}
					setState(312);
					_errHandler.sync(this);
					_alt = getInterpreter().adaptivePredict(_input,13,_ctx);
				}
				setState(318);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while (_la==T__8) {
					{
					{
					setState(313);
					match(T__8);
					setState(314);
					((ProgramContext)_localctx).iValue = match(DIGIT);
					((ProgramContext)_localctx).l.loc.setIValue(Integer.parseInt(((ProgramContext)_localctx).iValue.getText()));
					}
					}
					setState(320);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				mapLocs.put(((ProgramContext)_localctx).l.loc.getName(), ((ProgramContext)_localctx).l.loc);
				}
				}
				setState(327);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(328);
			match(RCBRA);
			setState(337); 
			_errHandler.sync(this);
			_la = _input.LA(1);
			do {
				{
				{
				setState(329);
				match(T__22);
				setState(330);
				((ProgramContext)_localctx).mainThread = match(DIGIT);
				mapRegs.put(((ProgramContext)_localctx).mainThread.getText(), new HashMap<String, Register>());
				setState(332);
				match(LCBRA);
				setState(333);
				((ProgramContext)_localctx).t1 = inst(((ProgramContext)_localctx).mainThread.getText());
				setState(334);
				match(RCBRA);
				p.add(((ProgramContext)_localctx).t1.t);
				}
				}
				setState(339); 
				_errHandler.sync(this);
				_la = _input.LA(1);
			} while ( _la==T__22 );
			((ProgramContext)_localctx).p =  p;
			setState(364);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==T__23) {
				{
				{
				setState(342);
				match(T__23);
				setState(359);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__4) | (1L << T__8) | (1L << DIGIT) | (1L << WORD))) != 0)) {
					{
					setState(357);
					_errHandler.sync(this);
					switch (_input.LA(1)) {
					case T__4:
					case T__8:
					case WORD:
						{
						setState(343);
						((ProgramContext)_localctx).l = location();
						setState(344);
						match(T__8);
						setState(345);
						((ProgramContext)_localctx).value = match(DIGIT);
						setState(346);
						match(COMMA);

								Location loc = ((ProgramContext)_localctx).l.loc;
								p.getAss().addPair(loc, Integer.parseInt(((ProgramContext)_localctx).value.getText()));
							
						}
						break;
					case DIGIT:
						{
						setState(349);
						((ProgramContext)_localctx).thrd = match(DIGIT);
						setState(350);
						match(T__24);
						setState(351);
						((ProgramContext)_localctx).r = register();
						setState(352);
						match(T__8);
						setState(353);
						((ProgramContext)_localctx).value = match(DIGIT);
						setState(354);
						match(COMMA);

								Register regPointer = ((ProgramContext)_localctx).r.reg;
								Register reg = mapRegs.get(((ProgramContext)_localctx).thrd.getText()).get(regPointer.getName());
								p.getAss().addPair(reg, Integer.parseInt(((ProgramContext)_localctx).value.getText()));
							
						}
						break;
					default:
						throw new NoViableAltException(this);
					}
					}
					setState(361);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				}
				}
				setState(366);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static final String _serializedATN =
		"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\3\66\u0172\4\2\t\2"+
		"\4\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4\t\t\t\4\n\t\n\4\13"+
		"\t\13\4\f\t\f\4\r\t\r\4\16\t\16\4\17\t\17\4\20\t\20\4\21\t\21\4\22\t\22"+
		"\4\23\t\23\4\24\t\24\4\25\t\25\4\26\t\26\4\27\t\27\4\30\t\30\4\31\t\31"+
		"\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\5\2<\n\2\3\3\3\3\3\3\3\3\3\3\3\3"+
		"\3\3\3\3\3\3\3\3\3\3\5\3I\n\3\3\4\3\4\3\4\3\4\3\4\3\4\3\4\3\5\3\5\3\5"+
		"\3\5\3\5\3\5\3\5\3\5\3\5\5\5[\n\5\3\6\3\6\3\6\3\6\3\6\3\6\3\6\3\6\3\6"+
		"\3\6\3\6\3\6\3\6\5\6j\n\6\3\7\3\7\3\7\3\7\3\7\3\7\5\7r\n\7\3\b\3\b\3\b"+
		"\3\t\3\t\3\t\3\t\3\t\3\n\3\n\3\n\3\n\3\n\3\13\3\13\3\13\3\13\3\13\3\f"+
		"\3\f\3\f\3\f\3\f\3\f\3\f\3\f\3\f\3\f\3\r\3\r\3\r\3\r\3\r\3\r\3\r\3\r\3"+
		"\r\3\r\3\16\3\16\3\16\3\16\3\16\3\16\3\16\3\16\3\16\3\16\3\16\3\16\3\16"+
		"\5\16\u00a7\n\16\3\17\3\17\3\20\3\20\3\21\3\21\3\22\3\22\3\23\3\23\3\23"+
		"\3\23\3\23\3\23\3\23\3\23\3\23\3\23\3\23\3\23\3\23\3\23\3\23\3\23\5\23"+
		"\u00c1\n\23\3\24\3\24\3\24\3\24\3\24\3\24\3\24\3\24\3\24\3\24\3\24\3\24"+
		"\3\24\3\24\3\24\3\24\3\24\3\24\3\24\5\24\u00d6\n\24\3\25\3\25\3\25\3\25"+
		"\3\25\3\25\3\25\3\25\3\25\3\25\3\25\3\25\3\25\3\25\3\25\3\25\3\25\3\25"+
		"\3\25\3\25\3\25\5\25\u00ed\n\25\3\26\3\26\3\26\7\26\u00f2\n\26\f\26\16"+
		"\26\u00f5\13\26\3\26\3\26\3\26\3\26\3\26\3\26\3\26\3\26\3\26\3\27\3\27"+
		"\3\27\7\27\u0103\n\27\f\27\16\27\u0106\13\27\3\27\3\27\3\27\3\27\3\27"+
		"\3\30\3\30\3\30\3\30\3\30\3\30\3\30\3\31\3\31\3\31\3\31\3\31\3\31\3\31"+
		"\3\31\3\31\3\31\3\31\7\31\u011f\n\31\f\31\16\31\u0122\13\31\3\31\3\31"+
		"\3\31\7\31\u0127\n\31\f\31\16\31\u012a\13\31\3\31\3\31\3\31\3\31\3\31"+
		"\3\31\3\31\3\31\3\31\3\31\3\31\7\31\u0137\n\31\f\31\16\31\u013a\13\31"+
		"\3\31\3\31\3\31\7\31\u013f\n\31\f\31\16\31\u0142\13\31\3\31\3\31\7\31"+
		"\u0146\n\31\f\31\16\31\u0149\13\31\3\31\3\31\3\31\3\31\3\31\3\31\3\31"+
		"\3\31\3\31\6\31\u0154\n\31\r\31\16\31\u0155\3\31\3\31\3\31\3\31\3\31\3"+
		"\31\3\31\3\31\3\31\3\31\3\31\3\31\3\31\3\31\3\31\3\31\7\31\u0168\n\31"+
		"\f\31\16\31\u016b\13\31\7\31\u016d\n\31\f\31\16\31\u0170\13\31\3\31\2"+
		"\2\32\2\4\6\b\n\f\16\20\22\24\26\30\32\34\36 \"$&(*,.\60\2\4\3\2\3\4\3"+
		"\2\5\6\2\u0184\2;\3\2\2\2\4H\3\2\2\2\6J\3\2\2\2\bZ\3\2\2\2\ni\3\2\2\2"+
		"\fq\3\2\2\2\16s\3\2\2\2\20v\3\2\2\2\22{\3\2\2\2\24\u0080\3\2\2\2\26\u0085"+
		"\3\2\2\2\30\u008f\3\2\2\2\32\u00a6\3\2\2\2\34\u00a8\3\2\2\2\36\u00aa\3"+
		"\2\2\2 \u00ac\3\2\2\2\"\u00ae\3\2\2\2$\u00c0\3\2\2\2&\u00d5\3\2\2\2(\u00ec"+
		"\3\2\2\2*\u00ee\3\2\2\2,\u00ff\3\2\2\2.\u010c\3\2\2\2\60\u0113\3\2\2\2"+
		"\62<\3\2\2\2\63\64\5\4\3\2\64\65\7\35\2\2\65\66\5\4\3\2\66\67\b\2\1\2"+
		"\67<\3\2\2\289\5\4\3\29:\b\2\1\2:<\3\2\2\2;\62\3\2\2\2;\63\3\2\2\2;8\3"+
		"\2\2\2<\3\3\2\2\2=I\3\2\2\2>?\7\37\2\2?I\b\3\1\2@A\5\16\b\2AB\b\3\1\2"+
		"BI\3\2\2\2CD\7#\2\2DE\5\2\2\2EF\7$\2\2FG\b\3\1\2GI\3\2\2\2H=\3\2\2\2H"+
		">\3\2\2\2H@\3\2\2\2HC\3\2\2\2I\5\3\2\2\2JK\7#\2\2KL\5\2\2\2LM\7\34\2\2"+
		"MN\5\2\2\2NO\7$\2\2OP\b\4\1\2P\7\3\2\2\2Q[\3\2\2\2RS\5\n\6\2ST\b\5\1\2"+
		"T[\3\2\2\2UV\5\n\6\2VW\7\36\2\2WX\5\n\6\2XY\b\5\1\2Y[\3\2\2\2ZQ\3\2\2"+
		"\2ZR\3\2\2\2ZU\3\2\2\2[\t\3\2\2\2\\j\3\2\2\2]^\t\2\2\2^j\b\6\1\2_`\t\3"+
		"\2\2`j\b\6\1\2ab\5\6\4\2bc\b\6\1\2cj\3\2\2\2de\7#\2\2ef\5\b\5\2fg\7$\2"+
		"\2gh\b\6\1\2hj\3\2\2\2i\\\3\2\2\2i]\3\2\2\2i_\3\2\2\2ia\3\2\2\2id\3\2"+
		"\2\2j\13\3\2\2\2kr\3\2\2\2lm\7\7\2\2mn\7 \2\2nr\b\7\1\2op\7 \2\2pr\b\7"+
		"\1\2qk\3\2\2\2ql\3\2\2\2qo\3\2\2\2r\r\3\2\2\2st\7 \2\2tu\b\b\1\2u\17\3"+
		"\2\2\2vw\5\16\b\2wx\7\b\2\2xy\5\2\2\2yz\b\t\1\2z\21\3\2\2\2{|\5\16\b\2"+
		"|}\7\t\2\2}~\5\f\7\2~\177\b\n\1\2\177\23\3\2\2\2\u0080\u0081\5\f\7\2\u0081"+
		"\u0082\7\n\2\2\u0082\u0083\5\16\b\2\u0083\u0084\b\13\1\2\u0084\25\3\2"+
		"\2\2\u0085\u0086\5\16\b\2\u0086\u0087\7\13\2\2\u0087\u0088\5\f\7\2\u0088"+
		"\u0089\7(\2\2\u0089\u008a\7\f\2\2\u008a\u008b\7#\2\2\u008b\u008c\7\66"+
		"\2\2\u008c\u008d\7$\2\2\u008d\u008e\b\f\1\2\u008e\27\3\2\2\2\u008f\u0090"+
		"\5\f\7\2\u0090\u0091\7(\2\2\u0091\u0092\7\r\2\2\u0092\u0093\7#\2\2\u0093"+
		"\u0094\7\66\2\2\u0094\u0095\7\'\2\2\u0095\u0096\5\16\b\2\u0096\u0097\7"+
		"$\2\2\u0097\u0098\b\r\1\2\u0098\31\3\2\2\2\u0099\u00a7\3\2\2\2\u009a\u009b"+
		"\5\34\17\2\u009b\u009c\b\16\1\2\u009c\u00a7\3\2\2\2\u009d\u009e\5\36\20"+
		"\2\u009e\u009f\b\16\1\2\u009f\u00a7\3\2\2\2\u00a0\u00a1\5 \21\2\u00a1"+
		"\u00a2\b\16\1\2\u00a2\u00a7\3\2\2\2\u00a3\u00a4\5\"\22\2\u00a4\u00a5\b"+
		"\16\1\2\u00a5\u00a7\3\2\2\2\u00a6\u0099\3\2\2\2\u00a6\u009a\3\2\2\2\u00a6"+
		"\u009d\3\2\2\2\u00a6\u00a0\3\2\2\2\u00a6\u00a3\3\2\2\2\u00a7\33\3\2\2"+
		"\2\u00a8\u00a9\7\16\2\2\u00a9\35\3\2\2\2\u00aa\u00ab\7\17\2\2\u00ab\37"+
		"\3\2\2\2\u00ac\u00ad\7\20\2\2\u00ad!\3\2\2\2\u00ae\u00af\7\21\2\2\u00af"+
		"#\3\2\2\2\u00b0\u00c1\3\2\2\2\u00b1\u00b2\5&\24\2\u00b2\u00b3\b\23\1\2"+
		"\u00b3\u00c1\3\2\2\2\u00b4\u00b5\5(\25\2\u00b5\u00b6\b\23\1\2\u00b6\u00c1"+
		"\3\2\2\2\u00b7\u00b8\5.\30\2\u00b8\u00b9\b\23\1\2\u00b9\u00c1\3\2\2\2"+
		"\u00ba\u00bb\5*\26\2\u00bb\u00bc\b\23\1\2\u00bc\u00c1\3\2\2\2\u00bd\u00be"+
		"\5,\27\2\u00be\u00bf\b\23\1\2\u00bf\u00c1\3\2\2\2\u00c0\u00b0\3\2\2\2"+
		"\u00c0\u00b1\3\2\2\2\u00c0\u00b4\3\2\2\2\u00c0\u00b7\3\2\2\2\u00c0\u00ba"+
		"\3\2\2\2\u00c0\u00bd\3\2\2\2\u00c1%\3\2\2\2\u00c2\u00d6\3\2\2\2\u00c3"+
		"\u00c4\5\20\t\2\u00c4\u00c5\b\24\1\2\u00c5\u00d6\3\2\2\2\u00c6\u00c7\5"+
		"\22\n\2\u00c7\u00c8\b\24\1\2\u00c8\u00d6\3\2\2\2\u00c9\u00ca\5\24\13\2"+
		"\u00ca\u00cb\b\24\1\2\u00cb\u00d6\3\2\2\2\u00cc\u00cd\5\32\16\2\u00cd"+
		"\u00ce\b\24\1\2\u00ce\u00d6\3\2\2\2\u00cf\u00d0\5\26\f\2\u00d0\u00d1\b"+
		"\24\1\2\u00d1\u00d6\3\2\2\2\u00d2\u00d3\5\30\r\2\u00d3\u00d4\b\24\1\2"+
		"\u00d4\u00d6\3\2\2\2\u00d5\u00c2\3\2\2\2\u00d5\u00c3\3\2\2\2\u00d5\u00c6"+
		"\3\2\2\2\u00d5\u00c9\3\2\2\2\u00d5\u00cc\3\2\2\2\u00d5\u00cf\3\2\2\2\u00d5"+
		"\u00d2\3\2\2\2\u00d6\'\3\2\2\2\u00d7\u00ed\3\2\2\2\u00d8\u00d9\5&\24\2"+
		"\u00d9\u00da\7\22\2\2\u00da\u00db\5$\23\2\u00db\u00dc\b\25\1\2\u00dc\u00ed"+
		"\3\2\2\2\u00dd\u00de\5.\30\2\u00de\u00df\7\22\2\2\u00df\u00e0\5$\23\2"+
		"\u00e0\u00e1\b\25\1\2\u00e1\u00ed\3\2\2\2\u00e2\u00e3\5*\26\2\u00e3\u00e4"+
		"\7\22\2\2\u00e4\u00e5\5$\23\2\u00e5\u00e6\b\25\1\2\u00e6\u00ed\3\2\2\2"+
		"\u00e7\u00e8\5,\27\2\u00e8\u00e9\7\22\2\2\u00e9\u00ea\5$\23\2\u00ea\u00eb"+
		"\b\25\1\2\u00eb\u00ed\3\2\2\2\u00ec\u00d7\3\2\2\2\u00ec\u00d8\3\2\2\2"+
		"\u00ec\u00dd\3\2\2\2\u00ec\u00e2\3\2\2\2\u00ec\u00e7\3\2\2\2\u00ed)\3"+
		"\2\2\2\u00ee\u00ef\7\23\2\2\u00ef\u00f3\5\b\5\2\u00f0\u00f2\7\24\2\2\u00f1"+
		"\u00f0\3\2\2\2\u00f2\u00f5\3\2\2\2\u00f3\u00f1\3\2\2\2\u00f3\u00f4\3\2"+
		"\2\2\u00f4\u00f6\3\2\2\2\u00f5\u00f3\3\2\2\2\u00f6\u00f7\7%\2\2\u00f7"+
		"\u00f8\5$\23\2\u00f8\u00f9\7&\2\2\u00f9\u00fa\7\25\2\2\u00fa\u00fb\7%"+
		"\2\2\u00fb\u00fc\5$\23\2\u00fc\u00fd\7&\2\2\u00fd\u00fe\b\26\1\2\u00fe"+
		"+\3\2\2\2\u00ff\u0100\7\23\2\2\u0100\u0104\5\b\5\2\u0101\u0103\7\24\2"+
		"\2\u0102\u0101\3\2\2\2\u0103\u0106\3\2\2\2\u0104\u0102\3\2\2\2\u0104\u0105"+
		"\3\2\2\2\u0105\u0107\3\2\2\2\u0106\u0104\3\2\2\2\u0107\u0108\7%\2\2\u0108"+
		"\u0109\5$\23\2\u0109\u010a\7&\2\2\u010a\u010b\b\27\1\2\u010b-\3\2\2\2"+
		"\u010c\u010d\7\26\2\2\u010d\u010e\5\b\5\2\u010e\u010f\7%\2\2\u010f\u0110"+
		"\5$\23\2\u0110\u0111\7&\2\2\u0111\u0112\b\30\1\2\u0112/\3\2\2\2\u0113"+
		"\u0114\b\31\1\2\u0114\u0115\7%\2\2\u0115\u0120\5\f\7\2\u0116\u0117\7\13"+
		"\2\2\u0117\u0118\7\27\2\2\u0118\u0119\7\37\2\2\u0119\u011a\b\31\1\2\u011a"+
		"\u011b\7\'\2\2\u011b\u011c\7\37\2\2\u011c\u011d\b\31\1\2\u011d\u011f\7"+
		"\30\2\2\u011e\u0116\3\2\2\2\u011f\u0122\3\2\2\2\u0120\u011e\3\2\2\2\u0120"+
		"\u0121\3\2\2\2\u0121\u0128\3\2\2\2\u0122\u0120\3\2\2\2\u0123\u0124\7\13"+
		"\2\2\u0124\u0125\7\37\2\2\u0125\u0127\b\31\1\2\u0126\u0123\3\2\2\2\u0127"+
		"\u012a\3\2\2\2\u0128\u0126\3\2\2\2\u0128\u0129\3\2\2\2\u0129\u012b\3\2"+
		"\2\2\u012a\u0128\3\2\2\2\u012b\u0147\b\31\1\2\u012c\u012d\7\'\2\2\u012d"+
		"\u0138\5\f\7\2\u012e\u012f\7\13\2\2\u012f\u0130\7\27\2\2\u0130\u0131\7"+
		"\37\2\2\u0131\u0132\b\31\1\2\u0132\u0133\7\'\2\2\u0133\u0134\7\37\2\2"+
		"\u0134\u0135\b\31\1\2\u0135\u0137\7\30\2\2\u0136\u012e\3\2\2\2\u0137\u013a"+
		"\3\2\2\2\u0138\u0136\3\2\2\2\u0138\u0139\3\2\2\2\u0139\u0140\3\2\2\2\u013a"+
		"\u0138\3\2\2\2\u013b\u013c\7\13\2\2\u013c\u013d\7\37\2\2\u013d\u013f\b"+
		"\31\1\2\u013e\u013b\3\2\2\2\u013f\u0142\3\2\2\2\u0140\u013e\3\2\2\2\u0140"+
		"\u0141\3\2\2\2\u0141\u0143\3\2\2\2\u0142\u0140\3\2\2\2\u0143\u0144\b\31"+
		"\1\2\u0144\u0146\3\2\2\2\u0145\u012c\3\2\2\2\u0146\u0149\3\2\2\2\u0147"+
		"\u0145\3\2\2\2\u0147\u0148\3\2\2\2\u0148\u014a\3\2\2\2\u0149\u0147\3\2"+
		"\2\2\u014a\u0153\7&\2\2\u014b\u014c\7\31\2\2\u014c\u014d\7\37\2\2\u014d"+
		"\u014e\b\31\1\2\u014e\u014f\7%\2\2\u014f\u0150\5$\23\2\u0150\u0151\7&"+
		"\2\2\u0151\u0152\b\31\1\2\u0152\u0154\3\2\2\2\u0153\u014b\3\2\2\2\u0154"+
		"\u0155\3\2\2\2\u0155\u0153\3\2\2\2\u0155\u0156\3\2\2\2\u0156\u0157\3\2"+
		"\2\2\u0157\u016e\b\31\1\2\u0158\u0169\7\32\2\2\u0159\u015a\5\f\7\2\u015a"+
		"\u015b\7\13\2\2\u015b\u015c\7\37\2\2\u015c\u015d\7\'\2\2\u015d\u015e\b"+
		"\31\1\2\u015e\u0168\3\2\2\2\u015f\u0160\7\37\2\2\u0160\u0161\7\33\2\2"+
		"\u0161\u0162\5\16\b\2\u0162\u0163\7\13\2\2\u0163\u0164\7\37\2\2\u0164"+
		"\u0165\7\'\2\2\u0165\u0166\b\31\1\2\u0166\u0168\3\2\2\2\u0167\u0159\3"+
		"\2\2\2\u0167\u015f\3\2\2\2\u0168\u016b\3\2\2\2\u0169\u0167\3\2\2\2\u0169"+
		"\u016a\3\2\2\2\u016a\u016d\3\2\2\2\u016b\u0169\3\2\2\2\u016c\u0158\3\2"+
		"\2\2\u016d\u0170\3\2\2\2\u016e\u016c\3\2\2\2\u016e\u016f\3\2\2\2\u016f"+
		"\61\3\2\2\2\u0170\u016e\3\2\2\2\26;HZiq\u00a6\u00c0\u00d5\u00ec\u00f3"+
		"\u0104\u0120\u0128\u0138\u0140\u0147\u0155\u0167\u0169\u016e";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}