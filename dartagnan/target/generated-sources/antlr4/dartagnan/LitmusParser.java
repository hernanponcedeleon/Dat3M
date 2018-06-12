// Generated from Litmus.g4 by ANTLR 4.7

package dartagnan;
import dartagnan.program.*;
import dartagnan.expression.*;
import dartagnan.program.Thread;
import java.util.HashMap;
import java.util.Map;
import java.util.ArrayList;
import java.util.List;

import org.antlr.v4.runtime.atn.*;
import org.antlr.v4.runtime.dfa.DFA;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.misc.*;
import org.antlr.v4.runtime.tree.*;
import java.util.List;
import java.util.Iterator;
import java.util.ArrayList;

@SuppressWarnings({"all", "warnings", "unchecked", "unused", "cast"})
public class LitmusParser extends Parser {
	static { RuntimeMetaData.checkVersion("4.7", RuntimeMetaData.VERSION); }

	protected static final DFA[] _decisionToDFA;
	protected static final PredictionContextCache _sharedContextCache =
		new PredictionContextCache();
	public static final int
		T__0=1, T__1=2, T__2=3, T__3=4, T__4=5, T__5=6, T__6=7, T__7=8, T__8=9, 
		T__9=10, T__10=11, T__11=12, T__12=13, T__13=14, T__14=15, T__15=16, T__16=17, 
		T__17=18, T__18=19, T__19=20, T__20=21, T__21=22, T__22=23, T__23=24, 
		T__24=25, T__25=26, T__26=27, T__27=28, T__28=29, T__29=30, T__30=31, 
		T__31=32, T__32=33, T__33=34, T__34=35, T__35=36, T__36=37, T__37=38, 
		T__38=39, T__39=40, T__40=41, T__41=42, T__42=43, T__43=44, T__44=45, 
		T__45=46, ARCH=47, X86=48, POWER=49, LETTER=50, DIGIT=51, MONIO=52, SYMBOL=53, 
		WS=54, LWSYNC=55, SYNC=56, ISYNC=57;
	public static final int
		RULE_program = 0, RULE_inits = 1, RULE_initLocation = 2, RULE_initRegister = 3, 
		RULE_initRegisterLocation = 4, RULE_assertion = 5, RULE_bop = 6, RULE_headerComments = 7, 
		RULE_bottomComments = 8, RULE_word = 9, RULE_location = 10, RULE_locationX86 = 11, 
		RULE_registerPower = 12, RULE_registerX86 = 13, RULE_threads = 14, RULE_inst = 15, 
		RULE_localX86 = 16, RULE_localPower = 17, RULE_xor = 18, RULE_addi = 19, 
		RULE_mr = 20, RULE_loadX86 = 21, RULE_loadPower = 22, RULE_storeX86reg = 23, 
		RULE_storeX86val = 24, RULE_storePower = 25, RULE_cmpw = 26, RULE_mfence = 27, 
		RULE_lwsync = 28, RULE_sync = 29, RULE_isync = 30;
	public static final String[] ruleNames = {
		"program", "inits", "initLocation", "initRegister", "initRegisterLocation", 
		"assertion", "bop", "headerComments", "bottomComments", "word", "location", 
		"locationX86", "registerPower", "registerX86", "threads", "inst", "localX86", 
		"localPower", "xor", "addi", "mr", "loadX86", "loadPower", "storeX86reg", 
		"storeX86val", "storePower", "cmpw", "mfence", "lwsync", "sync", "isync"
	};

	private static final String[] _LITERAL_NAMES = {
		null, "'PPC'", "'X86'", "'{'", "'}'", "'exists'", "'('", "')'", "'='", 
		"';'", "':'", "'/\\'", "'['", "']'", "'r0'", "'r1'", "'r2'", "'r3'", "'r4'", 
		"'r5'", "'r6'", "'r7'", "'r8'", "'r9'", "'r10'", "'r11'", "'r12'", "'r13'", 
		"'r14'", "'EAX'", "'EBX'", "'ECX'", "'EDX'", "'|'", "'beq'", "'LC'", "'MOV'", 
		"',$'", "'li'", "','", "'xor'", "'addi'", "'mr'", "'lwz'", "'stw'", "'cmpw'", 
		"'MFENCE'", null, null, null, null, null, "'~'", null, null, "'lwsync'", 
		"'sync'", "'isync'"
	};
	private static final String[] _SYMBOLIC_NAMES = {
		null, null, null, null, null, null, null, null, null, null, null, null, 
		null, null, null, null, null, null, null, null, null, null, null, null, 
		null, null, null, null, null, null, null, null, null, null, null, null, 
		null, null, null, null, null, null, null, null, null, null, null, "ARCH", 
		"X86", "POWER", "LETTER", "DIGIT", "MONIO", "SYMBOL", "WS", "LWSYNC", 
		"SYNC", "ISYNC"
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
	public String getGrammarFileName() { return "Litmus.g4"; }

	@Override
	public String[] getRuleNames() { return ruleNames; }

	@Override
	public String getSerializedATN() { return _serializedATN; }

	@Override
	public ATN getATN() { return _ATN; }


	private Map<String, Location> mapLocs = new HashMap<String, Location>();
	private Map<String, Map<String, Register>> mapRegs = new HashMap<String, Map<String, Register>>();
	private Map<String, Map<String, Location>> mapRegLoc = new HashMap<String, Map<String, Location>>();
	private Map<String, Location> mapLoc = new HashMap<String, Location>();
	private Map<String, List<Thread>> mapThreads = new HashMap<String, List<Thread>>();

	public LitmusParser(TokenStream input) {
		super(input);
		_interp = new ParserATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
	}
	public static class ProgramContext extends ParserRuleContext {
		public String name;
		public Program p;
		public ThreadsContext threadsList;
		public HeaderCommentsContext headerComments() {
			return getRuleContext(HeaderCommentsContext.class,0);
		}
		public InitsContext inits() {
			return getRuleContext(InitsContext.class,0);
		}
		public BottomCommentsContext bottomComments() {
			return getRuleContext(BottomCommentsContext.class,0);
		}
		public AssertionContext assertion() {
			return getRuleContext(AssertionContext.class,0);
		}
		public ThreadsContext threads() {
			return getRuleContext(ThreadsContext.class,0);
		}
		public ProgramContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public ProgramContext(ParserRuleContext parent, int invokingState, String name) {
			super(parent, invokingState);
			this.name = name;
		}
		@Override public int getRuleIndex() { return RULE_program; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).enterProgram(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).exitProgram(this);
		}
	}

	public final ProgramContext program(String name) throws RecognitionException {
		ProgramContext _localctx = new ProgramContext(_ctx, getState(), name);
		enterRule(_localctx, 0, RULE_program);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{

					Program p = new Program(name);
					p.setAss(new Assert());
				
			setState(63);
			_la = _input.LA(1);
			if ( !(_la==T__0 || _la==T__1) ) {
			_errHandler.recoverInline(this);
			}
			else {
				if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
				_errHandler.reportMatch(this);
				consume();
			}
			setState(64);
			headerComments();
			setState(65);
			match(T__2);
			setState(66);
			inits();
			setState(67);
			match(T__3);
			setState(68);
			((ProgramContext)_localctx).threadsList = threads();

					for(Thread t : ((ProgramContext)_localctx).threadsList.lst) {
						p.add(t);
					}
					((ProgramContext)_localctx).p =  p;
				
			setState(70);
			bottomComments();
			setState(71);
			match(T__4);
			setState(72);
			match(T__5);
			setState(73);
			assertion(p);
			setState(74);
			match(T__6);
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

	public static class InitsContext extends ParserRuleContext {
		public List<InitLocationContext> initLocation() {
			return getRuleContexts(InitLocationContext.class);
		}
		public InitLocationContext initLocation(int i) {
			return getRuleContext(InitLocationContext.class,i);
		}
		public List<InitRegisterContext> initRegister() {
			return getRuleContexts(InitRegisterContext.class);
		}
		public InitRegisterContext initRegister(int i) {
			return getRuleContext(InitRegisterContext.class,i);
		}
		public List<InitRegisterLocationContext> initRegisterLocation() {
			return getRuleContexts(InitRegisterLocationContext.class);
		}
		public InitRegisterLocationContext initRegisterLocation(int i) {
			return getRuleContext(InitRegisterLocationContext.class,i);
		}
		public InitsContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_inits; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).enterInits(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).exitInits(this);
		}
	}

