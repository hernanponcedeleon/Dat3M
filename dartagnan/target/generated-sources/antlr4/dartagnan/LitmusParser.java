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
		T__45=46, T__46=47, T__47=48, T__48=49, T__49=50, T__50=51, T__51=52, 
		T__52=53, T__53=54, T__54=55, T__55=56, T__56=57, T__57=58, T__58=59, 
		T__59=60, T__60=61, T__61=62, T__62=63, T__63=64, T__64=65, T__65=66, 
		T__66=67, T__67=68, T__68=69, T__69=70, ARCH=71, X86=72, POWER=73, LETTER=74, 
		DIGIT=75, MONIO=76, SYMBOL=77, WS=78, LWSYNC=79, SYNC=80, ISYNC=81;
	public static final int
		RULE_program = 0, RULE_bop = 1, RULE_text = 2, RULE_word = 3, RULE_location = 4, 
		RULE_locationX86 = 5, RULE_registerPower = 6, RULE_registerX86 = 7, RULE_threads = 8, 
		RULE_inst = 9, RULE_localX86 = 10, RULE_localPower = 11, RULE_xor = 12, 
		RULE_addi = 13, RULE_mr = 14, RULE_loadX86 = 15, RULE_loadPower = 16, 
		RULE_storeX86 = 17, RULE_storePower = 18, RULE_cmpw = 19, RULE_mfence = 20, 
		RULE_lwsync = 21, RULE_sync = 22, RULE_isync = 23;
	public static final String[] ruleNames = {
		"program", "bop", "text", "word", "location", "locationX86", "registerPower", 
		"registerX86", "threads", "inst", "localX86", "localPower", "xor", "addi", 
		"mr", "loadX86", "loadPower", "storeX86", "storePower", "cmpw", "mfence", 
		"lwsync", "sync", "isync"
	};

	private static final String[] _LITERAL_NAMES = {
		null, "'PPC'", "'X86'", "'{'", "'='", "';'", "':'", "'}'", "'exists'", 
		"'('", "')'", "'/\\'", "'\\/'", "'li'", "',0'", "'!'", "'\\'", "'@'", 
		"'#'", "'\u20AC'", "'%'", "'&'", "'/'", "'['", "']'", "'$'", "'|'", "'?'", 
		"'+'", "'`'", "'\u00B4'", "'^'", "'\u00A8'", "'*'", "','", "'.'", "'-'", 
		"'_'", "'>'", "'<'", "'\"'", "'r0'", "'r1'", "'r2'", "'r3'", "'r4'", "'r5'", 
		"'r6'", "'r7'", "'r8'", "'r9'", "'r10'", "'r11'", "'r12'", "'r13'", "'r14'", 
		"'EAX'", "'EBX'", "'ECX'", "'EDX'", "'beq'", "'LC'", "'MOV'", "',$'", 
		"'xor'", "'addi'", "'mr'", "'lwz'", "'stw'", "'cmpw'", "'MFENCE'", null, 
		null, null, null, null, "'~'", null, null, "'lwsync'", "'sync'", "'isync'"
	};
	private static final String[] _SYMBOLIC_NAMES = {
		null, null, null, null, null, null, null, null, null, null, null, null, 
		null, null, null, null, null, null, null, null, null, null, null, null, 
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
		public LocationContext l;
		public Token thrd;
		public RegisterPowerContext r;
		public Token d;
		public ThreadsContext threadsList;
		public Token value;
		public ThreadsContext threads() {
			return getRuleContext(ThreadsContext.class,0);
		}
		public List<TextContext> text() {
			return getRuleContexts(TextContext.class);
		}
		public TextContext text(int i) {
			return getRuleContext(TextContext.class,i);
		}
		public List<TerminalNode> DIGIT() { return getTokens(LitmusParser.DIGIT); }
		public TerminalNode DIGIT(int i) {
			return getToken(LitmusParser.DIGIT, i);
		}
		public List<LocationContext> location() {
			return getRuleContexts(LocationContext.class);
		}
		public LocationContext location(int i) {
			return getRuleContext(LocationContext.class,i);
		}
		public List<RegisterPowerContext> registerPower() {
			return getRuleContexts(RegisterPowerContext.class);
		}
		public RegisterPowerContext registerPower(int i) {
			return getRuleContext(RegisterPowerContext.class,i);
		}
		public List<TerminalNode> LETTER() { return getTokens(LitmusParser.LETTER); }
		public TerminalNode LETTER(int i) {
			return getToken(LitmusParser.LETTER, i);
		}
		public List<TerminalNode> MONIO() { return getTokens(LitmusParser.MONIO); }
		public TerminalNode MONIO(int i) {
			return getToken(LitmusParser.MONIO, i);
		}
		public List<BopContext> bop() {
			return getRuleContexts(BopContext.class);
		}
		public BopContext bop(int i) {
			return getRuleContext(BopContext.class,i);
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
			int _alt;
			enterOuterAlt(_localctx, 1);
			{

					Program p = new Program(name);
					p.ass = new Assert("exists");
				
			setState(49);
			_la = _input.LA(1);
			if ( !(_la==T__0 || _la==T__1) ) {
			_errHandler.recoverInline(this);
			}
			else {
				if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
				_errHandler.reportMatch(this);
				consume();
			}
			setState(53);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__0) | (1L << T__3) | (1L << T__4) | (1L << T__5) | (1L << T__8) | (1L << T__9) | (1L << T__12) | (1L << T__13) | (1L << T__14) | (1L << T__15) | (1L << T__16) | (1L << T__17) | (1L << T__18) | (1L << T__19) | (1L << T__20) | (1L << T__21) | (1L << T__22) | (1L << T__23) | (1L << T__24) | (1L << T__25) | (1L << T__26) | (1L << T__27) | (1L << T__28) | (1L << T__29) | (1L << T__30) | (1L << T__31) | (1L << T__32) | (1L << T__33) | (1L << T__34) | (1L << T__35) | (1L << T__36) | (1L << T__37) | (1L << T__38) | (1L << T__39) | (1L << T__40) | (1L << T__41) | (1L << T__42) | (1L << T__43) | (1L << T__44) | (1L << T__45) | (1L << T__46) | (1L << T__47) | (1L << T__48) | (1L << T__49) | (1L << T__50) | (1L << T__51) | (1L << T__52) | (1L << T__53) | (1L << T__54) | (1L << T__55) | (1L << T__56) | (1L << T__57) | (1L << T__58))) != 0) || ((((_la - 74)) & ~0x3f) == 0 && ((1L << (_la - 74)) & ((1L << (LETTER - 74)) | (1L << (DIGIT - 74)) | (1L << (SYMBOL - 74)) | (1L << (LWSYNC - 74)) | (1L << (SYNC - 74)) | (1L << (ISYNC - 74)))) != 0)) {
				{
				{
				setState(50);
				text();
				}
				}
				setState(55);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(56);
			match(T__2);
			setState(82); 
			_errHandler.sync(this);
			_la = _input.LA(1);
			do {
				{
				setState(82);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,3,_ctx) ) {
				case 1:
					{
					setState(57);
					((ProgramContext)_localctx).l = location();
					setState(58);
					match(T__3);
					setState(59);
					match(DIGIT);
					setState(60);
					match(T__4);
					mapLocs.put(((ProgramContext)_localctx).l.loc.getName(), ((ProgramContext)_localctx).l.loc);
					}
					break;
				case 2:
					{
					setState(66);
					_errHandler.sync(this);
					_la = _input.LA(1);
					while (_la==LETTER) {
						{
						{
						setState(63);
						match(LETTER);
						}
						}
						setState(68);
						_errHandler.sync(this);
						_la = _input.LA(1);
					}
					setState(69);
					((ProgramContext)_localctx).thrd = match(DIGIT);
					setState(70);
					match(T__5);
					setState(71);
					((ProgramContext)_localctx).r = registerPower();
					setState(72);
					match(T__3);
					setState(78);
					_errHandler.sync(this);
					switch (_input.LA(1)) {
					case LETTER:
						{
						setState(73);
						((ProgramContext)_localctx).l = location();

									if(!mapRegLoc.keySet().contains(((ProgramContext)_localctx).thrd.getText())) {
										mapRegLoc.put(((ProgramContext)_localctx).thrd.getText(), new HashMap<String, Location>());
									}
									if(!mapLoc.keySet().contains(((ProgramContext)_localctx).l.loc.getName())) {
										mapLoc.put(((ProgramContext)_localctx).l.loc.getName(), ((ProgramContext)_localctx).l.loc);
									}
									mapRegLoc.get(((ProgramContext)_localctx).thrd.getText()).put(((ProgramContext)_localctx).r.reg.getName(), mapLoc.get(((ProgramContext)_localctx).l.loc.getName()));
								
						}
						break;
					case DIGIT:
						{
						setState(76);
						((ProgramContext)_localctx).d = match(DIGIT);

									Register regPointer = ((ProgramContext)_localctx).r.reg;
									if(!mapRegs.keySet().contains(((ProgramContext)_localctx).thrd.getText())) {
										mapRegs.put(((ProgramContext)_localctx).thrd.getText(), new HashMap<String, Register>());
									}
									mapRegs.get(((ProgramContext)_localctx).thrd.getText()).put(regPointer.getName(), regPointer);
									if(!mapThreads.keySet().contains(((ProgramContext)_localctx).thrd.getText())) {
										mapThreads.put(((ProgramContext)_localctx).thrd.getText(), new ArrayList<Thread>());
									}
									mapThreads.get(((ProgramContext)_localctx).thrd.getText()).add(new Local(regPointer, new AConst(Integer.parseInt(((ProgramContext)_localctx).d.getText()))));
								
						}
						break;
					default:
						throw new NoViableAltException(this);
					}
					setState(80);
					match(T__4);
					}
					break;
				}
				}
				setState(84); 
				_errHandler.sync(this);
				_la = _input.LA(1);
			} while ( _la==LETTER || _la==DIGIT );
			setState(86);
			match(T__6);
			setState(87);
			((ProgramContext)_localctx).threadsList = threads();

					for(Thread t : ((ProgramContext)_localctx).threadsList.lst) {
						p.add(t);
					}
					((ProgramContext)_localctx).p =  p;
				
			setState(92);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__0) | (1L << T__3) | (1L << T__4) | (1L << T__5) | (1L << T__8) | (1L << T__9) | (1L << T__12) | (1L << T__13) | (1L << T__14) | (1L << T__15) | (1L << T__16) | (1L << T__17) | (1L << T__18) | (1L << T__19) | (1L << T__20) | (1L << T__21) | (1L << T__22) | (1L << T__23) | (1L << T__24) | (1L << T__25) | (1L << T__26) | (1L << T__27) | (1L << T__28) | (1L << T__29) | (1L << T__30) | (1L << T__31) | (1L << T__32) | (1L << T__33) | (1L << T__34) | (1L << T__35) | (1L << T__36) | (1L << T__37) | (1L << T__38) | (1L << T__39) | (1L << T__40) | (1L << T__41) | (1L << T__42) | (1L << T__43) | (1L << T__44) | (1L << T__45) | (1L << T__46) | (1L << T__47) | (1L << T__48) | (1L << T__49) | (1L << T__50) | (1L << T__51) | (1L << T__52) | (1L << T__53) | (1L << T__54) | (1L << T__55) | (1L << T__56) | (1L << T__57) | (1L << T__58))) != 0) || ((((_la - 74)) & ~0x3f) == 0 && ((1L << (_la - 74)) & ((1L << (LETTER - 74)) | (1L << (DIGIT - 74)) | (1L << (SYMBOL - 74)) | (1L << (LWSYNC - 74)) | (1L << (SYNC - 74)) | (1L << (ISYNC - 74)))) != 0)) {
				{
				{
				setState(89);
				text();
				}
				}
				setState(94);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(156);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==T__7 || _la==MONIO) {
				{
				{
				setState(99);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while (_la==MONIO) {
					{
					{
					setState(95);
					match(MONIO);
					p.ass.existsQuery = false;
					}
					}
					setState(101);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				setState(102);
				match(T__7);
				setState(106);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while (_la==T__8) {
					{
					{
					setState(103);
					match(T__8);
					}
					}
					setState(108);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				setState(121);
				_errHandler.sync(this);
				switch (_input.LA(1)) {
				case LETTER:
					{
					setState(109);
					((ProgramContext)_localctx).l = location();
					setState(110);
					match(T__3);
					setState(111);
					((ProgramContext)_localctx).value = match(DIGIT);

							Location loc = ((ProgramContext)_localctx).l.loc;
							p.ass.addPair(loc, Integer.parseInt(((ProgramContext)_localctx).value.getText()));
						
					}
					break;
				case DIGIT:
					{
					setState(114);
					((ProgramContext)_localctx).thrd = match(DIGIT);
					setState(115);
					match(T__5);
					setState(116);
					((ProgramContext)_localctx).r = registerPower();
					setState(117);
					match(T__3);
					setState(118);
					((ProgramContext)_localctx).value = match(DIGIT);

							Register regPointer = ((ProgramContext)_localctx).r.reg;
							Register reg = mapRegs.get(((ProgramContext)_localctx).thrd.getText()).get(regPointer.getName());
							p.ass.addPair(reg, Integer.parseInt(((ProgramContext)_localctx).value.getText()));
						
					}
					break;
				default:
					throw new NoViableAltException(this);
				}
				setState(139);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while (_la==T__10 || _la==T__11) {
					{
					setState(137);
					_errHandler.sync(this);
					switch ( getInterpreter().adaptivePredict(_input,9,_ctx) ) {
					case 1:
						{
						setState(123);
						bop();
						setState(124);
						((ProgramContext)_localctx).l = location();
						setState(125);
						match(T__3);
						setState(126);
						((ProgramContext)_localctx).value = match(DIGIT);

								Location loc2 = ((ProgramContext)_localctx).l.loc;
								p.ass.addPair(loc2, Integer.parseInt(((ProgramContext)_localctx).value.getText()));	
							
						}
						break;
					case 2:
						{
						setState(129);
						bop();
						setState(130);
						((ProgramContext)_localctx).thrd = match(DIGIT);
						setState(131);
						match(T__5);
						setState(132);
						((ProgramContext)_localctx).r = registerPower();
						setState(133);
						match(T__3);
						setState(134);
						((ProgramContext)_localctx).value = match(DIGIT);

								Register regPointer2 = ((ProgramContext)_localctx).r.reg;
								Register reg2 = mapRegs.get(((ProgramContext)_localctx).thrd.getText()).get(regPointer2.getName());
								p.ass.addPair(reg2, Integer.parseInt(((ProgramContext)_localctx).value.getText()));	
							
						}
						break;
					}
					}
					setState(141);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				setState(145);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,11,_ctx);
				while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
					if ( _alt==1 ) {
						{
						{
						setState(142);
						match(T__9);
						}
						} 
					}
					setState(147);
					_errHandler.sync(this);
					_alt = getInterpreter().adaptivePredict(_input,11,_ctx);
				}
				setState(151);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__0) | (1L << T__3) | (1L << T__4) | (1L << T__5) | (1L << T__8) | (1L << T__9) | (1L << T__12) | (1L << T__13) | (1L << T__14) | (1L << T__15) | (1L << T__16) | (1L << T__17) | (1L << T__18) | (1L << T__19) | (1L << T__20) | (1L << T__21) | (1L << T__22) | (1L << T__23) | (1L << T__24) | (1L << T__25) | (1L << T__26) | (1L << T__27) | (1L << T__28) | (1L << T__29) | (1L << T__30) | (1L << T__31) | (1L << T__32) | (1L << T__33) | (1L << T__34) | (1L << T__35) | (1L << T__36) | (1L << T__37) | (1L << T__38) | (1L << T__39) | (1L << T__40) | (1L << T__41) | (1L << T__42) | (1L << T__43) | (1L << T__44) | (1L << T__45) | (1L << T__46) | (1L << T__47) | (1L << T__48) | (1L << T__49) | (1L << T__50) | (1L << T__51) | (1L << T__52) | (1L << T__53) | (1L << T__54) | (1L << T__55) | (1L << T__56) | (1L << T__57) | (1L << T__58))) != 0) || ((((_la - 74)) & ~0x3f) == 0 && ((1L << (_la - 74)) & ((1L << (LETTER - 74)) | (1L << (DIGIT - 74)) | (1L << (SYMBOL - 74)) | (1L << (LWSYNC - 74)) | (1L << (SYNC - 74)) | (1L << (ISYNC - 74)))) != 0)) {
					{
					{
					setState(148);
					text();
					}
					}
					setState(153);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				}
				}
				setState(158);
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
		enterRule(_localctx, 2, RULE_bop);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(159);
			_la = _input.LA(1);
			if ( !(_la==T__10 || _la==T__11) ) {
			_errHandler.recoverInline(this);
			}
			else {
				if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
				_errHandler.reportMatch(this);
				consume();
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

	public static class TextContext extends ParserRuleContext {
		public List<TerminalNode> SYMBOL() { return getTokens(LitmusParser.SYMBOL); }
		public TerminalNode SYMBOL(int i) {
			return getToken(LitmusParser.SYMBOL, i);
		}
		public List<TerminalNode> LETTER() { return getTokens(LitmusParser.LETTER); }
		public TerminalNode LETTER(int i) {
			return getToken(LitmusParser.LETTER, i);
		}
		public List<TerminalNode> DIGIT() { return getTokens(LitmusParser.DIGIT); }
		public TerminalNode DIGIT(int i) {
			return getToken(LitmusParser.DIGIT, i);
		}
		public TextContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_text; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).enterText(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).exitText(this);
		}
	}

	public final TextContext text() throws RecognitionException {
		TextContext _localctx = new TextContext(_ctx, getState());
		enterRule(_localctx, 4, RULE_text);
		int _la;
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(162); 
			_errHandler.sync(this);
			_alt = 1;
			do {
				switch (_alt) {
				case 1:
					{
					{
					setState(161);
					_la = _input.LA(1);
					if ( !((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__0) | (1L << T__3) | (1L << T__4) | (1L << T__5) | (1L << T__8) | (1L << T__9) | (1L << T__12) | (1L << T__13) | (1L << T__14) | (1L << T__15) | (1L << T__16) | (1L << T__17) | (1L << T__18) | (1L << T__19) | (1L << T__20) | (1L << T__21) | (1L << T__22) | (1L << T__23) | (1L << T__24) | (1L << T__25) | (1L << T__26) | (1L << T__27) | (1L << T__28) | (1L << T__29) | (1L << T__30) | (1L << T__31) | (1L << T__32) | (1L << T__33) | (1L << T__34) | (1L << T__35) | (1L << T__36) | (1L << T__37) | (1L << T__38) | (1L << T__39) | (1L << T__40) | (1L << T__41) | (1L << T__42) | (1L << T__43) | (1L << T__44) | (1L << T__45) | (1L << T__46) | (1L << T__47) | (1L << T__48) | (1L << T__49) | (1L << T__50) | (1L << T__51) | (1L << T__52) | (1L << T__53) | (1L << T__54) | (1L << T__55) | (1L << T__56) | (1L << T__57) | (1L << T__58))) != 0) || ((((_la - 74)) & ~0x3f) == 0 && ((1L << (_la - 74)) & ((1L << (LETTER - 74)) | (1L << (DIGIT - 74)) | (1L << (SYMBOL - 74)) | (1L << (LWSYNC - 74)) | (1L << (SYNC - 74)) | (1L << (ISYNC - 74)))) != 0)) ) {
					_errHandler.recoverInline(this);
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
				setState(164); 
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,14,_ctx);
			} while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER );
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
		enterRule(_localctx, 6, RULE_word);
		int _la;
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(167); 
			_errHandler.sync(this);
			_alt = 1;
			do {
				switch (_alt) {
				case 1:
					{
					{
					setState(166);
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
				setState(169); 
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,15,_ctx);
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
		enterRule(_localctx, 8, RULE_location);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(173);
			((LocationContext)_localctx).l = match(LETTER);
			setState(177);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==LETTER || _la==DIGIT) {
				{
				{
				setState(174);
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
				setState(179);
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
		enterRule(_localctx, 10, RULE_locationX86);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(182);
			match(T__22);
			setState(183);
			((LocationX86Context)_localctx).l = location();
			setState(184);
			match(T__23);
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
		enterRule(_localctx, 12, RULE_registerPower);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(187);
			((RegisterPowerContext)_localctx).r = _input.LT(1);
			_la = _input.LA(1);
			if ( !((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__40) | (1L << T__41) | (1L << T__42) | (1L << T__43) | (1L << T__44) | (1L << T__45) | (1L << T__46) | (1L << T__47) | (1L << T__48) | (1L << T__49) | (1L << T__50) | (1L << T__51) | (1L << T__52) | (1L << T__53) | (1L << T__54))) != 0)) ) {
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
		enterRule(_localctx, 14, RULE_registerX86);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(190);
			((RegisterX86Context)_localctx).r = _input.LT(1);
			_la = _input.LA(1);
			if ( !((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__55) | (1L << T__56) | (1L << T__57) | (1L << T__58))) != 0)) ) {
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
		enterRule(_localctx, 16, RULE_threads);
		int _la;
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(201); 
			_errHandler.sync(this);
			_la = _input.LA(1);
			do {
				{
				{
				setState(193);
				((ThreadsContext)_localctx).mainThread = word();

						if(!mapRegs.keySet().contains(((ThreadsContext)_localctx).mainThread.str)) {
							mapRegs.put(((ThreadsContext)_localctx).mainThread.str, new HashMap<String, Register>());
						}
					
				setState(198);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while (_la==T__25) {
					{
					{
					setState(195);
					match(T__25);
					}
					}
					setState(200);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				}
				}
				setState(203); 
				_errHandler.sync(this);
				_la = _input.LA(1);
			} while ( _la==LETTER || _la==DIGIT );
			setState(205);
			match(T__4);
			Integer thread = 0;
			setState(224); 
			_errHandler.sync(this);
			_alt = 1;
			do {
				switch (_alt) {
				case 1:
					{
					{
					setState(207);
					((ThreadsContext)_localctx).t1 = inst(thread.toString());

							if(!mapThreads.keySet().contains(thread.toString())) {
									mapThreads.put(thread.toString(), new ArrayList<Thread>());
							}
							mapThreads.get(thread.toString()).add(((ThreadsContext)_localctx).t1.t);
						
					setState(218);
					_errHandler.sync(this);
					_la = _input.LA(1);
					while (_la==T__25) {
						{
						{
						thread ++;
						setState(210);
						match(T__25);
						setState(213);
						_errHandler.sync(this);
						switch (_input.LA(1)) {
						case T__4:
						case T__12:
						case T__25:
						case T__59:
						case T__60:
						case T__61:
						case T__63:
						case T__64:
						case T__65:
						case T__66:
						case T__67:
						case T__68:
						case T__69:
						case LWSYNC:
						case SYNC:
						case ISYNC:
							{
							setState(211);
							((ThreadsContext)_localctx).t2 = inst(thread.toString());
							}
							break;
						case WS:
							{
							setState(212);
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
						setState(220);
						_errHandler.sync(this);
						_la = _input.LA(1);
					}
					setState(221);
					match(T__4);
					thread = 0;
					}
					}
					break;
				default:
					throw new NoViableAltException(this);
				}
				setState(226); 
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,21,_ctx);
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
		public StoreX86Context t3;
		public MfenceContext t4;
		public LocalPowerContext t5;
		public LoadPowerContext t6;
		public StorePowerContext t7;
		public IsyncContext t8;
		public SyncContext t9;
		public LwsyncContext t10;
		public XorContext t11;
		public AddiContext t12;
		public MrContext t13;
		public CmpwContext t14;
		public LocalX86Context localX86() {
			return getRuleContext(LocalX86Context.class,0);
		}
		public LoadX86Context loadX86() {
			return getRuleContext(LoadX86Context.class,0);
		}
		public StoreX86Context storeX86() {
			return getRuleContext(StoreX86Context.class,0);
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
		enterRule(_localctx, 18, RULE_inst);
		try {
			setState(280);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,22,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				}
				break;
			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(231);
				((InstContext)_localctx).t1 = localX86(mainThread);
				((InstContext)_localctx).t =  ((InstContext)_localctx).t1.t;
				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(234);
				((InstContext)_localctx).t2 = loadX86(mainThread);
				((InstContext)_localctx).t =  ((InstContext)_localctx).t2.t;
				}
				break;
			case 4:
				enterOuterAlt(_localctx, 4);
				{
				setState(237);
				((InstContext)_localctx).t3 = storeX86(mainThread);
				((InstContext)_localctx).t =  ((InstContext)_localctx).t3.t;
				}
				break;
			case 5:
				enterOuterAlt(_localctx, 5);
				{
				setState(240);
				((InstContext)_localctx).t4 = mfence();
				((InstContext)_localctx).t =  ((InstContext)_localctx).t4.t;
				}
				break;
			case 6:
				enterOuterAlt(_localctx, 6);
				{
				setState(243);
				((InstContext)_localctx).t5 = localPower(mainThread);
				((InstContext)_localctx).t =  ((InstContext)_localctx).t5.t;
				}
				break;
			case 7:
				enterOuterAlt(_localctx, 7);
				{
				setState(246);
				((InstContext)_localctx).t6 = loadPower(mainThread);
				((InstContext)_localctx).t =  ((InstContext)_localctx).t6.t;
				}
				break;
			case 8:
				enterOuterAlt(_localctx, 8);
				{
				setState(249);
				((InstContext)_localctx).t7 = storePower(mainThread);
				((InstContext)_localctx).t =  ((InstContext)_localctx).t7.t;
				}
				break;
			case 9:
				enterOuterAlt(_localctx, 9);
				{
				setState(252);
				((InstContext)_localctx).t8 = isync();
				((InstContext)_localctx).t =  ((InstContext)_localctx).t8.t;
				}
				break;
			case 10:
				enterOuterAlt(_localctx, 10);
				{
				setState(255);
				((InstContext)_localctx).t9 = sync();
				((InstContext)_localctx).t =  ((InstContext)_localctx).t9.t;
				}
				break;
			case 11:
				enterOuterAlt(_localctx, 11);
				{
				setState(258);
				((InstContext)_localctx).t10 = lwsync();
				((InstContext)_localctx).t =  ((InstContext)_localctx).t10.t;
				}
				break;
			case 12:
				enterOuterAlt(_localctx, 12);
				{
				setState(261);
				((InstContext)_localctx).t11 = xor(mainThread);
				((InstContext)_localctx).t =  ((InstContext)_localctx).t11.t;
				}
				break;
			case 13:
				enterOuterAlt(_localctx, 13);
				{
				setState(264);
				((InstContext)_localctx).t12 = addi(mainThread);
				((InstContext)_localctx).t =  ((InstContext)_localctx).t12.t;
				}
				break;
			case 14:
				enterOuterAlt(_localctx, 14);
				{
				setState(267);
				((InstContext)_localctx).t13 = mr(mainThread);
				((InstContext)_localctx).t =  ((InstContext)_localctx).t13.t;
				}
				break;
			case 15:
				enterOuterAlt(_localctx, 15);
				{
				setState(270);
				((InstContext)_localctx).t14 = cmpw(mainThread);
				((InstContext)_localctx).t =  ((InstContext)_localctx).t14.t;
				}
				break;
			case 16:
				enterOuterAlt(_localctx, 16);
				{
				setState(273);
				match(T__59);
				setState(274);
				match(T__60);
				setState(275);
				word();
				}
				break;
			case 17:
				enterOuterAlt(_localctx, 17);
				{
				setState(276);
				match(T__60);
				setState(277);
				word();
				setState(278);
				match(T__5);
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
		enterRule(_localctx, 20, RULE_localX86);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(282);
			match(T__61);
			setState(283);
			((LocalX86Context)_localctx).r = registerX86();
			setState(284);
			match(T__62);
			setState(285);
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
		enterRule(_localctx, 22, RULE_localPower);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(288);
			match(T__12);
			setState(289);
			((LocalPowerContext)_localctx).r = registerPower();
			setState(290);
			match(T__33);
			setState(291);
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
		enterRule(_localctx, 24, RULE_xor);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(294);
			match(T__63);
			setState(295);
			((XorContext)_localctx).r1 = registerPower();
			setState(296);
			match(T__33);
			setState(297);
			((XorContext)_localctx).r2 = registerPower();
			setState(298);
			match(T__33);
			setState(299);
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
		enterRule(_localctx, 26, RULE_addi);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(302);
			match(T__64);
			setState(303);
			((AddiContext)_localctx).r1 = registerPower();
			setState(304);
			match(T__33);
			setState(305);
			((AddiContext)_localctx).r2 = registerPower();
			setState(306);
			match(T__33);
			setState(307);
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
		enterRule(_localctx, 28, RULE_mr);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(310);
			match(T__65);
			setState(311);
			((MrContext)_localctx).r1 = registerPower();
			setState(312);
			match(T__33);
			setState(313);
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
		enterRule(_localctx, 30, RULE_loadX86);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(316);
			match(T__61);
			setState(317);
			((LoadX86Context)_localctx).r = registerX86();
			setState(318);
			match(T__33);
			setState(319);
			((LoadX86Context)_localctx).l = locationX86();

					Map<String, Register> mapThreadRegs = mapRegs.get(mainThread);
					if(!(mapThreadRegs.keySet().contains(((LoadX86Context)_localctx).r.reg.getName()))) {
						mapThreadRegs.put(((LoadX86Context)_localctx).r.reg.getName(), ((LoadX86Context)_localctx).r.reg);
					}
					if(!(mapLocs.keySet().contains(((LoadX86Context)_localctx).l.loc.getName()))) {
						System.out.println(String.format("Location %s must be initialized", ((LoadX86Context)_localctx).l.loc.getName()));
					}
					Register pointerReg = mapThreadRegs.get(((LoadX86Context)_localctx).r.reg.getName());
					Location pointerLoc = mapLocs.get(((LoadX86Context)_localctx).l.loc.getName());
					((LoadX86Context)_localctx).t =  new Load(pointerReg, pointerLoc);
				
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
		public RegisterPowerContext rl;
		public List<RegisterPowerContext> registerPower() {
			return getRuleContexts(RegisterPowerContext.class);
		}
		public RegisterPowerContext registerPower(int i) {
			return getRuleContext(RegisterPowerContext.class,i);
		}
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
		enterRule(_localctx, 32, RULE_loadPower);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(322);
			match(T__66);
			setState(323);
			((LoadPowerContext)_localctx).r = registerPower();
			setState(324);
			match(T__13);
			setState(325);
			_la = _input.LA(1);
			if ( !(_la==T__8 || _la==T__33) ) {
			_errHandler.recoverInline(this);
			}
			else {
				if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
				_errHandler.reportMatch(this);
				consume();
			}
			setState(326);
			((LoadPowerContext)_localctx).rl = registerPower();
			setState(330);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==T__9) {
				{
				{
				setState(327);
				match(T__9);
				}
				}
				setState(332);
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
					((LoadPowerContext)_localctx).t =  new Load(pointerReg, pointerLoc);
				
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

	public static class StoreX86Context extends ParserRuleContext {
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
		public StoreX86Context(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public StoreX86Context(ParserRuleContext parent, int invokingState, String mainThread) {
			super(parent, invokingState);
			this.mainThread = mainThread;
		}
		@Override public int getRuleIndex() { return RULE_storeX86; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).enterStoreX86(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof LitmusListener ) ((LitmusListener)listener).exitStoreX86(this);
		}
	}

	public final StoreX86Context storeX86(String mainThread) throws RecognitionException {
		StoreX86Context _localctx = new StoreX86Context(_ctx, getState(), mainThread);
		enterRule(_localctx, 34, RULE_storeX86);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(335);
			match(T__61);
			setState(336);
			((StoreX86Context)_localctx).l = locationX86();
			setState(337);
			match(T__33);
			setState(338);
			((StoreX86Context)_localctx).r = registerX86();

					if(!(mapLocs.keySet().contains(((StoreX86Context)_localctx).l.loc.getName()))) {
						System.out.println(String.format("Location %s must be initialized", ((StoreX86Context)_localctx).l.loc.getName()));
					}
					Map<String, Register> mapThreadRegs = mapRegs.get(mainThread);
					if(!(mapThreadRegs.keySet().contains(((StoreX86Context)_localctx).r.reg.getName()))) {
						System.out.println(String.format("Register %s must be initialized", ((StoreX86Context)_localctx).r.reg.getName()));
					}
					Register pointerReg = mapThreadRegs.get(((StoreX86Context)_localctx).r.reg.getName());
					Location pointerLoc = mapLocs.get(((StoreX86Context)_localctx).l.loc.getName());
					((StoreX86Context)_localctx).t =  new Store(pointerLoc, pointerReg);
				
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
		public RegisterPowerContext rl;
		public List<RegisterPowerContext> registerPower() {
			return getRuleContexts(RegisterPowerContext.class);
		}
		public RegisterPowerContext registerPower(int i) {
			return getRuleContext(RegisterPowerContext.class,i);
		}
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
		enterRule(_localctx, 36, RULE_storePower);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(341);
			match(T__67);
			setState(342);
			((StorePowerContext)_localctx).r = registerPower();
			setState(343);
			match(T__13);
			setState(344);
			_la = _input.LA(1);
			if ( !(_la==T__8 || _la==T__33) ) {
			_errHandler.recoverInline(this);
			}
			else {
				if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
				_errHandler.reportMatch(this);
				consume();
			}
			setState(345);
			((StorePowerContext)_localctx).rl = registerPower();
			setState(349);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==T__9) {
				{
				{
				setState(346);
				match(T__9);
				}
				}
				setState(351);
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
					((StorePowerContext)_localctx).t =  new Store(pointerLoc, pointerReg);
				
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
		enterRule(_localctx, 38, RULE_cmpw);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(354);
			match(T__68);
			setState(355);
			((CmpwContext)_localctx).r1 = registerPower();
			setState(356);
			match(T__33);
			setState(357);
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
		enterRule(_localctx, 40, RULE_mfence);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(360);
			match(T__69);
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
		enterRule(_localctx, 42, RULE_lwsync);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(363);
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
		enterRule(_localctx, 44, RULE_sync);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(366);
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
		enterRule(_localctx, 46, RULE_isync);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(369);
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
		"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\3S\u0177\4\2\t\2\4"+
		"\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4\t\t\t\4\n\t\n\4\13\t"+
		"\13\4\f\t\f\4\r\t\r\4\16\t\16\4\17\t\17\4\20\t\20\4\21\t\21\4\22\t\22"+
		"\4\23\t\23\4\24\t\24\4\25\t\25\4\26\t\26\4\27\t\27\4\30\t\30\4\31\t\31"+
		"\3\2\3\2\3\2\7\2\66\n\2\f\2\16\29\13\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2"+
		"\7\2C\n\2\f\2\16\2F\13\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\5\2Q\n\2"+
		"\3\2\3\2\6\2U\n\2\r\2\16\2V\3\2\3\2\3\2\3\2\7\2]\n\2\f\2\16\2`\13\2\3"+
		"\2\3\2\7\2d\n\2\f\2\16\2g\13\2\3\2\3\2\7\2k\n\2\f\2\16\2n\13\2\3\2\3\2"+
		"\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\5\2|\n\2\3\2\3\2\3\2\3\2\3\2"+
		"\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\2\7\2\u008c\n\2\f\2\16\2\u008f\13\2"+
		"\3\2\7\2\u0092\n\2\f\2\16\2\u0095\13\2\3\2\7\2\u0098\n\2\f\2\16\2\u009b"+
		"\13\2\7\2\u009d\n\2\f\2\16\2\u00a0\13\2\3\3\3\3\3\4\6\4\u00a5\n\4\r\4"+
		"\16\4\u00a6\3\5\6\5\u00aa\n\5\r\5\16\5\u00ab\3\5\3\5\3\6\3\6\7\6\u00b2"+
		"\n\6\f\6\16\6\u00b5\13\6\3\6\3\6\3\7\3\7\3\7\3\7\3\7\3\b\3\b\3\b\3\t\3"+
		"\t\3\t\3\n\3\n\3\n\7\n\u00c7\n\n\f\n\16\n\u00ca\13\n\6\n\u00cc\n\n\r\n"+
		"\16\n\u00cd\3\n\3\n\3\n\3\n\3\n\3\n\3\n\3\n\5\n\u00d8\n\n\3\n\7\n\u00db"+
		"\n\n\f\n\16\n\u00de\13\n\3\n\3\n\3\n\6\n\u00e3\n\n\r\n\16\n\u00e4\3\n"+
		"\3\n\3\13\3\13\3\13\3\13\3\13\3\13\3\13\3\13\3\13\3\13\3\13\3\13\3\13"+
		"\3\13\3\13\3\13\3\13\3\13\3\13\3\13\3\13\3\13\3\13\3\13\3\13\3\13\3\13"+
		"\3\13\3\13\3\13\3\13\3\13\3\13\3\13\3\13\3\13\3\13\3\13\3\13\3\13\3\13"+
		"\3\13\3\13\3\13\3\13\3\13\3\13\3\13\3\13\3\13\5\13\u011b\n\13\3\f\3\f"+
		"\3\f\3\f\3\f\3\f\3\r\3\r\3\r\3\r\3\r\3\r\3\16\3\16\3\16\3\16\3\16\3\16"+
		"\3\16\3\16\3\17\3\17\3\17\3\17\3\17\3\17\3\17\3\17\3\20\3\20\3\20\3\20"+
		"\3\20\3\20\3\21\3\21\3\21\3\21\3\21\3\21\3\22\3\22\3\22\3\22\3\22\3\22"+
		"\7\22\u014b\n\22\f\22\16\22\u014e\13\22\3\22\3\22\3\23\3\23\3\23\3\23"+
		"\3\23\3\23\3\24\3\24\3\24\3\24\3\24\3\24\7\24\u015e\n\24\f\24\16\24\u0161"+
		"\13\24\3\24\3\24\3\25\3\25\3\25\3\25\3\25\3\25\3\26\3\26\3\26\3\27\3\27"+
		"\3\27\3\30\3\30\3\30\3\31\3\31\3\31\3\31\2\2\32\2\4\6\b\n\f\16\20\22\24"+
		"\26\30\32\34\36 \"$&(*,.\60\2\t\3\2\3\4\3\2\r\16\t\2\3\3\6\b\13\f\17="+
		"LMOOQS\3\2LM\3\2+9\3\2:=\4\2\13\13$$\2\u0186\2\62\3\2\2\2\4\u00a1\3\2"+
		"\2\2\6\u00a4\3\2\2\2\b\u00a9\3\2\2\2\n\u00af\3\2\2\2\f\u00b8\3\2\2\2\16"+
		"\u00bd\3\2\2\2\20\u00c0\3\2\2\2\22\u00cb\3\2\2\2\24\u011a\3\2\2\2\26\u011c"+
		"\3\2\2\2\30\u0122\3\2\2\2\32\u0128\3\2\2\2\34\u0130\3\2\2\2\36\u0138\3"+
		"\2\2\2 \u013e\3\2\2\2\"\u0144\3\2\2\2$\u0151\3\2\2\2&\u0157\3\2\2\2(\u0164"+
		"\3\2\2\2*\u016a\3\2\2\2,\u016d\3\2\2\2.\u0170\3\2\2\2\60\u0173\3\2\2\2"+
		"\62\63\b\2\1\2\63\67\t\2\2\2\64\66\5\6\4\2\65\64\3\2\2\2\669\3\2\2\2\67"+
		"\65\3\2\2\2\678\3\2\2\28:\3\2\2\29\67\3\2\2\2:T\7\5\2\2;<\5\n\6\2<=\7"+
		"\6\2\2=>\7M\2\2>?\7\7\2\2?@\b\2\1\2@U\3\2\2\2AC\7L\2\2BA\3\2\2\2CF\3\2"+
		"\2\2DB\3\2\2\2DE\3\2\2\2EG\3\2\2\2FD\3\2\2\2GH\7M\2\2HI\7\b\2\2IJ\5\16"+
		"\b\2JP\7\6\2\2KL\5\n\6\2LM\b\2\1\2MQ\3\2\2\2NO\7M\2\2OQ\b\2\1\2PK\3\2"+
		"\2\2PN\3\2\2\2QR\3\2\2\2RS\7\7\2\2SU\3\2\2\2T;\3\2\2\2TD\3\2\2\2UV\3\2"+
		"\2\2VT\3\2\2\2VW\3\2\2\2WX\3\2\2\2XY\7\t\2\2YZ\5\22\n\2Z^\b\2\1\2[]\5"+
		"\6\4\2\\[\3\2\2\2]`\3\2\2\2^\\\3\2\2\2^_\3\2\2\2_\u009e\3\2\2\2`^\3\2"+
		"\2\2ab\7N\2\2bd\b\2\1\2ca\3\2\2\2dg\3\2\2\2ec\3\2\2\2ef\3\2\2\2fh\3\2"+
		"\2\2ge\3\2\2\2hl\7\n\2\2ik\7\13\2\2ji\3\2\2\2kn\3\2\2\2lj\3\2\2\2lm\3"+
		"\2\2\2m{\3\2\2\2nl\3\2\2\2op\5\n\6\2pq\7\6\2\2qr\7M\2\2rs\b\2\1\2s|\3"+
		"\2\2\2tu\7M\2\2uv\7\b\2\2vw\5\16\b\2wx\7\6\2\2xy\7M\2\2yz\b\2\1\2z|\3"+
		"\2\2\2{o\3\2\2\2{t\3\2\2\2|\u008d\3\2\2\2}~\5\4\3\2~\177\5\n\6\2\177\u0080"+
		"\7\6\2\2\u0080\u0081\7M\2\2\u0081\u0082\b\2\1\2\u0082\u008c\3\2\2\2\u0083"+
		"\u0084\5\4\3\2\u0084\u0085\7M\2\2\u0085\u0086\7\b\2\2\u0086\u0087\5\16"+
		"\b\2\u0087\u0088\7\6\2\2\u0088\u0089\7M\2\2\u0089\u008a\b\2\1\2\u008a"+
		"\u008c\3\2\2\2\u008b}\3\2\2\2\u008b\u0083\3\2\2\2\u008c\u008f\3\2\2\2"+
		"\u008d\u008b\3\2\2\2\u008d\u008e\3\2\2\2\u008e\u0093\3\2\2\2\u008f\u008d"+
		"\3\2\2\2\u0090\u0092\7\f\2\2\u0091\u0090\3\2\2\2\u0092\u0095\3\2\2\2\u0093"+
		"\u0091\3\2\2\2\u0093\u0094\3\2\2\2\u0094\u0099\3\2\2\2\u0095\u0093\3\2"+
		"\2\2\u0096\u0098\5\6\4\2\u0097\u0096\3\2\2\2\u0098\u009b\3\2\2\2\u0099"+
		"\u0097\3\2\2\2\u0099\u009a\3\2\2\2\u009a\u009d\3\2\2\2\u009b\u0099\3\2"+
		"\2\2\u009ce\3\2\2\2\u009d\u00a0\3\2\2\2\u009e\u009c\3\2\2\2\u009e\u009f"+
		"\3\2\2\2\u009f\3\3\2\2\2\u00a0\u009e\3\2\2\2\u00a1\u00a2\t\3\2\2\u00a2"+
		"\5\3\2\2\2\u00a3\u00a5\t\4\2\2\u00a4\u00a3\3\2\2\2\u00a5\u00a6\3\2\2\2"+
		"\u00a6\u00a4\3\2\2\2\u00a6\u00a7\3\2\2\2\u00a7\7\3\2\2\2\u00a8\u00aa\t"+
		"\5\2\2\u00a9\u00a8\3\2\2\2\u00aa\u00ab\3\2\2\2\u00ab\u00a9\3\2\2\2\u00ab"+
		"\u00ac\3\2\2\2\u00ac\u00ad\3\2\2\2\u00ad\u00ae\b\5\1\2\u00ae\t\3\2\2\2"+
		"\u00af\u00b3\7L\2\2\u00b0\u00b2\t\5\2\2\u00b1\u00b0\3\2\2\2\u00b2\u00b5"+
		"\3\2\2\2\u00b3\u00b1\3\2\2\2\u00b3\u00b4\3\2\2\2\u00b4\u00b6\3\2\2\2\u00b5"+
		"\u00b3\3\2\2\2\u00b6\u00b7\b\6\1\2\u00b7\13\3\2\2\2\u00b8\u00b9\7\31\2"+
		"\2\u00b9\u00ba\5\n\6\2\u00ba\u00bb\7\32\2\2\u00bb\u00bc\b\7\1\2\u00bc"+
		"\r\3\2\2\2\u00bd\u00be\t\6\2\2\u00be\u00bf\b\b\1\2\u00bf\17\3\2\2\2\u00c0"+
		"\u00c1\t\7\2\2\u00c1\u00c2\b\t\1\2\u00c2\21\3\2\2\2\u00c3\u00c4\5\b\5"+
		"\2\u00c4\u00c8\b\n\1\2\u00c5\u00c7\7\34\2\2\u00c6\u00c5\3\2\2\2\u00c7"+
		"\u00ca\3\2\2\2\u00c8\u00c6\3\2\2\2\u00c8\u00c9\3\2\2\2\u00c9\u00cc\3\2"+
		"\2\2\u00ca\u00c8\3\2\2\2\u00cb\u00c3\3\2\2\2\u00cc\u00cd\3\2\2\2\u00cd"+
		"\u00cb\3\2\2\2\u00cd\u00ce\3\2\2\2\u00ce\u00cf\3\2\2\2\u00cf\u00d0\7\7"+
		"\2\2\u00d0\u00e2\b\n\1\2\u00d1\u00d2\5\24\13\2\u00d2\u00dc\b\n\1\2\u00d3"+
		"\u00d4\b\n\1\2\u00d4\u00d7\7\34\2\2\u00d5\u00d8\5\24\13\2\u00d6\u00d8"+
		"\7P\2\2\u00d7\u00d5\3\2\2\2\u00d7\u00d6\3\2\2\2\u00d8\u00d9\3\2\2\2\u00d9"+
		"\u00db\b\n\1\2\u00da\u00d3\3\2\2\2\u00db\u00de\3\2\2\2\u00dc\u00da\3\2"+
		"\2\2\u00dc\u00dd\3\2\2\2\u00dd\u00df\3\2\2\2\u00de\u00dc\3\2\2\2\u00df"+
		"\u00e0\7\7\2\2\u00e0\u00e1\b\n\1\2\u00e1\u00e3\3\2\2\2\u00e2\u00d1\3\2"+
		"\2\2\u00e3\u00e4\3\2\2\2\u00e4\u00e2\3\2\2\2\u00e4\u00e5\3\2\2\2\u00e5"+
		"\u00e6\3\2\2\2\u00e6\u00e7\b\n\1\2\u00e7\23\3\2\2\2\u00e8\u011b\3\2\2"+
		"\2\u00e9\u00ea\5\26\f\2\u00ea\u00eb\b\13\1\2\u00eb\u011b\3\2\2\2\u00ec"+
		"\u00ed\5 \21\2\u00ed\u00ee\b\13\1\2\u00ee\u011b\3\2\2\2\u00ef\u00f0\5"+
		"$\23\2\u00f0\u00f1\b\13\1\2\u00f1\u011b\3\2\2\2\u00f2\u00f3\5*\26\2\u00f3"+
		"\u00f4\b\13\1\2\u00f4\u011b\3\2\2\2\u00f5\u00f6\5\30\r\2\u00f6\u00f7\b"+
		"\13\1\2\u00f7\u011b\3\2\2\2\u00f8\u00f9\5\"\22\2\u00f9\u00fa\b\13\1\2"+
		"\u00fa\u011b\3\2\2\2\u00fb\u00fc\5&\24\2\u00fc\u00fd\b\13\1\2\u00fd\u011b"+
		"\3\2\2\2\u00fe\u00ff\5\60\31\2\u00ff\u0100\b\13\1\2\u0100\u011b\3\2\2"+
		"\2\u0101\u0102\5.\30\2\u0102\u0103\b\13\1\2\u0103\u011b\3\2\2\2\u0104"+
		"\u0105\5,\27\2\u0105\u0106\b\13\1\2\u0106\u011b\3\2\2\2\u0107\u0108\5"+
		"\32\16\2\u0108\u0109\b\13\1\2\u0109\u011b\3\2\2\2\u010a\u010b\5\34\17"+
		"\2\u010b\u010c\b\13\1\2\u010c\u011b\3\2\2\2\u010d\u010e\5\36\20\2\u010e"+
		"\u010f\b\13\1\2\u010f\u011b\3\2\2\2\u0110\u0111\5(\25\2\u0111\u0112\b"+
		"\13\1\2\u0112\u011b\3\2\2\2\u0113\u0114\7>\2\2\u0114\u0115\7?\2\2\u0115"+
		"\u011b\5\b\5\2\u0116\u0117\7?\2\2\u0117\u0118\5\b\5\2\u0118\u0119\7\b"+
		"\2\2\u0119\u011b\3\2\2\2\u011a\u00e8\3\2\2\2\u011a\u00e9\3\2\2\2\u011a"+
		"\u00ec\3\2\2\2\u011a\u00ef\3\2\2\2\u011a\u00f2\3\2\2\2\u011a\u00f5\3\2"+
		"\2\2\u011a\u00f8\3\2\2\2\u011a\u00fb\3\2\2\2\u011a\u00fe\3\2\2\2\u011a"+
		"\u0101\3\2\2\2\u011a\u0104\3\2\2\2\u011a\u0107\3\2\2\2\u011a\u010a\3\2"+
		"\2\2\u011a\u010d\3\2\2\2\u011a\u0110\3\2\2\2\u011a\u0113\3\2\2\2\u011a"+
		"\u0116\3\2\2\2\u011b\25\3\2\2\2\u011c\u011d\7@\2\2\u011d\u011e\5\20\t"+
		"\2\u011e\u011f\7A\2\2\u011f\u0120\7M\2\2\u0120\u0121\b\f\1\2\u0121\27"+
		"\3\2\2\2\u0122\u0123\7\17\2\2\u0123\u0124\5\16\b\2\u0124\u0125\7$\2\2"+
		"\u0125\u0126\7M\2\2\u0126\u0127\b\r\1\2\u0127\31\3\2\2\2\u0128\u0129\7"+
		"B\2\2\u0129\u012a\5\16\b\2\u012a\u012b\7$\2\2\u012b\u012c\5\16\b\2\u012c"+
		"\u012d\7$\2\2\u012d\u012e\5\16\b\2\u012e\u012f\b\16\1\2\u012f\33\3\2\2"+
		"\2\u0130\u0131\7C\2\2\u0131\u0132\5\16\b\2\u0132\u0133\7$\2\2\u0133\u0134"+
		"\5\16\b\2\u0134\u0135\7$\2\2\u0135\u0136\7M\2\2\u0136\u0137\b\17\1\2\u0137"+
		"\35\3\2\2\2\u0138\u0139\7D\2\2\u0139\u013a\5\16\b\2\u013a\u013b\7$\2\2"+
		"\u013b\u013c\5\16\b\2\u013c\u013d\b\20\1\2\u013d\37\3\2\2\2\u013e\u013f"+
		"\7@\2\2\u013f\u0140\5\20\t\2\u0140\u0141\7$\2\2\u0141\u0142\5\f\7\2\u0142"+
		"\u0143\b\21\1\2\u0143!\3\2\2\2\u0144\u0145\7E\2\2\u0145\u0146\5\16\b\2"+
		"\u0146\u0147\7\20\2\2\u0147\u0148\t\b\2\2\u0148\u014c\5\16\b\2\u0149\u014b"+
		"\7\f\2\2\u014a\u0149\3\2\2\2\u014b\u014e\3\2\2\2\u014c\u014a\3\2\2\2\u014c"+
		"\u014d\3\2\2\2\u014d\u014f\3\2\2\2\u014e\u014c\3\2\2\2\u014f\u0150\b\22"+
		"\1\2\u0150#\3\2\2\2\u0151\u0152\7@\2\2\u0152\u0153\5\f\7\2\u0153\u0154"+
		"\7$\2\2\u0154\u0155\5\20\t\2\u0155\u0156\b\23\1\2\u0156%\3\2\2\2\u0157"+
		"\u0158\7F\2\2\u0158\u0159\5\16\b\2\u0159\u015a\7\20\2\2\u015a\u015b\t"+
		"\b\2\2\u015b\u015f\5\16\b\2\u015c\u015e\7\f\2\2\u015d\u015c\3\2\2\2\u015e"+
		"\u0161\3\2\2\2\u015f\u015d\3\2\2\2\u015f\u0160\3\2\2\2\u0160\u0162\3\2"+
		"\2\2\u0161\u015f\3\2\2\2\u0162\u0163\b\24\1\2\u0163\'\3\2\2\2\u0164\u0165"+
		"\7G\2\2\u0165\u0166\5\16\b\2\u0166\u0167\7$\2\2\u0167\u0168\5\16\b\2\u0168"+
		"\u0169\b\25\1\2\u0169)\3\2\2\2\u016a\u016b\7H\2\2\u016b\u016c\b\26\1\2"+
		"\u016c+\3\2\2\2\u016d\u016e\7Q\2\2\u016e\u016f\b\27\1\2\u016f-\3\2\2\2"+
		"\u0170\u0171\7R\2\2\u0171\u0172\b\30\1\2\u0172/\3\2\2\2\u0173\u0174\7"+
		"S\2\2\u0174\u0175\b\31\1\2\u0175\61\3\2\2\2\33\67DPTV^el{\u008b\u008d"+
		"\u0093\u0099\u009e\u00a6\u00ab\u00b3\u00c8\u00cd\u00d7\u00dc\u00e4\u011a"+
		"\u014c\u015f";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}