	public final InitsContext inits() throws RecognitionException {
		InitsContext _localctx = new InitsContext(_ctx, getState());
		enterRule(_localctx, 2, RULE_inits);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(81);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==LETTER || _la==DIGIT) {
				{
				setState(79);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,0,_ctx) ) {
				case 1:
					{
					setState(76);
					initLocation();
					}
					break;
				case 2:
					{
					setState(77);
					initRegister();
					}
					break;
				case 3:
					{
					setState(78);
					initRegisterLocation();
					}
					break;
				}
				}
				setState(83);
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

	public static class InitLocationContext extends ParserRuleContext {
		public LocationContext l;
		public TerminalNode DIGIT() { return getToken(LitmusParser.DIGIT, 0); }
		public LocationContext location() {
			return getRuleContext(LocationContext.class,0);
		}
		public InitLocationContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_initLocation; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).enterInitLocation(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).exitInitLocation(this);
		}
	}

	public final InitLocationContext initLocation() throws RecognitionException {
		InitLocationContext _localctx = new InitLocationContext(_ctx, getState());
		enterRule(_localctx, 4, RULE_initLocation);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(84);
			((InitLocationContext)_localctx).l = location();
			setState(85);
			match(T__7);
			setState(86);
			match(DIGIT);
			setState(87);
			match(T__8);
			mapLocs.put(((InitLocationContext)_localctx).l.loc.getName(), ((InitLocationContext)_localctx).l.loc);
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

	public static class InitRegisterContext extends ParserRuleContext {
		public Token thrd;
		public RegisterPowerContext r;
		public LocationContext l;
		public TerminalNode DIGIT() { return getToken(LitmusParser.DIGIT, 0); }
		public RegisterPowerContext registerPower() {
			return getRuleContext(RegisterPowerContext.class,0);
		}
		public LocationContext location() {
			return getRuleContext(LocationContext.class,0);
		}
		public List<TerminalNode> LETTER() { return getTokens(LitmusParser.LETTER); }
		public TerminalNode LETTER(int i) {
			return getToken(LitmusParser.LETTER, i);
		}
		public InitRegisterContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_initRegister; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).enterInitRegister(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).exitInitRegister(this);
		}
	}

	public final InitRegisterContext initRegister() throws RecognitionException {
		InitRegisterContext _localctx = new InitRegisterContext(_ctx, getState());
		enterRule(_localctx, 6, RULE_initRegister);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(93);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==LETTER) {
				{
				{
				setState(90);
				match(LETTER);
				}
				}
				setState(95);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(96);
			((InitRegisterContext)_localctx).thrd = match(DIGIT);
			setState(97);
			match(T__9);
			setState(98);
			((InitRegisterContext)_localctx).r = registerPower();
			setState(99);
			match(T__7);
			setState(100);
			((InitRegisterContext)_localctx).l = location();
			setState(101);
			match(T__8);

			        if(!mapRegLoc.keySet().contains(((InitRegisterContext)_localctx).thrd.getText())) {
			            mapRegLoc.put(((InitRegisterContext)_localctx).thrd.getText(), new HashMap<String, Location>());
			        }
			        if(!mapLoc.keySet().contains(((InitRegisterContext)_localctx).l.loc.getName())) {
			            mapLoc.put(((InitRegisterContext)_localctx).l.loc.getName(), ((InitRegisterContext)_localctx).l.loc);
			        }
			        mapRegLoc.get(((InitRegisterContext)_localctx).thrd.getText()).put(((InitRegisterContext)_localctx).r.reg.getName(), mapLoc.get(((InitRegisterContext)_localctx).l.loc.getName()));
			    
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

	public static class InitRegisterLocationContext extends ParserRuleContext {
		public Token thrd;
		public RegisterPowerContext r;
		public Token d;
		public List<TerminalNode> DIGIT() { return getTokens(LitmusParser.DIGIT); }
		public TerminalNode DIGIT(int i) {
			return getToken(LitmusParser.DIGIT, i);
		}
		public RegisterPowerContext registerPower() {
			return getRuleContext(RegisterPowerContext.class,0);
		}
		public List<TerminalNode> LETTER() { return getTokens(LitmusParser.LETTER); }
		public TerminalNode LETTER(int i) {
			return getToken(LitmusParser.LETTER, i);
		}
		public InitRegisterLocationContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_initRegisterLocation; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).enterInitRegisterLocation(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).exitInitRegisterLocation(this);
		}
	}

	public final InitRegisterLocationContext initRegisterLocation() throws RecognitionException {
		InitRegisterLocationContext _localctx = new InitRegisterLocationContext(_ctx, getState());
		enterRule(_localctx, 8, RULE_initRegisterLocation);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(107);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==LETTER) {
				{
				{
				setState(104);
				match(LETTER);
				}
				}
				setState(109);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(110);
			((InitRegisterLocationContext)_localctx).thrd = match(DIGIT);
			setState(111);
			match(T__9);
			setState(112);
			((InitRegisterLocationContext)_localctx).r = registerPower();
			setState(113);
			match(T__7);
			setState(114);
			((InitRegisterLocationContext)_localctx).d = match(DIGIT);
			setState(115);
			match(T__8);

			        Register regPointer = ((InitRegisterLocationContext)_localctx).r.reg;
			        if(!mapRegs.keySet().contains(((InitRegisterLocationContext)_localctx).thrd.getText())) {
			            mapRegs.put(((InitRegisterLocationContext)_localctx).thrd.getText(), new HashMap<String, Register>());
			        }
			        mapRegs.get(((InitRegisterLocationContext)_localctx).thrd.getText()).put(regPointer.getName(), regPointer);
			        if(!mapThreads.keySet().contains(((InitRegisterLocationContext)_localctx).thrd.getText())) {
			            mapThreads.put(((InitRegisterLocationContext)_localctx).thrd.getText(), new ArrayList<Thread>());
			        }
			        mapThreads.get(((InitRegisterLocationContext)_localctx).thrd.getText()).add(new Local(regPointer, new AConst(Integer.parseInt(((InitRegisterLocationContext)_localctx).d.getText()))));
			    
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

	public static class AssertionContext extends ParserRuleContext {
		public Program p;
		public LocationContext l;
		public Token value;
		public Token thrd;
		public RegisterPowerContext r;
		public RegisterX86Context rx;
		public List<LocationContext> location() {
			return getRuleContexts(LocationContext.class);
		}
		public LocationContext location(int i) {
			return getRuleContext(LocationContext.class,i);
		}
		public List<TerminalNode> DIGIT() { return getTokens(LitmusParser.DIGIT); }
		public TerminalNode DIGIT(int i) {
			return getToken(LitmusParser.DIGIT, i);
		}
		public List<RegisterPowerContext> registerPower() {
			return getRuleContexts(RegisterPowerContext.class);
		}
		public RegisterPowerContext registerPower(int i) {
			return getRuleContext(RegisterPowerContext.class,i);
		}
		public List<RegisterX86Context> registerX86() {
			return getRuleContexts(RegisterX86Context.class);
		}
		public RegisterX86Context registerX86(int i) {
			return getRuleContext(RegisterX86Context.class,i);
		}
		public List<BopContext> bop() {
			return getRuleContexts(BopContext.class);
		}
		public BopContext bop(int i) {
			return getRuleContext(BopContext.class,i);
		}
		public AssertionContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public AssertionContext(ParserRuleContext parent, int invokingState, Program p) {
			super(parent, invokingState);
			this.p = p;
		}
		@Override public int getRuleIndex() { return RULE_assertion; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).enterAssertion(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).exitAssertion(this);
		}
	}

	public final AssertionContext assertion(Program p) throws RecognitionException {
		AssertionContext _localctx = new AssertionContext(_ctx, getState(), p);
		enterRule(_localctx, 10, RULE_assertion);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(142); 
			_errHandler.sync(this);
			_la = _input.LA(1);
			do {
				{
				{
				setState(137);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,4,_ctx) ) {
				case 1:
					{
					setState(118);
					((AssertionContext)_localctx).l = location();
					setState(119);
					match(T__7);
					setState(120);
					((AssertionContext)_localctx).value = match(DIGIT);

					        Location loc = ((AssertionContext)_localctx).l.loc;
					        p.getAss().addPair(loc, Integer.parseInt(((AssertionContext)_localctx).value.getText()));
					    
					}
					break;
				case 2:
					{
					setState(123);
					((AssertionContext)_localctx).thrd = match(DIGIT);
					setState(124);
					match(T__9);
					setState(125);
					((AssertionContext)_localctx).r = registerPower();
					setState(126);
					match(T__7);
					setState(127);
					((AssertionContext)_localctx).value = match(DIGIT);

					        Register regPointer = ((AssertionContext)_localctx).r.reg;
					        Register reg = mapRegs.get(((AssertionContext)_localctx).thrd.getText()).get(regPointer.getName());
					        p.getAss().addPair(reg, Integer.parseInt(((AssertionContext)_localctx).value.getText()));
					    
					}
					break;
				case 3:
					{
					setState(130);
					((AssertionContext)_localctx).thrd = match(DIGIT);
					setState(131);
					match(T__9);
					setState(132);
					((AssertionContext)_localctx).rx = registerX86();
					setState(133);
					match(T__7);
					setState(134);
					((AssertionContext)_localctx).value = match(DIGIT);

					            Register regPointer = ((AssertionContext)_localctx).rx.reg;
					            Register reg = mapRegs.get(((AssertionContext)_localctx).thrd.getText()).get(regPointer.getName());
					            p.getAss().addPair(reg, Integer.parseInt(((AssertionContext)_localctx).value.getText()));
					        
					}
					break;
				}
				setState(140);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if (_la==T__10) {
					{
					setState(139);
					bop();
					}
				}

				}
				}
				setState(144); 
				_errHandler.sync(this);
				_la = _input.LA(1);
			} while ( _la==LETTER || _la==DIGIT );
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

	public static class BopContext extends ParserRuleContext {
		public BopContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_bop; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).enterBop(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).exitBop(this);
		}
	}

	public final BopContext bop() throws RecognitionException {
		BopContext _localctx = new BopContext(_ctx, getState());
		enterRule(_localctx, 12, RULE_bop);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(146);
			match(T__10);
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

	public static class HeaderCommentsContext extends ParserRuleContext {
		public HeaderCommentsContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_headerComments; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).enterHeaderComments(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).exitHeaderComments(this);
		}
	}

	public final HeaderCommentsContext headerComments() throws RecognitionException {
		HeaderCommentsContext _localctx = new HeaderCommentsContext(_ctx, getState());
		enterRule(_localctx, 14, RULE_headerComments);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(151);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__0) | (1L << T__1) | (1L << T__3) | (1L << T__4) | (1L << T__5) | (1L << T__6) | (1L << T__7) | (1L << T__8) | (1L << T__9) | (1L << T__10) | (1L << T__11) | (1L << T__12) | (1L << T__13) | (1L << T__14) | (1L << T__15) | (1L << T__16) | (1L << T__17) | (1L << T__18) | (1L << T__19) | (1L << T__20) | (1L << T__21) | (1L << T__22) | (1L << T__23) | (1L << T__24) | (1L << T__25) | (1L << T__26) | (1L << T__27) | (1L << T__28) | (1L << T__29) | (1L << T__30) | (1L << T__31) | (1L << T__32) | (1L << T__33) | (1L << T__34) | (1L << T__35) | (1L << T__36) | (1L << T__37) | (1L << T__38) | (1L << T__39) | (1L << T__40) | (1L << T__41) | (1L << T__42) | (1L << T__43) | (1L << T__44) | (1L << T__45) | (1L << ARCH) | (1L << X86) | (1L << POWER) | (1L << LETTER) | (1L << DIGIT) | (1L << MONIO) | (1L << SYMBOL) | (1L << WS) | (1L << LWSYNC) | (1L << SYNC) | (1L << ISYNC))) != 0)) {
				{
				{
				setState(148);
				_la = _input.LA(1);
				if ( _la <= 0 || (_la==T__2) ) {
				_errHandler.recoverInline(this);
				}
				else {
					if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
					_errHandler.reportMatch(this);
					consume();
				}
				}
				}
				setState(153);
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

	public static class BottomCommentsContext extends ParserRuleContext {
		public BottomCommentsContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_bottomComments; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).enterBottomComments(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).exitBottomComments(this);
		}
	}

	public final BottomCommentsContext bottomComments() throws RecognitionException {
		BottomCommentsContext _localctx = new BottomCommentsContext(_ctx, getState());
		enterRule(_localctx, 16, RULE_bottomComments);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(157);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__0) | (1L << T__1) | (1L << T__2) | (1L << T__3) | (1L << T__5) | (1L << T__6) | (1L << T__7) | (1L << T__8) | (1L << T__9) | (1L << T__10) | (1L << T__11) | (1L << T__12) | (1L << T__13) | (1L << T__14) | (1L << T__15) | (1L << T__16) | (1L << T__17) | (1L << T__18) | (1L << T__19) | (1L << T__20) | (1L << T__21) | (1L << T__22) | (1L << T__23) | (1L << T__24) | (1L << T__25) | (1L << T__26) | (1L << T__27) | (1L << T__28) | (1L << T__29) | (1L << T__30) | (1L << T__31) | (1L << T__32) | (1L << T__33) | (1L << T__34) | (1L << T__35) | (1L << T__36) | (1L << T__37) | (1L << T__38) | (1L << T__39) | (1L << T__40) | (1L << T__41) | (1L << T__42) | (1L << T__43) | (1L << T__44) | (1L << T__45) | (1L << ARCH) | (1L << X86) | (1L << POWER) | (1L << LETTER) | (1L << DIGIT) | (1L << MONIO) | (1L << SYMBOL) | (1L << WS) | (1L << LWSYNC) | (1L << SYNC) | (1L << ISYNC))) != 0)) {
				{
				{
				setState(154);
				_la = _input.LA(1);
				if ( _la <= 0 || (_la==T__4) ) {
				_errHandler.recoverInline(this);
				}
				else {
					if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
					_errHandler.reportMatch(this);
					consume();
				}
				}
				}
				setState(159);
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

	public static class WordContext extends ParserRuleContext {
		public String str;
		public Token w;
		public List<TerminalNode> LETTER() { return getTokens(LitmusParser.LETTER); }
		public TerminalNode LETTER(int i) {
			return getToken(LitmusParser.LETTER, i);
		}
		public List<TerminalNode> DIGIT() { return getTokens(LitmusParser.DIGIT); }
		public TerminalNode DIGIT(int i) {
			return getToken(LitmusParser.DIGIT, i);
		}
		public WordContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_word; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).enterWord(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).exitWord(this);
		}
	}

	public final WordContext word() throws RecognitionException {
		WordContext _localctx = new WordContext(_ctx, getState());
		enterRule(_localctx, 18, RULE_word);
		int _la;
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(161); 
			_errHandler.sync(this);
			_alt = 1;
			do {
				switch (_alt) {
				case 1:
					{
					{
					setState(160);
					((WordContext)_localctx).w = _input.LT(1);
					_la = _input.LA(1);
					if ( !(_la==LETTER || _la==DIGIT) ) {
						((WordContext)_localctx).w = (Token)_errHandler.recoverInline(this);
					}
					else {
						if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
						_errHandler.reportMatch(this);
						consume();
					}
					}
					}
					break;
				default:
					throw new NoViableAltException(this);
				}
				setState(163); 
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,9,_ctx);
			} while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER );
			((WordContext)_localctx).str =  ((WordContext)_localctx).w.getText();
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
		public Token l;
		public List<TerminalNode> LETTER() { return getTokens(LitmusParser.LETTER); }
		public TerminalNode LETTER(int i) {
			return getToken(LitmusParser.LETTER, i);
		}
		public List<TerminalNode> DIGIT() { return getTokens(LitmusParser.DIGIT); }
		public TerminalNode DIGIT(int i) {
			return getToken(LitmusParser.DIGIT, i);
		}
		public LocationContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_location; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).enterLocation(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).exitLocation(this);
		}
	}

	public final LocationContext location() throws RecognitionException {
		LocationContext _localctx = new LocationContext(_ctx, getState());
		enterRule(_localctx, 20, RULE_location);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(167);
			((LocationContext)_localctx).l = match(LETTER);
			setState(171);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==LETTER || _la==DIGIT) {
				{
				{
				setState(168);
				_la = _input.LA(1);
				if ( !(_la==LETTER || _la==DIGIT) ) {
				_errHandler.recoverInline(this);
				}
				else {
					if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
					_errHandler.reportMatch(this);
					consume();
				}
				}
				}
				setState(173);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			((LocationContext)_localctx).loc =  new Location(((LocationContext)_localctx).l.getText());
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

	public static class LocationX86Context extends ParserRuleContext {
		public Location loc;
		public LocationContext l;
		public LocationContext location() {
			return getRuleContext(LocationContext.class,0);
		}
		public LocationX86Context(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_locationX86; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).enterLocationX86(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).exitLocationX86(this);
		}
	}

	public final LocationX86Context locationX86() throws RecognitionException {
		LocationX86Context _localctx = new LocationX86Context(_ctx, getState());
		enterRule(_localctx, 22, RULE_locationX86);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(176);
			match(T__11);
			setState(177);
			((LocationX86Context)_localctx).l = location();
			setState(178);
			match(T__12);
			((LocationX86Context)_localctx).loc =  ((LocationX86Context)_localctx).l.loc;
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

	public static class RegisterPowerContext extends ParserRuleContext {
		public Register reg;
		public Token r;
		public RegisterPowerContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_registerPower; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).enterRegisterPower(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).exitRegisterPower(this);
		}
	}

	public final RegisterPowerContext registerPower() throws RecognitionException {
		RegisterPowerContext _localctx = new RegisterPowerContext(_ctx, getState());
		enterRule(_localctx, 24, RULE_registerPower);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(181);
			((RegisterPowerContext)_localctx).r = _input.LT(1);
			_la = _input.LA(1);
			if ( !((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__13) | (1L << T__14) | (1L << T__15) | (1L << T__16) | (1L << T__17) | (1L << T__18) | (1L << T__19) | (1L << T__20) | (1L << T__21) | (1L << T__22) | (1L << T__23) | (1L << T__24) | (1L << T__25) | (1L << T__26) | (1L << T__27))) != 0)) ) {
				((RegisterPowerContext)_localctx).r = (Token)_errHandler.recoverInline(this);
			}
			else {
				if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
				_errHandler.reportMatch(this);
				consume();
			}
			((RegisterPowerContext)_localctx).reg =  new Register(((RegisterPowerContext)_localctx).r.getText());
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

	public static class RegisterX86Context extends ParserRuleContext {
		public Register reg;
		public Token r;
		public RegisterX86Context(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_registerX86; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).enterRegisterX86(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).exitRegisterX86(this);
		}
	}

	public final RegisterX86Context registerX86() throws RecognitionException {
		RegisterX86Context _localctx = new RegisterX86Context(_ctx, getState());
		enterRule(_localctx, 26, RULE_registerX86);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(184);
			((RegisterX86Context)_localctx).r = _input.LT(1);
			_la = _input.LA(1);
			if ( !((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__28) | (1L << T__29) | (1L << T__30) | (1L << T__31))) != 0)) ) {
				((RegisterX86Context)_localctx).r = (Token)_errHandler.recoverInline(this);
			}
			else {
				if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
				_errHandler.reportMatch(this);
				consume();
			}
			((RegisterX86Context)_localctx).reg =  new Register(((RegisterX86Context)_localctx).r.getText());
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

	public static class ThreadsContext extends ParserRuleContext {
		public List<Thread> lst;
		public WordContext mainThread;
		public InstContext t1;
		public InstContext t2;
		public List<WordContext> word() {
			return getRuleContexts(WordContext.class);
		}
		public WordContext word(int i) {
			return getRuleContext(WordContext.class,i);
		}
		public List<InstContext> inst() {
			return getRuleContexts(InstContext.class);
		}
		public InstContext inst(int i) {
			return getRuleContext(InstContext.class,i);
		}
		public List<TerminalNode> WS() { return getTokens(LitmusParser.WS); }
		public TerminalNode WS(int i) {
			return getToken(LitmusParser.WS, i);
		}
		public ThreadsContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_threads; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).enterThreads(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).exitThreads(this);
		}
	}

	public final ThreadsContext threads() throws RecognitionException {
		ThreadsContext _localctx = new ThreadsContext(_ctx, getState());
		enterRule(_localctx, 28, RULE_threads);
		int _la;
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(195); 
			_errHandler.sync(this);
			_la = _input.LA(1);
			do {
				{
				{
				setState(187);
				((ThreadsContext)_localctx).mainThread = word();

						if(!mapRegs.keySet().contains(((ThreadsContext)_localctx).mainThread.str)) {
							mapRegs.put(((ThreadsContext)_localctx).mainThread.str, new HashMap<String, Register>());
						}
					
				setState(192);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while (_la==T__32) {
					{
					{
					setState(189);
					match(T__32);
					}
					}
					setState(194);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				}
				}
				setState(197); 
				_errHandler.sync(this);
				_la = _input.LA(1);
			} while ( _la==LETTER || _la==DIGIT );
			setState(199);
			match(T__8);
			Integer thread = 0;
			setState(218); 
			_errHandler.sync(this);
			_alt = 1;
			do {
				switch (_alt) {
				case 1:
					{
					{
					setState(201);
					((ThreadsContext)_localctx).t1 = inst(thread.toString());

							if(!mapThreads.keySet().contains(thread.toString())) {
									mapThreads.put(thread.toString(), new ArrayList<Thread>());
							}
							mapThreads.get(thread.toString()).add(((ThreadsContext)_localctx).t1.t);
						
					setState(212);
					_errHandler.sync(this);
					_la = _input.LA(1);
					while (_la==T__32) {
						{
						{
						thread ++;
						setState(204);
						match(T__32);
						setState(207);
						_errHandler.sync(this);
						switch (_input.LA(1)) {
						case T__8:
						case T__32:
						case T__33:
						case T__34:
						case T__35:
						case T__37:
						case T__39:
						case T__40:
						case T__41:
						case T__42:
						case T__43:
						case T__44:
						case T__45:
						case LWSYNC:
						case SYNC:
						case ISYNC:
							{
							setState(205);
							((ThreadsContext)_localctx).t2 = inst(thread.toString());
							}
							break;
						case WS:
							{
							setState(206);
							match(WS);
							}
							break;
						default:
							throw new NoViableAltException(this);
						}

								if(!mapThreads.keySet().contains(thread.toString())) {
										mapThreads.put(thread.toString(), new ArrayList<Thread>());
								}
								mapThreads.get(thread.toString()).add(((ThreadsContext)_localctx).t2.t);
							
						}
						}
						setState(214);
						_errHandler.sync(this);
						_la = _input.LA(1);
					}
					setState(215);
					match(T__8);
					thread = 0;
					}
					}
					break;
				default:
					throw new NoViableAltException(this);
				}
				setState(220); 
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,15,_ctx);
			} while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER );

					List threads = new ArrayList<Thread>();
					for(String k : mapThreads.keySet()) {
						If lastIf = null;
						Thread partialThread = null;
						Thread partialIfBody = null;
						for(Thread t : mapThreads.get(k)) {
							if(t != null) {
								if(partialThread == null && lastIf == null) {
									partialThread = t;
								}
								else if(lastIf == null){
									partialThread = new Seq(partialThread, t);
								}
								if(partialIfBody == null) {
									partialIfBody = t;
								}
								else {
									partialIfBody = new Seq(partialIfBody, t);
								}
								if(t instanceof If) {
									if(lastIf != null) {
										partialIfBody.incCondLevel();
										lastIf.setT1(partialIfBody);
									}
									partialIfBody = null;
									lastIf = (If) t;
								}
							}
						}
						if(lastIf != null && partialIfBody != null) {
							partialIfBody.setCondLevel(lastIf.getCondLevel()+1);
							lastIf.setT1(partialIfBody);
						}
						threads.add(partialThread);
					}
					((ThreadsContext)_localctx).lst =  threads;
				
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
		public LocalX86Context t1;
		public LoadX86Context t2;
		public StoreX86regContext t3;
		public StoreX86valContext t4;
		public MfenceContext t5;
		public LocalPowerContext t6;
		public LoadPowerContext t7;
		public StorePowerContext t8;
		public IsyncContext t9;
		public SyncContext t10;
		public LwsyncContext t11;
		public XorContext t12;
		public AddiContext t13;
		public MrContext t14;
		public CmpwContext t15;
		public LocalX86Context localX86() {
			return getRuleContext(LocalX86Context.class,0);
		}
		public LoadX86Context loadX86() {
			return getRuleContext(LoadX86Context.class,0);
		}
		public StoreX86regContext storeX86reg() {
			return getRuleContext(StoreX86regContext.class,0);
		}
		public StoreX86valContext storeX86val() {
			return getRuleContext(StoreX86valContext.class,0);
		}
		public MfenceContext mfence() {
			return getRuleContext(MfenceContext.class,0);
		}
		public LocalPowerContext localPower() {
			return getRuleContext(LocalPowerContext.class,0);
		}
		public LoadPowerContext loadPower() {
			return getRuleContext(LoadPowerContext.class,0);
		}
		public StorePowerContext storePower() {
			return getRuleContext(StorePowerContext.class,0);
		}
		public IsyncContext isync() {
			return getRuleContext(IsyncContext.class,0);
		}
		public SyncContext sync() {
			return getRuleContext(SyncContext.class,0);
		}
		public LwsyncContext lwsync() {
			return getRuleContext(LwsyncContext.class,0);
		}
		public XorContext xor() {
			return getRuleContext(XorContext.class,0);
		}
		public AddiContext addi() {
			return getRuleContext(AddiContext.class,0);
		}
		public MrContext mr() {
			return getRuleContext(MrContext.class,0);
		}
		public CmpwContext cmpw() {
			return getRuleContext(CmpwContext.class,0);
		}
		public WordContext word() {
			return getRuleContext(WordContext.class,0);
		}
		public InstContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public InstContext(ParserRuleContext parent, int invokingState, String mainThread) {
			super(parent, invokingState);
			this.mainThread = mainThread;
		}
		@Override public int getRuleIndex() { return RULE_inst; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).enterInst(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).exitInst(this);
		}
	}

	public final InstContext inst(String mainThread) throws RecognitionException {
		InstContext _localctx = new InstContext(_ctx, getState(), mainThread);
		enterRule(_localctx, 30, RULE_inst);
		try {
			setState(277);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,16,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				}
				break;
			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(225);
				((InstContext)_localctx).t1 = localX86(mainThread);
				((InstContext)_localctx).t =  ((InstContext)_localctx).t1.t;
				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(228);
				((InstContext)_localctx).t2 = loadX86(mainThread);
				((InstContext)_localctx).t =  ((InstContext)_localctx).t2.t;
				}
				break;
			case 4:
				enterOuterAlt(_localctx, 4);
				{
				setState(231);
				((InstContext)_localctx).t3 = storeX86reg(mainThread);
				((InstContext)_localctx).t =  ((InstContext)_localctx).t3.t;
				}
				break;
			case 5:
				enterOuterAlt(_localctx, 5);
				{
				setState(234);
				((InstContext)_localctx).t4 = storeX86val(mainThread);
				((InstContext)_localctx).t =  ((InstContext)_localctx).t4.t;
				}
				break;
			case 6:
				enterOuterAlt(_localctx, 6);
				{
				setState(237);
				((InstContext)_localctx).t5 = mfence();
				((InstContext)_localctx).t =  ((InstContext)_localctx).t5.t;
				}
				break;
			case 7:
				enterOuterAlt(_localctx, 7);
				{
				setState(240);
				((InstContext)_localctx).t6 = localPower(mainThread);
				((InstContext)_localctx).t =  ((InstContext)_localctx).t6.t;
				}
				break;
			case 8:
				enterOuterAlt(_localctx, 8);
				{
				setState(243);
				((InstContext)_localctx).t7 = loadPower(mainThread);
				((InstContext)_localctx).t =  ((InstContext)_localctx).t7.t;
				}
				break;
			case 9:
				enterOuterAlt(_localctx, 9);
				{
				setState(246);
				((InstContext)_localctx).t8 = storePower(mainThread);
				((InstContext)_localctx).t =  ((InstContext)_localctx).t8.t;
				}
				break;
			case 10:
				enterOuterAlt(_localctx, 10);
				{
				setState(249);
				((InstContext)_localctx).t9 = isync();
				((InstContext)_localctx).t =  ((InstContext)_localctx).t9.t;
				}
				break;
			case 11:
				enterOuterAlt(_localctx, 11);
				{
				setState(252);
				((InstContext)_localctx).t10 = sync();
				((InstContext)_localctx).t =  ((InstContext)_localctx).t10.t;
				}
				break;
			case 12:
				enterOuterAlt(_localctx, 12);
				{
				setState(255);
				((InstContext)_localctx).t11 = lwsync();
				((InstContext)_localctx).t =  ((InstContext)_localctx).t11.t;
				}
				break;
			case 13:
				enterOuterAlt(_localctx, 13);
				{
				setState(258);
				((InstContext)_localctx).t12 = xor(mainThread);
				((InstContext)_localctx).t =  ((InstContext)_localctx).t12.t;
				}
				break;
			case 14:
				enterOuterAlt(_localctx, 14);
				{
				setState(261);
				((InstContext)_localctx).t13 = addi(mainThread);
				((InstContext)_localctx).t =  ((InstContext)_localctx).t13.t;
				}
				break;
			case 15:
				enterOuterAlt(_localctx, 15);
				{
				setState(264);
				((InstContext)_localctx).t14 = mr(mainThread);
				((InstContext)_localctx).t =  ((InstContext)_localctx).t14.t;
				}
				break;
			case 16:
				enterOuterAlt(_localctx, 16);
				{
				setState(267);
				((InstContext)_localctx).t15 = cmpw(mainThread);
				((InstContext)_localctx).t =  ((InstContext)_localctx).t15.t;
				}
				break;
			case 17:
				enterOuterAlt(_localctx, 17);
				{
				setState(270);
				match(T__33);
				setState(271);
				match(T__34);
				setState(272);
				word();
				}
				break;
			case 18:
				enterOuterAlt(_localctx, 18);
				{
				setState(273);
				match(T__34);
				setState(274);
				word();
				setState(275);
				match(T__9);
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

	public static class LocalX86Context extends ParserRuleContext {
		public String mainThread;
		public Thread t;
		public RegisterX86Context r;
		public Token d;
		public RegisterX86Context registerX86() {
			return getRuleContext(RegisterX86Context.class,0);
		}
		public TerminalNode DIGIT() { return getToken(LitmusParser.DIGIT, 0); }
		public LocalX86Context(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public LocalX86Context(ParserRuleContext parent, int invokingState, String mainThread) {
			super(parent, invokingState);
			this.mainThread = mainThread;
		}
		@Override public int getRuleIndex() { return RULE_localX86; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).enterLocalX86(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).exitLocalX86(this);
		}
	}

	public final LocalX86Context localX86(String mainThread) throws RecognitionException {
		LocalX86Context _localctx = new LocalX86Context(_ctx, getState(), mainThread);
		enterRule(_localctx, 32, RULE_localX86);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(279);
			match(T__35);
			setState(280);
			((LocalX86Context)_localctx).r = registerX86();
			setState(281);
			match(T__36);
			setState(282);
			((LocalX86Context)_localctx).d = match(DIGIT);

					Map<String, Register> mapThreadRegs = mapRegs.get(mainThread);
					if(!(mapThreadRegs.keySet().contains(((LocalX86Context)_localctx).r.reg.getName()))) {
						mapThreadRegs.put(((LocalX86Context)_localctx).r.reg.getName(), ((LocalX86Context)_localctx).r.reg);
					}
					Register pointerReg = mapThreadRegs.get(((LocalX86Context)_localctx).r.reg.getName());
					((LocalX86Context)_localctx).t =  new Local(pointerReg, new AConst(Integer.parseInt(((LocalX86Context)_localctx).d.getText())));
				
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

	public static class LocalPowerContext extends ParserRuleContext {
		public String mainThread;
		public Thread t;
		public RegisterPowerContext r;
		public Token d;
		public RegisterPowerContext registerPower() {
			return getRuleContext(RegisterPowerContext.class,0);
		}
		public TerminalNode DIGIT() { return getToken(LitmusParser.DIGIT, 0); }
		public LocalPowerContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public LocalPowerContext(ParserRuleContext parent, int invokingState, String mainThread) {
			super(parent, invokingState);
			this.mainThread = mainThread;
		}
		@Override public int getRuleIndex() { return RULE_localPower; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).enterLocalPower(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).exitLocalPower(this);
		}
	}

	public final LocalPowerContext localPower(String mainThread) throws RecognitionException {
		LocalPowerContext _localctx = new LocalPowerContext(_ctx, getState(), mainThread);
		enterRule(_localctx, 34, RULE_localPower);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(285);
			match(T__37);
			setState(286);
			((LocalPowerContext)_localctx).r = registerPower();
			setState(287);
			match(T__38);
			setState(288);
			((LocalPowerContext)_localctx).d = match(DIGIT);

					Map<String, Register> mapThreadRegs = mapRegs.get(mainThread);
					if(!(mapThreadRegs.keySet().contains(((LocalPowerContext)_localctx).r.reg.getName()))) {
						mapThreadRegs.put(((LocalPowerContext)_localctx).r.reg.getName(), ((LocalPowerContext)_localctx).r.reg);
					}
					Register pointerReg = mapThreadRegs.get(((LocalPowerContext)_localctx).r.reg.getName());
					((LocalPowerContext)_localctx).t =  new Local(pointerReg, new AConst(Integer.parseInt(((LocalPowerContext)_localctx).d.getText())));
				
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

	public static class XorContext extends ParserRuleContext {
		public String mainThread;
		public Thread t;
		public RegisterPowerContext r1;
		public RegisterPowerContext r2;
		public RegisterPowerContext r3;
		public List<RegisterPowerContext> registerPower() {
			return getRuleContexts(RegisterPowerContext.class);
		}
		public RegisterPowerContext registerPower(int i) {
			return getRuleContext(RegisterPowerContext.class,i);
		}
		public XorContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public XorContext(ParserRuleContext parent, int invokingState, String mainThread) {
			super(parent, invokingState);
			this.mainThread = mainThread;
		}
		@Override public int getRuleIndex() { return RULE_xor; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).enterXor(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).exitXor(this);
		}
	}

	public final XorContext xor(String mainThread) throws RecognitionException {
		XorContext _localctx = new XorContext(_ctx, getState(), mainThread);
		enterRule(_localctx, 36, RULE_xor);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(291);
			match(T__39);
			setState(292);
			((XorContext)_localctx).r1 = registerPower();
			setState(293);
			match(T__38);
			setState(294);
			((XorContext)_localctx).r2 = registerPower();
			setState(295);
			match(T__38);
			setState(296);
			((XorContext)_localctx).r3 = registerPower();

					Map<String, Register> mapThreadRegs = mapRegs.get(mainThread);
					if(!(mapThreadRegs.keySet().contains(((XorContext)_localctx).r1.reg.getName()))) {
						mapThreadRegs.put(((XorContext)_localctx).r1.reg.getName(), ((XorContext)_localctx).r1.reg);
					}
					if(!(mapThreadRegs.keySet().contains(((XorContext)_localctx).r2.reg.getName()))) {
						mapThreadRegs.put(((XorContext)_localctx).r2.reg.getName(), ((XorContext)_localctx).r2.reg);
					}
					if(!(mapThreadRegs.keySet().contains(((XorContext)_localctx).r3.reg.getName()))) {
						mapThreadRegs.put(((XorContext)_localctx).r3.reg.getName(), ((XorContext)_localctx).r3.reg);
					}
					Register pointerReg1 = mapThreadRegs.get(((XorContext)_localctx).r1.reg.getName());
					Register pointerReg2 = mapThreadRegs.get(((XorContext)_localctx).r2.reg.getName());
					Register pointerReg3 = mapThreadRegs.get(((XorContext)_localctx).r3.reg.getName());
					((XorContext)_localctx).t =  new Local(pointerReg1, new AExpr(pointerReg2, "xor", pointerReg3));
				
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

	public static class AddiContext extends ParserRuleContext {
		public String mainThread;
		public Thread t;
		public RegisterPowerContext r1;
		public RegisterPowerContext r2;
		public Token d;
		public List<RegisterPowerContext> registerPower() {
			return getRuleContexts(RegisterPowerContext.class);
		}
		public RegisterPowerContext registerPower(int i) {
			return getRuleContext(RegisterPowerContext.class,i);
		}
		public TerminalNode DIGIT() { return getToken(LitmusParser.DIGIT, 0); }
		public AddiContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public AddiContext(ParserRuleContext parent, int invokingState, String mainThread) {
			super(parent, invokingState);
			this.mainThread = mainThread;
		}
		@Override public int getRuleIndex() { return RULE_addi; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).enterAddi(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).exitAddi(this);
		}
	}

	public final AddiContext addi(String mainThread) throws RecognitionException {
		AddiContext _localctx = new AddiContext(_ctx, getState(), mainThread);
		enterRule(_localctx, 38, RULE_addi);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(299);
			match(T__40);
			setState(300);
			((AddiContext)_localctx).r1 = registerPower();
			setState(301);
			match(T__38);
			setState(302);
			((AddiContext)_localctx).r2 = registerPower();
			setState(303);
			match(T__38);
			setState(304);
			((AddiContext)_localctx).d = match(DIGIT);

					Map<String, Register> mapThreadRegs = mapRegs.get(mainThread);
					if(!(mapThreadRegs.keySet().contains(((AddiContext)_localctx).r1.reg.getName()))) {
						mapThreadRegs.put(((AddiContext)_localctx).r1.reg.getName(), ((AddiContext)_localctx).r1.reg);
					}
					if(!(mapThreadRegs.keySet().contains(((AddiContext)_localctx).r2.reg.getName()))) {
						mapThreadRegs.put(((AddiContext)_localctx).r2.reg.getName(), ((AddiContext)_localctx).r2.reg);
					}
					Register pointerReg1 = mapThreadRegs.get(((AddiContext)_localctx).r1.reg.getName());
					Register pointerReg2 = mapThreadRegs.get(((AddiContext)_localctx).r2.reg.getName());
					((AddiContext)_localctx).t =  new Local(pointerReg1, new AExpr(pointerReg2, "+", new AConst(Integer.parseInt(((AddiContext)_localctx).d.getText()))));
				
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

	public static class MrContext extends ParserRuleContext {
		public String mainThread;
		public Thread t;
		public RegisterPowerContext r1;
		public RegisterPowerContext r2;
		public List<RegisterPowerContext> registerPower() {
			return getRuleContexts(RegisterPowerContext.class);
		}
		public RegisterPowerContext registerPower(int i) {
			return getRuleContext(RegisterPowerContext.class,i);
		}
		public MrContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public MrContext(ParserRuleContext parent, int invokingState, String mainThread) {
			super(parent, invokingState);
			this.mainThread = mainThread;
		}
		@Override public int getRuleIndex() { return RULE_mr; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).enterMr(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).exitMr(this);
		}
	}

	public final MrContext mr(String mainThread) throws RecognitionException {
		MrContext _localctx = new MrContext(_ctx, getState(), mainThread);
		enterRule(_localctx, 40, RULE_mr);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(307);
			match(T__41);
			setState(308);
			((MrContext)_localctx).r1 = registerPower();
			setState(309);
			match(T__38);
			setState(310);
			((MrContext)_localctx).r2 = registerPower();

					Map<String, Register> mapThreadRegs = mapRegs.get(mainThread);
					if(!(mapThreadRegs.keySet().contains(((MrContext)_localctx).r1.reg.getName()))) {
						mapThreadRegs.put(((MrContext)_localctx).r1.reg.getName(), ((MrContext)_localctx).r1.reg);
					}
					if(!(mapThreadRegs.keySet().contains(((MrContext)_localctx).r2.reg.getName()))) {
						mapThreadRegs.put(((MrContext)_localctx).r2.reg.getName(), ((MrContext)_localctx).r2.reg);
					}
					Register pointerReg1 = mapThreadRegs.get(((MrContext)_localctx).r1.reg.getName());
					Register pointerReg2 = mapThreadRegs.get(((MrContext)_localctx).r2.reg.getName());
					((MrContext)_localctx).t =  new Local(pointerReg1, pointerReg2);
				
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

	public static class LoadX86Context extends ParserRuleContext {
		public String mainThread;
		public Thread t;
		public RegisterX86Context r;
		public LocationX86Context l;
		public RegisterX86Context registerX86() {
			return getRuleContext(RegisterX86Context.class,0);
		}
		public LocationX86Context locationX86() {
			return getRuleContext(LocationX86Context.class,0);
		}
		public LoadX86Context(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public LoadX86Context(ParserRuleContext parent, int invokingState, String mainThread) {
			super(parent, invokingState);
			this.mainThread = mainThread;
		}
		@Override public int getRuleIndex() { return RULE_loadX86; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).enterLoadX86(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).exitLoadX86(this);
		}
	}

	public final LoadX86Context loadX86(String mainThread) throws RecognitionException {
		LoadX86Context _localctx = new LoadX86Context(_ctx, getState(), mainThread);
		enterRule(_localctx, 42, RULE_loadX86);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(313);
			match(T__35);
			setState(314);
			((LoadX86Context)_localctx).r = registerX86();
			setState(315);
			match(T__38);
			setState(316);
			((LoadX86Context)_localctx).l = locationX86();

					Map<String, Register> mapThreadRegs = mapRegs.get(mainThread);
					if(!(mapThreadRegs.keySet().contains(((LoadX86Context)_localctx).r.reg.getName()))) {
						mapThreadRegs.put(((LoadX86Context)_localctx).r.reg.getName(), ((LoadX86Context)_localctx).r.reg);
					}
					if(!(mapLocs.keySet().contains(((LoadX86Context)_localctx).l.loc.getName()))) {
						//System.out.println(String.format("Location %s must be initialized", ((LoadX86Context)_localctx).l.loc.getName()));
						mapLocs.put(((LoadX86Context)_localctx).l.loc.getName(), ((LoadX86Context)_localctx).l.loc);
					}
					Register pointerReg = mapThreadRegs.get(((LoadX86Context)_localctx).r.reg.getName());
					Location pointerLoc = mapLocs.get(((LoadX86Context)_localctx).l.loc.getName());
					//((LoadX86Context)_localctx).t =  new Load(pointerReg, pointerLoc);
					((LoadX86Context)_localctx).t =  new Read(pointerReg, pointerLoc, "_rx");
				
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

	public static class LoadPowerContext extends ParserRuleContext {
		public String mainThread;
		public Thread t;
		public RegisterPowerContext r;
		public Token s;
		public RegisterPowerContext rl;
		public List<RegisterPowerContext> registerPower() {
			return getRuleContexts(RegisterPowerContext.class);
		}
		public RegisterPowerContext registerPower(int i) {
			return getRuleContext(RegisterPowerContext.class,i);
		}
		public TerminalNode DIGIT() { return getToken(LitmusParser.DIGIT, 0); }
		public LoadPowerContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public LoadPowerContext(ParserRuleContext parent, int invokingState, String mainThread) {
			super(parent, invokingState);
			this.mainThread = mainThread;
		}
		@Override public int getRuleIndex() { return RULE_loadPower; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).enterLoadPower(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).exitLoadPower(this);
		}
	}

	public final LoadPowerContext loadPower(String mainThread) throws RecognitionException {
		LoadPowerContext _localctx = new LoadPowerContext(_ctx, getState(), mainThread);
		enterRule(_localctx, 44, RULE_loadPower);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(319);
			match(T__42);
			setState(320);
			((LoadPowerContext)_localctx).r = registerPower();
			setState(321);
			match(T__38);
			setState(322);
			((LoadPowerContext)_localctx).s = match(DIGIT);
			setState(323);
			_la = _input.LA(1);
			if ( !(_la==T__5 || _la==T__38) ) {
			_errHandler.recoverInline(this);
			}
			else {
				if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
				_errHandler.reportMatch(this);
				consume();
			}
			setState(324);
			((LoadPowerContext)_localctx).rl = registerPower();
			setState(328);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==T__6) {
				{
				{
				setState(325);
				match(T__6);
				}
				}
				setState(330);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}

					Map<String, Register> mapThreadRegs = mapRegs.get(mainThread);
					if(!(mapThreadRegs.keySet().contains(((LoadPowerContext)_localctx).r.reg.getName()))) {
						mapThreadRegs.put(((LoadPowerContext)_localctx).r.reg.getName(), ((LoadPowerContext)_localctx).r.reg);
					}
					if(!(mapRegLoc.get(mainThread).keySet().contains(((LoadPowerContext)_localctx).rl.reg.getName()))) {
						System.out.println(String.format("Register %s must be initialized to a location", ((LoadPowerContext)_localctx).rl.reg.getName()));
					}
					Register pointerReg = mapThreadRegs.get(((LoadPowerContext)_localctx).r.reg.getName());
					Location pointerLoc = mapRegLoc.get(mainThread).get(((LoadPowerContext)_localctx).rl.reg.getName());
					//((LoadPowerContext)_localctx).t =  new Load(pointerReg, pointerLoc);
					((LoadPowerContext)_localctx).t =  new Read(pointerReg, pointerLoc, "_rx");
				
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

	public static class StoreX86regContext extends ParserRuleContext {
		public String mainThread;
		public Thread t;
		public LocationX86Context l;
		public RegisterX86Context r;
		public LocationX86Context locationX86() {
			return getRuleContext(LocationX86Context.class,0);
		}
		public RegisterX86Context registerX86() {
			return getRuleContext(RegisterX86Context.class,0);
		}
		public StoreX86regContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public StoreX86regContext(ParserRuleContext parent, int invokingState, String mainThread) {
			super(parent, invokingState);
			this.mainThread = mainThread;
		}
		@Override public int getRuleIndex() { return RULE_storeX86reg; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).enterStoreX86reg(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).exitStoreX86reg(this);
		}
	}

	public final StoreX86regContext storeX86reg(String mainThread) throws RecognitionException {
		StoreX86regContext _localctx = new StoreX86regContext(_ctx, getState(), mainThread);
		enterRule(_localctx, 46, RULE_storeX86reg);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(333);
			match(T__35);
			setState(334);
			((StoreX86regContext)_localctx).l = locationX86();
			setState(335);
			match(T__38);
			setState(336);
			((StoreX86regContext)_localctx).r = registerX86();

			        if(!(mapLocs.keySet().contains(((StoreX86regContext)_localctx).l.loc.getName()))) {
			            System.out.println(String.format("Location %s must be initialized", ((StoreX86regContext)_localctx).l.loc.getName()));
			        }
			        Map<String, Register> mapThreadRegs = mapRegs.get(mainThread);
			        if(!(mapThreadRegs.keySet().contains(((StoreX86regContext)_localctx).r.reg.getName()))) {
			            System.out.println(String.format("Register %s must be initialized", ((StoreX86regContext)_localctx).r.reg.getName()));
			        }
			        Register pointerReg = mapThreadRegs.get(((StoreX86regContext)_localctx).r.reg.getName());
			        Location pointerLoc = mapLocs.get(((StoreX86regContext)_localctx).l.loc.getName());
			            //((StoreX86regContext)_localctx).t =  new Store(pointerLoc, pointerReg);
			            ((StoreX86regContext)_localctx).t =  new Write(pointerLoc, pointerReg, "_rx");
			        
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

	public static class StoreX86valContext extends ParserRuleContext {
		public String mainThread;
		public Thread t;
		public LocationX86Context l;
		public Token value;
		public LocationX86Context locationX86() {
			return getRuleContext(LocationX86Context.class,0);
		}
		public TerminalNode DIGIT() { return getToken(LitmusParser.DIGIT, 0); }
		public StoreX86valContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public StoreX86valContext(ParserRuleContext parent, int invokingState, String mainThread) {
			super(parent, invokingState);
			this.mainThread = mainThread;
		}
		@Override public int getRuleIndex() { return RULE_storeX86val; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).enterStoreX86val(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).exitStoreX86val(this);
		}
	}

	public final StoreX86valContext storeX86val(String mainThread) throws RecognitionException {
		StoreX86valContext _localctx = new StoreX86valContext(_ctx, getState(), mainThread);
		enterRule(_localctx, 48, RULE_storeX86val);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(339);
			match(T__35);
			setState(340);
			((StoreX86valContext)_localctx).l = locationX86();
			setState(341);
			match(T__36);
			setState(342);
			((StoreX86valContext)_localctx).value = match(DIGIT);

			    	    if(!(mapLocs.keySet().contains(((StoreX86valContext)_localctx).l.loc.getName()))) {
			        		System.out.println(String.format("Location %s must be initialized", ((StoreX86valContext)_localctx).l.loc.getName()));
			        	}
			        	Map<String, Register> mapThreadRegs = mapRegs.get(mainThread);
			        	Location pointerLoc = mapLocs.get(((StoreX86valContext)_localctx).l.loc.getName());
			        	AConst val = new AConst(Integer.parseInt(((StoreX86valContext)_localctx).value.getText()));
			        	((StoreX86valContext)_localctx).t =  new Write(pointerLoc, val, "_rx");
			    	
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

	public static class StorePowerContext extends ParserRuleContext {
		public String mainThread;
		public Thread t;
		public RegisterPowerContext r;
		public Token s;
		public RegisterPowerContext rl;
		public List<RegisterPowerContext> registerPower() {
			return getRuleContexts(RegisterPowerContext.class);
		}
		public RegisterPowerContext registerPower(int i) {
			return getRuleContext(RegisterPowerContext.class,i);
		}
		public TerminalNode DIGIT() { return getToken(LitmusParser.DIGIT, 0); }
		public StorePowerContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public StorePowerContext(ParserRuleContext parent, int invokingState, String mainThread) {
			super(parent, invokingState);
			this.mainThread = mainThread;
		}
		@Override public int getRuleIndex() { return RULE_storePower; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).enterStorePower(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).exitStorePower(this);
		}
	}

	public final StorePowerContext storePower(String mainThread) throws RecognitionException {
		StorePowerContext _localctx = new StorePowerContext(_ctx, getState(), mainThread);
		enterRule(_localctx, 50, RULE_storePower);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(345);
			match(T__43);
			setState(346);
			((StorePowerContext)_localctx).r = registerPower();
			setState(347);
			match(T__38);
			setState(348);
			((StorePowerContext)_localctx).s = match(DIGIT);
			setState(349);
			_la = _input.LA(1);
			if ( !(_la==T__5 || _la==T__38) ) {
			_errHandler.recoverInline(this);
			}
			else {
				if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
				_errHandler.reportMatch(this);
				consume();
			}
			setState(350);
			((StorePowerContext)_localctx).rl = registerPower();
			setState(354);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==T__6) {
				{
				{
				setState(351);
				match(T__6);
				}
				}
				setState(356);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}

					if(!(mapRegLoc.get(mainThread).keySet().contains(((StorePowerContext)_localctx).rl.reg.getName()))) {
						System.out.println(String.format("Register %s must be initialized to a location", ((StorePowerContext)_localctx).rl.reg.getName()));
					}
					Map<String, Register> mapThreadRegs = mapRegs.get(mainThread);
					if(!(mapThreadRegs.keySet().contains(((StorePowerContext)_localctx).r.reg.getName()))) {
						System.out.println(String.format("Register %s must be initialized", ((StorePowerContext)_localctx).r.reg.getName()));
					}
					Register pointerReg = mapThreadRegs.get(((StorePowerContext)_localctx).r.reg.getName());
					Location pointerLoc = mapRegLoc.get(mainThread).get(((StorePowerContext)_localctx).rl.reg.getName());
					//((StorePowerContext)_localctx).t =  new Store(pointerLoc, pointerReg);
					((StorePowerContext)_localctx).t =  new Write(pointerLoc, pointerReg, "_rx");
				
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

	public static class CmpwContext extends ParserRuleContext {
		public String mainThread;
		public Thread t;
		public RegisterPowerContext r1;
		public RegisterPowerContext r2;
		public List<RegisterPowerContext> registerPower() {
			return getRuleContexts(RegisterPowerContext.class);
		}
		public RegisterPowerContext registerPower(int i) {
			return getRuleContext(RegisterPowerContext.class,i);
		}
		public CmpwContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public CmpwContext(ParserRuleContext parent, int invokingState, String mainThread) {
			super(parent, invokingState);
			this.mainThread = mainThread;
		}
		@Override public int getRuleIndex() { return RULE_cmpw; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).enterCmpw(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).exitCmpw(this);
		}
	}

	public final CmpwContext cmpw(String mainThread) throws RecognitionException {
		CmpwContext _localctx = new CmpwContext(_ctx, getState(), mainThread);
		enterRule(_localctx, 52, RULE_cmpw);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(359);
			match(T__44);
			setState(360);
			((CmpwContext)_localctx).r1 = registerPower();
			setState(361);
			match(T__38);
			setState(362);
			((CmpwContext)_localctx).r2 = registerPower();

					Map<String, Register> mapThreadRegs = mapRegs.get(mainThread);
					Register pointerReg1 = mapThreadRegs.get(((CmpwContext)_localctx).r1.reg.getName());
					Register pointerReg2 = mapThreadRegs.get(((CmpwContext)_localctx).r2.reg.getName());
					((CmpwContext)_localctx).t =  new If(new Atom(pointerReg1, "==", pointerReg2), new Skip(), new Skip());
				
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
		public Thread t;
		public MfenceContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_mfence; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).enterMfence(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).exitMfence(this);
		}
	}

	public final MfenceContext mfence() throws RecognitionException {
		MfenceContext _localctx = new MfenceContext(_ctx, getState());
		enterRule(_localctx, 54, RULE_mfence);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(365);
			match(T__45);
			((MfenceContext)_localctx).t =  new Mfence();
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
		public Thread t;
		public TerminalNode LWSYNC() { return getToken(LitmusParser.LWSYNC, 0); }
		public LwsyncContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_lwsync; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).enterLwsync(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).exitLwsync(this);
		}
	}

	public final LwsyncContext lwsync() throws RecognitionException {
		LwsyncContext _localctx = new LwsyncContext(_ctx, getState());
		enterRule(_localctx, 56, RULE_lwsync);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(368);
			match(LWSYNC);
			((LwsyncContext)_localctx).t =  new Lwsync();
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
		public Thread t;
		public TerminalNode SYNC() { return getToken(LitmusParser.SYNC, 0); }
		public SyncContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_sync; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).enterSync(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).exitSync(this);
		}
	}

	public final SyncContext sync() throws RecognitionException {
		SyncContext _localctx = new SyncContext(_ctx, getState());
		enterRule(_localctx, 58, RULE_sync);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(371);
			match(SYNC);
			((SyncContext)_localctx).t =  new Sync();
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
		public Thread t;
		public TerminalNode ISYNC() { return getToken(LitmusParser.ISYNC, 0); }
		public IsyncContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_isync; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).enterIsync(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).exitIsync(this);
		}
	}

	public final IsyncContext isync() throws RecognitionException {
		IsyncContext _localctx = new IsyncContext(_ctx, getState());
		enterRule(_localctx, 60, RULE_isync);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(374);
			match(ISYNC);
			((IsyncContext)_localctx).t =  new Isync();
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
		"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\3;\u017c\4\2\t\2\4"+
		"\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4\t\t\t\4\n\t\n\4\13\t"+
		"\13\4\f\t\f\4\r\t\r\4\16\t\16\4\17\t\17\4\20\t\20\4\21\t\21\4\22\t\22"+
		"\4\23\t\23\4\24\t\24\4\25\t\25\4\26\t\26\4\27\t\27\4\30\t\30\4\31\t\31"+
		"\4\32\t\32\4\33\t\33\4\34\t\34\4\35\t\35\4\36\t\36\4\37\t\37\4 \t \3\2"+
		"\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\3\3\3\3\3\7\3R"+
		"\n\3\f\3\16\3U\13\3\3\4\3\4\3\4\3\4\3\4\3\4\3\5\7\5^\n\5\f\5\16\5a\13"+
		"\5\3\5\3\5\3\5\3\5\3\5\3\5\3\5\3\5\3\6\7\6l\n\6\f\6\16\6o\13\6\3\6\3\6"+
		"\3\6\3\6\3\6\3\6\3\6\3\6\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3"+
		"\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\5\7\u008c\n\7\3\7\5\7\u008f\n\7\6\7\u0091"+
		"\n\7\r\7\16\7\u0092\3\b\3\b\3\t\7\t\u0098\n\t\f\t\16\t\u009b\13\t\3\n"+
		"\7\n\u009e\n\n\f\n\16\n\u00a1\13\n\3\13\6\13\u00a4\n\13\r\13\16\13\u00a5"+
		"\3\13\3\13\3\f\3\f\7\f\u00ac\n\f\f\f\16\f\u00af\13\f\3\f\3\f\3\r\3\r\3"+
		"\r\3\r\3\r\3\16\3\16\3\16\3\17\3\17\3\17\3\20\3\20\3\20\7\20\u00c1\n\20"+
		"\f\20\16\20\u00c4\13\20\6\20\u00c6\n\20\r\20\16\20\u00c7\3\20\3\20\3\20"+
		"\3\20\3\20\3\20\3\20\3\20\5\20\u00d2\n\20\3\20\7\20\u00d5\n\20\f\20\16"+
		"\20\u00d8\13\20\3\20\3\20\3\20\6\20\u00dd\n\20\r\20\16\20\u00de\3\20\3"+
		"\20\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3"+
		"\21\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3"+
		"\21\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3"+
		"\21\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3\21\5\21\u0118"+
		"\n\21\3\22\3\22\3\22\3\22\3\22\3\22\3\23\3\23\3\23\3\23\3\23\3\23\3\24"+
		"\3\24\3\24\3\24\3\24\3\24\3\24\3\24\3\25\3\25\3\25\3\25\3\25\3\25\3\25"+
		"\3\25\3\26\3\26\3\26\3\26\3\26\3\26\3\27\3\27\3\27\3\27\3\27\3\27\3\30"+
		"\3\30\3\30\3\30\3\30\3\30\3\30\7\30\u0149\n\30\f\30\16\30\u014c\13\30"+
		"\3\30\3\30\3\31\3\31\3\31\3\31\3\31\3\31\3\32\3\32\3\32\3\32\3\32\3\32"+
		"\3\33\3\33\3\33\3\33\3\33\3\33\3\33\7\33\u0163\n\33\f\33\16\33\u0166\13"+
		"\33\3\33\3\33\3\34\3\34\3\34\3\34\3\34\3\34\3\35\3\35\3\35\3\36\3\36\3"+
		"\36\3\37\3\37\3\37\3 \3 \3 \3 \2\2!\2\4\6\b\n\f\16\20\22\24\26\30\32\34"+
		"\36 \"$&(*,.\60\62\64\668:<>\2\t\3\2\3\4\3\2\5\5\3\2\7\7\3\2\64\65\3\2"+
		"\20\36\3\2\37\"\4\2\b\b))\2\u0181\2@\3\2\2\2\4S\3\2\2\2\6V\3\2\2\2\b_"+
		"\3\2\2\2\nm\3\2\2\2\f\u0090\3\2\2\2\16\u0094\3\2\2\2\20\u0099\3\2\2\2"+
		"\22\u009f\3\2\2\2\24\u00a3\3\2\2\2\26\u00a9\3\2\2\2\30\u00b2\3\2\2\2\32"+
		"\u00b7\3\2\2\2\34\u00ba\3\2\2\2\36\u00c5\3\2\2\2 \u0117\3\2\2\2\"\u0119"+
		"\3\2\2\2$\u011f\3\2\2\2&\u0125\3\2\2\2(\u012d\3\2\2\2*\u0135\3\2\2\2,"+
		"\u013b\3\2\2\2.\u0141\3\2\2\2\60\u014f\3\2\2\2\62\u0155\3\2\2\2\64\u015b"+
		"\3\2\2\2\66\u0169\3\2\2\28\u016f\3\2\2\2:\u0172\3\2\2\2<\u0175\3\2\2\2"+
		">\u0178\3\2\2\2@A\b\2\1\2AB\t\2\2\2BC\5\20\t\2CD\7\5\2\2DE\5\4\3\2EF\7"+
		"\6\2\2FG\5\36\20\2GH\b\2\1\2HI\5\22\n\2IJ\7\7\2\2JK\7\b\2\2KL\5\f\7\2"+
		"LM\7\t\2\2M\3\3\2\2\2NR\5\6\4\2OR\5\b\5\2PR\5\n\6\2QN\3\2\2\2QO\3\2\2"+
		"\2QP\3\2\2\2RU\3\2\2\2SQ\3\2\2\2ST\3\2\2\2T\5\3\2\2\2US\3\2\2\2VW\5\26"+
		"\f\2WX\7\n\2\2XY\7\65\2\2YZ\7\13\2\2Z[\b\4\1\2[\7\3\2\2\2\\^\7\64\2\2"+
		"]\\\3\2\2\2^a\3\2\2\2_]\3\2\2\2_`\3\2\2\2`b\3\2\2\2a_\3\2\2\2bc\7\65\2"+
		"\2cd\7\f\2\2de\5\32\16\2ef\7\n\2\2fg\5\26\f\2gh\7\13\2\2hi\b\5\1\2i\t"+
		"\3\2\2\2jl\7\64\2\2kj\3\2\2\2lo\3\2\2\2mk\3\2\2\2mn\3\2\2\2np\3\2\2\2"+
		"om\3\2\2\2pq\7\65\2\2qr\7\f\2\2rs\5\32\16\2st\7\n\2\2tu\7\65\2\2uv\7\13"+
		"\2\2vw\b\6\1\2w\13\3\2\2\2xy\5\26\f\2yz\7\n\2\2z{\7\65\2\2{|\b\7\1\2|"+
		"\u008c\3\2\2\2}~\7\65\2\2~\177\7\f\2\2\177\u0080\5\32\16\2\u0080\u0081"+
		"\7\n\2\2\u0081\u0082\7\65\2\2\u0082\u0083\b\7\1\2\u0083\u008c\3\2\2\2"+
		"\u0084\u0085\7\65\2\2\u0085\u0086\7\f\2\2\u0086\u0087\5\34\17\2\u0087"+
		"\u0088\7\n\2\2\u0088\u0089\7\65\2\2\u0089\u008a\b\7\1\2\u008a\u008c\3"+
		"\2\2\2\u008bx\3\2\2\2\u008b}\3\2\2\2\u008b\u0084\3\2\2\2\u008c\u008e\3"+
		"\2\2\2\u008d\u008f\5\16\b\2\u008e\u008d\3\2\2\2\u008e\u008f\3\2\2\2\u008f"+
		"\u0091\3\2\2\2\u0090\u008b\3\2\2\2\u0091\u0092\3\2\2\2\u0092\u0090\3\2"+
		"\2\2\u0092\u0093\3\2\2\2\u0093\r\3\2\2\2\u0094\u0095\7\r\2\2\u0095\17"+
		"\3\2\2\2\u0096\u0098\n\3\2\2\u0097\u0096\3\2\2\2\u0098\u009b\3\2\2\2\u0099"+
		"\u0097\3\2\2\2\u0099\u009a\3\2\2\2\u009a\21\3\2\2\2\u009b\u0099\3\2\2"+
		"\2\u009c\u009e\n\4\2\2\u009d\u009c\3\2\2\2\u009e\u00a1\3\2\2\2\u009f\u009d"+
		"\3\2\2\2\u009f\u00a0\3\2\2\2\u00a0\23\3\2\2\2\u00a1\u009f\3\2\2\2\u00a2"+
		"\u00a4\t\5\2\2\u00a3\u00a2\3\2\2\2\u00a4\u00a5\3\2\2\2\u00a5\u00a3\3\2"+
		"\2\2\u00a5\u00a6\3\2\2\2\u00a6\u00a7\3\2\2\2\u00a7\u00a8\b\13\1\2\u00a8"+
		"\25\3\2\2\2\u00a9\u00ad\7\64\2\2\u00aa\u00ac\t\5\2\2\u00ab\u00aa\3\2\2"+
		"\2\u00ac\u00af\3\2\2\2\u00ad\u00ab\3\2\2\2\u00ad\u00ae\3\2\2\2\u00ae\u00b0"+
		"\3\2\2\2\u00af\u00ad\3\2\2\2\u00b0\u00b1\b\f\1\2\u00b1\27\3\2\2\2\u00b2"+
		"\u00b3\7\16\2\2\u00b3\u00b4\5\26\f\2\u00b4\u00b5\7\17\2\2\u00b5\u00b6"+
		"\b\r\1\2\u00b6\31\3\2\2\2\u00b7\u00b8\t\6\2\2\u00b8\u00b9\b\16\1\2\u00b9"+
		"\33\3\2\2\2\u00ba\u00bb\t\7\2\2\u00bb\u00bc\b\17\1\2\u00bc\35\3\2\2\2"+
		"\u00bd\u00be\5\24\13\2\u00be\u00c2\b\20\1\2\u00bf\u00c1\7#\2\2\u00c0\u00bf"+
		"\3\2\2\2\u00c1\u00c4\3\2\2\2\u00c2\u00c0\3\2\2\2\u00c2\u00c3\3\2\2\2\u00c3"+
		"\u00c6\3\2\2\2\u00c4\u00c2\3\2\2\2\u00c5\u00bd\3\2\2\2\u00c6\u00c7\3\2"+
		"\2\2\u00c7\u00c5\3\2\2\2\u00c7\u00c8\3\2\2\2\u00c8\u00c9\3\2\2\2\u00c9"+
		"\u00ca\7\13\2\2\u00ca\u00dc\b\20\1\2\u00cb\u00cc\5 \21\2\u00cc\u00d6\b"+
		"\20\1\2\u00cd\u00ce\b\20\1\2\u00ce\u00d1\7#\2\2\u00cf\u00d2\5 \21\2\u00d0"+
		"\u00d2\78\2\2\u00d1\u00cf\3\2\2\2\u00d1\u00d0\3\2\2\2\u00d2\u00d3\3\2"+
		"\2\2\u00d3\u00d5\b\20\1\2\u00d4\u00cd\3\2\2\2\u00d5\u00d8\3\2\2\2\u00d6"+
		"\u00d4\3\2\2\2\u00d6\u00d7\3\2\2\2\u00d7\u00d9\3\2\2\2\u00d8\u00d6\3\2"+
		"\2\2\u00d9\u00da\7\13\2\2\u00da\u00db\b\20\1\2\u00db\u00dd\3\2\2\2\u00dc"+
		"\u00cb\3\2\2\2\u00dd\u00de\3\2\2\2\u00de\u00dc\3\2\2\2\u00de\u00df\3\2"+
		"\2\2\u00df\u00e0\3\2\2\2\u00e0\u00e1\b\20\1\2\u00e1\37\3\2\2\2\u00e2\u0118"+
		"\3\2\2\2\u00e3\u00e4\5\"\22\2\u00e4\u00e5\b\21\1\2\u00e5\u0118\3\2\2\2"+
		"\u00e6\u00e7\5,\27\2\u00e7\u00e8\b\21\1\2\u00e8\u0118\3\2\2\2\u00e9\u00ea"+
		"\5\60\31\2\u00ea\u00eb\b\21\1\2\u00eb\u0118\3\2\2\2\u00ec\u00ed\5\62\32"+
		"\2\u00ed\u00ee\b\21\1\2\u00ee\u0118\3\2\2\2\u00ef\u00f0\58\35\2\u00f0"+
		"\u00f1\b\21\1\2\u00f1\u0118\3\2\2\2\u00f2\u00f3\5$\23\2\u00f3\u00f4\b"+
		"\21\1\2\u00f4\u0118\3\2\2\2\u00f5\u00f6\5.\30\2\u00f6\u00f7\b\21\1\2\u00f7"+
		"\u0118\3\2\2\2\u00f8\u00f9\5\64\33\2\u00f9\u00fa\b\21\1\2\u00fa\u0118"+
		"\3\2\2\2\u00fb\u00fc\5> \2\u00fc\u00fd\b\21\1\2\u00fd\u0118\3\2\2\2\u00fe"+
		"\u00ff\5<\37\2\u00ff\u0100\b\21\1\2\u0100\u0118\3\2\2\2\u0101\u0102\5"+
		":\36\2\u0102\u0103\b\21\1\2\u0103\u0118\3\2\2\2\u0104\u0105\5&\24\2\u0105"+
		"\u0106\b\21\1\2\u0106\u0118\3\2\2\2\u0107\u0108\5(\25\2\u0108\u0109\b"+
		"\21\1\2\u0109\u0118\3\2\2\2\u010a\u010b\5*\26\2\u010b\u010c\b\21\1\2\u010c"+
		"\u0118\3\2\2\2\u010d\u010e\5\66\34\2\u010e\u010f\b\21\1\2\u010f\u0118"+
		"\3\2\2\2\u0110\u0111\7$\2\2\u0111\u0112\7%\2\2\u0112\u0118\5\24\13\2\u0113"+
		"\u0114\7%\2\2\u0114\u0115\5\24\13\2\u0115\u0116\7\f\2\2\u0116\u0118\3"+
		"\2\2\2\u0117\u00e2\3\2\2\2\u0117\u00e3\3\2\2\2\u0117\u00e6\3\2\2\2\u0117"+
		"\u00e9\3\2\2\2\u0117\u00ec\3\2\2\2\u0117\u00ef\3\2\2\2\u0117\u00f2\3\2"+
		"\2\2\u0117\u00f5\3\2\2\2\u0117\u00f8\3\2\2\2\u0117\u00fb\3\2\2\2\u0117"+
		"\u00fe\3\2\2\2\u0117\u0101\3\2\2\2\u0117\u0104\3\2\2\2\u0117\u0107\3\2"+
		"\2\2\u0117\u010a\3\2\2\2\u0117\u010d\3\2\2\2\u0117\u0110\3\2\2\2\u0117"+
		"\u0113\3\2\2\2\u0118!\3\2\2\2\u0119\u011a\7&\2\2\u011a\u011b\5\34\17\2"+
		"\u011b\u011c\7\'\2\2\u011c\u011d\7\65\2\2\u011d\u011e\b\22\1\2\u011e#"+
		"\3\2\2\2\u011f\u0120\7(\2\2\u0120\u0121\5\32\16\2\u0121\u0122\7)\2\2\u0122"+
		"\u0123\7\65\2\2\u0123\u0124\b\23\1\2\u0124%\3\2\2\2\u0125\u0126\7*\2\2"+
		"\u0126\u0127\5\32\16\2\u0127\u0128\7)\2\2\u0128\u0129\5\32\16\2\u0129"+
		"\u012a\7)\2\2\u012a\u012b\5\32\16\2\u012b\u012c\b\24\1\2\u012c\'\3\2\2"+
		"\2\u012d\u012e\7+\2\2\u012e\u012f\5\32\16\2\u012f\u0130\7)\2\2\u0130\u0131"+
		"\5\32\16\2\u0131\u0132\7)\2\2\u0132\u0133\7\65\2\2\u0133\u0134\b\25\1"+
		"\2\u0134)\3\2\2\2\u0135\u0136\7,\2\2\u0136\u0137\5\32\16\2\u0137\u0138"+
		"\7)\2\2\u0138\u0139\5\32\16\2\u0139\u013a\b\26\1\2\u013a+\3\2\2\2\u013b"+
		"\u013c\7&\2\2\u013c\u013d\5\34\17\2\u013d\u013e\7)\2\2\u013e\u013f\5\30"+
		"\r\2\u013f\u0140\b\27\1\2\u0140-\3\2\2\2\u0141\u0142\7-\2\2\u0142\u0143"+
		"\5\32\16\2\u0143\u0144\7)\2\2\u0144\u0145\7\65\2\2\u0145\u0146\t\b\2\2"+
		"\u0146\u014a\5\32\16\2\u0147\u0149\7\t\2\2\u0148\u0147\3\2\2\2\u0149\u014c"+
		"\3\2\2\2\u014a\u0148\3\2\2\2\u014a\u014b\3\2\2\2\u014b\u014d\3\2\2\2\u014c"+
		"\u014a\3\2\2\2\u014d\u014e\b\30\1\2\u014e/\3\2\2\2\u014f\u0150\7&\2\2"+
		"\u0150\u0151\5\30\r\2\u0151\u0152\7)\2\2\u0152\u0153\5\34\17\2\u0153\u0154"+
		"\b\31\1\2\u0154\61\3\2\2\2\u0155\u0156\7&\2\2\u0156\u0157\5\30\r\2\u0157"+
		"\u0158\7\'\2\2\u0158\u0159\7\65\2\2\u0159\u015a\b\32\1\2\u015a\63\3\2"+
		"\2\2\u015b\u015c\7.\2\2\u015c\u015d\5\32\16\2\u015d\u015e\7)\2\2\u015e"+
		"\u015f\7\65\2\2\u015f\u0160\t\b\2\2\u0160\u0164\5\32\16\2\u0161\u0163"+
		"\7\t\2\2\u0162\u0161\3\2\2\2\u0163\u0166\3\2\2\2\u0164\u0162\3\2\2\2\u0164"+
		"\u0165\3\2\2\2\u0165\u0167\3\2\2\2\u0166\u0164\3\2\2\2\u0167\u0168\b\33"+
		"\1\2\u0168\65\3\2\2\2\u0169\u016a\7/\2\2\u016a\u016b\5\32\16\2\u016b\u016c"+
		"\7)\2\2\u016c\u016d\5\32\16\2\u016d\u016e\b\34\1\2\u016e\67\3\2\2\2\u016f"+
		"\u0170\7\60\2\2\u0170\u0171\b\35\1\2\u01719\3\2\2\2\u0172\u0173\79\2\2"+
		"\u0173\u0174\b\36\1\2\u0174;\3\2\2\2\u0175\u0176\7:\2\2\u0176\u0177\b"+
		"\37\1\2\u0177=\3\2\2\2\u0178\u0179\7;\2\2\u0179\u017a\b \1\2\u017a?\3"+
		"\2\2\2\25QS_m\u008b\u008e\u0092\u0099\u009f\u00a5\u00ad\u00c2\u00c7\u00d1"+
		"\u00d6\u00de\u0117\u014a\u0164";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}